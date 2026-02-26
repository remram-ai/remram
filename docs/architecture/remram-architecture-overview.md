# Remram Architecture Overview

## 1\. What Remram Is

Remram is a local-first memory substrate for AI systems.

It provides:

*   Persistent, organized long-term memory across users and domains
*   Deterministic retrieval (RAM)
*   Controlled consolidation and mutation (REM)

Remram is not a chatbot and not a model.  
It is the system layer that makes memory real.

---

## 2\. The Core Thesis

Foundation models are stateless.  
Context windows are temporary.

“Infinite memory” is not solved by bigger models.

Memory is an orchestration problem.

Remram solves it by enforcing:

*   Structured storage
*   Policy gating
*   Deliberate retrieval
*   Controlled consolidation

---

## 3\. High-Level Topology

Remram is implemented as a four-layer system:

1.  **moltbox** — hardware control plane (local appliance)
2.  **remram-os** — orchestration layer (OpenClaw integration + skills)
3.  **remram-recall** — **RAM** (retrieval / read path)
4.  **remram-encode** — **REM** (consolidation / write path)

Cloud cognition remains optional and stateless.

---

## 4\. Component Roles

### 4.1 Moltbox (Local Control Plane)

Moltbox is the hardware environment that runs Remram.

It owns:

*   Local deployment and configuration
*   OpenSearch runtime
*   Local routing model runtime
*   Persistent artifact storage

Moltbox makes the system sovereign by default.

---

### 4.2 remram-os (Orchestration)

`remram-os` integrates OpenClaw with Remram’s memory layers.

It is responsible for:

*   Request routing
*   Tool schema enforcement
*   Context budget management
*   Calling RAM for retrieval
*   Calling REM for mutation
*   Escalation decisions (cloud cognition or user clarification)

`remram-os` does not own memory.

---

### 4.3 remram-recall (RAM — Read Path)

`remram-recall` retrieves memory safely and deterministically.

It is responsible for:

*   Policy-gated hybrid retrieval (filters + sparse + dense)
*   Rank feature scoring
*   Confidence scoring
*   Context bundle assembly

RAM does not mutate memory.

---

### 4.4 remram-encode (REM — Write Path)

`remram-encode` consolidates and mutates memory under policy.

REM operates as a two-layer system:

**Baseline Encode Routine** (post-request)

*   Updates relevant context chunks
*   Extracts obvious durable facts
*   Stages low-confidence changes

**Dream Machine** (nightly)

*   Reviews staged updates
*   Reconciles conflicts
*   Updates artifacts
*   Promotes high-confidence knowledge
*   Prunes noise / staleness
*   Refreshes embeddings in batch
*   Escalates low-confidence changes to the user

REM refines memory.

---

## 5\. Data and Control Flow

### 5.1 Request Flow (Online)

1.  User request arrives at `remram-os`
2.  `remram-os` determines memory needs and calls RAM
3.  RAM returns a context bundle + confidence signals
4.  `remram-os` executes tools and/or escalates to cognition when required
5.  A Baseline Encode pass runs to stage memory updates

### 5.2 Consolidation Flow (Offline)

1.  Dream Machine runs on a schedule (typically nightly)
2.  Staged updates are reviewed and reconciled
3.  Artifacts are updated (diff + reconcile)
4.  Facts are promoted/demoted under policy
5.  Low-confidence changes generate user clarification prompts

---

## 6\. Memory Model (Summary)

Remram distinguishes between:

*   **Facts**: atomic, confidence-scored, versioned
*   **Artifacts**: mutable documents/files stored on disk with indexed pointers
*   **Chunks**: retrieval units derived from artifacts and conversations

Promotion path:

Artifact → Extracted Fact → Structured Knowledge → Skill

---

## 7\. System Invariants

Remram maintains the following invariants:

*   RAM never mutates memory
*   REM never serves live queries
*   Memory policy gates eligibility
*   Vectors are ranking signals, not truth
*   Context bundles remain small and deliberate
*   Cloud cognition is stateless and replaceable

---

## 8\. What Comes Next

Immediate build sequence:

1.  Define OS ↔ RAM interface contract
2.  Define OS ↔ REM interface contract
3.  Implement RAM retrieval baseline
4.  Implement Baseline Encode staging
5.  Implement Dream Machine consolidation loop

Architecture becomes executable through contracts.