# CLI Reference

This document records the active Moltbox CLI reference model used by the documentation set.

Canonical grammar:

```text
moltbox <resource> <command>
```

## Top-Level Resources

Canonical resource namespaces:

- `gateway`
- `dev`
- `test`
- `prod`
- `service` for scoped secrets only
- `ollama`
- `caddy`
- `opensearch`

The CLI does not expose `openclaw-dev`, `openclaw-test`, or `openclaw-prod` as top-level operator namespaces.

## Command Tree

```text
moltbox
  gateway
    status
    update
    logs
    token create <NAME>
    token list
    token delete <NAME>
    token rotate <NAME>
    service deploy <service>
    service restart <service>
    service status <service>

  dev
    openclaw <command>
    checkpoint
    reload
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  test
    openclaw <command>
    checkpoint
    reload
    secrets set <NAME> [VALUE]
    secrets list
    secrets delete <NAME>

  prod
    openclaw <command>
    checkpoint
    reload
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

## Retired Namespaces

These namespaces are retired:

- `runtime`
- top-level `service`
- top-level `skill`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `tools`
- `host`

Legacy commands should fail rather than redirect.

Exception:

- `moltbox service secrets ...` is valid because `service` is a secret scope, not the retired lifecycle namespace
- `tools update` is not an active command; use `moltbox gateway update`

## Environment Mapping

Environment namespaces map to internal runtime identities:

- `dev` -> `openclaw-dev`
- `test` -> `openclaw-test`
- `prod` -> `openclaw-prod`

Those internal names are for implementation and deployment plumbing. They are not part of the public CLI taxonomy.

## Gateway Commands

Control-plane operations:

```text
moltbox gateway status
moltbox gateway logs
moltbox gateway update
moltbox gateway token create search-agent
```

`moltbox gateway update` refreshes the appliance self-managed control-plane tooling:

- the running `gateway` container
- the host `moltbox` CLI binary
- the host-side CLI config used by local gateway-owned commands such as scoped secrets

Gateway token operations manage the bearer tokens used by the internal MCP HTTP surface:

```text
moltbox gateway token create <NAME>
moltbox gateway token list
moltbox gateway token delete <NAME>
moltbox gateway token rotate <NAME>
```

Workstation automation uses SSH plus the Moltbox CLI directly. MCP is reserved for internal appliance agents and containers.

Service lifecycle operations:

```text
moltbox gateway service deploy <service>
moltbox gateway service restart <service>
moltbox gateway service status <service>
```

Examples:

```text
moltbox gateway service deploy opensearch
moltbox gateway service restart caddy
moltbox gateway service status ollama
```

`moltbox gateway service restart <service>` reconciles the service through the same deploy pipeline as `deploy` and only reports success after health checks pass.

## Environment Commands

Runtime orchestration stays under the environment namespaces:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev openclaw <command>

moltbox test reload
moltbox test checkpoint
moltbox test openclaw <command>

moltbox prod reload
moltbox prod checkpoint
moltbox prod openclaw <command>
```

Scoped secrets also use the environment namespaces:

```text
moltbox dev secrets set TOGETHER_API_KEY "tgp_v1_..."
moltbox test secrets list
moltbox prod secrets delete TOGETHER_API_KEY
moltbox service secrets set POSTGRES_PASSWORD "super-secret"
```

## Native Service Passthrough

```text
moltbox ollama <native ollama command>
moltbox opensearch <native opensearch command>
moltbox caddy <native caddy command>
```

Moltbox does not reimplement these service CLIs. It forwards operator requests into the managed service surfaces.

## Service Identifier Notes

`gateway service ...` operates on managed appliance services.

Stable documented examples include:

- `gateway`
- `opensearch`
- `ollama`
- `caddy`
- `dev`
- `test`
- `prod`

For runtime deployment through the gateway service pipeline, the public identifiers remain the environment names. The underlying container names such as `openclaw-dev` are implementation details.

## OpenClaw Passthrough Notes

Current upstream OpenClaw command families that Moltbox should preserve under `moltbox <env> openclaw ...` include:

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

## Scoped Secrets

Secrets are gateway-owned local appliance state.

Rules:

- valid scopes are `dev`, `test`, `prod`, and `service`
- the CLI surface is `moltbox <scope> secrets <set|list|delete>`
- scoped secret commands route through the gateway control plane before the encrypted store is touched
- the gateway stores encrypted secret files under `/var/lib/moltbox/secrets/<scope>/`
- secret values are not printed in normal CLI output
- gateway-managed deploy or reload operations inject scoped secrets into the target container environment

Gateway-managed MCP bearer tokens are stored in the same encrypted secret store under the `service` scope.

## Checkpoint Notes

Checkpoint is an environment-scoped operation:

```text
moltbox dev checkpoint
```

It is intended to:

1. capture runtime state
2. build a new base container image
3. deploy that image
4. validate runtime health
5. clear replay history if successful

## Output Model

The CLI should emit structured JSON for success and failure.

Useful fields include:

- command metadata
- operation details
- `error_type`
- `error_message`
- `recovery_message`

## Related Documents

- [CLI Architecture](../overview/cli-architecture.md)
- [CLI](../operations/cli.md)
- [Operator Workflow](../operations/operator-workflow.md)
- [Gateway](../concepts/gateway.md)
