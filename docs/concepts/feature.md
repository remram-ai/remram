# Feature

A Feature is the approved lifecycle container created when a proposal is accepted.

Feature artifacts describe the approved capability and hold the project work and enhancement backlog that implement or extend it.

## Where Features Live

Feature artifacts live under:

```text
features/<feature-name>/
```

A typical feature folder includes a top-level `README.md`, a `projects/` folder, and an `enhancements/` folder. `feature-spec.md` and `test-plan.md` are optional when this repository owns those local lifecycle artifacts.

## What A Feature Can Produce

A feature may produce one or more implementation projects and platform deliverables through the active delivery pipeline:

```text
Idea -> Proposal -> Feature -> features/<feature>/projects/<project> -> platform/<type>/<name>
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

Use `roadmap/proposals/` for pre-approval capability planning.

Use `features/` once a proposal has been approved into active feature work.

Use `platform/` once a feature project has produced a defined platform deliverable under the correct implementation surface.

Feature-level validation may live under `features/<feature>/test-plan.md` when this repository owns the feature-level acceptance contract.

Platform-item validation belongs under `platform/<type>/<name>/test-plan.md`.

Some repo-backed features keep their detailed validation and implementation contracts in a dedicated repository instead of a local feature-level plan. Platform-item plans prove the lower-level components.

## Related Concepts

- [Plugin](plugin.md)
- [Skill](skill.md)
- [Service](service.md)
- [Runtime](runtime.md)
