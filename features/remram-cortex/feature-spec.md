# Remram Cortex Feature Spec

## Feature Summary

- Feature name: remram-cortex
- Source proposal: early system architecture design and current Cortex idea backlog; formal proposal artifacts have not yet been reconstructed into `roadmap/proposals/`

## Scope

- In scope: durable knowledge objects stored outside transcript history
- In scope: OpenSearch-backed retrieval as the single structured recall authority
- In scope: reflection, Dream reconciliation, and artifact promotion workflows
- In scope: multi-dimensional indexing, dimension registry management, and candidate-dimension promotion
- In scope: graceful degradation when Cortex or OpenSearch is unavailable
- Out of scope: owning OpenClaw session routing or transcript mutation
- Out of scope: direct model invocation from the App
- Out of scope: re-enabling OpenClaw's built-in long-term memory subsystems as competing authorities

## User Experience

The system should be able to remember durable facts, constraints, and patterns across long time spans without forcing users to restate them every session.

Knowledge retrieval should be deliberate, bounded, and structurally filtered so long-term memory improves runs without turning prompt history into an unbounded dump.

## Functional Requirements

- Cortex runs as a local Go service with narrow endpoints including `/ingest`, `/retrieve`, `/reflect`, `/dream`, `/promote`, and `/dimensions`
- Cortex stores structured knowledge objects in OpenSearch with provenance, confidence, dimensions, relational links, and promotion state
- retrieval is eligibility-first and then similarity-based: dimension filtering, lexical ranking, vector similarity, confidence-weighted re-ranking, and typed bundle construction
- reflection runs after `agent_end` and updates knowledge objects without blocking the visible user response
- Dream cycles run asynchronously through scheduled cron-driven reconciliation and handle contradiction detection, consolidation, demotion, and artifact-promotion preparation
- artifacts remain derived projections of validated knowledge rather than the primary memory store
- execution must continue when Cortex or OpenSearch is unavailable, even if retrieval or reflection has to return empty results or defer writes

## Working Design Notes

- the current direction uses OpenSearch as the single semantic retrieval engine for Cortex-backed memory
- the current working dimension model targets a 64-slot structured indexing budget carried forward from the early design notes
- when extracted attributes do not fit existing canonical dimensions, the system should track them as candidate dimensions or dimension misses rather than fabricating a category immediately
- candidate dimensions should be promoted during Dream reconciliation when recurring miss signal justifies formalization

## Dependencies

- [OpenSearch](../../platform/services/opensearch/README.md)
- OpenClaw transcript persistence and tool-result persistence surfaces
- orchestration hook attachment points such as `before_prompt_build`, `tool_result_persist`, `agent_end`, and scheduled cron sessions
- future dedicated `remram-cortex` implementation service and repo boundary

## Acceptance Criteria

- durable knowledge survives transcript compaction, pruning, and session-boundary changes
- structured retrieval returns bounded knowledge bundles through Cortex rather than direct transcript replay
- reflection updates and Dream reconciliation can mature knowledge over time without blocking live execution
- candidate-dimension or miss tracking is observable and can promote stable new categories through the defined reconciliation path
- failure of Cortex or OpenSearch degrades knowledge augmentation gracefully without stopping normal session execution

## Open Questions

- the exact 64-dimension budget and promotion thresholds remain early-design assumptions rather than finalized implementation contracts
- the dedicated Cortex platform bundle, service deployment model, and repo boundary are not yet represented in `platform/`
- user-facing app workflows for knowledge review and artifact approval have not yet been reconstructed into active docs in this repo
