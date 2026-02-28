# Remram Memory Model 

Remram provides long-term, structured memory for AI systems by separating:

*   **Operational Retrieval (Chunks + Hybrid Search)**
*   **Canonical Truth (Normalized Entities & Facts)**
*   **Mutation Log (Append-Only Change Ledger)**
*   **Consolidation Engine (REM / Dream Routine)**
*   **Versioned Artifacts (Git-backed)**
*   **Policy & Scope Layer**

This revision clarifies:

*   Git’s role in canonical artifacts
*   The Memory Update Log as a first-class component
*   Human correction surfaces
*   Chunk-first ingestion
*   Cloud-assisted consolidation
*   Separation of live memory from document synthesis

---

# 1\. Memory Layers

## 1.1 Transient Working Memory (Session Layer)

Short-lived, prompt-bounded context.

Includes:

*   Last N turns
*   Retrieved chunk bundle
*   Active plan
*   Temporary reasoning artifacts

Never authoritative.  
Never canonical.  
Never durable.

Session compaction affects prompts only.

---

## 1.2 Episodic Memory (Chunk Retrieval Layer)

Append-only chunk store indexed in OpenSearch.

Properties:

*   Hierarchically chunked
*   Scoped
*   May contradict
*   Provenance-linked
*   Optimized for recall

Episodic memory supports:

*   Context rehydration
*   Evidence traceability
*   Partial matching

It is not truth.

---

## 1.3 Canonical Memory (Normalized Truth Layer)

Structured, deduplicated knowledge.

Stores:

*   Facts (atomic statements)
*   Entity records
*   Policies
*   Confidence tiers
*   Status flags

Properties:

*   Deduplicated
*   Conflict-aware
*   Scoped
*   Deterministic
*   Token-minimized

Canonical memory is authoritative for answers.

---

## 1.4 Mutation Log (Memory Update Log)

Append-only structured delta store.

Each entry contains:

```
{
  "mutation_id": "...",
  "timestamp": "...",
  "source_session_id": "...",
  "entity_ids_touched": ["..."],
  "facts_added": ["..."],
  "facts_modified": ["..."],
  "facts_removed": ["..."],
  "artifact_refs": ["..."],
  "confidence_score": 0.81,
  "conflict_flags": ["..."],
  "consolidated": false
}
```

Purpose:

*   Dream Routine input
*   Audit trail
*   Reversibility
*   Human review
*   Drift detection

The log is not retrieval memory.  
It is a change feed.

---

## 1.5 Versioned Artifacts (Git Layer)

Canonical documents are versioned in Git.

Examples:

*   Project charters
*   Domain summaries
*   Architecture docs
*   Consolidated reports

Dream Routine:

*   Rewrites artifacts
*   Commits changes
*   Generates diff summary
*   Preserves version history

Git does not store:

*   Retrieval chunks
*   Raw logs
*   OpenSearch indices

Git versions:

*   Human-readable canonical state

---

## 1.6 Skills (Derived Behavioral Layer)

Reusable behavioral rules derived from canonical memory.

Examples:

*   "When user says ‘the game’, default to preferred team."
*   "Streaming-first preference."

Skills are computed artifacts.  
Not raw memory.

---

# 2\. Core Data Structures

## 2.1 Facts (Atomic Truth)

Minimal durable statements.

```
{
  "fact_id": "...",
  "subject": "...",
  "attribute": "...",
  "value": "...",
  "scope": "...",
  "confidence": 0.82,
  "provenance": ["..."],
  "status": "active | contradicted | deprecated",
  "version": 3,
  "created_at": "...",
  "updated_at": "..."
}
```

Facts are optimized for low-token injection.

---

## 2.2 Entities (Collection-Based Model)

Avoid namespace explosion.

Small number of entity types.  
Unlimited instances.

Core types:

*   person
*   project
*   domain
*   subscription
*   asset
*   policy
*   document
*   event
*   obligation
*   preference

