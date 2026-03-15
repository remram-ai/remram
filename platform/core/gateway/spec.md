# Moltbox Gateway Specification

## Purpose

Moltbox Gateway is the appliance control plane.

It owns the operator-facing command surface and coordinates the lifecycle of the appliance as a whole.

This spec is intentionally more detailed than the other platform item specs because the gateway is the integration point for the rest of the platform.

## Scope

Gateway owns:

- the `moltbox` CLI
- service lifecycle orchestration
- gateway self-update
- environment lifecycle actions such as reload and checkpoint
- environment-scoped native OpenClaw passthrough
- deployment metadata writes
- runtime deployment-event history

Gateway does not own:

- platform item definitions
- service definitions as source material
- runtime baseline config as source material
- skill implementation code

## Primary Inputs

Gateway consumes four major input classes:

1. service definitions from `moltbox-services`
2. baseline runtime config from `moltbox-runtime`
3. skill packages and recipes from `remram-skills`
4. operator intent from the Moltbox CLI over SSH
5. internal agent intent from the token-authenticated MCP HTTP surface

It also depends on:

- appliance state under `/srv/moltbox-state`
- logs under `/srv/moltbox-logs`
- Docker on the appliance host

## Control Surfaces

### Gateway Namespace

Gateway lifecycle and status:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway logs
moltbox gateway mcp-stdio
moltbox gateway docker ping
moltbox gateway docker run <image>
moltbox gateway token create <NAME>
moltbox gateway token list
```

`moltbox gateway update` is the active self-update surface for both:

- the running gateway container
- the host `moltbox` CLI/tooling installed on the appliance
- the host-level appliance history ledger at `/var/lib/moltbox/history.jsonl`

It is also the only supported gateway mutation path. `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` are intentionally rejected.

### Gateway Service Pipeline

Container lifecycle is primarily handled through:

```text
moltbox gateway service <action> <service>
```

Known actions in the current documentation model:

- `deploy`
- `restart`
- `status`

### Environment Lifecycle

Runtime lifecycle is environment-scoped:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev skill deploy together
moltbox dev skill list
moltbox dev skill remove together
moltbox dev plugin install moltbox-telemetry
moltbox dev plugin list
moltbox dev plugin remove moltbox-telemetry
```

### Native OpenClaw Passthrough

Gateway intentionally preserves native OpenClaw lifecycle behavior for runtime-local operations:

```text
moltbox dev openclaw models status
```

This is how runtime-native inspection and agent operations continue to reach the runtime without a second gateway-only API layer.

## Operator Path

Primary workstation control path:

```text
Workstation
  -> ssh
    -> Moltbox CLI
      -> Gateway
```

Internal agent path:

```text
Internal agent or container
  -> HTTP MCP + bearer token
    -> Gateway
```

A thin host-level `moltbox` entrypoint may exist, but it is a convenience wrapper rather than a separate control plane.

Supported restricted SSH identities:

- `jason-codex` for `moltbox <args>` automation
- `codex-bootstrap` for break-glass diagnostics with tighter restrictions outside `dev`

## Deployment Metadata Authority

Gateway is the authoritative writer of deployment state.

Minimum deployment record fields:

- `deployment_id`
- `timestamp`
- `actor`
- `target`
- `artifact_version`
- `previous_version`
- `result`

These records must be written consistently for:

- service deploys
- runtime-mutating operations when they are tracked as deployment events
- gateway self-update

If deployment metadata disagrees with the running artifact or rendered state, that is an implementation defect in the gateway pipeline.

## State Model

Gateway coordinates both container lifecycle state and runtime state.

Container lifecycle concerns:

- which service artifact is running
- whether a service should be deployed or restarted
- service health and rollback posture

Runtime lifecycle concerns:

- baseline config sync
- plugin and skill deployment events
- checkpoint and rebase orchestration
- replay-driven recovery

The gateway keeps these models separate because a runtime can be healthy as a container while still carrying important mutable state.

## Service Deployment Flow

Typical service deployment flow:

1. resolve the target service definition
2. determine the target artifact version
3. capture rollback-ready state
4. replace or restart the service container
5. validate health
6. write authoritative deployment metadata

This flow is the primary lifecycle path for appliance services such as `opensearch`, `ollama`, and `caddy`.

Gateway self-mutation is handled by the dedicated `moltbox gateway update` helper path instead of `gateway service deploy|restart gateway`.

## Runtime Lifecycle Flow

Typical environment lifecycle flow:

1. resolve the target environment baseline
2. apply any baseline config changes
3. perform the requested environment action such as `reload`
4. validate runtime health
5. record deployment events or metadata where required

Skill deployment uses the environment-scoped managed lifecycle:

```text
moltbox <env> skill deploy <skill>
moltbox <env> skill list
moltbox <env> skill remove <skill>
```

Plugin deployment also remains environment-scoped on `main`:

```text
moltbox <env> plugin install <package>
moltbox <env> plugin list
moltbox <env> plugin remove <plugin>
```

Managed `skill deploy` currently stages pure skill packages only. Plugin-backed packages remain outside that managed path until a separate contract is implemented.

## Snapshot, Replay, And Checkpoint Model

Gateway owns the orchestration of runtime recovery artifacts.

### Snapshots

The durable runtime-state capture implemented on `main` is checkpoint snapshotting under:

- `/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/snapshot/`

A separate standalone `/srv/moltbox-state/runtime-snapshots/` contract is still in flight.

### Deployment Events

Gateway maintains rollback-aware deployment-event history per runtime environment.

These events support rebuild from:

```text
baseline runtime config
  + deployment events
  = current runtime state
```

### Checkpoint

Checkpoint is the rebase operation:

```text
runtime state
  + installed modules
  + runtime configuration
  = new base container image
```

Checkpoint artifacts begin under appliance state and may later be promoted into Git-backed baseline storage.

## Repository Boundaries

Gateway orchestrates other repositories but should not absorb their ownership:

- `moltbox-services` still owns service definitions
- `moltbox-runtime` still owns baseline runtime config
- `remram-skills` still owns skill packages
- `remram` still owns architecture, roadmap, and platform registry docs

## Constraints

- direct Docker commands are break-glass tools, not the normal operator contract
- internal runtime identifiers such as `openclaw-dev` are implementation details, not public CLI namespaces
- gateway must preserve native OpenClaw lifecycle where the runtime already provides it
- gateway provenance must stay reconcilable across running artifact, rendered artifact, and deployment metadata
- there is no separate active `tools update` namespace; gateway self-update owns host CLI/tooling refresh
- public HTTPS ingress does not expose gateway or MCP routes
- MCP HTTP requests require `Authorization: Bearer <token>` and tokens are stored through the existing encrypted gateway secret store
