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
- long-running application logic runs in containers
- runtime state is mutable and may outlive individual container instances

Canonical sources:

- [Topology](../platform/topology.md)
- [Deployment Models](../platform/deployment-models.md)
