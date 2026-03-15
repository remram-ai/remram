# Remram Forge

## Summary

Remram Forge is the approved feature for the internal lifecycle, governance, and orchestration contracts that drive how the platform evolves.

It separates Forge-owned SDLC mechanics from the Remram architecture repository so lifecycle rules, agent roles, artifact templates, and orchestration state contracts live in a dedicated repo.

## Status

Approved feature with a dedicated implementation repository.

The canonical implementation and lifecycle content now live in [`remram-forge`](https://github.com/remram-ai/remram-forge).

Historical proposal and project artifacts for this feature have not yet been reconstructed into this repo's `roadmap/` and `features/` history.

## User And Operator Outcome

- contributors can find lifecycle rules, governance checkpoints, and artifact templates in one dedicated place
- `remram` stays focused on platform architecture, feature definitions, and public-facing documentation
- downstream implementation repositories can consume one Forge-owned lifecycle model instead of duplicating local process rules
- lifecycle state contracts for agents, projects, and tasks have one canonical home

## Primary Platform Deliverables

- dedicated repo:
  - [`remram-forge`](https://github.com/remram-ai/remram-forge)
- canonical lifecycle surfaces:
  - [Forge Governance](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
  - [Forge Schemas](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Projects](projects/README.md)

## Related Documentation

- [Forge Repository README](https://github.com/remram-ai/remram-forge/blob/main/README.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
