# Discord Channel

## Summary

Discord Channel is the approved feature that lets a runtime participate in Discord through direct messages and allowlisted guild channels.

It is a higher-level communication feature, not just the runtime skill that implements one part of it.

## Status

In flight.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## User And Operator Outcome

- operators can expose an environment through Discord without a separate bridge service
- users can reach the runtime through direct messages or approved guild channels
- Discord policy remains environment-scoped and operator-controlled
- the runtime remains authoritative for routing, tools, and session behavior

## Primary Platform Deliverables

- [Discord Channel Skill](../../platform/skills/discord-channel/README.md)
- supporting platform dependency:
  - [Gateway](../../platform/core/gateway/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Documentation

- [Runtime Concept](../../docs/concepts/runtime.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
