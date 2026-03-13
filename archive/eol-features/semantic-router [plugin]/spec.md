# Semantic Router Specification

## Purpose

Semantic Router is the chat-time routing feature that gives Moltbox runtimes a bounded local-first escalation ladder.

It is a feature because it changes how requests are answered, escalated, and observed, not just how the runtime is packaged.

## Implementation Surfaces

Primary evidence:

- `remram-skills/skills/semantic-router/`
- `moltbox-runtime/openclaw-*/semantic-router.yaml`
- `moltbox-runtime/openclaw-*/routing.yaml`
- `moltbox-runtime/openclaw-*/model-runtime.yml`

Important package files:

- `openclaw.plugin.json`
- `SKILL.md`
- `index.ts`
- `router/default-config.json`
- `example-config.json`

## Architecture Components

Semantic Router depends on four layers working together:

1. skill package in `remram-skills`
2. runtime baseline config in `moltbox-runtime`
3. runtime-local OpenClaw install state
4. supporting providers such as `ollama` and configured cloud reasoning backends

## Lifecycle

### Install

The feature is installed into a runtime through the native OpenClaw plugin lifecycle.

Example direction:

```text
moltbox dev openclaw plugins install semantic-router
```

The install writes runtime-local plugin state and may require explicit trust or allowlisting in OpenClaw config.

### Configure

The feature expects baseline config from the runtime repo, including:

- `semantic-router.yaml` for ladder and guardrails
- `routing.yaml` for routing posture
- `model-runtime.yml` for provider and model policy

OpenClaw config also needs a provider entry and plugin allowance for `semantic-router`.

### Execute

At request time the feature:

1. enters through the normal OpenClaw reply lifecycle
2. chooses the current routing stage
3. attempts a local answer first
4. escalates if the request exceeds the current stage
5. records structured telemetry

### Persist

The feature persists runtime-local install state and debug artifacts inside the runtime environment rather than back into Git automatically.

## Dependencies

Required dependencies:

- OpenClaw plugin support
- local `ollama` connectivity for the local routing stage
- remote provider credentials for cloud reasoning stages
- runtime plugin allowance for `semantic-router`

## Runtime Behavior

Observed baseline behavior from the current config:

- local-first posture
- bounded escalation depth
- stage timeout and budget controls
- local `ollama` routing stage
- remote reasoning and deep-thinking stages

The feature is designed to preserve normal OpenClaw execution rather than replacing it with a parallel runtime.

## Deployment Implications

Semantic Router is not a separate service deployment.

Its deployment affects:

- runtime mutable state
- runtime deployment-event history
- runtime snapshots before mutation

Because it installs through native OpenClaw behavior, the live runtime may differ from the Git baseline after install until a later checkpoint promotes that state.

## Constraints And Edge Cases

- if `ollama` is unavailable, local routing cannot satisfy the first stage
- if cloud keys are missing, escalations may fail or fall back according to runtime policy
- if the plugin is installed but not trusted, it may load but remain unusable
- provider base URLs must match the active gateway/runtime port contract

## TODO

- document the exact OpenClaw hook sequence used by the appliance runtime version once that contract is frozen
- document the final location of runtime debug artifacts after storage normalization is fully settled
