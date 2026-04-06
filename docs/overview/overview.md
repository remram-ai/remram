# Platform Overview

This file is the ecosystem-level summary for Moltbox in the wider Remram architecture.

For the live appliance contract, use the Gateway repo:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Gateway Design](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/design/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)

## Current High-Level Picture

At the ecosystem level, Moltbox is the managed appliance layer that sits between users and applications on one side and Cortex-backed long-term knowledge behavior on the other.

```text
People and clients
  -> Remram App
    -> Moltbox Gateway
      -> OpenClaw runtimes
        -> Remram Cortex
```

## Current Appliance Summary

The live appliance is a Linux host running a small managed service set:

- `gateway`
- `caddy`
- `ollama`
- `searxng`
- `test`
- `prod`

Key operating assumptions:

- `test` is the proving lane
- `prod` is a protected managed pet
- the gateway is thin and service-plane focused
- normal runtime mutation uses native OpenClaw CLI surfaces
- recovery is snapshot-first, not replay-first
- baseline web capability is `web_search`, built-in `web_fetch`, and native OpenClaw `browser`

## Ownership Split

At a high level:

- `remram` owns ecosystem framing, feature records, and the platform registry
- `moltbox-gateway` owns the live appliance/operator contract for Moltbox
- `moltbox-services` owns baseline service definitions, baseline config examples, and service docs
- `moltbox-runtime` owns the final deployable runtime layer
- `remram-cortex` owns Cortex implementation

If the question is "how does the live Moltbox appliance actually work right now?", the answer belongs in `moltbox-gateway`, not here.

## Related Documents

- [Repositories](repositories.md)
- [CLI Architecture](cli-architecture.md)
- [Deployment Models](deployment-models.md)
- [Topology](topology.md)
