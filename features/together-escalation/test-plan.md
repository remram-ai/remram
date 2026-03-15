# Together Escalation Master Test Plan

## Test Objectives

- validate the feature-level local-first and cloud-fallback promise
- confirm the feature satisfies user and operator goals rather than only the skill-level mechanics
- confirm the feature rolls up the lower-level runtime and dependency checks it needs

## User Or Operator Goals

- as a user, I can send a normal runtime request without manually choosing between local and Together models
- as an operator, I can keep local inference as the normal path when Ollama is healthy
- as an operator, I can verify the runtime recovers automatically to Together when the local provider fails
- as an operator, I can validate reasoning and coding use the documented stronger model chains

## Scope

- In scope: feature-level acceptance of chat fallback, reasoning, coding, and operator deployment flow
- In scope: secret handling and operator-visible validation of model selection
- Out of scope: lower-level skill packaging and component-only checks already covered by platform item plans

## Referenced Lower-Level Plans

- [Together Escalation Platform Test Plan](../../platform/skills/together-escalation/test-plan.md)
- [Gateway Platform Test Plan](../../platform/core/gateway/test-plan.md)
- [Ollama Platform Test Plan](../../platform/services/ollama/test-plan.md)

## Preconditions

- target runtime environment is available
- `TOGETHER_API_KEY` is present in the target environment
- the local Ollama service is healthy before fallback testing begins
- the Together Escalation skill is staged in the target runtime

## Test Cases

1. Scenario: user sends a normal runtime request while Ollama is healthy.
   Expected result: the runtime answers successfully through the documented local primary model.
2. Scenario: operator induces a fallback-eligible local-model failure and reruns the same class of request.
   Expected result: the runtime recovers automatically to the documented Together fallback model without changing the request path.
3. Scenario: operator exercises a reasoning-oriented task and a coding-oriented task.
   Expected result: the reasoning and coding paths use the documented Together model chains and expose the effective model path for validation.
4. Scenario: operator deploys or reloads the runtime after setting Together credentials through the gateway.
   Expected result: the feature becomes active without leaking secrets and remains observable through runtime model or log surfaces.

## Exit Criteria

- the user and operator goals above are satisfied
- referenced lower-level skill and dependency validations pass for the environment under test
- fallback behavior is observable and repeatable without manual provider switching

## Results Summary

- [Result]
