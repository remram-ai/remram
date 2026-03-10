# Overview Context

## Purpose

Remram is the conceptual and orientation layer for an ecosystem that treats AI continuity as a systems problem, not as a prompt-length problem. The core idea is durable knowledge under clear authority boundaries: live execution stays local and governed, stronger cognition is invoked deliberately, and long-lived memory is handled as a structured subsystem rather than raw transcript accumulation. This repository explains that architecture and points contributors toward the repository that should own a given kind of work.

## Core Responsibilities

- Define why Remram exists: AI systems lose corrections, repeat mistakes, and rely on oversized prompts when continuity is not engineered.
- Describe the layered architecture: App -> Gateway / Moltbox -> OpenClaw / orchestration -> Cortex, with Agents as reusable capability that can be shared across layers.
- Preserve the project charter: local-first authority, bounded retrieval, governed mutation, replaceable cognition, and durable artifacts.
- Explain ecosystem direction without claiming everything is already implemented. Strategic themes include family-scale memory, guided building, research and briefing, durable human-facing artifacts, and structured creation workflows.
- Provide contributor orientation and backlog shaping so conceptual work is clarified before implementation is pushed into a domain repository.

## Ecosystem Relationships

The ecosystem is intentionally split by authority.

- Gateway / Moltbox is where the local appliance becomes operational and where runtime and operator responsibility meet.
- OpenClaw is the live orchestration layer. It interprets requests, compiles prompts, chooses tools, and shapes bounded runs.
- Cortex is the long-term knowledge layer. It owns retrieval, reflection, reconciliation, and artifact promotion.
- App turns these capabilities into user-facing and operator-facing product surfaces without bypassing the layers below.
- Agents provide reusable skills, modules, and workflow logic that should remain composable instead of being buried inside a single app or runtime.
- This repository remains the map, charter, and orientation point tying those parts together.

## What Does Not Belong Here

- Runtime implementation details, deployment procedures, and gateway configuration.
- Deep storage, retrieval, or memory-service internals.
- App-specific APIs, screens, and product implementation.
- Agent package implementation.
- Detailed operational runbooks for domain systems.

## Orientation Rules For AI Agents

- Treat transcript history as an input, not the durable source of truth.
- Keep runtime authority, control-plane authority, orchestration, and knowledge authority separate.
- Prefer the repository that owns implementation over expanding this repository into an implementation manual.
- Use this repository to understand the ecosystem shape first, then move into the appropriate domain repository for code or operational detail.
