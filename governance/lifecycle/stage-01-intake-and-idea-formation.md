# Stage 1 - Intake and Idea Formation

## Purpose

Convert a raw user request into a validated idea artifact that can enter the product evaluation pipeline. The goal is to clarify intent, explore possible solutions at a conceptual level, and confirm that the captured idea accurately reflects what the user wants.

## Responsible Role

Primary role: [Customer Success Manager](../roles/customer-success-manager.md)

The stage narrative identifies this role as being implemented by the Intake / Discovery agent.

## Supporting Roles

- [Designer](../roles/designer.md)

## Trigger

A user expresses a new idea, feature request, capability request, or workflow improvement.

Known intake sources from the stage narrative:

- direct user conversation
- support interaction
- internal product exploration

## Inputs

- raw user request
- discovery conversation with the user
- real usage scenarios
- success criteria
- feedback from prior review loops, when present

## Outputs

- [Idea document](../../schemas/artifacts/planning/idea-document.template.md) stored in `/roadmap/ideas/<idea>.md`
- [Concept materials](../../schemas/artifacts/design/concept-materials.template.md)
- [Audio brief](../../schemas/artifacts/design/audio-brief.template.md), when generated
- user review package
- idea status transitions such as `approved`, `cancelled`, or `pending-user`

## Execution Environment

The stage narrative does not add or change execution-environment rules beyond the existing system model.

## Core Tasks

1. [Pre-screen request](../tasks/pre-screen-request.md)
2. [Discovery interview](../tasks/discovery-interview.md)
3. [Use-case extraction](../tasks/use-case-extraction.md)
4. [Feature story generation](../tasks/feature-story-generation.md)
5. [Idea document synthesis](../tasks/idea-document-synthesis.md)
6. [Concept mock request](../tasks/concept-mock-request.md)
7. [Idea review package assembly](../tasks/idea-review-package-assembly.md)

## Detailed User Journey

### Step 1 - User expresses an idea

The process begins when a user shares an idea or problem they want solved. Requests may be vague or incomplete.

Example requests from the phase document:

- "I wish the system could automatically deploy agents when a new plugin is installed."
- "I want the CLI to show me the current task queue."

### Step 2 - Request Pre-Screening

The system classifies the request. Only feature requests proceed through the full intake workflow. Non-feature requests may be routed to another queue.

Known classifications from the phase document:

- `feature request`
- `bug report`
- `support question`
- `configuration change`
- `documentation request`

### Step 3 - Discovery Conversation

If the request is a feature idea, the Customer Success Manager runs a structured discovery conversation to understand the problem, capture real usage scenarios, and clarify success criteria.

Typical prompts from the phase document:

- "Can you walk me through a real example of when you would use this?"
- "What problem are you trying to solve?"
- "What should happen if the system succeeds?"
- "What should happen if it fails?"

### Step 4 - Use Case Extraction

The discovery conversation is converted into concrete workflows. Multiple workflows may be captured for one idea.

Example workflow from the phase document:

Workflow 1 - Automatic agent deployment

1. user installs a plugin
2. plugin registers a new capability
3. system detects capability
4. agent deployment is triggered

### Step 5 - Feature Story Generation

The workflows are translated into structured user stories so the idea stays framed in user-value terms.

Example format from the phase document:

As a developer
I want the system to automatically deploy agents when plugins are installed
So that new capabilities become available immediately

### Step 6 - Idea Document Creation

The discovery outputs are consolidated into the [Idea document](../../schemas/artifacts/planning/idea-document.template.md).

### Step 7 - Conceptual Mock Generation

A [Designer](../roles/designer.md) may generate conceptual representations such as UI wireframes, interaction storyboards, or workflow diagrams so the user can visualize the idea before deeper design begins.

### Step 8 - Idea Review Package

The system assembles a user review package that may include the idea summary, workflows, feature list, conceptual mockups, and an optional [Audio brief](../../schemas/artifacts/design/audio-brief.template.md) generated with the [Audio Brief Generator](../tools/audio-brief-generator.md).

### Step 9 - User Feedback Loop

If the user responds with changes or clarification questions, the discovery artifacts are updated and the review package is regenerated.

1. Capture the user's feedback.
2. Update the idea document.
3. Regenerate affected workflows, user stories, and feature list.
4. If needed, regenerate concept materials.
5. Re-present the updated review package.

This loop continues until the user confirms the idea is correct.

### Step 10 - Alternate Outcomes

Not all ideas proceed to approval. The stage may end in approval, cancellation, or pending-user inactivity.

## Artifacts Produced

Primary artifact:

- [Idea document](../../schemas/artifacts/planning/idea-document.template.md)

Supporting artifacts:

- [Concept materials](../../schemas/artifacts/design/concept-materials.template.md)

Optional artifacts:

- [Audio brief](../../schemas/artifacts/design/audio-brief.template.md)

Legacy source paths (historical reference only):
/product/ideas/<feature>.md  
/product/ideas/<feature>/brief.mp3  
/backlog/ideas/<feature>/concept/

Canonical repository paths:
/roadmap/ideas/<idea>.md  
/roadmap/ideas/<idea>/brief.mp3  
/roadmap/ideas/<idea>/concept/

## Exit Paths

### Approval

The idea is confirmed and enters the Stage 2 product evaluation queue.

The approved idea remains in `/roadmap/ideas/` and becomes the input artifact scanned by Stage 2.

When approved, `idea.status = approved`.

### Revision Loop

Feedback results in updated stage artifacts and a repeated review cycle.

### Cancellation

The idea is archived if the user decides it is no longer needed.

### Idle or No Response

If the user does not respond, the idea remains in `pending-user` until the conversation resumes.

## Checkpoint

Checkpoint 1: Idea Approved

