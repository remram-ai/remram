# Platform Overview

Moltbox is the appliance platform for the RemRam ecosystem.

It provides the control plane, runtime environments, and supporting services that make the local appliance operational.

At a high level, the appliance is:

- a Linux host with minimal host-side responsibilities
- a set of managed containers running the platform services
- a gateway control plane that owns deployment and lifecycle orchestration
- a set of mutable OpenClaw runtime environments for live work

## What Moltbox Is

Moltbox is not just a machine that happens to run models.

It is a managed appliance boundary with clear ownership rules:

- the host provides Docker, storage, and system services
- the gateway provides the operator control plane
- runtime environments provide live OpenClaw execution
- supporting services provide search, model serving, ingress, and other appliance capabilities

Operators are expected to work through the Moltbox CLI rather than directly through Docker.

## System Picture

```text
Workstation
  -> ssh
    -> Moltbox CLI
      -> gateway
        -> managed services
        -> runtime environments
        -> deployment metadata
        -> appliance state

Internal agent or container
  -> HTTP MCP + bearer token
    -> gateway
```

Workstation operators use SSH plus the Moltbox CLI directly. MCP is reserved for internal appliance agents and containers that need a token-authenticated programmatic control surface.

Steady-state appliance services include:

- `gateway`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `opensearch`
- `ollama`
- `caddy`

## Control Plane Versus Runtime

The gateway and the OpenClaw runtimes are deliberately separate concerns.

The gateway owns:

- CLI behavior
- deployment orchestration
- service lifecycle coordination
- plugin and skill deployment orchestration
- deployment metadata writes
- runtime deployment-event history

The runtime environments own:

- live OpenClaw execution
- runtime-local mutable state
- plugin and skill installation state
- runtime-specific operational health

This boundary matters because live runtime behavior is allowed to mutate, while appliance-wide deployment and recovery remain governed by the control plane.

## Lifecycle Surfaces

Moltbox exposes several legitimate lifecycle control surfaces.

Gateway service lifecycle:

```text
moltbox gateway service deploy <service>
moltbox gateway service restart <service>
moltbox gateway service status <service>
```

That pipeline is valid for both shared appliance services and the public runtime service targets:

- `dev`
- `test`
- `prod`

Gateway self-lifecycle:

```text
moltbox gateway update
```

Environment runtime lifecycle:

```text
moltbox dev reload
moltbox dev checkpoint
```

Native OpenClaw passthrough lifecycle:

```text
moltbox dev openclaw plugins install <plugin>
```

These are complementary surfaces, not competing CLI models.

## Runtime Model

OpenClaw runtimes are mutable systems.

The runtime state model is:

```text
baseline runtime configuration
  + skill and plugin deployments
  + deployment-event replay scripts
  + runtime mutations
  = current runtime state
```

`moltbox-runtime` stores the baseline configuration for each runtime environment.

The live appliance state is larger than that baseline. Native OpenClaw installation flows may change runtime configuration, plugin inventory, and extension state after deployment.

If a runtime must be rebuilt or redeployed as a container, the system restores the baseline and replays recorded deployment events for that environment, including replayable skill and plugin installs since the last full runtime container deploy.

Operator-facing runtime environments are limited to:

- `dev`
- `test`
- `prod`

Internal runtime identifiers such as `openclaw-dev`, `openclaw-test`, and `openclaw-prod` remain implementation details. They belong in deployment and topology documentation, not in the public CLI model.

Checkpointing is the rebasing step in this lifecycle.

Conceptually:

```text
runtime state
  + installed modules
  + runtime configuration
  = new base container image
```

That new baseline may later be stored in Git-backed platform repositories rather than in a traditional container registry.

## Appliance Storage Model

Durable appliance storage is machine-scoped.

Canonical roots:

- `/srv/moltbox-state`
- `/srv/moltbox-logs`

Important state areas include:

- `/srv/moltbox-state/runtime/`
- `/srv/moltbox-state/runtime-snapshots/`
- `/srv/moltbox-state/runtime-baselines/`
- `/srv/moltbox-state/services/`
- `/srv/moltbox-state/deploy/`

These locations hold operational state and recovery artifacts. They are not interchangeable with the Git-backed architecture repositories.

Runtime snapshots exist at more than one level:

- container-level snapshots
- runtime-state snapshots

Those snapshots are operational safety artifacts taken before runtime-mutating operations.

## Operator Model

The primary operator path is:

```text
Workstation
  -> ssh
    -> Moltbox CLI
      -> Gateway
```

Internal agents may call the gateway MCP HTTP endpoint over the appliance network with a bearer token managed by `moltbox gateway token ...`.

## Related Documents

- [CLI Architecture](cli-architecture.md)
- [Repositories](repositories.md)
- [Deployment Models](deployment-models.md)
- [Topology](topology.md)
- [Gateway](../concepts/gateway.md)
- [Runtime](../concepts/runtime.md)
