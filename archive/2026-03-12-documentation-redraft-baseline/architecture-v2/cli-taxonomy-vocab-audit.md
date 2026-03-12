# CLI Taxonomy and Vocabulary Audit

This document is a review artifact.

It records the second-pass CLI taxonomy and vocabulary audit for the Moltbox V2 architecture review.

It is not the final CLI specification and it is not a refactor plan.

## 1. Scope and Baseline

This audit evaluates:

- CLI grammar
- command taxonomy
- canonical component names
- legacy namespace handling
- architecture vocabulary as it appears in commands, docs, and source

Source precedence for this audit:

- `architecture-v2` is authoritative for CLI and control-plane behavior
- the taxonomy document remains useful for repository boundaries and conceptual vocabulary
- when the taxonomy document shows older CLI examples, those examples are treated as historical rather than authoritative

The current V2 CLI baseline is:

```text
moltbox <component> <command>
```

The current V2 vocabulary baseline is:

- `Feature` = product-level capability definition in `remram`
- `Skill` = portable capability package in `remram-skills`
- `Service` = containerized appliance process in `moltbox-services`
- `Runtime` = baseline runtime configuration plus runtime lifecycle/orchestration concerns
- `Gateway` = the appliance control plane

## 2. Canonical CLI Taxonomy

Under the updated V2 baseline, the canonical command taxonomy is:

| Namespace | Meaning | Status |
| --- | --- | --- |
| `gateway` | control-plane operations and gateway self-management | canonical |
| `gateway repo` | gateway-managed host-side repo refresh and seeding | canonical |
| `service` | generic service deployment and lifecycle pipeline | canonical |
| `skill` | skill deployment orchestration pipeline | canonical |
| `openclaw` | alias for `openclaw-prod` | canonical |
| `openclaw-dev` | runtime component namespace | canonical |
| `openclaw-test` | runtime component namespace | canonical |
| `openclaw-prod` | runtime component namespace | canonical |
| `caddy` | component namespace | canonical |
| `opensearch` | component namespace | canonical |
| `runtime` | cross-runtime orchestration namespace for checkpointing and similar operations | canonical but not yet implemented |
| `tools` | historical control-plane namespace | legacy only |
| `host` | historical host-service namespace | legacy only |
| `runtime <env>` | historical environment namespace | legacy only |

Important normalization rule:

- the new `runtime` orchestration namespace does not restore the old `moltbox runtime <env> ...` CLI family

## 3. Canonical Vocabulary Audit

| Term | Canonical meaning | Repository owner | CLI implication |
| --- | --- | --- | --- |
| `Feature` | product-level capability definition | `remram` | not a CLI namespace |
| `Skill` | portable capability package and deploy recipe | `remram-skills` | exposed through `skill deploy` |
| `Service` | containerized process on the appliance | `moltbox-services` | exposed through `service <verb> <service>` |
| `Runtime` | baseline runtime config and runtime lifecycle/orchestration scope | `moltbox-runtime` plus gateway lifecycle orchestration | exposed through runtime component names and future runtime orchestration commands |
| `Gateway` | appliance control plane | `moltbox-gateway` | exposed through `gateway <verb>` |

Audit conclusion:

- the V2 vocabulary itself is coherent
- the main vocabulary drift is not conceptual
- the drift is concentrated in old CLI nouns such as `tools`, `host`, and `runtime dev`

## 4. Evidence Summary

Evidence sources used in this audit:

- updated `architecture-v2` docs
- `architecture-v2/moltbox-runtime-snapshot.md`
- `architecture-v2/repo_taxonomy_latest_spec_before_refactor.md`
- local gateway CLI source in `remram-gateway/cli/src/moltbox_cli/cli.py`
- legacy packageable CLI source in `remram-gateway/moltbox-cli/tools/src/moltbox_cli/cli.py`
- root package metadata in `remram-gateway/pyproject.toml`
- legacy package metadata in `remram-gateway/moltbox-cli/pyproject.toml`
- gateway operator docs in `remram-gateway/docs/operator/`
- older gateway specs and architecture notes in `remram-gateway/docs/specs/` and `remram-gateway/docs/architecture/`
- live gateway CLI help and direct read-only command probes on the appliance

High-signal observations:

- updated V2 docs use `moltbox <component> <command>` consistently
- the taxonomy document still includes old examples such as `moltbox runtime dev deploy`, `moltbox host ssl status`, and `moltbox tools health`
- local gateway source implements the new component-oriented CLI and explicit legacy replacement guidance
- the gateway repo still contains a separately packageable legacy `moltbox-cli` project that also exports a `moltbox` console script
- the legacy `moltbox-cli` package is partially component-oriented, but it lacks the full current V2 surface such as `gateway repo`, runtime-targeted `skill deploy`, and explicit legacy namespace replacement guidance
- current operator CLI docs also describe the new component-oriented CLI
- many older gateway specs still describe `tools`, `host`, and `runtime` as the primary CLI taxonomy
- the live appliance is still running an older gateway artifact that does not match the current local CLI source
- the live appliance behavior matches the legacy packageable `moltbox-cli` implementation more closely than the current root CLI implementation

