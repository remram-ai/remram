# Remram Cortex Master Test Plan

## Test Objectives

- validate the top-level promise of durable knowledge and structured retrieval
- confirm the feature improves long-term continuity without replacing runtime authority
- confirm the knowledge layer degrades safely when its backing systems are unavailable

## User Or Operator Goals

- as a user, I can return to a topic later and the system can recover relevant durable knowledge without me restating everything
- as an operator, I can verify that knowledge survives transcript compaction or session resets because it is stored independently
- as an operator, I can confirm reflection and Dream cycles mature knowledge without blocking live execution
- as a reviewer or admin, I can inspect knowledge provenance, confidence, dimension behavior, and promotion candidates

## Scope

- In scope: feature-level acceptance of durable knowledge storage, retrieval, reflection, Dream reconciliation, and graceful degradation
- In scope: top-level dimension and candidate-dimension behavior
- Out of scope: lower-level implementation details that will belong to a future dedicated Cortex platform bundle

## Referenced Lower-Level Plans

- [OpenSearch Platform Test Plan](../../platform/services/opensearch/test-plan.md)
- no dedicated `remram-cortex` platform-item test plan exists in this repository yet

## Preconditions

- OpenSearch is running and reachable
- a Cortex service implementation or development harness is available locally
- orchestration hooks or equivalent test harnesses can invoke `/retrieve`, `/ingest`, `/reflect`, and `/dream`
- sample transcripts, tool outputs, or imported documents are available as source inputs

## Test Cases

1. Scenario: user returns to a prior topic after enough time for transcript compaction or a new session boundary.
   Expected result: Cortex retrieves a bounded, relevant knowledge bundle that preserves durable context without depending on raw transcript replay.
2. Scenario: a completed interaction produces durable facts, constraints, or tool output.
   Expected result: reflection writes or updates knowledge objects with provenance, confidence, and dimensions after the visible response completes.
3. Scenario: reflection encounters an extracted attribute that does not fit an existing canonical dimension.
   Expected result: the system records a candidate dimension or miss, and recurring signal can later promote that category during Dream reconciliation instead of inventing it immediately.
4. Scenario: Dream reconciliation runs over accumulated knowledge.
   Expected result: contradictions can be detected, weak inferences can be demoted, stable patterns can be consolidated, and artifact-promotion candidates can be produced.
5. Scenario: Cortex is unavailable or OpenSearch is unavailable during a live run.
   Expected result: execution continues, retrieval returns empty or deferred results, and knowledge writes are queued or logged for retry rather than blocking the session.

## Exit Criteria

- the user and operator goals above are satisfied through the documented retrieval and reconciliation posture
- knowledge remains structurally separate from transcript history
- candidate-dimension tracking and promotion behavior is observable enough to validate the evolving indexing model
- knowledge failure modes degrade safely without taking down live runtime execution

## Results Summary

- [Result]
