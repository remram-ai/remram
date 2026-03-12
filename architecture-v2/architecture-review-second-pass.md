# Architecture Review Second Pass

This document is a review artifact.

It consolidates the second-pass architectural assessment produced during the V2 architecture review thread.

It is not the final architecture specification and it is not a refactor plan.

It records the current evaluation baseline, the evidence gathered from the repositories and live appliance, the conflicts observed, and the architecture decisions adopted during this review pass.

## 1. System Overview

The system being evaluated is the V2 Moltbox appliance model.

The intended baseline is:

- `remram` owns architecture and feature documentation
- `remram-skills` owns skill packages, plugin-backed skills, and deploy recipes
- `moltbox-runtime` owns baseline runtime configuration
- `moltbox-services` owns service definitions and deployment topology
- `moltbox-gateway` owns the control plane, CLI, deployment orchestration, Docker interaction, and deployment metadata writes

The appliance model is a Linux host running minimal host services plus containerized application components.

The steady-state control plane is the `gateway` container.

OpenClaw runtimes are treated as mutable runtime systems:

- baseline runtime configuration comes from `moltbox-runtime`
- live runtime state may change through native OpenClaw plugin and skill installation flows
- current runtime state is reconstructed from baseline plus deployment history
- checkpoint and backup artifacts live under appliance state storage, not in Git

The intended storage roots are machine-scoped:

- `/srv/moltbox-state`
- `/srv/moltbox-logs`

The intended CLI remains component-oriented:

```text
moltbox <component> <command>
```

This review pass evaluates the current implementation and deployed appliance against that updated V2 baseline.

## 2. Evidence Summary

The assessment used five evidence classes:

- `doc` — the updated `architecture-v2` baseline and the runtime snapshot
- `taxonomy` — the repository taxonomy document
- `code` — repository source in `remram`, `remram-gateway` or renamed `moltbox-gateway`, `moltbox-runtime`, `moltbox-services`, and `remram-skills`
- `snapshot` — `architecture-v2/moltbox-runtime-snapshot.md`
- `live` — direct inspection of the appliance host over SSH and read-only gateway CLI inspection

Key evidence gathered during the review:

- the live appliance host is `moltbox-prime`
- canonical machine-scoped roots exist under `/srv/moltbox-state` and `/srv/moltbox-logs`
- the live gateway container reports image `moltbox-gateway:de94de7`
- the live gateway self-report also resolves to `de94de7`
- rendered gateway deployment artifacts also resolve to `de94de7`
- gateway deployment state still reports `47387a6` in `last-success.json`
- the live gateway CLI surface is older than the current V2 CLI surface described in the updated architecture docs and local gateway source
- `moltbox-runtime` templates provide baseline OpenClaw configuration only
- live `openclaw-dev` and `openclaw-test` runtime state contains plugin-backed `semantic-router` mutation that is not present in the rendered baseline config
- `/srv/moltbox-state/runtime-baselines/` does not currently exist on the appliance
- the live appliance does not currently expose a host `moltbox` wrapper in `/usr/local/bin` or `~/.local/bin`
- the live host still has legacy containers named `moltbox-openclaw`, `moltbox-ollama`, `moltbox-opensearch`, and `moltbox-tools`
- active `moltbox-services` definitions use normalized container names such as `gateway`, `openclaw-dev`, `openclaw-test`, `openclaw-prod`, `opensearch`, and `caddy`
- active gateway runtime skill code still includes `moltbox-openclaw` as a fallback runtime container candidate
- the updated architecture naming examples include `ollama`, and OpenClaw runtime templates point to `http://ollama:11434`, but there is no `ollama` service definition in `moltbox-services`

## 3. Findings

### F-1. Deployment metadata is inconsistent for the running gateway artifact

Severity: `high`

Observed:

- live container image: `moltbox-gateway:de94de7`
- embedded gateway self-report: `de94de7`
- rendered gateway manifest and compose output: `de94de7`
- gateway `last-success.json`: `47387a6`

