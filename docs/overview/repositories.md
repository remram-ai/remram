# Repositories

This document describes the repository ownership model for the current Remram ecosystem.

For the live Moltbox appliance contract, the authoritative docs now live in `moltbox-gateway`:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Gateway Docs](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)
- [Moltbox Service Catalog](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/service-catalog.md)

## Ownership Summary

- `remram`
  - ecosystem framing
  - approved feature records
  - platform registry
  - high-level cross-repo architecture docs
- `remram-forge` (private)
  - lifecycle governance
  - orchestration rules
  - lifecycle-owned templates and state contracts
- `moltbox-gateway`
  - live Moltbox appliance/operator contract
  - `moltbox` CLI
  - Gateway control plane
  - service-plane orchestration
  - deployment/snapshot metadata
- `moltbox-services`
  - baseline service definitions
  - baseline service config examples
  - service-local docs
  - thin service wrappers
- `moltbox-runtime`
  - final deployable runtime artifacts
  - private or base-specific runtime overlays when needed
- `remram-skills`
  - reusable skills and plugin packages
- `remram-cortex`
  - Cortex implementation
- `remram-app`
  - user-facing applications and APIs

## Boundary Rule

Use `remram` for:

- ecosystem framing
- feature intent
- cross-repo ownership
- platform registry and capability map

Use `moltbox-gateway` for:

- live appliance behavior
- operator workflow
- CLI contract
- current service inventory
- Gateway/OpenClaw lifecycle rules
- snapshot and restore posture

## Current Interaction Model

```text
remram
  -> defines feature intent and ecosystem map

moltbox-services
  -> defines appliance service baselines and service docs

moltbox-runtime
  -> holds the final deployable runtime layer

moltbox-gateway
  -> turns those inputs into the live managed appliance
```

## Runtime Mutation Boundary

- baseline service inputs belong in `moltbox-services`
- final deployable runtime artifacts belong in `moltbox-runtime`
- live runtime mutation happens through native OpenClaw lifecycle on the appliance
- appliance snapshots and deployment records belong to `moltbox-gateway`
- live runtime state does not get mirrored continuously back into Git
