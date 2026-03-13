# Ollama Operator Guide

## Purpose

Use Ollama to host and inspect the appliance's local models.

## Normal Operator Actions

Manage the service through the gateway:

```text
moltbox gateway service deploy ollama
moltbox gateway service status ollama
```

Use the native passthrough for model inspection and management:

```text
moltbox ollama pull <model>
moltbox ollama list
moltbox ollama remove <model>
```

Baseline model example used elsewhere in the platform:

```text
ollama/qwen3:8b
```

## What To Check

If local routing is not working:

- confirm the `ollama` service is healthy
- confirm the expected local model is present
- confirm runtimes still point at `http://ollama:11434`
- confirm the local model name still matches runtime policy

## Operational Touchpoints

- gateway service lifecycle
- native `ollama` CLI
- runtime model policy
- Semantic Router local-stage behavior

## Troubleshooting Basics

Common failure cases:

- the service is down
- the required local model is missing
- runtime provider config drifted away from the real service endpoint
- model inventory changed without corresponding runtime config updates

## TODO

- document the preferred operator workflow for model pre-pull, upgrade, and cleanup once the current Ollama service definition is fully restored into the active service repo
