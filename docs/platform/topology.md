# Topology

This document describes the steady-state Moltbox appliance topology.

The appliance is a Linux host running a small set of managed containers with the gateway as the control plane.

## Host Model

The host should remain minimal.

Allowed host responsibilities:

- container runtime
- system services such as `systemd` and `ssh`
- storage mounts and durable filesystem roots
- a thin Moltbox entrypoint wrapper if present

Long-running application logic belongs in containers, not directly on the host OS.

## Steady-State Topology

```text
Host OS
  -> Docker Engine
    -> gateway
    -> caddy
    -> opensearch
    -> ollama
    -> openclaw-dev
    -> openclaw-test
    -> openclaw-prod
```

Steady-state container names should not use the `moltbox-` prefix.

Legacy `moltbox-*` names are transitional drift, not part of the target topology.

These container identities are platform implementation names.

They are not the public CLI namespaces used by operators.

## Core Roles

### `gateway`

The control plane.

It owns:

- CLI handling
- deployment orchestration
- service lifecycle coordination
- runtime deployment-event history
- deployment metadata

### `openclaw-dev`, `openclaw-test`, `openclaw-prod`

The runtime environments.

These are the live OpenClaw systems that execute runtime behavior for each environment tier.

In the operator CLI, these environments are addressed only as:

- `dev`
- `test`
- `prod`

The internal container identities remain implementation details.

### `opensearch`

Shared search and indexing service for the appliance.

### `ollama`

First-class model-serving appliance service.

This service is part of the target topology even where implementation work is still catching up.

### `caddy`

Ingress and routing service.

It terminates and routes appliance traffic to the appropriate internal services.

## Relationship Model

At a high level:

```text
Visual Studio
  -> MCP plugin
    -> Moltbox CLI
      -> gateway
        -> service deployment and status
        -> runtime deployment events
        -> appliance state

caddy
  -> routes external traffic to gateway and runtime/service surfaces

openclaw environments
  -> use opensearch and ollama as supporting services
```

The MCP plugin should remain a thin wrapper around the CLI so both operator entry paths stay equivalent.

The gateway does not replace the native service CLIs.

Instead, the CLI exposes passthrough namespaces for selected services such as `ollama`, `opensearch`, and `caddy`.

## Appliance Storage Topology

The container topology depends on machine-scoped storage roots:

- `/srv/moltbox-state`
- `/srv/moltbox-logs`

Important subareas include:

- `/srv/moltbox-state/runtime/`
- `/srv/moltbox-state/runtime-snapshots/`
- `/srv/moltbox-state/runtime-baselines/`
- `/srv/moltbox-state/services/`
- `/srv/moltbox-state/deploy/`

These storage roots preserve mutable appliance state independently of individual container restarts or replacements.

## Topology Rules

- the appliance host is already the namespace, so container names should stay simple
- runtime environments are separate containers, not just profiles inside one runtime process
- the gateway is the only control-plane entrypoint
- the public CLI uses `dev`, `test`, and `prod` rather than internal runtime container names
- operators should not need direct Docker commands for normal management
- runtime state is allowed to outlive individual container instances through appliance storage

## TODO

- document the stable ingress hostnames and port contract once the endpoint documentation is finalized
- document any optional or future service containers separately from the steady-state core topology

## Related Documents

- [Overview](overview.md)
- [Deployment Models](deployment-models.md)
- [CLI Architecture](cli-architecture.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
