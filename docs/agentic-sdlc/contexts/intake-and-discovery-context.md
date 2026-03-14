# Intake and Discovery Context

## Load This Context When

The current project is in [Stage 1 - Intake and Idea Formation](../lifecycle/stage-01-intake-and-idea-formation.md).

## Primary Goal

Turn the incoming request into an approved idea artifact with enough clarity for stage 2 triage.

## Required Inputs

- current user conversation
- current request classification
- draft or active [Idea document](../artifacts/idea-document.md), if it already exists
- existing [Concept materials](../artifacts/concept-materials.md), if this is a feedback loop

## Focus Areas

- classify the request correctly
- clarify intent through discovery
- keep workflows, stories, and feature list aligned
- regenerate concept materials when the user changes the experience

## Gate Conditions

Advance only when the idea document exists, concept mock exists, review package has been sent, and the user confirms accuracy.

## Runtime Notes

- OpenClaw execution environment
- default local Ollama routing with escalation for stronger synthesis when needed
