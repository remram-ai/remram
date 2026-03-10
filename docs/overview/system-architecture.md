# System Architecture

Remram is best understood as a layered ecosystem rather than a single codebase.

The active shape is intentionally split so each layer can own a different kind of authority.

## Top-Level Layers

### Gateway / Moltbox

This layer runs the runtime and infrastructure.

It is the local authority boundary for live execution. It owns sessions, routing, runtime operations, and the appliance posture around the system.

This is also where the control-plane idea becomes concrete: the system needs a governed local surface for running the runtime, operating shared services, and iterating on tooling without blurring authority.

### Orchestration

This layer shapes how runs are executed.

It decides how context is assembled, when escalation is appropriate, how policies are enforced, and how the system uses its available models and tools.

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

## Control Plane vs Cognition Plane

One of the newer ways to understand the system is as a split between local control and on-demand cognition.

The control plane:

- owns execution
- owns routing
- owns tool invocation
- gates escalation
- remains local and inspectable

The cognition plane:

- performs deeper reasoning when needed
- receives curated bundles rather than raw system state
- remains replaceable and stateless relative to durable memory

This matters because the system should not collapse into a single opaque model loop.

## Authority Boundaries

The architecture only works if a few boundaries stay clear:

- the runtime owns execution
- orchestration owns run-shaping policy
- Cortex owns long-term knowledge
- the app owns presentation and interaction
- agents provide reusable capability, not global authority
- remote cognition does not own local memory or runtime state

## Why This Matters

Without these boundaries, systems drift toward one of two failures:

- a runtime that tries to become a full knowledge system
- a memory layer that tries to become a shadow runtime

Remram tries to avoid both.
