# Features

`features/` holds approved feature lifecycle artifacts and the active feature inventory.

This directory begins when leadership approval promotes a proposal into an active feature.

Once leadership approves a proposal, the feature moves into:

```text
features/<feature-name>/
```

Each feature holds the approved capability artifacts and one or more implementation projects. A typical layout is:

```text
features/<feature-name>/
  feature.md
  feature-spec.md
  test-plan.md
  proposal.md (optional, when reconstructed)
  projects/
    README.md
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

Feature-level `test-plan.md` files are the master acceptance plans for the feature. They should focus on the top-level user or operator goals that prove the feature meets its intent, and they should reference lower-level platform item test plans where component validation already exists.

Some restored legacy features do not yet have reconstructed proposal or project-history artifacts. In those cases, the feature folder starts with `feature.md`, `feature-spec.md`, `test-plan.md`, and a `projects/README.md` placeholder until the missing lifecycle history is rebuilt.

Lifecycle routing:

- Stage 1 captures the idea in `roadmap/ideas/`.
- Stage 2 evaluates that idea and produces a proposal package in `roadmap/proposals/<proposal>/`.
- Proposal approval creates `features/<feature-name>/`.
- [Stage 3 - Project Formation](../governance/lifecycle/stage-03-project-formation.md) and later stages continue from this directory, even though the workbook does not yet fully specify those later stage details.

Useful template and schema references:

- [Feature Spec Template](../schemas/artifacts/planning/feature-spec.template.md)
- [Project Plan Template](../schemas/artifacts/planning/project-plan.template.md)
- [Test Plan Template](../schemas/artifacts/reporting/test-plan.template.md)
- [Project State Schema](../schemas/state/project-state.schema.json)
- [Execution Log Template](../schemas/artifacts/execution/execution-log.template.md)

## Current Features

- [Gateway](gateway/feature.md)
- [Moltbox Telemetry](moltbox-telemetry/feature.md)
- [Together Escalation](together-escalation/feature.md)
- [Discord Channel](discord-channel/feature.md)
- [Remram Cortex](remram-cortex/feature.md)

Go next:

- Start with [Roadmap](../roadmap/README.md) when work is still pre-approval.
- Use [Governance Lifecycle](../governance/lifecycle/README.md) when you need the chronological stage path that leads into and continues beyond this directory.
- Use [Platform Registry](../platform/README.md) when feature work produces platform deliverables.
- Use [Feature Documentation](../docs/features/README.md) when the approved capability is ready for user-facing documentation.
