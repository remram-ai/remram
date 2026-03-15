# Moltbox Telemetry

## Summary

Moltbox Telemetry is the approved feature for standardized runtime telemetry across Moltbox environments.

It gives operators and downstream tooling one stable telemetry contract for model identity, token usage, context usage, and provider latency.

## Status

In flight.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## User And Operator Outcome

- operators can inspect one stable telemetry field set instead of provider-specific output
- runtimes expose the same telemetry contract across environments
- response-side telemetry and diagnostics output stay aligned
- downstream UI or reporting layers can consume telemetry without per-runtime reinterpretation

## Primary Platform Deliverables

- [Moltbox Telemetry Plugin](../../platform/plugins/moltbox-telemetry/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Projects](projects/README.md)

## Related Documentation

- [Runtime Concept](../../docs/concepts/runtime.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
