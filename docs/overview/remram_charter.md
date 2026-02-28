# Remram Charter

## 1. Purpose

Remram exists to provide structured, persistent, long-term memory for AI systems.

It addresses a foundational limitation of modern AI stacks: models are stateless, context windows are temporary, and chat history is not memory.

Remram treats memory as an orchestration problem - not a model problem.

The system enforces continuity across users, domains, and time through deliberate retrieval and controlled consolidation.

---

## 2. Problem Statement

Modern AI systems:

- Repeat mistakes
- Lose corrected assumptions
- Drift across sessions
- Accumulate noisy state
- Rely on context window hacks

Increasing model size does not solve these issues.

Memory must be engineered.

---

## 3. Scope

Remram is responsible for:

- Structured memory storage
- Deterministic retrieval
- Policy-driven mutation
- Confidence-aware promotion
- Memory pruning
- Consolidation routines (REM)
- Context assembly (RAM)

Remram is not responsible for:

- Deep reasoning
- Large-model cognition
- Core chat orchestration runtime
- Business-domain logic

Those responsibilities belong to OpenClaw runtime surfaces and external cognition systems.

---

## 4. Architectural Principles

Explicit Read / Write Separation

- REM (encode) mutates memory
- RAM (recall) retrieves memory

Deterministic Orchestration
Retrieval and mutation must be policy-governed and predictable.

OpenClaw-Native Integration
Prefer OpenClaw extension points (config, skills, plugins, lifecycle hooks, automation) over standalone orchestration services.

Local-First Control
Memory ownership remains on hardware controlled by the user.

Policy-Driven Mutation
Memory evolves only through explicit promotion, reconciliation, and pruning rules.

Bounded Growth
Memory does not expand indefinitely. Consolidation and pruning are required behaviors.

---

## 5. System Boundaries

Remram operates within a three-surface system:

- `openclaw gateway` - orchestration runtime and control plane
- `remram extension layer` - RAM/REM behavior implemented through OpenClaw memory plugins, tools, hooks, and automation
- `moltbox` - local hardware control plane

External cognition systems (cloud or local models) are stateless services.
They do not own memory.

---

## 6. Non-Goals

Remram does not aim to:

- Replace foundation models
- Provide infinite memory through brute force
- Store unstructured chat logs indefinitely
- Hide architectural complexity behind prompt tricks

The goal is engineered continuity, not larger context windows.

---

## 7. Long-Term Vision

Remram becomes a reusable memory substrate that:

- Maintains identity across sessions
- Supports multi-user systems
- Enables generational knowledge continuity
- Reduces token waste
- Stabilizes AI behavior over time

Memory is infrastructure.
Remram is that infrastructure.
