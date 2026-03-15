# Getting Started

This repository is the documentation and architecture home for the RemRam ecosystem.

It is the right place to start if you want to understand:

- what the system is
- how the ecosystem is divided across repositories
- how platform items are documented
- how architectural decisions are recorded

It is not the primary implementation home for appliance code, runtime code, service deployment logic, or lifecycle governance.

If you are arriving with an AI assistant or want a faster bootstrap pass before reading the full docs set, start with [AI Context](../ai-context/README.md).

## Start Here

Read in this order:

1. [Documentation Map](../README.md)
2. [Overview](../overview/README.md)
3. [Concepts](../concepts/README.md)
4. [Operations](../operations/README.md)
5. [AI Context](../ai-context/README.md)

Then deepen as needed:

- [Feature](../concepts/feature.md)
- [Plugin](../concepts/plugin.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)

If you want active capability docs, then continue into:

- [platform/](../../platform/)

If you want completed user-facing capability documentation assembled from those platform items, then continue into:

- [docs/features/](../features/README.md)

If you want active ideas and larger initiatives, then continue into:

- [roadmap/](../../roadmap/)

If you want historical material, use:

- [archive/](../../archive/)

## When This Repository Is The Right Place

Work in this repository when the change is primarily about:

- architecture
- system vocabulary
- documentation structure
- contributor orientation
- platform item definitions
- roadmap ideas and proposals, plus approved feature records under `features/`

## When Another Repository Is The Right Place

Use the domain repositories when the change is primarily about implementation:

- `remram-forge` for the private internal development pipeline: lifecycle governance, orchestration contracts, and lifecycle schema ownership
- `moltbox-gateway` for the control plane, CLI, and orchestration behavior
- `moltbox-runtime` for baseline runtime configuration
- `moltbox-services` for service definitions and topology
- `remram-skills` for skill packages and deploy recipes
- `remram-cortex` for long-term memory services
- `remram-app` for user-facing applications

## Recommended Next Step

If you are preparing to contribute, continue to [Contribute](contribute.md) and [Development Workflow](development-workflow.md).
