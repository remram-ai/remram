# Together Escalation Specification

Status note:

- this document predates the current managed-pet Gateway/OpenClaw correction
- it is retained as reconstruction material, not as the current live appliance contract
- use `README.md`, `features/together-escalation/README.md`, `docs/features/together-escalation.md`, and the owning Moltbox repos first

## Purpose

Together Escalation is the runtime skill that gives Moltbox environments an explicit Together AI fallback policy for the default agent's chat, reasoning, and coding paths.

It is a skill because it changes how the runtime recovers from model failure and how stronger cloud models are introduced into live execution, not just how credentials are stored.

## Implementation Surfaces

Primary evidence and owning inputs:

- `remram-skills/skills/together-escalation/`
- `moltbox-runtime/openclaw-*/openclaw.json.template`
- `moltbox-runtime/openclaw-*/model-runtime.yml`
- `moltbox-runtime/openclaw-*/tools.yaml`
- `moltbox-services/services/openclaw-*/compose.yml.template`

## Architecture Components

Together Escalation depends on four layers working together:

1. a skill package in `remram-skills`
2. OpenClaw model catalog and fallback config in the runtime baseline
3. runtime role policy for reasoning and coding work
4. Together provider authentication for the target environment

## Provider Assumptions

OpenClaw's current provider documentation establishes the following assumptions:

- Together uses the provider id `together`
- model refs use `together/<publisher>/<model>`
- Together authentication is based on `TOGETHER_API_KEY`
- Together is treated as an OpenAI-compatible provider

The skill must preserve that provider identity instead of introducing a second alias such as `together-ai` or `cloud-together`.

The current Moltbox runtime uses OpenClaw's built-in Together handling plus `TOGETHER_API_KEY`. No alternate provider alias is introduced, and no explicit `models.providers.together` entry is required in the validated baseline.

## Model Role Configuration

The skill defines three role-specific chains.

### Chat Role

The default chat path remains local-first:

- primary: `ollama/qwen3:8b`
- fallback: `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`

For the normal default-agent reply path, the OpenClaw-facing config should use the documented `agents.defaults.model.primary` and `agents.defaults.model.fallbacks` fields.

