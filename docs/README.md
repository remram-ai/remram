# Documentation

## 1. Documentation System Overview

This repository uses a simple documentation split:

- `docs/` contains shared system documentation
- `roadmap/` contains planning artifacts
- `features/` contains approved feature records plus local enhancement and project artifacts
- `remram-forge/governance/` contains private internal lifecycle and governance documentation
- `schemas/` contains Remram-owned architecture and runtime schema namespaces
- `remram-forge/schemas/` contains private internal lifecycle artifact templates and orchestration state schemas
- `reference/` contains concise technical reference material
- `platform/` contains the living capability registry
- `archive/` contains historical documentation

Public architecture, approved feature records, and active platform capability docs still live here in `remram`. The private Forge repo only owns the internal lifecycle pipeline and lifecycle-owned contracts.

## Moltbox / Gateway Authority Rule

For current Moltbox appliance behavior, treat `moltbox-gateway` as the authority.

That includes:

- the live CLI contract
- operator workflows
- service inventory
- Gateway/OpenClaw lifecycle
- snapshot and recovery posture
- Gateway-focused AI bootstrap context

Start there:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Gateway Docs](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox Service Catalog](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/service-catalog.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)

The local `docs/operations/`, `docs/overview/`, `docs/concepts/`, and `docs/ai-context/` pages now keep only high-level summaries and pointers for the Moltbox appliance domain.

The delivery lifecycle is:

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

For the SDLC routing itself, the canonical navigation path is:

1. [Roadmap](../roadmap/README.md)
2. [Forge Governance Lifecycle (private)](https://github.com/remram-ai/remram-forge/blob/main/governance/lifecycle/README.md)
3. [Features](../features/README.md)
4. [Forge Artifact Templates (private)](https://github.com/remram-ai/remram-forge/blob/main/schemas/artifacts/README.md)

Inside `docs/`, the material is organized into several primary areas:

- overview documentation
- feature documentation
- system concepts
- community and contributor documentation
- AI bootstrap context

Operational documentation also lives under `docs/` as its own layer so operator workflows and CLI usage stay separate from architecture and concepts.

## 2. Documentation Folder Map

```text
roadmap/         Ideas and proposals
features/        Approved feature lifecycle artifacts
schemas/         Remram-owned architecture and runtime schemas
remram-forge/    Private internal lifecycle governance and lifecycle artifact schemas
reference/       Technical reference material
platform/        Living platform registry

docs/
  audits/        Audit reports and unresolved architecture notes
  features/      User-facing feature documentation built from platform deliverables
  overview/      High-level system architecture and overview docs
  operations/    Operator workflows and CLI usage
  testing/       Validation plans and contract-focused test documentation
  concepts/      Core system vocabulary and definitions
  community/     Contributor and community documentation
  ai-context/    High-signal AI bootstrap summaries and role guides

archive/         Historical documentation
```

## 3. Documentation Layers

### Overview

Location:

```text
docs/overview/
```

Purpose:

Describe the Moltbox and RemRam architecture at a high level.

### Audits

Location:

```text
docs/audits/
```

Purpose:

Capture architecture audits, unresolved drift, and follow-up decisions that should not be guessed into the canonical docs.

Typical topics:

- system overview
- repository taxonomy
- deployment models
- service topology

### Feature Documentation

Location:

```text
docs/features/
```

Purpose:

Describe completed or usable user-facing capabilities assembled from multiple platform deliverables.

Typical topics:

- what a feature does
- how it is enabled
- which platform items it depends on
- deployment steps
- user workflow
- operational notes

### Operations

Location:

```text
docs/operations/
```

Purpose:

Operator-focused documentation describing how to run and manage the system.

Typical topics:

- CLI usage
- operator workflows
- runtime operations

### Testing

Location:

```text
docs/testing/
```

Purpose:

Validation plans and repeatable verification workflows for documented platform contracts.

Typical topics:

- CLI contract validation
- release gating
- cross-repo verification plans

### Concepts

Location:

```text
docs/concepts/
```

Purpose:

Define the canonical vocabulary used throughout the project.

Typical topics:

- Feature
- Plugin
- Skill
- Service
- Runtime
- Gateway
- Snapshot

These documents should be short conceptual explanations.

### Reference

Location:

```text
reference/
```

Purpose:

Pure technical reference documentation.

Typical topics:

- CLI reference
- API endpoints

Reference documents should be factual and concise.

### Community Documentation

Location:

```text
docs/community/
```

Purpose:

Documentation for contributors and developers.

Typical topics:

- getting started
- contributing guidelines
- development workflow
- repository setup

### AI Context

Location:

```text
docs/ai-context/
```

Purpose:

Fast-start context for AI assistants working in or around the repository.

Typical topics:

- system overview
- CLI model summary
- topology summary
- repository taxonomy
- platform item index
- role-specific AI guidance

### Roadmap

Location:

```text
roadmap/
```

Purpose:

Strategic planning artifacts, including ideas and proposals.

### Features

Location:

```text
features/
```

Purpose:

Approved feature records plus local enhancement and feature project work.

### Governance

Location:

```text
remram-forge/governance/
```

Purpose:

Lifecycle rules, role definitions, workflow models, and SDLC policies.

### Schemas

Location:

```text
schemas/
```

Purpose:

Canonical Remram-owned schema namespaces and shared machine-readable definitions.

Forge-owned lifecycle templates and orchestration state contracts live in:

```text
remram-forge/schemas/
```

### Platform Registry

Location:

```text
platform/
```

Purpose:

Documentation for active platform items and capability bundles.

### Archive

Location:

```text
archive/
```

Purpose:

Stores historical documentation and frozen reference material that should not be edited in place.

## 4. Quick Entry Points

- New contributor: [Community](community/README.md)
- Architecture/design work: [Overview](overview/overview.md)
- Repository boundary rules: [Repository Authority Rules](overview/repository-authority-rules.md)
- User-facing capability docs: [Feature Documentation](features/README.md)
- Vocabulary and definitions: [Concepts](concepts/README.md)
- Operator: [Operations](operations/README.md)
- Validation plans: [Testing](testing/README.md)
- Governance and lifecycle rules: [Forge Governance (private)](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- Canonical schemas and namespace routing: [Schemas](../schemas/README.md)
- End-to-end SDLC flow: [Roadmap](../roadmap/README.md), [Forge Governance Lifecycle (private)](https://github.com/remram-ai/remram-forge/blob/main/governance/lifecycle/README.md), [Features](../features/README.md), [Forge Artifact Templates (private)](https://github.com/remram-ai/remram-forge/blob/main/schemas/artifacts/README.md)
- Technical lookup: [Reference](../reference/README.md)
- AI assistant bootstrap: [AI Context](ai-context/README.md)
- architecture audit and unresolved drift: `audits/`

Recommended reading path:

1. [Community](community/README.md)
2. [Overview](overview/README.md)
3. [Concepts](concepts/README.md)
4. [Operations](operations/README.md)
5. [Testing](testing/README.md)
6. [AI Context](ai-context/README.md)
