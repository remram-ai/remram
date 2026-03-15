# Discord Channel Feature Spec

## Feature Summary

- Feature name: discord-channel
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: runtime access through Discord direct messages
- In scope: allowlisted Discord guild and channel access
- In scope: environment-scoped Discord bot identity and policy
- Out of scope: a standalone Discord bridge service
- Out of scope: bypassing normal runtime routing, tool, or session policy

## User Experience

Operators should be able to expose a runtime through Discord using environment-scoped configuration and secrets, while users interact with the runtime through familiar Discord surfaces.

## Functional Requirements

- Discord enablement is render-controlled per environment
- runtime secrets such as `DISCORD_BOT_TOKEN` are available to the target environment
- the runtime can establish its outbound Discord connection after reload
- allowlisted guild or channel traffic is accepted and disallowed traffic is blocked or ignored

## Dependencies

- the Discord Channel skill and runtime policy
- gateway-managed render inputs and reload orchestration
- environment-specific Discord bot credentials
- a healthy target runtime

## Acceptance Criteria

- direct-message interaction works for an enabled environment
- allowlisted guild interaction works when configured
- blocked or disallowed traffic is rejected as expected
- environments remain independently configurable

## Open Questions

- project history for this feature has not yet been reconstructed into `features/discord-channel/projects/`
- the current repo does not yet contain a reconstructed proposal package for the original approval event
