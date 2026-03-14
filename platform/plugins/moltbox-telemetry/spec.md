# Moltbox Telemetry Specification

## Purpose

Moltbox Telemetry is the runtime telemetry plugin that enables and standardizes the model-level diagnostics fields Moltbox expects from OpenClaw runtimes.

It is a feature because it defines the observable telemetry contract for live runtime execution, not just an implementation detail of one plugin package.

## Scope

Moltbox Telemetry owns:

- ensuring OpenClaw diagnostics are enabled for the target runtime
- shaping a stable telemetry field set for model responses
- shaping the same field set for diagnostics output
- keeping telemetry observable across `dev`, `test`, and `prod`

Moltbox Telemetry does not own:

- routing policy
- escalation logic
- fallback order
- model selection
- provider credential policy beyond what is already required for the selected model

## Implementation Surfaces

Primary evidence and owning inputs:

- `remram-skills/skills/moltbox-telemetry/`
- `moltbox-runtime/openclaw-*/openclaw.json.template`
- OpenClaw plugin config under `plugins.entries.moltbox-telemetry`
- OpenClaw diagnostics config under `diagnostics`

## Architecture Components

Moltbox Telemetry depends on four layers working together:

1. a plugin package in `remram-skills`
2. OpenClaw diagnostics enabled in runtime config
3. runtime-local plugin install state
4. operator-visible telemetry consumers such as chat metadata, diagnostics logs, and UI usage surfaces

## OpenClaw Diagnostics Integration

Current OpenClaw documentation establishes the following relevant behavior:

- diagnostics events are available when `diagnostics.enabled` is `true`
- `model.usage` is the core diagnostic event for model tokens, cost, duration, context, provider/model identity, and session metadata
- `/status` and `/usage off|tokens|full` already expose built-in usage and context surfaces for operators
- OpenClaw can export diagnostics through the official `diagnostics-otel` plugin
- plugin config lives under `plugins.entries.<id>`
- plugin config changes require a gateway restart

That means this feature should behave as a thin telemetry-normalization layer on top of OpenClaw diagnostics rather than as a second telemetry system or a replacement for the built-in usage footer.

## Telemetry Fields

The plugin standardizes the following fields.

### `model`

The model ref that generated the response.

Expected source:

- `model.usage.model`

Examples:

- `ollama/qwen3:8b`
- `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`

### `provider`

The provider id used for the response.

Expected source:

- `model.usage.provider`

Examples:

- `ollama`
- `together`

### `input_tokens`

Token count for prompt input.

Expected source:

- `model.usage.usage.input`
- or `model.usage.lastCallUsage.input` when the runtime exposes last-call data separately

### `output_tokens`

Token count for model output.

Expected source:

- `model.usage.usage.output`
- or `model.usage.lastCallUsage.output`

### `total_tokens`

Total token usage for the response.

Expected source:

- `model.usage.usage.total`
- or `model.usage.lastCallUsage.total`

### `context_pct`

Percentage of the active context window used by the run.

This is a Moltbox-standardized field and may need to be derived rather than copied directly. Expected derivation:

```text
context_pct = (context_used / effective_context_window) * 100
```

Expected source inputs:

- `model.usage.context.used`
- the effective runtime context-window limit for the selected model or agent default

If the runtime cannot resolve an effective context window for the selected model, `context_pct` should be treated as unavailable rather than fabricated.

### `provider_latency_ms`

Latency for the provider call that generated the response.

Expected source:

- `model.usage.durationMs`

This field is required because Moltbox wants a direct latency field name rather than relying on every downstream consumer to reinterpret a generic duration key.

## Standardized Output Contract

The plugin should expose the field set consistently in two places:

1. response-side telemetry attached to model replies
2. diagnostics output such as logs or event sinks

The standardized field names are:

```text
model
provider
input_tokens
output_tokens
total_tokens
context_pct
provider_latency_ms
```

Illustrative response-side telemetry shape:

```json
{
  "telemetry": {
    "model": "ollama/qwen3:8b",
    "provider": "ollama",
    "input_tokens": 1432,
    "output_tokens": 188,
    "total_tokens": 1620,
    "context_pct": 4.9,
    "provider_latency_ms": 842
  }
}
```

Illustrative diagnostics event payload shape:

```json
{
  "type": "model.usage",
  "provider": "ollama",
  "model": "ollama/qwen3:8b",
  "usage": {
    "input": 1432,
    "output": 188,
    "total": 1620
  },
  "context": {
    "used": 1620
  },
  "durationMs": 842
}
```

The plugin's role is not to replace the native event. Its role is to make the Moltbox-facing field contract stable and easy to consume.

