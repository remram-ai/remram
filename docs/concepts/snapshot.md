# Snapshot

A Snapshot is a pre-deploy runtime state capture taken before every OpenClaw deployment.

Its purpose is recovery and rollback safety.

## What A Snapshot Captures

A snapshot is intended to preserve the runtime state needed to recover if a deployment corrupts or destabilizes the runtime.

The exact artifact shape is an implementation detail, but the concept is stable:

- capture the runtime state before deployment
- keep that snapshot available for rollback and recovery
- do not treat it as source-controlled baseline configuration

## Where Snapshots Live

Snapshots are appliance-state artifacts stored under:

```text
/srv/moltbox-state/runtime-snapshots/
```

They are not committed to Git.

## Retention

Current retention guidance:

- keep the last 5 snapshots per runtime
- allow time-based retention up to roughly one year

## Snapshot Versus Checkpoint

A [Checkpoint](checkpoint.md) is a promoted runtime baseline.

A snapshot is a pre-deploy safety artifact.

Snapshots are operational recovery artifacts only.

## Related Concepts

- [Runtime](runtime.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
