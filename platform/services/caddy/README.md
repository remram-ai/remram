# Caddy

Caddy is the appliance entry-point service.

It is the front door that terminates HTTP or HTTPS traffic and routes requests to the correct internal Moltbox service.

Ingress path:

```text
Internet -> Caddy -> Gateway / Runtime services
```

## What Role It Plays

Caddy gives the appliance one stable ingress layer instead of exposing each internal container directly.

In the current platform model it is responsible for:

- TLS termination for appliance hostnames
- routing traffic to the gateway control plane
- routing traffic to the environment runtimes
- providing a simple health surface for ingress validation

## Why It Exists

Without Caddy, operators and tools would have to know individual container ports and direct service endpoints.

Caddy centralizes ingress so the appliance can present a cleaner operator surface and a more consistent network posture.

## High-Level Components

- the `caddy` service definition in `moltbox-services`
- the `Caddyfile` template in `moltbox-runtime`
- the gateway and runtime services that sit behind the reverse proxies
- Caddy-managed state for certificates and runtime configuration

## How It Interacts With Other Components

- forwards `moltbox-cli` traffic to `gateway`
- forwards `moltbox-dev`, `moltbox-test`, and `moltbox-prod` to the corresponding runtime environments
- depends on the gateway and runtime services being reachable on the appliance network or host bridge

## Operator View

Operators usually manage Caddy through the gateway service pipeline:

```text
moltbox gateway service deploy caddy
moltbox gateway service restart caddy
moltbox gateway service status caddy
```

The CLI also reserves a native passthrough namespace for service-specific operations:

```text
moltbox caddy <native command>
```

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Platform Topology](../../../docs/overview/topology.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
