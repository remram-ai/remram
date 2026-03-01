## RemRam System Architecture (Technical Overview)

Remram is a sovereign, knowledge-centric architecture layered on top of OpenClaw. It preserves OpenClaw’s deterministic execution model while introducing a structured, multi-dimensional knowledge authority that allows intelligence to mature over time. This document defines the full system—from runtime substrate to reconciliation cycles—so contributors can understand where authority lives, how components integrate, and how durable intelligence compounds without compromising execution integrity.

## 1\. System Overview

Remram operates as a sovereign appliance centered around a single OpenClaw Gateway host. The system is intentionally constrained: one execution authority, one policy layer, one knowledge authority, and one presentation surface. Each exists because it owns something distinct.

The architecture is not distributed and not cloud-first. It is local-first with controlled escalation.

**1.1 Architectural Shape**

At runtime, Remram forms a layered system around a single Gateway process. The Gateway remains the execution control plane, and all other components attach to it through defined seams.

Core invariants:

*   All inbound messages terminate at the Gateway.
*   All sessions are owned and serialized at the Gateway.
*   All transcripts persist locally on the appliance.
*   All tool execution occurs within Gateway-controlled sandbox boundaries.

Cloud models may be invoked, but they do not own session state, routing, or memory. The appliance remains authoritative.

**1.2 Primary Components**

Remram consists of four primary components. Each component owns a distinct authority surface.

*   **remram-gateway**  
    The appliance runtime host. It runs OpenClaw as infrastructure, maintains provider sessions, persists transcripts, enforces sandboxing, and defines the system’s security and network posture. It is the only process allowed to own session state and routing authority.
*   **remram-orchestration**  
    The policy layer. It defines agents and personas, routing bindings, model selection rules, escalation logic, lifecycle hook integration, and context assembly discipline. It determines how a message becomes a run and when knowledge extraction is triggered.
*   **remram-cortex**  
    The knowledge authority. It defines the structured knowledge object model, multi-dimensional indexing system, retrieval pipeline, reflection workflows, dream reconciliation cycles, and artifact promotion logic. It is the canonical source of durable knowledge.
*   **remram-app**  
    The user and administrative surface. It provides controlled interaction with the Gateway and Cortex, enabling chat, knowledge inspection, artifact review, and governance workflows without bypassing runtime authority.

All components operate inside a shared appliance boundary and rely on a single semantic retrieval engine (OpenSearch). There is no secondary memory authority.

**1.3 Authority Separation**

Clear authority boundaries prevent drift and accidental coupling.

*   Execution authority belongs to the Gateway.
*   Policy authority belongs to Orchestration.
*   Knowledge authority belongs to Cortex.
*   Presentation authority belongs to the App.

The App never calls models directly. Cortex never mutates transcripts. Orchestration does not reimplement routing internals. The Gateway does not become a knowledge engine.

This separation is structural, not stylistic.

**1.4 Retrieval Posture**

Remram enforces a single retrieval authority.

OpenClaw’s optional memory subsystems (SQLite vector memory, hybrid BM25, QMD, built-in memory\_search) are disabled. All structured recall flows through Cortex via OpenSearch.

Context is assembled at runtime. Knowledge is retrieved structurally and injected deliberately. They are not conflated.

## 2\. Architectural Principles

Remram extends OpenClaw without forking it. The principles below define how the system evolves while preserving determinism and authority boundaries.

These are not theoretical guidelines. They are constraints that shape implementation decisions across components.

*   **OpenClaw Remains the Runtime Substrate**  
    OpenClaw owns message intake, session grouping, transcript persistence, compaction, pruning, tool execution, sandboxing, and background scheduling. Remram integrates through documented hooks and does not replace runtime mechanics.
*   **Transcript Is Not Knowledge**  
    Session transcripts are append-only runtime history. They may compact or reset. Durable knowledge must survive those boundaries. Cortex extracts structured knowledge from transcripts and persists it independently with provenance and confidence.
*   **Reflection Precedes Reconciliation**  
    Knowledge extraction occurs after execution (agent\_end), not during generation. Scheduled Dream cycles reconcile contradictions and prevent drift. Runtime compaction protects tokens; reflection and Dream protect knowledge integrity.
*   **Escalation Is a Control-Plane Decision**  
    Model selection and escalation are handled in orchestration via before\_model\_resolve. Escalation is deterministic, logged, and policy-driven. It is not embedded in prompts and not delegated to agent improvisation.
*   **Local-First by Default**  
    Sessions, indices, artifacts, and knowledge persist locally. Cloud models provide stateless cognition only. Remote devices are clients, not authorities.
*   **Single Source of Retrieval Truth**  
    All semantic recall flows through OpenSearch via Cortex. Bootstrap files remain curated and minimal. Retrieval is structured, filtered, and bounded before injection.

Good. We’ll redraft Chapter 3 cleanly and structurally consistent with your preferred format:

*   Short meaningful intro per section.
*   Bullet for subcomponent.
*   1–3 sentences under each bullet explaining what it _does_.
*   No meta commentary.
*   Logical grouping by component, not by effort type.
*   Clear note of: Config / Hook Extension / Custom Service.

## 3\. Component Architecture

Remram is implemented as four logical components layered on top of a single OpenClaw runtime. Each component owns a distinct authority surface and integrates through explicit seams. This chapter defines what each component is responsible for and how it is implemented.

**3.1 remram-gateway**

The Gateway is the execution control plane of the system. It runs OpenClaw as hardened infrastructure and defines the appliance boundary where sessions, tools, and transcripts live.

*   \*\*OpenClaw Runtime (Config Only)\*\*  
    Session grouping (dmScope, identityLinks), queue modes, sandbox enforcement, cron scheduling, and transcript persistence are configured through openclaw.json. No runtime fork occurs. These settings define execution isolation and lifecycle boundaries.
