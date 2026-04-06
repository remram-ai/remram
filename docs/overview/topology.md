# Topology

This file is the ecosystem-level pointer for Moltbox appliance topology.

For the live appliance topology, use the Gateway repo:

- [Moltbox Gateway System Overview](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/system-overview.md)
- [Moltbox Runtime / Services Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/runtime-and-services.md)
- [Moltbox Host / Operations Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/host-and-operations.md)

## Current Topology Summary

The live appliance is a Linux host running:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `openclaw-test`
- `openclaw-prod`

The operator-facing service names are:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `test`
- `prod`

Important topology rules:

- the host stays minimal
- the gateway is the control plane
- `test` is the proving lane
- `prod` is a protected managed pet
- operators work through restricted SSH plus the `moltbox` CLI
- normal runtime mutation uses native OpenClaw lifecycle

Use this file for orientation only. The Gateway repo is the authoritative topology source.