The plugin also does not replace OpenClaw's official OTLP export path. If operators need collector export, that remains the responsibility of `diagnostics-otel`.

## Runtime Configuration Surfaces

### OpenClaw Diagnostics

The primary runtime requirement is:

```json
{
  "diagnostics": {
    "enabled": true
  }
}
```

This should remain enabled wherever the plugin is installed. If diagnostics are disabled, the plugin cannot produce the expected standardized telemetry contract.

Optional targeted diagnostics flags may also be enabled when operators need deeper troubleshooting, but they are not required for the normal telemetry contract.

### Plugin Configuration

The plugin is expected to load through the normal OpenClaw plugin config surface:

```json
{
  "plugins": {
    "enabled": true,
    "entries": {
      "moltbox-telemetry": {
        "enabled": true
      }
    }
  }
}
```

If the final package introduces a plugin-defined config object, it belongs under:

```text
plugins.entries.moltbox-telemetry.config
```

No telemetry feature requirement currently depends on prompt injection, routing hooks, or provider overrides.

### Usage Surface Expectations

Current OpenClaw docs already expose usage-oriented surfaces such as:

- `/status`
- `/usage off|tokens|full`
- diagnostics logs and events
- OTLP export through `diagnostics-otel`

Moltbox Telemetry should align with those surfaces instead of replacing them.

The gray statistics line beneath chat responses is a UI consumer concern. OpenClaw already supports usage footers through `/usage`. This feature only requires that latency and the rest of the standardized fields are present in the telemetry contract so the UI or usage footer layer can render them once that surface consumes the field.

## Runtime Observability Defaults

Moltbox runtimes using this feature should operate with the following observability posture:

- `thinking: auto`
- `usage: full`

Equivalent runtime commands:

```text
/thinking auto
/usage full
```

These defaults exist so the telemetry contract is fully observable to operators.

- `thinking: auto` allows reasoning-capable models to use internal reasoning when appropriate
- `usage: full` ensures the runtime emits the complete usage footer and metadata

Moltbox Telemetry does not control model reasoning behavior. These settings are documented here because they ensure the standardized telemetry fields are visible in normal runtime operation.

When validating telemetry output, Moltbox Telemetry assumes this runtime posture is active.

## Lifecycle

### Install

The feature is installed into a runtime through the native OpenClaw plugin lifecycle.

Example direction:

```text
moltbox dev openclaw plugins install moltbox-telemetry
```

Because OpenClaw plugin changes are restart-required, the runtime may need a restart or reload path before the plugin becomes fully active. In the default OpenClaw `hybrid` reload mode, restart-required config changes are handled automatically by the gateway. In other reload modes, operators may need an explicit restart.

### Configure

The feature expects:

- diagnostics enabled in `openclaw.json.template`
- plugin enablement through `plugins.entries.moltbox-telemetry`
- runtime log access for diagnostics inspection

### Execute

At runtime:

1. OpenClaw emits model diagnostics events for a response
2. the plugin reads or observes the native telemetry data
3. the plugin normalizes the Moltbox field set
4. the runtime exposes that field set through response-side telemetry and diagnostics output

### Persist

The feature persists runtime-local plugin install state inside the target environment rather than back into Git automatically.

## Runtime Behavior Assumptions

This feature assumes:

- normal model calls already emit `model.usage` events when diagnostics are enabled
- the runtime can observe provider/model identity, usage counts, context-used data, and duration
- the plugin can standardize those values without changing model execution flow
- OpenClaw's native `/status` and `/usage` surfaces remain available to operators

This feature does not assume:

- custom routing stages
- special provider-specific telemetry exporters
- a separate telemetry service container

## Deployment Implications

Moltbox Telemetry is not a separate service deployment.

Its deployment affects:

- runtime mutable state
- runtime deployment-event history
- runtime snapshots before mutation
- diagnostics visibility for operators

Because it installs through native OpenClaw behavior, a live runtime may differ from the Git baseline after install until a later checkpoint promotes that state intentionally.

## Constraints And Edge Cases

- if `diagnostics.enabled` is `false`, the plugin cannot satisfy the required field contract
- if a model provider does not report usage or duration, some standardized fields may be unavailable and should be surfaced as missing rather than guessed
- if the runtime cannot resolve the effective context window, `context_pct` cannot be computed reliably
- if logs are over-redacted or suppressed through logging policy, diagnostics visibility can degrade even when telemetry exists internally
- if OTLP export is required, operators still need the separate `diagnostics-otel` plugin
- this feature must not modify routing or model fallback behavior while standardizing telemetry

## TODO

- document the exact `remram-skills/skills/moltbox-telemetry/` package layout once the plugin lands
- document any final plugin-specific config schema once the package manifest exists
