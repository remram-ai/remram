# Moltbox Runtime Snapshot

This document captures the deployed appliance state that was validated during the OpenClaw runtime and CLI/control-plane rollout threads.

It is a deployment snapshot, not a replacement for the architecture documents in this directory.

## 1. Running Appliance Topology

Expected steady-state containers:

| Component | Container name | Validated image | Host-exposed ports | Internal ports | Health endpoints |
| --- | --- | --- | --- | --- | --- |
| gateway | `gateway` | `moltbox-gateway:c2e5477` | `17474/tcp` | `7474/tcp` | `http://127.0.0.1:7474/health` |
| openclaw-dev | `openclaw-dev` | `ghcr.io/openclaw/openclaw:latest` | `18790/tcp` | `18789/tcp` | `http://127.0.0.1:18789/healthz`, `http://127.0.0.1:18789/readyz` |
| openclaw-test | `openclaw-test` | `ghcr.io/openclaw/openclaw:latest` | `28789/tcp` | `18789/tcp` | `http://127.0.0.1:18789/healthz`, `http://127.0.0.1:18789/readyz` |
| openclaw-prod | `openclaw-prod` | `ghcr.io/openclaw/openclaw:latest` | `38789/tcp` | `18789/tcp` | `http://127.0.0.1:18789/healthz`, `http://127.0.0.1:18789/readyz` |
| opensearch | `opensearch` | `moltbox-opensearch:local` | none | `9200/tcp` | Docker healthcheck uses TCP connect on `127.0.0.1:9200` |
| caddy | `caddy` | `caddy:2.8.4` | `80/tcp`, `443/tcp` | `80/tcp`, `443/tcp` | `http://127.0.0.1/healthz` |

Topology summary:

- the gateway container is the control plane
- all OpenClaw runtimes run as separate containers
- Caddy terminates HTTPS ingress and forwards to gateway or the runtime host ports
- OpenSearch runs as an internal shared service

## 2. Persistent Appliance Storage Layout

Canonical durable roots:

- state root: `/srv/moltbox-state/`
- logs root: `/srv/moltbox-logs/`

Runtime state directories:

- `/srv/moltbox-state/runtime/openclaw-dev`
- `/srv/moltbox-state/runtime/openclaw-test`
- `/srv/moltbox-state/runtime/openclaw-prod`

Important separation of concerns:

- rendered runtime configuration
  - service deploy renders config into `/srv/moltbox-state/deploy/rendered/<service>/config/<service>/`
  - runtime config sync stages render-only output into `/srv/moltbox-state/deploy/runtime-sync/<component>/`
- runtime container state
  - mutable OpenClaw container state lives under `/srv/moltbox-state/runtime/<component>/`
  - the gateway no longer tries to synchronize mutable state under `/home/node/.openclaw`
- deployment artifacts
  - deployment snapshots, last-success records, rollback state, and active render copies live under `/srv/moltbox-state/services/<service>/`

Logs are separated from state:

- `/srv/moltbox-logs/gateway/`
- `/srv/moltbox-logs/services/`

## 3. Gateway Ingress Routes

Active ingress routes validated during deployment:

- `https://moltbox-cli`
  - maps to the `gateway` container on internal port `7474`
- `https://moltbox-dev`
  - maps to `openclaw-dev` through host port `18790`
- `https://moltbox-test`
  - maps to `openclaw-test` through host port `28789`
- `https://moltbox-prod`
  - maps to `openclaw-prod` through host port `38789`

Ingress notes:

- Caddy is the only ingress container in the steady-state appliance
- `https://moltbox-cli/health` is the gateway health route exposed through Caddy
- runtime ingress is HTTPS-first even though each runtime still keeps its direct host port mapping

## 4. Current CLI Command Surface

Canonical grammar:

```text
moltbox <component> <command>
```

Canonical examples:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway repo refresh runtime

moltbox service deploy openclaw-dev
moltbox service deploy openclaw-test
moltbox service deploy openclaw-prod
moltbox service deploy opensearch
moltbox service deploy caddy

moltbox openclaw-dev config sync
moltbox openclaw-dev reload
moltbox openclaw-test doctor
moltbox openclaw monitor

moltbox skill deploy semantic-router --runtime openclaw-test
moltbox openclaw-test skill deploy semantic-router
```

Aliases:

- `openclaw == openclaw-prod`

Normalization rule:

- legacy surfaces such as `moltbox tools ...`, `moltbox host ssl ...`, and `moltbox runtime dev ...` are no longer canonical
- the CLI now returns explicit replacement guidance for those older forms

## 5. Repository Responsibility Boundaries

Repository boundaries in the deployed model:

- `remram`
  - product docs
  - architecture docs
  - architecture-v2 reference set
- `remram-skills`
  - skill implementations
  - skill packages
  - deploy recipes
- `moltbox-gateway`
  - control-plane implementation
  - CLI
  - orchestration logic
  - Docker interaction
  - runtime synchronization
  - note: the implementation repository is still currently named `remram-gateway` in the active workspace
- `moltbox-runtime`
  - runtime templates
  - runtime configuration inputs
  - environment-owned runtime material
- `moltbox-services`
  - service definitions
  - Dockerfiles
  - compose templates
  - service manifests

## 6. Known Limitations Discovered During This Deployment

- semantic-router provenance warning
  - OpenClaw can still emit a warning that `semantic-router` was loaded without full install/load-path provenance even though the plugin validates as loaded and the skill validates as eligible
- historical router config `ENOENT` message
  - during early plugin-backed skill iterations, stale plugin state could surface a historical router-config `ENOENT` style message while the runtime was being normalized
  - the deployment now succeeds, but this remains a useful diagnostic clue when old plugin state is present
- remaining operator documentation drift
  - the primary CLI/operator docs were updated during the rollout
  - some older gateway docs and feature-specific notes still contain historical `tools` / `host` / `runtime` examples and should be treated as pre-normalization reference material
