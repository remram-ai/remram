# Moltbox Gateway Test Plan

## Definition Of Done

Gateway is done when the appliance can be operated through the documented control path without falling back to undocumented Docker-first behavior.

That means:

- the CLI surface is coherent
- deployment metadata is trustworthy
- service lifecycle commands work
- environment lifecycle commands work
- native OpenClaw passthrough remains reachable through the environment namespaces

## Core Validation

### 1. CLI Contract Validation

Verify the documented namespaces exist:

- `gateway`
- `dev`
- `test`
- `prod`
- `ollama`
- `opensearch`
- `caddy`

Verify retired namespaces fail rather than silently redirect.

### 2. Gateway Status And Logs

Verify:

- `moltbox gateway status` returns a meaningful control-plane view
- `moltbox gateway logs` returns the expected diagnostics surface

### 3. Service Pipeline Validation

Verify the gateway service pipeline can:

- report service status
- deploy a service
- restart a service

At minimum, validate against a stable shared service such as `opensearch`.

### 4. Self-Update Validation

Verify `moltbox gateway update`:

- refreshes the gateway source or build input
- rebuilds and replaces the host `moltbox` CLI binary without a manual operator `go build`
- resolves a target artifact
- updates the running gateway safely
- writes authoritative deployment metadata

After update, verify newly added CLI surfaces are available from the appliance host binary.

### 5. Environment Lifecycle Validation

Verify:

- `moltbox dev reload` works
- the target runtime remains healthy
- environment-scoped operations do not leak across environments

### 6. Native OpenClaw Passthrough Validation

Verify an environment-scoped native command works through Moltbox.

Example class:

- plugin install or plugin inspection

### 7. Metadata Reconciliation

For a deployment action, verify the following reconcile:

- running artifact identity
- rendered artifact identity
- deployment record fields

## Failure Cases To Test

- deployment metadata does not match the running artifact
- a service deploy fails health validation
- environment reload succeeds mechanically but leaves the runtime unhealthy
- passthrough commands work in one environment and not another
- legacy namespaces are still accepted

## Operator-Visible Success Criteria

- operators can manage the appliance through `moltbox` alone
- service deploys and runtime lifecycle actions are distinguishable and predictable
- gateway update does not create provenance ambiguity
- failures point to a specific service, runtime, or metadata problem

## Deployment And Runtime Checks

- inspect deployment records after service changes
- confirm snapshots exist before runtime-mutating operations
- confirm runtime deployment events are tracked where expected
- confirm logs and status surfaces expose enough information for diagnosis
