# Remram Cortex

## Summary

Remram Cortex is the approved feature for durable knowledge, long-term memory, and structured retrieval in the Remram system.

It adds the knowledge layer that turns transcript history into durable knowledge objects, retrieves that knowledge deliberately at runtime, and reconciles it over time through reflection and Dream cycles.

The name reflects the two halves of the design direction: REM-style reflection and RAM-style retrieval.

## Status

Early design feature.

The dedicated `remram-cortex` implementation repository and platform-service bundle have not yet been reconstructed into this repo's `platform/` tree.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## User And Operator Outcome

- users can benefit from durable knowledge that survives transcript compaction, pruning, and session resets
- orchestration can inject bounded, structured knowledge bundles into runs without conflating transcript history and memory
- operators can treat OpenSearch as the single retrieval engine for structured recall
- the system can reconcile contradictions and promote stable patterns into evergreen artifacts over time
- live execution continues even when Cortex or OpenSearch is unavailable

## Primary Platform Deliverables

- current enabling dependency:
  - [OpenSearch](../../platform/services/opensearch/README.md)
- planned implementation boundary:
  - dedicated `remram-cortex` local service and repo, not yet represented as a platform item in this repository

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Projects](projects/README.md)

## Related Planning Inputs

- [Cortex Hydrate](../../roadmap/ideas/2026-03-01__cortex__cortex-hydrate.md)
- [Cortex Import](../../roadmap/ideas/2026-03-01__cortex__cortex-import.md)
- [Durable Conversation Layer](../../roadmap/ideas/2026-03-01__cortex__durable-conversation-layer.md)

## Related Documentation

- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
