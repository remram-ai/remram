# Gateway Feature Spec

## Feature Summary

- Feature name: gateway
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: operator-facing `moltbox` CLI control path
- In scope: service lifecycle orchestration and status reporting
- In scope: native OpenClaw passthrough on `test` and `prod`
- In scope: restricted verification surfaces for routine operator checks
- In scope: authenticated MCP and restricted SSH automation surfaces
- In scope: snapshot-aware mutation guardrails and recovery workflow
- Out of scope: service definitions as source material
- Out of scope: baseline service config as source material
- Out of scope: skill or plugin implementation code

## User Experience

Operators should be able to manage the appliance through one documented control plane instead of mixing direct Docker usage, ad hoc host commands, and disconnected tooling.

## Functional Requirements

- gateway writes authoritative deployment and snapshot metadata
- `moltbox service ...` manages appliance service lifecycle
- `moltbox test|prod openclaw ...` preserves native runtime lifecycle operations
- `moltbox test|prod verify ...` supports restricted operator verification
- MCP access requires authenticated access
- `moltbox gateway update` refreshes both the running gateway and host CLI tooling

## Dependencies

- Docker on the appliance host
- appliance state under `/srv/moltbox-state`
- appliance logs under `/srv/moltbox-logs`
- service definitions from `moltbox-services`
- final deployable runtime artifacts from `moltbox-runtime`
- skill packages from `remram-skills`

## Acceptance Criteria

- operators can manage core appliance lifecycle through documented CLI commands
- deployment and snapshot metadata reconcile with running and rendered artifacts
- internal agents can reach MCP with authenticated access
- normal operator workflows do not require undocumented Docker-first recovery paths
- replay and checkpoint are not part of the normal `test` / `prod` lifecycle

## Open Questions

- project history for this feature has not yet been reconstructed into `features/gateway/projects/`
- future follow-on work may split this feature into multiple tracked implementation projects
