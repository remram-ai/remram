# Caddy Test Plan

## Definition Of Done

Caddy is done when:

- the service deploys successfully
- `/healthz` responds
- gateway ingress works through the expected hostname
- each environment route reaches the correct runtime
- TLS termination works as expected for the appliance posture

## Core Validation

### 1. Service Validation

Verify:

- `moltbox gateway service status caddy`
- `moltbox gateway service deploy caddy`
- `moltbox gateway service restart caddy`

Expected result:

- the service is healthy after deploy or restart

### 2. Health Endpoint Validation

Verify the Caddy health surface returns success:

- `http://<appliance>/healthz`

Expected result:

- HTTP `200`

### 3. Gateway Route Validation

Verify the appliance hostname for the control plane reaches the gateway target.

Expected result:

- the control-plane route resolves and the gateway remains reachable through ingress

### 4. Runtime Route Validation

Verify each runtime hostname reaches the intended environment:

- `moltbox-dev`
- `moltbox-test`
- `moltbox-prod`

Expected result:

- each route reaches the correct runtime backend

## Failure Cases To Test

- Caddy is healthy but the `gateway` route fails
- one runtime hostname resolves to the wrong backend
- health endpoint works but TLS routing fails
- storage mounts for Caddy state are missing or unwritable

## Operator-Visible Success Criteria

- operators can use the documented appliance hostnames
- ingress failures are distinguishable from gateway or runtime failures
- the entrypoint remains predictable after service restart or redeploy

## Runtime And Deployment Checks

- confirm rendered `Caddyfile` matches the expected appliance topology
- confirm the `caddy` container has the expected ports and mounts
- confirm downstream targets are reachable from the service
