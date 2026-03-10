# Family AI

## Project Overview

Family AI is a personal AI infrastructure project designed to give our family full control over context, learning, creativity, and intelligent systems.

At its core, Family AI is about ownership:

- Ownership of memory and context
- Ownership of development pipelines for the kids
- Ownership of experimentation
- Ownership of long‑term AI relationships

Rather than relying on public assistants or closed platforms, Family AI creates a private, always‑available environment where specialized AI systems support family life, education, making, and product development.

The system is built around a simple architectural principle:

**Local control. On‑demand cognition. Structured memory.**

A local orchestration node (“Moltbox”) handles interaction, routing, prompt compilation, tools, and memory. Cloud or appliance cognition tiers are invoked only when deeper reasoning, coding, or image generation is required.

This creates a cloud‑like experience while preserving local agency and sovereign memory.

---

## Core Architectural Insight: Memory Is Engineered, Not Magical

Family AI treats memory as an engineered substrate, not an emergent property of models.

Three distinct layers operate together:

1. **Memory Policy Layer (Structured Memory)**
   - Facts (atomic, versioned, confidence‑scored)
   - Artifacts (documents, charters, files)
   - Behavioral profiles (agent configuration)
   - Ownership and privacy boundaries

2. **Vector Layer (Similarity Engine)**
   - Embeddings attached to chunks
   - Dense vector similarity for proximity scoring
   - Used only as a ranking signal, never as authority

3. **Context Assembly Layer (RAG Operation)**
   - Hard filters applied first
   - Hybrid retrieval (filters + sparse + dense)
   - Snippet selection (1–2k token cap)
   - Structured bundle construction for model execution

Vector search does not define truth.
Memory policy defines eligibility.
RAG assembles evidence.

---

## Prompt Compilation as Infrastructure

Family AI centralizes prompt engineering inside the router.

Humans speak naturally.
The router compiles structured prompts for downstream models.

The router acts as a **prompt compiler**, responsible for:

- Intent classification
- Scope detection
- Query expansion (adjacent concept reasoning)
- Context injection
- Output schema enforcement
- Token budget discipline

Family members do not need to be prompt engineers.
The system absorbs that responsibility.

---

## Living Documents & Memory Compaction

Artifacts (e.g., project charters) evolve continuously.

Family AI separates:

- Mutable source documents
- Derived chunked retrieval units
- Stable extracted facts

After any artifact update:

1. Semantic diff is computed
2. Durable facts are reconciled
3. Updated sections are re‑chunked (strategy‑specific)
4. Embeddings are refreshed in batch
5. Rank features are recalibrated

This prevents memory entropy and keeps retrieval evergreen.

Chunking is policy‑driven, not vector‑driven.
Embeddings represent chunks; they do not create them.

---

## Core Goals

1. Regain control over personal and family context management
2. Create development pipelines for Asher and future projects
3. Give the whole family unlimited access to specialized AI
4. Build a shared family lab for learning and experimentation
5. Build useful skills that help the family (shopping list manager, financial assistant, stock portfolio management...)
6. Enable generational AI by eventually giving grandparents terminals
7. Establish a long‑term foundation for creative, educational, and entrepreneurial work

Family AI is not a chatbot.
It is an operating environment.

---

## Primary Use Cases

### Family AI

A private family assistant that:

- Answers questions
- Retrieves photos and memories
- Maintains long‑term family context
- Preserves advice, stories, and values
- Enables future memory playback and conversational inheritance

This becomes a living family knowledge system rather than disposable chat history.

---

### Asher Coding & Youth AI Studio

A safe local environment for:

- Game development
- Sprite and asset creation
- Learning to code with AI assistance
- Debugging and iteration

Moltbox handles orchestration and prompt compilation. Cognition tiers provide coding and image expertise when required. This creates a contained learning lab where experimentation is encouraged without exposure to public platforms.

---

### AI‑Native Product Development

Used as a living laboratory for:

- Agent workflows
- Context management
- Retrieval engineering
- Prompt compilation systems
- AI‑first product ideas

Family AI directly feeds broader AI‑native enterprise thinking.

---

## OpenClaw Overview

OpenClaw is the orchestration runtime that makes Family AI possible.

It provides:

- Agent routing
- Deterministic tool invocation
- Schema‑first execution
- Validation and retry logic
- Context handoff between tiers

Moltbox runs OpenClaw locally and owns execution. External cognition tiers are treated as stateless expert services.

OpenClaw enables:

1. Local models to act as routers instead of thinkers
2. Tools to be invoked safely and deterministically
3. Expert models to be called only when required
4. Results to be reintegrated into local workflows

This transforms AI from chat into infrastructure.

---

## System Architecture

### Moltbox – Local Control Plane

Responsibilities:

- Intent parsing
- Prompt compilation
- Tool routing
- Voice I/O
- Hybrid retrieval (filters + sparse + dense)
- Context assembly
- Schema enforcement (JSON discipline, validation, retries)
- Escalation decisions
- Background memory compaction

Optimized for latency, determinism, and memory sovereignty.

Explicitly not responsible for:

- Deep reasoning
- Long‑form planning
- Complex synthesis

Moltbox behaves like firmware: predictable, deterministic, and always available.

---

### Cognition Plane (Cloud or Appliance)

Responsibilities:

- Deep reasoning (“truth mode”)
- Long‑form planning
- Coding
- Image and sprite generation
- Deliberation for high‑impact decisions

Receives curated context bundles only.
Does not own memory.
Remains stateless.

---

## Escalation Rules (Control → Cognition)

Moltbox escalates only when at least one of the following is true:

- Task depth exceeds orchestration threshold
- Ambiguity is detected
- Confidence score is below threshold
- Long‑context synthesis is required
- Irreversible or high‑impact action is implied

Otherwise, execution remains local for speed and predictability.

---

## Memory Substrate (OpenSearch‑Backed)

OpenSearch serves as:

- Fact index
- Artifact index
- Embedding store (dense_vector)
- Ranking engine

Hybrid retrieval uses:

1. Hard filters (policy gate)
2. Sparse scoring (BM25)
3. Dense similarity (embeddings)
4. Rank features (recency, trust, usage)

Single query. Deterministic ordering. No recursive loops.

---

## Agents & Skills

Agents are specialized roles with shared memory:

- Orchestrator agent (routing + prompt compiler)
- Memory agent (fact reconciliation + compaction)
- Tool agents (filesystem, web, devices)
- Coding agent
- Image agent

Skills are composable behaviors layered on top of agents.

This modularity enables growth without architectural rewrites.

---

## Summary

Family AI is not a PC build.
It is not a chatbot.
It is not a single model.

It is a personal AI operating environment built on:

- Structured memory policy
- Hybrid retrieval
- Deterministic orchestration
- Prompt compilation
- Background compaction
- Sovereign context control

Instead of renting intelligence, we own it.
Instead of prompting models, we compile intent.
Instead of accumulating chat logs, we engineer memory.

This is the foundation layer for generational AI.

