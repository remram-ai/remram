# CLI Contract Audit

Date: 2026-03-15

Target appliance:

- SSH target: `moltbox` (`192.168.1.189`)
- Live gateway repo checkout: `3770e9ee0d69e49cd3e3670224e1c6380d553ee3`
- Live gateway branch: `greenfield/moltbox-go-bootstrap`

## Executive Summary

This audit covered the Moltbox CLI end to end across:

- Remram documentation and reference material as the contract baseline
- the `moltbox-gateway` implementation and live host checkout
- live execution on the gateway appliance over SSH
- gateway-owned state under `/srv/moltbox-state` and `/var/lib/moltbox`
- restricted SSH wrapper accounts

The public CLI surface is aligned with the documented contract after remediation and retest. The documented namespaces exist, the core operator flows work live, the gateway/service/runtime/secrets surfaces are reachable under the documented names, the wrapper namespaces route correctly for safe status/info checks, and the self-update and deployment provenance paths now reconcile with live state.

The audit started with two real provenance defects and one unsafe documented gateway self-deploy example. All three were fixed in `moltbox-gateway`, deployed to the appliance, and retested live.

## Coverage Summary

Namespaces tested:

- `gateway`
- `dev`
- `test`
- `prod`
- `service`
- `ollama`
- `opensearch`
- `caddy`
- retired namespaces: `runtime`, `host`, `tools`, `openclaw-dev`

Validation buckets:

- Full validation: 54 command invocations across parser behavior, gateway lifecycle, service lifecycle, runtime lifecycle, checkpoint/replay, secrets, tokens, and SSH wrapper policy
- Wrapper validation: 15 command invocations across OpenClaw passthrough, native service passthrough, and MCP safe endpoint checks

Result counts:

- Pass: 69
- Partial: 0
- Fail with root cause unresolved: 0

Safety boundaries used in this pass:

- full stateful lifecycle validation ran on `dev`
- shared-service mutation was limited to `opensearch`, `caddy`, and `gateway update`
- `test` and `prod` were validated through read-only and safe wrapper checks only to avoid mutating non-dev runtime state

## Command Validation Matrix

### Root And Parser Contract

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox --help` | print documented command tree | matched documented namespaces and command families | live `moltbox --help` showed `gateway`, `dev|test|prod`, `service`, `ollama`, `opensearch`, `caddy` | Pass |
| `moltbox --version` | print CLI version | returned `moltbox 0.1.0-dev` | docs were updated in this pass to include it explicitly | Pass |
| `moltbox runtime reload` | fail as retired namespace | returned `retired_namespace` | explicit JSON failure, no redirect | Pass |
| `moltbox host status` | fail as retired namespace | returned `retired_namespace` | explicit JSON failure, no redirect | Pass |
| `moltbox tools update` | fail as retired namespace | returned `retired_namespace` | explicit JSON failure, no redirect | Pass |
| `moltbox openclaw-dev reload` | fail as retired namespace | returned `retired_namespace` | explicit JSON failure, no redirect | Pass |
| `moltbox service deploy opensearch` | fail because top-level `service` is only valid for secrets | returned `retired_namespace` with secrets-only guidance | correct exception handling for `service secrets ...` | Pass |

### Gateway And Service Pipeline

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox gateway status` | return control-plane status JSON | returned healthy gateway payload | included `service`, `version`, `listen_address`, `docker_socket` | Pass |
| `moltbox gateway logs` | return gateway diagnostics surface | returned structured JSON with `docker logs` command output | initially empty earlier in the pass, later returned MCP and secrets activity lines as expected | Pass |
| `moltbox gateway docker ping` | prove Docker reachability | returned Docker version info | live result included `docker_version=29.3.0` | Pass |
| `moltbox gateway docker run hello-world` | launch safe helper container | returned container id/name | cleanup succeeded after run | Pass |
| `moltbox gateway service status gateway` | report service/container health | healthy | container `gateway`, image `moltbox-gateway:latest`, health `healthy` | Pass |
| `moltbox gateway service status caddy` | report service/container health | healthy | container `caddy`, image `caddy:2.8.4`, health `healthy` | Pass |
| `moltbox gateway service status opensearch` | report service/container health | healthy | container `opensearch`, image `moltbox-opensearch:local`, health `healthy` | Pass |
| `moltbox gateway service status ollama` | report service/container health | healthy | container `ollama`, image `ollama/ollama:latest`, health `healthy` | Pass |
| `moltbox gateway service status dev` | report runtime container health via public env name | healthy | mapped correctly to `openclaw-dev` | Pass |
| `moltbox gateway service status test` | report runtime container health via public env name | healthy | mapped correctly to `openclaw-test` | Pass |
| `moltbox gateway service status prod` | report runtime container health via public env name | healthy | mapped correctly to `openclaw-prod` | Pass |
| `moltbox gateway service deploy opensearch` | redeploy shared service and record reconciled metadata | service redeployed successfully and deployment record matched the running artifact | running image remained `moltbox-opensearch:local`; deployment history now records `moltbox-opensearch:local` | Pass |
| `moltbox gateway service restart caddy` | reconcile through deploy lifecycle and wait for health | service restarted successfully and deployment record matched the running artifact | running image remained `caddy:2.8.4`; deployment history now records `caddy:2.8.4` | Pass |
| `moltbox gateway service deploy gateway` | fail explicitly and point operators to the canonical self-update path | returned structured `service_deploy_failed` guidance without destabilizing the gateway | recovery message: `gateway service deploy gateway is not supported; use 'moltbox gateway update'` | Pass |
| `moltbox gateway service restart gateway` | fail explicitly and point operators to the canonical self-update path | returned structured `service_restart_failed` guidance without destabilizing the gateway | recovery message: `gateway service restart gateway is not supported; use 'moltbox gateway update'` | Pass |
| `moltbox gateway service deploy dev` | redeploy runtime via gateway pipeline and replay state | succeeded before and after checkpoint | correctly moved runtime image from old checkpoint tag to new checkpoint tag after `dev checkpoint` | Pass |

