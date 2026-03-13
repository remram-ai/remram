# Discord Channel

Discord Channel is the feature that lets a runtime participate in Discord without a separate bridge service.

It turns a target environment into a Discord-facing entrypoint for direct messages and allowlisted guild channels.

## What Problem It Solves

Operators and early users need a practical way to reach the runtime from a familiar messaging surface.

Discord Channel provides that ingress while keeping the runtime itself authoritative for session handling, routing, and tool use.

## What It Does

At a high level the feature:

- assigns a Discord bot identity to an environment
- configures Discord policy in runtime channel config
- lets the runtime connect outbound to the Discord gateway
- routes Discord traffic through the normal OpenClaw lifecycle

There is no dedicated Discord service container in this feature model.

## Main Moving Parts

- runtime channel policy in `channels.yaml.template`
- agent channel registration in `agents.yaml`
- environment-specific secrets such as `DISCORD_BOT_TOKEN`
- gateway render inputs that control enablement and allowlists

## Operator View

Operators enable the feature per environment, then interact with the runtime through:

- direct messages to the environment bot
- allowlisted Discord guild channels

Each environment can have its own Discord bot identity and policy.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Runtime Concept](../../docs/concepts/runtime.md)
- [Platform Topology](../../docs/platform/topology.md)
