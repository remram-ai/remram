# Platform Registry

`platform/` is the living registry of active RemRam and Moltbox capabilities.

Use this directory for active platform items. Use `roadmap/` for planning and `docs/overview/` for system-level architecture context.

Platform items are organized by primary type:

- [core/](core/) for control-plane and shared platform subsystems
- [services/](services/) for appliance services with their own lifecycle
- [skills/](skills/) for portable capability bundles deployed into runtimes
- [plugins/](plugins/) for runtime extensions installed through the native plugin lifecycle
- [backlog/](backlog/) for uncategorized candidates that have not yet been promoted

Enhancements stay near the owning platform item so capability history remains local to that item.

Bundle depth can vary:

- minimal bundles may contain only `README.md`
- full operational bundles may also include `spec.md`, `operator-guide.md`, and `test-plan.md`

Go next:

- Start with [Overview](../docs/overview/README.md) if you need system context first.
- Use [Roadmap](../roadmap/README.md) if you are shaping or classifying new work.
- Use one of the category directories above when you are looking for active platform entries.
