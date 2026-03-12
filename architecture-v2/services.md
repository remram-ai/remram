# Services

Service definitions and deployment topology come from:

```text
moltbox-services/services/<service>/
```

The gateway must read these definitions through repository adapters.

Host-side bootstrap and deployment should remain Git-backed. The authoritative service repo is pulled or seeded onto the appliance host first, then rendered and deployed from the checked-out host repository. Ad hoc file copying is not part of the deployment model.

## Service Identity

Environments are encoded as distinct service names.

Examples:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

Alias rule:

- `openclaw` resolves to `openclaw-prod`

## Deployment Pipeline

Command:

```text
moltbox service deploy <service>
```

`service` is a deployment pipeline, not a container namespace.

Canonical flow:

1. snapshot service state
2. resolve the selected service definition and artifact
3. pull the container image
4. stop the existing container
5. start the replacement container
6. remount persistent state
7. run health checks
8. rollback on failure

Before deployment, the gateway must ensure the remote host has already been validated as Linux and that the durable appliance roots are available under the machine-scoped storage layout.

## Promotion Rules

Artifact selection is service-aware and environment-aware.

- dev deploys the newest candidate
- test deploys the latest approved candidate
- prod deploys the approved stable artifact

Explicit overrides remain available:

```text
--version <tag>
--commit <sha>
```
