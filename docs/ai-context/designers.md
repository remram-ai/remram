# Designers

Use this file as a quick bootstrap if you are shaping architecture, documentation structure, or new feature definitions.

Documentation layout:

- `docs/platform/` describes appliance architecture and system rules
- `docs/concepts/` defines canonical vocabulary
- `docs/operations/` explains operator workflows and CLI usage
- `docs/reference/` holds concise technical reference
- `features/` holds implemented feature bundles
- `backlog/ideas/` holds unimplemented ideas

How to work:

- platform documents describe the shared appliance model
- feature bundles describe implemented capabilities
- specifications belong either in feature `spec.md` files or in the owning implementation repo, depending on scope
- archive material is reference input, not the active source of truth

When documenting a new feature:

1. create a folder under `features/`
2. add `README.md`, `spec.md`, `test-plan.md`, and `operator-guide.md`
3. align vocabulary with `docs/concepts/`
4. align command examples with the CLI architecture
5. link back to the relevant platform docs

Canonical docs:

- [Documentation Map](../README.md)
- [Platform Overview](../platform/overview.md)
- [Repositories](../platform/repositories.md)
- [CLI Architecture](../platform/cli-architecture.md)
- [Features](../../features/README.md)
