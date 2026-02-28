# Remram Architecture Overview

## 1. What Remram Is

Remram is a local-first memory substrate for AI systems.

It provides:

- Persistent, organized long-term memory across users and domains
- Deterministic retrieval (RAM)
- Controlled consolidation and mutation (REM)

Remram is not a chatbot and not a model.
It is the system layer that makes memory real.

---

## 2. The Core Thesis

Foundation models are stateless.
Context windows are temporary.

"Infinite memory" is not solved by bigger models.

Memory is an orchestration problem.

Remram solves it by enforcing:

- Structured storage
- Policy gating
- Deliberate retrieval
- Controlled consolidation

---

## 3. High-Level Topology

Remram is implemented as OpenClaw extensions running on a local appliance:

1. **moltbox** - hardware control plane (local appliance)
2. **openclaw gateway** - orchestration runtime (routing, policy, sessions, tools)
3. **remram extensions** - RAM/REM behaviors implemented through OpenClaw config, skills, plugins, hooks, and automation

Cloud cognition remains optional and stateless.

---

## 4. Runtime Roles

### 4.1 Moltbox (Local Control Plane)

Moltbox is the hardware environment that runs Remram.

It owns:

- Local deployment and configuration
- OpenSearch runtime
- Local routing model runtime
- Persistent artifact storage

Moltbox makes the system sovereign by default.

---

### 4.2 OpenClaw Gateway (Orchestration Runtime)

OpenClaw is the control plane and orchestration runtime.

It is responsible for:

- Request routing (`agents.list` + `bindings`)
- Tool policy and schema enforcement
- Context/session lifecycle management
- Calling Remram memory tools through the active memory slot plugin
- Executing automation (hooks + cron + heartbeats)
- Escalation decisions (cloud cognition or user clarification)

OpenClaw does not own canonical memory; it hosts Remram memory behavior.

---

### 4.3 RAM (Read Path via OpenClaw Memory Plugin)

RAM retrieves memory safely and deterministically.

It is responsible for:

- Policy-gated hybrid retrieval (filters + sparse + dense)
- Rank feature scoring
- Confidence scoring
- Context bundle assembly

RAM is implemented as OpenClaw memory tools and does not mutate memory.

---

### 4.4 REM (Write Path via Hooks and Automation)

REM consolidates and mutates memory under policy.

REM operates as a two-layer system:

**Baseline Encode Routine** (post-request)

- Updates relevant context chunks
- Extracts obvious durable facts
- Stages low-confidence changes

**Dream Machine** (nightly)

- Reviews staged updates
- Reconciles conflicts
- Updates artifacts
- Promotes high-confidence knowledge
- Prunes noise / staleness
- Refreshes embeddings in batch
- Escalates low-confidence changes to the user

REM is implemented via post-request hooks, scheduled automation, and plugin services.

---

## 5. Data and Control Flow

### 5.1 Request Flow (Online)

1. User request arrives at OpenClaw Gateway
2. Gateway determines memory needs and calls RAM tools from the Remram memory slot plugin
3. RAM returns a context bundle + confidence signals
4. Gateway executes tools and/or escalates to cognition when required
5. A Baseline Encode hook runs to stage memory updates

### 5.2 Consolidation Flow (Offline)

1. Dream Machine runs on a schedule (typically nightly)
2. Staged updates are reviewed and reconciled
3. Artifacts are updated (diff + reconcile)
4. Facts are promoted/demoted under policy
5. Low-confidence changes generate user clarification prompts

---

## 6. Memory Model (Summary)

Remram distinguishes between:

- **Facts**: atomic, confidence-scored, versioned
- **Artifacts**: mutable documents/files stored on disk with indexed pointers
- **Chunks**: retrieval units derived from artifacts and conversations

Promotion path:

Artifact -> Extracted Fact -> Structured Knowledge -> Skill

---

## 7. System Invariants

Remram maintains the following invariants:

- RAM never mutates memory
- REM never serves live queries
- Memory policy gates eligibility
- Vectors are ranking signals, not truth
- Context bundles remain small and deliberate
- Cloud cognition is stateless and replaceable

---

## 8. What Comes Next

Immediate integration sequence:

1. Define OpenClaw config layout for agents, bindings, tool policy, hooks, and cron
2. Implement Remram memory slot plugin (`memory_search` / `memory_get`)
3. Implement Baseline Encode lifecycle hook and staging writes
4. Implement Dream Machine scheduled consolidation workflow
5. Add skills for operations/runbooks and guardrail policies

Architecture becomes executable through OpenClaw-native integration contracts.
