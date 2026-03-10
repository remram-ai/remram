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

- a runtime that owns execution
- a policy layer that shapes runs
- a knowledge layer that decides what should endure
- a user-facing layer that exposes the system without replacing its authority structure

## Why This Repository Exists

This repository is the community-facing orientation point for that ecosystem.

It exists to explain:

- the vision
- the conceptual architecture
- the role of each major repository
- how contributors should navigate the project

It intentionally avoids becoming the primary home for implementation specifics.
