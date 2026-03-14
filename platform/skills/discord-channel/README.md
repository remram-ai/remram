# Discord Channel

Status: in flight

Discord Channel is the skill that lets a runtime participate in Discord without a separate bridge service.

It turns a target environment into a Discord-facing entrypoint for direct messages and allowlisted guild channels.

This is a next-release platform item on `main`. It is not part of the current tagged appliance release.

## What Problem It Solves

Operators and early users need a practical way to reach the runtime from a familiar messaging surface.

Discord Channel provides that ingress while keeping the runtime itself authoritative for session handling, routing, and tool use.

## What It Does

At a high level the skill:

- assigns a Discord bot identity to an environment
- configures Discord policy in runtime channel config
- lets the runtime connect outbound to the Discord gateway
- routes Discord traffic through the normal OpenClaw lifecycle

There is no dedicated Discord service container in this skill model.

Current architecture model:

- Discord remains a runtime capability inside the environment container boundary
- the gateway owns render inputs, secrets, reload orchestration, and operator control
- service packages stay in `moltbox-services` only when a shared appliance container is genuinely required
- plugin-backed extensions remain runtime-local rather than becoming a second control plane

## Main Moving Parts

- runtime channel policy in `channels.yaml.template`
- agent channel registration in `agents.yaml`
- environment-specific secrets such as `DISCORD_BOT_TOKEN`
- gateway render inputs that control enablement and allowlists

Current `main` gap:

- the platform contract is documented, but the runtime templates, gateway render path, and package/runtime wiring are still incomplete

## Operator View

Operators enable the skill per environment, then interact with the runtime through:

- direct messages to the environment bot
- allowlisted Discord guild channels

Each environment can have its own Discord bot identity and policy.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Runtime Concept](../../../docs/concepts/runtime.md)
- [Platform Topology](../../../docs/overview/topology.md)
