# Skill

A Skill is a reusable capability package deployed into runtimes.

Skills are the portable capability layer of the ecosystem.

## Where Skills Live

Skill packages and deploy recipes live in:

```text
remram-skills
```

## What A Skill Can Include

A skill may include:

- a `SKILL.md` skill definition
- capability code
- plugin-backed runtime behavior
- packaging metadata
- deploy recipes
- helper modules and manifests

## How Skills Reach The Appliance

Skills are deployed through the gateway control plane into runtime environments.

The active CLI does not expose a top-level `skill` namespace.

Instead, skill installation is expected to flow through environment-scoped runtime operations and native OpenClaw installation behavior.

Typical operator direction is:

```text
moltbox dev openclaw <command>
moltbox test openclaw <command>
```

The gateway may use native OpenClaw installation behavior as part of skill deployment.

Current OpenClaw skill-inspection commands that should remain reachable through passthrough are:

```text
openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

Workspace and managed skill layout is defined by current OpenClaw docs:

- skills are directories containing `SKILL.md`
- workspace skills live under `<workspace>/skills`
- managed or local skills live under `~/.openclaw/skills`
- plugins may also ship skills directories from the plugin root

Current OpenClaw skill config lives under `skills` in `~/.openclaw/openclaw.json`.

Important config surfaces include:

- `skills.allowBundled`
- `skills.load.extraDirs`
- `skills.load.watch`
- `skills.install.*`
- `skills.entries.<name>.enabled`
- `skills.entries.<name>.env`
- `skills.entries.<name>.apiKey`

## Skill Versus Feature

A [Feature](feature.md) is a product-level capability definition.

A skill is one implementation building block that a feature may depend on.

## Skill Versus Service

A [Service](service.md) is a long-running containerized process on the appliance.

A skill is a reusable capability package deployed into a runtime. It is not automatically a separate service.

## Skill Versus Plugin

A [Plugin](plugin.md) is executable extension code running in the OpenClaw process.

A skill is the broader portable capability package. It may be pure `SKILL.md` content, plugin-backed, or a mixture of prompts, manifests, helper modules, and runtime policy.

## Related Concepts

- [Feature](feature.md)
- [Plugin](plugin.md)
- [Runtime](runtime.md)
- [Gateway](gateway.md)