## 4.1 CLI Implementation Strata

There are currently three distinct CLI strata in the gateway repository history and layout:

### Stratum A. Historical `tools` / `host` / `runtime` model

This stratum is still present in:

- older specs
- older architecture notes
- the taxonomy document's CLI examples
- the `moltbox-cli/host/` and `moltbox-cli/runtime/` command trees

This is no longer the canonical CLI taxonomy.

### Stratum B. Legacy packageable `moltbox-cli` implementation

This stratum is still present as a separately packageable project:

- `remram-gateway/moltbox-cli/pyproject.toml`
- `remram-gateway/moltbox-cli/tools/src/moltbox_cli/cli.py`

Important properties:

- it exports a `moltbox` console script
- it uses top-level nouns such as `gateway`, `service`, `skill`, and `openclaw-*`
- it does not implement the full current V2 surface
- it does not implement the current legacy replacement guidance

This appears to be the closest source match to the currently deployed appliance behavior.

### Stratum C. Current root gateway CLI implementation

This is the current source-of-truth implementation in the active gateway package:

- `remram-gateway/pyproject.toml`
- `remram-gateway/cli/src/moltbox_cli/cli.py`

Important properties:

- it also exports a `moltbox` console script
- it implements `gateway repo refresh` and `gateway repo seed`
- it implements runtime-targeted `skill deploy`
- it implements explicit legacy replacement guidance for `tools`, `host`, and `runtime`

Audit implication:

- the repository still contains two installable `moltbox` entrypoint providers
- any CLI audit must distinguish the current root CLI from the legacy packageable CLI
- the live appliance cannot be assumed to reflect the newest source just because both implementations use the same console command name

## 5. Command Surface Matrix

| Surface | Updated V2 docs | Taxonomy doc | Local gateway source | Live gateway artifact | Audit result |
| --- | --- | --- | --- | --- | --- |
| `moltbox gateway <verb>` | yes | no | yes | yes | canonical and implemented |
| `moltbox gateway repo refresh` | yes | no | yes | no | canonical target, deployed drift |
| `moltbox gateway repo seed` | yes | no | yes | no | canonical target, deployed drift |
| `moltbox service <verb> <service>` | yes | not primary | yes | yes | canonical and implemented |
| `moltbox openclaw-dev|test|prod <verb>` | yes | no | yes | yes | canonical and implemented |
| `moltbox openclaw` alias | yes | no | yes | yes | canonical and implemented |
| `moltbox skill deploy <skill>` | yes | partly implicit | yes | yes | canonical and implemented |
| `moltbox skill deploy <skill> --runtime <runtime>` | yes | no | yes | no | canonical target, deployed drift |
| `moltbox <runtime> skill deploy <skill>` | yes | no | yes | no | canonical target, deployed drift |
| `moltbox runtime checkpoint <runtime>` | yes | no | no | no | canonical target, not implemented |
| `moltbox tools <verb>` | no | yes | rejected with replacement guidance | still accepted as old behavior | legacy taxonomy still leaking into deployment |
| `moltbox host <service> <verb>` | no | yes | rejected with replacement guidance | rejected without replacement guidance | legacy taxonomy retired in baseline, not cleanly handled in deployment |
| `moltbox runtime <env> <verb>` | no | yes | rejected with replacement guidance | rejected without replacement guidance | legacy taxonomy retired in baseline, not cleanly handled in deployment |

Live command probes:

- `moltbox tools status` still executes and resolves `tools` as a service-like component
- `moltbox gateway repo refresh runtime` fails because the live `gateway` verb set does not include `repo`
- `moltbox skill deploy semantic-router --runtime openclaw-test` fails because the live parser does not support `--runtime`
- `moltbox openclaw-test skill deploy semantic-router` fails because the live runtime component parser does not support nested `skill deploy`
- `moltbox host ssl status` and `moltbox runtime dev reload` both fail, but the live appliance does not provide the newer replacement guidance implemented in local source

Packaging and source-path probes:

- `remram-gateway/pyproject.toml` exports `moltbox = "moltbox_cli.__main__:main"` from the active root package search paths
- `remram-gateway/moltbox-cli/pyproject.toml` also exports `moltbox = "moltbox_cli.__main__:main"` from `moltbox-cli/tools/src`
- `remram-gateway/moltbox-cli/tools/src/moltbox_cli/cli.py` implements a transitional component-oriented CLI that is closer to the live appliance than the current root CLI

