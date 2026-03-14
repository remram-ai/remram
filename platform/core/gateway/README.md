# Moltbox Gateway

Moltbox Gateway is the control-plane core component of the appliance.

It is the part of the system that turns Git-backed configuration and service definitions into a running, manageable appliance.

## What Problem It Solves

Without a control plane, the appliance would be a loose set of containers and config files with no clear operator surface, no consistent deployment records, and no disciplined lifecycle model.

Gateway solves that by giving the appliance:

- one operator-facing CLI
- one deployment coordinator
- one place where deployment metadata is written
- one control path for service and runtime lifecycle

## What It Does

At a high level, Gateway:

- exposes the `moltbox` CLI
- drives service deployment and runtime lifecycle operations
- mediates native OpenClaw passthrough operations
- records deployment events and deployment metadata
- coordinates snapshots, replay history, and checkpoint-related lifecycle
- appends host-level self-update provenance to `/var/lib/moltbox/history.jsonl`

## Main Moving Parts

- the `gateway` container itself
- the `moltbox` CLI used over SSH from the workstation
- the internal token-authenticated MCP HTTP surface for appliance agents
- repository inputs from `moltbox-services`, `moltbox-runtime`, and `remram-skills`
- appliance state under `/srv/moltbox-state`
- appliance logs under `/srv/moltbox-logs`

## Operator View

Operators interact with the gateway through resource-oriented commands such as:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway mcp-stdio
moltbox gateway docker ping
moltbox gateway docker run hello-world
moltbox gateway service deploy opensearch
moltbox dev reload
moltbox dev skill deploy together
```

The gateway is also the path through which environment-scoped native OpenClaw operations are reached.

## Why It Matters

Gateway is not just another service. It is the appliance authority boundary.

It keeps deployment, lifecycle mutation, and operator control behind one governed interface instead of spreading those concerns across Docker commands, ad hoc scripts, or direct config edits.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Platform Overview](../../../docs/overview/overview.md)
- [CLI Architecture](../../../docs/overview/cli-architecture.md)
