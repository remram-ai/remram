# Features

`features/` holds approved feature lifecycle artifacts.

Once leadership approves a proposal, the feature moves into:

```text
features/<feature-name>/
```

Each feature holds the approved capability artifacts and one or more implementation projects. A typical layout is:

```text
features/<feature-name>/
  feature.md
  proposal.md
  feature-spec.md
  projects/
    <project-name>/
      project-plan.md
      _work/
        project-state.json
        execution-log.md
        agents/
```

Feature implementation work happens under:

```text
features/<feature-name>/projects/<project-name>/
```

Project execution state lives inside:

```text
features/<feature-name>/projects/<project-name>/_work/
```

Typical runtime-state artifacts inside `_work/` include:

- `project-state.json`
- `execution-log.md`
- `agents/`

`project-plan.md` lives at the project root, not inside `_work/`.

Go next:

- Start with [Roadmap](../roadmap/README.md) when work is still pre-approval.
- Use [Platform Registry](../platform/README.md) when feature work produces platform deliverables.
- Use [Feature Documentation](../docs/features/README.md) when the approved capability is ready for user-facing documentation.
