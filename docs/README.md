# Documentation Rewrite Strategy

This document is the active documentation strategy for the Architecture V2 redraft phase.

It exists after the archival sweep so the next rewrite phase has one current guide instead of competing active document trees.

## Purpose

The repository has been intentionally cleared of the prior active architecture, design, review, and operational document trees.

Those materials now live under:

```text
archive/2026-03-12-documentation-redraft-baseline/
```

That archive is frozen historical reference.

The next phase will rewrite the Architecture V2 documentation set from scratch against the locked architecture baseline.

This strategy defines:

- which documents should exist in the rewritten set
- what each document is for
- how much detail each should carry
- which archived materials feed each new document
- whether each document should be rewritten, merged, split, or created net-new
- how the final set should function as a coherent architecture knowledge system

## Active Versus Archived Material

Active during this phase:

- root `README.md`
- `features/README.md`
- this strategy document

Archived and frozen:

- `archive/2026-03-12-documentation-redraft-baseline/architecture-v2/`
- `archive/2026-03-12-documentation-redraft-baseline/docs/`
- `archive/2026-03-12-documentation-redraft-baseline/ai-context/`
- `archive/2026-03-12-documentation-redraft-baseline/backlog/`
- `archive/2026-03-12-documentation-redraft-baseline/moltbox/`

Working rule:

- no legacy document should be edited in place
- the new documentation set should be authored as a fresh, internally consistent Architecture V2 corpus

## Rewrite Principles

The rewritten set should follow these rules:

1. One active architecture line only.
2. Review artifacts remain archived evidence, not active specification.
3. CLI behavior, deployment behavior, storage behavior, and repo boundaries must each have a single active source of truth.
4. Vocabulary must be explicit and consistent across all documents.
5. Mutable runtime state, snapshots, checkpoints, and replay history must be documented as first-class architecture concepts.
6. Transitional or legacy behavior belongs in archive history, not in active reference docs.
7. The final set should read from top-level orientation down to operational contracts without requiring the reader to infer architecture from review notes.

## Locked Baseline Summary

The rewrite must align to the locked decisions already made:

- `ollama` is a first-class appliance service in `moltbox-services`
- OpenClaw runtimes are mutable systems
- `moltbox-runtime` defines baseline runtime configuration only
- gateway uses native OpenClaw plugin and skill installation flows
- pre-deploy runtime snapshots live under `/srv/moltbox-state/runtime-snapshots/`
- runtime checkpoints are promoted baselines and may enter source control
- gateway owns deployment metadata and deployment replay history
- the operator path is `Visual Studio -> MCP plugin -> Moltbox CLI -> Gateway`
- canonical CLI grammar remains `moltbox <component> <command>`
- retired CLI namespaces are `tools`, `host`, and `runtime <env>`
- the generic `runtime` CLI namespace is removed
- checkpoint-style runtime operations should bind directly to runtime components
- `moltbox-gateway` is the canonical gateway repository identity
- steady-state container names do not use the `moltbox-` prefix

## Target Document Set

The rewritten active Architecture V2 set should contain the following documents.

### 1. `architecture-v2/README.md`

Purpose:

- entrypoint to the active architecture corpus
- explain reading order
- define source-of-truth hierarchy

Detail level:

- concise orientation and document map

Primary inputs:

- `archive/2026-03-12-documentation-redraft-baseline/architecture-v2/README.md`
- `archive/2026-03-12-documentation-redraft-baseline/docs/README.md`
- root `README.md`
- `archive/2026-03-12-documentation-redraft-baseline/architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- merged rewrite

Reasoning:

- the new set needs one entrypoint instead of a split between `docs/` and `architecture-v2/`

### 2. `architecture-v2/system-model.md`

Purpose:

- describe the total system model at a high level
- define the appliance, product, runtime, and memory layers
- state the main architectural boundaries and source-of-truth rules

Detail level:

- high-level architecture contract

Primary inputs:

- `archive/.../docs/overview/system-architecture.md`
- `archive/.../docs/overview/ecosystem-map.md`
- `archive/.../docs/overview/moltbox.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- merged rewrite

Reasoning:

- the old overview material is spread across multiple documents and no longer reflects the locked V2 baseline

### 3. `architecture-v2/repository-taxonomy.md`

Purpose:

- define repository boundaries, ownership rules, and canonical vocabulary

Detail level:

- normative repository and terminology reference

Primary inputs:

