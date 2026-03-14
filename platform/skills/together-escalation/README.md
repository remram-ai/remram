# Together Escalation

Together Escalation is the skill that configures Together AI model escalation for OpenClaw runtimes in the Moltbox appliance.

It gives the default runtime agent a local-first chat posture while defining stronger Together-hosted fallback chains for chat, reasoning, and coding work.

## What Problem It Solves

Without a defined escalation policy, runtimes either stay on the local model when they should recover to a stronger cloud model or use Together models in an ad hoc way that is hard to observe and promote.

Together Escalation defines that policy so the runtime can:

- keep normal chat local on `ollama/qwen3:8b`
- escalate chat to Maverick when fallback is required
- use Together-hosted reasoning and coding models with explicit fallback order
- keep model selection and failure behavior visible to operators

## What It Does

The skill is implemented as an OpenClaw skill folder plus runtime baseline policy.

At a high level it:

- stages the `together-escalation` skill folder into the target runtime's managed OpenClaw state
- configures Together-backed model refs for the default agent and tool-driven role paths
- establishes ordered fallback chains per role
- depends on Together provider auth and runtime-visible model catalog entries

## Runtime Configuration

Validated runtime chains:

- chat primary: `ollama/qwen3:8b`
- chat fallback: `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`
- reasoning primary: `together/moonshotai/Kimi-K2.5`
- reasoning fallback: `together/Qwen/Qwen3.5-397B-A17B`
- coding primary: `together/Qwen/Qwen3-Coder-Next-FP8`
- coding fallback: `together/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8`

Together uses the built-in OpenClaw provider id `together` and the canonical model-ref format `together/<publisher>/<model>`.

## Main Moving Parts

- the `together-escalation` skill package in `remram-skills`
- runtime baseline config in `moltbox-runtime`
- runtime-local OpenClaw skill state under `~/.openclaw/skills`
- OpenClaw model catalog and provider auth for Together
- local `ollama` connectivity for the primary chat model

## Secrets And Deployment

Together credentials flow through the gateway-owned secret system:

```text
moltbox dev secrets set TOGETHER_API_KEY
moltbox gateway service deploy dev
```

The gateway retrieves the encrypted secret, renders it into the runtime service `.env`, and injects `TOGETHER_API_KEY` into the OpenClaw container. Operators should not read or write runtime secrets directly on disk.

## Operator View

Operators deploy the skill by redeploying or reloading the target runtime so the gateway can stage the skill folder and inject the required auth:

```text
moltbox gateway service deploy dev
```

Then inspect it through environment-scoped OpenClaw passthrough commands such as:

```text
moltbox dev openclaw skills list
moltbox dev openclaw models status
```

The skill is runtime-specific. `dev`, `test`, and `prod` can carry different credentials or promotion timing.

## Validated Behavior

The production baseline was validated on the appliance with the following results:

- normal local inference stays on `ollama/qwen3:8b`
- fallback activates only after the local provider fails
- a forced Ollama outage recovered to `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`
- Together and Ollama both returned the same standard OpenClaw response envelope with `payloads` and `meta`
- deprecated `semantic-router` baseline artifacts were removed from runtime state and startup

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
- [Runtime Concept](../../../docs/concepts/runtime.md)