Assessment:

Under the updated V2 baseline, this is an implementation defect in deployment metadata writing, not an architecture ambiguity.

Impact:

- provenance is unreliable
- rollback confidence is reduced
- CLI/runtime observations can be misattributed to the wrong build

### F-2. The live gateway CLI does not match the current V2 CLI baseline

Severity: `high`

Observed:

- the live gateway help output omits `gateway repo refresh`
- the live gateway help output omits runtime-targeted `skill deploy`
- `moltbox tools status` still executes instead of returning replacement guidance
- the local gateway source and runtime snapshot describe the newer V2 command surface

Assessment:

This is deployment drift caused by an older gateway artifact still running on the appliance, not a defect in the architecture model itself.

Impact:

- operators cannot rely on the documented CLI contract
- runtime-targeted orchestration is not yet available on the deployed appliance
- legacy namespace retirement is incomplete in practice

### F-3. Runtime checkpointing is part of the V2 baseline but is not implemented yet

Severity: `medium`

Observed:

- the updated V2 baseline defines `moltbox runtime checkpoint <runtime>`
- the live gateway CLI has no checkpoint surface
- the current gateway source does not expose checkpoint orchestration

Assessment:

The architecture now includes runtime checkpoints, but the implementation has not caught up.

Impact:

- rebuild and recovery remain dependent on ad hoc runtime state handling
- the mutable-runtime model lacks its intended baseline-reset mechanism

### F-4. Runtime checkpoint and backup storage is not present yet

Severity: `medium`

Observed:

- the updated V2 baseline reserves `/srv/moltbox-state/runtime-baselines/`
- that directory is absent on the live appliance

Assessment:

The backup and checkpoint storage model has been defined architecturally but is not yet materialized operationally.

Impact:

- checkpoint creation cannot yet be implemented against a defined storage root
- recovery artifacts are not normalized under the new baseline

### F-5. The host Moltbox operator CLI entrypoint is missing

Severity: `medium`

Observed:

- updated V2 architecture keeps a host CLI entrypoint in scope
- bootstrap code still installs a thin host wrapper that proxies into `gateway`
- the live host does not currently provide `moltbox` on PATH

Assessment:

The host interaction model is architecture-consistent, but the current appliance does not yet satisfy it.

Impact:

- operators must fall back to direct `docker exec gateway ...`
- the intended host operating model is not yet realized

### F-6. Container naming normalization is incomplete

Severity: `medium`

Observed:

- active service definitions use normalized steady-state names
- the live host still runs legacy `moltbox-*` containers
- active gateway runtime code still includes `moltbox-openclaw` as a fallback container candidate

Assessment:

The baseline naming model is clear, but transitional container naming still leaks into the live system and active code.

Impact:

- runtime targeting is less deterministic
- steady-state topology is harder to reason about
- legacy infrastructure can be mistaken for supported topology

### F-7. The `ollama` service boundary is unresolved

Severity: `medium`

Observed:

- updated V2 naming examples include `ollama`
- OpenClaw runtime service templates point to `http://ollama:11434`
- the live host runs a legacy `moltbox-ollama` container
- `moltbox-services` does not currently define an `ollama` service
- `moltbox service list` does not expose `ollama`

Assessment:

The architecture now clearly prefers normalized naming if `ollama` is part of the appliance, but the actual service model for `ollama` is still unresolved.

Impact:

- OpenClaw runtimes depend on a service that is not currently represented in the canonical service inventory
- steady-state topology remains ambiguous

### F-8. The gateway repository rename transition is incomplete

Severity: `medium`

Observed:

- the target vocabulary is `moltbox-gateway`
- the GitHub repo has been renamed to `moltbox-gateway`
- local workspace and some implementation paths still use `remram-gateway`
- the gateway Docker build still references `https://github.com/remram-ai/remram-gateway.git`
- appliance upstream mirrors still use `/srv/moltbox-state/upstream/remram-gateway`

