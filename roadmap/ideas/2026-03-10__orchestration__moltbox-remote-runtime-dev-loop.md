# Moltbox Remote Runtime Dev Loop

**Marketing Name (optional):** Moltbox Remote Runtime Dev Loop
**Layer:** Orchestration
**Primary Surface / Agent:** Moltbox CLI runtime commands
**Relevant Hook or Stage (if applicable):** Runtime validation, Semantic Router bring-up
**Dependencies (if any):** Moltbox tools service, runtime deploy flow, host target registry
**Date:** 2026-03-10
**Status:** Ready for CLI Review
**One-liner:** Make remote runtime validation and inspection a first-class CLI workflow so development does not depend on manual SSH sessions.

---

## Opportunity / Problem

The Semantic Router implementation exposed a practical operator gap.

The implementation itself belongs in the runtime, but validating it from the workstation still depends on host-level access patterns:

- SSH into `moltbox`
- inspect host paths and runtime roots manually
- run host-local CLI commands manually
- sometimes copy files or probe Docker directly

That is workable for early bring-up, but it is the wrong long-term developer loop.

If the expected development model is "edit locally, then SSH into the box to validate runtime behavior," the CLI is missing an important capability layer.

We want the normal path to be:

- run local command
- target remote runtime
- receive packet, ledger, telemetry, and status back directly

without treating SSH as the primary interface.

---

## What It Does

This idea adds a first-class remote development loop to the Moltbox CLI and related runtime tooling.

The goal is not to expose management internals everywhere. The goal is to let a developer or operator validate runtime behavior from their workstation without dropping into SSH for normal workflows.

Desired capabilities include:

- invoke `moltbox runtime <env> chat` against a remote host from the workstation
- inspect the returned packet, ledger, and telemetry directly
- run runtime smoke checks without manually entering the host
- surface runtime config provenance clearly
- reduce or eliminate ad hoc `ssh` and `scp` steps during development

---

## Example / Scenario

A developer is implementing the Remram Semantic Router locally.

They need to verify:

- packet creation
- preflight behavior
- multi-stage escalation
- guardrail enforcement
- telemetry output

Today that can collapse into:

- local tests pass
- local workstation cannot reach Docker directly
- host runtime exists on `moltbox-prime`
- validation requires SSH plus manual host commands

Desired future loop:

1. Developer runs a local CLI command such as:
   `moltbox runtime dev chat --message "..."`
2. CLI targets the configured remote runtime host automatically.
3. The command returns:
   - final answer or `spawn_agent` stub
   - packet summary
   - ledger
   - telemetry
   - stage path
4. Optional flags expose deeper debugging details without needing host shell access.

---

## Core Mechanism (High-Level)

This does not require turning runtime capabilities into management CLI surfaces.

Instead, it suggests a better remote execution path for the existing runtime-facing commands.

Possible shapes:

- CLI proxies runtime commands through the Moltbox tools service
- CLI supports remote host execution as a first-class transport
- CLI can target a configured host and run runtime commands there without manual SSH
- CLI can expose structured debug output for packet and ledger inspection

Important principle:

- the Semantic Router remains a runtime component
- the CLI remains a harness and operator surface
- remote runtime validation becomes a supported flow rather than a shell workaround

---

## Benefits

- Faster development loop for runtime capabilities
- Less dependence on host shell access
- Fewer manual SSH and file-copy steps
- Better reproducibility for validation and debugging
- Clearer separation between runtime behavior and management ergonomics
- Easier handoff to future contributors who should not need host-shell rituals to verify runtime behavior

---

## Feasibility (High-Level)

This is feasible because the project already has the core ingredients:

- Moltbox CLI runtime commands
- a tools/control-plane service
- a target registry
- managed runtime environments
- structured JSON outputs

The missing piece is not raw capability. The missing piece is a deliberate remote developer workflow.

This does not require inventing a second runtime model.

It likely requires:

- a remote transport or proxy path for runtime commands
- better config for host targeting
- structured debug flags on runtime chat commands

---

## Concrete Gaps Encountered

These are not hypothetical. They were encountered while implementing and validating the Remram Semantic Router and telemetry work.

### 1. Remote runtime chat is not a first-class workstation workflow

To validate the real runtime path, the loop repeatedly degraded into:

