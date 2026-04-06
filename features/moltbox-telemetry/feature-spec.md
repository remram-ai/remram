# Moltbox Telemetry Feature Spec

## Feature Summary

- Feature name: moltbox-telemetry
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: standardized runtime telemetry fields for model usage
- In scope: aligned response-side telemetry and diagnostics visibility
- In scope: consistent telemetry behavior across the current managed runtimes
- Out of scope: routing policy
- Out of scope: model fallback logic
- Out of scope: provider credential policy beyond existing runtime needs

## User Experience

Operators and higher-level tooling should be able to inspect runtime telemetry through one stable contract rather than interpreting provider-specific or environment-specific field layouts.

## Functional Requirements

- runtimes expose `model`, `provider`, token counts, `context_pct`, and `provider_latency_ms`
- diagnostics stay enabled where the feature is installed
- response-side telemetry and diagnostics output stay consistent
- the feature remains telemetry-only and does not change visible routing behavior

## Dependencies

- the `moltbox-telemetry` plugin package in `remram-skills`
- runtime diagnostics enabled in baseline config
- runtime-local plugin install state
- operator-visible usage or diagnostics surfaces

## Acceptance Criteria

- the standardized telemetry field contract is visible in chat responses and diagnostics output
- the same telemetry contract is usable across the current managed runtimes where the feature is enabled
- latency is visible as `provider_latency_ms`
- the runtime remains behaviorally unchanged apart from telemetry visibility

## Open Questions

- project history for this feature has not yet been reconstructed into `features/moltbox-telemetry/projects/`
- downstream UI consumers for the telemetry contract remain incomplete on `main`
