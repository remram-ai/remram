# Model Strategy & Memory Architecture
## Family AI (API‑First, Memory‑Centric)

---

## 1. Architectural Principle

Local-first orchestration with sovereign memory, and cloud cognition as a replaceable utility layer.

Moltbox (AM4 + 128GB RAM) operates as the system’s control plane:

- OpenClaw agent runtime
- Context routing and retrieval
- Tool execution
- Memory promotion
- Policy and escalation
- Artifact storage pointers

Cognition (reasoning, coding, generation) is accessed via APIs and may later be replaced by dedicated hardware without changing architecture.

---

## 2. Model Roles

### Orchestrator (Local, 8–14B)

Responsibilities:
- Intent classification
- Retrieval query construction
- Tool routing
- Schema‑compliant execution
- Escalation decisions

Requirements:
- Deterministic JSON output
- Strong tool discipline
- Low hallucination under constraint
- Low latency

Context target: small to medium, retrieval-first.

Failure modes:
- Schema drift
- Incorrect tool choice
- Escalation loops

Runs locally to preserve responsiveness and execution sovereignty.

---

### Reasoning / Thinking (API Tier)

Responsibilities:
- Multi-step planning
- Long-horizon synthesis
- Complex family logistics
- Strategic coding decisions

Latency tolerance: seconds.

Context: curated bundles only.

Triggered by:
- Planning complexity
- Low retrieval confidence
- Repeated local failures

---

### Coding (API Tier Primary)

Responsibilities:
- Multi-file edits
- Refactors
- Debugging
- Test generation

Context:
- Repository map
- Selected files
- Tool feedback

All file writes are mediated by OpenClaw.

---

### Image & Sprite Generation

- SDXL or similar locally when feasible
- API generation for heavier workloads

Sprite pipelines use ComfyUI with:
- Seed locking
- Versioned workflows
- Reference conditioning

---

### Embeddings

Used strictly for semantic similarity.

Primary role: assist context routing, not reasoning.

Must be:
- Stable
- Low latency
- Deterministic
- Tenant aware

---

## 3. OpenSearch as Context Router

OpenSearch serves as a multidimensional relevance engine.

It combines:
- Structured filters
- Rank features
- Embedding similarity

Vectors are only one signal.

### Layer 1 — Hard Filters

Exact fields:
- person
- audience
- category
- content_type
- privacy_scope
- safety_level
- time_scope
- source_type
- confidence
- human_verified

Used to eliminate irrelevant memory.

---

### Layer 2 — Rank Features

Soft scoring fields:
- recency
- usage_frequency
- trust_score
- family_priority
- curriculum_level
- project_affinity

These shape relevance before generation.

---

### Layer 3 — Embeddings

Used only to determine conceptual proximity.

---

## 4. Facts vs Artifacts

### Facts

Stored directly as OpenSearch documents.
Injected directly into model context.

### Artifacts

Stored on disk.
OpenSearch holds pointers plus metadata and embeddings.

The orchestrator decides whether to dereference.

---

## 5. Memory Promotion

Artifacts may promote into facts through:
- Repeated access
- High confidence
- Human approval

Promotion path:

Artifact → Extracted Fact → Structured Knowledge → Skill

All promotions preserve provenance.

---

## 6. Retrieval Flow

1. Local intent classification
2. Dimension selection
3. OpenSearch query (filters + ranking + vector)
4. Top‑N inspection
5. Context bundle assembly
6. Optional API escalation

Memory never flows directly to cognition without filtering.

---

## 7. Context Strategy

Context is role-specific:

- Orchestrator: short + retrieved snippets
- Reasoning: curated evidence bundles
- Coding: repo map + selected files

Full memory dumps are avoided.

---

## 8. Quantization Strategy

Role-based:

- Orchestrator: Q4_K_M or Q5_K_M
- Reasoning/Coding APIs: provider precision
- Future hardware: FP8 or W8A8
- Embeddings: prioritize stability
- Image models: FP16/BF16

Quantization choices are evaluated by tool reliability, not raw speed.

---

## 9. Layered Memory Architecture

### Working Memory