- SSH to the runtime host
- run host-local `python3 -m moltbox_cli ...`
- manually `scp` changed files into a scratch checkout
- redeploy from the remote scratch path

This is the single biggest ergonomics gap.

### 2. Runtime chat debugging is not surfaced directly

The runtime chat harness can produce useful debugging data, but the CLI does not yet make that easy to request or inspect in a stable way.

Needed output included:

- packet summary
- full packet
- ledger
- stage path
- per-stage telemetry
- raw stage outputs
- debug artifact path
- actual session id / turn id

Today that required reading large JSON blobs or digging into files manually.

### 3. Runtime config provenance is hard to see

When validating remote behavior, it was often necessary to confirm:

- which rendered deployment was mounted
- which runtime root was active
- which `openclaw.json` actually won
- which env vars were live inside the container
- which plugin/config files were being read

This should be one command, not a shell investigation.

### 4. Runtime logs are accessible, but not task-oriented

The built-in logs path is useful, but the CLI does not yet give a tight operator loop for runtime-capability bring-up.

Needed during this milestone:

- tail logs for one runtime target
- filter by subsystem or event string
- request JSON output suitable for tooling
- correlate a chat turn to the matching log events

Today this still drifted into raw `docker` or `cat | Select-String`.

### 5. Debug artifacts are not a first-class surface

Semantic Router debug artifacts were written under the runtime root, but discovering and retrieving the right file was awkward.

Needed operations:

- list latest artifacts
- fetch latest artifact for the last chat turn
- fetch artifact by session id / turn id
- show artifact metadata without dumping the full file

### 6. Remote deploy from local source is not supported as a normal dev loop

The code path worked, but only after manually syncing a local worktree to a remote scratch directory.

Needed:

- push a local worktree or changed files to the target runtime host
- deploy from that synced source
- make the source path explicit in CLI output

Without this, runtime development still depends on ad hoc `scp`.

### 7. No first-class diagnostics/exporter health surface

When trying to extend visibility beyond logs into OpenTelemetry, there was no clean CLI way to answer:

- are diagnostics enabled?
- are diagnostic events being emitted?
- is the diagnostics exporter plugin loaded?
- what endpoint is configured?
- is the exporter healthy?
- what blocked exporter startup?

This became a container-level investigation instead of a CLI workflow.

---

## Guardrails / Constraints

- Must not collapse runtime behavior into the config-plane CLI in a way that confuses responsibilities.
- Must preserve the distinction between:
  - management/deploy commands
  - runtime-facing validation commands
- Must not require developers to mutate live runtime config just to inspect packet behavior.
- Must keep packet and telemetry inspection explicit and intentional.
- Must remain compatible with later plugin-based runtime execution.

---

## Requested Capabilities

### A. First-class remote runtime execution

Add a supported remote transport so these commands work from the workstation without manual SSH:

- `moltbox runtime <env> chat`
- `moltbox runtime <env> status`
- `moltbox runtime <env> inspect`
- `moltbox runtime <env> logs`
- `moltbox runtime <env> smoke`

The transport can proxy through the tools service or use another supported remote execution mechanism, but it must be deliberate and supported.

### B. Rich runtime chat debugging

Add explicit debug flags to `moltbox runtime <env> chat`, for example:

- `--show-packet-summary`
- `--show-packet`
- `--show-ledger`
- `--show-telemetry`
- `--show-stage-path`
- `--show-raw-stage-outputs`
- `--show-debug-artifact`
- `--show-session-ids`

These should be individually selectable so debug output is intentional and not always noisy.

### C. Runtime smoke command for orchestration deliverables

Add a dedicated smoke surface for runtime bring-up.

Example:

- `moltbox runtime <env> smoke semantic-router`

Expected uses:

- prove local-only answer path
- prove escalation path
- verify timings/telemetry exist
- verify `spawn_agent` boundary behavior
- verify logs/artifacts were written

### D. Runtime config provenance command

Add a single command that explains what config actually drove a runtime turn.

Example:

- `moltbox runtime <env> config show --resolved`

Expected output:

- runtime root path
- rendered config path
- active `openclaw.json`
- active plugin config
- active env vars relevant to runtime routing
- mounted config sources
- deployment id / render manifest path

