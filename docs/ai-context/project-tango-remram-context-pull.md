# Project Tango / RemRam Context Pull

Generated from local RemRam repositories for reuse in a Project Tango work context.

## Search Scope

Searched these local Git repositories under `D:\Development\RemRam`:

- `remram`
- `remram-cortex`
- `remram-forge`
- `remram-app`
- `remram-skills`
- `moltbox-gateway`
- `moltbox-runtime`
- `moltbox-services`

Highest-signal repositories for the pasted Project Tango architecture:

- `remram-forge`: workflow orchestration, execution governance, deterministic routing, ledgers, approvals, capability discovery, stage/task/agent contracts.
- `remram-cortex`: memory authority, context packages/bounded retrieval, evidence, knowledge objects, reflection, Dream/reconciliation, promotion.
- `remram`: older architecture framing for Gateway/Orchestration/Cortex/App authority boundaries, hook-based runtime integration, roadmap ideas for intent calibration and prompt assembly.

Literal search result:

- `Foundry` does not appear in the searched RemRam repos.
- The closest RemRam equivalent to Tango's "Foundry Integration" is `OpenClaw` as agent/runtime substrate, plus `Lobster`/`Reef` for deterministic workflow bodies in newer Forge work.
- `EB Forms` does not appear as a domain term. The closest RemRam equivalent is Forge's structured decision/approval interface and decision artifacts.

## Executive Synthesis

The pasted Project Tango component architecture is strongly aligned with prior RemRam design work, but the names differ.

The local RemRam work already separates:

- workflow composition and lifecycle contracts
- deterministic execution governance
- agent runtime execution
- durable memory and bounded retrieval
- product/platform capability contracts
- human decision gates
- feedback, evidence, reflection, and improvement loops

The closest direct mapping is:

| Project Tango term | RemRam analogue | Main local sources |
| --- | --- | --- |
| AI Workflow Builder / Composer | Forge blueprint/stage/task/policy definition layer; Forge docs and blueprint JSON | `remram-forge/docs/overview/architecture.md`, `remram-forge/docs/concepts/core-building-blocks.md`, `remram-forge/blueprints/forge-inner-loop/` |
| AI Orchestration / Harness | Forge execution layer, Orchestrator responsibility, execution ledger, output gate, waiting state, recovery/escalation | `remram-forge/work-handoff/02-forge-execution-layer.md`, `remram-forge/docs/concepts/how-execution-works.md`, `remram-forge/docs/concepts/execution-ledger.md` |
| Context Engine / Memory Layer | Cortex memory authority: five-layer model, knowledge objects, evidence packages, bounded retrieval, reflection/Dream | `remram-cortex/docs/design/layered-memory-architecture.md`, `remram-cortex/docs/concepts/*` |
| Foundry Integration | No literal match; nearest is OpenClaw runtime plus Lobster/Reef workflow execution substrate | `remram-forge/docs/overview/openclaw-integration.md`, `remram/archive/history/openclaw-reference.md`, `remram-forge/reference/clawflows/llm-and-openclaw-reference.md` |
| Product Capabilities | RemRam platform registry, Forge platform capability index, logical tool contracts, Cortex product/provider contracts | `remram/platform/`, `remram-forge/platform-extensions/`, `remram-cortex/archive/.../product/capabilities/` |
| Interface UX / EB Forms | Structured decision presentation, approval loops, acceptance decision tasks, decision logs | `remram-forge/platform-extensions/skills/decision-presentation.md`, `remram-forge/blueprints/forge-inner-loop/tasks/*decision*.json` |
| Learning / Improvement Signals | Forge retro/improve loops plus Cortex reflection/Dream and evidence packages | `remram-forge/docs/concepts/how-context-is-built.md`, `remram-cortex/docs/concepts/reflection.md`, `remram-cortex/docs/concepts/evidence-package.md` |

The most important shared doctrine:

- Composer should not become the Harness.
- Harness should not become the agent runtime.
- Agent runtime should not own accepted workflow state.
- Memory should not be prompt stuffing.
- Evidence should not be confused with memory.
- Product capabilities should be contract-backed, not just raw APIs.
- Human approvals must be explicit deterministic artifacts, not sentiment inferred from chat.
- Learning should create governed candidate improvements, not silent behavioral drift.

## RemRam Root Architecture Context

The root repo's older system architecture frames RemRam around four authority surfaces:

- Gateway: execution/session authority.
- Orchestration: policy, routing, escalation, context assembly, reflection triggers.
- Cortex: durable knowledge authority.
- App: user/admin presentation and review surface.

Source: `remram/archive/history/legacy-system-architecture.md`

Key reusable ideas for Tango:

- All inbound messages terminate at the execution authority.
- Cloud models may be invoked, but do not own session state, routing, or memory.
- Execution authority, policy authority, knowledge authority, and presentation authority are structurally separate.
- Context is assembled at runtime; knowledge is retrieved structurally and injected deliberately.
- Transcripts are runtime history, not durable knowledge.
- Escalation is policy-driven and logged; it is not embedded in prompt text.
- Knowledge availability improves execution but does not gate the runtime.

The older runtime model maps cleanly to Tango Harness:

1. Inbound message/session resolution is owned by the runtime/Gateway.
2. Model escalation is decided before prompt assembly.
3. Context assembly retrieves bounded knowledge from Cortex.
4. Model/tool execution runs inside OpenClaw.
5. Tool outputs and run completion trigger capture/reflection.
6. Reflection and Dream update durable knowledge outside the user-visible response path.

The root `openclaw-reference.md` adds the integration seam:

- OpenClaw owns message intake, session management, execution loop, model invocation, tools, streaming, transcripts, sandboxing, cron, and session isolation.
- RemRam attaches policy and memory through hooks such as `before_model_resolve`, `before_prompt_build`, `tool_result_persist`, and `agent_end`.
- Cortex depends on OpenClaw sessions but does not replace them.
- Runtime context and durable memory stay separate.

Source: `remram/archive/history/openclaw-reference.md`

Root roadmap ideas relevant to Tango:

- `Durable Conversation Layer`: cross-session semantic continuity owned by Cortex, not the runtime transcript store.
- `Intent Calibration`: lightweight pre-cognition that classifies domain, mode, thread continuation, and confidence before deeper work.
- `Prompt Assembler`: structured escalation-ready context bundle that curates calibrated intent, internal artifacts, memory, fresh context, user preferences, constraints, and output expectations.

Sources:

- `remram/roadmap/ideas/2026-03-01__cortex__durable-conversation-layer.md`
- `remram/roadmap/ideas/2026-02-28__orchestration__intent-calibration.md`
- `remram/roadmap/ideas/2026-02-28__orchestration__prompt-assembler.md`

## Cortex Pull: Context Engine / Memory Layer

Cortex is the strongest match for Tango's Context Engine.

Core doctrine:

- Cortex is one knowledge authority coordinating multiple memory surfaces.
- Context, memory, operational knowledge, and evidence are distinct.
- Retrieval must be bounded and governed before ranking.
- Durable memory is not a transcript fragment, raw tool result, or prompt-injected blob.
- Evidence supports memory but is not memory.

Source: `remram-cortex/docs/design/layered-memory-architecture.md`

### Five-Layer Cortex Model

The active Cortex architecture defines five layers:

1. `Policy`: behavioral truth, role/mode composition, tool-use rules, approval/escalation posture, prompt-budget discipline.
2. `Working Memory`: hot working continuity, session-local and near-session continuity.
3. `Durable Memory`: durable semantic truth in Graphiti/Neo4j, with lineage, support, supersession, invalidation, continuity.
4. `Operational Knowledge`: active working bodies, workspaces, summaries, decomposed artifact knowledge, reference-derived operational knowledge.
5. `Evidence`: source-of-record bodies such as runtime evidence, reference cache, and authored artifacts.

Authority boundaries:

- Layer 2 may surface tentative continuity but does not become durable truth automatically.
- Layer 3 stores concepts and semantic relationships, not document bodies.
- Layer 4 owns shaped operational bodies the system works with.
- Layer 5 stores persisted evidence bodies and source records, not semantic meaning.

