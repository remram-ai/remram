# Artifact Ingestion (Cortex Import)

**Marketing Name (optional):** Cortex Import
**Layer:** Cortex
**Primary Surface / Agent:** Archivist Agent
**Relevant Hook or Stage (if applicable):** Manual trigger via App or file tool event -> /ingest endpoint
**Dependencies (if any):** OpenSearch, Reflection pipeline, Dimension registry
**Date:** 2026-03-01
**Status:** Shaping
**One-liner:** Import external documents into Cortex and convert them into structured, durable knowledge before user framing.

---

## Opportunity / Problem

Users already possess high-value artifacts: markdown files, design docs, charters, research notes, exports, and curated thinking. Today, these are static attachments. The system cannot reason over them structurally without manual summarization or copy-paste prompting.

Additionally, asking users to "frame" a document before the system has analyzed it introduces unnecessary friction. Users often do not know what is structurally important until the system surfaces it.

Cortex Import removes this friction by allowing the system to read first, extract signal, and then request targeted framing.

---

## What It Does

Cortex Import:

- Accepts an uploaded document (Markdown, PDF, text, or repository snapshot)
- Parses structure (headings, lists, sections)
- Extracts atomic knowledge candidates
- Detects entities, projects, constraints, and recurring themes
- Creates low-confidence knowledge objects in Cortex
- Registers candidate dimensions when appropriate
- Generates a structural summary for review
- Asks the user for clarification only after structural analysis

The user does not need to pre-structure the input. The system performs first-pass distillation.

---

## Example / Scenario

User uploads a project charter.

System performs:

1.  Structural parsing of headings and sections.
2.  Extraction of constraints, decisions, and principles.
3.  Identification of project name and domain.
4.  Creation of knowledge objects with source tag `external-artifact`.
5.  Generation of a structured preview:
    - "Detected 4 constraints"
    - "Detected 3 decision statements"
    - "Detected new candidate dimension: procurement-model"

System then asks:

- Is this authoritative or exploratory?
- Should constraints override existing ones?
- Should this artifact be considered evergreen?

User framing modifies confidence, dimension tagging, and promotion eligibility.

---

## Core Mechanism (High-Level)

1.  Artifact ingestion is triggered manually.
2.  Archivist Agent parses and extracts structured candidates.
3.  Candidates are sent to `/ingest` in Cortex.
4.  Knowledge objects are created with lower initial confidence.
5.  Dimension registry updated with candidates (not canonical yet).
6.  User framing adjusts metadata and confidence weights.

Reflection and Dream cycles later reconcile imported knowledge with existing system state.

---

## Benefits

- Eliminates cold-start friction for document-heavy users
- Converts static artifacts into structured knowledge
- Enables knowledge compounding across documents
- Avoids prompt-based manual summarization loops
- Maintains single knowledge authority in Cortex

---

## Feasibility (High-Level)

This leverages existing infrastructure:

- `/ingest` endpoint for structured knowledge writes
- Knowledge object schema
- Dimension registry
- Reflection and Dream reconciliation
- OpenSearch indexing

No modification to OpenClaw runtime is required. The process operates entirely within Cortex authority.

---

## Guardrails / Constraints

- Imported knowledge starts with reduced confidence
- No transcript mutation
- No automatic artifact promotion without review
- Dimension candidates require Dream validation before canonical promotion
- Large artifacts must respect token and parsing limits

---

## Open Questions

- Should repository ingestion be recursive or shallow by default?
- Should imported artifacts maintain full-text searchable archive outside knowledge objects?
- How do we prevent duplication when similar artifacts are re-imported?

---

## Links (Related Ideas)

- Hydrate (historical session backfill)
- Reflection (REM-R)
- Dream Routine (REM-D)

---

## Promotion Criteria

This idea may be promoted when:

- Archivist Agent responsibilities are clearly scoped
- Confidence initialization policy is defined
- Artifact source tagging schema is finalized
- UI review workflow is specified

Until then, it remains an intake artifact.


