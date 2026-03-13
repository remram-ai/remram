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
baseline runtime configuration
  + skill and plugin deployments
  + runtime mutations
  = current runtime state
```

`moltbox-runtime` defines the baseline runtime configuration only.

It does not define the full live runtime state after skill deployment and runtime mutation.

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
moltbox dev openclaw <command>

moltbox test reload
moltbox test openclaw <command>
```

## Runtime Rebuild Model

If a runtime must be rebuilt, the system restores the baseline configuration and then replays recorded [Deployment Events](deployment-event.md).

That replay history is maintained by the gateway control plane in appliance state.

TODO:

- confirm the exact stable OpenClaw passthrough command set exposed under `moltbox <env> openclaw <command>`
- confirm how runtime checkpoint promotion is reflected back into baseline source control and whether that promotion always resets the replay chain

## Related Concepts

- [Service](service.md)
- [Gateway](gateway.md)
- [Snapshot](snapshot.md)
- [Checkpoint](checkpoint.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../platform/cli-architecture.md)
