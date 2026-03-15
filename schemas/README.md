# Schemas

`schemas/` is the canonical location for repository-wide format definitions.

Use this directory when you need the authoritative structure for human-authored templates, machine-readable state contracts, organizational models, runtime payloads, or external data contracts.

## Conventions

| Type | Format |
| --- | --- |
| Human artifact template | `.template.md` |
| Machine schema | `.schema.json` |

## Namespace Model

- [artifacts/](artifacts/README.md): human-authored artifact templates grouped into planning, design, execution, and reporting
- [org/](org/README.md): structural definitions describing how the system is composed
- [state/](state/README.md): machine-readable persistent memory and working-state schemas
- [gateway/](gateway/README.md): runtime and control-plane schemas produced by the Moltbox gateway
- [external/](external/README.md): third-party schemas that RemRam must conform to

Related governance narrative:

- [Governance](../governance/README.md)
- [Policies](../governance/policies/README.md)