Illustrative OpenClaw-facing shape:

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "ollama/qwen3:8b",
        "fallbacks": [
          "together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8"
        ]
      },
      "models": {
        "ollama/qwen3:8b": {
          "alias": "Local Qwen3"
        },
        "together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8": {
          "alias": "Maverick"
        },
        "together/moonshotai/Kimi-K2.5": {
          "alias": "Kimi K2.5"
        },
        "together/Qwen/Qwen3.5-397B-A17B": {
          "alias": "Qwen 3.5 397B"
        },
        "together/Qwen/Qwen3-Coder-Next-FP8": {
          "alias": "Qwen Coder Next"
        },
        "together/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8": {
          "alias": "Qwen Coder 480B"
        }
      }
    }
  }
}
```

If `agents.defaults.models` is present, every model in the role chains must appear in that allowlist or OpenClaw can reject the model before a normal reply is produced.

### Reasoning Role

The reasoning chain is:

- primary: `together/moonshotai/Kimi-K2.5`
- fallback: `together/Qwen/Qwen3.5-397B-A17B`

This role is skill-owned runtime policy rather than a separate OpenClaw core top-level field in the currently documented schema. In the Moltbox runtime model, it should align with the existing reasoning-oriented policy surfaces in `model-runtime.yml` and the `think` tool path in `tools.yaml`.

The important contract is:

- the role resolves to a Together-backed primary model ref
- the role has one ordered fallback model ref
- both model refs are present in the OpenClaw model catalog
- runtime prompts or tool execution that request the reasoning role use that ordered chain rather than an unrelated general chat model

### Coding Role

The coding chain is:

- primary: `together/Qwen/Qwen3-Coder-Next-FP8`
- fallback: `together/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8`

As with reasoning, this is expected to be represented through skill-owned runtime policy and the coding tool path rather than through an undocumented OpenClaw core field. The role contract should align with the current Moltbox `coding` and `code` surfaces in `model-runtime.yml` and `tools.yaml`.

## Runtime Configuration Surfaces

### OpenClaw Config

`openclaw.json.template` is the main OpenClaw-facing surface for:

- default-agent chat model fallback order
- model allowlist and aliases under `agents.defaults.models`
- any explicit `models.providers` entries required by the runtime build
- plugin allowance and install metadata if the runtime requires explicit plugin config

Together auth is injected into the runtime container by the gateway-managed scoped secret system and is resolved by OpenClaw from the `TOGETHER_API_KEY` environment variable.

### Runtime Policy Files

`model-runtime.yml` remains the Moltbox-owned policy surface for describing why a role exists and what it is for.

For this skill, that file should make the role intent explicit for:

- local chat recovery from Ollama to Maverick
- reasoning escalation from Kimi K2.5 to Qwen 3.5 397B
- coding escalation from Qwen Coder Next to Qwen Coder 480B

`tools.yaml` should remain aligned with the same role contract so reasoning and coding invocations do not drift away from the documented fallback chains.

## Fallback Behavior

OpenClaw's documented model-failover behavior works in two stages:

1. auth profile rotation inside the current provider
2. model fallback to the next entry in `agents.defaults.model.fallbacks`

For this skill, that means:

- chat should move from `ollama/qwen3:8b` to Maverick when the local primary fails through a fallback-eligible path
- reasoning should move from Kimi K2.5 to Qwen 3.5 397B when the reasoning primary fails through the same class of conditions
- coding should move from Qwen Coder Next to Qwen Coder 480B when the coding primary fails through the same class of conditions

Per current OpenClaw docs, fallback is expected for auth failures, rate limits, and timeouts after provider-profile rotation is exhausted. Generic provider failures that do not map to those failover rules should be treated as runtime defects rather than assumed fallback triggers.

## Lifecycle

### Install

The skill is delivered into a runtime through the gateway-managed runtime deploy or reload flow.

Example direction:

```text
moltbox gateway service deploy dev
```

The gateway stages the `together-escalation` skill folder into the runtime's managed OpenClaw state under `~/.openclaw/skills/together-escalation`.

### Configure

The skill expects baseline config from the runtime repo, including:

- default-agent model policy in `openclaw.json.template`
- Together role policy in `model-runtime.yml`
- reasoning and coding tool alignment in `tools.yaml`
- environment credential material for `TOGETHER_API_KEY`

### Execute

At runtime:

1. a normal chat turn begins on the default local Ollama model
2. OpenClaw keeps provider-level auth/profile failover within the active provider first
3. if the chat model still fails through a documented failover path, OpenClaw advances to the next fallback model
4. reasoning and coding operations resolve their role-specific Together chains
5. runtime logs or model-selection surfaces expose the chosen model path

Validated runtime output shows the same `payloads` + `meta` response envelope for both the local Ollama path and the Together fallback path.

### Persist

The skill persists runtime-local skill state inside the target environment rather than back into Git automatically.

## Deployment Implications

Together Escalation is not a separate service deployment.

Its deployment affects:

- runtime mutable state
- runtime deployment-event history
- checkpoint and replay metadata
- environment-scoped secret management

Because it is staged into live runtime state during deploy or reload, a runtime may differ from the Git baseline until a later checkpoint promotes that state intentionally.

## Constraints And Edge Cases

- if `TOGETHER_API_KEY` is missing, Together-backed fallbacks cannot be used
- if `agents.defaults.models` omits one of the fallback models, the runtime can stop with a model-allowlist error instead of recovering
- if the runtime build does not expose Together as the provider id `together`, the skill is misconfigured
- if the role-specific reasoning and coding policy drifts from the OpenClaw model catalog, operators can see inconsistent selection behavior
- `dev`, `test`, and `prod` do not automatically share Together credentials or staged runtime state
- legacy runtime artifacts must stay removed from templates and staged runtime state to avoid stale startup noise and false-positive operator diagnostics
