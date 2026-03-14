# CLI

The Moltbox CLI is resource-oriented.

Canonical grammar:

```text
moltbox <resource> <command>
```

Top-level resources:

- `gateway`
- `dev`
- `test`
- `prod`
- `service` for scoped secrets only
- `ollama`
- `opensearch`
- `caddy`

Important rules:

- `gateway` is the appliance control-plane namespace
- `dev`, `test`, and `prod` are the public runtime namespaces
- `service` is reserved for shared-service secrets, for example `moltbox service secrets set POSTGRES_PASSWORD`
- internal names such as `openclaw-dev` are implementation details
- service lifecycle goes through `moltbox gateway service ...`
- lower-level gateway diagnostics and bootstrap helpers currently include `mcp-stdio`, `docker ping`, and `docker run <image>`
- gateway-managed MCP bearer tokens go through `moltbox gateway token <create|list|delete|rotate>`
- runtime containers can also be deployed through `moltbox gateway service deploy dev|test|prod`
- that service pipeline consumes definitions from `moltbox-services` and is orchestrated by the gateway
- managed skill lifecycle is currently `moltbox <env> skill deploy|rollback <skill>`
- scoped secrets follow `moltbox <scope> secrets <command>` where valid scopes are `dev`, `test`, `prod`, and `service`
- secrets are owned by the gateway control plane even when the CLI scope is a runtime or shared-service scope
- secrets are stored locally on the appliance under `/var/lib/moltbox/secrets/<scope>/`
- secrets are encrypted at rest and injected into runtime or service environments during deploy or reload
- native service operations stay native through passthrough namespaces
- native OpenClaw plugin and skill CLI families should remain reachable through `moltbox <env> openclaw ...`
- native passthrough is not a separate deployment model
- there is no public secrets ingress; `moltbox <scope> secrets ...` still routes through the gateway control plane before the encrypted store is touched
- workstation operators and automation use SSH plus the Moltbox CLI directly
- MCP is for internal agents and containers over HTTP with bearer token auth
- retired namespaces such as `runtime`, `tools`, `host`, and top-level `skill` should not appear in active examples

Canonical sources:

- [CLI Architecture](../overview/cli-architecture.md)
- [Deployment Models](../overview/deployment-models.md)
- [Gateway](../concepts/gateway.md)
- [Service](../concepts/service.md)
- [CLI](../operations/cli.md)
- [CLI Reference](../reference/cli-reference.md)
