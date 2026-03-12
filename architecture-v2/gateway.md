# Gateway

The gateway is the Moltbox control plane.

Steady-state topology:

```text
Host OS
  -> Docker Engine
    -> gateway container
    -> openclaw container
    -> opensearch container
    -> caddy container
    -> optional service containers
```

## Responsibilities

The gateway container owns:

- CLI implementation
- orchestration logic
- service deployment coordination
- runtime configuration synchronization
- Docker interaction
- runtime monitoring

The gateway does not own:

- product feature definitions
- service topology source of truth
- runtime configuration source of truth
- skill implementation source

Those concerns live in `remram`, `moltbox-services`, `moltbox-runtime`, and `remram-skills`.

## CLI Model

The CLI grammar is:

```text
moltbox <component> <command>
```

Examples:

```text
moltbox gateway status
moltbox gateway update

moltbox service deploy openclaw-dev
moltbox service restart caddy

moltbox openclaw reload
moltbox openclaw-dev reload

moltbox skill deploy <skill>
```

Rules:

- namespaces correspond to managed components or orchestration pipelines
- the CLI must not mirror repository layers such as features
- `openclaw` is an alias for `openclaw-prod`

## Gateway-Specific Operations

Gateway self-management is separate from generic service deployment.

Command:

```text
moltbox gateway update
```

That path exists because the gateway cannot deploy itself through the normal `service deploy` pipeline.