### Gateway Tokens, MCP, And SSH Automation

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox gateway token create <temp>` | mint bearer token once | returned token value once | token name appeared in list and worked against `/mcp` | Pass |
| `moltbox gateway token list` | list names only | returned names without values | empty after deletion and cleanup | Pass |
| `moltbox gateway token rotate <temp>` | revoke old token and issue new token | old token rejected, new token authorized | verified with live HTTP POST to `http://127.0.0.1:7460/mcp` | Pass |
| `moltbox gateway token delete <temp>` | revoke token and remove access | deleted token and subsequent MCP auth failed | also cleaned a stale leaked token secret from an earlier run when deleted by name | Pass |
| unauthenticated `POST /mcp` | reject access | returned `401 unauthorized` | JSON error payload matched contract | Pass |
| authenticated `POST /mcp` | return valid MCP response | returned `200` and tool list | tools included `moltbox_help` and `moltbox_run` | Pass |
| `moltbox gateway mcp-stdio` | expose MCP stdio server | returned valid tool list | live tool exchange succeeded | Pass |
| `ssh -i ~/.ssh/jason-codex jason-codex@... "moltbox gateway status"` | allow CLI-only automation path | succeeded | returned normal gateway status JSON | Pass |
| `ssh -i ~/.ssh/jason-codex jason-codex@... "uname -a"` | deny non-CLI commands | denied with exit `126` | message: `automation access denied: only moltbox commands are allowed` | Pass |
| `ssh -i ~/.ssh/codex-bootstrap codex-bootstrap@... "moltbox gateway logs"` | allow diagnostic gateway access | succeeded | matched wrapper policy | Pass |
| `ssh -i ~/.ssh/codex-bootstrap codex-bootstrap@... "moltbox dev openclaw health --json"` | allow full `dev` CLI access | succeeded | matched wrapper policy | Pass |
| `ssh -i ~/.ssh/codex-bootstrap codex-bootstrap@... "moltbox gateway update"` | deny mutating gateway access | denied with exit `126` | message matched wrapper policy | Pass |
| `ssh -i ~/.ssh/codex-bootstrap codex-bootstrap@... "moltbox test reload"` | deny non-dev mutation | denied with exit `126` | message matched wrapper policy | Pass |

