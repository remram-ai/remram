# Contribute

The easiest way to contribute well is to change the right artifact in the right repository.

This repository is intentionally open to contributors who are still getting oriented. If you can improve clarity, terminology, structure, or platform documentation, that is useful work.

## Contribute Here When The Change Is About

- architecture
- terminology
- documentation structure
- platform item definitions in `platform/`
- idea and epic planning in `roadmap/`
- contributor orientation

## Contribute Elsewhere When The Change Is About

- gateway or CLI implementation
- runtime configuration implementation
- service definitions or container topology
- skill packages or plugin-backed capability code
- application code
- Cortex implementation

## Contribution Rules

- Use the current canonical vocabulary from [Concepts](../concepts/README.md).
- Use the current CLI grammar from [CLI](../operations/cli.md) and [CLI Reference](../reference/cli-reference.md).
- Do not edit files in `archive/` in place.
- Put active capability docs in `platform/`, not in `roadmap/`.
- Put unimplemented ideas and epics in `roadmap/`, not in the active architecture docs.
- Keep architecture descriptions separate from implementation details when a domain repository should own the code-level contract.

## Good Contribution Pattern

1. Clarify the concept or architecture change here.
2. Confirm the owning repository or documentation layer.
3. Update the active document set using the current structure.
4. Keep examples, terminology, and links aligned with the rest of the docs.
5. Move implementation changes into the owning repository when documentation is stable.

Small clarification, wording, and traceability improvements are worth making. You do not need to wait for a large architecture rewrite to improve the docs.

## Before You Open A Change

Check these first:

- [Documentation Map](../README.md)
- [Development Workflow](development-workflow.md)
- [Repo Setup](repo-setup.md)

If the change affects system behavior, also review:

- [Gateway](../concepts/gateway.md)
- [Plugin](../concepts/plugin.md)
- [Runtime](../concepts/runtime.md)
- [Service](../concepts/service.md)
- [Skill](../concepts/skill.md)

If you are helping an AI assistant or another contributor get oriented quickly, also point them at [AI Context](../ai-context/README.md).
