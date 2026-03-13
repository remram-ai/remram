# CLI

The Moltbox CLI is the normal operator control surface for the appliance.

Canonical grammar:

```text
moltbox <resource> <command>
```

The CLI is resource-oriented. Top-level namespaces represent operator-facing resources rather than internal software layers.

## Command Map

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

  test
    openclaw <command>
    checkpoint
    reload

  prod
    openclaw <command>
    checkpoint
    reload

  ollama
    <native ollama command>

  opensearch
    <native opensearch command>

  caddy
    <native caddy command>
```

## Resource Groups

Gateway:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway logs
moltbox gateway service deploy opensearch
```

Runtime environments:

```text
moltbox dev reload
moltbox test checkpoint
moltbox prod openclaw <command>
```

Native service passthrough:

```text
moltbox ollama <native command>
moltbox opensearch <native command>
moltbox caddy <native command>
```

## Operational Rules

- use the CLI as the normal control surface
- use `dev`, `test`, and `prod` for runtime operations
- use `gateway service ...` for appliance deployment and service lifecycle work
- use `gateway service deploy dev|test|prod` when redeploying runtime containers through the control plane
- use native service passthrough namespaces instead of reimplementing service-specific commands in Moltbox
- treat Docker commands as internal implementation details

## Internal Mapping

The CLI uses environment names:

- `dev`
- `test`
- `prod`

Those map internally to runtime service identities such as:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

Those internal runtime names are implementation identities, not operator-facing CLI namespaces.

## Retired Namespaces

The following namespaces are retired:

- `runtime`
- top-level `service`
- top-level `skill`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `tools`
- `host`

Legacy commands should fail rather than redirect.

## See Also

- [CLI Architecture](../platform/cli-architecture.md)
- [Operator Workflow](operator-workflow.md)
- [CLI Reference](../reference/cli-reference.md)
