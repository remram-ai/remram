# Repository Authority Rules

This document records the current repository-boundary rules for the Remram ecosystem.

Use it when deciding where a new artifact, document, config file, service definition, or capability package should live.

## Core Rule

Artifacts should live in the repo that owns the thing itself.

Do not make `remram` or `moltbox-gateway` the long-term home for artifacts they do not own just because those repos are convenient.

## Current Authority Split

### `remram`

Owns:

- ecosystem framing
- approved feature records
- platform registry material
- cross-repo architecture summaries
- pointers to the owning implementation repos

Does not own:

- live Moltbox appliance contract
- service definitions
- service config as an artifact
- skill or plugin source
- service- or runtime-specific operator procedures

### `moltbox-gateway`

Owns:

- the `moltbox` CLI
- operator workflows and procedures
- verification surfaces
- Gateway/OpenClaw operating model for the appliance
- recovery workflow and snapshot/restore procedures
- live appliance service-plane behavior

Does not own:

- service definitions as source artifacts
- service-specific baseline config as long-term authority
- skill or plugin source artifacts

### `remram-skills`

Owns:

- reusable skills
- plugin packages
- skill/plugin documentation

Rule:

- if the thing being versioned is a reusable skill or plugin, it belongs here

### Service Artifact Authority

Current service artifact authority:

- `moltbox-services`

Directional naming preference:

- `remram-services`

The service repo should own:

- service definitions
- service-level docs
- baseline service config examples
- OpenClaw baseline config for `test` and `prod`
- workspace or instruction-pack artifacts that are part of the OpenClaw service baseline
- service validation docs

Important rule:

- OpenClaw is a service in this appliance
- if a config exists because `openclaw-test` or `openclaw-prod` must run, that config is service config

### `moltbox-runtime`

Current role:

- final deployable runtime artifacts used by the current release path
- optional private or base-specific runtime overlays, if needed

Examples:

- `moltbox-runtime` for private Moltbox-only overlays
- `elderclaw-runtime` for private Elderclaw-only overlays

It is not the primary authority for baseline service definitions or baseline config examples.

## Practical Placement Rules

Use these defaults:

- live CLI behavior or operator procedure:
  - `moltbox-gateway`
- service definition, compose/service yaml, thin wrapper Dockerfile, baseline service config, or service docs:
  - `moltbox-services`
- OpenClaw `test` / `prod` baseline config that exists to run those services:
  - `moltbox-services`
- final deployable runtime bundle or private overlay:
  - `moltbox-runtime`
- reusable skill or plugin package:
  - `remram-skills`
- ecosystem summary, feature intent, platform map, repo-boundary explanation:
  - `remram`

## Documentation Rule

Detailed docs should live with the artifact they describe.

That means:

- service docs live with services
- skill/plugin docs live with skills/plugins
- CLI and operator docs live with Gateway
- `moltbox-runtime` docs explain the final deployable runtime layer
- `remram` keeps overview docs and pointers, not competing detailed copies

## Transitional Note

The current private repos use the names:

- `moltbox-services`
- `moltbox-runtime`

The current split is:

- `moltbox-services` for service-owned baseline inputs
- `moltbox-runtime` for final deployable runtime artifacts

## Decision Shortcut

When deciding where something should go, ask:

1. Is this an operator workflow or CLI surface?
   - put it in `moltbox-gateway`
2. Is this required to define a service baseline?
   - put it in `moltbox-services`
3. Is this a final deployable runtime artifact or private overlay?
   - put it in `moltbox-runtime`
4. Is this a reusable skill or plugin?
   - put it in `remram-skills`
5. Is this ecosystem framing or a pointer to the owner?
   - put it in `remram`
