# Remram

Remram is the vision and architecture hub for the Remram ecosystem.

This repository explains what Remram is, why it exists, how the ecosystem fits together, and where contributors should go next. It is the public front door for the project, not the primary home for implementation details.

Active repository documentation lives under `docs/`, strategic planning lives under `roadmap/`, approved feature lifecycle work lives under `features/`, Remram-owned architecture and runtime schemas live under `schemas/`, concise technical reference lives under `reference/`, the living capability registry lives under `platform/`, historical material lives under `archive/`, and Forge lifecycle governance plus lifecycle artifact schemas now live in [`remram-forge`](https://github.com/remram-ai/remram-forge).

## Repository Structure

- [roadmap/](roadmap/README.md): planning artifacts, including ideas and proposals
- [features/](features/README.md): approved feature lifecycle artifacts and implementation work
- [platform/](platform/README.md): the registry of active platform items
- [schemas/](schemas/README.md): Remram-owned architecture and runtime schema namespaces
- [Forge Governance](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md): lifecycle, governance, and orchestration documentation
- [Forge Schemas](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md): lifecycle artifact templates and orchestration state schemas
- [reference/](reference/README.md): concise technical reference material
- [docs/](docs/README.md): system documentation, architecture explanation, feature documentation, operations, and AI context
- [archive/](archive/): preserved historical material

## Delivery Lifecycle

```text
Idea (Stage 1, roadmap/ideas/)
  -> Proposal (Stage 2, roadmap/proposals/)
  -> Approved Feature (features/)
  -> Feature Project (Stage 3 onward, features/<feature>/projects/<project>/)
  -> Platform deliverables (services, skills, plugins, core)
  -> Feature documentation (docs/features/)
```

Platform items are technical deliverables.
Feature documentation describes the user-facing capability built from those deliverables.

The chronological lifecycle definitions live under [Forge Governance Lifecycle](https://github.com/remram-ai/remram-forge/blob/main/governance/lifecycle/README.md).

## Release Posture

For the appliance repositories, `main` describes the next appliance release.

Tagged revisions are the release inputs that an appliance should run in steady state.

In practice:

- repository `main` is the next-release integration line
- an appliance host is a tagged release until it is intentionally updated
- `moltbox gateway update` applies whatever revision the configured host checkout points at, so release appliances should pin that checkout to the intended tag or release branch

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
   Moltbox Gateway
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

Remram Skills sit alongside the system as reusable skills,
plugin packages, and workflow building blocks.
```

Within Gateway / Moltbox, orchestration via OpenClaw and operator control are separate concerns. OpenClaw shapes live runs. The Moltbox control plane manages the appliance itself through CLI tools, tests, staged promotion, and human approval.

## Ecosystem Components

- **Remram**: vision, conceptual architecture, ecosystem map, contributor orientation
- **Moltbox Gateway**: control-plane implementation, Moltbox CLI tooling, deployment orchestration, and appliance operations
- **Remram Cortex**: long-term knowledge system, retrieval, reflection, and memory services
- **Remram App**: user-facing APIs and applications
- **Remram Skills**: reusable skills, plugin packages, and portable capability building blocks

## Repository Links

- [Remram](https://github.com/remram-ai/remram)
- [Remram Forge](https://github.com/remram-ai/remram-forge)
- [Moltbox Gateway](https://github.com/remram-ai/moltbox-gateway)
- [Remram Cortex](https://github.com/remram-ai/remram-cortex)
- [Remram App](https://github.com/remram-ai/remram-app)
- [Remram Skills](https://github.com/remram-ai/remram-skills)

## Start Here

- [Documentation Map](docs/README.md)
- [Roadmap](roadmap/README.md)
- [Features](features/README.md)
- [Platform Registry](platform/README.md)
- [Forge Governance](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- [Forge Schemas](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md)
- [Schemas](schemas/README.md)
- [Reference](reference/README.md)
- [Feature Documentation](docs/features/README.md)
- [AI Context](docs/ai-context/README.md)
- `archive/` for historical documentation

## Planning Pipeline

This repository preserves lifecycle artifacts under:

- `roadmap/ideas/` for Stage 1 idea capture
- `roadmap/proposals/` for Stage 2 proposal development
- `features/` once proposal approval creates an active feature

Use [Roadmap](roadmap/README.md) for the planning directories, [Forge Governance Lifecycle](https://github.com/remram-ai/remram-forge/blob/main/governance/lifecycle/README.md) for the stage definitions, and [Features](features/README.md) for the implementation-facing feature structure.

Historical context and superseded planning material remain in `archive/`.

## How To Get Started

- Want to understand the current documentation system: start with [docs/README.md](docs/README.md)
- Want a fast AI-assistant bootstrap: start with [docs/ai-context/README.md](docs/ai-context/README.md)
- Want to understand planning and lifecycle layout: start with [roadmap/README.md](roadmap/README.md), [features/README.md](features/README.md), and [platform/README.md](platform/README.md)
- Want the end-to-end SDLC path from idea to implementation: read [roadmap/README.md](roadmap/README.md), [Forge Governance Lifecycle](https://github.com/remram-ai/remram-forge/blob/main/governance/lifecycle/README.md), [features/README.md](features/README.md), and [Forge Schemas](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md) for artifact templates
- Want user-facing capability docs once the deliverables exist: use [docs/features/README.md](docs/features/README.md)
- Want governance and lifecycle rules: use [Forge Governance](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- Want canonical architecture and runtime schemas: use [schemas/README.md](schemas/README.md)
- Want concise command or endpoint lookup: use [reference/README.md](reference/README.md)
- Want to review earlier material: use `archive/`

## How To Contribute

If you are changing vision, ecosystem framing, conceptual architecture, onboarding, roadmap docs, or platform registry docs, this is the right repository.

If you are changing runtime behavior, deployment, storage, APIs, or implementation details, you probably want one of the domain repositories instead.
