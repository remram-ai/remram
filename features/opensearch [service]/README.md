# OpenSearch

OpenSearch is the baseline indexing, storage, and retrieval service for the Moltbox appliance.

It gives the runtime a local internal search backend without pulling Cortex design into the platform too early.

## What Role It Plays

OpenSearch provides the current retrieval substrate for the appliance.

In the current system it is used as:

- the backend for runtime retrieval tools
- internal storage for indexed search data
- internal retrieval over that indexed data

## Why It Exists

The appliance needs a local retrieval capability that the runtimes can call deterministically.

OpenSearch fills that role while keeping the design intentionally narrow:

- internal-only service
- single-node posture
- indexing, storage, and retrieval only
- not higher-level semantic search intelligence

## Main Moving Parts

- the `opensearch` service definition in `moltbox-services`
- the `opensearch.yml` runtime config in `moltbox-runtime`
- runtime tool definitions that point retrieval to the OpenSearch backend
- the gateway service pipeline used to deploy and inspect the service

## How It Interacts With Other Components

- OpenClaw runtimes refer to it through `OPENSEARCH_URL`
- runtime tool registries expose `retrieval_search` against the `opensearch` backend
- the gateway deploys and monitors it as a first-class appliance service
- higher-level semantic retrieval, embeddings, ranking, and long-term memory intelligence remain Cortex concerns rather than OpenSearch concerns in this layer

## Operator View

Operators usually manage the service through the gateway:

```text
moltbox gateway service deploy opensearch
moltbox gateway service status opensearch
```

The CLI also reserves a service passthrough namespace:

```text
moltbox opensearch <native command>
```

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Platform Topology](../../docs/platform/topology.md)
- [Deployment Models](../../docs/platform/deployment-models.md)