### Runtime Lifecycle And Replay

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox dev reload` | redeploy `dev` runtime and wait for health | succeeded repeatedly | three immediate reload -> health cycles all passed | Pass |
| `moltbox dev openclaw health --json` | route native health check into runtime | succeeded | one transient failure was seen once during the sweep and could not be reproduced; direct gateway POST and repeated CLI runs all passed | Pass |
| `moltbox dev skill deploy <temp>` | stage replay package, append replay event, redeploy runtime | succeeded | deployment history recorded `runtime_skill_deploy`; temp skill appeared in `skill list` | Pass |
| `moltbox dev skill list` | report runtime-visible skill inventory | succeeded | returned managed skills plus bundled skills view from OpenClaw | Pass |
| `moltbox dev skill remove <temp>` | remove replay entry and redeploy runtime | succeeded | deployment history recorded `runtime_skill_remove`; temp skill disappeared | Pass |
| `moltbox dev plugin install /srv/.../moltbox-telemetry` | install gateway-managed plugin and record replay event | succeeded | deployment history recorded `runtime_plugin_install` | Pass |
| `moltbox dev plugin list` | report gateway-managed effective plugin inventory | succeeded | empty output matched effective state when baseline plugin was masked by replay remove events | Pass |
| `moltbox dev plugin remove moltbox-telemetry` | remove gateway-managed plugin and redeploy runtime | succeeded | deployment history recorded `runtime_plugin_remove` | Pass |
| `moltbox dev openclaw plugins list` | preserve native OpenClaw plugin inspection | succeeded | showed full stock/runtime plugin inventory | Pass |
| `moltbox dev openclaw skills list` | preserve native OpenClaw skill inspection | succeeded | showed runtime-visible skill table | Pass |
| `moltbox dev checkpoint` | capture runtime state, build new baseline image, clear replay log | succeeded | new checkpoint id `checkpoint-1773560745651180358`; replay log changed from 3 events to `[]`; runtime image changed to the new checkpoint tag | Pass |
| pre-checkpoint replay-sensitive state | baseline plus replay remove events should produce current runtime state | confirmed | before checkpoint, `current.json` still listed `moltbox-telemetry` in baseline while replay log carried remove events and `moltbox dev plugin list` returned no gateway-managed plugins | Pass |
| post-checkpoint replay-sensitive state | promoted baseline should match current runtime and replay log should reset | confirmed | after checkpoint, `current.json` no longer contained `moltbox-telemetry`, `baseline_checkpoint` advanced, and replay log was empty | Pass |
| `moltbox dev skill rollback cli-validation-1773529331` | compatibility alias should still route if present | routed to `remove` and failed because the target skill is checkpointed into baseline, not replay state | hidden compatibility alias is still reachable even though it is intentionally undocumented | Pass |

### Secrets

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox dev secrets set <temp> <value>` | store encrypted secret under gateway-owned scope | succeeded | created `/var/lib/moltbox/secrets/dev/<temp>.json` | Pass |
| `moltbox dev secrets list` | list names only | succeeded | listed the temp name and existing `TOGETHER_API_KEY`, no value exposure | Pass |
| `moltbox dev secrets delete <temp>` | delete stored secret | succeeded | file disappeared from the list afterward | Pass |
| `moltbox service secrets set <temp> <value>` | store shared-service secret under gateway-owned scope | succeeded | created `/var/lib/moltbox/secrets/service/<temp>.json` | Pass |
| `moltbox service secrets list` | list names only | succeeded | names only, no value exposure | Pass |
| `moltbox service secrets delete <temp>` | delete stored secret | succeeded | file disappeared from the list afterward | Pass |
| `moltbox test secrets list` | list scope contents without value exposure | succeeded | listed `TOGETHER_API_KEY` only | Pass |
| `moltbox prod secrets list` | list scope contents without value exposure | succeeded | returned an empty list | Pass |

### Test And Prod Read-Only Sweep

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox test skill list` | route skill list into `openclaw-test` | succeeded | returned runtime skill table | Pass |
| `moltbox prod skill list` | route skill list into `openclaw-prod` | succeeded | returned runtime skill table | Pass |
| `moltbox test plugin list` | return gateway-managed plugin inventory for `test` | succeeded | returned empty effective inventory | Pass |
| `moltbox prod plugin list` | return gateway-managed plugin inventory for `prod` | succeeded | returned empty effective inventory | Pass |
| `moltbox test openclaw health --json` | preserve native health passthrough | succeeded | returned health JSON | Pass |
| `moltbox prod openclaw health --json` | preserve native health passthrough | succeeded | returned health JSON | Pass |

### Native Service Passthrough

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox ollama list` | reach native Ollama CLI safely | succeeded | returned model inventory including `qwen3:8b` | Pass |
| `moltbox caddy version` | reach native Caddy CLI safely | succeeded | returned `v2.8.4` | Pass |
| `moltbox opensearch --version` | reach native OpenSearch CLI safely | succeeded | returned `Version: 2.18.0 ...` | Pass |

