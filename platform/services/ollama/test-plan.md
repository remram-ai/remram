# Ollama Test Plan

## Definition Of Done

Ollama is done when:

- the service deploys or reports healthy through Moltbox
- the expected local models are present
- runtimes can reach `http://ollama:11434`
- local-first routing can use the service successfully

## Core Validation

### 1. Service Lifecycle Validation

Verify:

- `moltbox gateway service deploy ollama`
- `moltbox gateway service status ollama`

Expected result:

- the service is healthy after deploy

### 2. Native CLI Validation

Verify the passthrough works:

```text
moltbox ollama list
```

Expected result:

- the local model inventory is visible through the native CLI surface

### 3. Runtime Connectivity Validation

Verify the runtime can reach the Ollama provider endpoint.

Expected result:

- runtime provider checks against `http://ollama:11434` succeed

### 4. Model Inventory Validation

Verify the expected local model is present.

At minimum, check the currently documented local model posture against the runtime config.

## Failure Cases To Test

- service is unavailable even though runtime config points to `ollama`
- expected local model is missing
- native `ollama` CLI works locally but runtime cannot reach the service
- runtime config and local model names drift apart

## Operator-Visible Success Criteria

- operators can see the local model inventory
- runtimes can use the local provider consistently
- local-first routing remains available before remote escalation

## Runtime And Deployment Checks

- confirm runtime provider config still points at `http://ollama:11434`
- confirm the active local model exists in Ollama
- confirm the service remains internal to the appliance posture
