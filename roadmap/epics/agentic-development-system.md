# Agentic Development System

Epic

---

## 1. Overview

Agentic Development System is a development orchestration initiative that turns feature requests into completed software through isolated development environments, specialized AI agents, human approval gates, and reusable workflow recipes. It is intended to automate the coordination layer around software delivery so requests can move from intake to planning, development, testing, user acceptance, and production with durable context and explicit control points.

The initiative is anchored to the existing RemRam and Moltbox environment rather than requiring a wholly new stack.

---

## 2. Problem Statement

Software development currently requires constant human orchestration across planning, coding, testing, deployment, review, and communication.

- Development orchestration overhead consumes most of the operator's time.
- Context is fragile and often exists only in memory or scattered logs.
- Multi-agent workflows lack coordination and supervision.
- Parallel development across multiple projects is difficult to manage.
- Feature requests often require manual triage before development can begin.

Even when AI assists with implementation, humans still act as the project manager coordinating tools, stages, and handoffs.

The system lacks a durable orchestration layer that can convert requests into managed projects and carry them through the development lifecycle with clear supervision and approval boundaries.

---

## 3. Value Proposition

Agentic Development System turns the development lifecycle into an orchestrated execution loop rather than a manual coordination exercise.

- Requests can become structured projects with explicit lifecycle tracking.
- Each project can run inside its own isolated development node.
- Specialized agents can perform architecture, planning, coding, refactoring, testing, and review work in sequence.
- A supervisory layer can detect off-track execution and decide whether to continue, halt, or escalate.
- Humans remain involved only at explicit decision gates rather than throughout routine orchestration.
- Reusable workflow recipes can compound over time across projects and domains.

Strategically, this initiative creates a foundation for parallel software delivery across multiple projects without depending on a single operator to coordinate every step manually.

---

## 4. User Experience Model

Request Intake:

- Users submit requests through chat or request channels.
- The system asks follow-up questions when intent or scope is unclear.
- Existing registries are checked for duplicates, related capabilities, or reusable components.

Project Formation:

- The request is converted into a structured project.
- A project lifecycle begins and is tracked explicitly.
- The system presents a proposal for approval before execution proceeds.

Development Execution:

- Each active project receives its own isolated development environment.
- The environment is created from a golden container image with source code, Git access, and development tools.
- A specialized agent workforce executes the workflow in sequence:
  - Architect
  - Planner
  - Coder
  - Refactorer
  - Tester
  - Reviewer

Supervision and Control:

- A supervisory agent monitors execution quality and reasoning health.
- Humans are consulted at key approval gates such as architecture review, merge approval, and user acceptance testing.
- Interaction is streamlined through structured task prompts rather than continuous manual management.

Promotion Flow:

1. A request is accepted and clarified.
2. A project is created and assigned an isolated development node.
3. Agents execute the development workflow.
4. The supervisor halts, continues, or escalates when needed.
5. Requester and owner complete user acceptance.
6. Approved work is promoted to production.
7. The development node is removed after completion to free resources.

---

## 5. Epic Scope

### In Scope

- Feature intake through request surfaces.
- Clarifying-question flow before project formation.
- Project lifecycle creation and tracking.
- Isolated development node provisioning from a golden image.
- Multi-agent development workflow orchestration.
- Supervisory monitoring and intervention logic.
- Human approval gates for key decisions.
- User acceptance and promotion flow.
- Reusable workflow recipes and development patterns.

### Out of Scope

- Removing human approval from merge and production decisions.
- Shared, non-isolated project execution environments.
- Unbounded autonomous promotion to production.
- Replacing core Git workflow discipline.

---

## 6. Dependencies

### Architectural Dependencies

- Moltbox gateway control plane.
- Docker runtime nodes.
- Git-based development workflows.
- AI coding models in the Codex family.
- OpenClaw agent framework.
- Project lifecycle tracking and notification mechanisms.

Most of the required infrastructure already exists; the primary additions are node lifecycle management, orchestration, supervision, and project tracking.

### Data & Memory Interactions

Reads:

- Incoming feature requests and clarification threads.
- Existing capability registries and reusable workflow recipes.
- Project context, branch state, and test results.
- Runtime resource availability and scheduling signals.

Writes:

- Structured project records and lifecycle state.
- Agent task outputs and review artifacts.
- Approval requests and user acceptance checkpoints.
- Workflow telemetry and supervision events.
- Reusable patterns and orchestration recipes when promoted.

---

## 7. Governance & Risk

Potential risks:

- Development nodes consuming more resources than expected.
- Agents drifting off-track without timely intervention.
- Unsafe merges or promotions if approval boundaries blur.
- Project context fragmenting across containers, logs, and agents.
- Queueing and scheduling becoming a bottleneck under parallel load.

Mitigations:

- Isolated environments with explicit lifecycle controls.
- Resource scheduling that respects host CPU limits.
- Supervisory halt and escalation behavior.
- Explicit human approval gates for merge and production.
- Branch policies that enforce merge safety.

---

## 8. Success Metrics

- Reduction in human orchestration overhead per project.
- Number of projects that can progress in parallel.
- Time from request intake to user acceptance.
- Percentage of projects completed without manual coordination between every stage.
- Reuse rate of workflow recipes and development patterns.
- Stability of promotion outcomes after approval.

---

## 9. Open Questions

- How many concurrent development nodes should be supported?
- Should node scheduling include a queue system?
- What is the optimal supervisor architecture?
- How should project context be persisted?
- How should notifications be delivered?