### Self-Update

| Command(s) tested | Expected behavior | Actual behavior | Evidence / notes | Result |
| --- | --- | --- | --- | --- |
| `moltbox gateway update` | refresh checkout/tooling safely, append both provenance ledgers, and preserve revision fidelity | succeeded after remediation | helper now marks the repo as a safe Git directory, gateway restarted healthy, deployment history reconciled, and `/var/lib/moltbox/history.jsonl` appended non-empty `old_version`, `new_version`, and remote `source` | Pass |

## Bug List

No open user-facing CLI bugs remained at audit close.

Resolved during this audit:

### CLI-001

- Severity: High
- Affected command(s): `moltbox gateway service deploy opensearch`, `moltbox gateway service restart caddy`, likely all non-runtime `gateway service deploy|restart` actions
- Reproduction before fix:
  1. Run `moltbox gateway service deploy opensearch`
  2. Inspect `moltbox gateway service status opensearch`
  3. Inspect `/srv/moltbox-state/deploy/history.jsonl`
- Expected behavior:
  - deployment metadata should reconcile with the running artifact identity
- Actual behavior before fix:
  - live service status reported `moltbox-opensearch:local`
  - deployment history recorded `artifact_version":"opensearch:latest"`
  - same drift occurred for Caddy: live image `caddy:2.8.4`, recorded `caddy:latest`
- Likely root cause:
  - `moltbox-gateway/internal/orchestrator/runtime_state.go` hard-coded non-runtime artifacts as `<service>:latest`
- Implemented fix:
  - deployment history now records the inspected running container image for non-runtime services
  - added regression coverage in `internal/orchestrator/manager_test.go`
  - retested live: `opensearch` now records `moltbox-opensearch:local`; `caddy` now records `caddy:2.8.4`

### CLI-002

- Severity: High
- Affected command(s): `moltbox gateway update`
- Reproduction before fix:
  1. Run `moltbox gateway update`
  2. Inspect `/srv/moltbox-state/deploy/history.jsonl`
  3. Inspect `/var/lib/moltbox/history.jsonl`
  4. Reproduce updater-container Git calls with `docker run --rm --entrypoint sh -v /srv/moltbox-state/upstream/moltbox-gateway:/src moltbox-gateway:latest -lc 'git -C /src rev-parse HEAD'`
- Expected behavior:
  - updater should be able to resolve the current Git revision, remote source, and fetch/pull status
  - host history should record non-empty `old_version`, `new_version`, and remote `source`
  - update should fail if it cannot inspect or refresh the configured repo
- Actual behavior before fix:
  - the CLI returned success and the gateway restarted
  - host history appended a record with `old_version:""`, `new_version:""`, and `source:"/srv/moltbox-state/upstream/moltbox-gateway"`
  - reproducing the updater-container Git calls returned `fatal: detected dubious ownership in repository at '/src'`
- Likely root cause:
  - the updater helper ran Git as `root` inside the helper container against a repo owned by `jpekovitch`
  - Git safe-directory protection blocked `remote get-url`, `rev-parse`, `fetch`, and `pull`
- Implemented fix:
  - updater helper now marks the checkout as a safe Git directory and requires a real Git checkout before proceeding
  - added regression coverage in `internal/orchestrator/manager_test.go`
  - retested live: `/var/lib/moltbox/history.jsonl` now records non-empty `old_version`, `new_version`, and `source:"https://github.com/remram-ai/moltbox-gateway.git"`

### CLI-003

- Severity: High
- Affected command(s): `moltbox gateway service deploy gateway`, `moltbox gateway service restart gateway`
- Reproduction before fix:
  1. Run `moltbox gateway service deploy gateway`
  2. Observe the initiating CLI lose contact with the control plane
