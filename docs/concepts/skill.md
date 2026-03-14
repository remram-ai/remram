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

- a `SKILL.md` definition
- prompts, manifests, or helper modules
- packaging metadata
- runtime policy inputs
- optional plugin-backed behavior

## Public CLI Model

The active public CLI keeps skill lifecycle under the environment resources:

```text
moltbox <env> skill deploy <skill>
moltbox <env> skill list
moltbox <env> skill remove <skill>
```

There is no active top-level `moltbox skill ...` namespace.

`moltbox <env> skill list` is the gateway-owned convenience surface for runtime skill inventory.

Native OpenClaw skill inspection remains reachable through passthrough when needed:

```text
moltbox <env> openclaw skills list
moltbox <env> openclaw skills info <name>
```

## Managed Deploy Scope On Main

On `main`, managed `skill deploy` stages pure skill packages only.

Current rule:

- packages with `SKILL.md` and no `openclaw.plugin.json` are supported by `moltbox <env> skill deploy`
- packages that rely on `openclaw.plugin.json` are not yet supported by the managed skill deploy path on `main`

Plugin-backed packages remain future capability for managed skill deploy. Until that contract is implemented, use the documented plugin lifecycle for those deliverables instead of assuming `skill deploy` will stage them.

## Skill Versus Feature

A [Feature](feature.md) is an initiative-level capability definition.

A skill is one implementation building block that a feature may produce or depend on.

## Skill Versus Service

A [Service](service.md) is a long-running containerized process on the appliance.

A skill is a reusable capability package deployed into a runtime. It is not automatically a separate service.

## Skill Versus Plugin

A [Plugin](plugin.md) is executable extension code running in the OpenClaw process.

A skill is the broader portable capability package. It may be pure `SKILL.md` content, plugin-backed, or a mixture of prompts, manifests, helper modules, and runtime policy, even though the current managed `skill deploy` path only stages pure skills on `main`.

## Related Concepts

- [Feature](feature.md)
- [Plugin](plugin.md)
- [Runtime](runtime.md)
- [Gateway](gateway.md)
