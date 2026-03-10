# What Is Remram?

Remram is an attempt to make AI systems more durable, more local-first, and more legible over time.

At the simplest level, Remram is about this question:

How should an AI system remember what matters without turning raw transcript history into the source of truth?

The answer is not just "more context."

Remram treats continuity as a systems problem. That means:

- memory should be structured
- retrieval should be bounded
- mutation should be governed
- long-lived knowledge should be separate from ephemeral session state
- local control should remain authoritative
- external cognition should remain replaceable

## What Remram Is Not

Remram is not:

- a foundation model
- a single application
- just a vector store
- just a chat history layer
- a replacement for runtime infrastructure like OpenClaw

It is a coordinated ecosystem built around durable knowledge and clear authority boundaries.

## The Core Shift

Many AI systems can answer.

Fewer can accumulate understanding without drifting.

Remram is designed around the idea that durable behavior comes from a layered system:

- a Moltbox runtime that owns live execution
- a Moltbox control plane that governs appliance mutation and operator tooling
- an OpenClaw layer that interprets intent and shapes runs
- a knowledge layer that decides what should endure
- a user-facing layer that exposes the system without replacing its authority structure

The control plane and OpenClaw are related, but they are not the same. One manages the appliance itself. The other manages live work.

## Local Control, On-Demand Cognition, Structured Memory

One useful shorthand for the project is:

Local control. On-demand cognition. Structured memory.

That means:

- the local system should own runtime and appliance authority
- stronger cognition should be invoked deliberately, not eagerly
- memory should be external, governed, and inspectable

That local control does not mean OpenClaw should have unrestricted system access. Governed appliance changes should flow through the Moltbox control plane.

## More Than Retrieval

Remram is not just about storing and retrieving context.

It is also about:

- memory policy deciding what is eligible
- similarity systems helping rank what is relevant
- prompt compilation turning user intent into bounded machine-ready context
- reflection and reconciliation deciding what should mature over time

In other words, Remram is trying to turn prompting and memory into system functions instead of informal habits.

## Why This Repository Exists

This repository is the community-facing orientation point for that ecosystem.

It exists to explain:

- the vision
- the conceptual architecture
- the role of each major repository
- how contributors should navigate the project

It intentionally avoids becoming the primary home for implementation specifics.