- Expected behavior:
  - the CLI should not expose an in-place control-plane redeploy path that tears down its own request handler
  - operators should be directed to `moltbox gateway update`
- Actual behavior before fix:
  - the command destabilized the gateway request path and surfaced `gateway_unreachable`
- Likely root cause:
  - the generic service deploy lifecycle tried to mutate the running gateway container in place
- Implemented fix:
  - the gateway/orchestrator now rejects `gateway service deploy|restart gateway` explicitly and points operators to `moltbox gateway update`
  - retested live: both commands now return structured guidance and leave the gateway healthy

## Discrepancy List

- `moltbox <env> skill rollback <skill>` remains reachable as a compatibility alias even though the public docs intentionally retired it in favor of `skill remove`.
- Caddy and AI-topology docs previously implied `Internet -> Caddy -> Gateway / Runtime services` and a public control-plane ingress route. That contradicted `reference/endpoints.md` and the gateway docs. Those files were corrected in this pass.
- Operator workflow docs previously showed `moltbox gateway service deploy gateway`; those docs were corrected to use `moltbox gateway update`.

## Feedback List

- Deployment history should distinguish operator intent. `gateway service restart caddy` returns `action:"restart"` but appends `operation:"service_deploy"`, which weakens operator forensics even if the implementation intentionally reuses the deploy pipeline.
- Empty arrays are often omitted from JSON output. For example, `moltbox <env> plugin list` returns no `plugins` field when empty. A stable empty array would be easier for automation.
- Dev baseline state currently contains prior validation skills (`cli-validation-1773529331`, `cli-validation-debug`). That is not a contract violation by itself, but it shows why audit flows need a dedicated disposable runtime or stronger post-checkpoint cleanup rules.
- There is no documented managed CLI path to remove a skill once it has been promoted into the checkpoint baseline. The compatibility alias `skill rollback` also only operates on replay state.

## Troubleshooting Notes

To classify failures and partials, the audit inspected:

- live CLI responses over SSH as `jpekovitch`
- restricted wrapper behavior via `jason-codex` and `codex-bootstrap`
- direct gateway HTTP calls to `http://127.0.0.1:7460`
- direct container execution through `docker exec`
- gateway-owned state:
  - `/srv/moltbox-state/deploy/history.jsonl`
  - `/srv/moltbox-state/deploy/runtime/openclaw-dev/replay-log.json`
  - `/srv/moltbox-state/runtime-baselines/openclaw-dev/current.json`
  - `/var/lib/moltbox/history.jsonl`
  - `/var/lib/moltbox/secrets/`
- the live host checkout under `/srv/moltbox-state/upstream/moltbox-gateway`
- a fresh binary built from the live host checkout
- `go test ./...` executed inside `golang:1.23-bookworm` against the live host checkout
- `scripts/validate-moltbox-cli.ps1 -SshHost moltbox -Environment dev -IncludeGatewayUpdate`, which passed after remediation

Important investigation outcomes:

- a direct POST to `/runtime/openclaw` proved the gateway/runtime path was healthy when isolating one transient wrapper failure seen earlier in the pass
- the updater provenance defect was reproduced directly inside `moltbox-gateway:latest` with `git` safe-directory failures and then eliminated with a follow-up live self-update
- a live attempt to use `gateway service deploy gateway` demonstrated why gateway self-mutation needs the dedicated helper-based update path; after remediation the command failed explicitly instead of destabilizing the gateway
- a stale `MCP_TOKEN_cli-validation-1773529331.json` artifact was found under `/var/lib/moltbox/secrets/service` while `gateway token list` was empty; deleting the token name cleaned the leaked secret file

## Recommendations

- Add regression coverage for provenance reconciliation:
  - running image vs service status vs deployment record
  - deployment record vs host self-update ledger
- Keep the explicit rejection of `gateway service deploy|restart gateway` so the public surface cannot regress back to an in-place self-redeploy trap.
- Keep full mutation audits on `dev` or a dedicated disposable appliance unless `test` and `prod` are explicitly earmarked for destructive validation.
- Decide whether hidden compatibility surfaces such as `skill rollback` should remain reachable. If yes, document them as compatibility-only. If no, remove them.
- Add an explicit operational path for cleaning or replacing checkpoint-promoted validation artifacts, especially for skills promoted into a runtime baseline.
