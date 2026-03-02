# Durable Conversation Layer

**Attributes**

*   **Proposed Component Name (optional):** Durable Conversation Layer
*   **Layer:** Cortex
*   **Primary Surface / Agent:** /ingest, /retrieve
*   **Relevant Hook or Stage (if applicable):** agent\_end, before\_prompt\_build
*   **Dependencies (if any):** OpenClaw session model, Cortex knowledge schema, dimension registry

**Date:** 2026-03-01  
**Status:** Raw  
**One-liner:** Introduce a durable conversation object above OpenClaw sessions to enable cross-session continuity without duplicating transcripts.

---

## Opportunity / Problem

OpenClaw provides deterministic session continuity and transcript persistence. However, sessions are transport-scoped runtime groupings, not semantic containers. When sessions compact or reset, long-term conversational arcs fragment.

There is currently no native concept of a cross-session “thread” that:

*   Links multiple sessions over time
*   Preserves semantic trajectory
*   Enables intelligent resumption
*   Injects relevant historical context across years

Relying on transcripts alone couples semantic continuity to runtime compaction behavior. This limits long-term leverage.

---

## What It Does

The Durable Conversation Layer introduces a first-class **conversation object** in Cortex.

A conversation object:

*   Links multiple OpenClaw session IDs
*   Maintains a rolling dense summary (100–200 tokens)
*   Stores dimension tags (project, domain, topic, etc.)
*   Maintains an embedding for retrieval
*   Tracks recency and prominence
*   Optionally links to artifacts

Conversation objects do not store full transcripts.  
They store distilled semantic continuity.

Sessions remain owned by OpenClaw.  
Conversation objects are owned by Cortex.

---

## Example / Scenario

User returns after four years to discuss Cortex memory architecture.

System behavior:

1.  Orchestration evaluates similarity against existing threads.
2.  Detects high overlap with prior “Cortex Memory Model” thread.
3.  Retrieves thread summary.
4.  Injects into escalation package with metadata:
    *   "Last active: 4 years ago"
    *   "Confidence: High"
5.  Prompts user:  
    “This looks related to your previous Cortex memory discussion. Continue that thread or start a new direction?”

User can override.

If conversation shifts materially, system proposes fork:

*   New thread created
*   Linked to prior thread
*   Fresh summary begins

---

## Core Mechanism (High-Level)

**Conversation Assignment (agent\_end)**

*   After each session turn, reflection logic determines:
    *   Attach to existing thread OR
    *   Create new thread
*   Rolling summary updated.

**Conversation Retrieval (before\_prompt\_build)**

*   Identify active thread.
*   Retrieve:
    *   Canonical summary
    *   Top related threads (dimension + embedding overlap)
*   Inject bounded bundle into model context.

**Dormancy & Compaction**

*   On prolonged inactivity:
    *   Compress summary to ultra-dense form.
    *   Preserve metadata + decisions.
*   Full transcripts remain solely in OpenClaw.

Conversation objects persist indefinitely unless explicitly pruned.

---

## Benefits

*   Cross-session semantic continuity
*   Compaction-agnostic memory preservation
*   Massive context leverage from small token footprint
*   Clear authority separation (Gateway vs Cortex)
*   Intelligent resume behavior beyond raw transcript recall
*   Artifact promotion triggers at thread level

---

## Feasibility (High-Level)

Does NOT require:

*   Disabling OpenClaw compaction
*   Duplicating transcripts into Cortex
*   Forking runtime

Requires:

*   Thread object schema in Cortex
*   Embedding + dimension indexing
*   Reflection-based thread assignment logic
*   Retrieval injection via before\_prompt\_build

OpenClaw continues to own session state and transcript persistence.

---

## Guardrails / Constraints

*   No transcript duplication in Cortex
*   Conversation summaries must remain bounded (100–200 tokens)
*   Retrieval must respect token ceilings
*   User override required for thread continuation vs fork
*   Compaction remains enabled in OpenClaw

---

## Open Questions

*   What similarity threshold determines automatic continuation vs fork?
*   Should conversations ever be explicitly closed?
*   How does prominence decay over time?
*   Should thread merges be allowed during Dream cycles?

---

## Links (Related Ideas)

*   Reflection (REM-R)
*   Dream Routine (REM-D)
*   Dimension Registry
*   Artifact Promotion Model

---

## Promotion Criteria

Promote when:

*   Thread object schema defined
*   Hook attachment logic specified
*   Retrieval injection tested
*   UX override flow validated

Until then, remains intake artifact.