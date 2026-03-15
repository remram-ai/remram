# CLI Test Plan

## Purpose

This plan defines the repeatable validation workflow for the Moltbox CLI contract.

It is intended to catch:

- documentation drift
- namespace or routing drift
- live appliance regressions
- provenance and deployment-metadata defects
- wrapper-surface breakage

## Validation Buckets

### Bucket A: Full Validation

Use full validation for any project-owned command that:

- mutates gateway state
- deploys or restarts services
- changes runtime state
- manages checkpoints, replay, skills, plugins, secrets, or gateway update
- enforces SSH wrapper policy

Full validation must check:

- syntax and routing
- JSON output shape
- side effects
- state mutation
- deployment or replay metadata
- post-action health
- cleanup or rollback posture

### Bucket B: Safe Wrapper Validation

Use safe wrapper validation for passthrough or thin-wrapper surfaces such as:

- `moltbox <env> openclaw ...`
- `moltbox ollama ...`
- `moltbox opensearch ...`
- `moltbox caddy ...`
- authenticated MCP tool discovery

Wrapper validation must check:

- the documented namespace
- the wrapper reaches the intended backend
- the response shape is sane
- no destructive third-party action is required

## Contract Baseline Workflow

Before running live commands:

1. Read the Remram contract docs:
   - `docs/ai-context/README.md`
   - `docs/overview/overview.md`
   - `docs/operations/cli.md`
   - `docs/overview/topology.md`
   - `docs/overview/repositories.md`
   - `docs/overview/cli-architecture.md`
   - `reference/cli-reference.md`
   - `docs/concepts/gateway.md`
2. Read relevant platform and feature plans for the commands under test.
3. Build a command inventory from both docs and the live `moltbox-gateway` implementation.
4. Record which surfaces are public contract, compatibility-only, or undocumented implementation detail.

## Live Execution Rules

- Run live validation on the appliance host over SSH.
- Use the normal operator path first: `ssh -> moltbox`.
- Use break-glass container or HTTP inspection only when diagnosing a discrepancy.
- Prefer `dev` for destructive runtime validation.
- Treat `test` and `prod` as read-only unless the appliance is explicitly designated for destructive lifecycle testing.

## Preconditions

- SSH access to the appliance host
- healthy `gateway` service
- healthy shared services
- healthy target runtime environment, usually `dev`
- host repo checkouts present for `moltbox-gateway`, `moltbox-services`, `moltbox-runtime`, and `remram-skills`

## Required Scenario Coverage

### 1. Parser And Namespace Contract

Verify:

- `moltbox --help`
- `moltbox --version`
- active namespaces
- retired namespaces fail explicitly

At minimum, check:

- `runtime`
- `host`
- `tools`
- `openclaw-dev`
- top-level `service` used outside `service secrets ...`

### 2. Gateway Core

Verify:

- `moltbox gateway status`
- `moltbox gateway logs`
- `moltbox gateway docker ping`
- `moltbox gateway docker run hello-world`
- `moltbox gateway mcp-stdio`

### 3. Token And MCP Contract

Verify:

- token create
- token list
- token rotate
- token delete
- unauthenticated `/mcp` returns `401`
- authenticated `/mcp` returns tool metadata

### 4. Service Pipeline

Verify status for:

- `gateway`
- `caddy`
- `opensearch`
- `ollama`
- `dev`
- `test`
- `prod`

Verify mutation at minimum for:

- one shared service deploy
- one shared service restart
- one runtime deploy through `gateway service deploy <env>`
- `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` fail explicitly with guidance to use `moltbox gateway update`, and the gateway remains healthy

After every mutation, reconcile:

- service status output
- running container image
- `/srv/moltbox-state/deploy/history.jsonl`

### 5. Runtime Lifecycle

On `dev`, verify:

- `moltbox dev reload`
- `moltbox dev skill deploy <temp>`
- `moltbox dev skill list`
- `moltbox dev skill remove <temp>`
- `moltbox dev plugin install <temp-or-known-package>`
- `moltbox dev plugin list`
- `moltbox dev plugin remove <plugin>`
- `moltbox dev checkpoint`

Replay-sensitive scenario:

1. create runtime mutation state
2. prove `gateway service deploy dev` replays that state
3. checkpoint current runtime
4. prove replay log clears
5. prove the new baseline reflects current state
6. redeploy `dev` and confirm the new baseline still holds

Capture before/after:

- `/srv/moltbox-state/deploy/runtime/openclaw-dev/replay-log.json`
- `/srv/moltbox-state/runtime-baselines/openclaw-dev/current.json`

### 6. Secrets

Verify:

- `moltbox dev secrets set|list|delete`
- `moltbox service secrets set|list|delete`
- `moltbox test secrets list`
- `moltbox prod secrets list`

Expectations:

- values are not printed back
- files are created under `/var/lib/moltbox/secrets/<scope>/`
- list output is name-only

### 7. Wrapper Surfaces

Verify safe commands for:

- `moltbox dev openclaw health --json`
- `moltbox test openclaw health --json`
- `moltbox prod openclaw health --json`
- `moltbox dev openclaw skills list`
- `moltbox dev openclaw plugins list`
- `moltbox ollama list`
- `moltbox caddy version`
- `moltbox opensearch --version`

### 8. SSH Wrapper Policy

Verify:

- `jason-codex` can run `moltbox <args>`
- `jason-codex` cannot run arbitrary shell commands
- `codex-bootstrap` can run full `dev` diagnostics
- `codex-bootstrap` can read gateway status/logs
- `codex-bootstrap` cannot run `gateway update`
- `codex-bootstrap` cannot mutate `test` or `prod`

### 9. Gateway Update

Verify:

- `moltbox gateway update`
- gateway restarts healthy afterward
- `/srv/moltbox-state/deploy/history.jsonl` appends a `gateway_update` record
- `/var/lib/moltbox/history.jsonl` appends a host-level ledger entry
- both records contain reconcilable revision/source data

Also reproduce the updater helper inside `moltbox-gateway:latest` when investigating failures.

## Evidence Capture Requirements

For every audit run, capture:

- date and target appliance
- live gateway repo revision and branch
- exact command invoked
- JSON output or key lines
- before/after state files for mutations
- deployment history excerpts for service, runtime, and gateway update operations
- root-cause notes for any partial or failed result

## Regression Gates

A release should not be accepted when any of these are true:

- a documented namespace is missing
- a documented command routes under the wrong name
- a project-owned mutating command succeeds without reconcilable metadata
- `gateway update` cannot prove revision/source fidelity
- `gateway service deploy|restart gateway` mutates or destabilizes the control plane instead of failing explicitly
- retired namespaces redirect silently
- SSH wrappers allow shell escape
- checkpoint and replay state do not reconcile after a runtime mutation

## Cleanup Rules

- delete temporary tokens
- delete temporary secrets
- remove temporary replay-installed skills/plugins
- avoid checkpointing temporary validation artifacts unless the environment is disposable
- if checkpointing is part of the test, record the new baseline state explicitly and restore the environment intentionally rather than assuming cleanup happened
