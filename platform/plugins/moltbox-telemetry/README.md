# Moltbox Telemetry

Status: in flight

Moltbox Telemetry is the plugin-oriented platform item for standardized runtime telemetry across Moltbox environments.

It aims to give operators and downstream tooling one stable telemetry contract for model identity, token usage, context usage, and provider latency.

## What Problem It Solves

Without a standard telemetry layer, OpenClaw can emit useful diagnostics and usage data, but Moltbox cannot assume one stable field set across runtimes, plugins, and UI surfaces.

## Current Architecture Direction

- telemetry remains a runtime-local plugin-backed extension
- the live appliance no longer uses replay/checkpoint as the normal runtime lifecycle
- operator rollout should follow the native runtime model plus snapshot-first guardrails
- baseline service config belongs in `moltbox-services`
- final deployable runtime artifacts belong in `moltbox-runtime`
- operator and verification flow belongs in `moltbox-gateway`

## Main Moving Parts

- the `moltbox-telemetry` plugin package in `remram-skills`
- runtime-local plugin install state
- service and runtime baseline wiring in the owning Moltbox repos
- diagnostics logs and response-side telemetry surfaces

## Current Gap

The platform contract is documented, but the plugin package and runtime integration are still in flight.

## Documentation Posture

This README is the active entry point for the item.

The older local `spec.md`, `operator-guide.md`, and `test-plan.md` files predate the current managed-pet Gateway/OpenClaw correction and should be treated as in-flight reconstruction material until they are rewritten to the current model.

## Related Documents

- [Feature Record](../../../features/moltbox-telemetry/README.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
- [Runtime Concept](../../../docs/concepts/runtime.md)
