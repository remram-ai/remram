# Platform Registry

`platform/` is the registry of active RemRam and Moltbox capabilities.

Anything under `platform/` must represent an actual platform capability that is implemented or actively being implemented.
Conceptual work stays in [roadmap/](../roadmap/README.md) until approval moves it into [features/](../features/README.md).

The lifecycle is:

```text
Idea -> Proposal -> Feature -> Feature Project -> platform/<type>/<name> -> docs/features/<name>.md
```

Feature projects create platform items directly inside one of the active registry categories:

- [core/](core/) for control-plane and shared platform subsystems
- [services/](services/) for appliance services with their own lifecycle
- [skills/](skills/) for portable capability bundles deployed into runtimes
- [plugins/](plugins/) for runtime extensions installed through the native plugin lifecycle
- [templates/](templates/) for the standard platform item documentation bundle

Enhancements stay near the owning platform item so capability history remains local to that item.

New platform items must contain the operational documentation bundle:

- `README.md`
- `spec.md`
- `design.md`
- `operator-guide.md`
- `test-plan.md`

These files describe what the capability is, how it works, how operators run it, and how it is validated.
Use [platform/templates/](./templates/) when creating a new platform item.

Platform item `test-plan.md` files validate the component itself.

When this repository owns the feature-level acceptance contract, the master acceptance plan lives under `features/<feature>/test-plan.md` and rolls up the top-level user or operator goals that those platform items must satisfy together. Repo-backed features may keep that higher-level validation detail in the owning repository instead.

Platform items are technical deliverables.
User-facing capability explanations belong under [docs/features/](../docs/features/README.md) once multiple deliverables form a coherent feature.

Go next:

- Start with [Roadmap](../roadmap/README.md) if the work is still conceptual.
- Use [Features](../features/README.md) once the work has been approved into an active feature lifecycle.
- Use [Platform Template](./templates/README.md) when creating a new platform item bundle.
- Use [Feature Documentation](../docs/features/README.md) when a completed capability should be documented from the user-facing point of view.
- Use [Overview](../docs/overview/README.md) if you need system context first.
- Use one of the category directories above when you are looking for active platform entries.
