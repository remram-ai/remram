# Feature

A Feature is a product-level capability definition.

Feature documentation describes what the system should be able to do, not how a specific repository happens to implement it.

## Where Features Live

Implemented feature documentation belongs under:

```text
features/<feature-name>/
```

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

Use `features/` for implemented or committed capabilities.

Use `backlog/ideas/` for concepts that are not yet implemented or not yet stable enough to be treated as active capability documentation.

## Related Concepts

- [Plugin](plugin.md)
- [Skill](skill.md)
- [Service](service.md)
- [Runtime](runtime.md)
