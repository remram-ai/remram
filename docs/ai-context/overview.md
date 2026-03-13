# Overview

RemRam is the architecture and documentation hub for an ecosystem built around a managed local appliance.

At the platform layer, Moltbox is the appliance boundary. It provides:

- a gateway control plane
- mutable OpenClaw runtime environments
- supporting services such as Caddy, Ollama, and OpenSearch
- appliance-scoped state and logs

Primary operator path:

```text
Visual Studio -> MCP plugin -> Moltbox CLI -> gateway
```

Core orientation:

- the host stays minimal and primarily provides Docker, storage, and system services
- the gateway is the only control-plane entrypoint for appliance lifecycle and deployment
- service definitions live in `moltbox-services`
- baseline runtime configuration lives in `moltbox-runtime`
- plugin and skill packages live in `remram-skills`
- the gateway consumes those inputs and renders or deploys the running appliance
- operators should reason from the gateway and CLI model first, not from direct Docker commands

Host bootstrap note:

- Moltbox hosts pull Git-backed platform inputs with GitHub App installation tokens
- the private key stays on the host at `/home/jpekovitch/.ssh/remram_deploy.pem`
- gateway or bootstrap tooling performs the token exchange; SSH deploy keys are intentionally not used

Canonical sources:

- [Platform Overview](../platform/overview.md)
- [Topology](../platform/topology.md)
- [Repositories](../platform/repositories.md)
- [Deployment Models](../platform/deployment-models.md)
- [Gateway](../concepts/gateway.md)
- [Service](../concepts/service.md)
