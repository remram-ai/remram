# Repositories

This document describes the repository ownership model for the current Moltbox and RemRam architecture.

The main rule is:

- `remram` repositories own architecture, platform definitions, and portable capability
- `moltbox` repositories own appliance behavior and operations

## Core Repositories

### `remram`

Owns:

- architecture documentation
- platform registry documentation
- roadmap and ecosystem framing
- audit reports and unresolved architecture notes

Does not own:

- live runtime configuration
- service definitions
- gateway implementation
- skill or plugin implementation source

### `remram-skills`

Owns:

- reusable skill packages
- plugin packages
- packaging metadata and helper assets
- deployment inputs consumed by the gateway

Does not own:

- appliance deployment policy
- service topology
- baseline runtime source of record

### `moltbox-gateway`

Owns:

- the `moltbox` CLI
- the gateway control plane
- service lifecycle orchestration
- runtime replay and checkpoint orchestration
- deployment metadata writing
- Docker interaction on the appliance

Does not own:

- service definitions as source material
- baseline runtime configuration as source material
- skill or plugin implementation source

### `moltbox-runtime`

Owns:

- baseline configuration for each managed runtime environment
- promoted checkpoint baselines once they are intentionally adopted

Does not own:

- full live runtime state
- gateway replay history
- service deployment definitions

### `moltbox-services`

Owns:

- steady-state service definitions
- compose topology and service build metadata
- first-class appliance services such as `gateway`, `opensearch`, `ollama`, `caddy`, and the runtime containers

Does not own:

- feature documentation
- skill packages
- runtime replay history

## Release Model

The repository and appliance release contract is:

- repository `main` is the next appliance release line
- tagged revisions are the release inputs an appliance should run
- a running appliance should be treated as a tagged release until it is intentionally updated

Current implementation note:

- `moltbox gateway update` applies whatever revision the configured host checkout points at
- release appliances should therefore pin host checkouts to the intended tag or release branch rather than tracking `main` implicitly
- `main` remains appropriate for development and next-release integration work

## Repository Interaction Model

```text
remram
  -> defines architecture, platform items, and roadmap intent

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

## Runtime Mutation Boundary

The repository split matters most for runtime mutation:

- baseline runtime configuration belongs in `moltbox-runtime`
- live runtime mutation belongs in appliance state under `/srv/moltbox-state`
- replay history and checkpoint metadata belong to `moltbox-gateway`
- checkpoint promotion may intentionally move a rebased runtime baseline back into Git, but that is not the same thing as mirroring live runtime state continuously

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

## Related Documents

- [Overview](overview.md)
- [Deployment Models](deployment-models.md)
- [Topology](topology.md)
- [Feature](../concepts/feature.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)
