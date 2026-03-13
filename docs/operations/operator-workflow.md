# Operator Workflow

The normal operator path is:

```text
Visual Studio
  -> MCP plugin
    -> Moltbox CLI
      -> Gateway
```

The gateway is the control plane.

Operators should manage the appliance through the Moltbox CLI rather than direct Docker commands.

## Normal Workflow

### 1. Check the control plane

Start with the gateway:

```text
moltbox gateway status
moltbox gateway logs
moltbox gateway service status gateway
moltbox gateway service status caddy
moltbox gateway service status opensearch
moltbox gateway service status ollama
```

### 2. Work in the target environment

Runtime operations are scoped to the environment:

```text
moltbox dev reload
moltbox test checkpoint
moltbox prod openclaw <command>
```

Use `dev`, `test`, and `prod` in the CLI.

Do not use internal runtime identifiers such as `openclaw-dev` as top-level command namespaces.

### 3. Deploy or restart appliance services

Use the gateway service pipeline for appliance services:

```text
moltbox gateway service deploy gateway
moltbox gateway service deploy opensearch
moltbox gateway service restart caddy
moltbox gateway service status ollama
```

Runtime containers can also be deployed through the same service pipeline:

```text
moltbox gateway service deploy dev
moltbox gateway service deploy test
moltbox gateway service deploy prod
```

When this path is used, the runtime baseline must be restored and recorded skill or plugin deployment events must be replayed before the environment is treated as healthy.

### 4. Use native service CLIs when needed

Service namespaces are passthrough interfaces to the native service CLIs:

```text
moltbox ollama <native command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

### 5. Promote stable runtime state

When a runtime state should become the new baseline, checkpoint it:

```text
moltbox dev checkpoint
moltbox test checkpoint
```

Checkpointing is environment-scoped and stays under the environment namespaces, not under `gateway`.

### 6. Promote across environments deliberately

Expected promotion posture:

1. build and iterate in `dev`
2. run the relevant feature `test-plan.md` in `dev`
3. promote to `test` through the CLI only
4. run the same test plan in `test`
5. stop for UAT readiness review
6. deploy to `prod` only after approval

If `dev` to `test` promotion fails, fix the deployment process before treating the feature as ready.

### 7. Investigate with CLI-first diagnostics

Use the CLI namespaces first:

```text
moltbox gateway logs
moltbox dev openclaw <command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

## Host Wrapper

A thin host-level `moltbox` entrypoint may exist on the appliance host.

That wrapper is only a convenience layer around the real control path.

The primary operator model is still MCP tooling invoking the Moltbox CLI and gateway.

TODO:

- document the exact MCP operator flow once the Visual Studio plugin contract is finalized
- confirm whether host-shell invocation remains a supported primary path or only a local fallback

## Docker Boundary

Docker commands are an implementation detail.

They may be useful as a break-glass diagnostic path, but they are not the normal management contract.

## Legacy Command Namespaces

The following are retired:

- `runtime`
- top-level `service`
- top-level `skill`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `tools`
- `host`

Legacy commands should fail rather than redirect.

For the detailed command catalog, use [CLI Reference](../reference/cli-reference.md).
For the architecture behind the command tree, use [CLI Architecture](../platform/cli-architecture.md).
