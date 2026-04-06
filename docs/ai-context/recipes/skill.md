# Skill Recipe

Use this recipe when the deliverable is primarily a portable RemRam capability bundle deployed into a runtime.

## Use This Type When

- the capability should be reusable across environments or future runtimes
- the deliverable needs more than one local implementation surface
- the package combines runtime policy, manifests, helper modules, prompts, or deploy recipe material
- the deliverable is best described as a portable capability rather than as one container or one gateway command

Current repo examples:

- `together-escalation`
- `discord-channel`

## Do Not Use This Type When

- the deliverable is just a single runtime extension and the plugin boundary is the main thing that matters
- the deliverable needs a dedicated appliance container with its own lifecycle
- the deliverable changes gateway or CLI ownership rather than runtime capability

In those cases, use [Plugin](plugin.md), [Service](service.md), or [Gateway/Core](gateway-core.md).

## Ownership Model

Local ownership usually splits like this:

- `remram`: ecosystem framing and cross-repo summaries
- `remram-skills`: skill package source, packaging metadata, manifests, helpers, and plugin-backed code
- `moltbox-services`: baseline service config and policy files the skill depends on when they are part of an OpenClaw service baseline
- `moltbox-runtime`: final deployable runtime artifacts for that skill-enabled baseline
- `moltbox-gateway`: runtime deployment orchestration, snapshots, and deployment-event tracking

In the current architecture, a skill may be pure `SKILL.md` content, plugin-backed, or a mixture of both, but the skill is the broader RemRam packaging unit.

## OpenClaw Source Of Record

Check the current upstream docs before implementation:

- [Skills](https://docs.openclaw.ai/tools/skills)
- [Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
- [Skills Config](https://docs.openclaw.ai/tools/skills-config)
- [ClawHub](https://docs.openclaw.ai/tools/clawhub)
- [Configuration](https://docs.openclaw.ai/configuration)

If the skill affects model selection or failover, also read:

- [Model Failover](https://docs.openclaw.ai/concepts/model-failover)

## Capabilities

A skill is a good fit when the deliverable needs to bundle:

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
- install state can remain live runtime state until a promoted runtime artifact captures it
- a skill should not bypass native OpenClaw lifecycle where OpenClaw already owns install behavior

## Implementation Recipe

1. Define the capability in operator language first: what the runtime can do after install that it could not do before.
2. Identify the exact OpenClaw surfaces the skill depends on and verify them in current upstream docs.
3. Decide whether the runtime-facing unit is pure skill content, one plugin, several plugins, or pure config plus manifests.
4. Implement the portable package in `remram-skills`.
5. Add the stable baseline policy to `moltbox-services` when it is part of the service-owned OpenClaw baseline, and keep only the final deployable runtime artifact in `moltbox-runtime`.
6. Record required secrets, model refs, channel policy, tool policy, or allowlists explicitly in the skill spec.
7. Document the skill in its owning repo and keep `remram` as the ecosystem pointer rather than the detailed skill authority.
8. Call out what is environment-specific and what is expected to promote cleanly from `test` to `prod`.

## Deployment Method

Managed skills should reach the appliance through approved native or tracked runtime flows.

Relevant upstream inspection commands that should remain reachable through passthrough are:

```text
openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

Treat the gateway as the orchestrator around that deployment path:

- apply required runtime config
- stage the required `SKILL.md` package into the runtime state when appropriate
- reload or restart when required
- record deployment events and recovery metadata

## Testing Surfaces

Always test these surfaces:

- install eligibility and package discovery
- trust, allowlist, or manifest validation when the runtime enforces them
- runtime config render for every file the skill depends on
- the actual operator-visible behavior the skill is meant to create
- environment-specific secret handling
- logs, diagnostics, or runtime status that reveal the effective model, tool, or channel path
- promotion behavior across `test` and `prod`

## Common Combination Pattern

If the capability is mostly one OpenClaw extension with very little packaging around it, the primary type is probably [Plugin](plugin.md).

If the capability also depends on appliance infrastructure such as a model host, search backend, or ingress service, combine this recipe with [Service](service.md).
