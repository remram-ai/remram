# Checkpoint

A Checkpoint is a promoted runtime baseline.

It captures a runtime state that the system wants to preserve as the new baseline for future rebuilds and replay.

## What A Checkpoint Captures

A checkpoint should capture:

- runtime configuration
- plugin and skill inventory
- deployment replay metadata

Unlike a simple safety snapshot, a checkpoint is intended to represent a new stable baseline.

## Checkpoint Versus Snapshot

A [Snapshot](snapshot.md) is taken automatically before deployment for rollback safety and remains an appliance-only artifact.

A checkpoint is a deliberate promotion step.

Checkpoints may be committed into source control and treated as new baseline configuration for a runtime.

## Checkpoint In The CLI

Checkpoint operations are addressed directly against environment namespaces.

Example direction:

```text
moltbox dev checkpoint
```

Checkpoint is intended to:

1. capture runtime state
2. build a new base container image
3. deploy that image
4. validate runtime health
5. clear replay history if successful

TODO:

- finalize the checkpoint artifact schema
- finalize where checkpoint data lives before promotion into source control
- confirm whether checkpointing is synchronous or produces a staged artifact for later promotion

## Why Checkpoints Matter

The runtime model is mutable.

Checkpointing gives the system a way to promote a known-good runtime state into the new baseline instead of replaying the entire historical chain forever.

## Related Concepts

- [Runtime](runtime.md)
- [Snapshot](snapshot.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../platform/cli-architecture.md)
