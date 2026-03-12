# Repository Taxonomy V2

This document aligns the CLI refactor with the finalized repository strategy.

## RemRam Layer

### `remram`

Owns:

- product architecture
- ecosystem documentation
- feature definitions
- product proposals

New long-term locations in this repository:

- `architecture-v2/` for approved target architecture
- `features/` for feature definitions

### `remram-cortex`

Owns:

- durable knowledge
- retrieval pipelines
- reflection and reconciliation
- artifact promotion internals

### `remram-app`

Owns:

- user-facing APIs
- application UI
- operator and user workflows

### `remram-skills`

Owns portable OpenClaw skill packages.

Skills are reusable capabilities, not appliance-only deployment units.

## Moltbox Layer

### `remram-gateway`

Current implementation home for the Moltbox control plane.

Owns:

- CLI implementation
- control-plane orchestration
- deployment engine
- Docker interaction
- runtime monitoring

This repository is the implementation home for the gateway refactor until any later repository extraction is performed.

### `moltbox-services`

External repository defining service topology and deployment inputs.

Expected structure:

```text
services/
  openclaw-dev/
  openclaw-test/
  openclaw-prod/
  opensearch/
  caddy/
```

Each service directory may contain:

- service definition files
- Dockerfile extensions
- service documentation
- helper scripts

### `moltbox-runtime`

External repository containing runtime and component configuration state.

Expected structure:

```text
openclaw-dev/
openclaw-test/
openclaw-prod/
opensearch/
caddy/
```

This repository is the source of truth for live runtime wiring and synchronized configuration artifacts.

## Taxonomy Rules

- features are defined in `remram/features`
- skills live in `remram-skills`
- services live in `moltbox-services`
- runtime wiring lives in `moltbox-runtime`
- gateway orchestration lives in `remram-gateway`

The CLI must not mirror repository layers directly.

The CLI should expose the component or orchestration action being managed.
