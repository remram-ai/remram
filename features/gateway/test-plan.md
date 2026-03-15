# Gateway Master Test Plan

## Test Objectives

- validate the top-level control-plane promises of the gateway feature
- confirm operators can manage the appliance through documented CLI and automation paths
- confirm feature-level acceptance stays aligned with the lower-level gateway and service plans

## User Or Operator Goals

- as an operator, I can inspect and manage the appliance through `moltbox`
- as an operator, I can deploy, restart, and inspect services without falling back to undocumented Docker usage
- as an operator, I can perform environment lifecycle actions without cross-environment leakage
- as an automation client, I can reach gateway MCP only through authenticated access

## Scope

- In scope: end-to-end control-plane behaviors from the operator or automation point of view
- In scope: service lifecycle, environment lifecycle, metadata, and automation access
- Out of scope: low-level component-only checks already covered by platform item plans

## Referenced Lower-Level Plans

- [Gateway Platform Test Plan](../../platform/core/gateway/test-plan.md)
- [Caddy Platform Test Plan](../../platform/services/caddy/test-plan.md)
- [Ollama Platform Test Plan](../../platform/services/ollama/test-plan.md)
- [OpenSearch Platform Test Plan](../../platform/services/opensearch/test-plan.md)

## Preconditions

- appliance is reachable over SSH
- the gateway control plane is running
- at least one stable managed service is available for service-pipeline validation
- a target runtime environment such as `dev` is available for environment lifecycle validation

## Test Cases

1. Scenario: operator inspects gateway health and logs through the documented CLI.
   Expected result: `moltbox gateway status` and `moltbox gateway logs` expose meaningful control-plane state.
2. Scenario: operator deploys or restarts a managed service through `moltbox gateway service ...`.
   Expected result: the service action completes through the documented pipeline, health is validated, and deployment metadata is recorded.
3. Scenario: operator performs an environment lifecycle action such as `moltbox dev reload`.
   Expected result: the target runtime remains healthy and no unrelated environment is mutated.
4. Scenario: an internal automation client reaches MCP with and without valid authentication.
   Expected result: authenticated access succeeds and unauthenticated access fails cleanly.
5. Scenario: operator performs `moltbox gateway update`.
   Expected result: the gateway and host CLI refresh safely and provenance history is appended.

## Exit Criteria

- the operator goals above succeed without undocumented Docker-first recovery steps
- deployment metadata reconciles after service and runtime actions
- referenced lower-level gateway and service validations pass for the exercised surfaces

## Results Summary

- [Result]
