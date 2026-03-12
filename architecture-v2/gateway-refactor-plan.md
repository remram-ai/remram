# Gateway Refactor Plan V2

This plan updates the earlier CLI refactor so it matches the finalized repository taxonomy and component-oriented CLI model.

## Phase 1. Preserve the target architecture in docs

Create and maintain the `architecture-v2/` reference set in `remram`.

Do not rewrite the existing architecture documents yet.

Also create `features/README.md` so product capabilities have a stable home outside the gateway repository.

## Phase 2. Reframe the gateway CLI

In `remram-gateway`, replace the old domain split with:

- `gateway`
- `service`
- component-specific namespaces such as `openclaw`, `openclaw-dev`, `openclaw-test`, `caddy`, and `opensearch`
- `skill` for orchestration wrappers

Compatibility aliases may exist during migration, but the target model is component-oriented.

## Phase 3. Add external repository adapters

Gateway implementation should treat these as external sources:

- `moltbox-services`
- `moltbox-runtime`
- `remram-skills` for skill deployment inputs when needed

Required gateway adapter behavior:

- locate configured checkout paths or remote sync roots
- read service definitions from `moltbox-services`
- read runtime configuration from `moltbox-runtime`
- keep deployment logic independent from feature-document names

## Phase 4. Refactor deployment paths

Implement three separate control-plane paths:

- gateway self-update
- generic service deployment
- runtime config sync and reload

This prevents self-management, service lifecycle, and runtime wiring from collapsing into one command model.

## Phase 5. Add environment-aware service identity

The gateway must treat service identity as first-class.

Examples:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- alias: `openclaw`

This affects:

- command parsing
- service definition lookup
- runtime config lookup
- artifact promotion
- rollback targeting

## Phase 6. Add skill deployment orchestration

`moltbox skill deploy <skill>` should resolve the underlying actions required by the named skill.

That may include:

- service deploys
- runtime config sync
- runtime reload

The skill command is intentionally orchestration-oriented and should not force operators to know the lower-level sequence.

## Phase 7. Update tests and implementation docs

Required test areas:

- parser and alias resolution
- service-definition lookup
- runtime-config lookup
- deployment lifecycle
- reload flows
- artifact override precedence
- skill orchestration resolution

Implementation-facing docs in `remram-gateway` should be updated after the new `architecture-v2/` reference set exists, but older architecture docs should remain in place until the refactor is complete.
