# Remram Cortex

Remram Cortex is the memory engine for Remram.

It is the layer that turns transient conversations into durable knowledge, turns retrieval into a deliberate system capability instead of prompt sprawl, and gives the broader platform a place where reflection, reconciliation, and long-horizon memory can actually live.

When Cortex is fully realized, Remram stops behaving like a stateless assistant with a better transcript and starts behaving like a system that can remember, reorganize, and improve over time.

## What Cortex Means

Cortex is the conceptual center of long-lived intelligence in the Remram ecosystem:

- durable knowledge instead of transcript dependence
- bounded retrieval instead of uncontrolled context stuffing
- reflection and Dream-style reconciliation instead of one-pass accumulation
- multimodal artifact intake that turns documents and images into source-linked memory
- a dedicated system boundary for memory services, indexing, promotion, and recall

## Repository Boundary

The dedicated implementation and design repository is [`remram-cortex`](https://github.com/remram-ai/remram-cortex).

This folder exists to preserve the approved feature record inside `remram`, not to duplicate the full implementation contract.

## Status

Early design feature.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## Why It Matters

- users should not have to rebuild important context every time a session changes
- the platform needs a real memory layer instead of treating raw transcript history as durable truth
- retrieval should be structured, inspectable, and intentionally governed
- long-lived knowledge should be able to improve through reflection, contradiction handling, pruning, and artifact promotion

## Canonical Repository

- [`remram-cortex`](https://github.com/remram-ai/remram-cortex)

## Local Remram Artifacts

- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Planning Inputs

- [Cortex Hydrate](../../roadmap/ideas/2026-03-01__cortex__cortex-hydrate.md)
- [Cortex Import](../../roadmap/ideas/2026-03-01__cortex__cortex-import.md)
- [Durable Conversation Layer](../../roadmap/ideas/2026-03-01__cortex__durable-conversation-layer.md)

## Related Documentation

- [Cortex Repository](https://github.com/remram-ai/remram-cortex)
- [Feature Concept](../../docs/concepts/feature.md)
- [OpenSearch](../../platform/services/opensearch/README.md)
- [Platform Registry](../../platform/README.md)
