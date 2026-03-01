# Intent Calibration

**Attributes**

*   **Proposed Component Name:** remram-intuition
*   **Layer:** Orchestration
*   **Primary Surface:** User Agent (pre-cognition stage)
*   **Related Hook Surface (conceptual):** before\_model\_resolve–equivalent stage
*   **Dependency:** Provenance-aware retrieval + interaction pattern store

**Date:** 2026-02-28  
**Status:** Shaping  
**One-liner:** A pre-cognition alignment loop that confirms domain, interaction mode, and thread continuity using both real-time signals and learned user patterns.

---

## Opportunity / Problem

Users speak in shorthand.

They repeat patterns over time:

*   “I saw this on YouTube…”
*   “Is it too late?”
*   “That’s interesting.”
*   “What do you think?”

Each of these often implies:

*   A specific domain
*   A specific evaluation mode
*   A specific verbosity expectation
*   A likely continuation vs new-idea decision

Humans infer this instantly because they carry context in their heads.  
Models do not.

This creates recurring friction:

1.  Wrong interaction mode (expansion instead of critique).
2.  Wrong domain context (pulling hardware history for a Remram question).
3.  Thread fragmentation (new idea artifacts when this is a continuation).
4.  Premature escalation and token waste.

Intent Calibration exists to prevent those failures before deep reasoning begins.

---

## What It Does

Intent Calibration performs a lightweight pre-cognition pass that answers four questions:

1.  What domain is this likely about?
2.  What interaction mode is intended?
3.  Does this attach to an existing thread or start a new one?
4.  How confident am I?

It uses two information sources:

*   Immediate message signals (keywords, tone, structure)
*   Learned interaction patterns (user-specific priors)

It also performs a fast provenance-aware lookup to detect related threads.

If confidence is high:

*   Attach to the most likely thread.
*   Proceed directly to main response.

If confidence is low:

*   Surface a short calibration preview.

---

## Learned Interaction Patterns (Core Aspect)

remram-intuition maintains structured interaction priors tied to the user.

Example pattern entry:

*   Trigger phrase: “I saw this on YouTube…”
*   Typical domain: Entrepreneurial / Remram
*   Typical mode: Strategic evaluation / threat-check
*   Expected verbosity: Short unless expanded
*   Confidence score: dynamic and adaptive

Each time the pattern repeats and is confirmed, confidence increases.

This is not model retraining.  
It is orchestration-level learning stored in structured memory.

It behaves like:

*   A style cache
*   A mode prior map
*   A collaboration fingerprint

Over time, calibration frequency decreases because confidence increases.

---

## Provenance-Aware Thread Continuity

Intent Calibration integrates fast similarity lookup with provenance metadata.

When a new input arrives:

1.  Detect key signals.
2.  Query related prior ideas or artifacts.
3.  Rank candidates by:
    *   Similarity
    *   Recency
    *   Component alignment
4.  Select most likely thread (if confidence high).

If ambiguity remains, preview includes inferred attachment.

Example:

“I think this relates to the Remram memory layer and connects to our prior memory architecture discussions, though there’s no specific Obsidian thread. Are you evaluating competitive overlap, or starting a new idea?”

This prevents idea fragmentation and misrouting.

---

## Example (Obsidian Case)

User input:

“I was watching a podcast about Obsidian saying it’s infinite memory for OpenClaw. Is it too late?”

Internal alignment pass:

*   Detect keywords: Obsidian, infinite memory, OpenClaw.
*   Map to Remram memory domain.
*   Run provenance lookup (no existing Obsidian-specific thread).
*   Mode inference: strategic overlap check.
*   Confidence: moderate.

Calibration preview:

“I think you’re checking whether Obsidian overlaps with Remram’s memory thesis. Are you evaluating competitive overlap, or asking if we’re reinventing something?”

After confirmation, full reasoning proceeds.

---

## Benefits

*   Reduces wrong-mode responses
*   Prevents cross-domain misrouting
*   Maintains thread continuity
*   Reduces duplicate idea artifacts
*   Lowers unnecessary escalation
*   Reduces token waste
*   Improves perceived intuition
*   Compounds collaboration history into orchestration intelligence

It ensures cognition happens inside the correct context container.

---

## Feasibility (High-Level)

Requires:

*   Lightweight domain + mode classification
*   Confidence scoring
*   Provenance-aware similarity lookup
*   User interaction prior store
*   Short preview generation template

Does not require:

*   Model weight updates
*   Full retrieval
*   Deep reasoning
*   Escalation

It operates entirely at the orchestration layer.

---

## Guardrails

*   Trigger preview only when confidence below threshold
*   Keep preview ≤ 2 sentences
*   Avoid repeated calibration loops
*   Decay stale interaction priors
*   Auto-attach only when confidence high
*   Do not inflate verbosity due to priors

---

## Open Questions

*   What confidence threshold triggers preview?
*   How quickly should priors decay?
*   Should priors be per-user-agent or per-persona?
*   Should interaction priors influence escalation weighting?
*   How transparent should calibration inference be to the user?

---

## Links (Related Ideas)

*   Prompt Assembler / Escalation Brief Builder (post-calibration context packaging)
*   Idea Artifact structure (thread continuity relies on clean metadata)
*   Reflection engine (updates interaction priors)
*   Provenance-aware retrieval system