# Remram

Remram is the landing page for the memory-enhanced OpenClaw experiment and the projects that remain in the Remram organization.

The focus is local AI experimentation: governed memory and retrieval, reusable capabilities, appliance operations, and agentic workflow design. Remram remains active. Livonne's commercial care, family, community, hardware, and product strategy now belong to the separate Livonne organization.

## Start here

1. Read [repository ownership](docs/overview/repositories.md) to find the right project.
2. Read [the current scope and retirement record](docs/overview/2026-10-04-repository-scope.md) before reusing older architecture.
3. Use [Moltbox Gateway](https://github.com/remram-ai/moltbox-gateway) for appliance implementation and the current operator contract.
4. Use [Forge](https://github.com/remram-ai/remram-forge) for the separate workflow experiment, if you have access.
5. Use [the documentation map](docs/README.md), [concepts](docs/concepts/README.md), and [platform registry](platform/README.md) for reusable design material.

## Retained projects

| Repository | Responsibility | Access |
| --- | --- | --- |
| [remram](https://github.com/remram-ai/remram) | Ecosystem landing page, orientation, concepts, feature records, and capability registry | Public |
| [moltbox-gateway](https://github.com/remram-ai/moltbox-gateway) | Appliance control plane, CLI, deployment, verification, and recovery | Public |
| [moltbox-services](https://github.com/remram-ai/moltbox-services) | Service definitions and baseline configuration | Private |
| [moltbox-runtime](https://github.com/remram-ai/moltbox-runtime) | Final deployable runtime artifacts and overlays | Private |
| [remram-skills](https://github.com/remram-ai/remram-skills) | Reusable skills and plugin packages | Public |
| [remram-forge](https://github.com/remram-ai/remram-forge) | Forge reference architecture and the Lobster Reef workflow experiment | Private |
| [.github](https://github.com/remram-ai/.github) | Organization introduction and project routing | Public |

Existing visibility is preserved. Public orientation does not make private configuration or workflow repositories public.

## Retired repositories

- [remram-cortex](https://github.com/remram-ai/remram-cortex): retired as an active repository. Its recovered concepts and design depth were re-authored in [Livonne Platform](https://github.com/livonne-ai/livonne-platform) to support Livonne Care and the wider platform. Original code and historical alternatives remain reference material; no implementation port or runtime cutover is claimed.
- [elderclaw](https://github.com/remram-ai/elderclaw): retired. Selected product, platform, and hardware knowledge moved into the three Livonne repositories.
- [remram-app](https://github.com/remram-ai/remram-app): retired planning placeholder; it contains no application implementation.

These repositories are ready for owner-managed archiving after their notices are published. Memory concepts may still inform the open Remram experiment; the old Cortex repository is no longer the current implementation destination or a required deployed service.

## Livonne destination

- [Livonne](https://github.com/livonne-ai/livonne): company, product, strategy, experience, and narratives.
- [Livonne Platform](https://github.com/livonne-ai/livonne-platform): software concepts and architecture.
- [Livonne Hardware](https://github.com/livonne-ai/livonne-hardware): physical products and engineering.

Livonne Care is a product expression of the wider Livonne platform. Keep Livonne's commercial requirements and household product promises out of Remram's active experimental scope.

## Repository map

- [docs/](docs/README.md): orientation, concepts, contributor guidance, and high-level ownership.
- [platform/](platform/README.md): reusable capability records and design material.
- [features/](features/README.md): retained feature records; retired records are labeled.
- [roadmap/](roadmap/README.md): exploratory ideas and proposals, not a commitment to implement all historical plans.
- [schemas/](schemas/README.md): Remram-owned architecture and runtime schemas.
- [reference/](reference/README.md): technical reference.
- [archive/](archive/README.md): historical material.

## Contributor boundaries

Read [AGENTS.md](AGENTS.md) before making changes. Detailed appliance and service behavior belongs in its owning repository. Forge remains a separate workflow project, not part of the Livonne migration. Historical diagrams and fixed-stack proposals do not establish the current deployed system. Record what is proposed, implemented, and verified separately.
