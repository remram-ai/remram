# OpenSearch Test Plan

## Definition Of Done

OpenSearch is done when:

- the service deploys successfully
- the internal health endpoint responds
- runtime retrieval configuration points at the expected backend
- retrieval-dependent runtime paths can reach the service

## Core Validation

### 1. Service Lifecycle Validation

Verify:

- `moltbox gateway service deploy opensearch`
- `moltbox gateway service status opensearch`

Expected result:

- the service becomes healthy after deploy

### 2. Internal Health Validation

Verify the internal OpenSearch health endpoint responds from inside the appliance network.

Expected result:

- internal cluster health request succeeds

### 3. Runtime Retrieval Validation

Verify the runtime retrieval tool configuration still points to the `opensearch` backend.

Expected result:

- `retrieval_search` remains configured for OpenSearch in the target environments

### 4. Internal-Only Exposure Validation

Verify OpenSearch remains internal-only.

Expected result:

- no unintended host-public service exposure

## Failure Cases To Test

- deploy succeeds but healthcheck fails
- service is healthy but runtime retrieval fails due to URL or env drift
- config files render incorrectly
- host prerequisites for OpenSearch are missing

## Operator-Visible Success Criteria

- operators can deploy and inspect OpenSearch through Moltbox
- retrieval-backed runtime behavior has a stable internal dependency
- failures can be localized to service health or runtime integration

## Runtime And Deployment Checks

- verify rendered config files exist
- verify mounted OpenSearch config matches the intended posture
- verify the service remains reachable from the runtime network
