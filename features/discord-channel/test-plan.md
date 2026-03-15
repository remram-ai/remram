# Discord Channel Master Test Plan

## Test Objectives

- validate the feature-level user and operator goals for Discord ingress
- confirm the feature remains environment-scoped and policy-controlled
- confirm the feature rolls up the lower-level runtime and Discord-channel checks it depends on

## User Or Operator Goals

- as an operator, I can enable Discord for one environment without affecting others
- as a user, I can reach the runtime through a direct message to the environment bot
- as an operator, I can allow specific guild or channel traffic and reject disallowed traffic
- as an operator, I can diagnose failures as config, token, or runtime-health problems

## Scope

- In scope: feature-level acceptance of DM access, allowlisted guild access, and environment isolation
- In scope: operator-visible configuration and reload flow
- Out of scope: component-only skill implementation details already covered by the platform item plan

## Referenced Lower-Level Plans

- [Discord Channel Platform Test Plan](../../platform/skills/discord-channel/test-plan.md)
- [Gateway Platform Test Plan](../../platform/core/gateway/test-plan.md)

## Preconditions

- target runtime environment is available
- a valid `DISCORD_BOT_TOKEN` is configured for the environment under test
- Discord enablement and allowlists are rendered into the target environment
- the target runtime can be reloaded successfully

## Test Cases

1. Scenario: operator enables Discord for one environment and reloads it.
   Expected result: the runtime connects successfully and other environments remain unchanged.
2. Scenario: user sends a direct message to the environment bot.
   Expected result: the runtime receives the message and returns a response through Discord.
3. Scenario: user sends traffic from an allowlisted guild or channel and then from a disallowed one.
   Expected result: allowlisted traffic is accepted and disallowed traffic is rejected or ignored according to policy.
4. Scenario: operator inspects a failure caused by invalid token, bad allowlist, or unhealthy runtime.
   Expected result: the failure can be traced to a clear config, secret, or runtime-health cause.

## Exit Criteria

- the user and operator goals above are satisfied
- referenced lower-level Discord-channel and gateway validations pass for the environment under test
- Discord access remains environment-scoped and policy-controlled

## Results Summary

- [Result]
