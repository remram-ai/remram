# Semantic Router Test Plan

## Definition Of Done

Semantic Router is done for an environment when:

- the plugin installs successfully into the target runtime
- the runtime recognizes the plugin and the skill as eligible
- local-first routing works for simple requests
- escalation works for harder requests when remote providers are configured
- runtime telemetry and debug signals are produced

## Core Validation

### 1. Install Validation

Verify:

- `moltbox <env> openclaw plugins install semantic-router` succeeds
- `moltbox <env> openclaw plugins list` shows `semantic-router`
- `moltbox <env> openclaw plugins info semantic-router` resolves correctly

### 2. Config Validation

Verify the target runtime contains:

- router ladder config
- plugin allowance for `semantic-router`
- a provider entry for the plugin route
- local model provider configuration

### 3. Local Routing Validation

Use a simple prompt that should stay local.

Expected result:

- request completes without unnecessary escalation
- telemetry identifies the local stage

### 4. Escalation Validation

Use a prompt that requires deeper reasoning.

Expected result:

- router escalates to the next configured stage
- telemetry captures the ordered stage path
- final response still completes successfully

## Failure Cases To Test

- plugin install fails because the package path is wrong
- plugin installs but is not trusted or not allowlisted
- local `ollama` provider is unavailable
- remote reasoning provider keys are missing
- router config is malformed
- provider base URL points at the wrong runtime or gateway port

## Operator-Visible Success Criteria

- operators can confirm install state with native OpenClaw plugin commands through Moltbox
- routed requests show stable local-first behavior
- escalated requests are observable rather than silent
- failures point to a specific configuration or provider problem

## Deployment And Runtime Checks

- verify a pre-deploy snapshot exists before runtime mutation
- verify the runtime remains healthy after plugin install
- verify the deployment event is captured if deployment-event recording is enabled for the path
