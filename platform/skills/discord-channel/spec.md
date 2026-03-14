# Discord Channel Specification

## Purpose

Discord Channel is the runtime-ingress feature that exposes an environment through the built-in OpenClaw Discord channel.

It is environment-owned behavior, not a shared standalone appliance service.

## Implementation Surfaces

Primary evidence:

- `moltbox-runtime/openclaw-*/channels.yaml.template`
- `moltbox-runtime/openclaw-*/agents.yaml`
- `moltbox-gateway/runtime/src/moltbox_runtime/template_context.py`
- legacy operator guide material in `moltbox-gateway/docs/operator/discord.md`

## Architecture Components

The feature depends on:

1. runtime channel policy
2. agent channel exposure
3. environment secret material
4. runtime lifecycle for applying config changes

## Lifecycle

### Configure

The feature is configured per environment.

Important configuration surfaces include:

- `channels.yaml`
- runtime environment secrets such as `DISCORD_BOT_TOKEN`
- gateway render inputs for enablement and guild/channel allowlists

### Activate

After config changes are applied, the environment is reloaded so the runtime can establish its outbound Discord connection.

### Run

At runtime:

1. a Discord DM, mention, slash command, or allowlisted channel message reaches the bot
2. the runtime receives the event through OpenClaw's native Discord channel
3. the request enters the normal OpenClaw and routing lifecycle
4. the runtime returns the response through Discord

## Dependencies

Required dependencies:

- a Discord application and bot for the environment
- correct bot token handling
- required Discord intents
- a healthy target runtime

Policy dependencies:

- Discord enablement per environment
- correct guild and channel allowlists
- operator/user pairing and identity policy for DMs and group sessions

## Runtime Behavior

Observed policy from the current runtime templates:

- Discord is render-controlled rather than permanently on
- DMs are enabled
- group policy is allowlist-based
- config writes from Discord are disabled
- bot traffic is not blindly trusted
- group sessions require resolvable speaker identity

The runtime remains authoritative for:

- agent selection
- semantic routing
- tool execution
- memory and privilege policy

## Deployment Implications

This feature does not create a separate Discord service deployment.

Operational touchpoints are:

- runtime config rendering
- runtime reload
- runtime health
- environment-specific secrets

## Constraints And Edge Cases

- there is no separate `moltbox discord ...` namespace
- Discord is disabled until explicitly enabled for an environment
- missing Message Content intent or invalid tokens will break ingress
- promotion between environments does not automatically transfer Discord secrets or allowlists

## TODO

- document the exact active Moltbox operator flow for editing Discord runtime inputs once the environment configuration write surface is finalized under the current CLI
