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
- runtime configuration lives in `moltbox-runtime`
- skill recipes and implementations live in `remram-skills`
