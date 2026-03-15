# Development Workflow

This repository uses a documentation-first workflow for architecture changes.

## Normal Workflow

1. Identify the change.
2. Decide whether it is an overview, concept, operations, reference, platform, or roadmap change.
3. Update the active documentation in the correct location.
4. Keep terminology and CLI examples aligned with the current architecture baseline.
5. Use archive material as reference input, not as the active source of truth.
6. Only after the documentation is stable should implementation refactor or repository-boundary work proceed.

## Working Rules

- Active docs live under `docs/`, `platform/`, and `roadmap/`.
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

1. work on your own branch
2. iterate in `dev`
3. run unit tests and the relevant platform item `test-plan.md` in `dev`
4. promote to `test` through the CLI only
5. run the same test plan in `test`
6. stop when the change is ready for UAT
7. after approval, merge and deploy to `prod`

This workflow exists to test both the platform item and the deployment path itself.

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
