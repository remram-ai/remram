# Deployment Models

This file is the high-level Remram pointer for Moltbox deployment behavior.

For the current live deployment contract, use the Gateway repo:

- [Moltbox CLI / Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/cli-and-gateway.md)
- [Moltbox Runtime / Services Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/runtime-and-services.md)
- [Moltbox Backup / Recovery Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/backup-and-recovery.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)

## Current Deployment Summary

The current deployment model is:

- tracked repo state in the Moltbox repos
- host pull of exact revisions
- official deploy through `moltbox gateway update` and `moltbox service ...`
- native OpenClaw lifecycle for runtime-local mutation
- snapshot-first rollback posture

Important corrections relative to older Moltbox assumptions:

- replay and checkpoint are not the normal `test` / `prod` lifecycle
- `prod` is not treated as a disposable runtime
- raw Docker is not the normal deployment path
- the Gateway repo, not `remram`, owns the detailed deployment contract
