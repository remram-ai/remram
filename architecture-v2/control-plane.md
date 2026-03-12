# Moltbox Control Plane V2

Moltbox is the local appliance control plane for a containerized edge system.

Steady-state topology:

```text
Host OS
  -> Docker Engine
    -> gateway container
    -> openclaw container
    -> opensearch container
    -> caddy container
    -> optional service containers
```

The gateway container owns:

- CLI implementation
- orchestration logic
- Docker interaction
- service deployment
- runtime monitoring
- runtime configuration synchronization

System rules:

- containers are disposable executables
- durable state lives on the host filesystem
- host state is mounted into containers
- the control plane manages appliance behavior, not product semantics

The control plane operates on:

- gateway lifecycle
- service deployment definitions
- runtime configuration synchronization
- service health and diagnostics
- artifact promotion decisions

The control plane does not own:

- product feature definition
- portable skill implementation
- independent subsystem source trees

Those concerns live in other repositories and are consumed by the gateway through defined interfaces.
