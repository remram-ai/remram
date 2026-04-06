# Moltbox Telemetry Test Plan

Status note:

- this document predates the current managed-pet Gateway/OpenClaw correction
- it is retained as reconstruction material, not as the current active validation contract
- use `README.md`, the feature record, and the owning Moltbox repos first

Status: in flight

## Definition Of Done

Moltbox Telemetry is done for an environment when:

- the plugin installs successfully into the target runtime
- OpenClaw diagnostics telemetry is enabled
- chat responses include the standardized telemetry fields
- diagnostics output shows the same telemetry information
- `provider_latency_ms` is present for normal model responses
- the runtime remains behaviorally unchanged apart from telemetry visibility

This test plan is the acceptance target for the next-release line on `main`. It is not the current tagged-appliance validation matrix.

## Core Validation

### 1. Install Validation

Verify:

- `moltbox <env> plugin install moltbox-telemetry` succeeds
- `moltbox <env> plugin list` shows `moltbox-telemetry`
- `moltbox <env> openclaw plugins info moltbox-telemetry` resolves correctly

### 2. Diagnostics Enablement Validation

Verify the target runtime has diagnostics enabled.

Expected config posture:

- `diagnostics.enabled` is `true`

If the runtime exposes diagnostics state through a command surface, verify that state directly before continuing.

### 3. Runtime Usage Posture Validation

Confirm the target runtime is using the expected observability posture:

- `thinking: auto`
- `usage: full`

Equivalent runtime commands:

```text
/thinking auto
/usage full
```

After confirming that posture, continue to chat validation.

### 4. Chat Response Validation

Use the OpenClaw CLI chat path against the target runtime.

Example validation approach:

```text
openclaw chat "hello"
```

Verify the response metadata includes:

- `model`
- `provider`
- `input_tokens`
- `output_tokens`
- `total_tokens`
- `context_pct`
- `provider_latency_ms`

### 5. Diagnostics Output Validation

Verify telemetry also appears in diagnostics output.

Expected evidence:

- a `model.usage` event or equivalent diagnostics record exists
- provider/model identity is present
- token usage is present
- duration is present
- native `/status` or `/usage` surfaces remain consistent with the same underlying usage data

### 6. Latency Validation

Verify `provider_latency_ms` is populated for a normal chat response.

Expected result:

- latency is visible in response-side telemetry
- latency is visible in diagnostics output

### 7. UI Surface Validation

If the target UI build consumes the standardized telemetry contract, verify the gray statistics line beneath the response includes latency.

If the target UI build does not yet consume `provider_latency_ms`, treat that as a downstream UI gap rather than a plugin failure, as long as the field is present in the runtime telemetry contract.

If OpenClaw's native `/usage tokens` or `/usage full` footer is in use, confirm the plugin does not break that built-in footer behavior.

### 8. Environment Promotion Validation

Validate the plugin independently in:

- `dev`
- `test`
- `prod`

Each environment should have:

- the plugin installed
- diagnostics enabled
- the same standardized field contract

## Failure Cases To Test

- plugin install fails because the package path is wrong or the plugin is not trusted
- diagnostics are disabled, so no standardized telemetry is emitted
- a response contains tokens and model/provider identity but no latency
- `context_pct` is emitted with an obviously invalid value because the runtime could not resolve context-window size
- diagnostics logs are unavailable because logging configuration suppresses or redirects the expected output
- the plugin conflicts with OpenClaw's native usage footer or diagnostics exporter behavior
- the plugin changes visible runtime behavior instead of remaining telemetry-only

## Operator-Visible Success Criteria

- operators can confirm install state with native OpenClaw plugin commands through Moltbox
- operators can see telemetry in both chat responses and diagnostics output
- token, model, provider, context, and latency data are exposed under one stable field contract
- failures point to a specific diagnostics, logging, or runtime-config problem

## Deployment And Runtime Checks

- verify checkpoint metadata and replay state reconcile after the mutation
- verify the runtime remains healthy after plugin install
- verify deployment events are captured if runtime deployment-event recording is enabled
- verify diagnostics logs remain accessible after install
