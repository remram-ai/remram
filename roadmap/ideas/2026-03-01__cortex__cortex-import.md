# Artifact Ingestion (Cortex Import)

**Marketing Name (optional):** Cortex Import
**Layer:** Cortex
**Primary Surface / Agent:** Archivist Agent
**Relevant Hook or Stage (if applicable):** Manual trigger via App or file tool event -> /ingest endpoint
**Dependencies (if any):** OpenSearch, Reflection pipeline, Dimension registry, local artifact store
**Date:** 2026-03-01
**Status:** Shaping
**One-liner:** Import external documents and images into Cortex through one parser path and convert them into source-linked durable memory before user framing.

---

## Opportunity / Problem

Users already possess high-value artifacts: markdown files, design docs, charters, research notes, exports, and curated thinking. Today, these are static attachments. The system cannot reason over them structurally without manual summarization or copy-paste prompting.

Additionally, asking users to "frame" a document before the system has analyzed it introduces unnecessary friction. Users often do not know what is structurally important until the system surfaces it.

Cortex Import removes this friction by allowing the system to read first, extract signal, and then request targeted framing.

---

## What It Does

Cortex Import:

- Accepts an uploaded document or image (Markdown, PDF, text, repository snapshot, screenshot, or photo)
- Stores the original artifact in a local Git-backed artifact store
- Parses structure and visual content through one Artifact Parser path
- Extracts bounded source-linked memory candidates with location metadata
- Detects entities, projects, constraints, and recurring themes
- Creates or reinforces low-confidence knowledge objects in Cortex
- Registers candidate dimensions when appropriate
- Generates a structural summary and highlights for review
- Asks the user for clarification only after structural analysis

The user does not need to pre-structure the input. The system performs first-pass distillation.

---

## Example / Scenario

User uploads a project charter or architecture screenshot.

System performs:

1.  Stores the original file in the artifact store.
2.  Parses headings, sections, or image regions through the Artifact Parser.
3.  Extracts constraints, decisions, and principles with source locations.
4.  Identifies project name and domain.
5.  Creates or reinforces knowledge objects with source tag `external-artifact`.
6.  Generates a structured preview:
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
2.  Archivist Agent stores the original artifact and invokes one Artifact Parser path for documents or images.
3.  The parser emits summary, highlights, and source-linked candidate slices.
4.  Candidates are sent to `/ingest` in Cortex.
5.  Knowledge objects are created or reinforced with lower initial confidence.
6.  Dimension registry updated with candidates (not canonical yet).
7.  User framing adjusts metadata and confidence weights.

Reflection and Dream cycles later reconcile imported knowledge with existing system state.

---

## Benefits

- Eliminates cold-start friction for document-heavy users
- Converts static artifacts into structured, traceable knowledge
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
- local Git-backed artifact storage

No modification to OpenClaw runtime is required. The process operates entirely within Cortex authority.

---

## Guardrails / Constraints

- Imported knowledge starts with reduced confidence
- No transcript mutation
- No automatic artifact promotion without review
- Dimension candidates require Dream validation before canonical promotion
- Large artifacts must respect token and parsing limits
- Every imported memory candidate must retain a source location back to the artifact

---

## Open Questions

- Should repository ingestion be recursive or shallow by default?
- Which source-location schema should be normalized across pages, sections, offsets, and image regions?
- How aggressive should REM be when pruning low-value imported artifacts after intake?

---

## Links (Related Ideas)

- Hydrate (historical session backfill)
- Reflection (REM-R)
- Dream Routine (REM-D)

---

## Promotion Criteria

This idea may be promoted when:

- Archivist Agent responsibilities are clearly scoped
- Artifact Parser output contract is defined
- Confidence initialization policy is defined
- Artifact source tagging and location schema are finalized
- UI review workflow is specified

Until then, it remains an intake artifact.


