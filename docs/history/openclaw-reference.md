# OpenClaw Reference

## Overview

OpenClaw is a self-hosted AI gateway and runtime operating layer for agent-native systems. It connects messaging platforms—WhatsApp, Telegram, Discord, iMessage, and others—to AI agents through a single long-lived Gateway process. Rather than treating AI as a stateless chat endpoint, OpenClaw establishes a deterministic, stateful execution environment that you control locally.

In practical terms, the Gateway becomes the bridge between external messaging surfaces and internal agents, centralizing routing, session ownership, and provider connectivity into one authoritative runtime.

### Architectural Model

OpenClaw follows a single-Gateway architecture. One daemon process per host owns all channel connections, all sessions, and all routing decisions. Clients and nodes connect over a typed WebSocket protocol, but the Gateway remains the single source of truth for session state and orchestration.

High-level components:

*   **Gateway (daemon)** – owns sessions, routing, provider connections, HTTP surfaces
*   **Agents (e.g., Pi in RPC mode)** – tool-capable execution runtimes
*   **Channels** – WhatsApp (Baileys), Telegram (grammY), Discord, iMessage, Mattermost plugin
*   **Clients** – Web Control UI, CLI, macOS app
*   **Nodes** – macOS, iOS, Android, headless devices with declared capabilities
*   **Typed WS protocol** – structured request/response/event model with schema validation

Exactly one Gateway per host may control a provider session (e.g., WhatsApp), establishing a clear authority boundary.

### Core Capabilities

OpenClaw provides the runtime primitives required to operate AI agents across channels with isolation and control.

Primary capabilities:

*   **Multi-channel gateway** – WhatsApp, Telegram, Discord, iMessage from one process
*   **Plugin channels** – Mattermost and other extension packages
*   **Multi-agent routing** – isolated sessions per workspace or sender
*   **Session model** – direct chats collapse into shared main; groups isolated
*   **Media support** – images, audio, documents in and out
*   **Streaming responses** – chunking and progressive output
*   **Agent bridge** – Pi in RPC mode with tool streaming
*   **OAuth provider auth** – Anthropic and OpenAI subscription flows
*   **Web Control UI** – browser dashboard for chat, config, sessions, nodes
*   **Mobile nodes** – paired iOS and Android devices with Canvas support
*   **Voice note hook (optional)** – transcription integration point

These features together form a complete agent-native runtime environment.

### Industry Context and Strategic Fit

Historically, AI systems have been deployed as hosted SaaS endpoints or embedded APIs. OpenClaw changes that posture by introducing a local-first operating layer between humans and models. Instead of building custom bots per channel or repeatedly wiring orchestration logic, developers deploy a single Gateway that standardizes execution.

For Remram, this provides roughly 80% of the required system foundation:

*   Deterministic orchestration
*   Session isolation
*   Multi-agent routing
*   Device pairing and trust
*   Structured protocol contracts
*   Local runtime authority

OpenClaw eliminates the need to rebuild channel abstraction, runtime control, or session ownership.

### Gaps Relative to Remram

OpenClaw captures interaction and preserves session continuity. It does not provide structured long-term knowledge maturation.

Specifically, it does not include:

*   Reflection cycles after agent completion
*   Durable cross-session knowledge objects
*   Confidence scoring or contradiction reconciliation
*   Knowledge compaction governance
*   Evergreen artifact promotion

These are outside the scope of a runtime OS. They are where Remram layers in.

### Remram Within the OpenClaw Architecture

Remram does not replace the Gateway. It extends it at controlled seams.

*   OpenClaw remains the orchestration authority.
*   Sessions remain Gateway-owned.
*   WS protocol remains the contract boundary.
*   Device pairing remains the root of trust.

Remram introduces Cortex as a knowledge layer operating above sessions. Reflection triggers after agent completion events. Durable knowledge is extracted without mutating Gateway session state. A scheduled reconciliation cycle prevents drift.

OpenClaw provides agency. Remram adds continuity and maturation inside that operating envelope.\\

## Gateway Host (remram-gateway)

OpenClaw’s core runtime component is the **Gateway**. It is the authoritative daemon that owns sessions, routing, provider connections, and device trust. In Remram, this runs on Moltbox as a dedicated hardware appliance .

