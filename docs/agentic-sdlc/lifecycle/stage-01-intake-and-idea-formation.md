# Stage 1 - Intake and Idea Formation

## Purpose

Transform an initial user request into a validated idea artifact with supporting concept material before the SDLC begins.

## Responsible Role

Primary execution role: [Intake and Discovery](../roles/intake-and-discovery.md)

## Trigger

An initial user request enters the system. Only requests classified as `feature_request` proceed through the full intake workflow.

## Inputs

- initial user request
- clarification conversation with the user
- scenario, example usage, expected behavior, edge cases, and success criteria gathered during discovery

## Outputs

- [Idea document](../artifacts/idea-document.md)
- [Concept materials](../artifacts/concept-materials.md)
- user review package
- idea status transitions such as `approved`, `cancelled`, or `pending-user`

## Supporting Roles

- [Designer](../roles/designer.md)

## Execution Environment

Runs inside OpenClaw.

Model routing from the workbook:

- default: local Ollama model
- escalation: stronger model for synthesis or concept generation

## Task Flow

1. [Pre-screen request](../tasks/pre-screen-request.md)
2. [Discovery interview](../tasks/discovery-interview.md)
3. [Use-case extraction](../tasks/use-case-extraction.md)
4. [Feature story generation](../tasks/feature-story-generation.md)
5. [Idea document synthesis](../tasks/idea-document-synthesis.md)
6. [Concept mock request](../tasks/concept-mock-request.md)
7. [Idea review package assembly](../tasks/idea-review-package-assembly.md)

## Loops

### Feedback Loop

If the user gives feedback instead of approval:

1. Capture the user's feedback.
2. Update the idea document.
3. Regenerate affected workflows, user stories, and feature list.
4. If the experience changes, call the designer recipe again to regenerate concept materials.
5. Re-present the updated review package.

This loop continues until the user approves, cancels, or leaves the idea pending.

## Exit Paths

### Approval

All of the following must be true:

- idea document created
- concept mock generated
- review package sent to the user
- user confirms accuracy

When approved:

- `idea.status = approved`
- the idea moves into the user task queue for triage

### Cancellation

If the user explicitly cancels the idea:

- mark the idea as cancelled
- move the artifact to `/backlog/archive/ideas/<feature-name>.md`
- optional metadata may include cancellation reason and conversation snapshot

### Idle or No Response

If the user does not respond after the review package is sent:

- keep the idea in an open or pending state
- optional behaviors may include reminder timing, automated follow-up, and inactivity tagging
- `idea.status = pending-user`

No later SDLC stage starts until the user approves or cancels.

## Checkpoint

Checkpoint 1: Idea Approved
