# Plugin

A Plugin is an OpenClaw extension module that runs inside the OpenClaw gateway process.

Plugins are the runtime-extension layer for OpenClaw-backed deliverables.

## Where Plugins Live

In the current RemRam repository model:

- plugin capability definitions live under `remram/platform/plugins/`
- plugin package source lives in `remram-skills`
- baseline service config that enables a plugin belongs in `moltbox-services`
- final deployable runtime artifacts live in `moltbox-runtime`
- deployment orchestration and snapshot-aware runtime mutation handling belong in `moltbox-gateway`

## What A Plugin Can Do

Per current OpenClaw documentation, plugins can register or expose:

- agent tools
- CLI commands
- gateway RPC methods
- gateway HTTP routes
- background services
- context engines
- plugin-shipped skills

Each plugin must ship an `openclaw.plugin.json` manifest in the plugin root.

Current manifest contract highlights:

- required keys are `id` and `configSchema`
- manifests may also declare `kind`, `channels`, `providers`, `skills`, `name`, `description`, `uiHints`, and `version`
- manifest validation happens without executing plugin code

## Plugin Versus Skill

A [Skill](skill.md) is a portable capability package.

A plugin is executable extension code inside OpenClaw itself.

A skill may depend on one or more plugins, and a plugin may ship skills, but they are not the same concept.

## Plugin Versus Service

A [Service](service.md) is a long-running container on the appliance.

A plugin runs in-process with the OpenClaw gateway. It is not a separate appliance container.

## Trust Boundary

Plugins run with the same process-level trust boundary as the OpenClaw gateway.

That means plugin installs are runtime-mutating operations and should be treated like trusted code deployment rather than like harmless configuration toggles.

## Related Concepts

- [Skill](skill.md)
- [Runtime](runtime.md)
- [Service](service.md)
- [Gateway](gateway.md)