*   \*\*Appliance Deployment Layer (Custom Infrastructure Code)\*\*  
    Install scripts and service supervision ensure OpenClaw, OpenSearch, and Cortex start deterministically and persist state locally. This layer includes index provisioning and filesystem layout, but does not modify OpenClaw internals.
*   \*\*Security & Network Posture (Config + Infra)\*\*  
    Token enforcement, VPN-only access, and channel allowlists are enforced through OpenClaw configuration and host-level firewall policy. Remote devices are clients only and never own session state.

The Gateway never performs semantic retrieval and never mutates structured knowledge.

---

**3.2 remram-orchestration**

Orchestration defines how the runtime behaves. It translates inbound messages into controlled agent runs, applies escalation policy, injects structured recall, and triggers knowledge extraction.

*   **Agent & Persona Catalog (OpenClaw Config)**  
    Agents are declared using native OpenClaw definitions. Each persona has an isolated workspace and session store. Bootstrap files remain lean and curated, not dynamic memory stores.
*   **Routing & Isolation Policy (OpenClaw Config)**  
    Deterministic routing binds messages to specific agents and session keys. Isolation boundaries rely entirely on OpenClaw’s native session model.
*   **Escalation Policy (Hook Extension – before\_model\_resolve)**  
    Implemented as a TypeScript extension. Evaluates context pressure, task complexity, and explicit directives before model invocation. Escalation decisions are logged and remain external to prompt logic.
*   **Context Assembly & Injection (Hook Extension – before\_prompt\_build)**  
    Retrieves structured bundles from Cortex via local HTTP. Enforces token ceilings and injection order before the model call. OpenClaw constructs prompts; Remram augments them deterministically.
*   **Tool Output Capture (Hook Extension – tool\_result\_persist)**  
    Captures structured tool outputs at persistence time and forwards them to Cortex. Prevents reliance on prompt visibility, which may be pruned.
*   **Reflection Trigger (Hook Extension – agent\_end + sessions\_spawn)**  
    After a visible response completes, a background reflection agent is spawned in isolation. Reflection never blocks the primary user response.

Orchestration owns policy, not memory storage.

---

**3.3 remram-cortex**

Cortex is the knowledge authority of the system. It converts session history into structured, durable knowledge and governs retrieval, reconciliation, and artifact promotion.

**3.3.1 Cortex Service (Custom Web Service – Go)**

Cortex runs as a local Go service exposing a controlled HTTP API. It communicates with OpenSearch directly and never accesses OpenClaw internals.

Core endpoints:

*   **/ingest**  
    Accepts structured interaction events (tool outputs, reflection deltas) and converts them into knowledge objects.
*   **/retrieve**  
    Performs filter-first hybrid search and returns bounded, typed knowledge bundles suitable for prompt injection.
*   **/reflect**  
    Processes reflection outputs, updates knowledge objects, adjusts confidence, and links related objects.
*   **/dream**  
    Executes reconciliation routines: contradiction detection, principle extraction, demotion, and consolidation.
*   **/promote**  
    Generates or updates evergreen artifacts derived from validated knowledge and prepares diffs for review.
*   **/dimensions**  
    Manages the dimension registry and candidate dimension lifecycle.

Each endpoint has a narrow responsibility and never mutates session transcripts.

---

**3.3.2 Knowledge Object Model (Custom Schema)**

Knowledge is stored as structured objects in OpenSearch.

Each object includes:

*   Atomic statement or constraint
*   Provenance (source session/tool)
*   Confidence score
*   Dimension tags
*   Relational links
*   Promotion state

Transcripts are input only. Knowledge objects are the durable authority.

---

**3.3.3 Multi-Dimensional Indexing System (Custom Logic)**

Knowledge objects are indexed across multiple structured dimensions.

*   **Dimension Registry**  
    Canonical dimensions (person, project, topic, domain, constraint, etc.) are stored centrally.
*   **Candidate Dimensions**  
    New extracted attributes are tracked separately until signal persistence justifies promotion.
*   **Promotion Rules**  
    Executed during Dream cycles to formalize recurring candidate dimensions.

Retrieval is eligibility-first, similarity-second.

---

**3.3.4 Retrieval Pipeline (Custom – Go)**

Cortex performs hybrid retrieval in deterministic stages:

1.  Dimension eligibility filtering
2.  Lexical ranking (BM25)
3.  Vector similarity scoring
4.  Confidence-weighted re-ranking
5.  Typed bundle construction

The bundle returned is bounded and structured for injection. OpenClaw does not perform semantic search for long-term knowledge.

---

**3.3.5 Reflection & Dream Engines (Hybrid)**

Knowledge maturation occurs in two phases:

*   **Reflection (Hook + Cortex)**  
    Triggered by agent\_end. Extracts durable deltas from completed interactions and updates knowledge objects.
*   **Dream (Cron + Cortex)**  
    Triggered by scheduled cron sessions. Detects contradictions, consolidates principles, demotes weak knowledge, and prepares artifact promotions.

Reflection updates. Dream reconciles.

---

**3.3.6 Artifact Promotion (Cortex + Workspace + Git)**

Validated knowledge may be promoted into evergreen artifacts.

*   Artifacts are written as Markdown into the workspace.
*   Git versioning is handled locally.
*   Proposed diffs are surfaced through the App.
*   Approved artifacts are reindexed into OpenSearch.

Artifacts are projections of validated knowledge, not primary memory stores.

---

**3.4 remram-app**

The App layer provides visibility and governance without bypassing runtime authority.

*   \*\*Gateway Proxy (Thin Client Layer)\*\*  
    Connects to OpenClaw via RPC and streaming APIs. Does not invoke models directly.
*   \*\*Knowledge Visualization (Cortex Client)\*\*  
    Displays knowledge objects, dimensions, confidence, and provenance. Calls Cortex API only.
*   **Artifact Review Workflow**  
    Surfaces proposed artifact changes. Approval triggers /promote processing server-side.
*   **Admin Diagnostics**  
    Displays escalation frequency, retrieval metrics, and Dream cycle status without direct index access.

