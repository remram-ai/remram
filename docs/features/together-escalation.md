# Together AI Escalation

## Overview

Together AI Escalation is a Moltbox runtime feature that keeps normal chat local on Ollama while allowing OpenClaw to recover automatically to Together when the local model fails.

This is implemented as a skill-backed runtime feature.

It is specifically backed by the `together-escalation` OpenClaw skill plus runtime policy in the Moltbox runtime baseline.

It is not a standalone plugin and it does not add a separate Together service container.

## What this feature does

The feature gives each OpenClaw runtime an explicit local-first and cloud-fallback model policy:

- normal chat starts on `ollama/qwen3:8b`
- chat falls back to `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`
- reasoning uses `together/moonshotai/Kimi-K2.5` with fallback to `together/Qwen/Qwen3.5-397B-A17B`
- coding uses `together/Qwen/Qwen3-Coder-Next-FP8` with fallback to `together/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8`

In practice, that means local inference stays the default path, but the runtime can still complete a request when the local provider times out or becomes unavailable.

## How to enable it

Store the Together API key through the gateway-owned secrets system for the target environment:

```text
moltbox dev secrets set TOGETHER_API_KEY
```

Then deploy or reload the runtime so the gateway stages the skill and injects the secret into the runtime environment:

```text
moltbox gateway service deploy dev
```

Verify the feature is active:

```text
moltbox dev openclaw skills info together-escalation
moltbox dev openclaw models status
```

## Required components

- skill: `remram-skills/skills/together-escalation`
- core component: OpenClaw runtime model failover
- core component: gateway-managed scoped secret injection
- service: `ollama` for the local primary model
- service: `openclaw-dev`, `openclaw-test`, or `openclaw-prod`

## Deployment steps

1. Store `TOGETHER_API_KEY` in the target environment with `moltbox <env> secrets set TOGETHER_API_KEY`.
2. Deploy the runtime with `moltbox gateway service deploy <env>`.
3. Confirm the skill is staged with `moltbox <env> openclaw skills list`.
4. Confirm the model chain with `moltbox <env> openclaw models status`.
5. Validate a normal local request, then validate a forced fallback by temporarily stopping Ollama and rerunning the same request.

## User workflow

For normal use, operators and users do not choose between Ollama and Together manually.

They send a normal runtime request, for example:

```text
moltbox dev openclaw agent --agent main --local --thinking off --message hello --json
```

When local inference is healthy, the response comes from:

- provider: `ollama`
- model: `qwen3:8b`

If the local provider fails through OpenClaw failover conditions, the same request can recover automatically to:

- provider: `together`
- model: `meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`

The response envelope stays the same in both cases, using the standard OpenClaw `payloads` and `meta` structure.

## Operational notes

- Together uses the provider id `together` and canonical model refs in the form `together/<publisher>/<model>`.
- The Together API key must be stored as `TOGETHER_API_KEY` because that is the runtime env var consumed by the deployed OpenClaw containers.
- Secrets must flow through `CLI -> gateway -> encrypted secret store -> runtime injection`.
- Operators should not read or write runtime secrets directly on disk.
- Runtime logs should show fallback decisions such as `candidate_failed` and `candidate_succeeded` without leaking API keys.
- Deprecated `semantic-router` runtime artifacts are no longer part of the runtime baseline and should not appear in skill inventory or startup logs.

## Related platform records

- [Together Escalation Skill README](../../platform/skills/together-escalation/README.md)
- [Together Escalation Specification](../../platform/skills/together-escalation/spec.md)
- [Together Escalation Operator Guide](../../platform/skills/together-escalation/operator-guide.md)
- [Together Escalation Test Plan](../../platform/skills/together-escalation/test-plan.md)
