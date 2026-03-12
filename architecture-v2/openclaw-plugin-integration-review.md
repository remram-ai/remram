# OpenClaw Plugin Integration Review

This note is an analysis input for the upcoming architecture review.

It does not change the current `architecture-v2` baseline.

Current baseline remains:

- skills live in `remram-skills`
- runtime configuration lives in `moltbox-runtime`
- gateway remains the orchestration/control plane

The question here is whether recent OpenClaw plugin and extension changes reduce the amount of custom deployment and integration logic we need around that baseline.

## Summary of Relevant OpenClaw Changes

### Latest release: `openclaw 2026.3.11` (`2026-03-12`)

The latest stable release does not appear to introduce major new plugin primitives in its release notes.

Its most relevant change for integration is indirect:

- stronger browser-origin validation for gateway connections

That matters for plugin-exposed HTTP or control-plane surfaces, but it does not by itself change the RemRam/Moltbox architecture.

### Recent releases with direct extensibility impact

#### `openclaw 2026.3.7` (`2026-03-08`)

This is the most important recent release for architecture.

OpenClaw added a `ContextEngine` plugin slot with lifecycle hooks for:

- `bootstrap`
- `ingest`
- `assemble`
- `compact`
- `afterTurn`
- `prepareSubagentSpawn`
- `onSubagentEnded`

It also added:

- slot-based registry with config-driven resolution
- `LegacyContextEngine` compatibility wrapping
- scoped plugin runtime support via `AsyncLocalStorage`
- `sessions.get` gateway method

Architecturally, this is significant because OpenClaw can now host alternate context-management behavior as a plugin-selected runtime concern instead of requiring core patches or sidecar logic.

#### `openclaw 2026.3.2` (`2026-03-03`)

This release materially improved plugin runtime integration:

- plugins can access shared channel runtime helpers through `channelRuntime`
- plugins can call `api.runtime.stt.transcribeAudioFile(...)`
- plugins can call `runtime.system.requestHeartbeatNow(...)`
- plugins can subscribe to runtime event streams such as agent events and transcript updates
- plugin hook lifecycle now includes `sessionKey` for `session_start` and `session_end`
- `openclaw config validate` was added for pre-start config validation

It also tightened the plugin API:

- `api.registerHttpHandler(...)` was removed
- plugins must use explicit `api.registerHttpRoute({ path, auth, match, handler })`
- plugin routes now require explicit auth decisions

This is a move away from loose extension wiring and toward explicit, typed, policy-aware extension boundaries.

#### `openclaw 2026.2.26` (`2026-02-27`)

OpenClaw added plugin-owned onboarding hooks:

- `configureInteractive`
- `configureWhenConfigured`

That is relevant because some setup flows that we might otherwise model as separate gateway-side orchestration or manual runtime patching can now live inside the plugin lifecycle itself.

### Current plugin platform capabilities from OpenClaw docs

OpenClaw now documents plugins as runtime-loaded TypeScript modules that can register:

- gateway RPC methods
- gateway HTTP routes
- agent tools
- CLI commands
- background services
- context engines
- optional config validation
- auto-reply commands
- skills directories exposed through the plugin manifest

Plugins can also:

- expose config schema and UI hints for Control UI rendering
- register hooks with `api.registerHook(...)`
- participate in typed runtime lifecycle hooks with `api.on(...)`
- use prompt-injection controls such as `plugins.entries.<id>.hooks.allowPromptInjection`
- be installed, updated, enabled, disabled, and inspected through first-class `openclaw plugins ...` commands

## Comparison With Our Current Architecture

### `remram-skills`

The current `architecture-v2` model already says that reusable skill implementations live in `remram-skills`.

The new OpenClaw plugin model mostly reinforces that decision.

`remram-skills` is now a natural home for:

- plugin-backed skills
- OpenClaw plugin packages
- plugin manifests
- plugin-local code and helper modules
- plugin deploy metadata

This is already visible in the current `semantic-router` package, which is implemented as an OpenClaw plugin-backed skill.

### `moltbox-runtime`

The runtime repo should still own declarative runtime behavior, including:

- which plugins are enabled
- plugin config under runtime templates
- plugin slot selection such as `plugins.slots.contextEngine`
- environment-specific plugin wiring

The plugin model does not remove the need for `moltbox-runtime`.

Instead, it gives runtime configuration a stronger native target:

- declare plugin activation in runtime config
- declare plugin settings in runtime config
- declare slot selection in runtime config

That is cleaner than encoding too much plugin behavior in gateway-side imperative logic.

### Gateway orchestration

Gateway still needs to exist as the control plane.

The plugin model does not replace:

- repository adapters
- Git-backed deployment
- runtime sync
- service deployment
- environment targeting
- rollback and diagnostics

But it may let gateway orchestration become thinner and more declarative.

Instead of custom per-capability wiring, gateway can focus on:

- making the plugin package available to the runtime
- syncing runtime config
- validating config before restart
- triggering the correct lifecycle operation

## Potential Architectural Simplifications

### 1. Reduce custom skill-deploy behavior

Today, skill deployment is easy to drift into a special-case path because skill code, runtime config, and runtime mutation all meet at once.

OpenClaw's plugin lifecycle suggests a cleaner split:

- `remram-skills` provides the plugin package
- `moltbox-runtime` provides plugin activation and config
- gateway installs or updates the package, validates config, and reloads runtime

That would reduce pressure to embed plugin-specific behavior inside gateway code.

### 2. Replace ad hoc executable-extension patterns with native plugins

If a capability primarily needs:

- runtime code
- access to OpenClaw session/context state
- route registration
- hooks
- internal provider endpoints

then an OpenClaw plugin is likely cleaner than inventing a separate extension mechanism around the runtime.

### 3. Use ContextEngine plugins instead of custom context-pipeline overlays where appropriate

The new `ContextEngine` slot is the clearest simplification opportunity.

If RemRam wants alternate context assembly, compaction, or subagent context behavior inside OpenClaw, that now has a native extension surface.

That could eliminate some custom layering pressure around:

- prompt assembly overrides
- compaction intervention
- session-context side logic

This does not replace Cortex or durable memory architecture.

It only reduces the need to customize OpenClaw internals when the desired behavior is still fundamentally runtime-context orchestration.

### 4. Fold some gateway-side setup into plugin-owned onboarding/config flows

Plugin-owned onboarding hooks may reduce the need for separate bootstrap glue for capabilities that mainly need:

- plugin-local auth
- plugin-local config scaffolding
- guided interactive setup

Gateway would still orchestrate the appliance, but fewer capability-specific setup rules may need to live there.

### 5. Prefer declarative config validation over runtime trial-and-error

`openclaw config validate` is especially useful for Moltbox.

A better future path is:

1. sync runtime config
2. validate config
3. reload/restart only if validation passes

That is cleaner than discovering plugin/runtime incompatibilities only after a restart.

## Integration Opportunities

### Plugin-backed skills as the default advanced-skill pattern

For skills that need executable runtime behavior, the best fit now appears to be:

- code package in `remram-skills`
- installable as an OpenClaw plugin
- enabled/configured through `moltbox-runtime`
- deployed by gateway orchestration

This preserves repository boundaries while using OpenClaw's native extensibility model.

### Runtime-selected plugin slots

`moltbox-runtime` can remain the owner of environment-specific choices such as:

- whether a plugin is enabled in `dev`, `test`, or `prod`
- which plugin instance is selected for `plugins.slots.contextEngine`
- which providers/routes/config overlays point at plugin endpoints

That is consistent with the existing architecture-v2 rule that runtime wiring belongs in `moltbox-runtime`.

### Gateway-managed package installation and version pinning

Gateway can treat plugin packages similarly to other deployment inputs:

- resolve the package from `remram-skills`
- install or link it into the target OpenClaw runtime
- sync config from `moltbox-runtime`
- validate config
- reload runtime

The gateway remains the orchestrator, but the behavior being orchestrated becomes more native to OpenClaw.

### Internal provider and HTTP route patterns

The semantic-router pattern is especially promising.

OpenClaw plugins can expose authenticated HTTP routes and runtime-owned logic, which means some behaviors that previously looked like external sidecars may fit better as runtime-local plugin services.

That can simplify network topology when the capability does not need an independent container lifecycle.

## Open Questions

### 1. What is the correct deployment contract for plugin packages on a Linux appliance?

OpenClaw's plugin docs assume install/update flows inside the runtime, often under `~/.openclaw/extensions`.

We need to decide how that maps onto the Moltbox machine-scoped appliance layout under `/srv/moltbox-state/runtime/`.

### 2. Should gateway install plugins by local path, packaged artifact, or npm-style identifier?

For RemRam-owned plugins, the architecture currently prefers Git-backed host-side deployment.

We need to choose whether the canonical gateway behavior should:

- install from a checked-out `remram-skills` path
- package plugins during deployment and install artifacts
- rely on npm-oriented plugin install/update flows

### 3. How declarative can plugin installation become?

The clean target would be:

- package source in `remram-skills`
- activation/config in `moltbox-runtime`
- no hand-edited runtime mutation

We should verify how much install state OpenClaw keeps outside plain config and whether gateway needs to manage that state explicitly.

### 4. How far should we push `ContextEngine` for RemRam-specific memory behavior?

The new slot is powerful, but it should not collapse the boundary between:

- OpenClaw runtime context management
- Cortex durable memory architecture

We should use `ContextEngine` where the concern is runtime prompt/context assembly, not as a shortcut for moving Cortex responsibilities into OpenClaw.

### 5. Do plugin background services or gateway methods risk blurring repo boundaries?

OpenClaw plugins can now host more behavior in-process.

That is useful, but we should avoid letting plugin code become an accidental replacement for:

- gateway control-plane logic
- service topology definitions
- appliance-level operations

### 6. What compatibility policy do we need for plugin SDK changes?

Recent releases changed the plugin API shape in meaningful ways, including the move from `registerHttpHandler` to `registerHttpRoute`.

If RemRam depends heavily on plugin-backed skills, we need an explicit OpenClaw version floor and upgrade-validation discipline.

## Provisional Architectural Reading

At the moment, these OpenClaw changes do not justify rewriting `architecture-v2`.

They do suggest a likely future refinement:

- keep repository boundaries exactly as they are
- lean harder on native OpenClaw plugins for executable runtime behavior
- keep runtime activation/config in `moltbox-runtime`
- keep package code in `remram-skills`
- keep gateway focused on deterministic deployment, validation, and lifecycle orchestration

The biggest potential future revision is not a boundary change.

It is a simplification change:

- fewer custom runtime-extension patterns
- fewer skill-specific gateway mutations
- more declarative plugin installation + runtime config + reload flows

## Sources

- OpenClaw releases: <https://github.com/openclaw/openclaw/releases>
- OpenClaw plugin docs: <https://docs.openclaw.ai/tools/plugin>
- OpenClaw hooks docs: <https://docs.openclaw.ai/automation/hooks>
