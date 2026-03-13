# Gateway

The Gateway is the Moltbox control plane.

It is the layer that manages the appliance itself.

## What Gateway Owns

The gateway owns:

- the `moltbox` CLI
- deployment orchestration
- service deployment coordination
- runtime lifecycle orchestration
- skill deployment orchestration
- deployment metadata writes
- deployment replay history
- operator-facing diagnostics and status surfaces

## What Gateway Does Not Own

The gateway does not own:

- product feature definitions
- service definitions as source material
- baseline runtime configuration as source material
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
```

## Related Concepts

- [Service](service.md)
- [Runtime](runtime.md)
- [Skill](skill.md)
- [Deployment Event](deployment-event.md)
- [CLI Architecture](../platform/cli-architecture.md)
