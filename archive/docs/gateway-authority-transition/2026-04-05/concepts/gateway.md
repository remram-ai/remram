# Gateway

The Gateway is the Moltbox control plane.

It is the layer that manages the appliance itself.

## What Gateway Owns

The gateway owns:

- the `moltbox` CLI
- deployment orchestration
- the local encrypted secret store under `/var/lib/moltbox/secrets/`
- service deployment coordination
- runtime lifecycle orchestration
- plugin deployment orchestration
- skill deployment orchestration
- deployment metadata writes
- deployment replay history
- runtime baseline metadata
- host-level gateway self-update history at `/var/lib/moltbox/history.jsonl`
- operator-facing diagnostics and status surfaces

For runtime mutation state, the gateway is the only source of truth under `/srv/moltbox-state`.

That state currently includes:

- deployment history in `/srv/moltbox-state/deploy/history.jsonl`
- per-runtime replay logs in `/srv/moltbox-state/deploy/runtime/<runtime>/replay-log.json`
- staged replay packages in `/srv/moltbox-state/deploy/runtime/<runtime>/packages/`
- checkpoint metadata in `/srv/moltbox-state/runtime-baselines/<runtime>/current.json`
- host-level self-update history in `/var/lib/moltbox/history.jsonl`

## What Gateway Does Not Own

The gateway does not own:

- product and platform item definitions
- service definitions as source material
- baseline runtime configuration as source material
- plugin implementation source
- skill implementation source

Those concerns live in other repositories and are orchestrated by the gateway rather than authored there.

Runtime containers also do not own the authoritative install registry. They only execute deploys and replay installs that the gateway has already recorded in appliance state.

Managed `moltbox <env> skill deploy` on `main` stages pure skill packages only. Plugin-backed packages remain outside that managed path until a separate contract is implemented.

## Operator Path

The primary operator control path is:

```text
Workstation
  -> ssh
    -> Moltbox CLI
      -> Gateway

Internal agent or container
  -> HTTP MCP + bearer token
    -> Gateway
```

Operators should interact with the appliance through the Moltbox CLI.

Docker commands are an internal implementation detail and should not be the normal operator interface.

For secrets, the control path is:

```text
CLI
  -> gateway control-plane API
    -> encrypted secret store
      -> runtime or service env injection
```

There is no public secrets ingress. The gateway process is the only layer that reads and writes the secret store directly from the appliance filesystem.

The supported automation identities are:

- `jason-codex` for restricted SSH CLI automation
- `codex-bootstrap` for break-glass diagnostics with tighter limits outside `dev`

## Gateway In The CLI

Canonical examples:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway logs
moltbox gateway mcp-stdio
moltbox gateway docker ping
moltbox gateway docker run hello-world
moltbox gateway service status gateway
moltbox gateway service deploy opensearch
moltbox gateway service deploy dev
```

Gateway self-mutation is handled by `moltbox gateway update`. `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` are intentionally rejected.

## Related Concepts

- [Plugin](plugin.md)
- [Service](service.md)
- [Runtime](runtime.md)
- [Skill](skill.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../overview/cli-architecture.md)
