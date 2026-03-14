# Caddy Specification

## Purpose

Caddy is the ingress and routing service for the Moltbox appliance.

It is a first-class appliance service and the normal network entry point for the gateway and runtime surfaces.

Canonical ingress model:

```text
Internet -> Caddy -> Gateway / Runtime services
```

## Implementation Surfaces

Primary evidence:

- `moltbox-services/services/caddy/service.yaml`
- `moltbox-services/services/caddy/compose.yml.template`
- `moltbox-runtime/caddy/Caddyfile.template`

## Architecture Components

The service depends on three main layers:

1. service deployment definition in `moltbox-services`
2. runtime-owned ingress configuration in `moltbox-runtime`
3. upstream target services such as `gateway` and the runtime environments

## Configuration Model

Current baseline configuration shows:

- listener on `:80` with `/healthz`
- internal TLS for appliance hostnames
- reverse proxy routes for:
  - `moltbox-dev`
  - `moltbox-test`
  - `moltbox-prod`

Current routing posture:

- runtime hostnames proxy to host-facing runtime ports through `host.docker.internal`
- the public control plane is intentionally closed; `moltbox-cli` returns `404` rather than proxying to the gateway
- Caddy fronts runtime environments, not the gateway control plane

Persistent Caddy state is stored through mounted service data and config roots.

## Lifecycle

Typical lifecycle is service-oriented:

1. render the `Caddyfile` from runtime configuration
2. deploy or restart the `caddy` service through the gateway
3. validate ingress health
4. confirm downstream routes resolve correctly

## Dependencies

Required dependencies:

- `gateway` must be reachable on its internal container port
- environment runtimes must be reachable on the mapped appliance ports
- appliance network and shared storage roots must exist

## Runtime Behavior

Expected behavior:

- respond locally on `/healthz`
- terminate TLS for appliance hostnames
- reverse proxy traffic without owning application logic
- avoid exposing gateway or MCP routes on the public ingress

Caddy is intentionally thin. It should not absorb control-plane or runtime logic that belongs elsewhere.

## Constraints And Edge Cases

- if the `gateway` service is healthy but Caddy routing is wrong, the appliance can appear down to operators even though the control plane is running
- if runtime host-port mappings drift, Caddy routes can silently target the wrong backend
- internal TLS posture is appropriate for appliance-local routing but may need revision if the ingress contract changes later

## TODO

- document the stable ingress hostname contract once the endpoint layer is finalized
- document whether future non-runtime routes should live in the same `Caddyfile` or be split by service class
