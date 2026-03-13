# Remram

Remram is the vision and architecture hub for the Remram ecosystem.

This repository explains what Remram is, why it exists, how the ecosystem fits together, and where contributors should go next. It is the public front door for the project, not the primary home for implementation details.

During the current documentation refactor, active repository documentation lives under `docs/`, implemented capability docs live under `features/`, idea backlog lives under `backlog/`, and historical material lives under `archive/`.

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
OpenClaw / Orchestration
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

Within Gateway / Moltbox, orchestration via OpenClaw and operator control are separate concerns. OpenClaw shapes live runs. The Moltbox control plane manages the appliance itself through CLI tools, tests, staged promotion, and human approval.

## Ecosystem Components

- **Remram**: vision, conceptual architecture, ecosystem map, contributor orientation
- **Remram Gateway**: OpenClaw runtime configuration, gateway operations, Moltbox CLI tooling, and appliance control-plane implementation
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

- [Documentation Map](docs/README.md)
- [Features](features/README.md)
- `backlog/ideas/` for unimplemented ideas and proposed capabilities
- `archive/` for historical documentation

## Backlog Pipeline

This repository preserves early ideas under:

- `backlog/ideas/`

Historical context and superseded planning material remain in `archive/`.

## How To Get Started

- Want to understand the current documentation system: start with [docs/README.md](docs/README.md)
- Want to understand implemented capabilities: start with [features/README.md](features/README.md)
- Want to review earlier material: use `archive/`

## How To Contribute

If you are changing vision, ecosystem framing, conceptual architecture, onboarding, or backlog docs, this is the right repository.

If you are changing runtime behavior, deployment, storage, APIs, or implementation details, you probably want one of the domain repositories instead.
