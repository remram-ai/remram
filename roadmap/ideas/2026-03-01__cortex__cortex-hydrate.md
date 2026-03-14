# Historical Session Backfill (Cortex Hydrate)

**Marketing Name (optional):** Cortex Hydrate
**Layer:** Cortex
**Primary Surface / Agent:** Hydration Runner (reflection-based batch agent)
**Relevant Hook or Stage (if applicable):** Manual admin trigger -> sessions_history replay -> /reflect + /dream
**Dependencies (if any):** OpenClaw session store, Reflection (REM-R), Dream Routine (REM-D), OpenSearch
**Date:** 2026-03-01
**Status:** Shaping
**One-liner:** Replay historical conversations and external chat exports to rapidly load Cortex with structured knowledge.

---

## Opportunity / Problem

When a user installs Remram on top of an existing OpenClaw instance, the system starts structurally empty.

Even if months of conversations exist, Cortex has no durable knowledge. The user experiences no immediate continuity benefit. The system feels new, not cumulative.

This creates onboarding friction. The architecture is powerful, but the value is invisible until enough live interaction accumulates.

Cortex Hydrate eliminates this cold start.

It transforms installation into a wake-up moment.

---

## The Wake-Up Moment

Hydrate is the moment Cortex "wakes up."

Instead of growing knowledge slowly from zero, the user triggers a one-time catch-up process:

- The system scans historical sessions.
- Extracts durable patterns.
- Identifies recurring constraints and preferences.
- Builds dimension mappings.
- Runs reconciliation.

Within minutes, Cortex reflects the user's lived history.

The experience shifts from:

"Let's see if this works over time."

To:

"It already understands me."

Hydrate turns architecture into immediate impact.

---

## What It Does

Cortex Hydrate:

- Enumerates historical OpenClaw sessions
- Optionally ingests external exports (e.g., ChatGPT conversation JSON)
- Replays each session through the Reflection pipeline (deliver: false)
- Extracts atomic knowledge objects
- Assigns lower initial confidence (historical source)
- Runs a Dream reconciliation pass after ingestion
- Produces onboarding summary metrics (objects created, dimensions detected, conflicts resolved)

It does not alter transcripts. It derives structure from them.

---

## Example / Scenario

User installs Remram on a Gateway with 6 months of history.

User triggers Hydrate.

System performs:

1.  Iterates through all sessions via sessions\_list.
2.  Streams transcripts through Reflection agent.
3.  Creates knowledge objects tagged `historical-session`.
4.  Detects recurring constraints (e.g., tone preferences, escalation rules).
5.  Identifies domain clusters (projects, interests).
6.  Runs Dream reconciliation to collapse duplicates and resolve contradictions.

System presents summary:

- 482 knowledge objects created
- 17 recurring principles detected
- 4 candidate dimensions promoted
- 3 conflicting assumptions resolved

User immediately experiences continuity.

---

## Core Mechanism (High-Level)

1.  Hydrate is manually invoked.
2.  System enumerates sessions via OpenClaw surfaces.
3.  Reflection agent processes sessions in isolation.
4.  `/reflect` updates knowledge objects incrementally.
5.  After batch completion, `/dream` reconciles system-wide state.
6.  Confidence weighting begins lower and increases with live reinforcement.

Hydrate does not modify runtime execution rules. It seeds knowledge authority.

---

## Benefits

- Immediate onboarding impact
- Reduced time-to-value
- Visible demonstration of Cortex capability
- Natural alignment with OpenClaw's deterministic continuity model
- Repeatable benchmarking dataset for reflection quality

---

## Feasibility (High-Level)

Hydrate leverages existing infrastructure:

- OpenClaw session store
- sessions\_list and transcript access
- Reflection (REM-R)
- Dream (REM-D)
- Cortex knowledge schema

No runtime fork required.

It is an orchestration of existing primitives in batch form.

---

## Guardrails / Constraints

- Historical knowledge initializes with reduced confidence
- No transcript mutation
- No automatic artifact promotion during hydration
- Rate limiting required for large histories
- Must be idempotent (safe to re-run)

---

## Open Questions

- Should Hydrate default to full history or allow scoped ranges?
- Should external exports (ChatGPT JSON) be normalized differently than OpenClaw transcripts?
- How should we surface onboarding metrics in the App?

---

## Links (Related Ideas)

- Cortex Import
- Reflection (REM-R)
- Dream Routine (REM-D)

---

## Promotion Criteria

This idea may be promoted when:

- Historical confidence policy is finalized
- Batch execution strategy is defined (sequential vs parallel)
- Idempotency guarantees are specified
- Onboarding UX summary is designed

Until then, it remains an intake artifact.


