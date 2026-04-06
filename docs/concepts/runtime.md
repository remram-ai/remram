# Runtime

A Runtime is the execution environment for managed runtime behavior on the appliance.

In the current architecture, the primary runtime family is the OpenClaw runtime set.

Current steady-state environments:

- `test`
- `prod`

Internal runtime names:

- `openclaw-test`
- `openclaw-prod`

## Current Runtime Model

The current model is managed-pet, snapshot-first, and native-OpenClaw-first.

That means:

- normal runtime mutation uses native OpenClaw lifecycle surfaces
- service deploy is not the same thing as runtime mutation
- replay and checkpoint are not the normal `test` / `prod` lifecycle
- recovery is led by ZFS snapshots and verified backups

## Baseline Versus Live Runtime State

The current split is:

- `moltbox-services` owns baseline service inputs for OpenClaw services
- `moltbox-runtime` holds the final deployable runtime artifacts used by the release path
- live runtime state exists on the appliance under system-owned host paths

The live runtime state is not mirrored continuously back into Git.

## Runtime Operations

Runtime operations are addressed through environment namespaces:

```text
moltbox test openclaw <command>
moltbox test verify runtime|browser|web
moltbox prod openclaw <command>
moltbox prod verify runtime
```

These preserve native OpenClaw behavior rather than inventing a second Gateway-only runtime API.

## Related Concepts

- [Service](service.md)
- [Gateway](gateway.md)
- [Snapshot](snapshot.md)
- [CLI Architecture](../overview/cli-architecture.md)
