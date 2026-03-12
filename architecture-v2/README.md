# Architecture V2

This directory records the finalized Moltbox / RemRam architecture for the CLI refactor and repository split.

It exists alongside the current documentation set so implementation can proceed against a stable target without rewriting the current-state architecture documents yet.

Use this directory for:

- finalized control-plane architecture
- finalized CLI design
- repository taxonomy and responsibilities
- deployment and runtime configuration model
- environment and promotion rules
- gateway refactor implementation plan

Document map:

- `control-plane.md`
- `cli.md`
- `repository-taxonomy.md`
- `deployment-model.md`
- `artifact-promotion.md`
- `gateway-refactor-plan.md`

Status rule:

- documents under `docs/` continue to describe the current or pre-refactor system
- documents under `architecture-v2/` describe the approved target architecture for the refactor
