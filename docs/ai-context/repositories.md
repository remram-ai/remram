# Repositories

Core repository ownership:

- `remram`: architecture, shared docs, roadmap docs, and platform registry docs
- `remram-skills`: reusable skills and plugin packages
- `moltbox-gateway`: control plane, CLI, deployment orchestration, and Docker interaction on the appliance
- `moltbox-runtime`: baseline runtime configuration and promoted runtime baselines
- `moltbox-services`: service definitions and container topology

Boundary rules:

- feature definitions and platform item docs live in `remram`
- implementation lives in the owning domain repo
- service definitions and compose templates live in `moltbox-services`
- gateway orchestration consumes those service definitions rather than redefining them
- baseline runtime configuration belongs in `moltbox-runtime`
- live runtime mutation does not get mirrored directly back into Git
- gateway writes deployment metadata and deployment-event history

Execution model:

- `moltbox-services` defines what containers exist on the appliance
- `moltbox-gateway` turns those inputs into a running appliance
- `moltbox-runtime` provides the baseline starting point for each runtime
- appliance state under `/srv/moltbox-state` holds mutable live state

Host repository access:

- Moltbox hosts access private repositories through GitHub App installation tokens
- the host key path is `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling exchanges App ID `3071584` and Installation ID `115774577` for short-lived tokens
- host Git uses HTTPS token URLs such as `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`
- SSH deploy keys are intentionally not used for the host Git path

Canonical sources:

- [Roadmap](../../roadmap/README.md)
- [Repositories](../overview/repositories.md)
- [Topology](../overview/topology.md)
- [Deployment Models](../overview/deployment-models.md)
- [Feature](../concepts/feature.md)
- [Plugin](../concepts/plugin.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)
