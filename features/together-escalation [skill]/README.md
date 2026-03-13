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

The feature is implemented as an OpenClaw skill folder plus runtime baseline policy.

At a high level it:

- stages the `together-escalation` skill folder into the target runtime's managed OpenClaw state
- configures Together-backed model refs for the default agent and tool-driven role paths
- establishes ordered fallback chains per role
- depends on Together provider auth and runtime-visible model catalog entries

## Main Moving Parts

- the `together-escalation` skill package in `remram-skills`
- runtime baseline config in `moltbox-runtime`
- runtime-local OpenClaw skill state under `~/.openclaw/skills`
- OpenClaw model catalog and provider auth for Together
- local `ollama` connectivity for the primary chat model

## Operator View

Operators deploy the feature by redeploying or reloading the target runtime so the gateway can stage the skill folder and inject the required auth:

```text
moltbox gateway service deploy dev
```

Then inspect it through environment-scoped OpenClaw passthrough commands such as:

```text
moltbox dev openclaw skills list
```

The feature is runtime-specific. `dev`, `test`, and `prod` can carry different credentials or promotion timing.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Deployment Models](../../docs/platform/deployment-models.md)
- [Runtime Concept](../../docs/concepts/runtime.md)
