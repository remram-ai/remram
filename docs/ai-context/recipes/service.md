# Service Recipe

Use this recipe when the deliverable is primarily a containerized appliance process with its own lifecycle on the Moltbox host.

## Use This Type When

- the capability needs a long-running container
- it needs health checks, networking, storage, or its own logs
- operators need a service lifecycle such as deploy, restart, or status
- the runtime consumes the capability over the appliance network

Current repo examples:

- `ollama`
- `caddy`
- `searxng`

## Do Not Use This Type When

- the behavior should live inside an existing runtime as an OpenClaw extension
- the capability is mainly a portable skill bundle
- the change is really about gateway orchestration or the CLI contract

In those cases, use [Plugin](plugin.md), [Skill](skill.md), or [Gateway/Core](gateway-core.md).

## Ownership Model

Local ownership usually splits like this:

- `remram`: ecosystem framing and cross-repo summaries
- `moltbox-services`: service definition, baseline config examples, service metadata, and service docs
- `moltbox-gateway`: service deployment pipeline, status, restart, rollback posture, and deployment metadata
- `moltbox-runtime`: final deployable runtime artifacts when the service needs them

The service definition does not belong in `remram`.

## OpenClaw Source Of Record

For the live service lifecycle contract, use `moltbox-gateway` and the owning service repo.

For the OpenClaw-facing runtime contract, read the current upstream page that matches what the service feeds:

- [Configuration](https://docs.openclaw.ai/configuration)
- [Models](https://docs.openclaw.ai/models)
- [Tools](https://docs.openclaw.ai/tools)
- [Channels](https://docs.openclaw.ai/channels)

Do not assume one generic upstream page is enough. The relevant OpenClaw source depends on whether the service is acting as a model provider, retrieval backend, ingress dependency, or another runtime-facing component.

## Capabilities

A service is a good fit when the deliverable needs:

- a stable network identity on the appliance
- its own durability and storage posture
- operator-visible lifecycle commands
- shared use across multiple runtime environments
- a native service CLI passthrough only when that passthrough is part of the current public CLI contract

## Limitations

Assume these limits unless the platform changes:

- services are appliance deployment units, not standalone platform definitions
- services should not be managed by direct Docker commands during normal operations
- runtime health and service health are related but separate
- a service can be healthy while runtime config that points at it is wrong
- services still need a plugin, skill, or runtime-config surface if OpenClaw must consume them
- the default expectation is one shared service serving the appliance, not one duplicate service per environment

## Implementation Recipe

1. Define the service contract in operator terms: what the appliance gains and which runtimes consume it.
2. Place the service definition and baseline config in `moltbox-services`.
3. Define how gateway deploys, restarts, validates, and reports the service.
4. If the service needs final promoted runtime artifacts, add those to `moltbox-runtime`.
5. If the service has a native CLI and the public contract actually exposes it, preserve that through a thin passthrough instead of inventing a second abstraction.
6. Document the service in the owning service repo rather than creating a competing copy in `remram`.
7. State the network endpoint, health model, persistence needs, and upgrade or rollback posture explicitly.
8. If the service feeds OpenClaw, define the plugin, skill, or runtime-config surface that exposes it to the runtime.

## Deployment Method

Primary deployment path:

```text
moltbox service deploy <service>
```

Related lifecycle surfaces:

```text
moltbox service restart <service>
moltbox service status <service>
```

If the service has a native CLI and the current public contract exposes it, preserve the passthrough:

```text
moltbox <service> <native command>
```

## Testing Surfaces

Always test these surfaces:

- service deploy, restart, and status behavior
- health checks after deploy
- runtime connectivity to the service over the appliance network
- persistent state or mounted volume behavior when applicable
- native CLI passthrough when one exists
- negative cases for missing config, bad credentials, missing models or indexes, and runtime-to-service drift
- promotion and rollback behavior when the service is updated

## Common Combination Pattern

A deliverable often combines a service with either a skill or runtime config. For example, a model host or retrieval backend is a service, while the final promoted runtime artifact that points at it belongs in `moltbox-runtime` and sometimes in a [Skill](skill.md).
