# Moltbox Telemetry Operator Guide

## Purpose

Use this feature when you want a Moltbox runtime to emit consistent model telemetry that operators, diagnostics tools, and UI surfaces can consume without custom per-runtime interpretation.

## Where It Runs

Moltbox Telemetry is installed per environment:

- `dev`
- `test`
- `prod`

## Prerequisites

Before enabling it, confirm:

- the target runtime is healthy
- OpenClaw diagnostics can be enabled for the target runtime
- operators can access runtime diagnostics logs or equivalent diagnostics output
- operators understand whether the runtime is using the native `/usage` footer already
- the runtime can be restarted or reloaded if plugin activation requires it

## Install

Install the plugin through the environment-scoped OpenClaw passthrough:

```text
moltbox dev openclaw plugins install moltbox-telemetry
```

Then verify:

```text
moltbox dev openclaw plugins list
moltbox dev openclaw plugins info moltbox-telemetry
```

Confirm diagnostics are enabled in the runtime config before treating the feature as active.

Installed plugins are enabled by default in current OpenClaw builds, but runtime config should still be checked if the environment keeps an explicit `plugins.entries` record.

## Verify Telemetry Output

Run a simple chat request through the runtime.

Example:

```text
openclaw chat "hello"
```

Then verify the response telemetry includes:

- `model`
- `provider`
- `input_tokens`
- `output_tokens`
- `total_tokens`
- `context_pct`
- `provider_latency_ms`

Also inspect diagnostics output and confirm the same response produced model usage telemetry with provider, model, token, context, and duration data.

If the session uses OpenClaw's built-in `/usage tokens` or `/usage full` footer, confirm that footer still works normally after the plugin is installed.

## Confirm Latency Visibility

The important latency field is `provider_latency_ms`.

Confirm it is present in:

- response-side telemetry
- diagnostics output

If the UI build already consumes the standardized telemetry contract, also confirm the gray statistics line beneath the response shows latency.

If the UI does not yet show latency, treat that as a downstream UI integration gap rather than a plugin-install failure.

If operators need external collector export, install and validate OpenClaw's separate `diagnostics-otel` plugin. Moltbox Telemetry does not replace that exporter path.

## Promote To Test And Prod

Use `dev` first, then promote deliberately:

1. install and validate in `dev`
2. install and validate in `test`
3. install and validate in `prod`

Promotion means repeating the runtime install and verification steps in each environment. It does not automatically copy live plugin state across environments.

## What To Check

If the feature is not working:

- confirm the plugin is installed
- confirm the plugin is enabled in runtime config if the runtime tracks explicit plugin entries
- confirm `diagnostics.enabled` is `true`
- confirm diagnostics logs are reachable
- confirm the response telemetry contains native model usage data to normalize
- confirm `provider_latency_ms` is present in the normalized output

## Troubleshooting Basics

Common problems:

- diagnostics are disabled, so the plugin has no event stream to standardize
- token fields appear but latency is missing because the underlying duration was not captured
- `context_pct` is missing because the runtime could not resolve the active context window
- logs exist but operator log policy makes diagnostics hard to inspect
- OTLP export was expected but `diagnostics-otel` was never enabled
- the plugin was installed in `dev` but not promoted to `test` or `prod`

## TODO

- document the exact preferred Moltbox-wrapped commands for runtime diagnostics inspection once the gateway exposes a stable diagnostics command family
