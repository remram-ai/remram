# CLI

This file is now a cross-repo pointer, not the authoritative CLI contract.

For the live Moltbox CLI, use:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)

## Current CLI Summary

The current public contract is:

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

Current managed services:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `test`
- `prod`

Operational rules that still matter here:

- use the CLI as the normal appliance control surface
- use `moltbox service ...` for service-plane lifecycle work
- use `moltbox test|prod openclaw ...` for native OpenClaw lifecycle work
- use `moltbox test|prod verify ...` for routine verification
- do not treat raw Docker or break-glass SSH as the normal operator path

If a local Remram doc conflicts with the live Gateway repo docs on CLI behavior, the Gateway repo wins.