### E. Runtime log operator surface

Add runtime-targeted log commands so operators do not need raw `docker` access.

Examples:

- `moltbox runtime <env> logs --follow`
- `moltbox runtime <env> logs --json`
- `moltbox runtime <env> logs --grep semantic_router`
- `moltbox runtime <env> logs --since 15m`
- `moltbox runtime <env> logs --session <id>`
- `moltbox runtime <env> logs --turn <id>`

### F. Runtime debug artifact surface

Add a dedicated artifact surface instead of relying on shell/file access.

Examples:

- `moltbox runtime <env> artifacts list`
- `moltbox runtime <env> artifacts latest`
- `moltbox runtime <env> artifacts get --turn <id>`
- `moltbox runtime <env> artifacts get --session <id>`
- `moltbox runtime <env> artifacts meta --latest`

### G. Remote source sync / deploy helper

Add a supported inner-loop command so runtime code can be validated remotely from local source without hand-managed copies.

Examples:

- `moltbox runtime <env> sync`
- `moltbox runtime <env> deploy --from-local-worktree`
- `moltbox runtime <env> deploy --changed-only`

The important part is not the exact command name; the important part is removing manual `scp` as the default workflow.

### H. Diagnostics / exporter visibility

Add CLI support for runtime diagnostics state.

Examples:

- `moltbox runtime <env> diagnostics status`
- `moltbox runtime <env> diagnostics check`
- `moltbox runtime <env> diagnostics events --tail`
- `moltbox runtime <env> diagnostics exporters`

Expected output:

- diagnostics enabled/disabled
- exporter plugin loaded/failed
- configured endpoint
- recent exporter errors
- recent matching diagnostic events

---

## Proposed CLI Shape

This is one possible surface area, meant to make the request concrete rather than prescriptive.

### Runtime chat

- `moltbox runtime dev chat --message "..."`
- `moltbox runtime dev chat --message "..." --show-telemetry --show-stage-path`
- `moltbox runtime dev chat --message "..." --show-packet-summary --show-ledger`
- `moltbox runtime dev chat --message "..." --show-debug-artifact --show-session-ids`

### Runtime logs

- `moltbox runtime dev logs --grep semantic_router --json`
- `moltbox runtime dev logs --session <session-id>`
- `moltbox runtime dev logs --turn <turn-id>`

### Runtime config / diagnostics

- `moltbox runtime dev config show --resolved`
- `moltbox runtime dev diagnostics status`
- `moltbox runtime dev diagnostics check`

### Runtime artifacts

- `moltbox runtime dev artifacts latest`
- `moltbox runtime dev artifacts get --turn <turn-id>`

### Runtime smoke

- `moltbox runtime dev smoke semantic-router`

---

## Open Questions

- Should remote runtime execution proxy through the tools service, or should the CLI own a dedicated remote transport?
- Should packet and ledger inspection be default in dev/test and hidden in prod?
- Should runtime smoke validation become a named subcommand rather than overloading `chat` flags?
- What is the cleanest way to support remote code/test loops without blurring the line between source repo state and deployed runtime state?

---

## Acceptance Criteria

This deliverable request should be considered satisfied when all of the following are true:

1. A developer can validate a runtime-only deliverable from the workstation without manual SSH.
2. `moltbox runtime <env> chat` can show stage path and telemetry directly when requested.
3. A developer can fetch the matching runtime debug artifact for a turn without shell access.
4. A developer can inspect resolved runtime config and deployment provenance from one CLI command.
5. Runtime logs can be filtered by target/session/turn without dropping to `docker`.
6. A developer can run a named runtime smoke check for orchestration deliverables.
7. A developer can tell whether runtime diagnostics/exporters are enabled and healthy without shell investigation.
8. Remote deploy from local source no longer depends on ad hoc `scp`.

---

## Priority Assessment

This should be treated as a high-value developer productivity deliverable for any runtime-capability work, especially:

- Semantic Router
- runtime telemetry
- plugin bring-up
- provider integrations
- channel bring-up
- agent/workflow dispatch debugging

It is not cosmetic. It removes a real operational tax from every runtime-oriented development thread.

---

## Links (Related Ideas)

- Remram Semantic Router
- Request Preflight Pipeline
- Agent workflow dispatch
