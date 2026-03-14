# Idea Intake Workflow

## Purpose

Turn an incoming feature request into an approved idea artifact with supporting concept material before the rest of the SDLC begins.

## Primary Role

[Intake and Discovery](../roles/intake-and-discovery.md)

## Supporting Roles

- [Designer](../roles/designer.md)

## Trigger

An incoming user request is classified as `feature_request`.

## Orchestration

1. [Pre-screen request](../tasks/pre-screen-request.md)
2. [Discovery interview](../tasks/discovery-interview.md)
3. [Use-case extraction](../tasks/use-case-extraction.md)
4. [Feature story generation](../tasks/feature-story-generation.md)
5. [Idea document synthesis](../tasks/idea-document-synthesis.md)
6. [Concept mock request](../tasks/concept-mock-request.md)
7. [Idea review package assembly](../tasks/idea-review-package-assembly.md)
8. Present the review package to the user.

## Outputs

- [Idea document](../artifacts/idea-document.md)
- [Concept materials](../artifacts/concept-materials.md)
- review package

## Loops and Decisions

- Feedback loops back through idea updates and, when needed, concept regeneration.
- Approval sets `idea.status = approved` and advances to Stage 2.
- Cancellation archives the idea artifact.
- No response leaves the idea in `pending-user`.

## Checkpoint

Checkpoint 1: Idea Approved
