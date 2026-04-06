# Together Escalation Master Test Plan

## Test Objectives

- validate the feature-level local-first and cloud-fallback promise
- confirm the feature satisfies user and operator goals rather than only packaging mechanics
- confirm the feature rolls up the lower-level runtime and dependency checks it needs

## User Or Operator Goals

- as a user, I can send a normal runtime request without manually choosing between local and Together models
- as an operator, I can keep local inference as the normal path when Ollama is healthy
- as an operator, I can verify the runtime recovers automatically to Together when the local provider fails
- as an operator, I can validate the feature in `test` before treating it as promotable toward `prod`

## Scope

- In scope: feature-level acceptance of chat fallback and operator deployment flow
- In scope: secret handling and operator-visible validation of model selection
- Out of scope: lower-level packaging details already covered elsewhere

## Referenced Lower-Level Plans

- the current Gateway validation flow in `moltbox-gateway`
- the current service baseline and runtime artifact authorities

## Preconditions

- target runtime environment is available
- `TOGETHER_API_KEY` is present in the target scope
- the local Ollama service is healthy before fallback testing begins
- the target runtime can be deployed through the documented service plane

## Test Cases

1. Scenario: user sends a normal runtime request while Ollama is healthy.
   Expected result: the runtime answers successfully through the documented local primary model path.
2. Scenario: operator induces a fallback-eligible local-model failure and reruns the same class of request.
   Expected result: the runtime recovers automatically to the documented Together fallback path without changing the user request pattern.
3. Scenario: operator validates the deployed model chain and provider status through the runtime.
   Expected result: the effective provider/model path is visible and matches the documented baseline.
4. Scenario: operator deploys the target runtime after setting Together credentials through the documented secret path.
   Expected result: the feature becomes active without leaking secrets and remains observable through runtime model or log surfaces.

## Exit Criteria

- the user and operator goals above are satisfied
- fallback behavior is observable and repeatable without manual provider switching
- the behavior is proven in `test` before promotion is considered

## Results Summary

- [Result]
