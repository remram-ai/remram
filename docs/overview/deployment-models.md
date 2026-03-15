# Deployment Models

Moltbox uses several related deployment models.

They all share one rule: the gateway control plane is responsible for orchestrating change and writing authoritative deployment metadata.

## Common Deployment Rules

All deployment paths should follow these rules:

- deployments are coordinated by the gateway
- appliance inputs come from Git-backed repositories
- operational state lives under `/srv/moltbox-state`
- logs live under `/srv/moltbox-logs`
- deployment metadata is written consistently for every path, including self-update
- gateway self-update also appends a host-level appliance ledger to `/var/lib/moltbox/history.jsonl`

Operators should invoke these paths through the Moltbox CLI rather than direct Docker commands.

## Lifecycle Control Surfaces

The platform uses several legitimate lifecycle surfaces:

Gateway service lifecycle:

```text
moltbox gateway service <action> <service>
```

Gateway self-lifecycle:

```text
moltbox gateway update
```

Environment runtime lifecycle:

```text
moltbox dev reload
moltbox dev checkpoint
```

Native OpenClaw passthrough lifecycle:

```text
moltbox dev openclaw skills list
```

Moltbox preserves native OpenClaw passthrough for runtime inspection and debugging, but gateway-managed runtime mutation happens through the environment-scoped `skill` and `plugin` families plus the runtime deploy and reload paths.

## Deployment Metadata

The gateway is the authoritative writer of deployment records.

Minimum deployment record fields should include:

- `deployment_id`
- `timestamp`
- `actor`
- `target`
- `artifact_version`
- `previous_version`
- `result`

These fields are the minimum needed for rollback, audit, and reconciliation.

## 1. Service Deployment

Service deployment manages appliance containers as deployment units.

Typical operator surface:

```text
moltbox gateway service deploy <service>
moltbox gateway service restart <service>
moltbox gateway service status <service>
```

Primary inputs:

- service definitions from `moltbox-services`
- container images referenced by those definitions
- current appliance deployment state

Typical flow:

1. resolve the target service definition
2. capture the current deployment state needed for rollback
3. prepare the target artifact
4. replace or restart the container
5. remount persistent state
6. validate health
7. write authoritative deployment metadata

This model applies to shared services such as `opensearch`, `ollama`, and `caddy`.

The gateway is still a first-class appliance service for status and topology purposes, but gateway self-mutation is the special helper-based path:

```text
moltbox gateway update
```

It also applies to the runtime containers themselves.

Public runtime service targets are:

- `dev`
- `test`
- `prod`

When the gateway deploys one of those runtime containers as a service target, it must:

1. deploy the target runtime container artifact
2. restore the baseline runtime configuration
3. replay recorded runtime deployment events, including skill and plugin install replay scripts since the last full runtime container deploy
4. validate runtime health
5. write authoritative deployment metadata

## 2. Runtime Baseline Update

Runtime baseline updates apply changes from `moltbox-runtime` to an environment baseline.

Typical operator surfaces:

```text
moltbox dev reload
moltbox test reload
moltbox prod reload
```

Primary inputs:

- baseline runtime configuration from `moltbox-runtime`
- current runtime container state
- appliance runtime storage under `/srv/moltbox-state/runtime/`

Typical flow:

1. resolve the target environment baseline
2. synchronize the baseline into the appliance runtime area
3. run the required runtime lifecycle action
4. validate runtime health
5. record any deployment metadata or event history needed for recovery

This model updates the baseline starting point for a runtime. It does not claim that the resulting live runtime is identical to the Git repo after native runtime mutations occur.

## 3. Runtime Skill Deployment

Runtime skill deployment makes pure skill packages available inside a live runtime.

This model is different from baseline sync.

Primary inputs:

- skill packages from `remram-skills`
- the target runtime environment
- gateway replay state under `/srv/moltbox-state`

Typical operator surfaces:

```text
moltbox dev skill deploy together
moltbox dev skill list
moltbox dev skill remove together
```

Expected behavior:

- the gateway resolves a pure skill package from `remram-skills/skills/<name>/`
- the gateway stages that package under `/srv/moltbox-state/deploy/runtime/<runtime>/packages/<event_id>/`
- the gateway appends a replay event
- the runtime is redeployed through the control plane
- OpenClaw loads the staged skill from its normal local skill location

Managed `skill deploy` on `main` stages pure skill packages only. Packages that rely on `openclaw.plugin.json` are not yet supported by this managed path.

