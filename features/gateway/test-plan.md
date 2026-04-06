# Gateway Master Test Plan

## Test Objectives

- validate the top-level control-plane promises of the gateway feature
- confirm operators can manage the appliance through documented CLI and automation paths
- confirm feature-level acceptance stays aligned with the lower-level Gateway and service plans

## User Or Operator Goals

- as an operator, I can inspect and manage the appliance through `moltbox`
- as an operator, I can deploy, restart, and inspect services without falling back to undocumented Docker usage
- as an operator, I can mutate and verify `test` through the documented runtime and verification surfaces
- as an operator, I can inspect `prod` safely without normal mutation rights
- as an automation client, I can reach Gateway MCP only through authenticated access

## Scope

- In scope: end-to-end control-plane behaviors from the operator or automation point of view
- In scope: service lifecycle, runtime access model, verification surfaces, metadata, and automation access
- Out of scope: low-level component-only checks already covered by platform item plans or owning repos

## Referenced Lower-Level Plans

- the current Gateway validation plans in `moltbox-gateway`
- the current service authority docs in `moltbox-services`
- the current runtime promotion path in `moltbox-runtime`

## Preconditions

- appliance is reachable over SSH
- the gateway control plane is running
- the managed services `gateway`, `caddy`, `ollama`, `searxng`, `test`, and `prod` are present
- the current deployable revisions are tracked in Git-backed repos

## Test Cases

1. Scenario: operator inspects gateway health and logs through the documented CLI.
   Expected result: `moltbox gateway status` and `moltbox gateway logs` expose meaningful control-plane state.
2. Scenario: operator deploys or restarts a managed service through `moltbox service ...`.
   Expected result: the service action completes through the documented pipeline, health is validated, and deployment/snapshot metadata is recorded.
3. Scenario: operator performs native runtime checks on `test`.
   Expected result: `moltbox test openclaw ...` works through the documented passthrough path without relying on replay/checkpoint-era lifecycle.
4. Scenario: operator performs restricted verification through `moltbox test verify ...` and `moltbox prod verify runtime`.
   Expected result: routine validation succeeds without break-glass SSH.
5. Scenario: an internal automation client reaches MCP with and without valid authentication.
   Expected result: authenticated access succeeds and unauthenticated access fails cleanly.
6. Scenario: operator performs `moltbox gateway update`.
   Expected result: the gateway and host CLI refresh safely and provenance history is appended.

## Exit Criteria

- the operator goals above succeed without undocumented Docker-first recovery steps
- deployment and snapshot metadata reconcile after service and runtime actions
- `test` remains the proving lane and `prod` remains a protected managed pet

## Results Summary

- [Result]
