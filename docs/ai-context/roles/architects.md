# Architects

Use this file as a quick bootstrap if you are shaping architecture, documentation structure, or new platform item definitions.

Documentation layout:

- `docs/overview/` describes appliance architecture and system rules
- `docs/concepts/` defines canonical vocabulary
- `docs/operations/` explains operator workflows and CLI usage
- `docs/reference/` holds concise technical reference
- `platform/` holds the living platform registry
- `roadmap/ideas/` and `roadmap/features/` hold active planning artifacts
- `platform/backlog/` is the intake queue before a platform item type is finalized

How to work:

- overview documents describe the shared appliance model
- ideas are exploratory concepts
- features are initiative-level capabilities
- platform items describe active capabilities
- specifications belong either in platform item `spec.md` files or in the owning implementation repo, depending on scope
- archive material is reference input, not the active source of truth

When documenting a new platform item:

1. start in `roadmap/ideas/` or `roadmap/features/` if the work is still conceptual
2. use `platform/backlog/` when the initiative has produced a candidate platform deliverable but the type is not yet finalized
3. create a folder under the correct `platform/<type>/` category once the type is known
4. add `README.md`, `spec.md`, `design.md`, `test-plan.md`, and `operator-guide.md`
5. align vocabulary with `docs/concepts/`
6. align command examples with the CLI architecture
7. link back to the relevant overview docs

Canonical docs:

- [Documentation Map](../../README.md)
- [Overview](../../overview/overview.md)
- [Repositories](../../overview/repositories.md)
- [CLI Architecture](../../overview/cli-architecture.md)
- [Roadmap](../../../roadmap/README.md)
- [Platform Registry](../../../platform/README.md)
