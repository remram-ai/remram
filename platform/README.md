# Platform Registry

`platform/` is the registry of active RemRam and Moltbox capabilities.

Anything under `platform/` must represent an actual platform capability that is implemented or actively being implemented.
Conceptual work stays in [roadmap/](../roadmap/README.md).

The lifecycle is:

```text
Idea -> Feature -> platform/backlog -> platform/<type>/<name> -> docs/features/<name>.md
```

New capabilities begin in [platform/backlog/](./backlog/README.md).
Only after the capability type is known should the item move into one of the active registry categories:

- [core/](core/) for control-plane and shared platform subsystems
- [services/](services/) for appliance services with their own lifecycle
- [skills/](skills/) for portable capability bundles deployed into runtimes
- [plugins/](plugins/) for runtime extensions installed through the native plugin lifecycle
- [backlog/](backlog/) for new capabilities that are not yet classified

Enhancements stay near the owning platform item so capability history remains local to that item.

New platform items must contain the operational documentation bundle:

- `README.md`
- `spec.md`
- `design.md`
- `operator-guide.md`
- `test-plan.md`

These files describe what the capability is, how it works, how operators run it, and how it is validated.
Use [platform/_template/](./_template/) when creating a new platform item.

Platform items are technical deliverables.
User-facing capability explanations belong under [docs/features/](../docs/features/README.md) once multiple deliverables form a coherent feature.

Go next:

- Start with [Roadmap](../roadmap/README.md) if the work is still conceptual.
- Use [Platform Backlog](./backlog/README.md) when shaping a new platform capability candidate.
- Use [Platform Template](./_template/README.md) when creating a new platform item bundle.
- Use [Feature Documentation](../docs/features/README.md) when a completed capability should be documented from the user-facing point of view.
- Use [Overview](../docs/overview/README.md) if you need system context first.
- Use one of the category directories above when you are looking for active platform entries.