This machine is the control plane of the entire system. All messaging channels, all agent invocations, all sandbox execution, and all session state terminate here. There is exactly one Gateway per host, and it is the only process permitted to maintain provider sessions.

For Remram, this Gateway host must be:

*   Always-on
*   Deterministic in latency
*   Sized for local routing + embeddings
*   Capable of running an intelligent local model
*   Hardened like a network appliance

We are not deploying OpenClaw as a developer tool. We are deploying it as infrastructure.

### Hardware Sizing Philosophy

The Moltbox hardware spec is intentionally above minimum OpenClaw requirements . We are not targeting a 2–4 GB hobby tier.

Our hardware goals:

*   Support a capable local **router model**
*   Run local embedding workloads
*   Maintain stable OpenSearch performance
*   Sustain concurrent users without latency spikes
*   Avoid constant cloud escalation for routine reasoning

Baseline characteristics:

*   16GB+ VRAM class GPU (for efficient local routing models)
*   64GB+ system RAM preferred
*   Multi-core CPU (12–16 cores ideal)
*   Dedicated NVMe for search indices
*   Separate storage path for artifacts and logs

The local model is not meant to replace cloud cognition. It is meant to:

*   Classify intent
*   Select tools
*   Enforce schema outputs
*   Perform bounded reasoning loops
*   Curate context bundles before escalation

Edge hardware is therefore sized for intelligent orchestration, not heavy multi-hour reasoning.

### Configuring the OpenClaw Gateway

For a dedicated appliance, we use a clean OS base and the official installer. We avoid marketplace images and ephemeral setups.

Recommended posture:

*   Clean Ubuntu LTS (or equivalent)
*   Node 22+
*   Official installer script
*   System-level supervision (systemd)
*   Token enforcement enabled

Install flow:

1.  Install via official script
2.  Run onboarding
3.  Configure provider credentials
4.  Start Gateway as a managed service
5.  Verify using:
    *   openclaw doctor
    *   openclaw status
    *   openclaw dashboard

Default state location:

*   ~/.openclaw/

For Moltbox, state remains local and persistent. Native install is preferred over containerization for appliance-grade stability and observability.

### Configuration Overrides

We focus only on configuration surfaces relevant to our architecture.

Critical controls:

*   Channel allowlists
*   Mention-based activation for group chats
*   Required WebSocket token
*   Provider API configuration
*   Explicit state and config path control

The Gateway must not accept unauthenticated control-plane connections. Remote access must require both pairing and token validation.

Session authority remains centralized. We do not distribute session state across machines.

### Remote Access Model

Remote interaction occurs through:

*   Web Control UI (browser over VPN)
*   Paired iOS node
*   Paired Android node
*   CLI via SSH

These are interaction surfaces, not runtime authorities.

Remote posture:

*   VPN or tailnet only
*   No open public ports
*   Device pairing approval required
*   Token enforcement enabled
*   Browser devices approved via pairing store

Phones and browsers are clients. They do not own memory, routing, or models.

### Sandboxing

When agents use tools (shell, file system, etc.), sandboxing isolates execution without moving Gateway authority.

Recommended baseline:

*   mode: "non-main"
*   scope: "agent"
*   workspaceAccess: "none" or "ro"
*   network: "none"
*   Explicit tool allowlist
*   Resource caps (CPU, memory)

Sandbox protects the host. It does not own memory, sessions, or escalation logic.

### Edge Layer Invariants

Within Remram:

*   The Gateway host (Moltbox) owns all session state.
*   Local models run on the appliance.
*   Cloud escalation is stateless.
*   Remote devices are clients only.
*   Sandboxes isolate execution but never govern memory.
*   Memory and indices remain local by default.

Remram Edge is a sovereign appliance with intelligent local routing capacity. It is not a distributed cluster and not a thin cloud proxy.

\\

## Orchestration (remram-orchestration)

OpenClaw provides the execution engine for Remram. It owns message intake, session management, agent runtime, model invocation, tool execution, streaming, and persistence. Remram does not replace this engine. We layer policy, memory integration, escalation strategy, and persona architecture on top of it.

