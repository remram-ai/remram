# Topology

For detailed live Moltbox topology, use the Gateway repo:

- [Moltbox System Overview](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/system-overview.md)
- [Moltbox Runtime / Services Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/runtime-and-services.md)

## Current Summary

Steady-state appliance topology:

```text
Host OS
  -> Docker Engine
    -> gateway
    -> caddy
    -> ollama
    -> searxng
    -> openclaw-test
    -> openclaw-prod
```

Key rules:

- the host stays minimal
- the gateway is the control plane
- `test` is the proving lane
- `prod` is a managed pet
- normal lifecycle work goes through `moltbox`, not raw Docker
