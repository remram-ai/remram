# Repositories

Core repository ownership:

- `remram`: architecture, shared docs, feature docs, backlog
- `remram-skills`: reusable skills and plugin packages
- `moltbox-gateway`: control plane, CLI, deployment orchestration
- `moltbox-runtime`: baseline runtime configuration and promoted runtime baselines
- `moltbox-services`: service definitions and container topology

Boundary rules:

- feature definitions live in `remram`
- implementation lives in the owning domain repo
- live runtime mutation does not get mirrored directly back into Git
- gateway writes deployment metadata and deployment-event history

Host repository access:

- Moltbox hosts access private repositories through GitHub App installation tokens
- the host key path is `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling exchanges App ID `3071584` and Installation ID `115774577` for short-lived tokens
- host Git uses HTTPS token URLs such as `https://x-access-token:<installation_token>@github.com/remram-ai/<repo>.git`
- SSH deploy keys are intentionally not used for the host Git path

Canonical sources:

- [Repositories](../platform/repositories.md)
- [Feature](../concepts/feature.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)