This maps directly to Tango's distinction between:

- evidence
- knowledge objects
- context packages
- candidate memory updates
- promoted artifacts

### Evidence, Knowledge, Context

Source: `remram-cortex/docs/concepts/memory-vs-context.md`

Reusable definitions:

- Context: bounded information injected into a live run.
- Memory: structured, persistent, evolving knowledge owned by Cortex.
- Operational knowledge: medium-horizon retrieval-ready bodies, separate from both runtime context and durable semantic memory.
- Evidence: source-of-record material, not semantic meaning.

This is directly relevant to Tango's warning that memory must not become prompt stuffing.

### Knowledge Objects

Source: `remram-cortex/docs/concepts/knowledge-object.md`

A knowledge object is the concrete durable memory unit.

It carries:

- canonical statement or structured payload
- type such as fact, preference, constraint, correction, decision, principle, or procedure
- provenance back to runs, artifacts, or tools
- governance fields for eligibility
- typed signal fields for semantic retrieval
- semantic signature for soft routing
- confidence, freshness, reinforcement metadata
- relationships to other objects/artifacts
- promotion state

Important rule:

- A knowledge object is not a transcript, event log, execution record, or opaque imported file.

### Evidence Packages

Source: `remram-cortex/docs/concepts/evidence-package.md`

An evidence package is a closed, immutable, source-linked, replayable record used for audit, replay, reconciliation, and provenance.

It usually includes:

- stable evidence id
- timestamps
- source/session identifiers
- compact summary
- pointers to raw backing material
- metadata
- optional extracted support items

Tango implication:

- Harness should capture execution evidence.
- Cortex should receive evidence packages or bounded evidence records, not unbounded raw logs as durable memory.
- Evidence can later support candidate memory updates and reconciliation.

### Bounded Retrieval

Source: `remram-cortex/docs/concepts/bounded-retrieval.md`

Cortex retrieval is governed before it is ranked:

1. Resolve scope, ownership, and governance constraints.
2. Filter eligible objects.
3. Bias/preselect by semantic signature.
4. Score the bounded set using typed signals and lexical search.
5. Optionally boost with vector similarity inside the bounded set.
6. Rerank by confidence, freshness, reinforcement, and relationships.
7. Enforce token and bundle-shape limits.
8. Return a structured knowledge bundle plus optional retrieval trace.

Tango implication:

- Context packages should be explainable bundles.
- Retrieval should not search the entire graph and hope ranking fixes eligibility.
- Eligibility precedes similarity.

### Reflection, Dream, Intuition

Sources:

- `remram-cortex/docs/concepts/reflection.md`
- `remram-cortex/docs/concepts/intuition.md`
- `remram-cortex/docs/design/layered-memory-architecture.md`

Reflection is near-time interpretation and maintenance:

- stages/updates notions
- prunes/merges/demotes stale notions
- updates Layer 4 workspaces
- uses Layer 3 relationships to organize work
- detects promotion candidates

Dream is slower consolidation:

- revisits semantic relationships
- merges idea clusters
- hardens support, supersession, and invalidation
- identifies promotion candidates

Intuition is future Mamba-side signal evaluation:

- watches high-signal stream
- decides when hotter notion/reflection work should wake up
- does not replace durable memory, reflection, or reconciliation

Tango implication:

- Learning signals should route into governed candidate improvements.
- Reflection-like processing can be near-time.
- Deeper reconciliation should remain evidence-backed and slower.
- No autonomous self-modification.

### Artifact Promotion

Source: `remram-cortex/docs/concepts/artifact-promotion.md`

Promotion turns stabilized Layer 4 work into a Layer 5 `authored_artifact`.

Rules:

- Not every knowledge object or workspace should be promoted.
- Promotion is for stable, reusable, reviewable, version-worthy output.
- Promotion requires review and approval before publication.
- After promotion, canonical revisions can re-enter Layer 4 and trigger Layer 3 reconciliation.

Tango implication:

