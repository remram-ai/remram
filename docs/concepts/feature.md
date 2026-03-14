# Feature

A Feature is an initiative-level capability definition in the roadmap.

Feature documentation describes what a coordinated initiative is intended to create or enable before individual platform items are introduced.

## Where Features Live

Feature documents live under:

```text
roadmap/features/<name>.md
```

## What A Feature Can Produce

A feature may produce one or more platform deliverables through the active delivery pipeline:

```text
Idea -> Feature -> platform/backlog -> platform/<type>/<name>
```

Typical platform item types are:

- `core`
- `services`
- `skills`
- `plugins`

## What A Feature Is Not

A feature is not:

- a platform item
- a service
- a skill
- a plugin
- a core component

Those are deliverables or implementation types that can emerge from a feature.

## Feature Versus Platform Item

Use `roadmap/features/` for initiative-level capability planning.

Use `platform/backlog/` when the initiative has produced a candidate platform deliverable but the type is not yet finalized.

Use `platform/` for active or committed platform items.

## Related Concepts

- [Plugin](plugin.md)
- [Skill](skill.md)
- [Service](service.md)
- [Runtime](runtime.md)
