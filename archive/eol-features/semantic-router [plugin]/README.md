# Semantic Router

Semantic Router is the local-first routing feature for OpenClaw runtimes in the Moltbox appliance.

It gives the runtime a bounded answer-or-escalate ladder so simple requests can stay local while harder requests escalate through stronger reasoning tiers.

## What Problem It Solves

Without a routing layer, every request either stays local when it should escalate or escalates too early and wastes latency and cost.

Semantic Router adds a controlled routing policy that helps the runtime:

- prefer local answers when they are good enough
- escalate only when needed
- keep routing behavior observable for operators

## What It Does

The feature is implemented as an OpenClaw plugin-backed skill.

At a high level it:

- installs into a target runtime through the native OpenClaw plugin lifecycle
- reads router policy from runtime baseline files
- selects a routing stage for the current request
- records routing telemetry and debug data

## Main Moving Parts

- the `semantic-router` skill package in `remram-skills`
- runtime baseline config in `moltbox-runtime`
- runtime-local OpenClaw plugin install state
- local `ollama` and remote reasoning providers used by the ladder

## Operator View

Operators install and inspect the feature through environment-scoped OpenClaw passthrough commands such as:

```text
moltbox dev openclaw plugins install semantic-router
```

The feature is runtime-specific. `dev`, `test`, and `prod` can carry different install state or promotion timing even when they share the same baseline config.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
- [Runtime Concept](../../../docs/concepts/runtime.md)
