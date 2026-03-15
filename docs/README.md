# Documentation

## 1. Documentation System Overview

This repository uses a simple documentation split:

- `docs/` contains shared system documentation
- `roadmap/` contains planning artifacts
- `features/` contains approved feature lifecycle artifacts
- `governance/` contains lifecycle and governance documentation
- `schemas/` contains canonical artifact and state schema definitions
- `reference/` contains concise technical reference material
- `platform/` contains the living capability registry
- `archive/` contains historical documentation

The delivery lifecycle is:

```text
Idea
  -> Proposal (planning in roadmap/)
  -> Approved Feature (features/)
  -> Feature Project (features/<feature>/projects/<project>/)
  -> Platform deliverables (services, skills, plugins, core)
  -> Feature documentation (docs/features/)
```

Platform items are technical deliverables.
Feature documentation describes the user-facing capability built from those deliverables.

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
governance/      Governance and lifecycle documentation
schemas/         Canonical artifact and state schemas
reference/       Technical reference material
platform/        Living platform registry

docs/
  audits/        Audit reports and unresolved architecture notes
  features/      User-facing feature documentation built from platform deliverables
  overview/      High-level system architecture and overview docs
  operations/    Operator workflows and CLI usage
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
- Checkpoint

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

Approved feature lifecycle artifacts and feature project work.

### Governance

Location:

```text
governance/
```

Purpose:

Lifecycle rules, role definitions, workflow models, and SDLC policies.

### Schemas

Location:

```text
schemas/
```

Purpose:

Canonical artifact, state, and context model definitions.

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
- User-facing capability docs: [Feature Documentation](features/README.md)
- Vocabulary and definitions: [Concepts](concepts/README.md)
- Operator: [Operations](operations/README.md)
- Governance and lifecycle rules: [Governance](../governance/README.md)
- Canonical artifact and state formats: [Schemas](../schemas/README.md)
- Technical lookup: [Reference](../reference/README.md)
- AI assistant bootstrap: [AI Context](ai-context/README.md)
- architecture audit and unresolved drift: `audits/`

Recommended reading path:

1. [Community](community/README.md)
2. [Overview](overview/README.md)
3. [Concepts](concepts/README.md)
4. [Operations](operations/README.md)
5. [AI Context](ai-context/README.md)
