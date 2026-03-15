# Runtime

A Runtime is the configuration and execution environment for managed runtime behavior on the appliance.

In the current architecture, the primary runtime family is the OpenClaw runtime set.

Operators address those runtimes through the environment namespaces:

- `dev`
- `test`
- `prod`

Those map internally to:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

## Baseline Versus Live Runtime State

The current runtime model is:

```text
checkpoint baseline image
  + gateway replay log
  = current runtime state
```

`moltbox-runtime` defines the baseline runtime configuration only.

It does not define the full live runtime state after skill and plugin mutation.

The gateway owns the replay log, staged replay artifacts, and checkpoint metadata under `/srv/moltbox-state`.

The runtime container executes the selected baseline plus replayed installs. It is not the source of truth for managed deployment state.

## Runtime Operations

Runtime operations are addressed through environment namespaces, not a generic `runtime` namespace.

Examples:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev skill deploy together
moltbox dev skill list
moltbox dev skill remove together
moltbox dev plugin install moltbox-telemetry
moltbox dev plugin list
moltbox dev plugin remove moltbox-telemetry
moltbox dev openclaw <command>
```

Current upstream OpenClaw passthrough families that should remain reachable include:

```text
openclaw plugins list
openclaw plugins info <id>
openclaw plugins enable <id>
openclaw plugins disable <id>
openclaw plugins install <path-or-spec>
openclaw plugins uninstall <id>
openclaw plugins doctor
openclaw plugins update <id>
openclaw plugins update --all

openclaw skills list
openclaw skills list --eligible
openclaw skills info <name>
openclaw skills check
```

## Runtime Rebuild Model

If a runtime must be rebuilt or redeployed as a container, the system restores the selected checkpoint baseline and then replays the ordered events in the gateway replay log.

That replay history is maintained by the gateway control plane in appliance state.

The replay-aware redeploy path is:

```text
moltbox gateway service deploy <env>
```

Managed skill deploys follow the same control-plane model:

1. the gateway stages the package in appliance state
2. the gateway appends a replay event
3. the runtime is redeployed through the control plane
4. the runtime executes the install from gateway state

If the exact skill digest is already present in the current checkpoint metadata, `skill deploy` returns a no-op result instead of creating a duplicate replay entry.

Managed `skill deploy` currently stages pure skill packages only. Plugin-backed packages remain outside that path on `main`.

## Snapshot And Checkpoint Posture

Checkpoint is the durable runtime-state capture that currently exists on `main`.

The active checkpoint metadata path is:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/current.json
```

Checkpoint snapshot directories live under:

```text
/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/snapshot/
```

A separate per-mutation runtime snapshot root is still in flight and is not part of the implemented `main` contract today.

## Related Concepts

- [Plugin](plugin.md)
- [Service](service.md)
- [Gateway](gateway.md)
- [Snapshot](snapshot.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../overview/cli-architecture.md)
