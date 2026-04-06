# Endpoints

This file is the concise `remram`-side endpoint summary for the current Moltbox appliance.

For the detailed live topology and operator contract, use `moltbox-gateway`.

## Gateway

Gateway health:

- appliance-local: `http://127.0.0.1:7460/health`

Gateway MCP:

- appliance-local: `http://127.0.0.1:7460/mcp`
- internal container network: `http://gateway:7460/mcp`

Notes:

- MCP is for internal appliance agents and containers
- workstation operators should use SSH plus `moltbox`, not direct MCP HTTP calls

## Public HTTPS Ingress

Current ingress routes:

- `https://moltbox-gateway/`
- `https://moltbox-test/`
- `https://moltbox-prod/`

These are appliance-facing routes behind Caddy.

## OpenClaw Runtime Access

Normal runtime access uses:

- `moltbox test openclaw ...`
- `moltbox prod openclaw ...`

Dashboard token flow:

- generate a tokenized URL with `moltbox test openclaw dashboard --no-open` or `moltbox prod openclaw dashboard --no-open`
- keep the `#token=...` fragment
- replace any loopback origin in the printed URL with the matching ingress host

Direct runtime ports are implementation details, not the preferred operator surface.

## Internal Service Endpoints

Stable internal dependency endpoints used by the appliance include:

- Gateway MCP: `http://gateway:7460/mcp`
- Ollama: `http://ollama:11434`

Detailed service-local ports, mounts, and container wiring belong to the service authority repo, not this file.

## Current Notes

- `searxng` is an internal appliance service that backs `web_search`
- built-in `web_fetch` does not require a separate appliance endpoint
- native OpenClaw `browser` runs inside the runtime containers rather than through a separate external browser service
- OpenSearch is not part of the current target appliance

## Operator Rule

Prefer the CLI over direct endpoint probing for normal operations:

- `moltbox gateway status`
- `moltbox service status <service>`
- `moltbox test|prod openclaw ...`
- `moltbox test|prod verify ...`
