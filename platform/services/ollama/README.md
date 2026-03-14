# Ollama

Ollama is the local model-hosting service for the Moltbox appliance.

It gives the runtimes a nearby model provider for low-latency, low-cost local reasoning.

## What Role It Plays

Ollama is the default local model service behind the appliance's local-first posture.

In the current system it is used to:

- host the primary local routing model
- back the local stage of Semantic Router
- provide a runtime-local model provider at `http://ollama:11434`
- provide the current baseline local model example `ollama/qwen3:8b`

## Moltbox Model Philosophy

Moltbox does not treat Ollama as a general-purpose public model endpoint.

The local model philosophy is:

- keep cheap and fast reasoning local when possible
- use local models as the first stage, not the only stage
- escalate to stronger remote providers only when the request needs it

That makes Ollama part of the routing strategy, not just a convenience sidecar.

## Main Moving Parts

- runtime model policy in `model-runtime.yml`
- runtime routing policy in `routing.yaml`
- the OpenClaw provider config pointing at `http://ollama:11434`
- the gateway and service-layer component model that treats `ollama` as a first-class appliance service

## How It Interacts With Other Components

- OpenClaw runtimes call it as the local provider
- Semantic Router uses it as the first routing tier
- the gateway exposes it through the service lifecycle and passthrough CLI model

## Operator View

Operators manage the service through the gateway lifecycle surface:

```text
moltbox gateway service deploy ollama
moltbox gateway service status ollama
```

The CLI also reserves the native service passthrough:

```text
moltbox ollama <native command>
```

Common native model lifecycle operations:

```text
moltbox ollama pull <model>
moltbox ollama list
moltbox ollama remove <model>
```

Moltbox does not define a second model-management abstraction on top of those native commands.

## Related Documents

- [Specification](spec.md)
- [Test Plan](test-plan.md)
- [Operator Guide](operator-guide.md)
- [Platform Topology](../../../docs/overview/topology.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
