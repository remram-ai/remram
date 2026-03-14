# Agent Lifecycle Diagram Workbook

## Goal
Create a chronological SDLC diagram that shows:
- each agent
- its responsibilities
- when it enters and exits
- approval gates
- handoffs
- artifacts produced
- supervisory interventions

## Source Basis
This draft is grounded in the Agentic Development System feature concept.

## Working Model
We will build this in sequence, then assemble the final diagram and supporting document.

---

# Phase 1 — Lifecycle Backbone

## Chronological stages
1. Request intake
2. Clarification
3. Project formation
4. Architecture and solution design
5. Planning and task decomposition
6. Environment provisioning
7. Implementation
8. Refactor and hardening
9. Testing and validation
10. Review and merge decision
11. User acceptance testing
12. Production promotion
13. Teardown, archive, and pattern capture

---

# Stage 1 — Intake & Idea Formation

## Purpose
Transform an initial user request into a validated **Idea artifact** with supporting concept material before the SDLC begins.

## Primary Agent
Intake / Discovery Agent

## Supporting Agents
Designer / Experience Mock Agent

## Execution Environment
Runs inside OpenClaw.

Model routing:
- Default: local Ollama model
- Escalation: stronger model for synthesis or concept generation

---

## Intake Agent Recipes

### 1. Pre‑screen Request
Purpose: classify the incoming request and determine if it is a feature idea.

Possible classifications:
- feature_request
- bug_report
- question
- configuration_change
- documentation
- support_request
- research

Only `feature_request` proceeds through the full intake workflow.

---

### 2. Discovery Interview
Purpose: clarify the feature request and capture the user's intent.

The agent prompts for:
- scenario
- example usage
- expected behavior
- edge cases
- success criteria

---

### 3. Use‑Case Extraction
Convert the interview conversation into structured workflows.

Outputs:
- Example Workflow 1
- Example Workflow 2
- Example Workflow 3

---

### 4. Feature Story Generation
Convert workflows into structured user stories.

Format:

As a <user>
I want <capability>
So that <outcome>

---

### 5. Idea Document Synthesis
Create the canonical idea artifact.

Artifact location:

/backlog/ideas/<feature-name>.md

Document contents:
- Feature summary
- Example workflows
- User stories
- Initial feature list
- Open questions

---

### 6. Concept Mock Request
The Intake Agent calls a Designer Agent recipe to generate a conceptual mock.

Designer recipe example:

conceptual-mock

Inputs:
- idea document
- example workflows

Outputs:

/backlog/ideas/<feature-name>/concept/

Artifacts may include:
- conceptual wireframe images
- interaction storyboard
- workflow diagram

Goal: communicate the experience concept clearly for user validation.

---

### 7. Idea Review Package
The system assembles a review package for the user containing:

- idea summary
- workflows
- feature list
- concept visuals
- optional audio explanation

Message example:

"I drafted your idea and generated a quick concept. Please review and confirm that this matches what you meant."

---

## Exit Paths

### Approval Path
All must be true:

- Idea document created
- Concept mock generated
- Review package sent to user
- User confirms accuracy

When approved:

idea.status = approved

The idea is then added to the **user task queue** for triage.

---

### Feedback Loop Path
If the user provides feedback instead of approval, the intake stage loops.

The Intake Agent performs the following:

1. Capture the user's feedback.
2. Update the idea document.
3. Regenerate affected sections:
   - workflows
   - user stories
   - feature list
4. If the experience changes, call the Designer Agent again to regenerate the concept mock.

Designer call example:

`designer.run("conceptual-mock")`

New artifacts overwrite or version the prior concept materials.

---

### Re‑presentation
After adjustments, the agent sends a new review message to the user.

Example:

"I updated the proposal based on your feedback. Please review the revised concept and let me know if this now matches your intent."

The updated review package includes:

- revised idea summary
- updated workflows
- updated feature list
- revised concept visuals

This loop continues until the user approves.

---

### Cancellation Path

If the user explicitly cancels the idea:

Actions:

- Mark idea as cancelled
- Move artifact to archive

Example:

/backlog/archive/ideas/<feature-name>.md

Optional metadata:
- cancellation reason
- conversation snapshot

This allows later rediscovery without polluting the active backlog.

---

### Idle / No Response Path

If the user does not respond after the review package is sent, the idea remains in an **open / pending** state.

Possible system behavior:

- reminder after configurable interval
- optional automated follow‑up message
- eventual inactivity tagging

Example state:

idea.status = pending-user

No further SDLC stages are triggered until the user returns and approves or cancels the idea.

---

## Checkpoint 1

Idea Approved

This is the first SDLC gate.

