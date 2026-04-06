# AI Context

This folder provides fast, high-signal bootstrap material for AI assistants working in the RemRam documentation repository and the broader Moltbox ecosystem.

Use these files as orientation summaries, not as replacements for the canonical docs.

If the task touches the live Moltbox appliance, load the `moltbox-gateway` docs first:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)

Repository structure and lifecycle:

```text
roadmap/    -> ideas and proposals
features/   -> approved feature records plus local enhancement and project artifacts
platform/   -> active platform items
remram-forge/governance/ -> private lifecycle, roles, tasks, workflows, and policies
remram-forge/schemas/ -> private lifecycle templates and orchestration state schemas
reference/  -> persistent technical reference knowledge
docs/       -> architecture, feature docs, concepts, operations, and AI bootstrap

Idea -> Proposal -> Feature -> Feature Project -> platform item -> docs/features/<name>.md
```

Core summaries:

- [Overview](overview.md)
- [CLI](cli.md)
- [Topology](topology.md)
- [Repositories](repositories.md)
- [Platform Items](features.md)

Implementation recipes:

- [Platform Item Type Recipes](recipes/README.md)
- [Review Questions](recipes/review-questions.md)

Role guides:

- [Roles](roles/README.md)
- [Builders](roles/builders.md)
- [Testers](roles/testers.md)
- [Architects](roles/architects.md)

Canonical sources:

- [Documentation Map](../README.md)
- [Overview](../overview/overview.md)
- [CLI Architecture](../overview/cli-architecture.md)
- [Repositories](../overview/repositories.md)
- [Feature Documentation](../features/README.md)
- [Roadmap](../../roadmap/README.md)
- [Features](../../features/README.md)
- [Forge Governance (private)](https://github.com/remram-ai/remram-forge/blob/main/governance/README.md)
- [Forge Schemas (private)](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md)
- [Reference](../../reference/README.md)
- [Platform Registry](../../platform/README.md)

Recommended order:

1. Read [Overview](overview.md), [Topology](topology.md), and [Repositories](repositories.md).
2. Use [Features](../../features/README.md) and [Platform Items](features.md) once you need approved feature records or active registry entries.
3. If the task touches lifecycle stages, governance, or lifecycle artifact contracts, follow the private Forge docs when you have access.
4. Use [Roles](roles/README.md) and [Platform Item Type Recipes](recipes/README.md) for task-specific guidance.
