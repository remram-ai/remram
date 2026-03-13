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
moltbox dev openclaw plugins install semantic-router
```

Moltbox intentionally uses the native OpenClaw lifecycle for skill and plugin deployment rather than redefining those operations as a separate public lifecycle model.

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

This model applies to shared services such as `gateway`, `opensearch`, `ollama`, and `caddy`.

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

## 3. Runtime Skill and Plugin Deployment

Runtime capability deployment installs skills and plugins into a live runtime.

This model is different from baseline sync.

Primary inputs:

- skill packages and recipes from `remram-skills`
- native OpenClaw installation mechanisms
- the target runtime environment

Typical operator surface:

```text
moltbox dev openclaw plugins install semantic-router
```

Expected behavior:

- gateway drives the deployment flow
- OpenClaw-native installation may mutate live runtime state
- deployment events are recorded by the gateway per runtime
- resulting live state is operational state, not an automatic Git mirror

This is why `moltbox-runtime` is baseline-only rather than a complete record of live runtime state.

Minimum current passthrough command families that should remain supported through `moltbox <env> openclaw ...` are:

```text
openclaw plugins list
openclaw plugins info <id>
openclaw plugins enable <id>
openclaw plugins disable <id>
openclaw plugins install <path-or-spec>
openclaw plugins uninstall <id>
openclaw plugins doctor
openclaw plugins update <id>
openclaw plugins update --all

openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

## 4. Snapshot Types

Snapshots exist at multiple levels:

1. container-level snapshots
2. runtime-state snapshots

These snapshot types serve different recovery purposes and may be captured together for the same operation.

## 5. Pre-Deploy Snapshots

Before every runtime-mutating OpenClaw operation, the appliance should capture pre-deploy snapshots.

Purpose:

- rollback safety
- recovery if a deployment corrupts runtime state

Canonical root:

- `/srv/moltbox-state/runtime-snapshots/`

Expected policy:

- keep the last 5 snapshots per runtime
- allow time-based retention up to roughly one year

Pre-deploy snapshots should occur before operations such as:

- plugin installs
- skill installs
- runtime reloads
- checkpoint operations

Snapshots are appliance artifacts. They are not committed to Git.

## 6. Runtime Checkpointing

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

TODO:

- document how rebased runtime images are represented in Git once the artifact contract is finalized
- document the exact promotion workflow from checkpoint artifact to committed runtime baseline
- document where checkpoint metadata is stored before Git promotion is finalized

## 7. Gateway Self-Update

The gateway is part of the appliance, but it is also the control plane.

That means self-update is a special deployment path:

```text
moltbox gateway update
```

Self-update still has to satisfy the same rules as any other deployment path:

- identify the target artifact
- perform the update safely
- validate the running gateway
- write authoritative deployment metadata

Inconsistent gateway provenance is an implementation defect, not an acceptable deployment mode.

## 8. Environment Promotion Workflow

Environment promotion is intentionally asymmetric.

Expected workflow:

1. build and iterate in a feature branch
2. commit and test freely in `dev`, where shell access is available
3. run unit tests and the relevant feature `test-plan.md` in `dev`
4. promote to `test` through the Moltbox CLI only
5. run the same feature test plan again in `test`
6. validate that the promotion path itself worked correctly
7. stop for UAT readiness review
8. after approval, merge through the normal Git path and deploy to `prod`

This means:

- `dev` is the implementation environment
- `test` is the CLI-gated promotion and pre-UAT validation environment
- `prod` is reached only after approval steps and mainline integration

If promotion to `test` fails, the deployment process is defective and should be fixed before the feature is treated as ready.

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
