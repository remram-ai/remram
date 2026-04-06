# Together Escalation Feature Spec

## Feature Summary

- Feature name: together-escalation
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: local-first requests with Together-backed fallback recovery
- In scope: native OpenClaw provider/model policy for fallback behavior
- In scope: appliance secret flow for Together credentials
- In scope: proving and validating the behavior in `test` before promotion to `prod`
- Out of scope: a standalone Together service container
- Out of scope: a replay-era Gateway-managed skill deploy path
- Out of scope: low-confidence semantic escalation that is not backed by actual runtime/provider behavior

## User Experience

Users and operators should be able to treat the runtime as local-first under normal conditions while still getting successful completion when the local provider fails through a fallback-eligible path.

## Functional Requirements

- the runtime starts on the documented local primary model chain
- fallback recovery uses the documented Together provider and model chain
- `TOGETHER_API_KEY` flows through the documented appliance secret system
- the active provider/model path is observable through runtime status, logs, or both

## Dependencies

- native OpenClaw provider/model failover behavior
- baseline service config in `moltbox-services`
- final deployable runtime artifacts in `moltbox-runtime`
- a healthy local `ollama` service for the primary local path
- appliance secret injection for `TOGETHER_API_KEY`

## Acceptance Criteria

- normal requests stay local when the local model is healthy
- fallback recovers to the documented Together chain when local inference fails through a fallback-eligible path
- operators can deploy and validate the feature through the documented appliance flows
- `test` proves the behavior before the same baseline is treated as promotable toward `prod`

## Open Questions

- project history for this feature has not yet been reconstructed into `features/together-escalation/projects/`
- the current repo does not yet contain a reconstructed proposal package for the original approval event
