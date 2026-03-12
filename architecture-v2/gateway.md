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
    -> openclaw container
    -> opensearch container
    -> caddy container
    -> optional service containers
```

## Responsibilities

The gateway container owns:

- CLI implementation
- orchestration logic
- service deployment coordination
- runtime configuration synchronization
- Docker interaction
- runtime monitoring

The gateway does not own:

- product feature definitions
- service topology source of truth
- runtime configuration source of truth
- skill implementation source

Those concerns live in `remram`, `moltbox-services`, `moltbox-runtime`, and `remram-skills`.

## Storage Layout

Durable appliance storage should use machine-scoped roots, not user-home paths.

Canonical roots:

- state: `/srv/moltbox-state`
- logs: `/srv/moltbox-logs`

Subsystem layout beneath those roots:

- `/srv/moltbox-state/gateway/`
- `/srv/moltbox-state/deploy/`
- `/srv/moltbox-state/runtime/`
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

moltbox service deploy openclaw-dev
moltbox service restart caddy

moltbox openclaw reload
moltbox openclaw-dev reload

moltbox skill deploy <skill>
```

Rules:

- namespaces correspond to managed components or orchestration pipelines
- the CLI must not mirror repository layers such as features
- `openclaw` is an alias for `openclaw-prod`

## Gateway-Specific Operations

Gateway self-management is separate from generic service deployment.

Command:

```text
moltbox gateway update
```

That path exists because the gateway cannot deploy itself through the normal `service deploy` pipeline.

## Bootstrap Rule

Gateway bootstrap must remain Git-backed:

1. push changes to Git
2. validate the remote Linux host
3. pull or seed checked-out repositories on the host
4. render and deploy from those host-side Git checkouts

If host-side Git credentials or storage prerequisites are missing, bootstrap should fail explicitly rather than falling back to local file copying.
