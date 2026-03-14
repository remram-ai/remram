# Snapshot

A Snapshot is a captured copy of runtime state used by gateway recovery workflows.

## Current Implementation

In the current Moltbox implementation, snapshot artifacts are created by environment checkpoint operations:

```text
moltbox <env> checkpoint
```

The gateway captures runtime state from the target OpenClaw container and stores it under:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint>/snapshot/
```

Checkpoint metadata then points at that snapshot from:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/current.json
```

These artifacts are appliance state. They are not committed to Git.

## What A Snapshot Captures

Current checkpoint snapshots preserve the runtime-local OpenClaw state needed to rebase a runtime into a new baseline image.

That includes the mutable runtime state copied from `/home/node/.openclaw` for the target environment.

## What Is Not Currently Implemented

A separate generic pre-deploy snapshot root at:

```text
/srv/moltbox-state/runtime-snapshots/
```

is not present in the current gateway code or on the live appliance.

## Snapshot Versus Checkpoint

A [Checkpoint](checkpoint.md) promotes a snapshot-backed runtime state into a new baseline image.

The snapshot is the captured runtime-state artifact inside that checkpoint flow.

## Related Concepts

- [Runtime](runtime.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
