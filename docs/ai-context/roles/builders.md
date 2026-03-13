# Builders

Use this file as a quick bootstrap if you are implementing code or changing runtime behavior in the ecosystem.

Start with:

- [Repositories](../repositories.md)
- [Overview](../overview.md)
- [CLI](../cli.md)

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

Host Git access model:

- Moltbox hosts authenticate to GitHub with a GitHub App, not SSH deploy keys
- the host stores the GitHub App private key at `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling exchanges that key for short-lived installation tokens using App ID `3071584` and Installation ID `115774577`
- Git operations use HTTPS with the installation token, for example `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`
- the gateway or bootstrap tooling owns the token exchange step; do not hard-code tokens into repos or host config

CLI model:

- `moltbox gateway ...` for control-plane work
- `moltbox gateway service ...` for service lifecycle
- `moltbox dev|test|prod ...` for environment operations
- `moltbox <service> <native command>` for native service passthrough

Canonical docs:

- [Platform Overview](../../platform/overview.md)
- [Deployment Models](../../platform/deployment-models.md)
- [CLI Architecture](../../platform/cli-architecture.md)
- [Repositories](../../platform/repositories.md)
- [Features](../../../features/README.md)
