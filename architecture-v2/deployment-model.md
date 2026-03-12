# Deployment Model V2

The finalized deployment model separates three distinct control-plane activities.

## 1. Gateway Self-Management

The gateway container is the bootstrap control plane.

It cannot use the normal service deployment path for its own lifecycle.

Gateway update path:

```text
moltbox gateway update
```

Expected lifecycle:

1. prepare replacement artifact
2. preserve gateway state
3. replace the running gateway container
4. verify health
5. rollback on failure

## 2. Service Deployment

Service deployment is the generic container lifecycle path.

Command:

```text
moltbox service deploy <service>
```

Canonical flow:

1. snapshot service state
2. resolve version or artifact selector
3. pull the container image
4. stop the existing container
5. start the replacement container
6. remount persistent state
7. run health checks
8. rollback on failure

Source of truth:

- service definitions are read from `moltbox-services`

## 3. Runtime Configuration Synchronization

Some behavior changes are implemented by configuration, not by replacing service topology.

Commands:

```text
moltbox openclaw config sync
moltbox openclaw reload
```

Canonical flow:

1. pull or refresh `moltbox-runtime`
2. detect the target component config
3. synchronize configuration into the appliance runtime directories
4. reload the target runtime or service
5. report status and diagnostics

Source of truth:

- runtime configuration is read from `moltbox-runtime`

## 4. Environment Model

Environments are represented as service names.

Examples:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

Production alias:

- `openclaw` -> `openclaw-prod`

Environment selection therefore happens by component identity, not by a separate CLI environment flag.
