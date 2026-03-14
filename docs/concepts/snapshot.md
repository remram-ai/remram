# Snapshot

A Snapshot is a runtime-state capture used for recovery.

On `main`, the durable runtime snapshot that actually exists is the checkpoint snapshot captured during `moltbox <env> checkpoint`.

## What A Snapshot Captures

A snapshot preserves runtime state needed to recover or promote a runtime baseline.

The exact artifact shape is an implementation detail, but the concept is stable:

- capture runtime state from the live environment
- keep that capture in appliance state
- do not treat it as source-controlled baseline configuration until a checkpoint is intentionally promoted

## Where Snapshots Live Today

Current checkpoint snapshot directories live under:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/snapshot/
```

The active checkpoint metadata pointer lives at:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/current.json
```

## Current Contract Boundary

A separate standalone pre-mutation snapshot root is still in flight.

That means the implemented `main` contract today is:

- checkpoint snapshots are real
- replay history is real
- a separate per-mutation `/srv/moltbox-state/runtime-snapshots/` contract is not yet implemented

## Snapshot Versus Checkpoint

A [Checkpoint](checkpoint.md) is the promoted runtime baseline record.

A snapshot is the captured runtime-state input used by checkpoint.

## Related Concepts

- [Runtime](runtime.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
