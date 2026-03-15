# Remram Forge Feature Spec

## Feature Summary

- Feature name: remram-forge
- Source proposal: the repository split that separates Forge lifecycle mechanics from Remram architecture documentation; formal proposal artifacts have not yet been reconstructed into `roadmap/proposals/`

## Scope

- In scope: dedicated governance documentation for lifecycle stages, roles, tasks, workflows, tools, policies, recipes, services, and teams
- In scope: dedicated lifecycle artifact templates and orchestration state schemas for agents, projects, and tasks
- In scope: remram documentation and feature references that point to the dedicated Forge repository
- In scope: preserving the official feature record for Forge inside `remram/features/`
- Out of scope: moving Remram platform architecture documentation out of `remram`
- Out of scope: moving Remram-owned architecture, org, gateway, external, or runtime schemas out of `remram/schemas/`
- Out of scope: changing runtime behavior or platform implementation logic

## User Experience

Contributors should be able to understand the platform architecture from `remram` without wading through SDLC mechanics, while still finding the authoritative lifecycle model immediately through the linked Forge repo.

The Forge repo should read as the canonical home for lifecycle governance, artifact contracts, and orchestration state, while this feature record in `remram` preserves the approved feature inventory.

## Functional Requirements

- `remram-forge` contains `governance/`, `schemas/`, and a repository README that explains Forge's purpose
- Forge governance documentation remains internally navigable after the extraction
- Forge schemas remain internally navigable after the extraction
- `remram` retains architecture docs, roadmap artifacts, feature inventory, and Remram-owned runtime and architecture schemas
- lifecycle and template references in `remram` point to the canonical Forge repo
- `features/remram-forge/` remains the approved feature artifact set inside `remram`

## Dependencies

- [`remram-forge`](https://github.com/remram-ai/remram-forge)
- [`remram`](https://github.com/remram-ai/remram)
- the downstream repositories that consume Forge lifecycle outputs

## Acceptance Criteria

- the canonical lifecycle and governance documentation lives in `remram-forge`
- the canonical lifecycle artifact templates and orchestration state schemas live in `remram-forge`
- `remram` no longer carries local copies of Forge governance or lifecycle schema artifacts
- local feature inventory in `remram/features/` includes an official `remram-forge` feature record
- key README and planning links in `remram` resolve to the Forge repo instead of dead local paths

## Open Questions

- formal proposal and project-history reconstruction for Forge has not yet been restored into `roadmap/proposals/` or `features/remram-forge/projects/`
- downstream repo-by-repo adoption guidance for Forge is still lightweight and may need dedicated docs later
