# Discord Channel Test Plan

## Definition Of Done

Discord Channel is done for an environment when:

- Discord render inputs produce the expected runtime config
- the environment runtime comes up healthy
- direct-message interaction works
- allowlisted guild interaction works when configured
- blocked or disallowed traffic is rejected as expected

## Core Validation

### 1. Render Validation

Verify the target environment produces:

- `channels.discord.enabled: true` when enabled
- the expected guild and channel allowlists
- agent channel exposure for `discord`

### 2. Secret Validation

Verify the environment has a valid Discord bot token available to the runtime.

### 3. Runtime Validation

Verify the target runtime:

- starts or reloads successfully
- can establish the outbound Discord connection
- remains healthy after the feature is enabled

### 4. DM Validation

Send a DM to the environment bot.

Expected result:

- pairing or authorization flow completes if required
- the runtime returns a response through Discord

### 5. Guild Validation

Send a message from an allowlisted guild or channel.

Expected result:

- the runtime accepts the message according to policy
- non-allowlisted traffic is rejected or ignored

## Failure Cases To Test

- invalid or missing `DISCORD_BOT_TOKEN`
- Discord left disabled in config
- missing Message Content intent
- incorrect guild or channel IDs
- runtime healthy locally but not connected to Discord

## Operator-Visible Success Criteria

- operators can enable Discord per environment without changing code
- each environment bot behaves independently
- the runtime stays in control of routing and policy
- failure points are diagnosable from config, token, or runtime health

## Deployment And Runtime Checks

- verify config render output before reload
- verify runtime health after reload
- verify logs show Discord channel activity or connection failures
