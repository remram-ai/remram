# CLI

The Moltbox CLI is the normal operator control surface for the appliance.

Canonical grammar:

```text
moltbox <resource> <command>
```

The CLI is resource-oriented. Top-level namespaces represent operator-facing resources rather than internal software layers.

## Command Map

```text
moltbox
  gateway
    status
    update
    logs
    mcp-stdio
    docker ping
    docker run <image>
    token create <NAME>
    token list
    token delete <NAME>
    token rotate <NAME>
    service deploy <service>
    service restart <service>
    service status <service>

  dev
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill list
    skill remove <skill>
    plugin install <package>
    plugin list
    plugin remove <plugin>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  test
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill list
    skill remove <skill>
    plugin install <package>
    plugin list
    plugin remove <plugin>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  prod
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill list
    skill remove <skill>
    plugin install <package>
    plugin list
    plugin remove <plugin>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  service
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  ollama
    <native ollama command>

  opensearch
    <native opensearch command>

  caddy
    <native caddy command>
```

## Resource Groups

Gateway:

```text
moltbox --version
moltbox gateway status
moltbox gateway update
moltbox gateway logs
moltbox gateway mcp-stdio
moltbox gateway docker ping
moltbox gateway docker run hello-world
moltbox gateway service deploy opensearch
moltbox gateway token create search-agent
```

`moltbox gateway update` is the appliance self-update path. It refreshes the gateway and the host `moltbox` CLI/tooling together, writes the control-plane deployment record to `/srv/moltbox-state/deploy/history.jsonl`, and appends a host-level self-update record to `/var/lib/moltbox/history.jsonl`. There is no separate active `tools update` command.

Gateway self-mutation goes through `moltbox gateway update` only. `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` are intentionally rejected so the control plane is not redeployed in place under the initiating request.

Workstation operators and automation reach the CLI over SSH. Internal agents use the token-authenticated MCP HTTP endpoint instead of SSH.

`moltbox gateway token ...` manages bearer tokens for the internal gateway MCP HTTP surface only.

OpenClaw dashboard access uses the environment passthrough surface instead:

```text
moltbox dev openclaw dashboard --no-open
moltbox dev openclaw devices list --json
moltbox dev openclaw devices approve <requestId> --json
```

Use the same `openclaw dashboard --no-open` and `openclaw devices ...` flow under `test` and `prod` when approving dashboard pairing requests.

Runtime environments:

```text
moltbox dev reload
moltbox test checkpoint
moltbox dev skill deploy together
moltbox dev skill list
moltbox dev skill remove together
moltbox dev plugin install moltbox-telemetry
moltbox dev plugin list
moltbox dev plugin remove moltbox-telemetry
moltbox prod openclaw <command>
moltbox dev secrets set TOGETHER_API_KEY "tgp_v1_..."
```

`moltbox <env> skill deploy <skill>` is the managed skill deploy path on `main`, but it currently stages pure skill packages only. Plugin-backed packages are not yet supported by the managed skill deploy path.

Scoped secrets:

```text
moltbox dev secrets list
moltbox test secrets set TOGETHER_API_KEY "tgp_v1_..."
moltbox prod secrets delete TOGETHER_API_KEY
moltbox service secrets set POSTGRES_PASSWORD "super-secret"
```

Native service passthrough:

```text
moltbox ollama <native command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

## Operational Rules

- use the CLI as the normal control surface
- use `dev`, `test`, and `prod` for runtime operations
- use `dev`, `test`, `prod`, and `service` as the valid scopes for `moltbox <scope> secrets ...`
- use `gateway service ...` for appliance deployment and service lifecycle work
- use `gateway update` for gateway self-mutation; `gateway service deploy|restart gateway` is intentionally rejected
- use `gateway service deploy dev|test|prod` when redeploying runtime containers through the control plane
- scoped secrets follow `CLI -> gateway -> encrypted secret store`
- secrets are gateway-owned appliance state stored locally under `/var/lib/moltbox/secrets/<scope>/`
- secrets are encrypted at rest and injected into container environments during gateway-managed deploy or reload
- gateway MCP bearer tokens are also stored in the encrypted appliance secret store and managed through `moltbox gateway token ...`
- use native service passthrough namespaces instead of reimplementing service-specific commands in Moltbox
- treat Docker commands as internal implementation details

`moltbox gateway service restart <service>` uses the deploy lifecycle and waits for health before it reports success.

## Internal Mapping

The CLI uses environment names:

- `dev`
- `test`
- `prod`

Those map internally to runtime service identities such as:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

Those internal runtime names are implementation identities, not operator-facing CLI namespaces.

## Retired Namespaces

The following namespaces are retired:

- `runtime`
- top-level `service`
- top-level `skill`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `tools`
- `host`

Legacy commands should fail rather than redirect.

Exception:

- `moltbox service secrets ...` is valid because `service` acts as a secret scope, not as the retired lifecycle namespace

## See Also

- [CLI Architecture](../overview/cli-architecture.md)
- [Operator Workflow](operator-workflow.md)
- [CLI Reference](../../reference/cli-reference.md)
