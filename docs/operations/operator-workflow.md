# Operator Workflow

The normal operator path is:

```text
Workstation
  -> ssh
    -> Moltbox CLI
      -> Gateway
```

The gateway is the control plane.

Operators should manage the appliance through the Moltbox CLI rather than direct Docker commands.

Internal agents and containers use the gateway MCP HTTP surface with bearer tokens managed by `moltbox gateway token ...`. That MCP path is not the normal workstation operator interface.

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

`moltbox gateway service restart <service>` follows the deploy lifecycle and only reports success after the target service is healthy.

Runtime containers can also be deployed through the same service pipeline:

```text
moltbox gateway service deploy dev
moltbox gateway service deploy test
moltbox gateway service deploy prod
```

When this path is used, the runtime baseline must be restored and recorded skill or plugin deployment events must be replayed before the environment is treated as healthy.

For runtime replay validation and normal runtime redeploys, this is the correct control-plane path. A plain Docker container restart does not read gateway replay state.

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

Checkpoint creates a promoted runtime baseline image, writes baseline metadata under `/srv/moltbox-state/runtime-baselines/<runtime>/current.json`, and clears the replay log for that runtime.

### 6. Promote across environments deliberately

Expected promotion posture:

1. build and iterate in `dev`
2. deploy runtime mutations in `dev` with `moltbox dev skill deploy <skill>`
3. validate replay in `dev` with `moltbox gateway service deploy dev`
4. checkpoint `dev` with `moltbox dev checkpoint`
5. verify the checkpointed baseline and empty replay log in `dev`
6. promote the checkpointed baseline to `test`
7. validate runtime behavior in `test`
8. promote the verified baseline to `prod`

If `dev` to `test` promotion fails, fix the deployment process before treating the platform item as ready.

Operator workflow shorthand:

```text
dev -> checkpoint -> verify -> promote -> test -> verify -> promote -> prod
```

### 7. Investigate with CLI-first diagnostics

Use the CLI namespaces first:

```text
moltbox gateway logs
moltbox dev openclaw <command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

## SSH Automation

Supported restricted identities:

- `jason-codex` for automation that should be limited to `moltbox <args>`
- `codex-bootstrap` for break-glass diagnostics, with full CLI access in `dev` and diagnostic-only access in `test` and `prod`

Examples:

```text
ssh -T -i ~/.ssh/jason-codex jason-codex@moltbox-prime "moltbox dev openclaw health --json"
ssh -T -i ~/.ssh/codex-bootstrap codex-bootstrap@moltbox-prime "moltbox test openclaw health --json"
```

## Host Wrapper

A thin host-level `moltbox` entrypoint may exist on the appliance host.

That wrapper is only a convenience layer around the real control path.

The primary operator model is SSH plus the Moltbox CLI invoking the gateway.

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

For the detailed command catalog, use [CLI Reference](../../reference/cli-reference.md).
For the architecture behind the command tree, use [CLI Architecture](../overview/cli-architecture.md).
