# Prompt Assembler

**Attributes**

*   **Proposed Component Name (Marketing):** remram-reprompt
*   **Layer:** Orchestration
*   **Primary Surface / Agent:** before\_model\_resolve, before\_prompt\_build
*   **Dependencies:** Intent Calibration, Provenance Lookup, Retrieval Layer

**Date:** 2026-02-28  
**Status:** Shaping  
**One-liner:** Constructs a structured, escalation-ready prompt bundle from calibrated intent and curated context.

---

## Opportunity / Problem

Even after Intent Calibration determines what the user likely means, escalation is often naive.

Typical escalation behavior:

*   Pass transcript
*   Inject some retrieved context
*   Let the higher model infer structure

This wastes tokens and forces the model to reverse-engineer intent, constraints, and system context.

Humans do not operate this way. Before asking an expert a complex question, we prepare it. We clarify background, scope the task, and define what kind of answer we expect.

The system should do the same.

---

## What It Does

Prompt Assembler constructs a structured, escalation-ready prompt bundle before invoking a higher-tier model.

It takes:

*   Calibrated intent
*   Relevant internal project context
*   Retrieved memory artifacts
*   Fresh external context (if needed)
*   Known user response preferences

And assembles:

*   Clear system framing
*   Scoped project summary
*   Identified affected component(s)
*   Explicit task framing
*   Defined output expectations

The user’s raw phrasing is transformed into a machine-optimized reasoning brief.

---

## Example Scenario

User says:

> “I was watching a podcast about Obsidian and it says it’s like infinite memory for OpenClaw. Did someone already solve this for us?”

### Step 1 — Intent Calibration

System infers:

*   Domain: Remram
*   Likely affected layer: memory / Cortex
*   Confidence: moderate
*   Requires quick confirmation

User confirms scope.

### Step 2 — Prompt Assembler

The system:

Searches local memory for:

*   Remram memory architecture
*   Cortex documentation
*   Prior notes referencing Obsidian

Performs lightweight external retrieval:

*   What Obsidian actually provides
*   Core capabilities
*   Architectural positioning

Builds structured escalation bundle:

Instead of sending a raw transcript plus context fragments, it assembles a clean reasoning frame:

*   Defines Remram’s memory architecture in brief
*   Defines Obsidian’s capabilities
*   States the comparison objective
*   Specifies evaluation criteria
*   Constrains output format

The higher model receives a deliberate reasoning brief, not conversational noise.

---

## Core Mechanism (High-Level)

1.  Receive calibrated intent object.
2.  Determine whether escalation is required.
3.  Collect relevant internal artifacts via retrieval.
4.  Optionally retrieve fresh external context.
5.  Apply structured framing template.
6.  Inject task constraints and evaluation criteria.
7.  Produce final prompt payload.
8.  Invoke higher-tier model.

Prompt Assembler curates and structures context. It does not perform deep reasoning itself.

---

## Benefits

*   Higher-quality escalations
*   Reduced token waste
*   Improved reasoning performance from advanced models
*   More predictable output structures
*   Lower hallucination risk
*   Clear auditability of escalation bundles

---

## Guardrails / Constraints

*   Must not inject speculative or unvalidated memory
*   Must respect session isolation boundaries
*   Must obey token budget ceilings
*   Must not override system prompt authority
*   Must log assembled prompt bundles for audit and review

---

## Relationship to Intent Calibration

Intent Calibration answers:

> What does the user mean?

Prompt Assembler answers:

> How should we represent that meaning to a higher model?

Calibration interprets.  
Assembly constructs.

They are sequential but independent.

---

## Links (Related Ideas)

*   Intent Calibration (remram-intuition)
*   Provenance Lookup
*   Escalation Policy
*   Reflection Layer

---

## Promotion Criteria

This idea may be promoted to formal architecture when:

*   Hook integration points are finalized
*   Retrieval dependencies are clearly defined
*   Escalation policies are stable
*   Token budget strategy is specified

Until then, it remains an intake artifact.