# Features

`features/` holds approved feature lifecycle artifacts.

This directory begins when leadership approval promotes a proposal into an active feature.

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

Lifecycle routing:

- Stage 1 captures the idea in `roadmap/ideas/`.
- Stage 2 evaluates that idea and produces a proposal in `roadmap/proposals/`.
- Proposal approval creates `features/<feature-name>/`.
- [Stage 3 - Project Formation](../governance/lifecycle/stage-03-project-formation.md) and later stages continue from this directory, even though the workbook does not yet fully specify those later stage details.

Useful schema references:

- [Feature Spec](../schemas/artifacts/feature-spec.md)
- [Project Plan](../schemas/artifacts/project-plan.md)
- [Project State JSON](../schemas/artifacts/project-state-json.md)
- [Execution Log](../schemas/artifacts/execution-log.md)

Go next:

- Start with [Roadmap](../roadmap/README.md) when work is still pre-approval.
- Use [Governance Lifecycle](../governance/lifecycle/README.md) when you need the chronological stage path that leads into and continues beyond this directory.
- Use [Platform Registry](../platform/README.md) when feature work produces platform deliverables.
- Use [Feature Documentation](../docs/features/README.md) when the approved capability is ready for user-facing documentation.