The Gateway is the authority. It resolves inbound messages to sessions, serializes agent runs, emits structured lifecycle events, and persists transcripts. Devices and chat platforms are surfaces. The Gateway host is the source of truth.

Remram’s orchestration layer answers three questions:

1.  How does a message become an agent run?
2.  How does that run select a model and tools?
3.  Where do we inject memory and capture reflection?

### Execution Model

An agent run is a serialized, deterministic loop:

Inbound message  
→ routing → session key  
→ prompt assembly  
→ model invocation  
→ tool execution  
→ streaming events  
→ transcript persistence  
→ lifecycle end

Core properties:

*   One active run per session.
*   Global concurrency cap across sessions.
*   Lifecycle, assistant, and tool streams emitted during execution.
*   Session transcripts persisted as JSONL on the Gateway host.
*   Timeouts enforced at runtime level.

Remram depends on this determinism. We do not parallelize within a session. We attach memory extraction and reflection to lifecycle completion.

### Agent & Workspace Boundaries

In OpenClaw, an agent is a scoped “brain” composed of:

*   Workspace (cwd and injected context)
*   AgentDir (auth profiles and state)
*   Session store (transcripts)

Workspace bootstrap files (AGENTS.md, SOUL.md, USER.md, etc.) are injected into every run and consume context window tokens.

The workspace is the default working directory, not a hard sandbox. Sandboxing must be explicitly enabled. Session transcripts and credentials live outside the workspace under ~/.openclaw/.

**Remram Interpretation**

We divide memory into layers:

*   Workspace → identity and curated behavioral memory.
*   Session transcripts → conversational history.
*   Cortex → structured long-term memory.
*   Daily logs → rolling narrative capture.

Workspace must remain lean. MEMORY.md is curated, not a database. Structured recall flows through Cortex tools, not bootstrap injection.

Each persona or functional role in Remram maps to a separate agent and workspace. We do not reuse agent state across personas.

### Routing & Persona Isolation

OpenClaw’s multi-agent routing binds inbound messages to specific agents via deterministic rules (channel, accountId, peer, guild, etc.).

Important behaviors:

*   Direct chats collapse into a per-agent main session.
*   Groups receive isolated session keys.
*   Routing precedence is deterministic (most specific wins).
*   Sessions are gateway-owned and device-agnostic.

**Remram Strategy**

In Remram:

*   Each persona = separate agent.
*   Escalation tiers may be separate agents.
*   Family/shared agents run in restricted sandboxes.
*   Reflection agents run in isolated workspaces.

Routing is not workflow logic. It is isolation logic. It ensures separate identities, auth scopes, and memory boundaries.

### Model Selection & Escalation Policy

Model resolution occurs per run and can be overridden before invocation.

OpenClaw supports provider/model references and pre-session hooks.

**Remram Policy**

On Remram Gateway hardware:

*   Default to a capable local model for most runs.
*   Escalate to cloud only when required:
    *   Context window pressure
    *   High-complexity reasoning
    *   Explicit user directive
*   Log escalation events for later analysis.

Escalation is orchestration policy, not agent behavior. It is implemented via before\_model\_resolve.

We do not embed escalation logic in prompts.

### Message Control & Concurrency

OpenClaw protects the runtime with:

*   Duplicate inbound suppression.
*   Per-channel debounce windows.
*   Lane-aware FIFO command queue.
*   One run per session guarantee.
*   Configurable queue modes (collect, followup, steer, etc.).
*   Transport-level retry policy (per HTTP request only).

Default queue mode: collect.

**Remram Position**

*   Collect mode ensures coherent turns.
*   Avoid steer for memory-writing agents.
*   Never allow automatic replay of multi-step agent runs.
*   Transport retries must not duplicate memory writes.

Determinism and transcript integrity take priority over conversational speed.

### Streaming & Presentation Layer

OpenClaw supports:

*   Block streaming (partial channel messages).
*   Preview streaming (edited draft messages).
*   Chunking with channel caps.
*   Optional human-like pacing.

There is no raw token-delta channel streaming.

**Remram Position**

*   Default streaming off for Cortex-critical agents.
*   Enable selectively for UX-focused agents.
*   Never store streamed reasoning traces.
*   Treat streaming as presentation, not state.

