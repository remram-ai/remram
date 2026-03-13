# Getting Started

This repository is the documentation and architecture home for the RemRam ecosystem.

It is the right place to start if you want to understand:

- what the system is
- how the ecosystem is divided across repositories
- how features are documented
- how architectural decisions are recorded

It is not the primary implementation home for appliance code, runtime code, or service deployment logic.

If you are arriving with an AI assistant or want a faster bootstrap pass before reading the full docs set, start with [AI Context](../ai-context/README.md).

## Start Here

Read in this order:

1. [Documentation Map](../README.md)
2. [Feature](../concepts/feature.md)
3. [Plugin](../concepts/plugin.md)
4. [Skill](../concepts/skill.md)
5. [Service](../concepts/service.md)
6. [Runtime](../concepts/runtime.md)
7. [Gateway](../concepts/gateway.md)

If you want implemented capability docs, then continue into:

- [features/](../../features/)

If you want unimplemented ideas and proposed capabilities, then continue into:

- [backlog/ideas/](../../backlog/ideas/)

If you want historical material, use:

- [archive/](../../archive/)

## When This Repository Is The Right Place

Work in this repository when the change is primarily about:

- architecture
- system vocabulary
- documentation structure
- contributor orientation
- feature definitions
- backlog ideas

## When Another Repository Is The Right Place

Use the domain repositories when the change is primarily about implementation:

- `moltbox-gateway` for the control plane, CLI, and orchestration behavior
- `moltbox-runtime` for baseline runtime configuration
- `moltbox-services` for service definitions and topology
- `remram-skills` for skill packages and deploy recipes
- `remram-cortex` for long-term memory services
- `remram-app` for user-facing applications

## Recommended Next Step

If you are preparing to contribute, continue to [Contribute](contribute.md) and [Development Workflow](development-workflow.md).
