# 2026-03-14 Moltbox Mainline Audit

## Scope

- audited `remram` on `main` as the architecture and documentation hub
- reconciled the current gateway implementation checkout and the live appliance behavior against the documented CLI and platform model
- did not read or modify `D:\Development\RemRam\remram-plugin`

## Resolved In This Pass

- normalized the public CLI docs to the resource-oriented grammar `moltbox <resource> <command>`
- kept singular `moltbox <env> skill ...` as the canonical managed skill surface
- documented `moltbox <env> skill deploy|list|remove` and removed `skill rollback` from the public contract
- documented the live gateway helper surfaces: `gateway mcp-stdio`, `gateway docker ping`, and `gateway docker run <image>`
- documented gateway self-update provenance as two ledgers:
- `/srv/moltbox-state/deploy/history.jsonl` for control-plane deployment history
- `/var/lib/moltbox/history.jsonl` for host-level appliance self-update history
- corrected snapshot language to match the implemented checkpoint-backed runtime baseline model
- marked `discord-channel` and `moltbox-telemetry` as `Status: in flight` rather than presenting them as shipped
- added the repeatable CLI validation script at `scripts/validate-moltbox-cli.ps1`

## CLI Coverage

| Command family | Current repo status | Live appliance status on 2026-03-14 | Notes |
| --- | --- | --- | --- |
| `gateway status` | Implemented | Works | Spot-checked over SSH |
| `gateway update` | Implemented | Surface present, not executed | Repo main now records control-plane history and appends `/var/lib/moltbox/history.jsonl`; live host does not yet have that ledger |
| `gateway logs` | Implemented | Not rechecked | Documented and wired in repo main |
| `gateway mcp-stdio` | Implemented | Surface present | EOF smoke check returned `0`; full tool exchange not re-run on the live host in this pass |
| `gateway docker ping` | Implemented | Works | Spot-checked over SSH |
| `gateway docker run <image>` | Implemented | Surface present | Not exercised live in this pass |
| `gateway service deploy|restart|status` | Implemented | Not rechecked | Public contract aligned in docs |
| `dev|test|prod reload` | Implemented | Not rechecked | Public contract aligned in docs |
| `dev|test|prod checkpoint` | Implemented | Not rechecked | Public contract aligned in docs |
| `dev|test|prod skill deploy` | Implemented | Surface present | Live help still shows the older `deploy|rollback` pair |
| `dev|test|prod skill list` | Implemented | Missing | Live host returns `parse_error` |
| `dev|test|prod skill remove` | Implemented | Missing | Live host returns `parse_error` |
| `dev|test|prod plugin install|list|remove` | Implemented | Missing | `moltbox dev plugin list` returns `parse_error` on the live host |
| `dev|test|prod openclaw <command>` | Implemented | Not rechecked | Native passthrough remains part of the repo contract |
| `dev|test|prod|service secrets set|list|delete` | Implemented | Not rechecked | Gateway-owned secret path |
| `ollama|opensearch|caddy <native command>` | Implemented | Not rechecked | Native service passthrough |

Notes:

- `moltbox <env> skill rollback <skill>` remains a compatibility alias in the current repo implementation, but it is no longer part of the documented public contract
- no active documented public command family is stubbed in the current repo implementation
- the remaining intentional CLI limitation is that managed `skill deploy` only stages pure skill packages on `main`

## Live Appliance Drift

Spot checks on 2026-03-14 show the live appliance is behind the repo contract:

- `ssh moltbox "moltbox --help"` still advertises `skill rollback` and does not advertise `skill list`, `skill remove`, or the env-scoped `plugin` family
- `ssh moltbox "moltbox dev skill list"` returns `parse_error`
- `ssh moltbox "moltbox dev skill remove together"` returns `parse_error`
- `ssh moltbox "moltbox dev plugin list"` returns `parse_error`
- `ssh moltbox "test -s /var/lib/moltbox/history.jsonl && echo present || echo missing"` returned `missing`

The live appliance therefore does not yet match the updated repo and docs contract.

## Remaining Gaps Requiring A Decision Or Later Implementation

- Release tagging enforcement: the documented contract is `main = next release` and `appliance = tagged release`, but `moltbox gateway update` still applies whatever revision the configured host checkout points at. Recommendation: either add explicit tag selection to gateway update or require release appliances to pin host checkouts to the intended tag.
- Managed plugin-backed skill deploy: the architecture allows plugin-backed skills as a packaging concept, but `moltbox <env> skill deploy` on `main` stages pure skill packages only. Recommendation: keep this explicit until a separate contract is implemented.
- Discord Channel: architecture is defined, but runtime templates, gateway render inputs, package source wiring, and on-box behavior are still incomplete.
- Moltbox Telemetry: telemetry contract is defined, but the plugin package and runtime integration are still incomplete.
- Standalone runtime snapshots: the implemented durable capture is checkpoint snapshotting under `runtime-baselines`; a separate `/srv/moltbox-state/runtime-snapshots/` contract is still in flight.

## TODO / Unfinished Sweep

Remaining documentation TODOs outside the CLI/gateway cleanup are:

- `reference/endpoints.md`
- `platform/services/caddy/spec.md`
- `platform/services/caddy/operator-guide.md`
- `platform/services/ollama/spec.md`
- `platform/services/ollama/operator-guide.md`
- `platform/services/opensearch/spec.md`
- `platform/services/opensearch/operator-guide.md`

Code sweep results:

- no live `phase1` or placeholder handler paths remain in the current gateway implementation outside archived material
- `skill rollback` survives only as a compatibility alias path, not as the public contract

Validation limits in this pass:

- local `go` and `docker` binaries were not available in this workspace, so the gateway repo changes were not compiled or unit-tested locally
- `scripts/validate-moltbox-cli.ps1` passed a PowerShell parser check locally
- live appliance validation was limited to SSH spot checks because the appliance is behind the repo contract