## 6. Vocabulary Drift Audit

### 6.1 `gateway` versus `tools`

Current V2 meaning:

- the control plane is `gateway`

Drift:

- the taxonomy doc still describes `tools` as the control-plane service
- older gateway specs still center `tools` as the remote control surface
- the live artifact still accepts `tools` in at least one path

Audit result:

- `tools` is no longer a valid taxonomy noun for the canonical control plane
- it should be treated as historical vocabulary only

### 6.2 `service` versus `host <service>`

Current V2 meaning:

- appliance services are operated through the `service` deployment pipeline or by direct component namespace

Drift:

- the taxonomy doc and many older specs still use `host ssl`, `host ollama`, and similar phrases

Audit result:

- `host <service>` is not part of the canonical CLI taxonomy
- `service` is the correct generic operational noun

### 6.3 Runtime components versus `runtime <env>`

Current V2 meaning:

- runtime environments are represented as component names such as `openclaw-dev`, `openclaw-test`, and `openclaw-prod`

Drift:

- the taxonomy doc and older docs still model runtime environments as `runtime dev`, `runtime test`, and `runtime prod`

Audit result:

- environment-specific runtime commands should use runtime component names, not `runtime <env>`

### 6.4 `runtime` as a noun is now overloaded

Current V2 meaning:

- `runtime` refers to a repository and lifecycle concept
- runtime components are addressed through `openclaw-*`
- `runtime` may also become a narrow orchestration namespace for checkpoint operations

Risk:

- this can be confused with the retired `runtime <env>` family if not documented carefully

Audit result:

- the architecture needs explicit wording that `runtime checkpoint` is a new orchestration surface, not a reintroduction of the old CLI family

### 6.5 `skill` is now stable as an orchestration noun

Current V2 meaning:

- `skill deploy` is a first-class orchestration pipeline

Observation:

- this is consistent across updated V2 docs, local source, and operator docs
- the live appliance only supports the simplest `skill deploy <skill>` form, not the fuller runtime-targeted forms

Audit result:

- the vocabulary is correct
- deployment has not yet caught up to the full command model

## 7. Findings

### CTV-1. The CLI control-plane noun is still split between `gateway` and `tools`

Severity: `high`

Observed:

- V2 architecture and local source treat `gateway` as canonical
- taxonomy and many older specs still treat `tools` as the control-plane noun
- the live gateway artifact still accepts `moltbox tools status`

Why it matters:

- contributors and operators can form different mental models of what the control plane is
- the old noun still leaks into actual behavior

### CTV-2. The taxonomy document is not safe to use as a CLI source of truth

Severity: `high`

Observed:

- it still includes `moltbox runtime dev deploy`
- it still includes `moltbox host ssl status`
- it still includes `moltbox tools health`
- it still describes the tools container as the update surface

Why it matters:

- the taxonomy doc remains useful for repository boundaries and vocabulary
- it is no longer reliable for CLI behavior

### CTV-3. The live gateway artifact does not implement the full current V2 command taxonomy

Severity: `high`

Observed:

- no `gateway repo`
- no runtime-targeted `skill deploy`
- no runtime-scoped `skill deploy`
- no legacy replacement guidance

Why it matters:

- the deployed appliance does not currently satisfy the documented CLI contract

### CTV-4. The gateway repo still contains two installable `moltbox` CLI implementations

Severity: `high`

Observed:

- the root gateway package exports a `moltbox` console script from the current CLI implementation
- the legacy `moltbox-cli` project also exports a `moltbox` console script
- the legacy package exposes a transitional command surface that is closer to the live appliance than the current root CLI

Why it matters:

- source inspection can easily pick up the wrong CLI implementation if packaging boundaries are ignored
- deployed behavior can be misclassified unless the artifact lineage is traced carefully
- the repo currently contains multiple command-taxonomy generations under the same executable name

### CTV-5. Legacy namespace retirement is incomplete

Severity: `medium`

Observed:

- local source correctly rejects `tools`, `host`, and `runtime` with replacement guidance
- the live artifact still accepts `tools` and rejects `host` and `runtime` without the new replacement guidance

Why it matters:

- the intended migration path is only partially implemented in the deployed system

### CTV-6. The new checkpoint namespace is conceptually correct but not operationally available

Severity: `medium`

Observed:

- updated V2 baseline now includes `moltbox runtime checkpoint <runtime>`
- local source and live artifact do not yet implement it

Why it matters:

- the audit vocabulary is ahead of the implementation
- this needs careful documentation so it does not look like a rollback to the old `runtime <env>` CLI model

### CTV-7. Historical docs still compete with the V2 command taxonomy

