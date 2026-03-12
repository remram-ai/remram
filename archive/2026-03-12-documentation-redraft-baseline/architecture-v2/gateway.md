# Gateway

The gateway is the Moltbox control plane.

## Host Baseline

Moltbox currently targets a Linux host appliance.

- the authoritative runtime is the remote appliance host, not the operator workstation
- bootstrap and deployment must validate the remote host OS before doing path-dependent work
- Windows-host deployment is out of scope for now
- containers share the Linux kernel of the host

Current validated host class:

- Ubuntu 24.04.x LTS
- Docker Engine on the appliance host

Steady-state topology:

```text
Host OS
  -> Docker Engine
    -> gateway container
    -> openclaw runtime containers
    -> opensearch container
    -> caddy container
    -> optional service containers
```

## Container Naming Convention

Steady-state container names should not use the `moltbox-` prefix.

The appliance itself is already the namespace, so container identities should be simple and stable.

Canonical examples:

- `gateway`
- `opensearch`
- `ollama`
- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`
- `caddy`

Legacy `moltbox-*` container names should be treated as transitional drift rather than target naming.

## Responsibilities

The gateway container owns:

- CLI implementation
- orchestration logic
- service deployment coordination
- runtime configuration synchronization
- skill and plugin deployment orchestration through native OpenClaw installation flows
- Docker interaction
- runtime monitoring
- authoritative deployment-state writes for every deployment path

The gateway does not own:

- product feature definitions
- service topology source of truth
- runtime configuration source of truth
- skill implementation source

Those concerns live in `remram`, `moltbox-services`, `moltbox-runtime`, and `remram-skills`.

## Deployment Metadata Authority

The gateway deployment pipeline is the authoritative writer of deployment state.

That includes:

- generic service deployment
- gateway self-update
- runtime-oriented deployment paths

Canonical deployment metadata includes service-state records such as:

- `last-success.json`
- rollback and snapshot state
- active render references

All deployment paths must update those records consistently.

If deployment metadata disagrees with the rendered artifact or running container state, that is an implementation defect in the deployment pipeline, not a change in architecture.

## Storage Layout

Durable appliance storage should use machine-scoped roots, not user-home paths.

Canonical roots:

- state: `/srv/moltbox-state`
- logs: `/srv/moltbox-logs`

Subsystem layout beneath those roots:

- `/srv/moltbox-state/gateway/`
- `/srv/moltbox-state/deploy/`
- `/srv/moltbox-state/runtime/`
- `/srv/moltbox-state/runtime-baselines/`
- `/srv/moltbox-state/services/`
- `/srv/moltbox-state/upstream/`
- `/srv/moltbox-state/repos/`
- `/srv/moltbox-logs/gateway/`
- `/srv/moltbox-logs/services/`

Legacy user-home paths such as `~/.remram` and `~/Moltbox` should be treated as interim current-state behavior, not the long-term appliance layout.

## CLI Model

The CLI grammar is:

```text
moltbox <component> <command>
```

Examples:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway repo refresh runtime

moltbox runtime checkpoint openclaw-test

moltbox service deploy openclaw-dev
moltbox service restart caddy

moltbox openclaw reload
moltbox openclaw-dev reload

moltbox skill deploy <skill>
```

Rules:

- namespaces correspond to managed components or orchestration pipelines
- the CLI must not mirror repository layers such as features
- `runtime` may be used as an orchestration namespace for cross-runtime operations such as checkpoint management; it does not restore the old `moltbox runtime <env> ...` command family
- `openclaw` is an alias for `openclaw-prod`

## Gateway-Specific Operations

Gateway self-management is separate from generic service deployment.

Command:

```text
moltbox gateway update
```

That path exists because the gateway cannot deploy itself through the normal `service deploy` pipeline.

The gateway also owns host-side upstream mirror maintenance for the external repositories it uses during deploy and runtime sync.

Examples:

```text
moltbox gateway repo refresh
moltbox gateway repo seed runtime --bundle /path/to/moltbox-runtime.bundle
```

## Bootstrap Rule

Gateway bootstrap must remain Git-backed:

1. push changes to Git
2. validate the remote Linux host
3. pull or seed checked-out repositories on the host
4. render and deploy from those host-side Git checkouts

If host-side Git credentials or storage prerequisites are missing, bootstrap should fail explicitly rather than falling back to local file copying.

## Appliance Host Model

The Moltbox appliance host should run minimal host-side services only.

Host OS responsibilities are limited to:

- container runtime
- system services such as `systemd` and `ssh`
- filesystem mounts and durable storage
- the Moltbox operator CLI entrypoint

Long-running application logic should run inside containers, not directly on the host OS.

Normal operator interaction should happen through the Moltbox CLI rather than ad hoc Docker commands.

The host CLI entrypoint may be implemented as a thin wrapper that invokes the gateway control plane inside the running `gateway` container.
