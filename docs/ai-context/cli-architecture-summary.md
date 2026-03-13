# CLI Architecture Summary

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

- `dev`, `test`, and `prod` are the public runtime namespaces
- internal names such as `openclaw-dev` are implementation details
- service lifecycle goes through `moltbox gateway service ...`
- native service operations stay native through passthrough namespaces
- retired namespaces such as `runtime`, `tools`, `host`, top-level `service`, and top-level `skill` should not appear in active examples

Canonical sources:

- [CLI Architecture](../platform/cli-architecture.md)
- [CLI](../operations/cli.md)
- [CLI Reference](../reference/cli-reference.md)
