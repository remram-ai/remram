# Roadmap

`roadmap/` holds active pre-approval planning artifacts for RemRam.

Use this directory for planning work that has not yet been approved into the top-level `features/` lifecycle tree.

The planning flow is:

```text
Idea (`roadmap/ideas/`) -> Proposal (`roadmap/proposals/`) -> Approved Feature (`features/`) -> Feature Project -> Platform Item -> Feature Documentation
```

- `ideas/` captures Stage 1 intake outputs: exploratory concepts, experiments, and design hypotheses.
- `proposals/` captures Stage 2 proposal artifacts awaiting leadership approval.
- `features/` at the repository root holds the approved feature lifecycle work created after proposal approval.
- `platform/` holds active platform items once approved feature work produces a defined implementation surface.
- `docs/features/` holds the user-facing capability documentation assembled from completed platform deliverables.

Lifecycle routing:

- [Stage 1 - Intake and Idea Formation](../governance/lifecycle/stage-01-intake-and-idea-formation.md) produces idea artifacts in `roadmap/ideas/`.
- [Stage 2 - Product Evaluation and Proposal](../governance/lifecycle/stage-02-product-evaluation-and-proposal.md) produces proposal artifacts in `roadmap/proposals/`.
- Proposal approval promotes the work into `features/` for [Stage 3 - Project Formation](../governance/lifecycle/stage-03-project-formation.md) and later implementation stages.

Platform items are technical deliverables.
Feature documentation describes the user-facing capability built from those deliverables.

Use the roadmap templates when creating or promoting planning artifacts:

- [Idea Template](./ideas/_template.md)
- [Proposal Template](./proposals/_template.md)
- [Ideas README](./ideas/README.md)
- [Proposals README](./proposals/README.md)

Archived planning history remains in `archive/` and should not be edited in place.

Go next:

- Start with [Community Getting Started](../docs/community/getting-started.md) if you are orienting to the repository.
- Use [Ideas](./ideas/README.md) when shaping a new concept.
- Use [Proposals](./proposals/README.md) when an idea becomes decision-ready.
- Use [Features](../features/README.md) once leadership approval creates an approved feature.
- Use [Governance Lifecycle](../governance/lifecycle/README.md) when you need the chronological stage rules behind those directory transitions.
- Use [Platform Registry](../platform/README.md) once approved feature work produces a concrete platform item.
- Use [Feature Documentation](../docs/features/README.md) once a capability is ready to be explained as a complete user-facing feature.
- Use [Overview](../docs/overview/README.md) when you need architectural context for a roadmap item.
