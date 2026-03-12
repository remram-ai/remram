# Moltbox Builds

This folder is for real Moltbox builds.

Some documents here will be reference builds from the project creator. Others can be community builds that show different tradeoffs, budgets, and local AI goals.

## Build Families

- **Edge**: the smallest appliance. Minimal local inference, strong cloud assist, quiet and simple.
- **Solo**: a practical personal box. Enough local GPU and RAM to keep routing and retrieval close to the user.
- **Family**: a stronger shared box. More memory, more storage, and enough headroom for multiple people or heavier workflows.
- **Sovereign**: a serious local AI machine. Bigger GPU budgets, more local reasoning, less dependence on remote cognition.

These are not strict certification tiers. They are a shared vocabulary for talking about what a Moltbox is trying to do.

## Current Reference Build

- [Moltbox Build Guide](../build-guide.md)
- [Moltbox Prime](Moltbox-Prime/moltbox-prime.md)

## Add Your Build

Use [the build template](_build-template.md) and include:

- what kind of Moltbox you built
- when you built it
- what constraints shaped the build
- what the machine is good at
- what you would change next time
- one or more photos if you have them

## What Does Not Belong Here

This folder is not the place for deep deployment instructions, container topology, or runtime configuration.

Those implementation details belong in `remram-gateway`.
