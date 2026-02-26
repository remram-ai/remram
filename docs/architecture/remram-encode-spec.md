# remram-encode Spec (REM)

This document specifies Remram’s consolidation system (“REM”), including the post-request Baseline Encode routine and the nightly Dream Machine.

The goal is to keep memory **current**, **coherent**, and **bounded** while minimizing user burden and preventing repeated mistakes.

---

## 1\. Design Goals

*   Keep memory up to date without waiting for nightly consolidation
*   Prevent low-confidence updates from silently corrupting memory
*   Consolidate staged updates into clean, versioned state
*   Maintain bounded growth via pruning and compaction
*   Keep retrieval reliable for the local router model
*   Produce a clear clarification loop for ambiguous changes

---

## 2\. System Overview

REM is a two-layer encode system:

1.  **Baseline Encode Routine** (immediate, lightweight)
2.  **Dream Routine** (scheduled, deep consolidation)

Baseline Encode keeps memory fresh.  
Dream Routine keeps memory correct.

---

## 3\. Inputs and Outputs

### 3.1 Inputs

*   Recent user requests and assistant outputs
*   Tool outputs (structured results)
*   Retrieved context bundles used during the request
*   User corrections and explicit preferences
*   Artifact edits (files changed on disk)

### 3.2 Outputs

*   Chunk updates (staged or committed)
*   Candidate facts with confidence scores
*   Artifact update proposals (diffs)
*   Promotion/demotion decisions
*   Pruning decisions
*   Clarification prompts for the user

---

## 4\. Baseline Encode Routine (Post-Request)

### 4.1 Trigger

Runs after each completed request (or after a tool execution chain), before the system returns to idle.

### 4.2 Budget

Designed to be fast and bounded:

*   Token-bounded
*   Time-bounded
*   No long recursive loops

### 4.3 Responsibilities

Baseline Encode performs a minimal, high-signal pass:

*   Identify which memory domains are touched
*   Update or create relevant context chunks
*   Extract obvious durable facts
*   Attach provenance pointers to sources
*   Assign confidence scores
*   Stage low-confidence mutations

### 4.4 Staging Model

Baseline Encode writes to a **Staging Layer**.

Rules:

*   High-confidence updates may be committed immediately
*   Low-confidence updates must be staged
*   Any update that changes an existing durable fact must be staged unless confidence is high

### 4.5 Output Artifacts

Baseline Encode produces:

*   `staged_chunk_updates[]`
*   `candidate_facts[]`
*   `staged_fact_mutations[]`
*   `artifact_touch_list[]`
*   `confidence_report`

---

## 5\. Dream Routine (Nightly Consolidation)

### 5.1 Trigger

Runs on schedule (typically nightly), and may also run on demand.

### 5.2 Model Tier

Dream Routine may use a larger offline-capable model for:

*   multi-document reconciliation
*   diff-aware artifact updates
*   conflict resolution
*   higher-quality summaries

The Dream Routine remains governed by policy and does not own memory.

### 5.3 Responsibilities

The Dream Routine performs structured consolidation:

*   Review staged updates and mutations
*   Detect contradictions with existing facts
*   Resolve conflicts using provenance and confidence
*   Compute semantic diffs for changed artifacts
*   Update artifacts (or generate patch proposals)
*   Promote durable facts
*   Demote or invalidate stale facts
*   Prune low-signal or superseded chunks
*   Refresh embeddings in batch
*   Recalibrate rank features (recency, trust, usage)

### 5.4 Consolidation Order

Recommended sequence:

1.  Validate staged updates
2.  Reconcile fact layer
3.  Reconcile artifact layer
4.  Re-chunk affected artifacts
5.  Refresh embeddings
6.  Recompute rank features
7.  Generate clarification prompts

---

## 6\. Clarification Loop (Morning Prompts)

Dream Machine must not silently commit low-confidence mutations.

Instead, it produces user-facing clarification prompts for:

*   ambiguous preferences
*   conflicting facts
*   uncertain artifact edits

### 6.1 Prompt Format

Each clarification prompt should include:

*   the proposed change
*   current state
*   confidence score
*   source/provenance summary
*   a short multiple-choice resolution path

### 6.2 Resolution Outcomes

User responses can:

*   approve the mutation
*   reject it
*   revise it
*   scope it (user-only vs household)

Resolutions feed back into the next encode cycle.

---

## 7\. Pruning Policy

REM enforces bounded growth.

Pruning candidates include:

*   stale chunks with no retrieval usage
*   superseded chunk versions
*   low-confidence facts never confirmed
*   redundant near-duplicate chunks

Pruning must preserve:

*   provenance history
*   conflict history
*   auditability of promotions/demotions

---

## 8\. Failure Modes and Guardrails

REM must be resilient to:

*   partial runs
*   interrupted schedules
*   model hallucinations
*   artifact corruption risk

Guardrails:

*   never overwrite artifacts without a diff/patch representation
*   keep previous versions or backups for artifact updates
*   separate staging from committed memory
*   require user confirmation for low-confidence durable changes

---

## 9\. Observability

REM should emit structured logs/metrics:

*   staged vs committed counts
*   promotions/demotions
*   pruning counts
*   average confidence scores
*   clarification prompts generated
*   embedding refresh batches

---

## 10\. Implementation Notes

REM is architecture, not a single job.

In practice it will be implemented as:

*   a small post-request encode hook
*   a scheduled consolidation workflow
*   a user-facing clarification queue

REM consolidates deliberately.