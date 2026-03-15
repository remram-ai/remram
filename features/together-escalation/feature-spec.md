# Together Escalation Feature Spec

## Feature Summary

- Feature name: together-escalation
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: local-first chat with Together-backed fallback recovery
- In scope: Together-backed reasoning and coding model chains
- In scope: gateway-managed secret flow for Together credentials
- Out of scope: a standalone Together service container
- Out of scope: manual provider selection by end users on every request

## User Experience

Users and operators should be able to treat the runtime as local-first under normal conditions while still getting successful completion when the local model fails through a fallback-eligible path.

## Functional Requirements

- the default chat path starts on `ollama/qwen3:8b`
- fallback chat recovery uses `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`
- reasoning and coding use their documented Together model chains
- `TOGETHER_API_KEY` flows through the gateway-managed secret system
- runtime logs or model surfaces expose the effective model path without leaking secrets

## Dependencies

- the `together-escalation` skill package in `remram-skills`
- runtime baseline config in `moltbox-runtime`
- a healthy local `ollama` service for the primary chat path
- gateway-managed secret injection for `TOGETHER_API_KEY`

## Acceptance Criteria

- normal chat stays local when Ollama is healthy
- fallback recovers to the documented Together model when local inference fails through a fallback-eligible path
- reasoning and coding use the documented ordered model chains
- operators can deploy and validate the feature through the documented gateway and runtime surfaces

## Open Questions

- project history for this feature has not yet been reconstructed into `features/together-escalation/projects/`
- the current repo does not yet contain a reconstructed proposal package for the original approval event
