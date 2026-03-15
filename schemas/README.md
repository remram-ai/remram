# Schemas

`schemas/` is the canonical location for repository-wide format definitions.

Use this directory when you need the authoritative structure for artifacts, state files, context layers, runtime payloads, or external data contracts.

## Namespace Model

- [artifacts/](artifacts/README.md): structured work artifacts created by humans or agents
- [org/](org/README.md): structural definitions describing how the system is composed
- [state/](state/README.md): persistent memory and working-state structures
- [gateway/](gateway/README.md): runtime and control-plane schemas produced by the Moltbox gateway
- [external/](external/README.md): third-party schemas that RemRam must conform to

## Current Canonical Schemas

The current Stage 1 schema set is now routed under [artifacts/](artifacts/README.md).

Related governance narrative:

- [Governance](../governance/README.md)
- [Policies](../governance/policies/README.md)
