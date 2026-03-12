# Architecture V2

This directory records the finalized Moltbox architecture for the gateway refactor.

It exists alongside the current documentation set so implementation can proceed against a stable target without rewriting the historical docs yet.

The structure here follows the finalized taxonomy and component model:

- `gateway.md`
- `services.md`
- `runtime.md`
- `skills.md`
- `gateway-refactor-plan.md`
- `moltbox-runtime-snapshot.md`
- `openclaw-plugin-integration-review.md`
 - `architecture-review-second-pass.md`
 - `cli-taxonomy-vocab-audit.md`

Feature descriptions live separately in:

- `../features/`

Status rule:

- documents under `docs/` continue to describe the current or pre-refactor system
- documents under `architecture-v2/` describe the approved target architecture for the refactor

Current V2 baseline notes:

- the gateway deployment pipeline is the authoritative writer of deployment state
- `moltbox-runtime` defines baseline runtime configuration, not the full mutable live runtime state
- live runtime mutation, checkpointing, and backups are part of the appliance architecture under machine-scoped storage
- runtime snapshots and plugin-integration notes are supporting references; they do not replace the architecture documents as the behavioral baseline