Severity: `medium`

Observed:

- updated operator docs are aligned with V2
- many older specs and architecture notes still present the pre-normalization taxonomy as if it were active

Why it matters:

- a new contributor can still land on the wrong command model first

### CTV-8. `openclaw` alias behavior is one of the few fully aligned CLI elements

Severity: `low`

Observed:

- V2 docs, local source, and live help all agree that `openclaw` aliases `openclaw-prod`

Why it matters:

- this is a stable piece of CLI vocabulary that should be preserved

## 8. CLI Conflict Map

### CLI-CM-1. Control-plane noun conflict

Sources:

- updated V2 docs
- taxonomy doc
- local gateway source
- live gateway CLI

Conflict:

- `gateway` is canonical in V2
- `tools` is still present in taxonomy, stale docs, and live behavior

Authoritative source:

- updated V2 docs and local source

Classification:

- vocabulary drift plus deployment drift

### CLI-CM-2. Legacy namespace handling conflict

Sources:

- local gateway source
- legacy packageable CLI source
- live gateway CLI

Conflict:

- local source rejects `tools`, `host`, and `runtime` with explicit replacement guidance
- live gateway artifact does not provide that behavior consistently

Authoritative source:

- local source and updated operator docs

Classification:

- deployed behavior drift

### CLI-CM-3. Duplicate CLI implementation conflict

Sources:

- root gateway package metadata and source
- legacy `moltbox-cli` package metadata and source
- live gateway CLI

Conflict:

- the repo contains two installable `moltbox` console-script providers
- the current root CLI is the V2-complete implementation
- the live appliance behavior is closer to the legacy packageable CLI

Authoritative source:

- updated V2 docs plus the current root gateway CLI implementation

Classification:

- source-layout drift and deployment drift

### CLI-CM-4. Runtime-targeted skill deployment conflict

Sources:

- updated V2 docs
- local gateway source
- live gateway CLI

Conflict:

- target model includes `skill deploy --runtime` and `<runtime> skill deploy`
- live gateway artifact supports neither

Authoritative source:

- updated V2 docs and local gateway source

Classification:

- deployed behavior drift

### CLI-CM-5. Runtime namespace conflict

Sources:

- updated V2 docs
- taxonomy doc
- stale gateway docs

Conflict:

- V2 reserves `runtime` for a narrow orchestration role such as checkpointing
- historical docs use `runtime <env>` as the main runtime command family

Authoritative source:

- updated V2 docs

Classification:

- taxonomy drift and historical documentation lag

### CLI-CM-6. CLI source-of-truth conflict

Sources:

- updated `architecture-v2`
- taxonomy doc
- current operator docs
- historical specs
- live gateway CLI

Conflict:

- multiple documents still present different command taxonomies

Authoritative source:

- updated `architecture-v2` for behavior
- taxonomy doc for repository vocabulary only

Classification:

- documentation hierarchy drift

## 9. Recommendations

These are audit recommendations, not a refactor sequence.

- keep `gateway` as the only canonical control-plane noun
- keep `service` as the only generic service-operation noun
- keep runtime environments addressed through component names such as `openclaw-dev`
- reserve `runtime` only for cross-runtime orchestration commands such as checkpointing
- treat `tools`, `host`, and `runtime <env>` as historical-only vocabulary
- treat the root gateway package as the current CLI source of truth and the `moltbox-cli` package as legacy implementation residue unless explicitly proven otherwise
- make repo cleanup a first-class recommendation: converge on one installable `moltbox` CLI provider, quarantine or remove legacy `moltbox-cli` implementation trees, and archive stale CLI specs so taxonomy drift does not remain buildable
- explicitly state in docs that the taxonomy document is not authoritative for CLI behavior
- preserve `openclaw == openclaw-prod` because it is already stable across docs, source, and live behavior
- make legacy replacement guidance part of the operator contract, not just a parser nicety
- mark older gateway specs and architecture notes as historical so they stop competing with the V2 CLI model

## 10. Open Questions

- Should `runtime checkpoint <runtime>` remain the final checkpoint surface, or should checkpointing live under a different orchestration noun to avoid confusion with the historical `runtime <env>` model?
- Do we want any compatibility aliases to remain intentionally supported on the host wrapper, or should all legacy namespaces become hard failures with replacement guidance?
- Should the CLI contract explicitly distinguish between deployment pipelines such as `service` and orchestration pipelines such as `skill` and `runtime`?
- Should the legacy packageable `moltbox-cli` project remain in the repo as archival material, or should the repo converge on a single installable `moltbox` provider?
- Once the gateway repo rename is complete, should the CLI/operator docs refer only to `moltbox-gateway`, or should compatibility naming be documented for a transition period?