Reflection and memory capture occur at lifecycle end, not per stream chunk.

### Context Assembly & Prompt Boundaries

Each run rebuilds a system prompt composed of:

*   Tool list + tool schemas
*   Skills metadata
*   Workspace injection
*   Runtime metadata
*   Safety guidance

Tool schemas consume context tokens. Bootstrap files are truncated per-file and globally capped.

Context ≠ memory.

Context is the bounded window sent to the model. Memory is durable storage outside the model window.

**Remram Implications**

*   Inject Cortex recall via before\_prompt\_build.
*   Keep bootstrap files minimal.
*   Monitor token pressure using /context.
*   Avoid prompt bloat that increases compaction frequency.

Compaction is prompt optimization, not memory deletion.

### Extension Points Used by Remram

OpenClaw provides structured hook surfaces. Remram relies on:

*   before\_model\_resolve → escalation logic
*   before\_prompt\_build → Cortex injection
*   tool\_result\_persist → structured memory extraction
*   agent\_end → reflection capture
*   session\_end → dream-cycle triggers

We do not fork the runtime. We layer policy and memory orchestration through defined extension points.

### Boundary of Responsibility

OpenClaw owns:

*   Message intake
*   Session management
*   Execution loop
*   Tool invocation
*   Streaming
*   Transcript persistence

Remram owns:

*   Escalation policy
*   Persona architecture
*   Memory extraction
*   Structured recall
*   Reflection and dream cycles
*   Edge hardware optimization

This separation keeps Remram lightweight and future-compatible with upstream OpenClaw evolution.

\\

## Sessions & Memory (remram-cortex)

This chapter documents the OpenClaw session and memory mechanics that remram-cortex integrates with, extends, or intentionally disables.

This is an OpenClaw reference section. Its purpose is architectural alignment. Every Cortex feature that touches continuity, memory, identity, or context must map to one of the OpenClaw surfaces described here. If we misunderstand these surfaces, we risk building features that conflict with the runtime.

OpenClaw remains the execution substrate.  
remram-cortex attaches to that substrate to govern knowledge authority and injection.

### OpenClaw Session Model

The OpenClaw session model defines how conversations are grouped, isolated, persisted, and reset. This is the foundation of runtime continuity. Sessions determine which messages belong together, how identities are resolved across channels, and when conversational state expires.

remram-cortex does not replace the session model. It depends on it and must respect its boundaries.

#### Session Keys & Isolation

OpenClaw collapses incoming messages into session keys based on configuration. These rules determine how conversations are grouped and how identity continuity is handled across transports.

Core controls include:

*   session.dmScope
    *   main
    *   per-peer
    *   per-channel-peer
    *   per-account-channel-peer
*   session.identityLinks

These controls matter because Cortex extraction logic must not assume shared context beyond what the session model guarantees. If two users share a session key, they share context. If they do not, they are isolated.

Identity continuity across channels is governed by identityLinks. If a person appears as telegram:123 and discord:456, those can be mapped to a canonical identity. Cortex should rely on that mapping rather than building its own cross-channel identity system.

We use the OpenClaw session model exactly as designed. We do not introduce parallel session grouping logic.

#### Session Store & Transcripts

Every session has:

*   An entry in sessions.json
*   A corresponding JSONL transcript file

These live under:

~/.openclaw/agents/\<agentId>/sessions/

The transcript is append-only. Compaction summaries are persisted into the transcript. Store entries are recreated automatically if deleted.

This gives us three critical properties:

*   Durable historical record
*   Deterministic session reconstruction
*   Clear isolation boundaries

For remram-cortex, transcripts are the raw input to knowledge extraction. They are never the canonical long-term knowledge store. Cortex reads transcripts, extracts durable artifacts, and leaves the transcript untouched.

Transcripts are runtime history. Evergreen knowledge must live elsewhere.

#### Reset Behavior

OpenClaw defines when sessions expire and when new ones are created. Reset policies include:

*   reset (daily, idle, etc.)
*   resetByType
*   resetByChannel
*   Explicit /new and /reset
*   Cron sessions (always fresh)

This is operationally important because resets break continuity. Any knowledge that must persist beyond a session cannot depend on transcript continuity.