The App is presentation and governance only. It does not own policy or memory.

---

**Logical Responsibility Summary**

**Gateway Layer**

*   OpenClaw runtime (Config)
*   Sandbox enforcement (Config)
*   Session grouping (Config)
*   Appliance deployment (Infrastructure)

**Orchestration Layer**

*   Agent definitions (Config)
*   Escalation policy (Hook Extension)
*   Context injection (Hook Extension)
*   Tool capture (Hook Extension)
*   Reflection trigger (Hook Extension)

**Cortex Layer**

*   Knowledge schema (Custom Go)
*   Dimension registry (Custom Go)
*   Retrieval engine (Custom Go)
*   Reflection processor (Custom Go)
*   Dream reconciliation (Custom Go)
*   Artifact promotion (Custom Go + Git)

**App Layer**

*   Gateway proxy (Frontend)
*   Cortex visualization (Frontend)
*   Artifact review (Frontend)
*   Diagnostics (Frontend)

## 4\. Runtime Model

The runtime model defines how Remram behaves under real load. It describes what happens when a message enters the system, how execution proceeds inside OpenClaw, where Remram policy attaches, when knowledge is extracted, and how reconciliation occurs over time.

This is not conceptual. It is procedural. The goal is determinism: every event in the lifecycle has a defined owner and a defined hook boundary.

---

**4.1 Inbound Message → Session Resolution**

All interaction begins at the OpenClaw Gateway. The Gateway owns message intake, routing, deduplication, and session grouping.

When a message arrives:

*   Channel adapter normalizes transport.
*   Gateway resolves agent binding via routing rules.
*   Session key is computed using dmScope and identityLinks.
*   Concurrency rules enforce one active run per session.
*   Message is appended to session transcript (JSONL).

At this stage, Remram has not intervened. Execution authority remains entirely OpenClaw-native.

---

**4.2 Run Initialization & Escalation Decision**

Once a run begins, orchestration policy attaches.

Before the model is selected, the before\_model\_resolve hook executes. This is the escalation control point.

Escalation policy evaluates:

*   Context window pressure (token estimate).
*   Task complexity heuristics.
*   Explicit user escalation directives.
*   Domain-specific policies (if defined).

Outcomes:

*   Select local routing model.
*   Escalate to cloud reasoning model.
*   Log escalation decision for later diagnostics.

Escalation is resolved before prompt assembly and is never embedded in prompt text.

---

**4.3 Context Assembly & Injection**

After model resolution, OpenClaw begins prompt construction. Remram attaches at before\_prompt\_build.

The injection sequence is controlled and ordered:

1.  OpenClaw core system prompt.
2.  Agent bootstrap files (workspace).
3.  Remram structured knowledge bundle.
4.  Session transcript (subject to compaction).

During this phase:

*   Orchestration calls Cortex /retrieve.
*   Cortex performs eligibility filtering and hybrid search.
*   A bounded bundle is returned.
*   Token ceilings are enforced before injection.
*   Knowledge is inserted in structured format.

Transcript history remains separate from durable knowledge. Injection is deliberate, not cumulative.

---

**4.4 Model Invocation & Tool Execution**

The model is invoked with the compiled prompt. Tool execution occurs inside the OpenClaw runtime.

Runtime guarantees:

*   One active run per session.
*   Tool schemas enforced.
*   Sandbox restrictions applied.
*   Streaming (if enabled) emitted as presentation only.

Remram does not intervene mid-generation. It does not capture reasoning traces and does not mutate state during streaming.

Tool results are persisted by OpenClaw into transcripts.

---

**4.5 Tool Capture & Structured Ingestion**

When a tool result is persisted, the tool\_result\_persist hook executes.

At this point:

*   Structured outputs are forwarded to Cortex /ingest.
*   Ingestion occurs independently of prompt visibility.
*   No transcript mutation occurs.

This ensures durable artifacts are captured before pruning or compaction affects prompt assembly.

---

**4.6 Response Completion & Reflection Trigger**

Once the assistant response completes, OpenClaw emits agent\_end.

Remram uses this hook to spawn a reflection run via sessions\_spawn.

Reflection characteristics:

*   Isolated session.
*   deliver: false.
*   No interference with user-visible output.
*   Uses recent interaction delta as input.

Reflection agent extracts:

*   Durable facts.
*   Updated constraints.
*   Behavioral corrections.
*   Confidence adjustments.
*   Potential dimension candidates.

Reflection output is sent to Cortex /reflect for structured updates.

The primary user run is already complete at this stage.

---

**4.7 Compaction & Lifecycle Boundaries**

OpenClaw may compact transcripts when context windows approach limits.

Important boundaries:

*   Compaction writes summaries into transcript.
*   Pruning affects prompt visibility only.
*   Reset policies may create new sessions.

Remram does not override these mechanisms.

Instead:

*   Reflection runs immediately after each session turn.
*   Durable knowledge persists independently of compaction.
*   Dream cycles reconcile across sessions.

Compaction protects runtime stability. Knowledge authority lives outside it.

---

**4.8 Dream Cycle (Scheduled Reconciliation)**

Dream cycles are triggered via OpenClaw cron sessions.

When executed:

*   A Dream agent session is spawned.
*   Recent knowledge updates are reviewed.
*   Contradictions across dimensions are detected.
*   Weak inferences are demoted.
*   Stable recurring patterns are consolidated into principles.
*   Artifact promotion candidates are generated.

Dream processing calls Cortex /dream to apply reconciliation logic.

This phase is asynchronous and does not affect live sessions.

---

**4.9 Artifact Promotion Flow**

When Dream or Reflection produces promotion candidates:

*   Cortex prepares a proposed Markdown update.
*   Diff is generated against workspace artifact.
*   Proposal is surfaced in the App.
*   User approval triggers /promote.
*   Artifact is written to workspace.
*   Git commit occurs locally.
*   Updated artifact is reindexed into OpenSearch.

