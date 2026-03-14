# Architects

Use this file as a quick bootstrap if you are shaping architecture, documentation structure, or new platform item definitions.

Documentation layout:

- `docs/overview/` describes appliance architecture and system rules
- `docs/concepts/` defines canonical vocabulary
- `docs/operations/` explains operator workflows and CLI usage
- `docs/reference/` holds concise technical reference
- `platform/` holds the living platform registry
- `roadmap/ideas/` and `roadmap/epics/` hold active planning artifacts

How to work:

- overview documents describe the shared appliance model
- platform items describe active capabilities
- specifications belong either in platform item `spec.md` files or in the owning implementation repo, depending on scope
- archive material is reference input, not the active source of truth

When documenting a new platform item:

1. create a folder under the correct `platform/<type>/` category
2. add `README.md`, `spec.md`, `test-plan.md`, and `operator-guide.md`
3. align vocabulary with `docs/concepts/`
4. align command examples with the CLI architecture
5. link back to the relevant overview docs

Canonical docs:

- [Documentation Map](../../README.md)
- [Overview](../../overview/overview.md)
- [Repositories](../../overview/repositories.md)
- [CLI Architecture](../../overview/cli-architecture.md)
- [Platform Registry](../../../overview/README.md)
