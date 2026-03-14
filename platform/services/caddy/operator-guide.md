# Caddy Operator Guide

## Purpose

Use Caddy when you need to manage or diagnose the appliance ingress layer.

## Normal Operator Actions

Manage the service through the gateway:

```text
moltbox gateway service status caddy
moltbox gateway service deploy caddy
moltbox gateway service restart caddy
```

If service-specific diagnostics are needed, use the passthrough namespace:

```text
moltbox caddy <native command>
```

## What It Connects

Caddy sits in front of:

- `gateway`
- `dev`
- `test`
- `prod`

It is the appliance entry point, not the place where the application logic runs.

Ingress path:

```text
Internet -> Caddy -> Gateway / Runtime services
```

## What To Check

If ingress is not working:

- confirm `caddy` is healthy
- confirm the rendered `Caddyfile` contains the expected routes
- confirm the gateway and runtime targets are healthy behind Caddy
- confirm hostname resolution matches the expected appliance names

## Troubleshooting Basics

Common failure cases:

- Caddy is up but one route points at the wrong backend
- TLS is working but downstream service is not healthy
- the service restarts but the rendered config is stale
- mounted Caddy data or config state is missing

## Operational Touchpoints

- gateway service pipeline
- rendered `Caddyfile`
- Caddy health endpoint
- downstream gateway and runtime health

## TODO

- document the final operator procedure for certificate inspection if appliance TLS moves beyond the current internal-certificate posture
