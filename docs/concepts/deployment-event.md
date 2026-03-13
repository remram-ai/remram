# Deployment Event

A Deployment Event is a recorded deployment operation written by the gateway control plane.

Deployment events are part of the runtime rebuild and replay model.

## What Deployment Events Are For

Deployment events provide the event history needed to reconstruct current runtime state from:

- a baseline runtime configuration
- subsequent runtime-affecting operations

That means deployment events are part of the replay path used during rebuild and recovery.

## Where Deployment Events Live

Deployment replay history is:

- stored in appliance state
- maintained per runtime environment
- rollback-aware
- independent from Git repositories

## Typical Examples

Examples of runtime-affecting deployment events include:

- skill deployment into a runtime
- plugin-backed capability installation
- runtime baseline promotions that reset the replay chain

The exact event schema belongs to the platform architecture, but the concept is stable.

TODO:

- finalize the deployment-event schema
- confirm retention and pruning rules for replay history
- confirm whether service-only deploys that do not mutate runtime state are tracked separately from runtime replay events

## Related Concepts

- [Runtime](runtime.md)
- [Gateway](gateway.md)
- [Snapshot](snapshot.md)
- [Checkpoint](checkpoint.md)
