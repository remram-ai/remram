# Ollama Specification

## Purpose

Ollama is the local model-hosting service for the Moltbox appliance.

It is a first-class baseline service because the runtimes depend on it for their local-first execution model.

## Implementation Surfaces

Primary evidence:

- `moltbox-services/services/ollama/service.yaml`
- `moltbox-services/services/ollama/compose.yml.template`
- `moltbox-runtime/openclaw-*/openclaw.json.template`
- `moltbox-runtime/openclaw-*/model-runtime.yml`
- `moltbox-runtime/openclaw-*/routing.yaml`
- `moltbox-gateway/internal/orchestrator/manager.go`

## Architecture Components

The service depends on:

1. runtime provider config that points OpenClaw at `http://ollama:11434`
2. runtime model policy that treats Ollama as the local routing provider
3. gateway component and service model that treats `ollama` as a first-class service
4. operator-visible model management through the native `ollama` CLI

## Configuration Model

Current runtime-facing posture:

- OpenClaw provider `ollama` is configured with `baseUrl: http://ollama:11434`
- runtime defaults use `ollama/qwen3:8b` as the local primary model
- routing policy treats `ollama` as the local provider for the local-first strategy

The service is expected to remain internal to the appliance and reachable by the runtimes over the appliance network.

## Lifecycle

Typical lifecycle:

1. deploy or update the `ollama` service
2. ensure the expected local models are present
3. validate runtime connectivity to `http://ollama:11434`
4. confirm runtime model policy still matches the available local models

## Dependencies

Required dependencies:

- an `ollama` service reachable on the appliance network
- runtime model policy aligned with the locally hosted models
- healthy runtime-to-service connectivity

Operational dependencies:

- model inventory must match the local-first routing contract
- model management should stay disciplined so runtimes do not drift from expected local model names

## Runtime Behavior

Observed baseline behavior:

- runtimes treat Ollama as the local routing provider
- Semantic Router expects Ollama for its local stage
- local model hosting is part of the answer-first posture before remote escalation

## Model Management Expectations

Operators should treat Ollama as a managed appliance dependency, not an ad hoc model sandbox.

Expected posture:

- keep the required baseline models available
- use the native `ollama` CLI for service-local model inspection and management
- align runtime config and local model inventory before promoting environments

Canonical native lifecycle examples:

```text
moltbox ollama pull <model>
moltbox ollama list
moltbox ollama remove <model>
```

Moltbox should not add a second abstraction layer for model inventory management when the native Ollama lifecycle already exists.

## Constraints And Edge Cases

- if Ollama is unavailable, local-first routing loses its first stage
- if the expected model is missing, the runtime may degrade or fail at the local stage
- if runtime model policy and actual local model inventory drift, routing behavior becomes unpredictable

## TODO

- document the baseline local model inventory contract once the model set is frozen beyond the current `qwen3:8b` posture
