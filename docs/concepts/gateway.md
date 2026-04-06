# Gateway

The Gateway is the Moltbox appliance control plane.

In the current architecture, the detailed Gateway contract lives in the `moltbox-gateway` repo:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)

## Concept Summary

At the concept level, Gateway is the layer that:

- exposes the `moltbox` CLI
- manages the appliance service plane
- guards risky changes with snapshots and deployment records
- keeps the operator workflow separate from raw Docker operations
- treats OpenClaw runtimes as managed pets rather than replay-first disposable containers

Gateway does not own:

- service definitions as source material
- baseline service inputs as source material
- final deployable runtime artifacts as source material
- Cortex implementation
- application implementation

Those belong in the sibling domain repositories.

If you need the live operator contract, CLI shape, service inventory, or Gateway/OpenClaw lifecycle rules, use the Gateway repo docs rather than expanding this concept page.
