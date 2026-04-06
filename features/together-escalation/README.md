# Together Escalation

## Summary

Together Escalation is the approved feature that keeps normal runtime requests local first while allowing OpenClaw to recover to Together-hosted models when the local provider fails.

It is a higher-level runtime capability, not just one packaging approach.

## Status

Active feature.

Historical proposal and project artifacts for this feature have not yet been fully reconstructed from the older documentation set.

## User And Operator Outcome

- normal runtime requests stay local-first by default
- the runtime can recover automatically when the local provider fails
- operators manage credentials and rollout through the documented appliance flows
- the behavior belongs to the service/runtime baseline, not to a separate appliance service

## Primary Platform Deliverables

- native OpenClaw model/provider policy in the current service baseline
- supporting authorities:
  - `moltbox-gateway`
  - `moltbox-services`
  - `moltbox-runtime`

Historical or optional packaging direction:

- [Together Escalation Skill Record](../../platform/skills/together-escalation/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Documentation

- [Together AI Escalation Feature Guide](../../docs/features/together-escalation.md)
- [Runtime Concept](../../docs/concepts/runtime.md)
- [Feature Concept](../../docs/concepts/feature.md)