- "Promoted Artifacts" should be deliberate outputs such as specs, guides, playbooks, test cases, or solution definitions.
- Promotion should be a workflow with approval, not automatic memory write-through.

## Forge Pull: Workflow Composer / Harness

Forge is the strongest match for Tango's Composer plus Harness split.

Source: `remram-forge/work-handoff/02-forge-execution-layer.md`

Core Forge thesis:

- Forge is lifecycle and execution governance for agentic work.
- Forge does not replace an agent runtime.
- Forge defines how work moves, what artifacts must exist, what policies constrain execution, what counts as accepted output, and when a human decision is required.
- Forge is not primarily a prompt library. It is an execution contract system.

### Core Object Model

Sources:

- `remram-forge/docs/concepts/core-building-blocks.md`
- `remram-forge/docs/overview/architecture.md`

Forge definition hierarchy:

```text
Blueprint
  -> Stages
    -> Tasks
      -> Agents
```

Policies constrain blueprint, stage, task, and agent behavior.

Task types include:

- `simple`
- `loop`
- `composite`
- `recovery`

Runtime hierarchy:

```text
Project
  -> Stage
    -> Task
```

Tango mapping:

- `workflow blueprint` / `workflow definition`: Forge `blueprint`.
- `stage model`: Forge `stage`.
- `agent team configuration`: Forge `agent` bindings and assigned agents.
- `approval rules`: Forge policies and decision tasks.
- `workflow execution contract`: Forge task definitions, policies, runtime artifacts, output envelopes, ledgers.

### Deterministic Frame, Agentic Execution

Source: `remram-forge/docs/concepts/how-execution-works.md`

Forge controls deterministically:

- active blueprint
- current stage
- next task
- assigned agent
- applicable policies
- retro signal reuse
- transitions and escalations
- artifact lineage
- execution history in the ledger

OpenClaw handles agentic runtime execution:

- agents
- reasoning
- artifact generation
- negotiation
- skills/tools/plugins
- runtime behavior during task execution

Tango implication:

- Harness governs state, routing, approvals, retries, evidence, escalation, and accepted outcomes.
- Foundry/OpenClaw-style runtime executes bounded AI work.
- Agents do not decide accepted workflow state.

### Orchestrator Responsibility

Source: `remram-forge/docs/concepts/how-execution-works.md`

Forge's Orchestrator is responsible for:

- deterministic routing
- task-output validation against canonical envelope
- bounded schema repair when validation fails
- ordered conditional route evaluation
- ledger recording
- selecting relevant retro signals for reuse
- compaction summaries/highlights/feedback
- loop evaluation
- waiting-state pause/resume during escalations
- task recovery
- conflict resolution

Tango mapping:

- This is a close match to Harness responsibilities.
- Tango's Harness can use the same mental model: routing and accepted state are deterministic; AI assists inside bounded steps or repair paths.

### Execution Ledger

Source: `remram-forge/docs/concepts/execution-ledger.md`

Forge's execution ledger is deterministic, append-only runtime history.

Ledger hierarchy:

```text
project
  -> project_ledger
    -> stage_ledger
      -> execution_ledger
        -> task_ledger
```

Task ledger records include:

- `task_id`
- `task_type`
- canonical `result`
- canonical `data`
- optional `context`
- optional `summary`
- optional `highlights`
- optional `feedback`
- `artifacts`
- timestamps
- nested task ledgers

Routing uses deterministic fields only:

- canonical `result`
- legacy `success_status` during migration

Interpretive fields can help humans and agents understand the run, but they do not determine routing correctness.

Tango implication:

- Harness should persist run state, task ledgers, evidence, failures, approvals, retries, decisions, outputs, and cost/usage metadata.
- Routing should not depend on a free-form summary.

### Structured Output Gate

Source: `remram-forge/docs/concepts/how-execution-works.md`

Every task output boundary should use:

1. deterministic schema validation
2. bounded AI-assisted repair only if validation fails
3. code revalidation after repair
4. recovery/escalation if repair fails

Tango implication:

