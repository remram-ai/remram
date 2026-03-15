# Service

A Service is a containerized process running on the appliance.

Services are the deployable process layer of the Moltbox platform.

## Where Services Live

Service definitions and deployment topology live in:

```text
moltbox-services
```

## Examples

First-class appliance services include:

- `gateway`
- `caddy`
- `opensearch`
- `ollama`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

## How Services Are Managed

Services are deployed and operated through the gateway service pipeline:

```text
moltbox gateway service deploy <service>
moltbox gateway service restart <service>
moltbox gateway service status <service>
```

Some services also expose direct native CLI passthrough namespaces, such as:

```text
moltbox caddy <native command>
moltbox opensearch <native command>
moltbox ollama <native command>
```

The runtime containers are also deployable through the same `gateway service ...` pipeline, using the public service targets:

- `dev`
- `test`
- `prod`

`gateway` remains a first-class appliance service and a valid `moltbox gateway service status gateway` target, but control-plane self-mutation uses `moltbox gateway update` rather than `gateway service deploy|restart gateway`.

## Service Versus Runtime

A [Runtime](runtime.md) is the configuration and execution environment for managed runtime behavior.

A service is the actual running container process.

For OpenClaw, the runtime concept and the runtime service are closely related, but they are not the same concept.

## Service Versus Skill

A [Skill](skill.md) is a reusable capability package deployed into a runtime.

A service is a long-running process with its own lifecycle on the appliance.

## Service Versus Plugin

A [Plugin](plugin.md) is executable extension code running inside the OpenClaw gateway process.

A service is a containerized appliance process. If OpenClaw needs to consume that service, the runtime still needs a plugin, skill, or runtime-config surface that points at it.

## Related Concepts

- [Plugin](plugin.md)
- [Runtime](runtime.md)
- [Gateway](gateway.md)
- [Skill](skill.md)
- [CLI Architecture](../overview/cli-architecture.md)
