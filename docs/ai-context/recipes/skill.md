# Skill Recipe

Use this recipe when the feature is primarily a portable RemRam capability bundle deployed into a runtime.

## Use This Type When

- the capability should be reusable across environments or future runtimes
- the feature needs more than one local implementation surface
- the package combines plugin-backed behavior with runtime policy, manifests, helper modules, prompts, or deploy recipe material
- the feature is best described as a portable capability rather than as one container or one gateway command

Current repo examples:

- `together-escalation [skill]`
- `discord-channel [skill]`

## Do Not Use This Type When

- the feature is just a single runtime extension and the plugin boundary is the main thing that matters
- the feature needs a dedicated appliance container with its own lifecycle
- the feature changes gateway or CLI ownership rather than runtime capability

In those cases, use [Plugin](plugin.md), [Service](service.md), or [Gateway/Core](gateway-core.md).

## Ownership Model

Local ownership usually splits like this:

- `remram`: feature docs and capability contract
- `remram-skills`: skill package source, packaging metadata, manifests, helpers, and plugin-backed code
- `moltbox-runtime`: baseline config and policy files the skill depends on
- `moltbox-gateway`: runtime deployment orchestration, snapshots, and deployment-event tracking

In the current architecture, a skill may be plugin-backed, but the skill is the broader RemRam packaging unit.

## OpenClaw Source Of Record

Check the current upstream docs before implementation:

- [Skills](https://docs.openclaw.ai/tools/skills)
- [Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
- [Skills Config](https://docs.openclaw.ai/tools/skills-config)
- [ClawHub](https://docs.openclaw.ai/tools/clawhub)
- [Configuration](https://docs.openclaw.ai/configuration)

If the skill affects model selection or failover, also read:

- [Model Failover](https://docs.openclaw.ai/concepts/model-failover)

If it affects channels, tools, or another subsystem, add the matching current upstream pages to the feature spec instead of copying those docs into this repo.

## Capabilities

A skill is a good fit when the feature needs to bundle:

- one or more plugin-backed behaviors
- runtime policy across files such as `openclaw.json.template`, `model-runtime.yml`, `tools.yaml`, or `channels.yaml.template`
- helper modules, manifests, prompts, or packaging metadata
- environment-specific secrets or provider configuration
- a repeatable deployment recipe for runtime capability
- a `SKILL.md`-based capability layout, optionally with extra scripts or resources

## Limitations

Assume these limits unless the architecture changes:

- a skill is not automatically its own service
- a skill can depend on runtime config and secrets that differ per environment
- install state can remain live runtime state until checkpoint promotion makes it part of a new baseline
- a skill should not bypass native OpenClaw lifecycle where OpenClaw already owns install behavior

## Implementation Recipe

1. Define the capability in operator language first: what the runtime can do after install that it could not do before.
2. Identify the exact OpenClaw surfaces the skill depends on and verify them in current upstream docs.
3. Decide whether the runtime-facing unit is one plugin, several plugins, or pure config plus manifests.
4. Implement the portable package in `remram-skills` using current OpenClaw skill rules:
   - a skill is a directory containing `SKILL.md`
   - optional scripts or resources can live beside it
   - workspace skills live under `<workspace>/skills`
   - managed or local skills live under `~/.openclaw/skills`
   - plugin-shipped skills can be declared from `openclaw.plugin.json`
5. Add only the stable baseline policy to `moltbox-runtime`; keep live install state out of Git unless it is being promoted intentionally.
   - skill config lives under `skills` in `openclaw.json`
   - common surfaces include `skills.allowBundled`, `skills.load.extraDirs`, `skills.install.*`, and `skills.entries.<name>.enabled|env|apiKey`
   - `skills.entries.<name>.env` and `apiKey` apply to host runs only; sandboxed skill processes need sandbox env wiring
6. Record required secrets, model refs, channel policy, tool policy, or allowlists explicitly in the feature spec.
7. Document the feature in `remram/features/<name> [skill]/` with `README.md`, `spec.md`, `operator-guide.md`, and `test-plan.md`.
8. Call out what is environment-specific and what is expected to promote cleanly from `dev` to `test` to `prod`.

## Deployment Method

Skills currently reach the appliance through environment-scoped runtime operations and native OpenClaw behavior.

Typical path:

```text
moltbox <env> openclaw <native install command>
```

In many current feature docs, that concrete path is:

```text
moltbox <env> openclaw plugins install <skill-or-plugin-id>
```

Current upstream skill inspection commands that should remain reachable through passthrough are:

```text
openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

For external distribution and backup, current upstream OpenClaw uses ClawHub as the public skill registry. The relevant command family is:

```text
clawhub search "<query>"
clawhub install <slug>
clawhub update <slug>
clawhub update --all
clawhub list
clawhub publish <path>
clawhub sync --all
```

Treat the gateway as the orchestrator around that native install path:

- capture pre-deploy snapshots
- apply required runtime config
- perform the install
- reload or restart when required
- record deployment events and recovery metadata
- replay recorded install events when the runtime container itself is redeployed

## Testing Surfaces

Always test these surfaces:

- install eligibility and package discovery
- trust, allowlist, or manifest validation when the runtime enforces them
- runtime config render for every file the skill depends on
- the actual operator-visible behavior the skill is meant to create
- environment-specific secret handling
- logs, diagnostics, or runtime status that reveal the effective model, tool, or channel path
- promotion behavior across `dev`, `test`, and `prod`

## Common Combination Pattern

If the capability is mostly one OpenClaw extension with very little packaging around it, the primary type is probably [Plugin](plugin.md).

If the capability also depends on appliance infrastructure such as a model host, search backend, or ingress service, combine this recipe with [Service](service.md).
