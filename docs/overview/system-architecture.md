# System Architecture

Remram is best understood as a layered ecosystem rather than a single codebase.

The active shape is intentionally split so each layer can own a different kind of authority.

## Top-Level Layers

### Gateway / Moltbox

This layer runs the runtime and infrastructure.

It is where the local appliance becomes operational reality.

Within Gateway / Moltbox, two different concerns live side by side:

- the runtime surface, where live requests enter and execute
- the Moltbox control plane, where the appliance is inspected, tested, deployed, promoted, and recovered

That distinction matters. The runtime serves live work. The control plane manages Moltbox itself.

### OpenClaw / Orchestration

This is the live orchestration layer.

It decides how context is assembled, when escalation is appropriate, how policies are enforced, and how the system uses its available models and tools.

In the current ecosystem, OpenClaw is the clearest name for it.

It is not the same thing as the Moltbox control plane.

It also acts as a prompt compiler:

- interpreting intent
- assembling bounded context bundles
- selecting tools and model paths
- shaping machine-ready inputs from human requests

### Cortex

This is the long-term knowledge system.

It owns retrieval, durable knowledge, reflection, reconciliation, and artifact promotion.

Its internal logic should distinguish clearly between:

- memory policy
- similarity and ranking signals
- context assembly
- durable knowledge and artifact outputs

### App

This is the user-facing and operator-facing surface.

It turns the underlying system into a usable product experience without bypassing the authority structure underneath.

### Agents

This is the reusable agent and skill layer.

It provides composable building blocks that can be used across the ecosystem instead of burying behavior inside a single runtime or app.

## Moltbox Control Plane vs OpenClaw

The Moltbox control plane:

- manages Moltbox itself
- exposes operator CLI and bounded management tools
- governs deploy, test, staging, promotion, rollback, and recovery
- keeps appliance mutation behind explicit approvals and review surfaces

OpenClaw:

- handles live user and app requests
- assembles context and output contracts
- chooses tools and model paths
- decides when escalation is appropriate
- should not be treated as a raw machine-admin layer

This distinction exists to keep the system both useful and safe. OpenClaw may be able to ask the control plane to do work, but it should not simply become the control plane.

## Orchestration via OpenClaw vs Cognition

The orchestration layer, currently expressed through OpenClaw:

- owns live run shaping
- remains bounded and policy-driven
- prepares curated bundles for deeper work when needed

The cognition plane:

- performs deeper reasoning when needed
- receives curated bundles rather than raw system state
- remains replaceable and stateless relative to durable memory

This matters because the system should not collapse into a single opaque model loop.

## Authority Boundaries

The architecture only works if a few boundaries stay clear:

- the Gateway runtime owns live execution
- the Moltbox control plane owns appliance mutation and operator tooling
- the orchestration layer, currently embodied in OpenClaw, owns live run-shaping policy
- Cortex owns long-term knowledge
- the app owns presentation and interaction
- agents provide reusable capability, not global authority
- remote cognition does not own local memory or runtime state

## Why This Matters

Without these boundaries, systems drift toward one of two failures:

- a runtime that tries to become a full knowledge system
- a memory layer that tries to become a shadow runtime

Remram tries to avoid both.
