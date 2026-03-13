# Documentation

## 1. Documentation System Overview

This repository uses a simple documentation split:

- `docs/` contains shared system documentation
- `features/` contains documentation for implemented capabilities
- `backlog/` contains ideas and proposed capabilities
- `archive/` contains historical documentation

Inside `docs/`, the material is organized into four primary areas:

- platform documentation
- system concepts
- reference material
- community and contributor documentation
- AI bootstrap context

Operational documentation also lives under `docs/` as its own layer so operator workflows and CLI usage stay separate from architecture and concepts.

## 2. Documentation Folder Map

```text
features/        Implemented product capabilities
backlog/         Idea backlog and proposed features

docs/
  platform/      System architecture and platform rules
  operations/    Operator workflows and CLI usage
  concepts/      Core system vocabulary and definitions
  reference/     Technical reference documentation
  community/     Contributor and community documentation
  ai-context/    High-signal AI bootstrap summaries and role guides

archive/         Historical documentation
```

## 3. Documentation Layers

### Platform Documentation

Location:

```text
docs/platform/
```

Purpose:

Describe the Moltbox platform architecture and system rules.

Typical topics:

- system overview
- repository taxonomy
- deployment models
- service topology

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
docs/reference/
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
- feature index
- role-specific AI guidance

### Features

Location:

```text
features/
```

Purpose:

Documentation for implemented system capabilities.

Each feature should have its own folder.

### Backlog

Location:

```text
backlog/
```

Purpose:

Contains ideas and proposed features that have not yet been implemented.

The backlog exists so ideas are preserved without cluttering the active architecture documentation.

### Archive

Location:

```text
archive/
```

Purpose:

Stores historical documentation and frozen reference material that should not be edited in place.

## 4. Quick Entry Points

- New contributor: [Community](community/README.md)
- Operator: [Operations](operations/README.md)
- Architecture/design work: [Platform](platform/overview.md)
- AI assistant bootstrap: [AI Context](ai-context/README.md)
