# Builders

Use this file as a quick bootstrap if you are implementing code or changing runtime behavior in the ecosystem.

Start with:

- [Repository Taxonomy](repository-taxonomy.md)
- [System Overview](system-overview.md)
- [CLI Architecture Summary](cli-architecture-summary.md)

What to know first:

- `remram` owns architecture and feature docs
- `moltbox-gateway` owns the control plane and `moltbox` CLI
- `moltbox-runtime` owns baseline runtime config, not full live runtime state
- `moltbox-services` owns service definitions
- `remram-skills` owns reusable skill and plugin packages

Platform model:

- deployments flow through the gateway
- runtime environments are mutable systems
- pre-deploy snapshots live under `/srv/moltbox-state/runtime-snapshots/`
- checkpointing rebases runtime state into a new baseline

CLI model:

- `moltbox gateway ...` for control-plane work
- `moltbox gateway service ...` for service lifecycle
- `moltbox dev|test|prod ...` for environment operations
- `moltbox <service> <native command>` for native service passthrough

Canonical docs:

- [Platform Overview](../platform/overview.md)
- [Deployment Models](../platform/deployment-models.md)
- [CLI Architecture](../platform/cli-architecture.md)
- [Repositories](../platform/repositories.md)
- [Features](../../features/README.md)