Artifacts remain derived knowledge, not primary storage.

---

**4.10 Failure & Degradation Posture**

Runtime stability takes priority over knowledge augmentation.

If Cortex is unavailable:

*   Runs proceed without structured injection.
*   Escalation policy still executes.
*   Tool capture queues may retry ingestion.
*   No session execution is blocked.

If OpenSearch is unavailable:

*   Retrieval returns empty bundles.
*   Reflection writes are deferred or logged for retry.
*   No mutation of transcripts occurs.

Execution never depends on knowledge availability. Knowledge enhances runs but does not gate them.

---

**4.11 End-to-End Timeline Summary**

For a single user message:

1.  Message arrives at Gateway.
2.  Session resolved and locked.
3.  Escalation decision made (before\_model\_resolve).
4.  Knowledge bundle retrieved (before\_prompt\_build).
5.  Prompt compiled.
6.  Model invoked.
7.  Tools executed (if needed).
8.  Response streamed.
9.  tool\_result\_persist forwards structured outputs.
10.  agent\_end triggers reflection.
11.  Reflection updates Cortex.
12.  Dream cycle later reconciles system-wide knowledge.

Execution is synchronous and deterministic. Knowledge maturation is asynchronous and cumulative.

## 5\. Knowledge Model

The knowledge model defines what is durable in Remram and how it is structured, retrieved, matured, and promoted. It is the core architectural differentiator of the system.

Session transcripts capture history.  
Cortex defines knowledge.

This chapter formalizes the object schema, dimensional indexing strategy, confidence system, and lifecycle rules that govern structured memory.

---

**5.1 Knowledge Objects**

A knowledge object is the atomic unit of durable intelligence in Remram. It represents a distilled, structured statement extracted from interaction, tool output, or reconciliation.

Each knowledge object contains:

*   **Statement**  
    A normalized atomic fact, constraint, preference, principle, or decision.
*   **Type**  
    Examples: fact, preference, constraint, principle, relationship, artifact-derived summary.
*   **Provenance**  
    Source session ID, timestamp, originating tool (if applicable).
*   **Confidence Score**  
    Numeric score reflecting validation strength and recurrence.
*   **Dimensions**  
    Structured tags mapping the object into indexed categories.
*   **Relational Links**  
    References to related knowledge objects (supports graph traversal).
*   **Promotion State**  
    Indicates whether the object has contributed to an evergreen artifact.

Knowledge objects are immutable in identity but mutable in confidence and linkage. Updates occur through reflection and dream cycles.

---

**5.2 Knowledge Types**

Not all knowledge is equal. The system distinguishes between categories because retrieval eligibility and promotion rules differ.

Primary types:

*   **Fact**  
    Objective statements derived from explicit input or tool output.
*   **Preference**  
    User-stated or inferred inclinations (e.g., tone, style, interests).
*   **Constraint**  
    Behavioral or structural limits (e.g., “do not add praise”).
*   **Decision**  
    Explicit commitments or resolved tradeoffs.
*   **Principle**  
    Recurring pattern consolidated from multiple events.

Type affects:

*   Confidence weighting.
*   Promotion eligibility.
*   Retrieval priority.

---

**5.3 Dimension System**

Dimensions are structured axes used to index knowledge objects. They enable eligibility filtering before similarity search.

**5.3.1 Canonical Dimensions**

The system maintains a registry of canonical dimensions such as:

*   person
*   project
*   domain
*   topic
*   tool
*   channel
*   artifact
*   policy-area

Each dimension is stored as a keyword field in OpenSearch for fast filtering.

---

**5.3.2 Candidate Dimensions**

During reflection, extracted attributes may not map to existing canonical dimensions. These are stored as candidate dimensions.

Candidate lifecycle:

*   Created during reflection when recurring attributes are detected.
*   Tracked separately from canonical registry.
*   Evaluated during Dream cycles for persistence and recurrence.
*   Promoted to canonical dimensions if signal threshold is met.

This allows the dimension model to evolve without destabilizing retrieval structure.

---

**5.3.3 Multi-Dimensional Eligibility**

Each knowledge object may be indexed across many dimensions simultaneously.

For example:

A single knowledge object may include:

*   person: Jason
*   domain: AI architecture
*   project: Remram
*   topic: escalation policy
*   channel: Discord

Retrieval first applies eligibility filters across dimensions before vector similarity is applied. This prevents cross-domain bleed and irrelevant recall.

Eligibility precedes similarity.

---

**5.4 Confidence Model**

Confidence reflects how stable a knowledge object is over time.

Confidence increases when:

*   Reinforced by repeated interactions.
*   Confirmed by tool output.
*   Referenced consistently across sessions.
*   Survives Dream reconciliation without contradiction.

Confidence decreases when:

*   Contradicted by new evidence.
*   Not reinforced over time.
*   Demoted during Dream cycles.

Confidence is numeric and affects retrieval ranking. High-confidence objects outrank low-confidence ones during bundle construction.

Confidence never gates execution. It only influences recall weighting.

---

**5.5 Retrieval Model**

Retrieval is filter-first hybrid search executed entirely by Cortex.

**5.5.1 Stage 1 – Eligibility Filtering**

Objects must match:

*   Persona or workspace scope.
*   Relevant dimension filters.
*   Minimum confidence threshold (configurable).

This stage eliminates structurally irrelevant knowledge.

---

**5.5.2 Stage 2 – Hybrid Ranking**

Remaining candidates are ranked using:

*   BM25 lexical match.
*   Vector similarity (embedding).
*   Confidence weighting.
*   Recency decay (if configured).

Results are sorted deterministically.

---

**5.5.3 Stage 3 – Bundle Construction**

Top-ranked objects are compiled into a bounded, typed bundle.

Bundle properties:

*   Hard token ceiling.
*   Ordered by relevance and confidence.
*   Structured formatting for injection.
*   Explicit section delimiters.

Orchestration inserts this bundle during before\_prompt\_build.

---

**5.6 Reflection Model**

