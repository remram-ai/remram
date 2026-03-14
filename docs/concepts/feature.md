# Feature

A Feature is a product-level capability definition.

Feature documentation describes what the system should be able to do, not how a specific repository happens to implement it.

## Where Features Live

Implemented capability documentation belongs under:

```text
platform/<type>/<name>/
```

Typical types are:

- `core`
- `services`
- `skills`
- `plugins`

## What A Feature Can Depend On

A feature may be implemented through:

- one or more [Plugins](plugin.md)
- one or more [Skills](skill.md)
- one or more [Services](service.md)
- [Runtime](runtime.md) configuration
- any combination of those

## What A Feature Is Not

A feature is not:

- a container
- a CLI namespace
- a runtime environment
- a repository boundary

Those belong to other concepts.

## Feature Versus Backlog Idea

Use `platform/` for active or committed capabilities.

Use `roadmap/ideas/` for concepts that are not yet implemented or not yet stable enough to be treated as active capability documentation.

Use `roadmap/epics/` when one planning document groups multiple capabilities or workstreams.

## Related Concepts

- [Plugin](plugin.md)
- [Skill](skill.md)
- [Service](service.md)
- [Runtime](runtime.md)