Assessment:

The vocabulary direction is clear, but build and deployment references have not fully converged on the new repository identity.

Impact:

- bootstrap and build provenance remain harder to track
- repository identity differs across docs, source, and runtime artifacts

### F-9. Historical gateway docs still describe pre-normalization behavior

Severity: `low`

Observed:

- some gateway repo docs still describe `tools`, `host`, and `runtime` era command surfaces
- the updated V2 docs now describe the newer baseline

Assessment:

This is documentation lag, not a core architecture problem.

Impact:

- operator and contributor confusion remains possible

## 4. Conflict Maps

### CM-1. Gateway artifact provenance conflict

Sources involved:

- live gateway container image metadata
- gateway self-report
- rendered gateway compose and render manifest
- gateway deployment state file

Conflict:

- runtime execution artifacts resolve to `de94de7`
- `last-success.json` resolves to `47387a6`

Current authoritative reading:

- the appliance is actually executing `de94de7`
- the deployment-state record is stale or inconsistent

Classification:

- implementation defect

### CM-2. Gateway CLI contract conflict

Sources involved:

- updated `architecture-v2`
- runtime snapshot
- local gateway source
- live gateway CLI help and command behavior

Conflict:

- the current V2 baseline expects repo-oriented gateway commands, runtime-targeted skill deploy, and legacy replacement guidance
- the live gateway artifact exposes the older CLI

Current authoritative reading:

- the updated V2 baseline is the target contract
- the live appliance is running an older artifact

Classification:

- deployment drift

### CM-3. Runtime checkpoint model conflict

Sources involved:

- updated `architecture-v2/runtime.md`
- live gateway CLI
- current gateway source

Conflict:

- the architecture now defines checkpointing as part of the runtime lifecycle model
- the implementation does not yet expose the checkpoint surface or orchestration

Current authoritative reading:

- checkpointing is part of the architecture baseline

Classification:

- implementation gap

### CM-4. Runtime checkpoint storage conflict

Sources involved:

- updated `architecture-v2/runtime.md`
- live appliance filesystem

Conflict:

- the baseline defines `/srv/moltbox-state/runtime-baselines/`
- the live appliance does not currently have that storage root

Current authoritative reading:

- the storage root is part of the updated architecture

Classification:

- implementation gap

### CM-5. Host operator entrypoint conflict

Sources involved:

- updated `architecture-v2/gateway.md`
- bootstrap implementation
- live appliance host state

Conflict:

- architecture and bootstrap intent include a host `moltbox` entrypoint
- the live host does not currently expose that wrapper

Current authoritative reading:

- host-level operator entrypoint remains part of the intended appliance model

Classification:

- implementation gap

### CM-6. Container naming conflict

Sources involved:

- updated `architecture-v2/gateway.md`
- updated `architecture-v2/services.md`
- active `moltbox-services` service definitions
- active gateway runtime code
- live container inventory

Conflict:

- target naming is unprefixed and stable
- active service definitions mostly align
- live host and one active fallback path still retain legacy `moltbox-*` names

Current authoritative reading:

- unprefixed container names are the steady-state target

Classification:

- transitional drift

### CM-7. `ollama` service topology conflict

Sources involved:

- updated V2 naming examples
- OpenClaw runtime service templates
- live container inventory
- canonical `moltbox-services` service inventory

Conflict:

- runtimes assume an `ollama` endpoint
- live host still uses a legacy `moltbox-ollama` container
- no canonical `ollama` service exists in `moltbox-services`

Current authoritative reading:

- naming convention is clear if `ollama` exists
- the actual steady-state service status of `ollama` remains unresolved

Classification:

- unresolved topology gap

### CM-8. Gateway repository identity conflict

Sources involved:

- current vocabulary and GitHub rename direction
- local workspace naming
- gateway Docker build inputs
- appliance upstream mirror layout

Conflict:

- target naming is `moltbox-gateway`
- implementation and deployment artifacts still reference `remram-gateway` in several places

