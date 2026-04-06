# Moltbox Gateway Specification

This file is now an ecosystem-level summary, not the detailed Gateway authority document.

For the live Gateway contract, use `moltbox-gateway`:

- `README.md`
- `docs/design/`
- `docs/guides/operator-guide.md`

## Purpose

Moltbox Gateway is the appliance control plane.

It owns the operator-facing command surface and coordinates the lifecycle of the appliance as a whole.

## Current Scope Summary

Gateway owns:

- the `moltbox` CLI
- service lifecycle orchestration
- gateway self-update
- environment-scoped native OpenClaw passthrough
- verification surfaces
- snapshot-aware mutation guardrails
- deployment metadata writes

Gateway does not own:

- service definitions as source material
- baseline service config as source material
- final deployable runtime artifacts as source material
- skill implementation code

## Current Inputs

Gateway consumes four major input classes:

1. service definitions and service baselines from `moltbox-services`
2. final deployable runtime artifacts from `moltbox-runtime`
3. skill packages and recipes from `remram-skills`
4. operator intent from the Moltbox CLI over SSH

It also depends on:

- appliance state under `/srv/moltbox-state`
- logs under `/srv/moltbox-logs`
- Docker on the appliance host

## Current Public Control Surfaces

```text
moltbox gateway ...
moltbox service ...
moltbox test openclaw ...
moltbox test verify ...
moltbox prod openclaw ...
moltbox prod verify runtime
```

Detailed command behavior belongs in `moltbox-gateway`, not here.
