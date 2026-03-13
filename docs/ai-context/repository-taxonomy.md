# Repository Taxonomy

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

Canonical sources:

- [Repositories](../platform/repositories.md)
- [Feature](../concepts/feature.md)
- [Skill](../concepts/skill.md)
- [Service](../concepts/service.md)
- [Runtime](../concepts/runtime.md)
- [Gateway](../concepts/gateway.md)
