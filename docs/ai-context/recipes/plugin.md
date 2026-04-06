# Plugin Recipe

Use this recipe when the deliverable is primarily an OpenClaw runtime extension installed through the native plugin lifecycle.

## Use This Type When

- the behavior lives inside a running OpenClaw environment
- the runtime should recognize the extension as a plugin
- the main deployment act is `plugins install`
- the deliverable changes runtime-local behavior, telemetry, tooling, or channels without creating a new appliance container

Current repo example:

- `moltbox-telemetry`

## Do Not Use This Type When

- the deliverable needs a dedicated long-running container on the appliance
- the deliverable is mainly a broader portable capability bundle with policy, prompts, manifests, and helper modules beyond one plugin surface
- the deliverable changes the Moltbox control plane rather than runtime-local behavior

In those cases, use [Service](service.md), [Skill](skill.md), or [Gateway/Core](gateway-core.md).

## Ownership Model

Local ownership usually splits like this:

- `remram`: ecosystem framing and cross-repo summaries
- `remram-skills`: plugin package source and packaging metadata
- `moltbox-services`: baseline service config that enables or configures the plugin when that config is part of an OpenClaw service baseline
- `moltbox-runtime`: final deployable runtime artifact for that plugin-enabled baseline
- `moltbox-gateway`: deployment orchestration, snapshots, deployment events, and environment passthrough

The plugin itself is not a separate appliance service.

## OpenClaw Source Of Record

Check the current upstream docs before implementation:

- [Plugins](https://docs.openclaw.ai/tools/plugin)
- [Plugin Manifest](https://docs.openclaw.ai/plugins/manifest)
- [Plugin Agent Tools](https://docs.openclaw.ai/plugins/agent-tools)
- [Community Plugins](https://docs.openclaw.ai/plugins/community)
- [CLI Plugins](https://docs.openclaw.ai/cli/plugins)
- [Configuration](https://docs.openclaw.ai/configuration)

If the plugin touches a specific OpenClaw subsystem, also read that subsystem's current docs before designing the package.

## Capabilities

A plugin is a good fit when the deliverable needs to extend runtime behavior such as:

- diagnostics and telemetry shaping
- tool registration or tool-adjacent behavior
- channel integrations already supported by OpenClaw
- runtime-local policy or response shaping
- plugin-defined config under `plugins.entries.<id>.config`
- gateway RPC, HTTP routes, CLI commands, or background services registered from plugin code

## Limitations

Assume these limits unless upstream docs say otherwise:

- install state is runtime-local and can drift from Git baselines
- plugin deployment is a runtime mutation, not a service deployment
- plugin changes can require reload or restart semantics defined by the current OpenClaw build
- plugins should not introduce a second control plane beside gateway and native OpenClaw lifecycle
- plugins run in-process with the OpenClaw gateway and are not sandboxed

## Implementation Recipe

1. Define the operator-visible capability and the runtime evidence that proves it works.
2. Confirm the upstream plugin contract, manifest shape, and lifecycle commands in current OpenClaw docs.
3. Implement the plugin package in `remram-skills`, including `openclaw.plugin.json` in the plugin root.
4. Add the baseline config in `moltbox-services` when it is part of the service-owned OpenClaw baseline, and only keep the final deployable artifact in `moltbox-runtime`.
5. Document the plugin in its owning repo and keep `remram` as the ecosystem pointer rather than the detailed plugin authority.
6. State the runtime mutation impact explicitly: snapshots, restart or reload requirements, and recovery implications.
7. Keep the deliverable thin around native OpenClaw behavior rather than rebuilding a parallel plugin framework in Moltbox.

## Deployment Method

Primary deployment path uses native OpenClaw lifecycle through the appliance surfaces:

```text
moltbox test openclaw plugins ...
moltbox prod openclaw plugins ...
```

Current upstream plugin command family to preserve through passthrough:

```text
openclaw plugins list
openclaw plugins info <id>
openclaw plugins enable <id>
openclaw plugins disable <id>
openclaw plugins install <path-or-spec>
openclaw plugins uninstall <id>
openclaw plugins doctor
openclaw plugins update <id>
openclaw plugins update --all
```

Expected lifecycle posture:

- gateway records snapshot and deployment metadata around the mutation
- OpenClaw performs the native plugin install
- plugin config changes follow the current native OpenClaw restart or reload requirements
- promote across `test` and `prod` deliberately

## Testing Surfaces

Always test these surfaces:

- native install and inspection commands such as `plugins install`, `plugins list`, and `plugins info`
- runtime config posture required by the plugin
- the operator-visible behavior the plugin is meant to add
- diagnostics and logs that prove the plugin is active
- failure cases for trust, config, missing dependencies, and environment drift
- promotion behavior across `test` and `prod`

## Common Combination Pattern

Many RemRam skills are plugin-backed. If the deliverable needs more than one plugin plus runtime policy and packaging metadata, the primary type is often [Skill](skill.md) even though installation still reaches OpenClaw through the plugin lifecycle.
