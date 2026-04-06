# CLI Reference

This file is the concise `remram`-side summary of the current Moltbox CLI.

The authoritative CLI contract lives in `moltbox-gateway`:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)

## Canonical Grammar

```text
moltbox <resource> <command>
```

## Public Command Tree

```text
moltbox
  bootstrap gateway
  gateway status|logs|update|mcp-stdio
  service list|status|deploy|restart|remove|logs <service>
  test openclaw <native args>
  test verify runtime|browser|web
  prod openclaw <native args>
  prod verify runtime
  ollama <native args>
  secret set|list|delete <scope>
```

## Managed Service Names

Stable public service names:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `test`
- `prod`

Internal names such as `openclaw-test` and `openclaw-prod` are implementation details, not public CLI namespaces.

## Command Family Notes

`gateway`

- control-plane status, logs, self-update, and MCP stdio bridge

`service`

- appliance service lifecycle and logs
- examples:
  - `moltbox service list`
  - `moltbox service status test`
  - `moltbox service deploy searxng`
  - `moltbox service restart caddy`

`test openclaw` / `prod openclaw`

- native OpenClaw passthrough under the restricted appliance model
- examples:
  - `moltbox test openclaw health --json`
  - `moltbox prod openclaw models status --json`
  - `moltbox test openclaw backup create --verify`

`test verify` / `prod verify`

- operator-grade smoke checks for restricted SSH roles
- examples:
  - `moltbox test verify runtime`
  - `moltbox test verify browser`
  - `moltbox test verify web`
  - `moltbox prod verify runtime`

`ollama`

- native Ollama passthrough

`secret`

- encrypted secret-store operations by scope
- current documented scopes:
  - `test`
  - `prod`
  - `service`

## Current Operating Rules

- use `moltbox service ...` for the service plane
- use `moltbox test|prod openclaw ...` for runtime-native lifecycle work
- use `moltbox test|prod verify ...` for routine diagnostics
- use `moltbox secret ...` for secret storage
- use `moltbox gateway update` for gateway self-update
- do not treat raw Docker or break-glass SSH as the normal operator path

## Retired Public Surfaces

These are retired from the active public contract:

- `dev`
- `opensearch`
- `runtime`
- `skill`
- `plugin`
- `gateway service`
- `gateway docker`
- top-level `caddy`
- gateway token-management subcommands as a routine operator surface

Historical docs may still mention those surfaces. Treat them as retired unless the current Gateway repo explicitly says otherwise.

## Related Documents

- [CLI](../docs/operations/cli.md)
- [Operator Workflow](../docs/operations/operator-workflow.md)
- [Gateway](../docs/concepts/gateway.md)
