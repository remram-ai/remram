# Remram

Remram is the vision and architecture hub for the Remram ecosystem.

This repository explains what Remram is, why it exists, how the ecosystem fits together, and where contributors should go next. It is the public front door for the project, not the primary home for implementation detail.

## What Problem Remram Solves

AI systems still struggle with continuity.

They lose important context across sessions, repeat corrected mistakes, depend on oversized prompts, and confuse transcript history with durable knowledge. Remram exists to turn that fragile memory posture into a more disciplined system: local control remains authoritative, cognition is invoked deliberately, retrieval is bounded, mutation is governed, and long-lived knowledge is treated as a first-class architectural concern.

## High-Level Architecture

Remram is easiest to understand as a small ecosystem of cooperating layers:

```text
People and clients
        |
        v
   Remram App
        |
        v
Remram Gateway / Moltbox
        |
        v
  Remram Orchestration
        |
        v
   Remram Cortex
        |
        v
 Durable knowledge, artifacts,
 and long-term memory behavior

Remram Agents sit alongside the system as reusable skills,
agent modules, and workflow building blocks.
```

## Ecosystem Components

- **Remram**: vision, conceptual architecture, ecosystem map, contributor orientation
- **Remram Gateway**: OpenClaw runtime configuration, gateway operations, and Moltbox appliance deployment
- **Remram Cortex**: long-term knowledge system, retrieval, reflection, and memory services
- **Remram App**: user-facing APIs and applications
- **Remram Agents**: reusable skills, agent modules, and agent-facing building blocks

## Repository Links

- [Remram](https://github.com/remram-ai/remram)
- [Remram Gateway](https://github.com/remram-ai/remram-gateway)
- [Remram Cortex](https://github.com/remram-ai/remram-cortex)
- [Remram App](https://github.com/remram-ai/remram-app)
- [Remram Agents](https://github.com/remram-ai/remram-agents)

## Start Here

- [What Is Remram?](docs/overview/what-is-remram.md)
- [Project Charter](docs/overview/project-charter.md)
- [System Architecture](docs/overview/system-architecture.md)
- [Ecosystem Map](docs/overview/ecosystem-map.md)
- [Strategic Direction](docs/overview/strategic-direction.md)
- [Control Plane](docs/concepts/control-plane.md)
- [Prompt Compilation](docs/concepts/prompt-compilation.md)
- [Moltbox Community](moltbox/README.md)
- [Projects](docs/ecosystem/projects.md)
- [Repository Map](docs/ecosystem/repository-map.md)

## Backlog Pipeline

This repository also preserves the project pipeline:

- `backlog/ideas/` for early concepts
- `backlog/products/` for shaped product and system proposals

Those documents are intentionally kept here because they explain how ideas mature before they become implementation work in domain repositories.

## How To Get Started

- Want to understand the project: start with [docs/overview/what-is-remram.md](docs/overview/what-is-remram.md)
- Want to run something real today: start with [docs/getting-started/run-remram.md](docs/getting-started/run-remram.md)
- Want to contribute: start with [docs/getting-started/contribute.md](docs/getting-started/contribute.md)

## How To Contribute

If you are changing vision, ecosystem framing, conceptual architecture, onboarding, or backlog docs, this is the right repository.

If you are changing runtime behavior, deployment, storage, APIs, or implementation details, you probably want one of the domain repositories instead.
