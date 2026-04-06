# Builders

Use this file as the bootstrap for implementation and debugging work.

## Required Reading

Read these documents in order before you write code, diagnose runtime behavior, or reason about deployment:

1. [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md) if the task touches the live appliance
2. [Overview](../overview.md)
3. [Topology](../topology.md)
4. [Repositories](../repositories.md)
5. [CLI](../cli.md)
6. [Deployment Models](../../overview/deployment-models.md)

Do not begin implementation or debugging until you have read the documents above.

## Read Next For Specific Work

If the task touches appliance services, gateway orchestration, runtime mutation, or deployment behavior, also read:

- [Gateway](../../concepts/gateway.md)
- [Service](../../concepts/service.md)
- [Platform Items](../features.md)
- [Roadmap](../../../roadmap/README.md)
- [Platform Item Type Recipes](../recipes/README.md)
- the relevant owning repo docs, especially the matching service or runtime README
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
- `moltbox-gateway` owns the live Moltbox appliance/operator contract, the control plane, and the `moltbox` CLI
- `moltbox-services` owns service definitions, baseline service config, and service-local docs
- `moltbox-runtime` owns the final deployable runtime layer, not full live runtime state
- `remram-skills` owns reusable skill and plugin packages

## Platform Model

- the host stays minimal and provides Docker, storage, and system services
- long-running application logic runs in containers, not directly on the host OS
- deployments flow through the gateway and the official `moltbox` surfaces
- service lifecycle goes through `moltbox service ...`
- direct Docker commands are break-glass diagnostics, not the normal operator or builder contract
- runtime environments are mutable systems
- `test` is the proving lane
- `prod` is a managed pet
- snapshot-first recovery replaced replay/checkpoint-era normal operation

## Service And Deployment Model

- service definitions and baseline service inputs live in `moltbox-services`
- the gateway consumes those definitions and turns them into running appliance services on the host Docker engine
- final deployable runtime artifacts live in `moltbox-runtime`
- live runtime mutation lives in appliance state under `/srv/moltbox-state`
- gateway deployment metadata and deployment-event history are authoritative for appliance change tracking

## Host Git Access Model

- Moltbox hosts authenticate to GitHub with a GitHub App, not SSH deploy keys
- the host stores the GitHub App private key at `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling exchanges that key for short-lived installation tokens using App ID `3071584` and Installation ID `115774577`
- Git operations use HTTPS with the installation token, for example `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`
- the gateway or bootstrap tooling owns the token exchange step; do not hard-code tokens into repos or host config

## CLI Model

- `moltbox gateway ...` for control-plane status and self-update
- `moltbox service ...` for appliance service lifecycle
- `moltbox test openclaw ...` and `moltbox prod openclaw ...` for runtime-native lifecycle operations
- `moltbox test verify ...` and `moltbox prod verify runtime` for routine runtime diagnostics
- `moltbox ollama ...` for native service passthrough

## Canonical Docs

- [Overview](../../overview/overview.md)
- [Topology](../../overview/topology.md)
- [Deployment Models](../../overview/deployment-models.md)
- [CLI Architecture](../../overview/cli-architecture.md)
- [Repositories](../../overview/repositories.md)
- [Gateway](../../concepts/gateway.md)
- [Service](../../concepts/service.md)
- [Roadmap](../../../roadmap/README.md)
- [Platform Registry](../../../platform/README.md)
