# Stage 2 - Product Evaluation and Proposal

## Purpose

Convert an approved idea into a formal product proposal and determine whether that proposal should become a feature.

This stage evaluates feasibility, platform alignment, risk, and product value. The output is a proposal package that leadership can review and decide on.

## Responsible Role

[Product Manager](../roles/product-manager.md)

## Trigger

Checkpoint 1: Idea Approved

Approved ideas enter the product evaluation queue from `/roadmap/ideas/`. The Product Manager periodically scans that queue for unprocessed ideas.

Stage 2 begins from:

- `/roadmap/ideas/<idea>.md`

Optional supporting artifacts may accompany the idea from Stage 1:

- `/roadmap/ideas/<idea>/concept/`
- `/roadmap/ideas/<idea>/brief.mp3`

## Inputs

- approved [Idea document](../../schemas/artifacts/planning/idea-document.template.md)
- workflows and user stories from stage 1
- optional [Concept materials](../../schemas/artifacts/design/concept-materials.template.md)
- optional [Audio brief](../../schemas/artifacts/design/audio-brief.template.md)
- current knowledge of existing OpenClaw and internal capabilities

## Outputs

- [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md) stored in `/roadmap/proposals/<proposal>/proposal.md`
- [Proposal decision](../../schemas/artifacts/planning/proposal-decision.template.md) stored in `/roadmap/proposals/<proposal>/decision.md`
- [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md) stored in `/roadmap/proposals/<proposal>/mockups/`
- optional [Audio brief](../../schemas/artifacts/design/audio-brief.template.md) stored in `/roadmap/proposals/<proposal>/brief.mp3`
- proposal review package for leadership

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
6. [Product proposal generation](../tasks/product-proposal-generation.md)
7. [Proposal review package assembly](../tasks/proposal-review-package-assembly.md)

## Supporting Activities

- [Concept mock request](../tasks/concept-mock-request.md) may be invoked when the Designer needs to create higher-fidelity proposal mockups.
- [Architecture sanity check](../tasks/architecture-sanity-check.md) may be invoked once before leadership review. This is a single-pass review, not the later full architecture phase.

## Detailed Workflow

### Step 1 - Idea Triage

The Product Manager reviews the approved idea artifact and verifies that the problem statement, workflows, and user stories are valid.

Goals:

- confirm the idea is well defined
- verify the idea is unique
- determine approximate scope

### Step 2 - Capability Decomposition

The idea is translated into platform-relevant components.

The Product Manager identifies which platform surfaces are involved:

- `/platform/core`
- `/platform/plugins`
- `/platform/services`
- `/platform/skills`
- `/platform/templates`

Questions considered:

- Does the feature require a new plugin?
- Does it require a skill?
- Does it require a service?
- Can existing components be configured to achieve the goal?

The output is a preliminary capability map.

### Step 3 - OpenClaw Capability Review

Before proposing new development, the Product Manager and [OpenClaw SME](../roles/openclaw-sme.md) check whether the capability already exists.

Sources include:

- OpenClaw core platform
- OpenClaw community plugins
- internal platform modules
- reference material under `/reference/openclaw/`, when available

This step prevents redundant development and helps identify extension points.

### Step 4 - Implementation Exploration

The Product Manager outlines one or more conceptual implementation approaches.

This includes identifying:

- required plugins
- required services
- required skills
- configuration changes
- integration points

This exploration remains conceptual, not detailed engineering design.

### Step 5 - Risk and Cost Assessment

The potential impact of the proposal is evaluated.

Factors considered:

- system risk
- cross-service impact
- infrastructure requirements
- operational cost
- token or compute consumption

### Step 6 - Mockup Development

[Designer](../roles/designer.md) support may be requested to create higher-fidelity proposal mockups through [Concept mock request](../tasks/concept-mock-request.md).

Artifacts are stored under:

- `/roadmap/proposals/<proposal>/mockups/`

### Step 7 - Proposal Artifact Creation

The Product Manager generates the formal proposal document.

Artifact location:

- `/roadmap/proposals/<proposal>/proposal.md`

The proposal follows the canonical structure in the [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md).

Before leadership review, the [Architect](../roles/architect.md) may perform the single-pass [Architecture sanity check](../tasks/architecture-sanity-check.md) described by the stage narrative.

### Step 8 - Decision Artifact Creation

A decision document is created to record leadership evaluation.

Artifact location:

- `/roadmap/proposals/<proposal>/decision.md`

The decision document records:

- proposal summary
- decision status
- decision rationale
- review participants

Possible status values:

- `pending`
- `approved`
- `revision_requested`
- `rejected`
- `staged_for_manual_design`

The decision document acts as the source of truth for approval status.

## Proposal Package

The complete proposal review package consists of:

- [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md)
- [Proposal decision](../../schemas/artifacts/planning/proposal-decision.template.md)
- [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md)

Optional supporting artifacts may include:

- [Architecture document](../../schemas/artifacts/design/architecture-document.template.md)
- [Audio brief](../../schemas/artifacts/design/audio-brief.template.md)

## Exit Paths

### Approval

Leadership approves the proposal and the proposal becomes a feature.

Feature created:

- `/features/<feature-name>/`

Source note: this stage narrative names the next step "Stage 3 - Feature Formation and Design," while the current lifecycle backbone still names Stage 3 as project formation. This documentation preserves that mismatch rather than inventing a new reconciliation.

### Revision Requested

Leadership requests proposal refinement. The Product Manager updates scope, implementation direction, design materials, or proposal framing, then re-presents the package.

### Reject

The proposal is declined.

The Product Manager may communicate feedback back through the [Customer Success Manager](../roles/customer-success-manager.md).

### Stage for Manual Design

Leadership may decide the proposal requires deeper collaborative design before approval.

In this path, the proposal remains active but does not advance to feature creation.

## Loops

### Design Iteration Loop

The proposal may loop through:

`proposal draft -> design exploration -> architecture feedback -> proposal revision -> leadership review`

### Revision Requested Loop

If leadership requests revision, the proposal loops through proposal revision, optional design updates, optional architect pass, and re-presentation.

## Checkpoint

Checkpoint 2: Product Proposal Decision

The proposal package becomes decision-ready when the proposal document, decision document, and any required supporting artifacts are assembled for leadership review.

