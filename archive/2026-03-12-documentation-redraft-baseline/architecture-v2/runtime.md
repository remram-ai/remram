# Runtime

Runtime configuration comes from:

```text
moltbox-runtime/<service>/
```

The gateway must read runtime inputs through repository adapters.

The current platform target is a Linux host appliance. Runtime containers share the host kernel and should be treated as Linux workloads running on that host, not as alternate host platforms.

## Runtime Configuration Model

`moltbox-runtime` defines the baseline runtime configuration for each managed runtime.

It is not the complete authoritative runtime state after skill and plugin deployment.

OpenClaw runtimes are treated as mutable systems.

Native OpenClaw installation flows may change live runtime state, including:

- `openclaw.json`
- plugin state
- extension directories
- installed skill and plugin artifacts

That means the runtime state model is:

```text
baseline runtime configuration
  + skill/plugin deployments
  + runtime mutations
  = current runtime state
```

The baseline in `moltbox-runtime` is the starting point for runtime reconstruction and repeatable deployment, not a mirror of every live mutation that has occurred inside the container.

## Runtime Operations

Examples:

```text
moltbox openclaw config sync
moltbox openclaw reload

moltbox openclaw-dev config sync
moltbox openclaw-dev reload
```

`openclaw` targets production through the alias:

```text
openclaw == openclaw-prod
```

## Runtime Flow

Canonical flow:

1. refresh the external runtime repository
2. resolve the target component configuration
3. synchronize configuration into the appliance runtime root
4. execute the required runtime lifecycle operation
5. report diagnostics

This flow applies to baseline runtime configuration.

Skill and plugin deployment may then apply native OpenClaw mutations on top of that baseline.

The gateway is allowed to use OpenClaw's native plugin and skill installation flow when applying those mutations.

## Runtime Lifecycle

If a runtime must be rebuilt, the system restores the baseline configuration from `moltbox-runtime` and replays deployment history for that runtime.

Conceptually:

```text
baseline
  + deployment events
  = current runtime state
```

Rebuild behavior:

1. restore the baseline runtime configuration
2. restore required runtime-owned operational artifacts from appliance storage
3. replay deployment history for skills and plugins
4. return the runtime to the intended current state

The replay history is an operational runtime record, not a Git-backed source repository.

## Runtime Checkpoints

The architecture includes an explicit runtime checkpoint mechanism.

Conceptually:

```text
baseline
  + deployment events
  -> checkpoint
  = new baseline
  + future deployment events
```

Checkpointing captures the current runtime configuration and installed skills/plugins, then resets replay history for that runtime.

The intended control-plane surface is a runtime-scoped checkpoint operation such as:

```text
moltbox runtime checkpoint <runtime>
```

Exact command wiring and storage implementation remain implementation details, but checkpointing is part of the architecture model.

Checkpoint artifacts should be stored under appliance state storage.

Canonical root:

- `/srv/moltbox-state/runtime-baselines/`

Each checkpoint artifact should capture at least:

- runtime configuration snapshot
- installed plugin and skill inventory
- metadata such as runtime version, gateway version, and timestamp

## Runtime Backups

Live runtime configuration should not automatically synchronize back into Git repositories.

However, live runtime state must be backed up within appliance storage for:

- recovery
- rebuild replay support
- checkpoint creation

Those backups are operational artifacts under appliance storage, not version-controlled configuration.

Live runtime state must not automatically synchronize back into the Git-backed architecture repositories.

## Responsibility Boundary

Runtime operations own:

- baseline configuration synchronization
- reload and restart coordination
- runtime-specific diagnostics
- runtime checkpoint and backup orchestration
- rebuild-from-baseline and replay orchestration

Runtime operations do not own:

- service topology definition
- product feature naming
- generic service deployment policy

Canonical appliance storage for runtime material:

- baseline runtime artifacts and mutable runtime state under `/srv/moltbox-state/runtime/`
- checkpoint and backup artifacts under `/srv/moltbox-state/runtime-baselines/`
- logs under `/srv/moltbox-logs/`

User-home runtime paths should be treated as legacy current-state behavior until the appliance has been normalized onto the machine-scoped storage roots.
