# Remram RAM Spec (Recall Engine)

This document specifies the behavior and guarantees of the RAM layer (`remram-recall`).

RAM is responsible for deterministic, policy-gated memory retrieval and context assembly.

It is the read path of the system.

---

## 1\. Design Goals

*   Deterministic retrieval
*   Strict policy gating before ranking
*   Token-bounded context bundles
*   Confidence-aware selection
*   Predictable latency under load

RAM must be boring, fast, and correct.

---

## 2\. Retrieval Pipeline

Every RAM query follows the same ordered pipeline.

### Step 1 — Policy Gate (Hard Filters)

Before scoring:

*   Scope enforcement (user / household / shared)
*   Domain eligibility
*   Artifact/fact type filters
*   Privacy restrictions

If an item fails policy, it is never scored.

---

### Step 2 — Candidate Set Construction

RAM builds a candidate set using:

*   Keyword search (BM25)
*   Embedding similarity
*   Structured facet matching (int8 facet space)

The goal is recall breadth without token explosion.

---

### Step 3 — Hybrid Scoring

Final ranking combines:

*   Dense vector similarity
*   Sparse keyword relevance
*   Rank features:
    *   confidence
    *   recency
    *   usage frequency
    *   provenance trust
    *   domain overlap score

Vectors are a ranking signal.  
Facets and policy define relevance.

---

### Step 4 — Context Assembly

RAM assembles a context bundle with:

*   Top-N facts
*   Top-N chunks (hierarchical aware)
*   Optional artifact summaries (L0 level)

Assembly rules:

*   Respect token budget
*   Prefer breadth over redundant depth
*   Avoid near-duplicate chunks
*   Maintain deterministic ordering

Output includes confidence metadata.

---

## 3\. Input Contract

RAM receives:

*   user\_id
*   request\_text
*   intent classification (optional)
*   domain hints (optional)
*   token budget
*   retrieval mode (standard / deep)

---

## 4\. Output Contract

RAM returns:

*   context\_bundle\[\]
*   fact\_list\[\]
*   artifact\_refs\[\]
*   aggregate\_confidence\_score
*   retrieval\_trace (optional debug mode)

No mutation occurs.

---

## 5\. Hierarchical Chunk Handling

RAM respects chunk hierarchy:

*   Prefer L1/L2 chunks for concept grounding
*   Use L0 summaries when broad context needed
*   Avoid injecting full artifacts

Chunk adjacency may be expanded within bounded limits.

---

## 6\. Performance Targets

For baseline Moltbox tier:

*   \<150ms median retrieval latency
*   \<300ms p95 under light concurrency

Under load, RAM must degrade gracefully without violating policy.

---

## 7\. Failure Modes and Guardrails

*   If retrieval confidence is low → flag to OS
*   If token budget exceeded → deterministic truncation
*   If OpenSearch unhealthy → return degraded minimal context

RAM never fabricates context.

---

## 8\. Invariants

*   RAM never mutates memory
*   RAM never bypasses policy gate
*   Retrieval ordering is reproducible
*   Token budgets are enforced before return

RAM retrieves deliberately.