# Gateway Feature Spec

## Feature Summary

- Feature name: gateway
- Source proposal: historical approval predates the current roadmap proposal structure and has not yet been reconstructed

## Scope

- In scope: operator-facing `moltbox` CLI control path
- In scope: service lifecycle orchestration and status reporting
- In scope: environment lifecycle actions such as reload and checkpoint
- In scope: authenticated MCP and restricted SSH automation surfaces
- Out of scope: service definitions as source material
- Out of scope: runtime baseline config as source material
- Out of scope: skill or plugin implementation code

## User Experience

Operators should be able to manage the appliance through one documented control plane instead of mixing direct Docker usage, ad hoc host commands, and disconnected tooling.

## Functional Requirements

- gateway writes authoritative deployment metadata
- `moltbox gateway service ...` manages appliance service lifecycle
- environment-scoped lifecycle remains available through `dev`, `test`, and `prod`
- MCP access requires bearer-token authentication
- `moltbox gateway update` refreshes both the running gateway and host CLI tooling

## Dependencies

- Docker on the appliance host
- appliance state under `/srv/moltbox-state`
- appliance logs under `/srv/moltbox-logs`
- service definitions from `moltbox-services`
- baseline runtime config from `moltbox-runtime`
- skill packages from `remram-skills`

## Acceptance Criteria

- operators can manage core appliance lifecycle through documented CLI commands
- deployment metadata reconciles with running and rendered artifacts
- internal agents can reach MCP with authenticated access
- normal operator workflows do not require undocumented Docker-first recovery paths

## Open Questions

- project history for this feature has not yet been reconstructed into `features/gateway/projects/`
- future follow-on work may split this feature into multiple tracked implementation projects
