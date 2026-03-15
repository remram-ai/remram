# Schemas

`schemas/` is the canonical location for Remram-owned machine-readable format definitions.

Use this directory when you need the authoritative structure for organizational models, Remram runtime payloads, or external data contracts.

## Conventions

| Type | Format |
| --- | --- |
| Human artifact template | `.template.md` |
| Machine schema | `.schema.json` |

## Namespace Model

- [org/](org/README.md): structural definitions describing how the system is composed
- [state/](state/README.md): Remram-owned runtime state schemas
- [gateway/](gateway/README.md): runtime and control-plane schemas produced by the Moltbox gateway
- [external/](external/README.md): third-party schemas that RemRam must conform to

Forge-owned lifecycle templates and orchestration state schemas live in [remram-forge/schemas/](https://github.com/remram-ai/remram-forge/blob/main/schemas/README.md).
