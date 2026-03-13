# CLI Architecture

This document is the authoritative architecture reference for the Moltbox CLI.

The CLI is a resource-oriented operator surface. Top-level namespaces represent things the operator works with directly:

- the gateway control plane
- runtime environments
- scoped secret targets
- managed service CLIs

Canonical grammar:

```text
moltbox <resource> <command>
```

## Command Tree

```text
moltbox
  gateway
    status
    update
    logs
    service deploy <service>
    service restart <service>
    service status <service>

  dev
    openclaw <command>
    checkpoint
    reload
    secrets set <NAME>
    secrets list
    secrets delete <NAME>

  test
    openclaw <command>
    checkpoint
    reload
    secrets set <NAME>
    secrets list
    secrets delete <NAME>

  prod
    openclaw <command>
    checkpoint
    reload
    secrets set <NAME>
    secrets list
    secrets delete <NAME>

  service
    secrets set <NAME>
    secrets list
    secrets delete <NAME>

  ollama
    <native ollama command>

  opensearch
    <native opensearch command>

  caddy
    <native caddy command>
```

## Design Principles

### Resource-Oriented CLI

Top-level commands represent operator-facing resources rather than internal software layers.

Examples:

- `dev`, `test`, and `prod` represent runtime environments
- `service` is a shared-service secret scope used only for `moltbox service secrets ...`
- `ollama`, `opensearch`, and `caddy` represent managed services
- `gateway` represents the appliance control plane

This keeps the CLI aligned with the way operators think about the appliance.

### Environment-First Runtime Model

Runtime operations are scoped to environments:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox prod openclaw <command>
```

Internally, those environment names map to runtime service identities:

- `dev` -> `openclaw-dev`
- `test` -> `openclaw-test`
- `prod` -> `openclaw-prod`

Those internal identifiers remain implementation details and must not appear as top-level CLI namespaces.

Scoped secrets also follow the environment-first model:

```text
moltbox dev secrets set TOGETHER_API_KEY
moltbox test secrets list
moltbox prod secrets delete TOGETHER_API_KEY
```

Shared-service secrets use:

```text
moltbox service secrets set POSTGRES_PASSWORD
```

### Native CLI Passthrough

Moltbox exposes selected service CLIs through thin passthrough namespaces:

```text
moltbox ollama <native command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

Moltbox does not try to reimplement service-native functionality when a native CLI already exists.

### Gateway As Control Plane

The `gateway` namespace manages appliance-level lifecycle and deployment operations.

Examples:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway service deploy opensearch
```

Container deployment and service lifecycle actions are routed through the gateway service pipeline.

`moltbox gateway update` is also the canonical self-update path for the host `moltbox` CLI/tooling. There is no separate active `tools update` namespace in the Architecture V2 contract.

Secrets are also gateway-owned, but they do not use a network secrets API. The CLI invokes local gateway command handlers that read and write the encrypted appliance secret store at `/var/lib/moltbox/secrets/<scope>/`.

### Runtime Checkpoint Behavior

Checkpoint is an environment-scoped runtime orchestration action:

```text
moltbox dev checkpoint
```

Checkpoint is intended to:

1. capture runtime state
2. build a new base container image
3. deploy that image
4. run health checks
5. clear replay history if successful

This keeps long-lived runtime mutation manageable by periodically promoting a stable runtime state into a new baseline.

## Service Passthrough Model

The service passthrough namespaces are intentionally thin.

- `ollama` forwards to the native Ollama CLI inside the managed service surface
- `opensearch` forwards to the native OpenSearch CLI or management entrypoint exposed by the service
- `caddy` forwards to the native Caddy CLI

The passthrough model exists to preserve native service ergonomics while keeping operators inside the Moltbox control surface.

## Gateway Service Pipeline

The gateway also exposes a structured service lifecycle surface:

```text
moltbox gateway service deploy <service>
moltbox gateway service restart <service>
moltbox gateway service status <service>
```

This pipeline manages appliance services as deployment units.

Documented shared-service identifiers include:

- `gateway`
- `opensearch`
- `ollama`
- `caddy`

Runtime container deployment is also valid through this pipeline.

Documented public runtime service identifiers are:

- `dev`
- `test`
- `prod`

Those environment identifiers still map internally to runtime container identities such as `openclaw-dev`, `openclaw-test`, and `openclaw-prod`.

## Retired CLI Forms

These forms are not part of the Architecture V2 CLI contract:

- `runtime` as a top-level namespace
- top-level `skill`
- top-level `openclaw-dev`
- top-level `openclaw-test`
- top-level `openclaw-prod`
- `tools`
- `host`

Legacy commands should fail rather than redirect.

Exception:

- `moltbox service secrets ...` is part of the active CLI because `service` acts as a secret scope, not as the retired lifecycle namespace
- `tools update` remains retired; gateway self-update owns CLI/tooling refresh

## Related Documents

- [CLI](../operations/cli.md)
- [Operator Workflow](../operations/operator-workflow.md)
- [CLI Reference](../reference/cli-reference.md)
- [Runtime](../concepts/runtime.md)
- [Checkpoint](../concepts/checkpoint.md)
