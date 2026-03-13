# Features

This directory defines product-level features for the RemRam ecosystem.

A feature is a conceptual capability, not a deployment unit.

A feature may be implemented through:

- one or more skills
- runtime configuration
- one or more services
- any combination of the above

Examples:

- Discord integration
- Signal integration
- memory-guided artifact review

Rules:

- feature definitions live here
- deployment logic must not depend directly on feature names
- feature docs may reference skills, services, and runtime configuration paths

Capability-type tags are part of the feature index on purpose. They make the visible role of each documented component clear without forcing readers to infer whether something is a plugin, skill, service, or core platform feature.

Current feature bundles:

- [semantic-router [plugin]](semantic-router%20%5Bplugin%5D/README.md)
- [moltbox-telemetry [plugin]](moltbox-telemetry%20%5Bplugin%5D/README.md)
- [together-escalation [skill]](together-escalation%20%5Bskill%5D/README.md)
- [discord-channel [skill]](discord-channel%20%5Bskill%5D/README.md)
- [gateway [core]](gateway%20%5Bcore%5D/README.md)
- [caddy [service]](caddy%20%5Bservice%5D/README.md)
- [ollama [service]](ollama%20%5Bservice%5D/README.md)
- [opensearch [service]](opensearch%20%5Bservice%5D/README.md)

Useful platform context:

- [Platform Overview](../docs/platform/overview.md)
- [Deployment Models](../docs/platform/deployment-models.md)
- [Topology](../docs/platform/topology.md)
