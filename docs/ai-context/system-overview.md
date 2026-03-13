# System Overview

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

Canonical sources:

- [Platform Overview](../platform/overview.md)
- [Topology](../platform/topology.md)
- [Gateway](../concepts/gateway.md)