Idea Approved

This is the first SDLC gate.

---

# Stage 2 — Product Evaluation & Proposal

## Purpose
Translate an approved idea into a concrete **product proposal** that defines what should be built, how it might be built, and what risks or costs are involved.

## Role Responsible
Product Manager

Note: Stages represent lifecycle steps. Roles represent responsibilities. Multiple agents may execute the role's recipes.

---

## Trigger
Checkpoint 1 — Idea Approved

Ideas enter the **ideas backlog queue** and are processed by the Product Manager as a periodic batch job.

Example trigger flow:

/backlog/ideas/

The Product Manager periodically scans the queue for unprocessed ideas.

---

## Product Manager Recipes

### 1. Idea Triage
Evaluate the idea and determine whether it should move forward into design exploration.

Tasks:
- validate the problem statement
- review workflows and user stories
- confirm idea uniqueness
- determine overall scope

---

### 2. Capability Decomposition
Convert user needs into system components.

Questions addressed:

- Does this require a plugin?
- Does it require a skill?
- Does it require a service?
- Is it configuration of an existing capability?
- Does it require multiple components?

Output: preliminary component map.

---

### 3. OpenClaw Capability Review
Consult available capabilities before proposing new development.

Sources checked:

- OpenClaw core platform
- OpenClaw community extensions
- existing internal plugins

Goal:

Avoid reinventing capabilities and identify correct extension points.

---

### 4. Implementation Exploration
Define how the system could implement the idea.

Identify:

- plugins required
- services required
- skills required
- configuration changes
- integration points

---

### 5. Risk & Cost Assessment
Evaluate impact of the proposal.

Consider:

- system risk
- cross‑service impact
- infrastructure changes
- new services required
- token consumption or compute cost

---

### 6. Product Proposal Generation
Create a complete proposal document.

Artifact location:

/product/proposals/<feature-name>.md

Structure:

Executive summary

Full proposal body

Sections include:

- feature overview
- proposed architecture
- implementation components
- risks
- cost considerations
- assumptions
- open questions

---

### 7. Review Package Assembly
The Product Manager prepares a decision package for leadership review.

Package includes:

- proposal document
- executive summary
- design mockups
- architecture commentary
- assumptions list
- open questions

Additional formats:

- audio brief / podcast style explanation

---

## Supporting Roles

### Designer
Creates higher‑fidelity prototypes or UI concepts during proposal development.

### Architect
Provides a **single-pass architectural sanity check** before the proposal is finalized.

Responsibilities:
- validate proposed system components
- flag architectural risks
- identify major integration concerns
- suggest simpler implementation patterns

This is intentionally a **lightweight review**, not a full architecture phase. The goal is to catch obvious issues before the proposal is presented for decision.

### OpenClaw SME
Subject‑matter expert agent maintaining knowledge of the OpenClaw ecosystem.

Responsibilities:

- track community updates
- monitor OpenClaw releases
- maintain indexed capability knowledge
- advise on extension points

---

## Design Iteration Loop

The proposal may iterate several times.

Loop:

proposal draft
→ design exploration
→ architecture feedback
→ proposal revision
→ leadership review

Leadership may:

- approve
- reduce scope
- expand scope
- request redesign

---

## Decision Paths

After the proposal review package is delivered, leadership (human decision) determines the outcome.

### Approval

The proposal is accepted as written.

Result:

- project proceeds to **Feature Definition / Detailed Design** stage

---

### Revision Requested

Leadership provides feedback.

The Product Manager updates:

- scope
- architecture approach
- implementation strategy

The proposal then loops through:

proposal revision → optional design updates → architect pass → re-present proposal

---

### Rejected

The proposal is declined.

Actions:

- proposal marked rejected
- idea closed

Optional follow-up:

Leadership may suggest an alternate direction, which can trigger a **new idea** through the Customer Success intake process.

---

## Exit Criteria

One of the following must occur:

- proposal approved
- proposal rejected
- proposal revision requested

---

## Checkpoint 2

Product Proposal Decision

Proposal Ready For Decision

---

# Platform Tool Layer

The system includes a shared **tool layer** that agents use to perform specialized operations. Tools are not roles or agents; they are reusable capabilities that recipes can invoke.

Architecture relationship:

Roles
→ Agents
→ Recipes
→ Tools
→ Services

Tools may call local services, external APIs, or internal utilities.

---

## Initial Tool Categories

### Audio Brief Generator
Purpose: convert summaries, proposals, or reports into audio briefings (podcast‑style or narration).

Typical usage:
- idea review audio
- proposal brief
- architecture brief
- status updates

Inputs:
- document
- optional script

Outputs:
- audio file (e.g., mp3)

