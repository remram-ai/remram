# Product Proposal Workflow

## Purpose

Turn an approved idea into a decision-ready product proposal with architecture direction, risks, cost considerations, and supporting review materials.

## Primary Role

[Product Manager](../roles/product-manager.md)

## Supporting Roles

- [Designer](../roles/designer.md)
- [Architect](../roles/architect.md)
- [OpenClaw SME](../roles/openclaw-sme.md)

## Trigger

Checkpoint 1: Idea Approved

The Product Manager periodically scans `/roadmap/ideas/` for unprocessed approved ideas.

## Orchestration

1. [Idea triage](../tasks/idea-triage.md)
2. [Capability decomposition](../tasks/capability-decomposition.md)
3. [OpenClaw capability review](../tasks/openclaw-capability-review.md)
4. [Implementation exploration](../tasks/implementation-exploration.md)
5. [Risk and cost assessment](../tasks/risk-and-cost-assessment.md)
6. [Product proposal generation](../tasks/product-proposal-generation.md)
7. [Proposal review package assembly](../tasks/proposal-review-package-assembly.md)
8. Present the package for leadership review.

Supporting activities when needed:

- [Concept mock request](../tasks/concept-mock-request.md) for higher-fidelity proposal mockups
- [Architecture sanity check](../tasks/architecture-sanity-check.md) for the single-pass architect review before final presentation

## Outputs

- [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md)
- [Proposal decision](../../schemas/artifacts/planning/proposal-decision.template.md)
- [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md)
- architecture commentary
- optional audio brief

## Loops and Decisions

- Design and architecture feedback loop through proposal revision before a final leadership decision.
- Approval creates `features/<feature-name>/` and advances the work into the feature lifecycle.
- Revision requested loops back into proposal refinement.
- Rejection closes the proposal unless leadership starts a new idea in intake.
- `staged_for_manual_design` keeps the proposal active without advancing it to a feature.

## Checkpoint

Checkpoint 2: Product Proposal Decision

