# Discord Channel Operator Guide

Status note:

- this document predates the current managed-pet Gateway/OpenClaw correction
- it is retained as reconstruction material, not as the current live operator guide
- use `README.md` and the owning Moltbox repos first

Status: in flight

## Purpose

Use this skill when you want an environment to receive and answer Discord messages.

This guide describes the intended next-release operator posture on `main`. Discord Channel is not yet part of the current tagged appliance release.

## Environment Model

Configure Discord separately for:

- `dev`
- `test`
- `prod`

Do not assume Discord secrets or allowlists should be copied automatically between environments.

## Before You Start

Prepare:

- one Discord bot identity for the target environment
- the required Discord intents
- the bot token for that environment
- any guild and channel IDs needed for allowlists

## Enable The Feature

Current operator touchpoints are:

- runtime render inputs that enable Discord for the environment
- environment-specific token management
- runtime reload after the config change

Use the target environment lifecycle surface after updating the inputs:

```text
moltbox dev reload
```

## Use In Practice

Recommended posture:

- use DMs for private operator interaction
- use dedicated allowlisted guild channels for shared environment access

The runtime handles the conversation normally once Discord is enabled.

## What To Check

If Discord is not working:

- confirm the environment runtime is healthy
- confirm the bot token is present and valid
- confirm Discord is enabled in the rendered channel policy
- confirm guild or channel IDs are correct
- confirm the bot has the required intents and permissions

## Troubleshooting Basics

Common failure cases:

- token missing or expired
- Discord disabled in config
- guild or channel not allowlisted
- runtime not reloaded after config change
- bot not invited with the right permissions

Current `main` gap:

- the architecture and operator model are defined, but the concrete config write surface and runtime wiring are still in flight