Reflection is the primary ingestion path for new knowledge.

After each run:

*   The reflection agent analyzes interaction delta.
*   Extracts durable candidates.
*   Identifies new dimensions.
*   Detects behavioral corrections.
*   Proposes updates to confidence.

Cortex /reflect processes the structured extraction and updates knowledge objects.

Reflection is incremental. It updates existing objects when possible instead of creating duplicates.

---

**5.7 Dream Reconciliation Model**

Dream cycles operate at system scale rather than session scale.

During Dream:

*   Contradictions across dimensions are detected.
*   Weak or isolated objects are demoted.
*   Recurrent patterns are elevated to principles.
*   Candidate dimensions are evaluated for promotion.
*   Artifact promotion candidates are generated.

Dream cycles do not depend on transcript history. They operate on structured knowledge objects.

Reflection adds knowledge.  
Dream reconciles knowledge.

---

**5.8 Artifact Promotion Model**

Artifacts are durable projections of validated knowledge.

Promotion criteria may include:

*   High-confidence threshold.
*   Recurring reinforcement.
*   Principle-level consolidation.
*   Explicit user directive.

Promotion flow:

1.  Cortex generates artifact draft.
2.  Diff prepared against workspace file.
3.  Approval required via App.
4.  Artifact committed locally.
5.  Artifact reindexed into OpenSearch.

Artifacts are version-controlled but remain secondary to knowledge objects.

Knowledge is canonical.  
Artifacts are curated projections.

---

**5.9 Knowledge Degradation & Decay**

To prevent fossilization:

*   Confidence may decay over long inactivity periods.
*   Low-confidence objects may be pruned.
*   Demoted objects remain auditable but excluded from retrieval eligibility.

Knowledge is allowed to evolve. It is not permanent by default.

---

**5.10 Knowledge Authority Boundary**

OpenClaw governs session continuity and transcript persistence.

Cortex governs:

*   What becomes durable.
*   How it is structured.
*   How it is retrieved.
*   How contradictions are resolved.
*   How artifacts are promoted.

No other component mutates knowledge objects.

---

## 6\. Extension Surfaces & Integration Contracts

Remram does not fork OpenClaw. It extends it through documented surfaces and well-defined service boundaries. This chapter formalizes how components integrate, what guarantees exist at each seam, and how failure is handled.

Every integration point must answer three questions:

1.  Is it synchronous or asynchronous?
2.  Who owns failure handling?
3.  What state is allowed to mutate?

---

**6.1 OpenClaw Hook Surfaces**

Remram attaches behavior through OpenClaw’s documented lifecycle hooks. These hooks define the control-plane integration boundaries.

**before\_model\_resolve**

This hook executes before model selection.

*   **Purpose**  
    Apply escalation policy and model selection rules.
*   **Sync/Async**  
    Synchronous. Must complete before model invocation.
*   **Failure Posture**  
    If escalation logic fails, default to local model.
*   **State Mutation**  
    May log events externally. Must not mutate session transcript.

This is a policy decision point, not a knowledge mutation point.

---

**before\_prompt\_build**

This hook executes before prompt assembly completes.

*   **Purpose**  
    Retrieve structured knowledge bundle from Cortex and inject into prompt.
*   **Sync/Async**  
    Synchronous. Retrieval must complete before model invocation.
*   **Failure Posture**  
    If Cortex retrieval fails, continue run with no structured injection.
*   **State Mutation**  
    No transcript mutation allowed. Injection affects prompt only.

Knowledge enhances execution but does not gate it.

---

**tool\_result\_persist**

This hook executes when a tool result is persisted to transcript.

*   **Purpose**  
    Forward structured outputs to Cortex for ingestion.
*   **Sync/Async**  
    Asynchronous (non-blocking preferred).
*   **Failure Posture**  
    Retry queue or log for later re-ingestion.
*   **State Mutation**  
    Transcript already persisted by OpenClaw. Cortex mutation is separate.

This hook ensures durable artifacts are captured before pruning affects prompt context.

---

**agent\_end**

This hook executes after the assistant response completes.

*   **Purpose**  
    Trigger reflection workflow.
*   **Sync/Async**  
    Asynchronous. Spawns background session.
*   **Failure Posture**  
    Log failure; do not impact user response.
*   **State Mutation**  
    May result in Cortex knowledge updates only.

User-visible output must never depend on reflection success.

---

**Cron Sessions**

OpenClaw cron infrastructure triggers scheduled background runs.

*   **Purpose**  
    Execute Dream reconciliation cycles.
*   **Sync/Async**  
    Scheduled asynchronous.
*   **Failure Posture**  
    Retry next scheduled cycle.
*   **State Mutation**  
    May mutate knowledge objects and generate artifact proposals.

Cron execution is entirely runtime-native; Cortex processes reconciliation logic.

---

**6.2 Cortex Service Contracts**

Cortex operates as a local web service. Orchestration interacts with it through explicit HTTP endpoints.

**/retrieve**

*   **Caller**: Orchestration (before\_prompt\_build)
*   **Sync/Async**: Synchronous
*   **Contract**:
    *   Input: query context, dimension filters, token budget
    *   Output: bounded structured bundle
*   **Failure Handling**:
    *   Return empty bundle on failure
    *   Log error locally
*   **Mutation**: None

Retrieve must never block execution indefinitely.

---

**/ingest**

*   **Caller**: tool\_result\_persist hook
*   **Sync/Async**: Asynchronous preferred
*   **Contract**:
    *   Input: structured tool output
    *   Output: ingestion acknowledgment
*   **Failure Handling**:
    *   Retry or log
*   **Mutation**:
    *   Create or update knowledge objects

Ingestion is idempotent based on provenance keys.

---

**/reflect**

*   **Caller**: Reflection agent
*   **Sync/Async**: Synchronous within reflection session
*   **Contract**:
    *   Input: structured delta extraction
    *   Output: updated knowledge state
