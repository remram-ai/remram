# CLI Architecture

This file is now a high-level pointer, not the authoritative CLI architecture reference.

For the current Moltbox CLI contract and operator model, use:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)

## Current Architectural Summary

The live CLI is:

- resource-oriented
- service-plane focused
- snapshot-guarded around dangerous mutation
- native-OpenClaw-first for runtime lifecycle
- backed by restricted SSH operator roles for normal work

The current public command families are:

- `gateway`
- `service`
- `test openclaw`
- `test verify`
- `prod openclaw`
- `prod verify`
- `ollama`
- `secret`

The detailed command tree, runtime/service mapping, and operator workflow are maintained in the Gateway repo so the appliance implementation and documentation stay in the same place.