For remram-cortex:

*   Durable knowledge must survive resets.
*   Identity mutation cannot depend on session persistence.
*   Reflection must not assume unbounded conversational memory.

Reset logic remains fully OpenClaw-native. Cortex adapts to it rather than altering it.

### OpenClaw Context Lifecycle Controls

OpenClaw enforces token limits and runtime safety through compaction and pruning. These mechanisms directly affect what remains visible to the model during long sessions.

Cortex must understand these lifecycle boundaries to prevent loss of durable knowledge.

#### Auto-Compaction

When a session approaches the model’s context window, OpenClaw automatically compacts older messages. It summarizes them and writes that summary back into the transcript.

Configuration lives under:

agents.defaults.compaction

Compaction ensures:

*   Context windows are respected
*   Long sessions remain usable
*   Old content is compressed rather than dropped entirely

However, compaction changes granularity. Detailed content may be replaced by summary. That means extraction must occur before compaction removes important structure.

For remram-cortex:

*   Reflection hooks must run before information is irreversibly summarized.
*   Durable artifacts must not depend on transcript depth remaining intact.
*   Compaction is treated as a boundary event in the lifecycle.

We do not replace compaction. We coordinate with it.

#### Session Pruning

OpenClaw can prune toolResult messages in-memory before LLM calls. This does not modify the transcript. It only affects what the model sees during prompt assembly.

This behavior protects token budgets, especially for tool-heavy workflows.

For Cortex, this has a simple implication: tool outputs must be captured at persistence time, not assumed to remain in context.

The relevant integration surface is tool\_result\_persist. Extraction logic must attach there rather than depending on prompt context.

We do not modify pruning behavior. We design around it.

### OpenClaw Workspace & Memory Surfaces

OpenClaw provides a workspace file system and optional semantic memory systems. This section clarifies which parts we use and which we disable.

#### Workspace Files as Durable Surface

The workspace includes:

*   MEMORY.md
*   memory/YYYY-MM-DD.md
*   SOUL.md
*   Arbitrary Markdown files

OpenClaw treats these as simple files. They can be injected during prompt assembly and mutated via file tools.

For remram-cortex:

*   Evergreen artifacts are stored locally in the workspace.
*   They are versioned in Git outside of OpenClaw.
*   They are indexed in OpenSearch.
*   They are injected into context via runtime hooks.

The workspace is a durable projection surface, not the canonical retrieval engine.

#### Disabled Built-In Retrieval Systems

OpenClaw includes optional memory retrieval systems:

*   SQLite vector memory
*   Hybrid BM25 search
*   QMD backend
*   Built-in memory\_search

For remram-cortex, these systems are disabled to avoid dual authority.

Retrieval is centralized in OpenSearch. OpenClaw continues to provide:

*   Workspace storage
*   Prompt assembly
*   File mutation tools

But it does not serve as the semantic retrieval engine.

### OpenClaw Runtime Extension Points

OpenClaw exposes controlled hooks for modifying runtime behavior. These are the primary integration points for remram-cortex.

#### Prompt Assembly (before\_prompt\_build)

OpenClaw constructs prompts in a defined order:

1.  Core system prompt
2.  Agent bootstrap files
3.  Workspace files
4.  Session transcript

The before\_prompt\_build hook allows controlled injection before the model call.

remram-cortex uses this hook to:

*   Inject retrieved evergreen artifacts
*   Insert structured knowledge bundles
*   Enforce token budgets
*   Preserve system and bootstrap integrity

This is the primary injection surface.

#### Extraction Hooks (tool\_result\_persist & agent\_end)

Two hooks are critical for knowledge extraction:

*   tool\_result\_persist
*   agent\_end

tool\_result\_persist allows Cortex to capture durable artifacts from tool output before pruning affects context.

agent\_end allows Cortex to trigger reflection workflows after the user-visible response completes.

These hooks ensure extraction occurs outside the conversational flow and does not interfere with response timing.

#### Model Resolution (before\_model\_resolve)

The before\_model\_resolve hook allows dynamic model selection.

This may be used for:

*   Escalation logic
*   Identity-aware routing
*   Retrieval-aware model selection

It is optional but available.

