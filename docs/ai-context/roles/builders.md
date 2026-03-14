# Builders

Use this file as the bootstrap for implementation and debugging work.

## Required Reading

Read these documents in order before you write code, diagnose runtime behavior, or reason about deployment:

1. [Overview](../overview.md)
2. [Topology](../topology.md)
3. [Repositories](../repositories.md)
4. [CLI](../cli.md)
5. [Deployment Models](../../overview/deployment-models.md)

Do not begin implementation or debugging until you have read the documents above.

## Read Next For Specific Work

If the task touches appliance services, gateway orchestration, runtime mutation, or deployment behavior, also read:

- [Gateway](../../concepts/gateway.md)
- [Service](../../concepts/service.md)
- [Platform Items](../features.md)
- [Feature Type Recipes](../recipes/README.md)
- the relevant platform item `README.md`, `spec.md`, and `test-plan.md`
- [gateway spec](../../../platform/core/gateway/spec.md) for service lifecycle and deployment-pipeline work

Pick the primary recipe before implementation:

- [Plugin Recipe](../recipes/plugin.md)
- [Skill Recipe](../recipes/skill.md)
- [Service Recipe](../recipes/service.md)
- [Gateway/Core Recipe](../recipes/gateway-core.md)

Review unresolved contracts before treating a recipe as final guidance:

- [Review Questions](../recipes/review-questions.md)

## What To Know First

- `remram` owns architecture, roadmap, and platform registry docs
- `moltbox-gateway` owns the control plane, `moltbox` CLI, deployment orchestration, and Docker interaction on the appliance
- `moltbox-runtime` owns baseline runtime config, not full live runtime state
- `moltbox-services` owns service definitions and steady-state service topology
- `remram-skills` owns reusable skill and plugin packages

## Platform Model

- the host stays minimal and provides Docker, storage, and system services
- long-running application logic runs in containers, not directly on the host OS
- deployments flow through the gateway
- service lifecycle goes through `moltbox gateway service ...`
- direct Docker commands are break-glass diagnostics, not the normal operator or builder contract
- runtime environments are mutable systems
- pre-deploy snapshots live under `/srv/moltbox-state/runtime-snapshots/`
- checkpointing rebases runtime state into a new baseline

## Service And Deployment Model

- service definitions live in `moltbox-services`
- the gateway consumes those definitions and turns them into running appliance services on the host Docker engine
- baseline runtime configuration lives in `moltbox-runtime`
- live runtime mutation lives in appliance state under `/srv/moltbox-state`
- gateway deployment metadata and deployment-event history are authoritative for appliance change tracking

## Host Git Access Model

- Moltbox hosts authenticate to GitHub with a GitHub App, not SSH deploy keys
- the host stores the GitHub App private key at `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling exchanges that key for short-lived installation tokens using App ID `3071584` and Installation ID `115774577`
- Git operations use HTTPS with the installation token, for example `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`
- the gateway or bootstrap tooling owns the token exchange step; do not hard-code tokens into repos or host config

## CLI Model

- `moltbox gateway ...` for control-plane work
- `moltbox gateway service ...` for appliance service lifecycle
- `moltbox dev|test|prod ...` for environment lifecycle operations
- `moltbox <service> <native command>` for native service passthrough

## Canonical Docs

- [Overview](../../overview/overview.md)
- [Topology](../../overview/topology.md)
- [Deployment Models](../../overview/deployment-models.md)
- [CLI Architecture](../../overview/cli-architecture.md)
- [Repositories](../../overview/repositories.md)
- [Gateway](../../concepts/gateway.md)
- [Service](../../concepts/service.md)
- [Platform Registry](../../../platform/README.md)
