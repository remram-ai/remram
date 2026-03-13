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

- product feature definitions
- service definitions as source material
- baseline runtime configuration as source material
- plugin implementation source
- skill implementation source

Those concerns live in other repositories and are orchestrated by the gateway rather than authored there.

## Operator Path

The primary operator control path is:

```text
Visual Studio
  -> MCP plugin
    -> Moltbox CLI
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

TODO:

- confirm the exact long-term contract between the MCP plugin, the CLI, and the gateway, including where authentication, target selection, and remote policy enforcement are documented
- confirm whether the thin host `moltbox` wrapper remains a required appliance contract or only a convenience layer

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
- [CLI Architecture](../platform/cli-architecture.md)