### Sub-Agent & Cron Infrastructure

OpenClaw provides native mechanisms for isolated background execution.

#### sessions\_spawn

sessions\_spawn creates isolated sub-agent sessions. These runs can be non-delivering and auto-archived.

This infrastructure is used by remram-cortex for:

*   Reflection agents
*   Dream cycle processing
*   Identity mutation workflows
*   Knowledge reconciliation

Isolation rules and visibility scopes remain OpenClaw-controlled.

#### Cron Sessions

Cron jobs create fresh, isolated sessions on schedule.

remram-cortex uses cron for:

*   Dream cycles
*   Evergreen artifact review
*   Promotion and demotion logic
*   Identity audits

Scheduling remains entirely OpenClaw-native.

### Session Tools & Visibility Controls

OpenClaw provides session tools and visibility modes to control cross-session access.

Core tools include:

*   sessions\_list
*   sessions\_history
*   sessions\_send
*   sessions\_spawn

Visibility modes include:

*   self
*   tree
*   agent
*   all

Configuration surfaces include:

tools.sessions.visibility

agents.defaults.sandbox.sessionToolsVisibility

remram-cortex must operate strictly within these boundaries. Reflection agents must not access unrelated sessions. Sandbox workspace access must be respected when mutating artifacts.

Isolation enforcement is OpenClaw’s responsibility.

### Disabled Memory Subsystems

To avoid conflicting sources of knowledge authority, remram-cortex disables:

*   SQLite vector memory
*   Hybrid BM25 search
*   QMD backend
*   Built-in memory\_search

OpenSearch becomes the sole retrieval authority. OpenClaw remains the runtime substrate.

### Final Framing

OpenClaw defines:

*   How sessions execute
*   How transcripts persist
*   How isolation is enforced
*   How context is bounded
*   How background tasks run

remram-cortex defines:

*   What knowledge is durable
*   What artifacts are evergreen
*   What identity changes are permitted
*   What context is injected into reasoning

\\

## User Experience (remram-UX)

This chapter documents the OpenClaw surfaces relevant to user and admin experience. The purpose is to clearly identify which OpenClaw mechanisms power client interaction, which are used as-is, and which remram-UX layers extend or consume. OpenClaw remains the runtime authority; remram-UX is a client surface that integrates with it.

### User Experience Client

OpenClaw provides a complete conversational runtime that any client can consume. The user experience client does not replace these mechanics; it relies on them. This section identifies which OpenClaw capabilities form the foundation of the end-user interface.

OpenClaw provides:

*   Multi-channel transport connectors
*   Gateway RPC (agent, agent.wait)
*   Streaming (assistant/tool/lifecycle events)
*   Queue modes (collect, steer, followup, interrupt)
*   Inbound debouncing and dedupe
*   Session key normalization
*   Session isolation (dmScope, identityLinks)
*   Transcript persistence (JSONL)
*   Compaction and pruning
*   Reset policies
*   Tool execution and messaging tools

These capabilities mean that OpenClaw already supports a functional chat client. remram-UX consumes these surfaces through the gateway and streaming APIs. We do not override transport routing, queue logic, streaming internals, or session lifecycle.

The extension occurs only at the client layer.

### Chat & Transport Surfaces

OpenClaw’s messaging system is the foundation of the chat interface. It handles message intake, routing to a session key, agent loop execution, and streaming outbound replies. It also enforces concurrency and retry policies.

Relevant OpenClaw components:

*   Message flow pipeline
*   Session store and transcript persistence
*   Block streaming configuration
*   Preview streaming (per-channel)
*   Retry policies per provider
*   Command parsing and directives
*   Inbound history wrappers
*   Queue modes and backlog handling

remram-UX relies entirely on these mechanics. The client connects to the gateway and subscribes to stream events. No override of OpenClaw’s messaging system is required.

If needed, we may adjust configuration values (streaming defaults, queue modes, retry policy) but not replace implementation.

### Session & Context Surfaces in the Client

OpenClaw owns session grouping, context assembly, and transcript persistence. The client does not directly manipulate session keys; it sends messages and allows OpenClaw to resolve routing.

Relevant OpenClaw session capabilities:

*   session.dmScope grouping
*   session.identityLinks
*   Session JSONL transcripts
*   Compaction summaries
*   Reset triggers (/new, cron isolation, config resets)
*   Context inspection (/context, /status)
*   Tool result pruning (in-memory)

remram-UX depends on these behaviors for continuity. The client must assume:

*   Sessions may compact
*   Sessions may reset
*   Tool results may be pruned
*   Identity-linked sessions may unify context

No override occurs here. remram-UX remains session-agnostic and defers to OpenClaw’s routing and isolation model.

### Workspace & Artifact Access in UX

OpenClaw defines a workspace model that serves as the agent’s working directory. It injects bootstrap files (AGENTS.md, SOUL.md, USER.md, etc.) into the system prompt and provides file tools for read/write operations.

Relevant OpenClaw surfaces:

*   Workspace root (agents.defaults.workspace)
*   Bootstrap file injection
*   Sandbox configuration
*   File tools (read, write, edit, exec)
*   Skill loading hierarchy
*   Git compatibility (external, not OpenClaw-managed)

remram-UX leverages this model for artifact browsing. The client may surface workspace-backed documents (evergreen artifacts), but it does not modify how OpenClaw loads or injects them.

OpenClaw remains the file access authority. remram-UX is a visual layer over workspace content and Cortex-indexed artifacts.

### Cron & Spawned Sessions in the User Surface

OpenClaw includes infrastructure for cron jobs and spawned sub-agent sessions. These sessions are isolated, optionally invisible to the user, and can emit messages or persist results.

Relevant OpenClaw components:

*   sessions\_spawn
*   deliver: false runs
*   Cron session isolation
*   Session visibility controls
*   Tool visibility scoping
*   Lifecycle hooks (agent\_end)

remram-UX may surface the results of cron jobs or reflection runs through a feed or notification interface. However, it does not replace or alter OpenClaw’s scheduling system.

Cron and spawn mechanics remain entirely OpenClaw-native.

### Admin Experience

The admin experience refers to runtime management and configuration. In this domain, OpenClaw already provides substantial tooling.

OpenClaw admin capabilities include:

*   CLI (setup, configure, doctor, status)
*   Context inspection commands
*   Transcript inspection
*   Configuration file control (openclaw.json)
*   Channel configuration
*   Retry and streaming tuning
*   Tool policy enforcement
*   Sandbox enforcement
*   Plugin hook registration
*   Model configuration and escalation controls

For remram, the admin experience will primarily use OpenClaw out of the box. There is no need to replace the control UI or CLI.

Potential remram-specific additions may include lightweight diagnostics (e.g., retrieval injection metrics), but these would be implemented as plugins or observability extensions — not as a replacement admin interface.

### OpenClaw UX Services in remram

This section clarifies how remram will use OpenClaw’s existing UX-related services as the foundation for its client and administrative interfaces. The objective is not to redesign the runtime or replace built-in capabilities, but to leverage OpenClaw’s messaging, session, and streaming infrastructure while layering remram-specific client experiences on top.

remram will begin with a single client surface to validate core cognition and runtime integration. During this phase, we will rely almost entirely on OpenClaw’s built-in gateway APIs and messaging pipeline. As the UX matures, we will transition to a dedicated web client and eventually a mobile client. These evolutions affect presentation only — not the underlying runtime contract.

OpenClaw UX services used directly in remram include:

*   Gateway RPC (agent, agent.wait)
*   Streaming event channels (assistant/tool/lifecycle)
*   Session management and transcript persistence
*   Queueing and concurrency controls
*   Retry policies and transport abstraction
*   Cron and spawned session delivery
*   Context inspection endpoints
*   Workspace-backed file access

remram’s primary responsibility in this domain is to consume these services cleanly and consistently. The client layer will:

*   Connect to OpenClaw via supported APIs
*   Render streaming responses
*   Respect session isolation rules
*   Surface cron and spawned outputs appropriately
*   Utilize existing message routing and queue behaviors

Where additional capabilities are required (e.g., structured feed surfaces or enhanced diagnostics), remram may introduce supplementary APIs or plugins. However, these will extend the gateway rather than fork or replace it.

