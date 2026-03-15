# Together Escalation

## Summary

Together Escalation is the approved feature that keeps normal runtime chat local while allowing OpenClaw to recover automatically to Together-hosted models when the local model fails.

It is a higher-level runtime capability, not just the skill package that implements part of it.

## Status

Active feature.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## User And Operator Outcome

- normal runtime requests stay local-first by default
- the runtime can recover automatically when the local provider fails
- reasoning and coding paths use explicit stronger Together-backed model chains
- operators manage credentials and deployment through the gateway-owned lifecycle

## Primary Platform Deliverables

- [Together Escalation Skill](../../platform/skills/together-escalation/README.md)
- supporting platform dependencies:
  - [Gateway](../../platform/core/gateway/README.md)
  - [Ollama](../../platform/services/ollama/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Projects](projects/README.md)

## Related Documentation

- [Together AI Escalation Feature Guide](../../docs/features/together-escalation.md)
- [Runtime Concept](../../docs/concepts/runtime.md)
- [Feature Concept](../../docs/concepts/feature.md)