Current authoritative reading:

- the naming direction is toward `moltbox-gateway`

Classification:

- naming drift

## 5. Architectural Risks

### R-1. Mutable runtime state without checkpoints remains fragile

The updated architecture now explicitly allows mutable OpenClaw runtime state.

Without implemented checkpoints and baseline artifacts, that model increases recovery fragility because the intended replay and reset mechanism does not yet exist operationally.

### R-2. Provenance ambiguity can undermine all later audit work

If deployment metadata is not reliable, later architecture, deployment, and runtime analysis can all be applied to the wrong artifact line.

This is especially risky for gateway self-update and rollback behavior.

### R-3. Transitional infrastructure can become accidental architecture

Legacy containers and fallback container-name paths create a risk that old deployment shapes remain accidentally supported because they continue to exist in live environments.

### R-4. Service topology is still partially implicit

The `ollama` dependency is currently implicit in runtime config rather than explicit in the canonical service inventory.

That makes the topology harder for a new contributor or operator to understand.

### R-5. Repository identity drift can break build and bootstrap assumptions

If repo naming changes land in GitHub, docs, local workspaces, Dockerfiles, and host-side upstream mirrors at different times, provenance and automation become more brittle.

## 6. Decision Trees

### DT-1. Runtime configuration authority

Options considered:

- `A` — treat Git-backed runtime config as the complete authoritative runtime state
- `B` — treat `moltbox-runtime` as baseline configuration and allow OpenClaw-native mutation in live runtime state

Decision:

- adopted `B`

Reasoning:

- OpenClaw plugin and skill installation naturally mutates runtime state
- forcing full sync-back into Git would work against the native runtime model
- rebuild and recovery are better served by baseline plus replay plus checkpoints

### DT-2. Deployment metadata interpretation

Options considered:

- `A` — treat inconsistent deployment metadata as an architecture ambiguity
- `B` — treat the gateway deployment pipeline as the authoritative metadata writer and classify inconsistency as an implementation defect

Decision:

- adopted `B`

Reasoning:

- deployment-state ownership belongs in the control plane
- architecture should not encode inconsistency as acceptable behavior

### DT-3. Runtime rebuild and recovery model

Options considered:

- `A` — rebuild by restoring Git-backed templates only
- `B` — rebuild from baseline config and replay runtime deployment history
- `C` — sync live runtime state back into Git and rebuild from that

Decision:

- adopted `B`

Reasoning:

- it preserves a clean boundary between source repos and operational state
- it matches the mutable-runtime model without requiring Git to track live operational artifacts

### DT-4. Runtime checkpoint storage model

Options considered:

- `A` — checkpoint back into `moltbox-runtime`
- `B` — checkpoint into appliance-state artifacts under `/srv/moltbox-state/runtime-baselines/`

Decision:

- adopted `B`

Reasoning:

- checkpoints are operational recovery artifacts
- they do not belong in source-controlled architecture repositories

### DT-5. Host operator interface

Options considered:

- `A` — operators interact primarily through Docker commands
- `B` — provide a host-level `moltbox` entrypoint that proxies into the gateway control plane

Decision:

- adopted `B`

Reasoning:

- the gateway should remain the operator-facing control surface
- direct Docker control should not become the default operational contract

### DT-6. Container naming convention

Options considered:

- `A` — keep `moltbox-*` prefixed steady-state container names
- `B` — use simple component names because the appliance is already the namespace

Decision:

- adopted `B`

Reasoning:

- shorter names reduce noise
- steady-state topology becomes easier to read
- legacy prefixed names can be treated as transitional drift rather than first-class identity

## 7. Architectural Recommendations

These are architecture-level recommendations only.

They are not yet a refactor sequence.

