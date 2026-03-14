# Moltbox Telemetry

Moltbox Telemetry is the plugin that enables and standardizes runtime telemetry for OpenClaw runtimes inside the Moltbox appliance.

It gives Moltbox a consistent telemetry contract on top of OpenClaw's native diagnostics, status, and usage surfaces without changing routing, fallback policy, or model selection.

## What Problem It Solves

Without a standard telemetry layer, OpenClaw can already emit useful diagnostics and usage data, but Moltbox cannot assume one stable field set across runtimes, plugins, and UI surfaces.

Moltbox Telemetry solves that by ensuring the runtime exposes the same expected response and diagnostics fields for every supported environment.

## What It Does

The feature is implemented as an OpenClaw plugin.

At a high level it:

- requires OpenClaw diagnostics telemetry to be enabled
- standardizes the model telemetry fields Moltbox expects to observe
- aligns those fields with OpenClaw's native diagnostics and `/usage` surfaces
- keeps telemetry observable through normal OpenClaw diagnostics surfaces

## Expected Telemetry Fields

The plugin standardizes:

- `model`
- `provider`
- `input_tokens`
- `output_tokens`
- `total_tokens`
- `context_pct`
- `provider_latency_ms`

## Main Moving Parts

- the `moltbox-telemetry` plugin package in `remram-skills`
- runtime baseline OpenClaw config in `moltbox-runtime`
- OpenClaw diagnostics events such as `model.usage`
- runtime-local plugin install state
- diagnostics logs and response-side telemetry surfaces

## Operator View

Operators install and inspect the feature through environment-scoped OpenClaw passthrough commands such as:

```text
moltbox dev openclaw plugins install moltbox-telemetry
```

After install, operators should be able to verify telemetry through chat responses, diagnostics output, and runtime logs.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
- [Runtime Concept](../../docs/concepts/runtime.md)
