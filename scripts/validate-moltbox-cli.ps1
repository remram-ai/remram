param(
    [string]$SshHost = "moltbox",
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment = "dev",
    [string]$BaseSkill = "together-escalation",
    [switch]$IncludeGatewayUpdate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$script:timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$script:tempSkillName = "cli-validation-$script:timestamp"
$script:tempSkillRoot = "/srv/moltbox-state/upstream/remram-skills/skills"
$script:tempSkillPath = "$script:tempSkillRoot/$script:tempSkillName"
$script:baseSkillPath = "$script:tempSkillRoot/$BaseSkill"
$script:tempTokenName = "cli-validation-$script:timestamp"
$script:dockerRunContainer = "hello-world"

$script:results = New-Object System.Collections.ArrayList
$script:tempSkillCreated = $false
$script:tempSkillDeployed = $false
$script:tempTokenCreated = $false

function Add-Result {
    param(
        [string]$Group,
        [string]$Command,
        [string]$Status,
        [string]$Details
    )

    [void]$script:results.Add([pscustomobject]@{
        Group   = $Group
        Command = $Command
        Status  = $Status
        Details = $Details
    })
}

function Quote-RemoteToken {
    param([string]$Value)

    return "'" + $Value.Replace("'", '''"''"''') + "'"
}

function Join-RemoteCommand {
    param([string[]]$Tokens)

    return ($Tokens | ForEach-Object { Quote-RemoteToken $_ }) -join " "
}

function Invoke-RemoteShell {
    param(
        [string]$Script,
        [switch]$AllowFailure
    )

    $output = & ssh $SshHost "sh -lc $(Quote-RemoteToken $Script)" 2>&1 | Out-String
    $exitCode = $LASTEXITCODE
    $trimmed = $output.TrimEnd("`r", "`n")

    if (-not $AllowFailure -and $exitCode -ne 0) {
        throw "remote command failed ($exitCode): $Script`n$trimmed"
    }

    return [pscustomobject]@{
        ExitCode = $exitCode
        Output   = $trimmed
    }
}

function Invoke-Moltbox {
    param(
        [string[]]$Args,
        [switch]$AllowFailure
    )

    return Invoke-RemoteShell -Script ("moltbox " + (Join-RemoteCommand $Args)) -AllowFailure:$AllowFailure
}

function Invoke-MoltboxJson {
    param(
        [string[]]$Args,
        [switch]$AllowFailure
    )

    $result = Invoke-Moltbox -Args $Args -AllowFailure:$AllowFailure
    $payload = $null
    if ($result.Output -ne "") {
        try {
            $payload = $result.Output | ConvertFrom-Json -Depth 32
        } catch {
            throw "failed to parse JSON for 'moltbox $($Args -join ' ')': $($result.Output)"
        }
    }

    if (-not $AllowFailure -and $null -ne $payload -and $payload.ok -eq $false) {
        throw "moltbox $($Args -join ' ') returned an error: $($result.Output)"
    }

    return [pscustomobject]@{
        ExitCode = $result.ExitCode
        Output   = $result.Output
        Json     = $payload
    }
}

function Invoke-McpStdioToolsList {
    $request = '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
    $prefix = "Content-Length: $([Text.Encoding]::UTF8.GetByteCount($request))`r`n`r`n"

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "ssh"
    $startInfo.Arguments = "$SshHost `"moltbox gateway mcp-stdio`""
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    [void]$process.Start()
    $process.StandardInput.Write($prefix + $request)
    $process.StandardInput.Close()

    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()

    if ($process.ExitCode -ne 0) {
        throw "gateway mcp-stdio failed ($($process.ExitCode)): $stderr"
    }

    $parts = $stdout -split "\r?\n\r?\n", 2
    if ($parts.Count -ne 2) {
        throw "unexpected mcp-stdio response: $stdout"
    }

    try {
        return ($parts[1] | ConvertFrom-Json -Depth 32)
    } catch {
        throw "failed to parse mcp-stdio body: $($parts[1])"
    }
}

function Wait-GatewayReady {
    param([int]$TimeoutSeconds = 90)

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            $status = Invoke-MoltboxJson -Args @("gateway", "status")
            if ($status.Json.ok -eq $true) {
                return
            }
        } catch {
        }
        Start-Sleep -Seconds 3
    }

    throw "gateway did not return to ready state within $TimeoutSeconds seconds"
}

function Run-Step {
    param(
        [string]$Group,
        [string]$Command,
        [scriptblock]$Action,
        [switch]$ContinueOnFailure
    )

    try {
        $details = & $Action
        if ($null -eq $details) {
            $details = ""
        }
        Add-Result -Group $Group -Command $Command -Status "PASS" -Details ([string]$details)
        return $true
    } catch {
        Add-Result -Group $Group -Command $Command -Status "FAIL" -Details $_.Exception.Message
        if (-not $ContinueOnFailure) {
            throw
        }
        return $false
    }
}

function Cleanup-State {
    Run-Step -Group "cleanup" -Command "skill remove $script:tempSkillName" -ContinueOnFailure -Action {
        if (-not $script:tempSkillDeployed) {
            return "no replay-installed temp skill to remove"
        }
        $remove = Invoke-MoltboxJson -Args @($Environment, "skill", "remove", $script:tempSkillName) -AllowFailure
        $script:tempSkillDeployed = $false
        return $remove.Output
    } | Out-Null

    Run-Step -Group "cleanup" -Command "remove temp skill package" -ContinueOnFailure -Action {
        if (-not $script:tempSkillCreated) {
            return "no temp skill package to delete"
        }
        Invoke-RemoteShell -Script "rm -rf $(Quote-RemoteToken $script:tempSkillPath)" | Out-Null
        $script:tempSkillCreated = $false
        return $script:tempSkillPath
    } | Out-Null

    Run-Step -Group "cleanup" -Command "gateway token delete $script:tempTokenName" -ContinueOnFailure -Action {
        if (-not $script:tempTokenCreated) {
            return "no temp token to delete"
        }
        Invoke-MoltboxJson -Args @("gateway", "token", "delete", $script:tempTokenName) -AllowFailure | Out-Null
        $script:tempTokenCreated = $false
        return $script:tempTokenName
    } | Out-Null

    Run-Step -Group "cleanup" -Command "docker rm -f $script:dockerRunContainer" -ContinueOnFailure -Action {
        Invoke-RemoteShell -Script "docker rm -f $(Quote-RemoteToken $script:dockerRunContainer) >/dev/null 2>&1 || true" | Out-Null
        return $script:dockerRunContainer
    } | Out-Null
}

try {
    Run-Step -Group "gateway" -Command "gateway status" -Action {
        $status = Invoke-MoltboxJson -Args @("gateway", "status")
        if ($status.Json.service -ne "gateway") {
            throw "unexpected gateway service payload: $($status.Output)"
        }
        return "version=$($status.Json.version)"
    } | Out-Null

    Run-Step -Group "gateway" -Command "gateway docker ping" -Action {
        $ping = Invoke-MoltboxJson -Args @("gateway", "docker", "ping")
        if ([string]::IsNullOrWhiteSpace([string]$ping.Json.docker_version)) {
            throw "docker version missing: $($ping.Output)"
        }
        return "docker_version=$($ping.Json.docker_version)"
    } | Out-Null

    Run-Step -Group "gateway" -Command "gateway docker run hello-world" -Action {
        $run = Invoke-MoltboxJson -Args @("gateway", "docker", "run", "hello-world")
        if ([string]::IsNullOrWhiteSpace([string]$run.Json.container_name)) {
            throw "container name missing: $($run.Output)"
        }
        return "container=$($run.Json.container_name)"
    } | Out-Null

    Run-Step -Group "gateway" -Command "gateway token create/list/delete" -Action {
        $create = Invoke-MoltboxJson -Args @("gateway", "token", "create", $script:tempTokenName)
        if ([string]::IsNullOrWhiteSpace([string]$create.Json.token)) {
            throw "token value missing: $($create.Output)"
        }
        $script:tempTokenCreated = $true

        $list = Invoke-MoltboxJson -Args @("gateway", "token", "list")
        $names = @($list.Json.tokens | ForEach-Object { $_.name })
        if ($names -notcontains $script:tempTokenName) {
            throw "temp token missing from list: $($list.Output)"
        }

        return "token=$script:tempTokenName"
    } | Out-Null

    Run-Step -Group "gateway" -Command "gateway mcp-stdio" -Action {
        $response = Invoke-McpStdioToolsList
        $tools = @($response.result.tools | ForEach-Object { $_.name })
        if ($tools -notcontains "moltbox_run") {
            throw "moltbox_run missing from mcp tools list"
        }
        return "tools=$($tools -join ',')"
    } | Out-Null

    if ($IncludeGatewayUpdate) {
        Run-Step -Group "gateway" -Command "gateway update" -Action {
            Invoke-MoltboxJson -Args @("gateway", "update") | Out-Null
            Wait-GatewayReady
            $historyCheck = Invoke-RemoteShell -Script "test -s /var/lib/moltbox/history.jsonl"
            if ($historyCheck.ExitCode -ne 0) {
                throw "gateway update did not leave a non-empty /var/lib/moltbox/history.jsonl"
            }
            return "update completed"
        } | Out-Null
    } else {
        Add-Result -Group "gateway" -Command "gateway update" -Status "SKIP" -Details "skipped by default; rerun with -IncludeGatewayUpdate for full self-update validation"
    }

    Run-Step -Group "skill" -Command "prepare temp skill package" -Action {
        Invoke-RemoteShell -Script "rm -rf $(Quote-RemoteToken $script:tempSkillPath)" | Out-Null
        $prepare = @(
            "set -eu",
            "cp -R $(Quote-RemoteToken $script:baseSkillPath) $(Quote-RemoteToken $script:tempSkillPath)",
            "sed -i '0,/^name: /s//name: $script:tempSkillName/' $(Quote-RemoteToken "$script:tempSkillPath/SKILL.md")"
        ) -join "; "
        Invoke-RemoteShell -Script $prepare | Out-Null
        $script:tempSkillCreated = $true
        return $script:tempSkillName
    } | Out-Null

    Run-Step -Group "skill" -Command "$Environment skill deploy $script:tempSkillName" -Action {
        $deploy = Invoke-MoltboxJson -Args @($Environment, "skill", "deploy", $script:tempSkillName)
        if ($deploy.Json.action -ne "deploy") {
            throw "unexpected deploy action payload: $($deploy.Output)"
        }
        $script:tempSkillDeployed = $true
        return "event=$($deploy.Json.event_id)"
    } | Out-Null

    Run-Step -Group "skill" -Command "$Environment skill list" -Action {
        $list = Invoke-MoltboxJson -Args @($Environment, "skill", "list")
        if ([string]$list.Json.stdout -notmatch [regex]::Escape($script:tempSkillName)) {
            throw "temp skill missing from skill list: $($list.Output)"
        }
        return "listed $script:tempSkillName"
    } | Out-Null

    Run-Step -Group "skill" -Command "$Environment skill remove $script:tempSkillName" -Action {
        $remove = Invoke-MoltboxJson -Args @($Environment, "skill", "remove", $script:tempSkillName)
        if ($remove.Json.action -ne "remove") {
            throw "unexpected remove action payload: $($remove.Output)"
        }
        $script:tempSkillDeployed = $false
        return "event=$($remove.Json.event_id)"
    } | Out-Null

    Run-Step -Group "skill" -Command "$Environment skill list (post-remove)" -Action {
        $list = Invoke-MoltboxJson -Args @($Environment, "skill", "list")
        if ([string]$list.Json.stdout -match [regex]::Escape($script:tempSkillName)) {
            throw "temp skill still present after remove: $($list.Output)"
        }
        return "temp skill absent"
    } | Out-Null
}
finally {
    Cleanup-State

    ""
    "CLI validation summary:"
    $script:results | Format-Table -AutoSize

    $failed = @($script:results | Where-Object { $_.Status -eq "FAIL" })
    if ($failed.Count -gt 0) {
        exit 1
    }
}