- Harness should not accept malformed agent output into workflow state.
- Schema repair is allowed, but bounded, logged, and revalidated.

### Context Assembly

Source: `remram-forge/docs/concepts/how-context-is-built.md`

Forge assembles context deterministically before agent reasoning:

```text
blueprint -> stage -> task -> agent -> artifacts -> mission context -> retro signals -> policies
```

Additional points:

- Retro signals support context; they do not replace artifacts and policies.
- Agent knowledge should be layered: small baseline, registry of larger knowledge, retrievable library.
- Tasks can declare `memory_requests` for targeted retrieval.
- Retrieval hints guide runtime retrieval but do not replace deterministic task inputs.

Tango implication:

- Composer should declare context needs.
- Harness should request bounded context packages at step boundaries.
- Context packages should be explicit, inspectable, and scoped to workflow/task/role/risk.

### Configuration Versus Runtime State

Source: `remram-forge/docs/concepts/configuration-vs-runtime-state.md`

Forge separates:

- configuration: blueprint, stage, task, agent, policy definitions
- runtime state: project progress, execution ledger, mission context, escalation messages, negotiation records
- human-readable artifacts: proposals, architecture writeups, plans, presentations

Tango implication:

- Composer owns definitions/templates/versioning.
- Harness owns runtime execution state and ledgers.
- Artifacts may be human-readable but should not be confused with workflow state.

### Human Approval And Decision Artifacts

Sources:

- `remram-forge/platform-extensions/skills/decision-presentation.md`
- `remram-forge/blueprints/forge-inner-loop/tasks/user-approval-loop.task.json`
- `remram-forge/blueprints/forge-inner-loop/tasks/system-owner-acceptance-decision.task.json`
- `remram-forge/docs/reef/gap-report.md`

Forge already models:

- structured decision interfaces
- deterministic response options
- follow-up commentary capture
- decision logs
- user approval loops
- system-owner acceptance decisions
- explicit approval confirmation
- expired/ambiguous signals routed explicitly
- waiting state for escalations
- persisted decision artifacts for resume

Tango implication:

- EB Forms / Interface UX should render the human task.
- Harness should decide what the approval means for workflow state.
- Approval cannot be inferred from positive sentiment.
- Resuming a stage should depend on persisted decision artifacts, not raw chat or approval tokens alone.

## Product And Platform Capability Context

Tango's Product Capabilities concept has three RemRam analogues.

### RemRam Platform Registry

Source: `remram/docs/README.md`, `remram/platform/`

The root repo treats `platform/` as the living registry for active platform items and capability bundles. Feature records and platform deliverables are separated:

```text
Idea -> Proposal -> Feature -> Feature Project -> Platform Item -> Feature Documentation
```

Tango implication:

- Product capabilities should have stable documentation and validation records.
- Product capabilities should not be buried inside one workflow project.

### Forge Platform Capability Review

Sources:

- `remram-forge/platform-extensions/services/platform-capability-index.md`
- `remram-forge/blueprints/forge-inner-loop/policies/existing-capability-first.policy.json`

Forge wants a queryable capability index of known OpenClaw/shared-platform capabilities, extension surfaces, and implementations.

Policy:

- Existing platform capabilities should be reviewed before recommending new runtime implementation work.
- Gaps should classify whether they require a plugin, skill, service, tool, or template.

Tango implication:

- Composer should expose product/platform capability selection.
- Harness should enforce allowed use, permissions, evidence requirements, mode, retries, and escalation.
- Capability review should be part of workflow design/readiness checks.

### Tool Contracts And Provider Contracts

Sources:

- `remram-forge/platform-extensions/tools/README.md`
- `remram-forge/docs/overview/openclaw-integration.md`
- `remram-cortex/archive/2026-04-03-layered-repository-reset/product/capabilities/artifact-storage/provider-contract.md`

Forge recommends logical tool contracts over direct implementation dependencies.

Tool contract fields should include:

- logical tool name or contract id
- input shape
- output shape
- behavioral annotations such as read-only, destructive, idempotent, or open-world behavior

Cortex artifact-storage provider contracts separate:

