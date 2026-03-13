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

Host bootstrap note:

- Moltbox hosts pull Git-backed platform inputs with GitHub App installation tokens
- the private key stays on the host at `/home/jpekovitch/.ssh/remram_deploy.pem`
- gateway or bootstrap tooling performs the token exchange; SSH deploy keys are intentionally not used

Canonical sources:

- [Platform Overview](../platform/overview.md)
- [Topology](../platform/topology.md)
- [Gateway](../concepts/gateway.md)
