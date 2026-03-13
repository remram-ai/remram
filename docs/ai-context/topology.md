# Topology

Steady-state appliance topology:

```text
Host OS
  -> Docker Engine
    -> gateway
    -> caddy
    -> opensearch
    -> ollama
    -> openclaw-dev
    -> openclaw-test
    -> openclaw-prod
```

Ingress path:

```text
Internet -> Caddy -> Gateway / Runtime services
```

Storage roots:

- `/srv/moltbox-state`
- `/srv/moltbox-logs`

Key model:

- the host stays minimal
- Docker Engine is host infrastructure, not the primary operator surface
- long-running application logic runs in containers
- the gateway is the control plane that coordinates service deployment and runtime lifecycle
- runtime state is mutable and may outlive individual container instances

Service relationship model:

- service definitions and compose templates live in `moltbox-services`
- the gateway consumes those definitions and deploys them onto the host Docker engine
- operators and builders should reason through `moltbox gateway ...` and `moltbox gateway service ...` before dropping to Docker details
- direct Docker commands are break-glass diagnostics, not the normal management path

Host Git model:

- the host keeps a local GitHub App private key at `/home/jpekovitch/.ssh/remram_deploy.pem`
- bootstrap tooling generates short-lived installation tokens for host-side Git access
- host repository access uses HTTPS token URLs; SSH deploy keys are not part of the target topology

Canonical sources:

- [Topology](../platform/topology.md)
- [Repositories](../platform/repositories.md)
- [Deployment Models](../platform/deployment-models.md)
- [Gateway](../concepts/gateway.md)
- [Service](../concepts/service.md)