Artifact example:

/product/proposals/<feature>/brief.mp3

---

### Visual Mockup Generator
Used by designer roles to create conceptual UI or workflow mockups.

Possible implementations under evaluation:
- Excalidraw
- Penpot
- image‑model wireframe generation

Outputs:
- wireframes
- UI concept images
- interaction diagrams

Artifact example:

/backlog/ideas/<feature>/concept/

---

### Diagram Generator
Used for architecture and workflow diagrams.

Preferred format:

Mermaid

Example usage:
- architecture diagrams
- workflow diagrams
- system lifecycle diagrams

---

# Context Model

This system assembles an **agent execution context** from several layers. These layers together form the "brain" used when an agent executes a task.

## Governance Layer
Global rules and architectural guidelines that apply to all teams and roles.

Examples:
- architecture constraints
- security policies
- approval gates

Example rule:
"All new CLI configuration surfaces require approval from Jason."

## Team Layer
Defines organizational ownership and mission.

Teams specialize in specific system areas.

Example teams:
- CLI Team
- Platform Team
- AI Systems Team

Team documents define:
- mission
- owned systems
- rules
- approval requirements

## Role Layer
Roles represent responsibilities inside the SDLC.

Examples:
- Customer Success Manager
- Product Manager
- Designer
- Architect
- OpenClaw SME

Agents execute the recipes associated with these roles.

## Workflow Layer
Workflows orchestrate sequences of task templates to complete lifecycle stages.

Examples:
- Idea Intake Workflow
- Product Proposal Workflow
- Feature Definition Workflow

## Task Template Layer
Task templates are atomic units of repeatable work.

Examples:
- discovery interview
- idea triage
- capability decomposition
- proposal generation

Each task template defines:
- inputs
- outputs
- artifacts produced
- tools used

## Project Context
Project context contains all artifacts and documents related to a specific feature or project.

Example locations:

/product/proposals/<feature-name>.md
/product/specs/<feature-name>.md

## Stage Context
Indicates which lifecycle stage the project is currently in.

Example:

Stage 2 — Product Evaluation

## Working Memory
Temporary reasoning state for an agent while executing tasks.

Working memory is stored in runtime artifacts and may include:
- intermediate notes
- execution progress
- reasoning checkpoints

## Tool Layer
Agents use tools to perform specialized operations.

Examples:
- audio brief generator
- visual mock generator
- diagram generator

---

# Artifact Categories

Artifacts generated by the system fall into three major categories.

## 1. Product Artifacts
Define what should be built.

Examples:

/product/ideas/<feature>.md
/product/proposals/<feature>.md
/product/specs/<feature>.md

Typical artifacts:
- idea document
- product proposal
- feature specification
- architecture document
- test plan

---

## 2. Engineering Artifacts
Define how the system will be implemented.

Examples:

/engineering/implementation-plan.md
/engineering/migration-plan.md
/engineering/deployment-plan.md

These documents guide implementation agents and engineering teams.

---

## 3. Runtime State Artifacts
Used by agents to store execution state and working memory.

Example location:

/runtime/projects/<project-id>/

Typical files:

project-plan.md
project-state.json
agent-state.json
task-state.json
execution-log.md

These artifacts allow agents to:
- resume work
- coordinate across roles
- track execution progress

---

# Decision Log

Major platform tool decisions and architectural selections are recorded here.

### Pending Decisions

Audio generation tool

Candidates:
- Piper TTS
- other local TTS options

Status: research required

---

Visual mockup tool

Candidates:
- Excalidraw
- Penpot
- AI image wireframe generation

Status: research required

---

### Confirmed Decisions

Diagram generation

Tool: Mermaid

Rationale: simple, text‑based diagrams suitable for agent generation and documentation.

---

# Phase 2 — Agent Inventory

To document for each agent:
- Mission
- Trigger
- Responsibilities
- Inputs consumed
- Outputs produced
- Dependencies
- Human interaction points
- Stop/continue/escalate conditions

Initial agent set from the current concept:
- Intake / triage agent
- Clarifier
- Architect
- Planner
- Environment provisioner / node orchestrator
- Coder
- Refactorer
- Tester
- Reviewer
- Supervisor
- Promotion / release coordinator
- Pattern capture / recipe curator

---

# Phase 3 — Handoffs and Controls

Track:
- handoff from one agent to the next
- artifacts passed across stages
- approval gates
- rollback points
- telemetry and supervision events

---

# Phase 4 — Final Assembly

Deliverables to produce at the end:
- one chronological lifecycle diagram
- one agent responsibility matrix
- one concise narrative explaining the flow
- optional swimlane version for presentation

