# Architects

Use this file as a quick bootstrap if you are shaping architecture, documentation structure, or new platform item definitions.

Documentation layout:

- `docs/overview/` describes appliance architecture and system rules
- `docs/concepts/` defines canonical vocabulary
- `docs/operations/` explains operator workflows and CLI usage
- `reference/` holds concise technical reference
- `remram-forge/governance/` holds lifecycle, roles, tasks, workflows, and policies
- `platform/` holds the living platform registry
- `roadmap/ideas/` and `roadmap/proposals/` hold active planning artifacts before approval
- `features/` holds approved feature lifecycle work

How to work:

- overview documents describe the shared appliance model
- ideas are exploratory concepts
- proposals are pre-approval capability definitions
- features are approved lifecycle containers
- platform items describe active capabilities
- specifications belong either in platform item `spec.md` files or in the owning implementation repo, depending on scope
- archive material is reference input, not the active source of truth

When documenting a new platform item:

1. start in `roadmap/ideas/` or `roadmap/proposals/` if the work is still conceptual
2. move into `features/` once the proposal is approved and implementation work begins
3. create a folder under the correct `platform/<type>/` category once the feature project defines the implementation surface
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
- [Features](../../../features/README.md)
- [Forge Governance](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- [Reference](../../../reference/README.md)
- [Platform Registry](../../../platform/README.md)