Native OpenClaw skill inspection still remains reachable through passthrough:

```text
openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

## 4. Runtime Plugin Deployment

Runtime plugin deployment is also a gateway-managed environment-scoped mutation on `main`.

Typical operator surfaces:

```text
moltbox dev plugin install moltbox-telemetry
moltbox dev plugin list
moltbox dev plugin remove moltbox-telemetry
```

Expected behavior:

- the gateway stages or resolves the plugin package input
- the gateway records replay metadata
- the runtime is redeployed or reloaded through the control plane
- resulting live plugin state remains operational state until a later checkpoint intentionally promotes it

Native OpenClaw plugin inspection and debugging must still remain reachable through passthrough when needed.

## 5. Snapshot Types

Snapshots exist at multiple levels:

1. container-level snapshots
2. runtime-state snapshots

These snapshot types serve different recovery purposes and may be captured together for the same operation.

## 6. Current Runtime Snapshot Contract

The implemented durable runtime-state capture on `main` is checkpoint snapshotting.

Current snapshot root:

- `/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/snapshot/`

A separate standalone `/srv/moltbox-state/runtime-snapshots/` contract is still in flight and is not part of the implemented `main` behavior today.

## 7. Runtime Checkpointing

Checkpointing promotes a known-good runtime state into a new baseline.

Typical operator surface:

```text
moltbox dev checkpoint
```

Checkpointing is a runtime rebasing process.

Conceptually:

```text
runtime state
  + installed modules
  + runtime configuration
  = new base container image
```

Expected checkpoint flow:

1. capture current runtime configuration
2. capture installed plugin and skill inventory
3. capture deployment replay metadata
4. build a new base container image
5. deploy and validate that image
6. clear replay history if successful

Checkpoint artifacts begin in appliance storage and may later be promoted into Git-backed source control as a new runtime baseline.

In this model, Git can act as the baseline artifact store for rebased runtime images instead of relying only on a traditional container registry.

Canonical appliance storage root:

- `/srv/moltbox-state/runtime-baselines/`

## 8. Gateway Self-Update

The gateway is part of the appliance, but it is also the control plane.

That means self-update is a special deployment path:

```text
moltbox gateway update
```

Self-update still has to satisfy the same rules as any other deployment path:

- identify the target artifact
- refresh the gateway source or build input
- rebuild and replace the host `moltbox` CLI/tooling bundle
- perform the update safely
- validate the running gateway
- write authoritative deployment metadata
- append a host-level history record to `/var/lib/moltbox/history.jsonl`

Inconsistent gateway provenance is an implementation defect, not an acceptable deployment mode.

There is no separate active `moltbox tools update` lifecycle surface. `moltbox gateway update` is the canonical appliance self-update path for both the gateway container and the host CLI/tooling installed at `~/.local/bin/moltbox`.

## 9. Environment Promotion Workflow

Environment promotion is intentionally asymmetric.

Expected workflow:

1. build and iterate in a working branch
2. commit and test freely in `dev`, where shell access is available
3. run unit tests and the relevant platform item `test-plan.md` in `dev`
4. promote to `test` through the Moltbox CLI only
5. run the same platform item test plan again in `test`
6. validate that the promotion path itself worked correctly
7. stop for UAT readiness review
8. after approval, merge through the normal Git path and deploy to `prod`

This means:

- `dev` is the implementation environment
- `test` is the CLI-gated promotion and pre-UAT validation environment
- `prod` is reached only after approval steps and mainline integration

If promotion to `test` fails, the deployment process is defective and should be fixed before the platform item is treated as ready.

## Runtime State Versus Container Lifecycle

The platform separates container lifecycle from runtime state lifecycle.

Container lifecycle answers:

- what container image is running
- whether the service is healthy
- whether the container should be replaced or restarted

Runtime state lifecycle answers:

- what baseline configuration is active
- what deployment events have mutated the runtime
- what snapshots and checkpoints exist for recovery

This distinction matters because an OpenClaw runtime may be healthy as a container while still carrying important mutable state that must be preserved, replayed, or promoted.

## Related Documents

- [Overview](overview.md)
- [Topology](topology.md)
- [CLI Architecture](cli-architecture.md)
- [Runtime](../concepts/runtime.md)
- [Snapshot](../concepts/snapshot.md)
- [Checkpoint](../concepts/checkpoint.md)
- [Deployment Event](../concepts/deployment-event.md)
