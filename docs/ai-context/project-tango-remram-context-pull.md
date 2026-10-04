# Architecture reuse context

Status: general Remram engineering guidance. The previous work-context-specific crosswalk has been removed from the active document. Historical revisions are not current authority.

## Reusable boundaries

| Responsibility | Owns |
| --- | --- |
| Workflow definition | Stages, tasks, policies, inputs, and intended outcomes |
| Execution governance | Run state, deterministic routing, validation, approvals, retries, and accepted outcomes |
| Agent/runtime execution | Bounded model and tool work |
| Memory and retrieval | Governed durable knowledge, evidence relationships, bounded context, correction, and reflection |
| Capability contracts | Callable operations, permissions, failure behavior, and expected evidence |
| Human interaction | Presentation and collection of explicit decisions |
| Improvement | Reviewable proposals derived from outcomes and evidence |

Agent output does not become accepted workflow state automatically. Runtime transcripts are evidence, not durable memory. Human approval is an explicit scoped decision. Learning creates governed candidates rather than silently changing behavior.

## Retained source homes

- [Forge](https://github.com/remram-ai/remram-forge) preserves the separate workflow experiment and architecture material.
- [Remram concepts](../concepts/README.md) preserve reusable vocabulary.
- [Platform registry](../../platform/README.md) preserves capability records.
- [Current repository map](../overview/repositories.md) identifies active owners and retired destinations.

Earlier Cortex architecture remains historical source material. The recovered Livonne software corpus lives in [Livonne Platform](https://github.com/livonne-ai/livonne-platform); no implementation port or shared runtime dependency is implied.

## Public-content rule

Keep employer-specific system names, internal product architecture, partner records, customer information, commercial commitments, and secrets outside public Remram documentation. Discuss general patterns with their evidence and limits.
