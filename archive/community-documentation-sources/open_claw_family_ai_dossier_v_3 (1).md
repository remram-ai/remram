# OpenClaw Family AI – Dossier V3

## Executive Summary

OpenClaw is a deterministic orchestration runtime designed to convert AI from conversational interface into infrastructure.

It separates:

- Control from cognition
- Memory policy from similarity search
- Prompt engineering from human interaction
- Retrieval from reasoning

OpenClaw runs locally on Moltbox and owns execution. External cognition tiers remain stateless expert services.

The system prioritizes:

- Determinism
- Memory sovereignty
- Token efficiency
- Inspectability
- Long-term architectural stability

---

## Core Architectural Principles

### 1. Deterministic Control Plane

OpenClaw enforces:

- Intent classification before execution
- Schema-first tool invocation
- Structured JSON discipline
- Validation and retry loops
- Explicit escalation rules

Local models act as routers and prompt compilers — not deep thinkers.

---

### 2. Memory Is Engineered, Not Emergent

Memory is not stored in model weights.
Memory is external, structured, and versioned.

Three layers define memory behavior:

#### Memory Policy Layer

Defines:

- Ownership boundaries
- Privacy scope
- Fact confidence
- Promotion / demotion logic
- Version reconciliation

#### Vector Layer

- Dense embeddings attached to retrieval units
- Used strictly for similarity scoring
- Never defines eligibility or truth

#### Context Assembly Layer (RAG Operation)

- Applies hard filters first
- Executes hybrid retrieval (sparse + dense + rank features)
- Selects top snippets (1–2k token cap)
- Assembles curated context bundles

Single query.
No recursive loops.
No vector-driven scope expansion.

---

### 3. Prompt Compilation as a System Function

Humans do not engineer prompts.
OpenClaw compiles intent into structured prompts.

Router responsibilities:

- Intent interpretation
- Scope detection
- Adjacent concept expansion (controlled)
- Context injection
- Output schema enforcement
- Token budget management

This transforms prompt engineering into infrastructure.

---

## Retrieval Model

Hybrid retrieval executes as a single OpenSearch query combining:

1. Hard filters (memory policy gate)
2. Sparse search (BM25)
3. Dense similarity (embedding field)
4. Rank features (recency, trust, usage, confidence)

Vector search narrows candidates.
Memory policy defines what is allowed.
Router defines when expansion is permitted.

Optional second-pass retrieval occurs only when:

- Confidence score is below threshold
- Ambiguity is detected
- Zero direct hits returned

Router initiates re-query.
Vector never initiates re-query.

---

## Living Document Pipeline

Artifacts are mutable.
Facts are stabilized derivatives.

After any artifact update:

1. Semantic diff is computed
2. Durable facts are extracted
3. Conflicts are reconciled
4. Updated sections are re-chunked (strategy-specific)
5. Embeddings refreshed in batch
6. Rank features recalibrated

Chunking is policy-driven.
Embeddings represent chunks — they do not create them.

This prevents memory entropy and keeps retrieval evergreen.

---

## Chunking Strategy Framework

Chunking is domain-aware and strategy-specific.

Examples:

- Project charters → section-based chunks
- Technical specs → subsystem-based chunks
- Policies → atomic rule chunks
- Conversations → sliding window chunks + fact extraction

Chunk boundaries determine retrieval precision.
Vector similarity only ranks existing chunks.

---

## Escalation Model

OpenClaw escalates to cognition tier only when:

- Task depth exceeds orchestration threshold
- Ambiguity cannot be resolved locally
- Confidence score is below threshold
- Long-context synthesis required
- High-impact irreversible action implied

Otherwise execution remains local.

Cognition tier receives curated bundles only.
Cognition tier does not own memory.

---

## Agent Model

Agents are specialized roles sharing the same substrate.

- Orchestrator Agent (router + prompt compiler)
- Memory Agent (fact extraction + reconciliation)
- Tool Agents (filesystem, web, devices)
- Coding Agent
- Image Agent

Behavioral traits (tone, verbosity, challenge level) are stored externally as structured agent profiles.

No behavioral memory is stored in base model weights.

---

## Model Weight Philosophy

Model weights are reserved for:

- General reasoning capability
- Domain adaptation when stable and high-frequency

LoRA or fine-tuning is considered only when:

- Behavioral patterns are stable
- Prompt overhead is large and repetitive
- Frequency justifies training cost

Router model remains weight-clean and stateless.

Knowledge memory remains external.

---

## System Objectives

OpenClaw ensures:

- Sub-second time-to-first-token on local router
- Deterministic routing
- Small, precise context bundles
- Sovereign memory control
- Inspectable reasoning pathways
- Controlled query expansion

This transforms AI from conversational assistant into governed infrastructure.

---

## Summary

OpenClaw V3 formalizes:

- Deterministic orchestration
- Hybrid retrieval with policy-first gating
- Prompt compilation as infrastructure
- Living document compaction pipeline
- Clear separation of memory, similarity, and reasoning

Vector is a scoring tool.
Router is the thinker.
Memory policy is the authority.

This architecture enables scalable, inspectable, and generational AI systems.

