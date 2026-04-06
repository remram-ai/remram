# Operator Workflow

This file is now a short cross-repo pointer for readers who start in `remram`.

The authoritative live operator workflow for the Moltbox appliance lives in `moltbox-gateway`:

- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox Service Catalog](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/service-catalog.md)
- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)
- [Moltbox Backup / Recovery Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/backup-and-recovery.md)

## Current Workflow Summary

Normal human and AI operator flow is:

```text
workstation or automation
  -> restricted SSH
    -> host-side moltbox CLI
      -> Gateway service plane
      -> native OpenClaw CLI in test or prod
```

Current operational rules:

- use `moltbox service ...` for service-plane lifecycle work
- use `moltbox test openclaw ...` and `moltbox prod openclaw ...` for runtime-native lifecycle work
- use `moltbox test verify ...` and `moltbox prod verify runtime` for routine diagnostics
- use snapshot-first recovery rather than replay/checkpoint-era rebuild flows
- treat `prod` as a protected managed pet

Current managed services:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `test`
- `prod`

If a local Remram document disagrees with the Gateway repo on live operator workflow, the Gateway repo wins.
