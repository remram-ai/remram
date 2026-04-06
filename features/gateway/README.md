# Gateway

## Summary

Gateway is the approved feature for the Moltbox appliance control plane.

It gives operators and automation one governed path for appliance management, runtime access, verification, and recovery-aware deployment.

## Status

Active feature.

Historical proposal and project artifacts for this feature have not yet been fully reconstructed from the older documentation set.

## User And Operator Outcome

- operators manage the appliance through `moltbox` instead of ad hoc Docker-first workflows
- service deployment and restart actions route through one control plane
- `test` is the proving lane for runtime changes
- `prod` is a protected managed pet
- verification can stay inside restricted SSH roles through dedicated CLI surfaces
- recovery is snapshot-first rather than replay/checkpoint-first

## Primary Platform Deliverables

- [Moltbox Gateway](../../platform/core/gateway/README.md)
- supporting service and runtime authorities:
  - `moltbox-services`
  - `moltbox-runtime`

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Documentation

- [Gateway Concept](../../docs/concepts/gateway.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
