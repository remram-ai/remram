# Contributor Context

## Purpose

This repository is the conceptual front door for the Remram ecosystem. Contributors should use it to understand the project vision, the layered architecture, the domain boundaries, and the backlog pipeline before they start changing implementation. The goal is to keep conceptual framing, contributor orientation, and ecosystem mapping clear here while pushing code, runtime details, and subsystem internals into the repositories that actually own them.

## How To Navigate The Ecosystem

Start in this repository when you need to answer these questions:

- Why does Remram exist?
- What is each layer responsible for?
- Which repository should own a change?
- Is this idea still conceptual, or is it ready for implementation work?

Use the domain repositories when the work is implementation-facing:

- `remram-gateway` for runtime behavior, deployment, Moltbox operations, control-plane implementation, and gateway docs.
- `remram-cortex` for memory internals, retrieval behavior, reflection, reconciliation, and durable knowledge services.
- `remram-app` for user-facing APIs, apps, and operator product surfaces.
- `remram-agents` for reusable skills, modules, and shared workflow logic.

## Contribution Model

The preferred pattern is:

1. Clarify the concept here.
2. Identify the authority boundary and owning repository.
3. Move implementation work into the correct domain repository.
4. Keep the conceptual docs aligned with the ecosystem shape.

This repository also keeps the backlog pipeline visible:

- `backlog/ideas/` for early concepts.
- `backlog/products/` for shaped proposals that are clearer and closer to implementation.

That pipeline exists to help ideas mature before they fragment across implementation repos.

## What Belongs In This Repository

- Vision and public framing.
- Conceptual architecture.
- Ecosystem explanation and repository boundaries.
- Onboarding and contributor guidance.
- Backlog ideas and product proposals.

## What Does Not Belong Here

- Runtime APIs, deployment instructions, or gateway implementation details.
- Memory-service internals and retrieval implementation.
- App implementation, screens, or product code.
- Reusable agent package implementation.
- Deep technical specs that are detached from ecosystem context.

## Working Heuristic

If you are changing the meaning of the system, the map of the ecosystem, or the conceptual boundary between layers, work here first. If you are changing how a subsystem actually runs, stores, serves, or ships, move to the repository that owns that subsystem.
