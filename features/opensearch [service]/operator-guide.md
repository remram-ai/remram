# OpenSearch Operator Guide

## Purpose

Use OpenSearch when you need to manage or diagnose the appliance retrieval backend.

## Normal Operator Actions

Manage the service through the gateway:

```text
moltbox gateway service deploy opensearch
moltbox gateway service status opensearch
```

For service-specific diagnostics, use:

```text
moltbox opensearch <native command>
```

## What To Check

If retrieval behavior is failing:

- confirm the `opensearch` service is healthy
- confirm the runtime still points retrieval to the OpenSearch backend
- confirm the internal cluster health endpoint responds
- confirm the service is still internal-only and reachable from the runtime network

Keep the operator mental model narrow:

- OpenSearch owns indexing, storage, and retrieval
- if the issue is semantic ranking, embeddings, or higher-level memory behavior, that belongs to Cortex design rather than the baseline OpenSearch service contract

## Operational Touchpoints

- gateway service pipeline
- rendered OpenSearch config
- runtime retrieval tool config
- internal service health

## Troubleshooting Basics

Common failure cases:

- OpenSearch does not start because host prerequisites are missing
- service health is green but runtime retrieval config drifted
- config files mounted into the container do not match the intended baseline

## TODO

- document the preferred operator path for inspecting indices and documents once the baseline retrieval contract is defined more concretely
