# Skills

Skill implementations and deploy recipes live in:

```text
remram-skills
```

The gateway must treat `remram-skills` as an external repository.

## Skill Deployment

Command:

```text
moltbox skill deploy <skill>
```

`skill deploy` is an orchestration pipeline.

It may coordinate:

- OpenClaw runtime configuration updates
- OpenClaw lifecycle operations
- service deployments

The gateway reads the deploy recipe for the skill from `remram-skills` and executes the required lower-level actions.

The gateway may use native OpenClaw skill and plugin installation mechanisms as part of that deployment flow.

That means skill deployment is allowed to mutate live runtime state inside the target runtime container when OpenClaw's native installation process requires it.

Those mutations are part of operational runtime state and do not need to synchronize back into Git-backed runtime templates automatically.

Runtime targeting should be first-class.

Examples:

```text
moltbox skill deploy semantic-router --runtime openclaw-test
moltbox openclaw-test skill deploy semantic-router
```

## Boundary Rule

Skills are not feature docs and are not the same thing as services.

- feature descriptions live in `remram/features/`
- service definitions live in `moltbox-services`
- baseline runtime configuration lives in `moltbox-runtime`
- skill recipes and implementations live in `remram-skills`

## Runtime State Interaction

`remram-skills` owns:

- skill packages
- plugin packages
- deploy recipes
- skill-local code and manifests

`moltbox-runtime` owns the baseline runtime configuration that skill deployment starts from.

Live runtime state after skill deployment may include OpenClaw-managed mutations that are not fully represented in Git-backed runtime templates.

Those mutations remain part of runtime state, not part of the skill source repository.

Runtime checkpoint and backup artifacts that capture deployed skill/plugin state are appliance-state records, not source-controlled skill assets.