The long-term plan — web client, mobile client, voice interface — does not change the runtime dependency. All remram UX surfaces remain thin clients over OpenClaw’s gateway.

In short:

OpenClaw provides the execution and session substrate.  
remram consumes and presents it.

No duplication of messaging infrastructure.  
No replacement of runtime mechanics.  
Only layered client experience.

\\

## Feature Responsibility Map

This section maps runtime and memory features to their authoritative provider. It clarifies which capabilities are native to OpenClaw and which are layered by Remram through documented extension points.

The purpose is architectural clarity. Every feature must resolve to either:

*   OpenClaw runtime authority, or
*   A Remram layer attached through an explicit OpenClaw surface.

### Execution & Session Runtime

These capabilities are fully owned by OpenClaw. Remram uses them as-is.

| **Feature** | **Authority** | **OpenClaw Surface** |
| --- | --- | --- |
| Message intake & routing | OpenClaw | Gateway channel adapters |
| Session key resolution | OpenClaw | session.\* configuration |
| Transcript persistence | OpenClaw | JSONL session store |
| Session isolation | OpenClaw | dmScope, identityLinks |
| Concurrency control | OpenClaw | Command Queue |
| Retry policy | OpenClaw | channels.\*.retry |
| Streaming (block/preview) | OpenClaw | agents.defaults.blockStreaming\* |
| Tool execution | OpenClaw | Embedded agent runtime |
| Sandbox isolation | OpenClaw | agents.defaults.sandbox |
| Cron scheduling | OpenClaw | cron configuration |

Remram does not replace or fork these mechanisms.

### Orchestration Policy (Attached to OpenClaw Hooks)

These behaviors are implemented by Remram but executed through OpenClaw’s documented hook system.

| **Feature** | **Authority** | **OpenClaw Hook** |
| --- | --- | --- |
| Model escalation policy | Remram | before\_model\_resolve |
| Context injection | Remram | before\_prompt\_build |
| Tool output capture | Remram | tool\_result\_persist |
| Post-run reflection trigger | Remram | agent\_end |
| Background reflection runs | Remram | sessions\_spawn |
| Scheduled dream cycles | Remram | cron sessions |

All policy logic attaches to runtime via hooks. OpenClaw remains the execution authority.

### Memory & Knowledge Authority

OpenClaw provides session memory and workspace storage. Remram governs durable knowledge.

| **Feature** | **Authority** | **OpenClaw Surface Used** |
| --- | --- | --- |
| Session transcripts | OpenClaw | JSONL store |
| Workspace files | OpenClaw | agents.defaults.workspace |
| Bootstrap injection | OpenClaw | Prompt assembly pipeline |
| Structured long-term memory | Remram | Injected via before\_prompt\_build |
| Reflection cycles | Remram | agent\_end + sessions\_spawn |
| Dream reconciliation | Remram | cron sessions |
| Identity mutation | Remram | Workspace file tools |

Disabled OpenClaw subsystems (to avoid dual authority):

*   SQLite vector memory
*   Hybrid BM25 search
*   QMD backend
*   Built-in memory\_search

OpenClaw continues to provide workspace storage and prompt assembly. Remram centralizes retrieval externally.

### User & Admin Experience

OpenClaw provides a complete runtime interface and management surface. Remram consumes these services through client applications.

| **Feature** | **Authority** | **OpenClaw Surface Used** |
| --- | --- | --- |
| Chat transport | OpenClaw | Gateway RPC + streaming |
| Session continuity | OpenClaw | Session model |
| Transcript inspection | OpenClaw | CLI / Control UI |
| Runtime configuration | OpenClaw | openclaw.json |
| Client chat interface | Remram | Gateway APIs |
| Memory visualization | Remram | Retrieval + injection layer |
| Artifact browsing | Remram | Workspace file access |
| Event feed | Remram | Cron + spawn output |

All UX clients must route through the OpenClaw Gateway. No direct model invocation from clients.

### Responsibility Boundary

OpenClaw defines:

*   How agents execute
*   How sessions persist
*   How isolation is enforced
*   How tools are invoked
*   How context is bounded
*   How background jobs run

Remram defines:

*   What knowledge is durable
*   What context is injected
*   When escalation occurs
*   How identity evolves
*   How memory matures over time