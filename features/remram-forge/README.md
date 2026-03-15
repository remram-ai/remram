# Remram Forge

Remram Forge is the internal engine for how the platform gets shaped, reviewed, and improved.

It is where the lifecycle becomes explicit: intake, proposal shaping, implementation flow, validation posture, decision mechanics, and the artifact contracts that let those steps stay coherent across repositories.

Forge exists so `remram` can stay focused on what the platform is while Forge owns how the platform evolves.

## What Forge Means

Forge is the operational grammar of the ecosystem:

- lifecycle stages and checkpoints
- governance rules and decision posture
- role mechanics, workflows, and orchestration tasks
- canonical lifecycle templates and orchestration state schemas
- the inner loop that feeds better artifacts back into the rest of the platform

## Repository Boundary

The dedicated implementation and lifecycle repository is the private internal [`remram-forge`](https://github.com/remram-ai/remram-forge) repository.

This folder exists to preserve the approved feature record inside `remram`, not to mirror the full Forge repository.

## Status

Approved feature with a dedicated private repository.

Historical proposal and project artifacts for this feature have not yet been reconstructed into this repo's `roadmap/` and `features/` history.

## Why It Matters

- contributors can find lifecycle rules, governance checkpoints, and artifact templates in one dedicated place
- `remram` stays focused on platform architecture, feature definitions, and public-facing documentation
- downstream implementation repositories can consume one Forge-owned lifecycle model instead of duplicating local process rules
- lifecycle state contracts for agents, projects, and tasks have one canonical home

## Canonical Repository

- [`remram-forge` (private)](https://github.com/remram-ai/remram-forge)
- [Forge Governance (private)](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- [Forge Schemas (private)](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md)

## Local Remram Artifacts

- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Documentation

- [Forge Repository README (private)](https://github.com/remram-ai/remram-forge/blob/main/README.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
