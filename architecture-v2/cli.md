# Moltbox CLI V2

The CLI reflects the component being managed, not the repository that stores its source.

Grammar:

```text
moltbox <component> <command>
```

## Component Rules

`<component>` should generally be one of:

- `gateway`
- `service`
- a real service or container identity such as `openclaw`, `openclaw-dev`, `openclaw-test`, `caddy`, or `opensearch`
- `skill` for orchestrated multi-action skill deployment

Avoid generic namespaces such as:

- `runtime`
- `host`
- `tools`
- repository-layer names such as `features`

## Core Namespaces

### Gateway

```text
moltbox gateway health
moltbox gateway status
moltbox gateway inspect
moltbox gateway logs
moltbox gateway update
moltbox gateway rollback
```

### Service

`service` is the generic deployment path for container lifecycle.

```text
moltbox service list
moltbox service inspect <service>
moltbox service status <service>
moltbox service logs <service>
moltbox service deploy <service> [--version <tag>] [--commit <sha>]
moltbox service restart <service>
moltbox service start <service>
moltbox service stop <service>
moltbox service rollback <service>
moltbox service doctor <service>
```

### Service-Specific Commands

Service-specific namespaces exist when the control plane is operating on the runtime behavior or component-specific control surface of a real service.

Examples:

```text
moltbox openclaw status
moltbox openclaw logs
moltbox openclaw reload
moltbox openclaw doctor
moltbox openclaw monitor
moltbox openclaw config sync

moltbox openclaw-dev status
moltbox openclaw-dev reload
moltbox openclaw-dev config sync

moltbox openclaw-test status
moltbox openclaw-test reload

moltbox caddy status
moltbox opensearch status
```

## Environment Naming

Environments are represented as separate service identities rather than CLI flags.

Examples:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

Alias rule:

- `openclaw` is an alias for `openclaw-prod`

## Skill Deployment

`skill` is the one non-service orchestration namespace intentionally added to the CLI.

Reason:

- skills may trigger multiple underlying operations
- a skill deploy is not just a single service deploy or a single config reload

Example:

```text
moltbox skill deploy <skill>
```

That command should orchestrate the required service deploys, runtime syncs, and reloads without forcing operators to know the internal sequence.
