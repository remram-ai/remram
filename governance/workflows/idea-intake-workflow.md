# Idea Intake Workflow

## Purpose

Turn an incoming idea-oriented request into an approved idea artifact with supporting concept material before Stage 2 begins.

## Primary Role

[Customer Success Manager](../roles/customer-success-manager.md)

## Supporting Roles

- [Designer](../roles/designer.md)

## Trigger

A new idea, feature request, capability request, or workflow improvement enters intake from direct user conversation, support interaction, or internal product exploration.

## Orchestration

1. [Pre-screen request](../tasks/pre-screen-request.md) classifies the incoming request.
2. If the request is not a feature idea, route it to the appropriate queue and end this workflow.
3. [Discovery interview](../tasks/discovery-interview.md) captures the user's problem, scenarios, and success criteria.
4. [Use-case extraction](../tasks/use-case-extraction.md) turns the conversation into concrete workflows.
5. [Feature story generation](../tasks/feature-story-generation.md) reframes those workflows as user stories.
6. [Idea document synthesis](../tasks/idea-document-synthesis.md) creates the canonical idea artifact.
7. [Concept mock request](../tasks/concept-mock-request.md) produces conceptual visuals when they help validate the idea.
8. [Idea review package assembly](../tasks/idea-review-package-assembly.md) assembles the user-facing package, including an optional audio briefing.
9. Present the review package to the user and collect approval, requested changes, clarification questions, cancellation, or no response.

## Outputs

- [Idea document](../../schemas/idea-document.md)
- [Concept materials](../../schemas/concept-materials.md)
- [Audio brief](../../schemas/audio-brief.md), when generated
- review package

## Loops and Decisions

- Non-feature requests are routed out of the workflow after pre-screening.
- Feedback and clarification loop back through discovery artifacts and, when needed, concept regeneration.
- Approval sets `idea.status = approved` and advances to Stage 2.
- Cancellation archives the idea artifact.
- No response leaves the idea in `pending-user`.

## Checkpoint

Checkpoint 1: Idea Approved

