# OpenSearch Specification

## Purpose

OpenSearch is the baseline indexing, storage, and retrieval service for the appliance.

Its job is to provide an internal search backend for runtime retrieval without expanding into full Cortex behavior yet.

## Implementation Surfaces

Primary evidence:

- `moltbox-services/services/opensearch/service.yaml`
- `moltbox-services/services/opensearch/compose.yml.template`
- `moltbox-services/services/opensearch/Dockerfile`
- `moltbox-runtime/opensearch/opensearch.yml`
- `moltbox-runtime/openclaw-*/opensearch.yml`
- `moltbox-runtime/openclaw-*/tools.yaml`

## Architecture Components

The feature depends on:

1. the `opensearch` service definition
2. service-local config files and environment files
3. runtime retrieval tool definitions that target the backend
4. gateway service lifecycle orchestration

## Configuration Model

Current service posture:

- single-node deployment
- internal-only networking
- local Docker build at deploy time
- persistent OpenSearch data volume
- explicit runtime config mount for `opensearch.yml`
- intentionally light scope: indexing, storage, and retrieval

Current runtime-facing posture:

- runtimes resolve OpenSearch through `OPENSEARCH_URL`
- retrieval tools identify `opensearch` as the backend
- runtime-local config carries the index name and URL variable mapping

## Lifecycle

Typical lifecycle:

1. render the service definition and config inputs
2. build or prepare the target image
3. deploy the `opensearch` service
4. validate the internal health endpoint
5. confirm runtime retrieval paths can reach the backend

## Dependencies

Required dependencies:

- Docker and the appliance internal network
- valid OpenSearch config files
- host kernel settings that satisfy OpenSearch runtime requirements
- healthy runtime connectivity from OpenClaw environments

## Runtime Behavior

Observed baseline behavior:

- OpenSearch is internal-only
- runtimes treat it as a deterministic retrieval dependency
- the service is intentionally separate from future Cortex memory design
- higher-level semantic search, embeddings, ranking, and memory intelligence are out of scope here and belong to Cortex

This keeps the current retrieval stack simple while preserving a clean boundary for later architecture work.

## Constraints And Edge Cases

- host kernel or memory settings can block service startup
- OpenSearch may be healthy as a service while runtime retrieval still fails because environment variables or tool config drifted
- the design should stay intentionally light until Cortex ownership becomes clearer

## TODO

- document the initial index bootstrap and schema expectations once the retrieval contract is frozen beyond the current baseline config
- document the handoff boundary between this baseline retrieval service and future Cortex-owned search or memory layers
