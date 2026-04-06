# CLI

For the live Moltbox CLI contract, use the Gateway repo first:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)

## Current Summary

Current command families:

- `gateway`
- `service`
- `test openclaw`
- `test verify`
- `prod openclaw`
- `prod verify`
- `ollama`
- `secret`

Key rules:

- normal appliance work stays inside the `moltbox` CLI
- service-plane lifecycle uses `moltbox service ...`
- runtime-native lifecycle uses `moltbox test|prod openclaw ...`
- routine diagnostics use `moltbox test|prod verify ...`
- raw Docker and break-glass SSH are not the normal operator path

Use this file as a quick reminder only. The Gateway repo is the authoritative CLI source.
