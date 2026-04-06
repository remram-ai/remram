# Development Workflow

This repository uses a documentation-first workflow for architecture changes.

## Normal Workflow

1. Identify the change.
2. Decide whether it is an overview, concept, operations, reference, platform, roadmap, or feature-record change.
3. Update the active documentation in the correct location.
4. Keep terminology and CLI examples aligned with the current architecture baseline.
5. Use archive material as reference input, not as the active source of truth.
6. Only after the documentation is stable should implementation refactor or repository-boundary work proceed.

## Working Rules

- Active docs live under `docs/`, `platform/`, and `roadmap/`.
- Approved feature records live under `features/`.
- Forge-owned lifecycle governance, templates, and orchestration state contracts live in the private `remram-forge` repo, not here.
- Historical docs live under `archive/`.
- Active docs should not depend on transitional terminology or legacy command surfaces.
- If a document is obsolete, archive it instead of editing history in place.

## Architecture Change Workflow

Use this sequence for architecture work:

1. capture review findings
2. lock decisions
3. rewrite active documentation
4. refactor implementation

This repository is the place to stabilize the language and structure before downstream implementation changes spread across the other repositories.

## Implementation Promotion Workflow

When architecture work turns into implementation work in the domain repositories, the expected promotion model is:

1. work in the owning repository on a normal Git branch
2. keep baseline service inputs, runtime overlays, CLI changes, and skill/plugin changes in their owning repos
3. run the relevant unit tests and the matching platform item or feature test plan
4. commit and push the tracked revisions you intend to deploy
5. update the appliance host from those exact tracked revisions
6. deploy through the official `moltbox` CLI and service-plane path
7. prove the change in `test` first when the appliance is involved
8. only then treat `prod` as promotable

Current Moltbox posture:

- `test` is the proving lane
- `prod` is a protected managed pet
- replay and checkpoint are not the normal `test` / `prod` lifecycle
- snapshot-first recovery replaces the old replay-first rebuild model
- routine operator work should not require raw Docker or break-glass SSH

## Documentation Quality Checklist

Before closing a documentation change, verify:

- terms match the current concept docs
- examples use `moltbox <component> <command>`
- links resolve to active docs, not archived ones, unless historical reference is intentional
- legacy namespaces are not shown as active usage
- the document belongs in the current folder based on its purpose

## Related Documents

- [Documentation Map](../README.md)
- [Contribute](contribute.md)
- [CLI](../operations/cli.md)
- [CLI Reference](../../reference/cli-reference.md)
