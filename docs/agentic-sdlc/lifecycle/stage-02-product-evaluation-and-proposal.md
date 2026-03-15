# Stage 2 - Product Evaluation and Proposal

## Purpose

Translate an approved idea into a concrete product proposal that defines what should be built, how it might be built, and what risks or costs are involved.

## Responsible Role

[Product Manager](../roles/product-manager.md)

## Trigger

Checkpoint 1: Idea Approved

Approved ideas enter the product evaluation queue from `/product/ideas/`. The Product Manager periodically scans that queue for unprocessed ideas.

## Inputs

- approved idea document
- workflows and user stories from stage 1
- [Concept materials](../artifacts/concept-materials.md)
- current knowledge of existing OpenClaw and internal capabilities

## Outputs

- [Product proposal](../artifacts/product-proposal.md)
- executive summary
- review package for leadership
- optional audio brief
- proposal status of approved, revision requested, or rejected

## Supporting Roles

- [Designer](../roles/designer.md)
- [Architect](../roles/architect.md)
- [OpenClaw SME](../roles/openclaw-sme.md)

## Task Flow

1. [Idea triage](../tasks/idea-triage.md)
2. [Capability decomposition](../tasks/capability-decomposition.md)
3. [OpenClaw capability review](../tasks/openclaw-capability-review.md)
4. [Implementation exploration](../tasks/implementation-exploration.md)
5. [Risk and cost assessment](../tasks/risk-and-cost-assessment.md)
6. [Architecture sanity check](../tasks/architecture-sanity-check.md)
7. [Product proposal generation](../tasks/product-proposal-generation.md)
8. [Proposal review package assembly](../tasks/proposal-review-package-assembly.md)

## Loops

### Design Iteration Loop

The workbook defines this loop:

`proposal draft -> design exploration -> architecture feedback -> proposal revision -> leadership review`

Leadership may approve, reduce scope, expand scope, or request redesign.

### Revision Requested Loop

If leadership requests revision, the Product Manager updates:

- scope
- architecture approach
- implementation strategy

The proposal then loops through proposal revision, optional design updates, architect pass, and re-presentation.

## Exit Paths

### Approval

The proposal is accepted as written.

Source note: the workbook says the project proceeds to "Feature Definition / Detailed Design," while the lifecycle backbone separately names Stage 3 as project formation and Stage 4 as architecture and solution design. This documentation preserves that mismatch rather than resolving it by invention.

### Revision Requested

The proposal remains active and loops through the revision path until leadership reaches a decision.

### Rejected

If the proposal is declined:

- mark the proposal as rejected
- close the idea
- leadership may suggest an alternate direction that starts a new idea through the customer success intake process

## Checkpoint

Checkpoint 2: Product Proposal Decision

The workbook also records the readiness state "Proposal Ready For Decision."
