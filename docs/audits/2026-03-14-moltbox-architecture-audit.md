# 2026-03-14 Moltbox Architecture Audit

This audit reconciles the RemRam documentation hub, the implementation repositories, and the live Moltbox appliance after the recent CLI rework.

## Scope

Repos and sources reviewed:

- `remram`
- `moltbox-gateway`
- `moltbox-runtime`
- `moltbox-services`
- `remram-skills`
- live appliance host `moltbox-prime`

Live appliance validation covered CLI help, gateway status and tokens, service status and restart, runtime skill deploy, OpenClaw passthrough, scoped secrets, retired namespaces, runtime and gateway health endpoints, and public ingress behavior.

## Direct Cleanup Applied

The obvious stale items were corrected directly:

- canonical docs now consistently describe the active resource-oriented CLI model
- environment-scoped managed skill lifecycle is documented under `moltbox <env> skill deploy|rollback <skill>`
- Caddy docs now match the live runtime-only ingress model and explicitly note that `moltbox-cli` returns `404`
- stale path references to `/srv/moltbox-state/runtime-snapshots/` were replaced or clarified to match the current checkpoint-backed `runtime-baselines` layout
- canonical CLI docs now include the live `gateway mcp-stdio` and `gateway docker ping|run` commands
- stale repo references and "phase 1 only" framing were removed from `moltbox-gateway` docs
- `remram-skills` now reflects the current repo model and the retained-but-inactive `semantic-router` package

## Alignment Summary

The main repo ownership boundaries are aligned in code:

- `remram` remains the architecture and platform registry hub
- `moltbox-gateway` owns the public CLI, control plane, deploy orchestration, scoped secrets, and MCP token management
- `moltbox-services` owns service definitions and compose inputs
- `moltbox-runtime` owns baseline runtime material
- `remram-skills` owns reusable skill and plugin packages

The live box matches the current public model on these points:

- public runtime namespaces are `dev`, `test`, and `prod`
- internal names like `openclaw-dev` are implementation details, not public CLI language
- retired namespaces such as `runtime`, top-level `skill`, `host`, and `tools` fail instead of redirecting
- service lifecycle flows through `moltbox gateway service ...`
- Caddy exposes the runtime hosts and does not proxy the public control plane
- gateway MCP requires bearer-token auth on the local/internal surface

## CLI Coverage

| Command family | Docs status | Local repo | Live box | Notes |
| --- | --- | --- | --- | --- |
| `gateway status`, `gateway logs` | documented | implemented | validated | aligned |
| `gateway update` | documented | implemented | not executed in this audit | deployment provenance gap, see findings |
| `gateway token create|list|delete|rotate` | documented | implemented | create/list/delete validated | `rotate` not executed during audit |
| `gateway service deploy|restart|status` | documented | implemented | `status` and `restart` validated | `deploy` also exercised indirectly by runtime redeploy paths |
| `gateway mcp-stdio` | now documented | implemented | not executed in this audit | real live command, previously undocumented in canonical docs |
| `gateway docker ping` | now documented | implemented | validated | real live command, previously undocumented in canonical docs |
| `gateway docker run <image>` | now documented | implemented | not executed in this audit | lower-level bootstrap/diagnostic surface |
| `<env> reload` | documented | implemented | not executed in this audit | current runtime deploy path uses the same orchestration layer |
| `<env> checkpoint` | documented | implemented | artifacts validated on-box | command itself was not re-run during the audit |
| `<env> skill deploy <skill>` | documented | implemented | validated | current public implementation is singular `skill` |
| `<env> skill rollback <skill>` | documented | implemented | not executed in this audit | code path is implemented |
| `<env> openclaw <command>` | documented | implemented | validated | live passthrough works |
| `<scope> secrets <set|list|delete>` | documented | implemented | validated | includes `service` shared-secret scope |
| `ollama`, `opensearch`, `caddy` passthrough | documented | implemented | validated | aligned |
| `<env> skills deploy|rollback` | not documented as current | not implemented | not implemented | maintainer intent points here, see findings |

## Stubbed Or Incomplete CLI Areas

No currently documented public command family in the active local code path is entirely stubbed.

The remaining CLI incompleteness is narrower:

- `moltbox <env> skill deploy ...` only discovers pure skills; plugin-backed packages with `openclaw.plugin.json` are intentionally skipped by `discoverPureSkills()` in `moltbox-gateway/internal/orchestrator/runtime_state.go`
- the intended pluralized form `moltbox <env> skills deploy ...` is not implemented locally or on the live box
- stale dead-path "not implemented in phase 1" language still exists in `moltbox-gateway/internal/gateway/handler.go`, `moltbox-gateway/internal/runtime/handler.go`, `moltbox-gateway/internal/services/handler.go`, and `moltbox-gateway/cmd/moltbox/main_test.go`

## High-Risk Inconsistencies

### 1. Gateway Self-Update Does Not Write Reconciliable Deployment Provenance

Evidence:

- docs and specs treat gateway as the authoritative writer of deployment metadata for self-update
- `moltbox-gateway/internal/orchestrator/manager.go` implements `GatewayUpdate()` but does not append a deployment record
- the live appliance deployment history did not contain `target: "gateway"` records for self-update

Competing interpretations:

- implementation bug: gateway update should append deployment history like other deploy paths
- doc drift: gateway self-update is intentionally outside deployment history

Recommended resolution:

- treat this as an implementation defect and write authoritative deployment records for `gateway update`

### 2. Generic Pre-Deploy Snapshot Language Had Drifted Past The Real System

Evidence:

- gateway code and the live box only materialize checkpoint snapshots under `runtime-baselines`
- no `/srv/moltbox-state/runtime-snapshots/` directory exists on the live appliance

Resolution applied:

- canonical docs were corrected to describe the current checkpoint-backed snapshot behavior

Residual question:

- decide whether a separate generic pre-deploy snapshot pipeline is still part of the target architecture or has been superseded by checkpointing and replay state

### 3. `discord-channel` Is Documented As An Active Platform Skill But Is Not Wired

Evidence:

- active docs exist under `platform/skills/discord-channel/`
- `moltbox-runtime/openclaw-*/channels.yaml.template` still contains raw `{{ discord_enabled }}` and `{{ discord_guilds_block }}` placeholders
- `moltbox-gateway/internal/orchestrator/manager.go` does not populate those render keys
- `remram-skills` does not contain a `discord-channel` package
- the live appliance rendered `channels.yaml` still contains the unresolved placeholders

Competing interpretations:

- the feature is intended but unfinished
- the platform item should have been retired back to backlog or archive

Recommended resolution:

- do not present `discord-channel` as an active implemented platform item until the render path, package source, and operator flow actually exist

### 4. `moltbox-telemetry` Is Still Registry-Level Documentation Without Matching Implementation

Evidence:

- active docs exist under `platform/plugins/moltbox-telemetry/`
- those docs reference `remram-skills/skills/moltbox-telemetry/`
- no such package exists in `remram-skills`
- no matching gateway or runtime integration was found in the implementation repos

Competing interpretations:

- active implementation was planned but never landed
- the item should be in backlog rather than the active plugin registry

Recommended resolution:

- move it out of the active platform registry or land the missing package and integration

### 5. Live Appliance Gateway Code Is Behind The Local Workspace

Evidence:

- local `moltbox-gateway` checkout is at `a196987d713516ad4e20efbab23dd696f7b8f21c`
- live appliance upstream checkout is at `5451b874142e820e6e2957451aed66646b518063`
- the newer local code contains the baseline no-op guard in `RuntimeSkillDeploy`
- the live box still appended a replay event for `together` even though that skill digest was already present in the baseline metadata

Recommended resolution:

- do not treat the live box as representative of the latest repo state until the appliance is updated

### 6. `skill` Versus Intended `skills` Namespace Still Needs A Decision

Evidence:

- local code, live help, and live execution all use singular `moltbox <env> skill deploy|rollback <skill>`
- the maintainer clarified during this audit that the intended new deploy surface is probably `moltbox <env> skills deploy`

Competing interpretations:

- singular `skill` is the stable public contract and should remain
- plural `skills` is the intended canonical namespace and singular should become a compatibility alias or be retired

Recommended resolution:

- make an explicit contract decision
- if plural wins, implement `moltbox <env> skills deploy|rollback`, update help and docs, and decide whether singular remains as a compatibility alias

## Unfinished Work Sweep

Docs or platform bundles that still advertise unfinished work:

- `platform/skills/discord-channel/spec.md`
- `platform/skills/discord-channel/operator-guide.md`
- `platform/plugins/moltbox-telemetry/spec.md`
- `platform/plugins/moltbox-telemetry/operator-guide.md`
- `platform/services/caddy/spec.md`
- `platform/services/caddy/operator-guide.md`
- `platform/services/ollama/spec.md`
- `platform/services/ollama/operator-guide.md`
- `platform/services/opensearch/spec.md`
- `platform/services/opensearch/operator-guide.md`
- `docs/overview/repositories.md`

Code-level unfinished or stale signals:

- dead-path "phase 1" stubs remain in the gateway/runtime/service handler packages noted above
- plugin-backed skill packages are still outside the managed `skill deploy` flow

## Audit Outcome

What is now aligned:

- the canonical docs, repo boundaries, and live public ingress model
- the resource-oriented CLI taxonomy for `gateway`, `dev`, `test`, `prod`, `service` secrets, `ollama`, `opensearch`, and `caddy`
- live box behavior for the currently shipped singular env-scoped skill deploy model

What is still inconsistent:

- gateway self-update provenance
- active-platform docs for `discord-channel` and `moltbox-telemetry`
- local repo state versus the older gateway revision currently running on-box
- intended plural `skills` namespace versus the shipped singular `skill` implementation

What needs a human decision:

- whether `skills` replaces `skill` in the env-scoped managed deploy namespace
- whether `discord-channel` and `moltbox-telemetry` stay active platform items or move back to backlog/archive
- whether generic pre-deploy snapshots remain a target architecture item beyond checkpoint snapshots