*   **Failure Handling**:
    *   Abort reflection run only
*   **Mutation**:
    *   Update confidence
    *   Link objects
    *   Add candidate dimensions

Reflection never modifies transcripts.

---

**/dream**

*   **Caller**: Dream cron agent
*   **Sync/Async**: Scheduled batch
*   **Contract**:
    *   Input: system-wide reconciliation request
    *   Output: promotion proposals, demotions, consolidations
*   **Failure Handling**:
    *   Retry next cycle
*   **Mutation**:
    *   Confidence adjustments
    *   Object merges
    *   Dimension promotions
    *   Artifact proposal generation

Dream operates exclusively on knowledge objects.

---

**/promote**

*   **Caller**: App approval workflow
*   **Sync/Async**: Synchronous
*   **Contract**:
    *   Input: approved artifact diff
    *   Output: workspace update + index refresh
*   **Failure Handling**:
    *   Abort commit
    *   No partial writes
*   **Mutation**:
    *   Write Markdown artifact
    *   Commit via Git
    *   Reindex artifact

Artifact promotion is atomic.

---

**6.3 Failure & Degradation Strategy**

The system is designed to degrade gracefully.

**If Cortex is unavailable:**

*   Runs proceed without knowledge injection.
*   Escalation policy still executes.
*   Tool outputs remain in transcript.
*   Reflection and Dream suspend.

Execution authority is never blocked.

---

**If OpenSearch is unavailable:**

*   Retrieval returns empty bundles.
*   Ingestion requests queue or fail gracefully.
*   No transcript mutation occurs.

Knowledge availability enhances performance but does not gate runtime.

---

**If Orchestration Hook Fails:**

*   Fallback to safe defaults.
*   Never allow a failed extension to crash the Gateway.
*   Log locally for diagnostics.

Hooks must be defensive.

---

**6.4 State Ownership Rules**

To prevent cross-layer mutation errors:

*   Only OpenClaw writes transcripts.
*   Only Cortex writes knowledge objects.
*   Only Workspace writes artifacts.
*   Only Git writes version history.
*   App never writes directly to indices or transcripts.

All cross-boundary interactions are explicit and logged.

---

**6.5 Sync vs Async Boundaries**

Synchronous operations (block run):

*   Escalation decision
*   Knowledge retrieval
*   Model invocation

Asynchronous operations (post-response):

*   Tool ingestion
*   Reflection
*   Dream reconciliation
*   Artifact proposal generation

User response latency must not depend on knowledge reconciliation.

---

**6.6 Logging & Observability Contracts**

Each layer logs independently:

*   Gateway logs execution and routing.
*   Orchestration logs escalation decisions.
*   Cortex logs retrieval metrics and reconciliation events.
*   App logs governance actions.

No layer writes to another’s log store directly.

---

## 7\. Deployment Model

Remram is deployed as a sovereign appliance. The deployment model describes how to go from bare hardware to a working local system capable of running OpenClaw, injecting knowledge, and testing memory maturation.

This chapter is intentionally grounded in what must exist before any higher-level feature can be validated.

---

**7.1 Hardware Foundation (Moltbox Reference Architecture)**

Remram is designed around a local-first control plane. That means the hardware must support:

*   Deterministic OpenClaw runtime
*   OpenSearch indexing
*   Embedding generation
*   A capable local routing model
*   Moderate concurrent sessions

We prioritize intelligent orchestration locally and escalate heavy cognition to cloud models.

**Baseline Moltbox Profile**

Recommended minimum for development:

*   16GB+ VRAM GPU (e.g., RTX 4060 Ti 16GB or better)
*   64GB system RAM
*   12–16 CPU cores
*   1TB NVMe dedicated for OpenSearch data
*   Separate SSD/NVMe path for OS + logs

Why this matters:

*   OpenSearch is memory-sensitive.
*   Embeddings are CPU/GPU intensive.
*   Local routing models require VRAM.
*   Reflection and Dream cycles should not stall execution.

This machine is not for multi-hour training runs. It is for orchestration intelligence.

---

**7.2 Base Operating System**

Recommended:

*   Ubuntu LTS (server or minimal desktop)
*   Clean install
*   Static IP or reserved DHCP
*   VPN-only inbound access

Required base packages:

sudo apt update

sudo apt install git curl build-essential

This is the substrate for everything else.

---

**7.3 Local AI Stack (Routing & Embeddings)**

Before OpenClaw can use a local model, you must install a local model runtime.

Recommended for v1: **Ollama**

Why:

*   Lightweight
*   Local model hosting
*   Embedding support
*   Easy model switching

Install:

curl -fsSL https://ollama.com/install.sh | sh

Verify:

ollama run llama3

You will later configure OpenClaw to call Ollama as a local provider.

This provides:

*   Local routing model
*   Lightweight reasoning model
*   Embedding generation endpoint

Cloud escalation (Anthropic/OpenAI) remains optional but recommended for complex tasks.

---

**7.4 OpenClaw Installation**

OpenClaw is the execution engine. It must be installed before any Remram layer.

