# System Architecture

Remram is best understood as a layered ecosystem rather than a single codebase.

The active shape is intentionally split so each layer can own a different kind of authority.

## Top-Level Layers

### Gateway / Moltbox

This layer runs the runtime and infrastructure.

It is the local authority boundary for live execution. It owns sessions, routing, runtime operations, and the appliance posture around the system.

### Orchestration

This layer shapes how runs are executed.

It decides how context is assembled, when escalation is appropriate, how policies are enforced, and how the system uses its available models and tools.

### Cortex

This is the long-term knowledge system.

It owns retrieval, durable knowledge, reflection, reconciliation, and artifact promotion.

### App

This is the user-facing and operator-facing surface.

It turns the underlying system into a usable product experience without bypassing the authority structure underneath.

### Agents

This is the reusable agent and skill layer.

It provides composable building blocks that can be used across the ecosystem instead of burying behavior inside a single runtime or app.

## Authority Boundaries

The architecture only works if a few boundaries stay clear:

- the runtime owns execution
- orchestration owns run-shaping policy
- Cortex owns long-term knowledge
- the app owns presentation and interaction
- agents provide reusable capability, not global authority

## Why This Matters

Without these boundaries, systems drift toward one of two failures:

- a runtime that tries to become a full knowledge system
- a memory layer that tries to become a shadow runtime

Remram tries to avoid both.
