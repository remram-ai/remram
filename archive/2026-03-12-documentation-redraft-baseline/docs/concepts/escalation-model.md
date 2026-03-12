# Escalation Model

Remram assumes that not every task should be solved in the same way.

Some work should stay local. Some work should use stronger external models. Some work should become asynchronous or agent-driven.

## The Basic Idea

Escalation is not failure.

It is the system deciding that a different path is more appropriate for the task.

It should be deliberate, inspectable, and bounded.

## Common Escalation Paths

- use a stronger model
- ask the user for clarification
- dispatch a longer-running workflow
- defer work into a background process

## Conceptual Rules

- the local system should prefer staying local when it is competent to do so
- deterministic tool paths should not be mixed casually with heuristic escalation
- escalation should happen before the system collapses into prompt sprawl
- remote cognition should receive curated bundles, not raw dumps of local state

One useful shorthand is:

route or escalate, not both.

The system should avoid drifting into a hybrid state where the local runtime half-solves a task, then hands an incoherent mess upward.

## What Triggers Escalation Conceptually

Typical triggers include:

- ambiguity that remains unresolved
- task depth that exceeds the local orchestration tier
- context pressure or bundle overflow
- irreversible or high-impact action
- repeated schema or tool failures

## What Escalation Is Not

Escalation is not:

- a license to dump all memory into a larger model
- a substitute for good retrieval and prompt compilation
- a replacement for reflection or consolidation
- an excuse to let the cognition tier become the runtime authority

## Why This Is Conceptual Here

This repository describes the idea of escalation and why it matters.

Detailed implementation of model routing, OpenClaw hooks, tool selection, and policy logic belongs in the implementation repositories.
