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
- operator-facing diagnostics and status surfaces

## What Gateway Does Not Own

The gateway does not own:

- product and platform item definitions
- service definitions as source material
- baseline runtime configuration as source material
- plugin implementation source
- skill implementation source

Those concerns live in other repositories and are orchestrated by the gateway rather than authored there.

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

For secrets, the control path is local:

```text
CLI
  -> gateway command handler
    -> local secret store
      -> runtime or service env injection
```

There is no network API for secrets. The gateway process reads and writes the secret store directly from the appliance filesystem.

The supported automation identities are:

- `jason-codex` for restricted SSH CLI automation
- `codex-bootstrap` for break-glass diagnostics with tighter limits outside `dev`

## Gateway In The CLI

Canonical examples:

```text
moltbox gateway status
moltbox gateway update
moltbox gateway logs
moltbox gateway service deploy opensearch
moltbox gateway service deploy dev
```

## Related Concepts

- [Plugin](plugin.md)
- [Service](service.md)
- [Runtime](runtime.md)
- [Skill](skill.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../overview/cli-architecture.md)