- Cortex-owned artifact identity, version references, records, routing, policy
- provider-owned backing bytes/documents/handles, provider-native revisions, read/write mechanics, prune mechanics, backlinks

Tango implication:

- Product capabilities should be contract-backed.
- A capability's owner, inputs, outputs, permissions, mode, evidence, failure behavior, and support path should be explicit.
- Product capabilities are more than APIs; they include rules, constraints, demos, tests, validation behavior, and improvement paths.

## Foundry / OpenClaw Boundary

There is no literal RemRam `Foundry` term.

The closest boundary is:

- Forge defines lifecycle semantics, orchestration configuration, policies, artifact lineage, accepted state, and deterministic records.
- OpenClaw executes agents, skills, tools, plugins, sub-agents, ACP sessions, and runtime behavior.
- Lobster/Reef can own deterministic multi-step workflow bodies, approvals, retry/resume semantics, and structured envelopes.

Sources:

- `remram-forge/docs/overview/openclaw-integration.md`
- `remram-forge/reference/clawflows/llm-and-openclaw-reference.md`
- `remram-forge/docs/reef/architecture.md`
- `remram-forge/docs/reef/feature-mapping.md`

Useful implementation idea from Forge:

1. Lobster controls stage, approvals, and retries.
2. A step calls an official OpenClaw agent surface.
3. The step returns a structured envelope for routing.

In Tango language:

1. Harness controls workflow state, gates, approvals, retries, and accepted outcomes.
2. Foundry executes bounded AI work through agents/tools.
3. Foundry returns structured output, evidence, confidence/failure details, metadata, and usage.
4. Harness validates and decides the next state.

## Learning And Improvement Signals

RemRam already has two complementary improvement loops.

### Forge Retro / Improve

Source: `remram-forge/work-handoff/04-whitepaper-line-of-sight.md`

The compounding loop:

1. A workflow starts with explicit stage/task/artifact expectations.
2. Forge assembles context and requests bounded memory from Cortex.
3. A specialized agent performs a task in OpenClaw or Lobster.
4. Forge validates output and accepts, routes, or escalates it.
5. Accepted artifacts, decisions, and execution signals become evidence.
6. Cortex reflects evidence into durable knowledge.
7. Future workflows retrieve improved knowledge instead of starting cold.

This maps directly to Tango's Learning / Improvement Signals.

### Cortex Reflection / Dream

Sources:

- `remram-cortex/docs/concepts/reflection.md`
- `remram-cortex/docs/design/layered-memory-architecture.md`

Reflection handles near-time memory maintenance and workspace updates.
Dream handles slower consolidation, merge, supersession, invalidation, and promotion readiness.

Tango implication:

- Workflow evidence should produce candidate improvements.
- Improvement destinations should be explicit: workflow redesign, memory update/pruning, agent/tool improvement, product capability update, UX/form improvement, backlog/test updates, reusable pattern library.
- Learning should be governed and reviewable.

## First-Proof Shape Suggested By RemRam Context

A Tango first proof can reuse this shape:

1. Define one pilot workflow as a Forge-like blueprint/stage/task/policy contract.
2. Keep Composer as the definition and inspection surface, not runtime authority.
3. Make Harness own project/run state, deterministic routing, output validation, ledger, evidence, retries, escalation, and accepted outcomes.
4. Invoke Foundry/OpenClaw-style agents only for bounded task work.
5. Require structured output envelopes at every AI boundary.
6. Capture task evidence and decision artifacts in the run ledger.
7. Add one explicit human review/approval point with deterministic outcomes.
8. Have Context Engine/Cortex provide scoped context packages and retrieval traces.
9. Send accepted outcomes, corrections, failures, and evidence back as candidate memory updates.
10. Promote only reviewed/stable knowledge into durable artifacts.

What should not be faked:

- explicit workflow state
- human approval gate
- runtime agent invocation
- context package supplied into the run
- evidence capture
- accepted outcome
- boundary between agent output and workflow authority
- record of what happened

## Architecture Risks To Preserve

RemRam repeatedly flags the same risks that Tango also names:

