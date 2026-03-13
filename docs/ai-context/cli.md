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
- `ollama`
- `opensearch`
- `caddy`

Important rules:

- `gateway` is the appliance control-plane namespace
- `dev`, `test`, and `prod` are the public runtime namespaces
- internal names such as `openclaw-dev` are implementation details
- service lifecycle goes through `moltbox gateway service ...`
- runtime containers can also be deployed through `moltbox gateway service deploy dev|test|prod`
- that service pipeline consumes definitions from `moltbox-services` and is orchestrated by the gateway
- native service operations stay native through passthrough namespaces
- native OpenClaw plugin and skill CLI families should remain reachable through `moltbox <env> openclaw ...`
- native passthrough is not a separate deployment model
- retired namespaces such as `runtime`, `tools`, `host`, top-level `service`, and top-level `skill` should not appear in active examples

Canonical sources:

- [CLI Architecture](../platform/cli-architecture.md)
- [Deployment Models](../platform/deployment-models.md)
- [Gateway](../concepts/gateway.md)
- [Service](../concepts/service.md)
- [CLI](../operations/cli.md)
- [CLI Reference](../reference/cli-reference.md)
