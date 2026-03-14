# Runtime

A Runtime is the configuration and execution environment for managed runtime behavior on the appliance.

In the current architecture, the primary runtime family is the OpenClaw runtime set.

Operators address those runtimes through environment namespaces:

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

It does not define the full live runtime state after skill deployment and runtime mutation.

The gateway owns the replay log, staged replay artifacts, and checkpoint metadata under `/srv/moltbox-state`.

The runtime container is a stateless executor for:

- normal startup from the selected baseline image
- replayed installs during runtime redeploy

## Why The Runtime Concept Matters

The runtime concept separates:

- baseline configuration in `moltbox-runtime`
- live mutable runtime state on the appliance
- runtime lifecycle operations such as reload, snapshot, and checkpoint

## Runtime Operations

Runtime operations are addressed through environment namespaces, not a generic `runtime` namespace.

Examples:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev skill deploy together
moltbox dev skill rollback together
moltbox dev openclaw <command>

moltbox test reload
moltbox test checkpoint
moltbox test skill deploy together
moltbox test openclaw <command>
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

Skill deploys follow the same control-plane model:

1. the gateway stages the package in appliance state
2. the gateway appends a replay event
3. the runtime is redeployed through the control plane
4. the runtime executes the install from gateway state

If the exact skill digest is already present in the current checkpoint metadata, `skill deploy` returns a no-op result instead of creating a duplicate replay entry.

## Related Concepts

- [Plugin](plugin.md)
- [Service](service.md)
- [Gateway](gateway.md)
- [Snapshot](snapshot.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../overview/cli-architecture.md)