- `archive/.../architecture-v2/repo_taxonomy_latest_spec_before_refactor.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`
- `features/README.md`

Rewrite mode:

- rewritten from one primary source plus review corrections

Reasoning:

- the taxonomy doc is still useful, but it must be separated from its obsolete CLI language

### 4. `architecture-v2/cli-taxonomy.md`

Purpose:

- define canonical CLI grammar, namespaces, aliases, removed namespaces, and command family boundaries

Detail level:

- normative CLI reference at the taxonomy level, not a full command manual

Primary inputs:

- `archive/.../architecture-v2/cli-taxonomy-vocab-audit.md`
- `archive/.../architecture-v2/gateway.md`
- `archive/.../architecture-v2/moltbox-runtime-snapshot.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- rewritten from audit artifact

Reasoning:

- CLI drift was severe enough that the rewritten set needs a dedicated authoritative CLI taxonomy document

### 5. `architecture-v2/gateway.md`

Purpose:

- define the control plane
- define deployment metadata authority
- define self-update, repo refresh, orchestration responsibilities, and operator-facing role

Detail level:

- component contract with operational boundaries

Primary inputs:

- `archive/.../architecture-v2/gateway.md`
- `archive/.../docs/concepts/control-plane.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- merged rewrite

Reasoning:

- gateway is the center of the appliance model and must have a clean contract separate from CLI taxonomy and deployment lifecycle details

### 6. `architecture-v2/services.md`

Purpose:

- define steady-state service topology
- define canonical service identities and naming
- document `gateway`, `caddy`, `opensearch`, `ollama`, and `openclaw-*` runtimes

Detail level:

- topology and ownership reference

Primary inputs:

- `archive/.../architecture-v2/services.md`
- `archive/.../architecture-v2/moltbox-runtime-snapshot.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- merged rewrite

Reasoning:

- service identity, naming, and `ollama` status must be made explicit and final

### 7. `architecture-v2/runtime.md`

Purpose:

- define baseline runtime configuration
- define mutable live runtime state
- define snapshots, checkpoints, replay history, and rebuild behavior

Detail level:

- detailed lifecycle and state model

Primary inputs:

- `archive/.../architecture-v2/runtime.md`
- `archive/.../architecture-v2/moltbox-runtime-snapshot.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- rewritten from multiple sources

Reasoning:

- runtime is where the largest architectural changes landed during review, so it needs a clean rewrite rather than incremental edits

### 8. `architecture-v2/skills.md`

Purpose:

- define the role of `remram-skills`
- define skill deployment versus service deployment
- define plugin-backed capability deployment into runtimes

Detail level:

- component boundary and deployment model reference

Primary inputs:

- `archive/.../architecture-v2/skills.md`
- `archive/.../architecture-v2/openclaw-plugin-integration-review.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`
- `features/README.md`

Rewrite mode:

- merged rewrite

Reasoning:

- skills sit across product capability, runtime mutation, and OpenClaw integration, so this boundary must be explicit

### 9. `architecture-v2/storage-and-artifacts.md`

Purpose:

- define state roots, log roots, render roots, repo mirrors, deployment metadata, runtime snapshots, replay history, and checkpoint artifact locations

Detail level:

- concrete storage contract reference

Primary inputs:

- `archive/.../architecture-v2/gateway.md`
- `archive/.../architecture-v2/runtime.md`
- `archive/.../architecture-v2/moltbox-runtime-snapshot.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- net-new document split out from multiple sources

Reasoning:

- storage layout is currently spread across gateway, runtime, and deployment notes; splitting it out reduces duplication and drift

### 10. `architecture-v2/deployment-lifecycle.md`

Purpose:

- define Git-backed deployment flow
- define pre-deploy runtime snapshots
- define service deploy, gateway self-update, rollback, and deployment metadata requirements

Detail level:

- lifecycle and control-plane flow contract

Primary inputs:

- `archive/.../architecture-v2/gateway.md`
- `archive/.../architecture-v2/services.md`
- `archive/.../architecture-v2/runtime.md`
- `archive/.../architecture-v2/moltbox-runtime-snapshot.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`

Rewrite mode:

- merged rewrite

Reasoning:

- deployment behavior now spans service deployment, runtime safety, replay history, and gateway metadata ownership, so it needs its own document

### 11. `architecture-v2/operator-model.md`

Purpose:

- define the operator control path
- define the MCP plugin, CLI, gateway relationship
- define the role of the thin host wrapper
- state that Docker is an internal implementation detail

Detail level:

- concise but normative operator model

Primary inputs:

- `archive/.../architecture-v2/architecture-review-second-pass.md`
- `archive/.../docs/getting-started/run-remram.md`
- `archive/.../docs/getting-started/contribute.md`
- root `README.md`

Rewrite mode:

- net-new document

Reasoning:

- the operator model changed materially during review and should no longer be inferred indirectly from gateway docs

### 12. `architecture-v2/openclaw-integration.md`

Purpose:

- define how OpenClaw fits into the architecture
- define native plugin installation, runtime mutation boundaries, and integration responsibilities

Detail level:

- architecture integration reference

Primary inputs:

- `archive/.../architecture-v2/openclaw-plugin-integration-review.md`
- `archive/.../architecture-v2/runtime.md`
- `archive/.../architecture-v2/skills.md`

Rewrite mode:

- rewritten from analysis note into normative architecture text

Reasoning:

- the review note should become stable architecture guidance rather than remain an analysis-only artifact

### 13. `architecture-v2/glossary.md`

Purpose:

- define canonical terms such as Feature, Skill, Service, Runtime, Gateway, Snapshot, Checkpoint, Deployment Event, Replay History, and Baseline

Detail level:

- short reference glossary

Primary inputs:

- `archive/.../architecture-v2/repo_taxonomy_latest_spec_before_refactor.md`
- `archive/.../architecture-v2/cli-taxonomy-vocab-audit.md`
- `archive/.../architecture-v2/architecture-review-second-pass.md`
- `features/README.md`

Rewrite mode:

- net-new document assembled from multiple sources

Reasoning:

- terminology drift was one of the recurring sources of confusion, so the new set needs an explicit glossary

## Rewrite Order

The document rewrite should proceed in this order:

1. `architecture-v2/README.md`
2. `architecture-v2/system-model.md`
3. `architecture-v2/repository-taxonomy.md`
4. `architecture-v2/glossary.md`
5. `architecture-v2/cli-taxonomy.md`
6. `architecture-v2/gateway.md`
7. `architecture-v2/services.md`
8. `architecture-v2/runtime.md`
9. `architecture-v2/skills.md`
10. `architecture-v2/storage-and-artifacts.md`
11. `architecture-v2/deployment-lifecycle.md`
12. `architecture-v2/operator-model.md`
13. `architecture-v2/openclaw-integration.md`

Reason for this order:

- start with the index and top-level system model
- lock vocabulary and boundaries before component docs
- write component docs before shared lifecycle and storage contracts
- finish with operator and OpenClaw integration documents that depend on the earlier contracts

## How the Final Set Should Work as a Knowledge System

The final active documentation set should function in layers:

### Layer 1. Orientation

- `architecture-v2/README.md`
- `architecture-v2/system-model.md`

This layer tells a new reader what the system is and how to navigate the rest of the corpus.

### Layer 2. Semantics and boundaries

- `architecture-v2/repository-taxonomy.md`
- `architecture-v2/glossary.md`
- `architecture-v2/cli-taxonomy.md`

This layer ensures readers learn the canonical nouns and control surfaces before they read lifecycle details.

### Layer 3. Component contracts

- `architecture-v2/gateway.md`
- `architecture-v2/services.md`
- `architecture-v2/runtime.md`
- `architecture-v2/skills.md`
- `architecture-v2/openclaw-integration.md`

This layer explains who owns what and how the major system parts fit together.

### Layer 4. Cross-cutting operational contracts

- `architecture-v2/storage-and-artifacts.md`
- `architecture-v2/deployment-lifecycle.md`
- `architecture-v2/operator-model.md`

This layer explains how the architecture behaves in operation.

### Layer 5. Product capability references

- `features/README.md`
- future feature documents

These stay conceptually adjacent but are not part of the appliance control-plane spec itself.

## Explicit Non-Goals for the Rewrite Phase

The rewrite phase should not:

- preserve legacy document structure for its own sake
- keep transitional CLI namespaces alive in active docs
- treat review artifacts as active specification
- rewrite backlog or historical proposal material into the architecture corpus
- turn the architecture rewrite into an implementation refactor plan

## Success Criteria

The strategy is satisfied when the next redraft phase produces:

- one active Architecture V2 corpus
- one active CLI taxonomy
- one active repository taxonomy
- one active runtime model with snapshots, checkpoints, and replay history clearly defined
- one active operator model
- explicit storage and deployment contracts
- no active dependence on archived transitional or review documents
