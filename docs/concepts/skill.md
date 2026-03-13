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

TODO:

- document the exact public skill-install command forms once the environment-scoped OpenClaw contract is written down in platform documentation

## Skill Versus Feature

A [Feature](feature.md) is a product-level capability definition.

A skill is one implementation building block that a feature may depend on.

## Skill Versus Service

A [Service](service.md) is a long-running containerized process on the appliance.

A skill is a reusable capability package deployed into a runtime. It is not automatically a separate service.

## Related Concepts

- [Feature](feature.md)
- [Runtime](runtime.md)
- [Gateway](gateway.md)
