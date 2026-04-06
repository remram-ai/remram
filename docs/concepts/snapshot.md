# Snapshot

A Snapshot is a runtime-state capture used for recovery.

In the current Moltbox model, snapshots are the first restore-point mechanism for appliance and runtime state.

## What A Snapshot Captures

A snapshot preserves state needed to recover the system after a risky mutation.

The exact artifact shape is an implementation detail, but the concept is stable:

- capture state from the live environment
- keep that capture in appliance state
- use rollback before reaching for rebuild

## Where Snapshots Live Today

The current appliance uses ZFS snapshots for the covered appliance state paths.

Those snapshots live in the host storage layer rather than as Git artifacts.

Gateway-driven service deploy and restart operations also record snapshot metadata as part of the deploy history.

## Related Concepts

- [Runtime](runtime.md)
- [Gateway](gateway.md)