- prompts carrying lifecycle meaning that should live in contracts
- agents deciding accepted state
- runtime transcripts becoming durable memory
- memory becoming prompt stuffing
- full documents being treated as memory
- product capabilities reduced to raw APIs
- forms treated as orchestration
- learning becoming silent behavioral drift
- prototype scaffolding becoming accidental architecture
- weak ownership between runtime, memory, and governance
- humans bypassing escalation because the system is slower than informal coordination

## Best Source Files To Reattach

Highest-value files from `remram-forge`:

- `work-handoff/02-forge-execution-layer.md`
- `work-handoff/03-applied-agentic-operating-model.md`
- `work-handoff/04-whitepaper-line-of-sight.md`
- `docs/overview/architecture.md`
- `docs/overview/openclaw-integration.md`
- `docs/concepts/core-building-blocks.md`
- `docs/concepts/how-execution-works.md`
- `docs/concepts/how-context-is-built.md`
- `docs/concepts/configuration-vs-runtime-state.md`
- `docs/concepts/execution-ledger.md`
- `platform-extensions/skills/decision-presentation.md`
- `platform-extensions/services/platform-capability-index.md`
- `platform-extensions/tools/README.md`
- `blueprints/forge-inner-loop/README.md`
- `blueprints/forge-inner-loop/tasks/user-approval-loop.task.json`
- `blueprints/forge-inner-loop/tasks/system-owner-acceptance-decision.task.json`
- `blueprints/forge-inner-loop/policies/existing-capability-first.policy.json`
- `reference/clawflows/llm-and-openclaw-reference.md`

Highest-value files from `remram-cortex`:

- `docs/design/layered-memory-architecture.md`
- `docs/design/knowledge-and-artifact-architecture.md`
- `docs/design/openclaw-integration.md`
- `docs/concepts/memory-vs-context.md`
- `docs/concepts/bounded-retrieval.md`
- `docs/concepts/evidence-package.md`
- `docs/concepts/knowledge-object.md`
- `docs/concepts/reflection.md`
- `docs/concepts/intuition.md`
- `docs/concepts/artifact-promotion.md`
- `docs/concepts/typed-signals.md`
- `work-handoff/01-cortex-memory-layer.md` does not exist in Cortex; the equivalent is in `remram-forge/work-handoff/01-cortex-memory-layer.md`.
- `archive/2026-04-03-layered-repository-reset/product/capabilities/README.md`
- `archive/2026-04-03-layered-repository-reset/product/capabilities/artifact-storage/provider-contract.md`

Highest-value files from `remram` root:

- `archive/history/legacy-system-architecture.md`
- `archive/history/openclaw-reference.md`
- `roadmap/ideas/2026-03-01__cortex__durable-conversation-layer.md`
- `roadmap/ideas/2026-02-28__orchestration__intent-calibration.md`
- `roadmap/ideas/2026-02-28__orchestration__prompt-assembler.md`
- `docs/README.md`
- `docs/ai-context/features.md`
- `platform/README.md`

## Short Crosswalk To Paste Elsewhere

Project Tango should be interpreted as a Tyler/enterprise expression of the Forge + Cortex split:

- Composer is the workflow definition and operating surface.
- Harness is the deterministic execution authority.
- Context Engine is Cortex: governed memory, evidence, bounded retrieval, reconciliation, and promotion.
- Foundry is the agent/runtime substrate analogous to OpenClaw/Lobster in RemRam, not the owner of workflow state.
- Product Capabilities are contract-backed platform/product surfaces with inputs, outputs, permissions, modes, evidence, failure behavior, and improvement paths.
- Interface UX / EB Forms are rendering surfaces for human tasks; they do not own workflow semantics.
- Learning signals are governed evidence-to-improvement routes, not automatic self-modification.

The durable boundary is:

```text
Composer defines.
Harness governs.
Foundry/OpenClaw executes bounded AI work.
Context Engine/Cortex remembers and retrieves.
Product Capabilities provide callable product reach.
UX/Forms collect human decisions.
Learning routes evidence-backed improvements.
```

