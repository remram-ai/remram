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
    mcp-stdio
    token create <NAME>
    token list
    token delete <NAME>
    token rotate <NAME>
    service deploy <service>
    service restart <service>
    service status <service>
    docker ping
    docker run <image>

  dev
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill rollback <skill>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  test
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill rollback <skill>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  prod
    openclaw <command>
    checkpoint
    reload
    skill deploy <skill>
    skill rollback <skill>
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  service
    secrets set <NAME> [VALUE]
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
- `gateway token ...` manages bearer tokens for the internal MCP HTTP surface

This keeps the CLI aligned with the way operators think about the appliance.

### Environment-First Runtime Model

Runtime operations are scoped to environments:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev skill deploy together
moltbox prod openclaw <command>
```

Internally, those environment names map to runtime service identities:

- `dev` -> `openclaw-dev`
- `test` -> `openclaw-test`
- `prod` -> `openclaw-prod`

Those internal identifiers remain implementation details and must not appear as top-level CLI namespaces.

Scoped secrets also follow the environment-first model:

```text
moltbox dev secrets set TOGETHER_API_KEY "tgp_v1_..."
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
moltbox gateway token create search-agent
moltbox gateway docker ping
```

Container deployment and service lifecycle actions are routed through the gateway service pipeline.

`moltbox gateway update` is also the canonical self-update path for the host `moltbox` CLI/tooling. There is no separate active `tools update` namespace in the Architecture V2 contract.

The gateway namespace also includes implementation-oriented diagnostic and bootstrap commands:

- `moltbox gateway mcp-stdio`
- `moltbox gateway docker ping`
- `moltbox gateway docker run <image>`

They are part of the live CLI surface, but they are lower-level than the normal lifecycle workflows.

Workstation automation reaches this namespace over SSH with restricted identities such as `jason-codex`. Internal agents use token-authenticated HTTP MCP against the gateway and do not expose a public ingress route.

Secrets are also gateway-owned. Scoped secret commands follow the control path `CLI -> gateway -> encrypted secret store`, and only the gateway process reads or writes `/var/lib/moltbox/secrets/<scope>/`.

Gateway-owned MCP bearer tokens use the same encrypted secret store through `moltbox gateway token <create|list|delete|rotate>`.

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

### Gateway-Owned Replay State

Runtime mutation state is owned by the gateway under `/srv/moltbox-state`.

Current runtime control-plane state includes:

- `/srv/moltbox-state/deploy/history.jsonl`
- `/srv/moltbox-state/deploy/runtime/<runtime>/replay-log.json`
- `/srv/moltbox-state/deploy/runtime/<runtime>/packages/<event_id>/`
- `/srv/moltbox-state/runtime-baselines/<runtime>/current.json`

Replay is driven entirely from that state. Runtime containers are not the source of truth for installed skills.

### Skill Deploy Lifecycle

For:

```text
moltbox <env> skill deploy <skill>
```

the gateway:

1. resolves the skill and computes its digest
2. checks the current baseline metadata
3. skips replay if the same skill digest is already part of the baseline
4. stages the package in gateway state
5. appends a replay event
6. redeploys the runtime through `moltbox gateway service deploy <env>`

Rollback removes the corresponding replay entry and redeploys from the baseline plus the remaining replay events.

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

`moltbox gateway service restart <service>` reconciles the service through the same deploy lifecycle used by `deploy` and does not report success until the target containers are healthy.

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

For runtime replay validation and normal control-plane redeploys, operators should use `moltbox gateway service deploy <env>`. A plain `docker restart` only restarts the container and does not re-run gateway replay orchestration.

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
