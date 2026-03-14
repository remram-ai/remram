# Agentic SDLC

This doc set modularizes the agentic software delivery lifecycle described in the workbook at [`archive/Agentic Coding/agent_lifecycle_diagram_workbook.md`](../../archive/Agentic%20Coding/agent_lifecycle_diagram_workbook.md).

The workbook is the authoritative source. This documentation reorganizes that source into lifecycle stages, roles, tasks, workflows, tools, artifacts, and agent-facing context packs without changing the system design intent.

## Architecture Layers

- Governance
- Teams
- Roles
- Workflows
- Tasks
- Recipes
- Tools
- Services
- Project context
- Stage context
- Working memory

See [system-architecture.md](system-architecture.md) and [context-model.md](context-model.md) for the layer model.

## Documentation Areas

- [Lifecycle](lifecycle/README.md)
- [Roles](roles/README.md)
- [Teams](teams/README.md)
- [Tasks](tasks/README.md)
- [Workflows](workflows/README.md)
- [Recipes](recipes/README.md)
- [Tools](tools/README.md)
- [Services](services/README.md)
- [Artifacts](artifacts/README.md)
- [Contexts](contexts/README.md)
- [Decision Log](decision-log.md)

## Lifecycle Overview

```mermaid
flowchart TD
    S1["1. Intake and Idea Formation"] --> C1{"Checkpoint 1\nIdea Approved"}
    C1 -- "Feedback" --> S1
    C1 -- "Approved" --> S2["2. Product Evaluation and Proposal"]
    C1 -- "Cancelled or Idle" --> X1["Archived or Pending User"]

    S2 --> C2{"Checkpoint 2\nProduct Proposal Decision"}
    C2 -- "Revision requested" --> S2
    C2 -- "Approved" --> S3["3. Project Formation"]
    C2 -- "Rejected" --> X2["Closed or Returned as New Idea"]

    S3 --> S4["4. Architecture and Solution Design"]
    S4 --> S5["5. Planning and Task Decomposition"]
    S5 --> S6["6. Environment Provisioning"]
    S6 --> S7["7. Implementation"]
    S7 --> S8["8. Refactor and Hardening"]
    S8 --> S9["9. Testing and Validation"]
    S9 --> S10["10. Review and Merge Decision"]
    S10 --> S11["11. User Acceptance Testing"]
    S11 --> S12["12. Production Promotion"]
    S12 --> S13["13. Teardown, Archive, and Pattern Capture"]
```

Stages 1 and 2 are fully specified from the workbook. Stages 3 through 13 are present as minimal placeholders because the workbook names them but does not yet define them in detail.
