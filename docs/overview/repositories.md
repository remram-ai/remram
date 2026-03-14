# Repositories

This document describes the repository ownership model for the current Moltbox and RemRam architecture.

The main rule is simple:

- `RemRam` repositories own product definitions and portable capability
- `Moltbox` repositories own appliance behavior and platform operations

## Core Repositories

### `remram`

Purpose:

- architecture documentation
- platform registry documentation
- ecosystem-level explanation

Owns:

- the Architecture V2 documentation set
- `platform/`
- `roadmap/`
- contributor-facing architecture context

Does not own:

- live runtime configuration
- service definitions
- gateway implementation
- skill implementation source

### `remram-skills`

Purpose:

- reusable skill and plugin packages
- deploy recipes for portable runtime capability

Owns:

- plugin source
- skill source
- packaging metadata
- skill-local helper modules
- skill deployment inputs consumed by the gateway

Does not own:

- appliance deployment policy
- baseline runtime configuration
- service topology

### `moltbox-gateway`

Purpose:

- the Moltbox control plane

Owns:

- the `moltbox` CLI
- deployment orchestration
- service lifecycle coordination
- runtime deployment-event tracking
- deployment metadata writing
- Docker interaction on the appliance

Does not own:

- service definitions as source material
- baseline runtime configuration as source material
- skill implementation code

### `moltbox-runtime`

Purpose:

- baseline configuration for each managed runtime environment
- Git-backed baseline artifact store for promoted runtime rebases

Owns:

- environment baseline configuration
- runtime configuration templates
- promoted checkpoint baselines once they are intentionally adopted
- Git-stored runtime baseline artifacts produced by checkpointing when they are promoted

Does not own:

- full live runtime state
- operational snapshots
- deployment replay history
- service deployment definitions

### `moltbox-services`

Purpose:

- service definitions and steady-state service topology

Owns:

- container definitions
- service deployment topology
- service-level build and runtime metadata
- first-class appliance services such as `gateway`, `opensearch`, `ollama`, `caddy`, and the OpenClaw runtime containers

Does not own:

- roadmap feature documentation
- skill packages
- runtime deployment-event history

## Adjacent Ecosystem Repositories

Repositories such as `remram-cortex` and `remram-app` are adjacent ecosystem projects.

They are intentionally out of scope for this platform pass because they do not currently define the core appliance control-plane architecture.

## Repository Interaction Model

The repositories interact like this:

```text
remram
  -> defines platform items, roadmap artifacts, and architecture

remram-skills
  -> provides reusable capability packages

moltbox-runtime
  -> provides baseline runtime configuration

moltbox-services
  -> provides service definitions

moltbox-gateway
  -> orchestrates deployment and runtime behavior on the appliance
```

Another useful way to read the flow is:

```text
Roadmap item
  -> Plugin if needed
  -> Skill
  -> Runtime baseline
  -> Service topology if needed
  -> Gateway deployment and orchestration
```

## Host Repository Access

Moltbox hosts pull private platform repositories with GitHub App installation tokens.

The host-side model is:

- do not use SSH deploy keys for private repository access
- keep the GitHub App private key on the host at `/home/jpekovitch/.ssh/remram_deploy.pem`
- let bootstrap tooling or the gateway exchange that key for a short-lived installation token
- use HTTPS Git URLs in the form `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`

The required private repositories for the bootstrap and deployment path are:

- `remram-ai/moltbox-gateway`
- `remram-ai/moltbox-services`
- `remram-ai/moltbox-runtime`

Current GitHub App metadata for this host bootstrap path:

- App ID `3071584`
- Installation ID `115774577`

## Ownership Boundaries

The most important repository boundaries are:

- `remram` documents what the system is supposed to do
- `remram-skills` packages reusable capability
- `moltbox-runtime` defines the baseline starting point for each runtime
- `moltbox-services` defines what containers exist on the appliance
- `moltbox-gateway` turns those inputs into a running appliance

This boundary is especially important for runtime mutation:

- baseline runtime configuration belongs in `moltbox-runtime`
- live runtime mutation belongs in appliance state
- deployment-event history belongs to the gateway control plane
- checkpoint promotion may move a rebased runtime baseline back into Git intentionally, but that is different from mirroring live runtime state continuously

## TODO

- document the exact representation of Git-stored runtime baseline artifacts once the checkpoint promotion contract is finalized
- document the promotion path for checkpoint baselines once the repo/path contract is finalized

## Related Documents

- [Overview](overview.md)
- [Deployment Models](deployment-models.md)
- [Topology](topology.md)
- [Feature](../concepts/feature.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)