- keep the updated V2 docs as the source of truth for the mutable-runtime model and stop treating live runtime mutation as an architecture violation
- explicitly define the required deployment metadata schema for every deployment path, including self-update and rollback-related fields
- define the conceptual checkpoint artifact contents and replay-history contract more precisely before implementation begins
- clarify the service-topology status of `ollama` so that runtime dependencies and canonical service inventory align
- keep the host operator model explicit: the CLI is the intended operator surface, even if a thin wrapper proxies into the gateway container
- continue treating legacy `moltbox-*` container names as transitional only, not as accepted steady-state identity
- finish converging repository vocabulary on `moltbox-gateway` across docs, build inputs, and deployment references
- make repository cleanup an explicit workstream: retire or quarantine duplicate CLI implementations, transitional codepaths, legacy container-era assets, and stale documentation trees so the repo exposes one active architecture line
- mark older gateway docs and specs as historical or pre-normalization so they do not compete with the V2 baseline

## 8. Implementation Gaps

The current system does not yet conform to the updated architecture in these areas:

- gateway deployment metadata does not consistently describe the running artifact
- the live gateway artifact does not expose the full current V2 CLI surface
- runtime checkpoint orchestration is not implemented
- runtime checkpoint and backup storage under `/srv/moltbox-state/runtime-baselines/` is absent
- the host `moltbox` wrapper is not present on the appliance
- legacy `moltbox-*` containers are still present on the live host
- active gateway code still contains at least one legacy runtime container fallback
- the service status of `ollama` is not represented in the canonical service inventory
- gateway build and deployment references have not fully converged on the `moltbox-gateway` repo identity

## 9. Architectural Decisions Made During This Review

The following decisions were adopted into the current V2 architecture baseline during this review pass:

1. The gateway deployment pipeline is the authoritative writer of deployment state.
2. Deployment metadata inconsistency is an implementation defect, not an architecture model.
3. OpenClaw runtimes are mutable systems.
4. `moltbox-runtime` represents baseline runtime configuration, not full live runtime state.
5. Gateway may continue to use native OpenClaw plugin and skill installation flows during skill deployment.
6. Runtime state is modeled as baseline configuration plus deployment events and live runtime mutations.
7. Runtime rebuild restores baseline configuration and replays runtime deployment history.
8. Runtime checkpointing is part of the architecture and conceptually exposed through `moltbox runtime checkpoint <runtime>`.
9. Runtime checkpoints and backup artifacts belong under appliance state storage, with `/srv/moltbox-state/runtime-baselines/` as the canonical root.
10. Runtime backups and checkpoints are operational artifacts and must not automatically synchronize back into Git-backed architecture repositories.
11. The appliance host should run minimal host services only.
12. Long-running application logic belongs in containers, not on the host OS.
13. Operators should interact through the Moltbox CLI rather than direct Docker commands.
14. A host-level Moltbox CLI entrypoint remains part of the appliance model, even if implemented as a thin wrapper into the `gateway` container.
15. Steady-state container names should not use the `moltbox-` prefix.
16. Legacy `moltbox-*` container names are transitional drift rather than target identity.
17. The `runtime` namespace may be used for cross-runtime orchestration such as checkpointing without restoring the old `moltbox runtime <env> ...` CLI family.

## 10. Outstanding Questions

- What exact artifact schema should runtime checkpoints use for configuration snapshots, plugin inventory, deployment history, and provenance metadata?
- What retention policy should govern runtime checkpoints and backups under `/srv/moltbox-state/runtime-baselines/`?
- Should deployment replay history be stored per runtime, per service, or through a shared gateway deployment-event ledger?
- What additional CLI surfaces should accompany checkpointing, such as list, inspect, restore, or prune?
- Is `ollama` intended to be a first-class service in `moltbox-services`, an optional shared service, or an external dependency outside the canonical service inventory?
- How should existing appliances transition from `remram-gateway` references to `moltbox-gateway` without breaking bootstrap, build, or provenance tooling?
- What minimum deployment metadata fields are required so that rendered artifacts, running containers, and service-state files always reconcile to the same artifact identity?
- Which historical gateway docs should remain as archived reference material versus being actively retired from the main documentation path?
