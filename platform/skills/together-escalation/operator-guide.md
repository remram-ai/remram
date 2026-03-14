# Together Escalation Operator Guide

## Purpose

Use this skill when you want a Moltbox runtime to keep default chat local while recovering to stronger Together-hosted models for chat, reasoning, and coding when fallback is needed.

## Where It Runs

Together Escalation is installed per environment:

- `dev`
- `test`
- `prod`

## Prerequisites

Before enabling it, confirm:

- the target runtime is healthy
- `ollama` is reachable for the local chat primary
- `TOGETHER_API_KEY` is present for the target environment
- the runtime model catalog includes the required Together model refs
- the runtime baseline contains the role-policy files that describe reasoning and coding behavior

## Install

Deploy or reload the target runtime so the gateway stages the skill folder and injects the required secret:

```text
moltbox gateway service deploy dev
```

Then verify:

```text
moltbox dev openclaw skills list
moltbox dev openclaw skills info together-escalation
```

If the active gateway build exposes native model inspection through the same passthrough surface, also verify the resolved model state:

```text
moltbox dev openclaw models status
moltbox dev openclaw models list
```

If the runtime requires explicit trust or allowlisting, apply the required OpenClaw config changes before treating the skill as active.

## Use In Practice

Once installed, the skill changes model recovery behavior inside the existing runtime.

Normal chat should begin on `ollama/qwen3:8b`. If the local model fails through a fallback-eligible path, the runtime should recover to Maverick. Reasoning and coding work should use their Together chains automatically when those role paths are invoked.

The skill does not create a new operator-facing chat endpoint and it does not introduce a separate Together service container.

## Promote To Test And Prod

Use `dev` first, then promote deliberately:

1. install and validate in `dev`
2. install and validate in `test`
3. install and validate in `prod`

Promotion means repeating the runtime deploy and verification steps in each environment. It does not automatically copy Together credentials or live runtime state across environments.

## What To Check

If the skill is not working:

- confirm the skill is present under the runtime's skill inventory
- confirm `TOGETHER_API_KEY` is present in the target environment
- confirm all required Together model refs are present in the runtime model catalog
- confirm the chat, reasoning, and coding role chains match the documented order
- confirm runtime logs show the expected selected model or fallback path

## Troubleshooting Basics

Common problems:

- local chat never reaches Maverick because the chat fallback chain was not written to the default-agent model config
- a Together model is missing from `agents.defaults.models`, causing a model-allowlist failure instead of recovery
- reasoning or coding policy points at the wrong model id
- the provider is configured under the wrong name instead of `together`
- `dev` works but `test` or `prod` is missing the required key or runtime deploy

## TODO

- document the exact preferred Moltbox-wrapped commands for inspecting effective model chains once the gateway's OpenClaw passthrough surface is finalized