Entities store attributes.  
Facts may reference entities.

---

## 2.3 Chunks (Retrieval Units)

Indexed in OpenSearch.

```
{
  "chunk_id": "...",
  "owner_scope": "...",
  "memory_type": "episodic | artifact | policy | evidence",
  "entity_type": "...",
  "level": 1,
  "text": "...",
  "embedding": "...",
  "recency_score": 0.72,
  "confidence": 0.83
}
```

Embeddings rank only.  
Never define truth.

---

# 3\. Scope Model (Isolation First)

Scope gating precedes ranking.

Scopes:

*   person:
*   household:
*   org:
*   venture:
*   domain:

Default eligibility:

*   requester scope
*   household scope

Expansion requires explicit signal.

Prevents context bleed.

---

# 4\. Retrieval Pipeline

1.  Scope Filter (hard gate)
2.  Status Filter (active only)
3.  Structured Filters (entity\_type, domain, category)
4.  Sparse Match (BM25)
5.  Dense Similarity (embedding)
6.  Rank Features:
    *   recency decay
    *   confidence weight
    *   usage frequency
    *   provenance quality
7.  Optional Re-rank (local or cloud)

Context bundle remains token-bounded.

---

# 5\. Two-Phase Memory Update Model

## Phase 1 — Immediate Encode (Local Model)

After each session:

Local model produces:

*   Structured chunk updates
*   Candidate facts
*   Entity changes
*   Confidence score

Writes to:

*   Episodic chunk index
*   Canonical fact store (staged)
*   Mutation Log (append-only)

Low-confidence facts flagged.

---

## Phase 2 — Dream Routine (Nightly or On-Demand)

Input:

*   Unconsolidated mutation log entries
*   Current canonical artifacts

Process:

*   Cross-entity reconciliation
*   Conflict resolution
*   Deduplication
*   Artifact redrafting
*   Confidence recalibration
*   Embedding refresh if needed

Output:

*   Updated canonical entities
*   Updated artifacts (Git commit)
*   Consolidated log entries

Dream never blocks live queries.

---

# 6\. Human-in-the-Loop Dashboard

Expose fact mutations as tiles.

Each tile displays:

*   Entity
*   Fact statement
*   Operation type
*   Confidence
*   Conflict flag
*   Source

Controls:

*   Approve
*   Edit
*   Reject

Low-confidence highlighted.

Rejected facts:

*   Logged
*   Not promoted

Prevents silent drift.

---

# 7\. Mind Map + Domain Navigation

UI layer organizes:

Domain → Project → Artifact → Facts

Thread creation requires domain binding.

Mind map enables:

*   Visual scoping
*   Cross-link discovery
*   Artifact navigation

Folder tree supports:

*   Deterministic navigation
*   Search precision

---

# 8\. Storage Architecture

OpenSearch:

*   chunk index
*   fact index
*   entity index
*   rank features

Structured Store:

*   canonical entities
*   canonical facts
*   policies
*   mutation log

Git:

*   versioned canonical artifacts

Disk:

*   raw artifacts

OpenClaw integration model:

*   Memory is exposed through a memory slot plugin (`plugins.slots.memory`)
*   Recall is served through memory tools (`memory_search`, `memory_get`)
*   Encode/consolidation is executed via lifecycle hooks + scheduled automation

---

# 9\. Invariants

*   Embeddings rank; metadata governs
*   Scope gating precedes ranking
*   Canonical store is authoritative
*   Mutation log is append-only
*   Git versions artifacts only
*   Episodic memory may contradict
*   Canon reconciles
*   Consolidation prevents entropy
*   Context bundles remain bounded

---

# 10\. Next Steps

Define:

*   Memory slot plugin contract and tool schemas
*   Canonical Store schema
*   Lifecycle hook contracts for Baseline Encode and transcript sanitization
*   Consolidation thresholds
*   Retrieval scoring weights
*   Scope expansion policy

This is where Remram becomes executable.