Documentation:  
[https://docs.openclaw.ai](https://docs.openclaw.ai/)

Install using official script and complete onboarding.

After install:

openclaw doctor

openclaw status

openclaw dashboard

Configure:

*   session model
*   sandbox policy
*   queue mode (collect)
*   provider configuration (Ollama + optional cloud)

OpenClaw must be stable before moving forward.

You should be able to:

*   Send a message
*   See transcript persistence
*   Confirm tool execution
*   Confirm session grouping

Do not proceed until this works.

---

**7.5 OpenSearch Installation**

OpenSearch is required for Cortex.

Recommended approach: Docker container for simplicity.

Install Docker:

sudo apt install docker.io

Run OpenSearch:

docker run -d \\

  --name opensearch \\

  -p 9200:9200 \\

  -e "discovery.type=single-node" \\

  -e "OPENSEARCH\_JAVA\_OPTS=-Xms2g -Xmx2g" \\

  opensearchproject/opensearch:latest

Do not expose port 9200 publicly.

Verify:

curl http://localhost:9200

OpenSearch must respond before Cortex can start.

---

**7.6 remram-cortex Deployment**

Cortex runs as a local Go service.

Requirements:

*   Go installed OR compiled binary
*   OpenSearch reachable
*   Local filesystem access
*   Git CLI available

Start Cortex after OpenSearch.

Cortex will:

*   Create required index templates
*   Validate connection to OpenSearch
*   Expose local API (e.g., port 8081)

Verify:

curl http://localhost:8081/health

No OpenClaw modification is required here.

---

**7.7 remram-orchestration Deployment**

Orchestration consists of:

*   Agent definitions
*   Hook extensions
*   Escalation logic
*   Context injection logic

This is deployed into the OpenClaw environment.

Steps:

1.  Install hook modules.
2.  Register before\_model\_resolve.
3.  Register before\_prompt\_build.
4.  Register tool\_result\_persist.
5.  Register agent\_end.

Restart Gateway.

Verify:

*   Escalation logs appear.
*   Retrieval injection occurs.
*   Reflection agent spawns.

Only after this step does Remram behavior begin.

---

**7.8 remram-app Deployment (Optional for Lab Phase)**

The App is not required to validate memory.

For initial development, you can:

*   Use OpenClaw dashboard
*   Inspect OpenSearch directly
*   Call Cortex endpoints manually

App becomes necessary when:

*   Reviewing artifact diffs
*   Visualizing dimensions
*   Inspecting confidence drift

It runs as a separate Node-based web service and connects only to:

*   Gateway RPC
*   Cortex API

No direct OpenSearch access from browser.

---

**7.9 Reflection & Dream Scheduling**

Reflection:

*   Triggered via agent\_end hook
*   Spawned session (deliver: false)
*   Runs immediately after response

Dream:

*   Triggered via OpenClaw cron
*   Scheduled during low-load hours
*   Processes reconciliation

To prevent overload:

*   Reflection tasks run in isolated sessions.
*   Cortex maintains bounded worker pool.
*   Dream cycle limited to single concurrent execution.

No external message queue required in v1.

---

**7.10 Order of Operations (From Zero to Running System)**

1.  Install Ubuntu.
2.  Install Git.
3.  Install Ollama.
4.  Install OpenClaw.
5.  Verify basic agent execution.
6.  Install Docker.
7.  Install OpenSearch.
8.  Start Cortex.
9.  Install orchestration hooks.
10.  Verify retrieval injection.
11.  Trigger reflection.
12.  Trigger Dream manually.
13.  Only then build the App.

This is the correct bootstrapping order.

---

**7.11 What This Deployment Does Not Include (Yet)**

Not included in v1:

*   DGX cognition plane
*   Distributed clustering
*   External message queues
*   Multi-host federation
*   Cloud-managed indices

Those are scaling discussions. They do not belong in initial deployment.

The objective here is a working local appliance that:

*   Executes deterministically.
*   Escalates intentionally.
*   Extracts durable knowledge.
*   Reconciles contradictions.
*   Promotes artifacts.
*   Remains sovereign.

---

## 8\. Responsibility Matrix

Remram is intentionally layered. Each layer owns a different type of authority. This matrix makes that explicit so contributors understand where features belong and where they do not.

If a capability is unclear in ownership, it likely does not belong in the system.

---

**8.1 Gateway Layer (Execution Authority)**

The Gateway layer is powered by OpenClaw. It owns deterministic runtime behavior and session continuity.

| **Capability** | **Authority** | **Implementation** |
| --- | --- | --- |
| Message intake & transport routing | OpenClaw | Native channel adapters |
| Session key resolution | OpenClaw | session.dmScope, identityLinks config |
| Transcript persistence (JSONL) | OpenClaw | Built-in session store |
| Tool execution | OpenClaw | Agent runtime |
| Sandbox enforcement | OpenClaw | agents.defaults.sandbox config |
| Concurrency & queue mode | OpenClaw | Command queue system |
| Streaming & response emission | OpenClaw | Native runtime |
| Cron scheduling | OpenClaw | Built-in cron sessions |

Remram does not modify or fork these systems.

---

**8.2 Orchestration Layer (Policy Authority)**

The orchestration layer defines how the runtime behaves without replacing it.

| **Capability** | **Authority** | **Implementation Surface** |
| --- | --- | --- |
| Agent & persona definitions | Remram | OpenClaw agent config |
| Routing bindings | Remram | OpenClaw routing config |
| Model escalation | Remram | before\_model\_resolve hook |
| Context injection | Remram | before\_prompt\_build hook |
| Tool output capture | Remram | tool\_result\_persist hook |
| Reflection trigger | Remram | agent\_end + sessions\_spawn |

Orchestration may influence execution, but it does not own transcripts or memory storage.

---

**8.3 Cortex Layer (Knowledge Authority)**

Cortex owns all durable knowledge and retrieval logic.

| **Capability** | **Authority** | **Implementation** |
| --- | --- | --- |
| Knowledge object schema | Remram | Go service + OpenSearch index |
| Multi-dimensional indexing | Remram | Dimension registry + filters |
| Hybrid retrieval | Remram | BM25 + vector + confidence ranking |
| Reflection processing | Remram | /reflect endpoint |
| Dream reconciliation | Remram | /dream endpoint + cron |
| Confidence scoring | Remram | Cortex logic |
| Candidate dimension promotion | Remram | Dream cycle evaluation |
| Artifact promotion logic | Remram | /promote endpoint |

OpenClaw does not access OpenSearch directly. Only Cortex does.

---

**8.4 Artifact & Workspace Layer (Durable Projections)**

Artifacts are structured projections of validated knowledge.

| **Capability** | **Authority** | **Implementation** |
| --- | --- | --- |
| Workspace file storage | OpenClaw | Agent workspace directory |
| Markdown artifact files | Remram | Generated by Cortex |
| Version control | Git | Local CLI integration |
| Artifact review approval | Remram | App → /promote |

Artifacts are derived. Knowledge objects remain canonical.

---

**8.5 App Layer (Presentation & Governance Authority)**

The App layer provides visibility and review without bypassing execution or knowledge authority.

| **Capability** | **Authority** | **Implementation** |
| --- | --- | --- |
| Chat interface | OpenClaw | Gateway RPC + streaming |
| Knowledge browser | Remram | Cortex API client |
| Dimension visualization | Remram | Cortex API |
| Artifact diff review | Remram | App UI |
| Escalation diagnostics | Remram | Orchestration logs |
| Dream cycle status | Remram | Cortex metrics |

The App never:

*   Calls models directly
*   Writes to OpenSearch directly
*   Modifies transcripts directly

---

**8.6 Cross-Layer Guardrails**

To prevent architectural drift:

*   Only OpenClaw writes transcripts.
*   Only Cortex writes knowledge objects.
*   Only Git writes version history.
*   Only Orchestration selects models.
*   Only the Gateway owns session state.

This separation is not stylistic — it is structural protection.

---

## 9\. Glossary

This glossary defines canonical terminology used throughout the Remram Architecture.  
Terms are alphabetical and marked by origin: **(OpenClaw)** or **(Remram)**.

---

**Agent (OpenClaw)**

A configured runtime persona in OpenClaw that defines tools, providers, sandbox rules, routing bindings, and workspace. Agents execute runs.

---

**Artifact (Remram)**

A durable Markdown file representing curated, validated knowledge. Artifacts are projections of structured knowledge and are version-controlled via Git.

---

**before\_model\_resolve (OpenClaw)**

Lifecycle hook executed prior to model selection. Remram attaches escalation logic here.

---

**before\_prompt\_build (OpenClaw)**

Lifecycle hook executed before prompt assembly. Remram injects structured knowledge bundles here.

---

**Candidate Dimension (Remram)**

A proposed indexing axis extracted during reflection that has not yet been promoted to canonical dimension status.

---

**Cognition Plane (Remram)**

An optional higher-capability reasoning tier selected via escalation policy. May be cloud-hosted or appliance-based.

---

**Confidence Score (Remram)**

A numeric stability metric assigned to a knowledge object. Influences retrieval ranking but never gates execution.

---

**Cortex (Remram)**

The structured knowledge service and authority layer of Remram. Cortex manages:

*   Knowledge object schema
*   Multi-dimensional indexing
*   Retrieval pipeline
*   Reflection ingestion
*   Dream reconciliation
*   Artifact promotion

Cortex is the sole owner of durable knowledge.

---

**Cron Session (OpenClaw)**

Scheduled background execution mechanism used to trigger Dream cycles.

---

**Dimension (Remram)**

A structured indexing axis (e.g., person, project, domain) applied to knowledge objects for eligibility filtering before similarity search.

---

**Dream Cycle (Remram)**

A scheduled reconciliation process that operates across the entire knowledge graph. Dream:

*   Resolves contradictions
*   Adjusts confidence
*   Promotes candidate dimensions
*   Consolidates recurring patterns into principles
*   Generates artifact promotion proposals

Dream operates system-wide, not session-by-session.

---

**Dream Routine (REM-D) (Remram)**

The operational implementation of the Dream Cycle. REM-D is the scheduled background process responsible for knowledge reconciliation and maturation.

---

**Escalation (Remram)**

A policy decision made in before\_model\_resolve determining whether execution remains local or escalates to a higher-capability provider.

---

**Hook (OpenClaw)**

A documented lifecycle interception point used to extend runtime behavior without modifying core execution.

---

**Knowledge Bundle (Remram)**

A bounded, structured collection of knowledge objects retrieved during prompt assembly and injected into the model context.

---

**Knowledge Object (Remram)**

The atomic durable intelligence unit in Remram. Contains:

*   Statement
*   Type
*   Provenance
*   Dimensions
*   Confidence score
*   Relational links

---

**Moltbox (Remram)**

The reference hardware appliance architecture used to deploy Remram locally.

---

**Orchestration Layer (Remram)**

The hook-based policy layer attached to OpenClaw. Controls escalation, context injection, and reflection triggering.

---

**Promotion (Remram)**

The process of converting validated structured knowledge into an artifact update. Requires explicit approval.

---

**Provider (OpenClaw)**

A configured model backend (e.g., Ollama, OpenAI, Anthropic).

---

**Reflection (REM-R) (Remram)**

The incremental knowledge extraction process triggered after agent\_end. REM-R converts interaction deltas into structured knowledge updates.

---

**REM (Remram Evolution Mechanism) (Remram)**

The collective knowledge maturation system composed of:

*   REM-R (Reflection)
*   REM-D (Dream Routine)

REM governs how experience compounds into structured intelligence over time.

---

**Remram (Remram)**

The knowledge architecture layered on top of OpenClaw that extracts, structures, reconciles, and promotes durable intelligence without replacing execution.

---

**Routing Model (Remram)**

A local LLM optimized for orchestration and tool coordination rather than deep reasoning.

---

**Run (OpenClaw)**

A single execution cycle where an agent processes input, invokes a model, executes tools, and emits a response.

---

**Sandbox (OpenClaw)**

The controlled execution environment for tools and code.

---

**Session (OpenClaw)**

A structured conversation grouping mechanism keyed by identity and dmScope. Sessions persist transcripts.

---

**Sovereign Appliance (Remram)**

A deployment posture in which execution, retrieval, knowledge authority, and artifacts reside locally on a single machine.

---

**tool\_result\_persist (OpenClaw)**

Lifecycle hook executed when tool output is written to transcript. Remram uses this to ingest structured results into Cortex.

---

**Transcript (OpenClaw)**

The JSONL record of session activity. Owned exclusively by OpenClaw.

---

**Workspace (OpenClaw)**

An agent-specific filesystem directory containing artifacts and generated files.