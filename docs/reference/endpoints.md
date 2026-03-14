# Endpoints

This document records the main endpoint and health-surface references used by the appliance.

These are reference values for the current appliance model.

## Gateway

Gateway health:

- appliance-local: `http://127.0.0.1:7460/health`

Gateway is the control-plane endpoint surfaced through the CLI and internal tooling.

Public HTTPS ingress does not expose the control plane. `https://moltbox-cli/*` returns `404` by design.

Gateway MCP:

- appliance-local: `http://127.0.0.1:7460/mcp`
- internal container network: `http://gateway:7460/mcp`
- auth: `Authorization: Bearer <token>`

MCP is for internal appliance agents and containers, not the workstation operator path.

## OpenClaw Runtime Endpoints

Each OpenClaw runtime exposes:

- health: `http://127.0.0.1:18789/healthz`
- readiness: `http://127.0.0.1:18789/readyz`

Validated default host mappings:

- `openclaw-dev` -> host `18790`
- `openclaw-test` -> host `28789`
- `openclaw-prod` -> host `38789`

Validated ingress routes:

- `https://moltbox-dev`
- `https://moltbox-test`
- `https://moltbox-prod`

TODO:

- confirm which ingress hostnames and host-port mappings are part of the stable documented contract versus validated appliance defaults

## Caddy

Caddy health:

- `http://127.0.0.1/healthz`

Caddy is the steady-state ingress service.

## OpenSearch

OpenSearch runs as an internal appliance service.

Reference port:

- internal `9200/tcp`

Health is typically checked by service-level connectivity rather than a public ingress route.

## Ollama

Ollama is a first-class appliance service but is typically treated as an internal shared dependency rather than a public ingress endpoint.

Runtime configuration commonly refers to:

- `http://ollama:11434`

TODO:

- confirm whether Ollama remains internal-only for the documented model or later gains a public ingress or health surface

## Notes

- endpoint ownership belongs to the appliance topology and service model
- operator workflow should prefer the CLI over direct endpoint probing for normal operations
- workstation automation should use SSH plus the Moltbox CLI rather than public HTTPS control-plane endpoints
- platform docs own the deeper topology contract; this page is the quick technical reference