Ephemeral prompt + tool results + retrieval.

### Session Memory

Structured JSON summaries with provenance.

### Long-Term Family Memory

Tenant-separated OpenSearch indexes with promotion gates.

### Skill Memory

Versioned executable workflows.

### Code Memory

Separate index with semantic chunking.

---

## 10. Escalation Policy Engine

API escalation is triggered by:

- Multi-file coding
- Planning depth
- Low retrieval confidence
- Tool retry thresholds
- Context overflow

The system tracks:
- Token usage
- Cost per task
- Escalation frequency

Hardware acquisition becomes a data-driven optimization.

---

## 11. Failure Modes & Guardrails

Schema drift:
- JSON validation
- bounded retries

Stale embeddings:
- versioned fields
- scheduled reindexing

Memory contamination:
- provenance
- confidence scores
- tenant isolation

Skill compromise:
- sandboxed tools
- signed workflows

Context overflow:
- role-specific context targets
- retrieval bundles
- no global long-context scaling

---

## 12. Reference Architecture

Schema drift:
- JSON validation
- bounded retries

Stale embeddings:
- versioned fields
- scheduled reindexing

Memory contamination:
- provenance
- confidence scores
- tenant isolation

Skill compromise:
- sandboxed tools
- signed workflows

---

## 12. Reference Architecture

Family Clients
→ OpenClaw Gateway
→ Moltbox (Orchestrator + OpenSearch + Artifact Store)
→ Cognition APIs (Reasoning / Coding / Image)

Hardware cognition can later replace APIs without architectural change.

---

## 11. Orchestrator Model Guidance

### Qwen3-8B (Primary Local Router)

Default local orchestrator. Run with thinking disabled. Optimized for tool routing, JSON compliance, and low-latency intent classification. Native ~32k context; long-context scaling should only be enabled per-session when explicitly required.

Key operational notes:
- Prefer retrieval + summarization over raw context growth.
- Quantize at Q4_K_M or Q5_K_M and select the variant that minimizes tool-schema retries.
- Treat this model strictly as a router, not a problem-solver.

### Qwen2.5-14B (Reliability Upgrade Option)

Use when Qwen3-8B shows schema drift under heavy tool usage. Provides stronger structured output and routing stability at the cost of latency. Suitable as a drop-in replacement if orchestration reliability becomes the bottleneck.

### Llama 3.1 8B

Not recommended as primary orchestrator due to documented instability when combining conversation + tool definitions. May be used for isolated chat or zero-shot tool calls only.

### GLM Flash-Class Models

High-performance agent models with excellent capability-per-latency, but require fragile inference stacks. Consider only for remote cognition or experimentation, not always-on local routing.

---

## 12. Quantization and Precision Strategy

Quantization is role-specific:

- Local orchestrator: Q4_K_M or Q5_K_M (optimize for schema reliability over speed)
- Future hardware reasoning/coding: FP8 or W8A8 preferred
- INT4 reserved for capacity-driven scenarios only
- Embeddings: prioritize stability
- Image models: FP16/BF16

Quantization quality is evaluated by:
- Tool retry rate
- JSON validity
- Routing accuracy

Not by raw tokens/sec.

---

## 13. Escalation Heuristics

Escalate to API cognition when any of the following occur:

- Multi-file coding or refactoring
- Long-horizon planning (curriculum, projects, logistics)
- Low retrieval confidence
- Tool schema retry threshold exceeded
- Context window pressure

Escalation decisions are logged with:
- Trigger reason
- Token cost
- Latency

This data feeds hardware break-even analysis.

---

## 14. Phased Implementation

### Phase 1
- Local orchestrator
- Tool contracts
- OpenSearch schema
- Fact/artifact separation

### Phase 2
- Reasoning + coding APIs
- Escalation metrics

### Phase 3
- Image + sprite workflows
- ComfyUI pipelines

### Phase 4
- Family memory ingestion
- Promotion gates

### Phase 5
- Token economics
- Hardware break-even logic

---

This document defines a memory-centric AI operating environment where context ownership, deterministic orchestration, and modular cognition enable long-term family-scale intelligence.

