# OpenClaw OS Extensibility and Integration Guide for a Family Multi-Agent System

## Executive summary

Your fastest path to a “first‑class” integration is to treat OpenClaw as the control plane (routing, policy, session + prompt lifecycle) and build your project as _three deployable artifact families_: **configuration (JSON5)**, **skills (SKILL.md runbooks)**, and \*\*plugins (TypeScript in‑process extensions)\*\*—with **Remram/OpenSearch as a derived memory substrate** behind a **memory-slot plugin**. OpenClaw already gives you strict schema validation, config composition (`$include`), hot reload for most settings, and control-plane RPCs (`config.apply`, `config.patch`) that you can drive from your CI/CD pipeline. citeturn17view0turn6view0turn6view3

The non-obvious architectural “unlock” is that OpenClaw’s plugin system is not just “extra tools”: the core repo exposes **plugin lifecycle hooks** (e.g., `before_tool_call`, `after_tool_call`, `llm_input`, `llm_output`, `tool_result_persist`) and **HTTP handlers/routes** at the Gateway, enabling you to implement guardrails, ingestion, and memory indexing as _first‑class runtime behavior_, not just prompts. citeturn26view1turn26view0turn9search1

Key recommendations (assumptions noted inline):

*   Build a **memory-slot plugin** (`kind: "memory"`) to provide `memory_search`/`memory_get` tools backed by Remram/OpenSearch, while keeping OpenClaw’s Markdown workspace memory as the source of truth (rebuildable derived index). citeturn12search4turn7view3turn26view1
*   Use **multi-agent routing + DM isolation** (`agents.list` + `bindings`, plus secure DM scoping) to create per-user “Family AI” behaviors without accidentally sharing context across senders. citeturn21view1turn10search3
*   Treat **skills as governance + runbooks** (human-auditable operational capability) and **plugins as enforcement + integration code** (tools, hooks, background services, RPC/HTTP surfaces). citeturn15view4turn9search0turn26view1
*   For the appliance: pin OpenSearch storage to dedicated NVMe via `path.data`, tune JVM heap and OS kernel settings, and operationalize snapshots as your backup primitive. citeturn16search16turn4search20turn16search7turn27search0
*   Treat Gateway/plugin HTTP surfaces as _high-risk exposure_: at least one upstream issue reports plugin HTTP routes bypassing Gateway auth in some versions, so default to loopback/VPN-only exposure and explicit allowlists. citeturn24view0turn26view0turn11search21

Where specifics are unspecified (e.g., exact repo names, exact Remram APIs, your embedding model/router protocol), this report states assumptions and provides patterns you can concretize.

## OpenClaw extensibility inventory

OpenClaw’s extensibility points cluster into four layers: **configuration**, **runtime extension (plugins/tools)**, **skills + automation**, and **control plane operations**.

### Configuration and composition

OpenClaw reads an optional JSON5 config at `~/.openclaw/openclaw.json`, and fails closed: unknown keys or invalid schema causes the Gateway to refuse to start (diagnostic commands still work). citeturn17view0

Key config extensibility mechanisms:

*   **Structured composition via** `**$include**`: single-file replacement or array deep-merge, sibling overrides, nested includes (up to 10 levels), and strict erroring on missing/circular includes. citeturn6view0
*   **Environment management**: reads `.env` from CWD and `~/.openclaw/.env` (no override of existing env), inline env injection, and `${VAR_NAME}` substitution inside config values (including include files). citeturn6view2turn17view0
*   **Hot reload modes** (`hybrid|hot|restart|off`) and a documented hot-apply vs restart-required matrix. Notably, `plugins` and some infra settings require restart, while agents/channels/tools/skills/automation are generally hot-applied. citeturn6view3

Practical implication for your project: your _primary “OS artifacts”_ will be (1) a root `openclaw.json` and (2) a tree of included JSON5 fragments that cleanly isolate modules (agents/tools/channels/plugins/hooks/cron).

### Agent system and routing surfaces

OpenClaw supports multi-agent operation inside one Gateway:

*   `agents.defaults.*` establishes global defaults (workspace, model config, sandbox, heartbeat, pruning/compaction, etc.). citeturn10search2turn19view0
*   `agents.list[]` defines per-agent overrides (workspace isolation, per-agent tools policy, sandbox mode, etc.). citeturn19view0
*   `bindings[]` routes inbound messages to agents using deterministic match order. Match supports `channel`, optional `accountId`, and optional `peer` (`{ kind: direct|group|channel, id }`), plus channel-specific fields like guild/team IDs. citeturn21view0turn21view1

This is your primary “Family AI” extensibility surface: it’s how you create per-user agents, per-surface agents (e.g., “family group chat agent”), and isolate workspaces/sessions.

### Channels and conversational policy surfaces

Messaging channels are configured under `channels.<provider>`, with consistent DM policy patterns (`pairing|allowlist|open|disabled`) and group policy patterns (`allowlist|open|disabled`) described in both task docs and the full reference. citeturn17view0turn19view0

Channel config is a major extensibility point because it binds identity and access (who can talk to the system, where, and under what constraints). Examples include message gating (`requireMention`, mention patterns), per-guild/per-group settings, and per-channel model overrides (`channels.modelByChannel`). citeturn17view0turn19view0

### Tools policy surfaces

Tools are an explicit governance surface, not just “capabilities”:

*   Tool profiles (`minimal|coding|messaging|full`) establish base allowlists; allow/deny and provider-specific restrictions (`tools.byProvider`) further narrow tool availability. citeturn12search3
*   Tool groups (e.g., `group:runtime`, `group:fs`, `group:memory`, `group:web`, `group:messaging`) let you express policy at a high level while still controlling specific tools. citeturn12search3

This is foundational for safety/guardrails: you can define “family agents” with messaging + memory only, “ingestion agents” with file + exec (node-hosted), and “operator agent” with full tooling—without rewriting code.

### Skills surfaces

Skills are portable, text-first runbooks discovered from:

1.  bundled skills, 2) `~/.openclaw/skills`, 3) `<workspace>/skills` (highest precedence), plus optional `skills.load.extraDirs` as lowest precedence. citeturn15view4turn19view0

Skills support:

*   **Gating** via metadata (OS, required bins/env/config keys) and per-skill config injection via `skills.entries.<skillKey>.env|apiKey|config`. citeturn15view2turn19view0
*   **Watcher-driven refresh** (`skills.load.watch`) to bump skill snapshots when `SKILL.md` changes. citeturn15view0
*   A documented **token impact model** for how skills appear in the system prompt, useful for performance budgeting at scale. citeturn15view2

Plugins can ship skills by listing skill directories in the plugin manifest; those skills load when the plugin is enabled. citeturn15view4turn9search1

### Automation surfaces

OpenClaw has multiple automation modalities:

*   **Event-driven internal hooks**: TypeScript hook packs discovered from workspace/managed/bundled hook directories; enable/disable via CLI (and show eligibility, requirements, etc.). citeturn12search13turn12search1
*   **HTTP hooks (webhooks)**: Configurable `hooks.*` section defines an authenticated `/hooks/*` ingress with mappings, transforms, agent routing, session key handling, and delivery options. citeturn20view0turn19view0
*   **Cron**: A scheduler with Gateway-level settings (`cron.*`) governing concurrency, retention, and run logs; jobs persist in Gateway state (not just config). citeturn20view1turn27search9
*   **Agent heartbeat**: A built-in periodic execution concept (distinct from cron) and explicitly called out as hot-applied configuration. citeturn6view3turn19view0

### Plugins and extension APIs

Plugins are TypeScript modules loaded at runtime, discovered in a documented order (config paths, workspace extensions, global extensions, bundled). OpenClaw performs security checks on candidate paths and strongly recommends allowlisting trusted plugins. citeturn7view3turn9search1

From the docs, plugins can register: Gateway RPC methods, HTTP handlers, agent tools, CLI commands, background services, hooks, skills, and auto-reply commands. citeturn9search1turn8view1turn22view2

From the core repo’s plugin types, the plugin API includes concrete registration calls:

*   `registerTool`, `registerHook`, `registerGatewayMethod`, `registerCommand`, `registerService`, `registerProvider`, and critically `**registerHttpHandler**` **/** `**registerHttpRoute**`. citeturn26view1

The core repo also defines **plugin lifecycle hooks** including (non-exhaustive): `before_model_resolve`, `before_prompt_build`, `llm_input`, `llm_output`, `before_tool_call`, `after_tool_call`, `tool_result_persist`, `session_start`, `session_end`, `gateway_start`, `gateway_stop`, etc. citeturn26view1

This is the deepest extensibility surface for your project because it lets you implement:

*   centralized safety filters (block/transform tool calls),
*   memory auto-recall/capture injection before prompts,
*   sanitization of persisted tool results,
*   ingestion side-effects driven by session lifecycle.

### Control plane RPCs and programmatic configuration

OpenClaw provides control-plane write RPCs:

*   `config.apply` (full replace, validate, write, and restart), and `config.patch` (partial merge patch semantics). These are rate-limited (3/60s per deviceId+clientIp), coalesce restarts, and enforce cooldown between restart cycles. citeturn6view3turn17view0

This is the backbone for “configuration as code” deployments and controlled rollouts from your CI/CD pipeline.

## Mapping OpenClaw extensibility to your project modules

Assumption: your system has five major modules—**memory (Remram/OpenSearch)**, **per-user multi-agent Family AI behaviors**, **ingestion pipelines**, **safety/guardrails**, and **deployment appliance constraints**—and you want OpenClaw OS clarified as the host runtime and control plane.

### Architecture overview

```
flowchart TD
  subgraph Gateway["OpenClaw Gateway (control plane)"]
    Channels["Channels (WhatsApp/Telegram/etc.)"] --> Router["Routing (bindings + session keys)"]
    Router --> Agents["Agents (per-user + roles)"]
    Agents --> ToolPolicy["Tool policy (profiles + allow/deny + sandbox)"]
    Agents --> Skills["Skills (runbooks injected into system prompt)"]
    Automation["Automation (hooks + cron + webhooks)"] --> Agents

    Plugins["Plugins (TS modules)"] --> ToolPolicy
    Plugins --> RPC["Gateway RPC methods"]
    Plugins --> HTTP["Gateway HTTP handlers/routes"]
    Plugins --> HookLife["Lifecycle hooks (before_tool_call, llm_input, ...)"]
  end

  subgraph Memory["Memory subsystem"]
    Workspace["Workspace Markdown memory (source of truth)"] --> Indexer["Indexer (plugin service + ingestion)"]
    Indexer --> OpenSearch["OpenSearch (derived index)"]
    OpenSearch --> Recall["memory_search/memory_get tools"]
  end

  Agents --> Recall
  ToolPolicy --> NodeExec["Node-host exec (GPU router box)"]
  NodeExec --> Embeddings["Embedding / inference services"]

  classDef core fill:#f5f5f5,stroke:#999,stroke-width:1px;
  class Gateway,Memory core;
```

This aligns with OpenClaw’s own “Markdown is source of truth” memory model (files are what persists, tooling enables recall) while letting Remram/OpenSearch become your scalable derived store. citeturn12search4turn18view2turn26view1

### Module-by-module mapping

**Memory subsystem (Remram/OpenSearch)**  
Primary OpenClaw extensibility points:

*   Memory is “plain Markdown in the agent workspace”; memory search tools are provided by the active memory plugin (`plugins.slots.memory`), and can be disabled via slot selection. citeturn12search4turn7view3
*   Plugins support an exclusive `kind: "memory"` slot type in the core repo type definitions, meaning your memory integration should ship as a memory-kind plugin. citeturn26view1turn7view3  
    Recommended integration: implement a **memory-slot plugin** that (1) indexes workspace Markdown + ingestion artifacts into OpenSearch, and (2) exposes recall tools (`memory_search`, `memory_get`) via `registerTool`. (Tool group `group:memory` already exists for policy control.) citeturn12search3turn9search0turn26view1

**Per-user multi-agent Family AI behaviors**  
Primary OpenClaw extensibility points:

*   `agents.list` defines agents and separate workspaces; `bindings` routes traffic deterministically based on channel/account/peer/guild/team. citeturn21view1turn21view0
*   Secure DM mode uses `session.dmScope` to prevent cross-sender context mixing when multiple people can DM the bot (critical for family scenarios where multiple senders share one channel surface). citeturn10search3turn19view0  
    Recommended integration: define per-user agents (e.g., parent/child agents) with different tool profiles and memory policies, and route DMs and group spaces explicitly via `bindings.match.peer`. citeturn21view0turn12search3

**Ingestion pipelines**  
Primary OpenClaw extensibility points:

*   Event-driven internal hooks system (for lifecycle events like `/new`), plus HTTP hooks (webhook ingress) that can route to specific agents and sessions with allowlisted session key prefixes. citeturn12search13turn20view0
*   Cron configuration provides concurrency controls and retention for scheduled runs, and OpenSearch Dashboards supports snapshot management if you go that route operationally. citeturn20view1turn27search9  
    Recommended integration:
*   Use **HTTP hooks** for external ingestion triggers (email/webhook feeds, file-drop events, etc.), with a dedicated ingestion agent and strict `allowedSessionKeyPrefixes`. citeturn20view0turn21view1
*   Use **plugin services** + lifecycle hooks for continuous indexing (watch workspace changes, persist tool results, run background indexing). citeturn8view1turn26view1turn22view2

**Safety and guardrails**  
Primary OpenClaw extensibility points:

*   Tool policy (profiles, allow/deny, byProvider) and sandboxing/exec approvals are explicit governance layers. citeturn12search3turn18view1turn19view0
*   Plugins run in-process and are “trusted code”; allowlists are recommended. citeturn14view1turn7view3
*   Core repo provides plugin lifecycle hooks like `before_tool_call` and `after_tool_call`, allowing centralized enforcement/filters around tool usage. citeturn26view1  
    Recommended integration:
*   Use tool policy to enforce least-privilege per-agent and per-provider. citeturn12search3turn19view0
*   Add a “guardrails plugin” using `before_tool_call` + `after_tool_call` to implement deny/allow decisions, argument canonicalization, and output redaction (especially before persistence). citeturn26view1turn12search14

**Deployment appliance constraints (NVMe for OpenSearch, GPU router)**  
Primary extensibility points:

*   OpenSearch disk placement is controlled by `path.data` in `opensearch.yml`, supporting multiple locations separated by commas; use your dedicated NVMe mount here. citeturn16search16
*   OpenClaw nodes allow a Gateway to forward `exec` calls to another machine, with approvals enforced locally on the execution host (`~/.openclaw/exec-approvals.json`). citeturn18view2turn18view1  
    Recommended integration:
*   Treat your GPU router box as a **node host** and run embedding generation / heavy transforms there via allowlisted exec, keeping the Gateway and OpenSearch stable on the primary appliance. citeturn18view2turn18view0

## Artifact layouts and exact filenames

This section proposes a “configuration as code” layout that maps cleanly onto OpenClaw’s include system, skill discovery rules, and plugin discovery/trust controls.

### Deployment surfaces on disk

**OpenClaw state + config (host OS):**

*   `~/.openclaw/openclaw.json` (root JSON5, schema-validated). citeturn17view0turn19view0
*   `~/.openclaw/.env` and/or project-local `.env` (secrets precedence rules apply). citeturn6view2
*   `~/.openclaw/extensions/<plugin-id>/...` (installed plugins). citeturn7view3turn9search1
*   `~/.openclaw/skills/...` (managed/local skills visible across all agents). citeturn15view4
*   `~/.openclaw/hooks/...` (managed hooks / hook packs). citeturn12search13
*   `~/.openclaw/agents/<agentId>/sessions/*.jsonl` (session transcripts on disk). citeturn12search14

**Per-agent workspace (human-auditable state):**

*   `<workspace>/skills/*` (per-agent skills, highest precedence). citeturn15view4
*   `<workspace>/memory/YYYY-MM-DD.md` + optional `MEMORY.md` (canonical memory files). citeturn12search4turn12search5
*   Optional derived memory store under workspace (OpenClaw research note suggests derived index under workspace, rebuildable from Markdown; adapt this pattern to OpenSearch as your derived store). citeturn12search2turn12search4

### Recommended Git repo layout

Assumption: you want a single “distribution” repo that builds and deploys artifacts to a target appliance host. Repo names are intentionally generic.

```
repo: family-ai-openc law/
  README.md

  openc law/
    config/
      openclaw.json5                 # root entry (deployed to ~/.openclaw/openclaw.json)
      gateway.json5                  # gateway.*, identity, logging
      env.json5                      # inline env vars (non-secret), config substitution anchors

      agents/
        defaults.json5               # agents.defaults.*
        family-agents.json5          # agents.list[] and bindings[]
        routing.json5                # bindings match peer objects, channel/account routing

      tools/
        policy.json5                 # tools.profile, allow/deny, byProvider
        exec-node.json5              # tools.exec host=node + guardrails defaults

      channels/
        whatsapp.json5
        telegram.json5
        discord.json5                # if used for “family server”
        channel-model-overrides.json5

      automation/
        hooks-http.json5             # hooks.* (webhook ingress)
        cron.json5                   # cron.* baseline

      plugins/
        plugins.json5                # plugins.allow/deny/load.paths + slots + entries.<id>

    skills/
      family-orchestrator/
        SKILL.md
      ingestion/
        SKILL.md
      memory-ops/
        SKILL.md
      safety/
        SKILL.md

  plugins/
    memory-opensearch/               # your slot-based memory plugin
      openclaw.plugin.json
      package.json
      src/
        index.ts
        opensearch/
          client.ts
          index-templates.ts
          queries.ts
        hooks/
          persist.ts
          recall.ts
      skills/
        memory-opensearch/
          SKILL.md
      test/
        memory-opensearch.plugin.test.ts

    guardrails/                      # before_tool_call/after_tool_call policy plugin
      openclaw.plugin.json
      package.json
      src/index.ts
      skills/guardrails/SKILL.md
      test/guardrails.plugin.test.ts

  opensearch/
    configs/
      opensearch.yml                 # appliance-specific (path.data, cluster, security)
      jvm.options.d/
        heap.options                 # Xms/Xmx pins (if packaging this way)
    templates/
      remr am-base.template.json
      remram-facts.template.json
      remram-chunks.template.json
    pipelines/
      embed.pipeline.json
    runbooks/
      OPENSEARCH_RUNBOOK.md
      BACKUP_RESTORE.md
```

This structure makes “what you are creating” explicit:

*   JSON5 configs (deployed) citeturn17view0turn6view0
*   Skills (runbooks) with precedence rules citeturn15view4turn15view2
*   Plugins (code + manifest + tests) citeturn7view3turn14view1turn26view1
*   OpenSearch operational artifacts (yml, templates, pipelines, runbooks) citeturn16search0turn3search36turn27search0

### Artifact type comparison

| Artifact type | Purpose in OpenClaw OS | Where it lives | Hot reload vs restart | Best for |
| --- | --- | --- | --- | --- |
| JSON5 config fragments (`*.json5`) | Declarative routing, policy, channel access, plugin enablement | `~/.openclaw/openclaw.json` + included files | Mostly hot-applies; `plugins` and `gateway.*` require restart citeturn6view3turn7view3 | Any behavior expressible as policy/routing/toggles |
| Skill (`skills/<name>/SKILL.md`) | Runbook surfaced to agents; auditable procedures | `<workspace>/skills` or `~/.openclaw/skills` | Snapshot refresh on new session; watcher can refresh mid-session citeturn15view2turn15view0 | Ingestion procedures, operational playbooks, human-visible “capabilities” |
| Plugin (TypeScript + `openclaw.plugin.json`) | In-process extensions: tools, hooks, services, RPC/HTTP, lifecycle interception | `~/.openclaw/extensions/*` or workspace extensions | Requires Gateway restart when config/plugins change citeturn7view3turn6view3 | Memory backend, guardrails enforcement, integration code |
| Hook pack (TypeScript handler + HOOK.md etc.) | Event-driven automation (e.g., session memory snapshots) | workspace/managed/bundled hook dirs | Generally hot-applies (automation category), but enablement flows may require reload depending on version citeturn6view3turn12search13 | Side-effects on lifecycle events (`/new`, startup, auditing) |
| OpenSearch index templates / pipelines | Derived memory indexing, retrieval optimization | OpenSearch cluster state | N/A (API-driven) | Retrieval quality, privacy partitioning, performance |

## Configuration templates and sample JSON5 snippets

The snippets below are deliberately modular and aligned to the config reference (field names, structures, and behaviors). OpenClaw config is strict-schema validated; treat these as _schemas-first_ artifacts you’ll validate in CI before deployment. citeturn17view0turn19view0turn6view0

### Root config with `$include`

```
// openc law/config/openclaw.json5  → deploy to ~/.openclaw/openclaw.json
{
  // Optional: editor schema binding (allowed root-level exception)
  $schema: "https://docs.openclaw.ai/schemas/openclaw.schema.json",

  env: { $include: "./env.json5" },

  gateway: { $include: "./gateway.json5" },

  agents: { $include: "./agents/defaults.json5" },
  bindings: { $include: "./agents/routing.json5" },

  tools: { $include: "./tools/policy.json5" },

  channels: {
    $include: [
      "./channels/whatsapp.json5",
      "./channels/telegram.json5",
      "./channels/channel-model-overrides.json5",
    ],
  },

  skills: { $include: "./skills/skills.json5" },

  plugins: { $include: "./plugins/plugins.json5" },

  hooks: { $include: "./automation/hooks-http.json5" },
  cron: { $include: "./automation/cron.json5" },
}
```

`$include` supports file replacement or deep-merged arrays, sibling overrides, relative-path resolution, and nested includes up to a depth limit. citeturn6view0

### Agents and bindings (per-user Family AI)

```
// openc law/config/agents/family-agents.json5
{
  agents: {
    defaults: {
      workspace: "~/.openclaw/workspaces/family-orchestrator",
      userTimezone: "America/Denver",

      // model catalog + allowlist strategy (aliases optional)
      model: {
        primary: "anthropic/claude-opus-4-6",
        fallbacks: ["openai/gpt-5.2"],
      },

      // Run periodic “care + maintenance” turns (distinct from cron jobs)
      heartbeat: { every: "30m" },
    },

    list: [
      {
        id: "orchestrator",
        default: true,
        workspace: "~/.openclaw/workspaces/family-orchestrator",
        tools: { profile: "full" },
        sandbox: { mode: "off" },
      },
      {
        id: "family",
        workspace: "~/.openclaw/workspaces/family",
        // Safer baseline: no host exec by default
        tools: { profile: "messaging", allow: ["group:memory"] },
        sandbox: { mode: "non-main", scope: "agent", workspaceAccess: "ro" },
      },
      {
        id: "kids",
        workspace: "~/.openclaw/workspaces/kids",
        tools: { profile: "messaging", allow: ["group:memory"] },
        sandbox: { mode: "all", scope: "agent", workspaceAccess: "ro" },
      },
    ],
  },

  // Secure DM isolation when multiple people can DM (reduces cross-sender context bleed)
  session: { dmScope: "per-channel-peer" },

  // Bind specific chat peers or accounts to specific agents
  bindings: [
    {
      agentId: "orchestrator",
      match: { channel: "whatsapp", accountId: "personal" },
    },
    {
      agentId: "family",
      match: {
        channel: "telegram",
        peer: { kind: "group", id: "-1001234567890" },
      },
    },
  ],
}
```

Multi-agent routing uses `agents.list` plus deterministic binding match fields and ordering. citeturn21view1turn21view0turn19view0  
Secure DM mode is recommended when multiple inbound DM senders exist. citeturn10search3turn19view0  
Per-agent access profiles can combine sandbox mode + tool allowlists for least privilege. citeturn21view1turn19view0turn12search3

### Tools policy (global + node-hosted GPU router exec)

```
// openc law/config/tools/policy.json5
{
  tools: {
    // Base posture
    profile: "coding",

    // Deny risky runtime tools by default; re-enable per-agent if needed
    deny: ["group:runtime"],

    // Allow memory + sessions + messaging for most agents
    allow: ["group:memory", "group:sessions", "message"],

    // Provider-specific narrowing: keep tool surface minimal for weaker/cheaper models
    byProvider: {
      "openrouter": { profile: "minimal" },
    },

    // Exec defaults: route to a node host when explicitly enabled (GPU router box)
    exec: {
      host: "node",
      security: "allowlist",
      ask: "on-miss",
      node: "gpu-router-1",
    },
  },
}
```

Tool profiles/groups and by-provider restrictions are built-in governance primitives. citeturn12search3turn19view0  
Exec can target `host=node`, with approvals enforced on the node. citeturn18view2turn18view1turn18view0

### Channels (access + mention gating)

```
// openc law/config/channels/telegram.json5
{
  channels: {
    telegram: {
      enabled: true,
      botToken: "${TELEGRAM_BOT_TOKEN}",

      dmPolicy: "pairing",

      // Group allowlist with mention gating defaults
      groups: {
        "*": { requireMention: true },

        // Family group: allow without mention in a specific topic
        "-1001234567890": {
          topics: {
            "99": { requireMention: false },
          },
        },
      },

      groupPolicy: "allowlist",
    },
  },
}
```

Telegram DM policy and group/topic controls are explicitly defined in the reference, including topic overrides. citeturn19view0turn10search4

### Plugins and slots (memory backend + guardrails)

```
// openc law/config/plugins/plugins.json5
{
  plugins: {
    enabled: true,

    // Pin trust: allowlist known plugin ids; deny wins over allow
    allow: ["memory-opensearch", "guardrails"],
    deny: ["untrusted-plugin"],

    // Load path for local dev builds (in addition to installed extensions)
    load: { paths: ["~/Projects/family-ai-openc law/plugins/memory-opensearch"] },

    // Exclusive slot selection: replace built-in memory backends
    slots: {
      memory: "memory-opensearch",
    },

    entries: {
      "memory-opensearch": {
        enabled: true,
        config: {
          endpoint: "https://opensearch.local:9200",
          indexPrefix: "remram",
          tenantMode: "per-user-index",
        },
      },

      guardrails: {
        enabled: true,
        config: {
          piiRedaction: true,
          toolWriteRequiresAuth: true,
        },
      },
    },
  },
}
```

Plugin discovery order, allow/deny trust controls, per-plugin config schema validation, and exclusive slot selection are documented. citeturn7view3turn9search1turn8view1  
Plugin kind includes `memory` as an explicit kind in core types (slot-based). citeturn26view1turn7view3

### Automation (HTTP hooks ingress + cron baseline)

```
// openc law/config/automation/hooks-http.json5
{
  hooks: {
    enabled: true,
    token: "${OPENCLAW_HOOKS_TOKEN}",
    path: "/hooks",

    // Constrain session keys callers can supply (default is closed)
    allowRequestSessionKey: false,
    allowedSessionKeyPrefixes: ["hook:"],

    // Route to a dedicated ingestion agent when desired
    allowedAgentIds: ["hooks", "orchestrator"],

    mappings: [
      {
        match: { path: "ingest" },
        action: "agent",
        agentId: "orchestrator",
        wakeMode: "now",
        sessionKey: "hook:ingest:{{source}}:{{id}}",
        messageTemplate: "INGEST EVENT\nsource={{source}}\nid={{id}}\n{{payload}}",
        deliver: false,
      },
    ],
  },
}
```

The `hooks` section defines an authenticated `/hooks/*` ingress with mappings, templating, transform modules constrained to `hooks.transformsDir`, and explicit controls around session keys and agent routing. citeturn20view0turn19view0

```
// openc law/config/automation/cron.json5
{
  cron: {
    enabled: true,
    maxConcurrentRuns: 2,
    sessionRetention: "24h",
    runLog: { maxBytes: "2mb", keepLines: 2000 },
  },
}
```

Cron config defines concurrency, retention of cron-run sessions, and run log pruning behavior. citeturn20view1turn19view0

## Plugin and skill design patterns

### Choosing between config, skills, and plugins

| Approach | Best when | Strengths | Weaknesses / risks |
| --- | --- | --- | --- |
| Config-only | Behavior is routing/policy/toggles | Safe, schema-validated, hot reload for most fields citeturn17view0turn6view3 | Cannot implement new runtime behavior or integrations |
| Skill-first | You need auditable runbooks and operator-visible procedures | Human-readable, precedence-controlled, gated by env/bins/config, auto-refresh watcher citeturn15view4turn15view0turn15view2 | Not enforcement; relies on model compliance unless paired with tool policy/guardrails |
| Plugin-first | You need integration code, enforcement, new tools, background services | Full code execution: tools, RPC, HTTP, services, lifecycle hooks citeturn26view1turn22view2turn9search0 | Runs in-process (trusted code), requires restarts for plugin config changes citeturn7view3turn14view1 |

### Skill/runbook template (SKILL.md frontmatter)

Skills are “AgentSkills + Pi-compatible”, with gating metadata keys like OS filters, required bins/env/config, and install hints. citeturn15view2turn15view3

Template:

```
---
name: memory-ops
description: "Operate and validate Remram/OpenSearch-backed memory for family agents"
emoji: "🧠"
os: ["linux"]
requires:
  anyBins: ["curl"]
  env: ["OPENSEARCH_URL"]
  config: ["plugins.entries.memory-opensearch.enabled"]
---

# Memory Ops (Remram/OpenSearch)

## When to use
- Memory search is failing or low quality
- After deploying new index templates or embedding model changes
- Before/after backups and restores

## Procedures

### Validate memory health
1) Check OpenClaw memory status (high-level)
2) Query OpenSearch cluster health
3) Run a sample `memory_search` against a known fact

### Reindex (safe mode)
- Run a “dry run” that only parses Markdown and reports changed chunks
- Apply index template updates
- Run full reindex with rate limiting
```

Gating keys (`os`, `requires.*`, `primaryEnv`, `install`, etc.) and per-skill config injection via `skills.entries.*` are supported. citeturn15view2turn19view0

### Memory plugin pattern (Remram/OpenSearch)

This plugin should be your “core integration”: it replaces the default memory backend via the memory slot and exposes recall tools.

**Plugin manifest + slot**

*   Plugins can declare `kind: "memory"`; OpenClaw loads the active memory plugin via `plugins.slots.memory`. citeturn7view3turn26view1

**Tool surface**

*   Register `memory_search` and `memory_get`\-like tools (or expose additional tools like `remram_ingest`, `remram_reindex`) and control them via OpenClaw tool allow/deny. Plugin tools can be required or optional (opt-in). citeturn9search0turn12search3turn26view1

**Background service**

*   Use `registerService` to run a file watcher + batching indexer:
    *   Watch workspace `memory/` and optionally session transcript directories.
    *   Chunk Markdown into stable ids.
    *   Generate embeddings via GPU router or OpenSearch pipeline.
    *   Upsert chunks into OpenSearch with versioning.

Background services registration is explicitly supported in plugin docs. citeturn22view2turn8view1turn26view1

**Lifecycle hooks for “automatic memory”**  
From core types, you can hook:

*   `before_prompt_build`: inject top-k recalled facts into prompt context.
*   `before_tool_call` / `after_tool_call`: block risky tools or redact outputs; also capture important tool results into memory index.
*   `tool_result_persist`: sanitize what gets written to the session transcript (privacy/PII minimization).
*   `before_reset` / `session_end`: snapshot session summary into Markdown then index it. citeturn26view1turn12search14

### Guardrails plugin pattern

Your safety module can live as a plugin that combines **declarative policy** (config + tool allow/deny) with **enforcement hooks** (plugin lifecycle hooks), because the core repo explicitly defines `before_tool_call` and `after_tool_call` hook names and semantics. citeturn26view1turn12search3

Recommended guardrails responsibilities:

*   **Tool gating and parameter normalization**: in `before_tool_call`, reject tool usage not allowed for that agent/session or require an explicit “elevated” state before running side-effecting tools. citeturn12search3turn18view0turn26view1
*   **Output redaction**: in `after_tool_call` and/or `tool_result_persist`, scrub secrets/PII before the result hits the transcript or memory index (OpenClaw stores transcripts on disk; treat disk as trust boundary). citeturn12search14turn26view1
*   **HTTP surface hardening**: if you expose plugin HTTP routes, treat them as privileged endpoints and avoid public exposure; one upstream report indicates plugin HTTP routes may bypass Gateway auth checks in some versions, so plan defense-in-depth (loopback bind, VPN-only, explicit in-plugin auth, or avoid plugin HTTP entirely). citeturn24view0turn26view0turn11search21

## Memory integration patterns for Remram/OpenSearch

Assumption: Remram is your memory subsystem layer, and OpenSearch is the persistence + retrieval engine. OpenClaw expects memory to be Markdown-first, so you should treat OpenSearch as a _derived index_ that is rebuildable from the workspace source. citeturn12search4turn12search2

### Index topology and templates

Use composable index templates to standardize mappings/settings across memory indices. citeturn3search36

Suggested index families (example prefixes):

*   `remram-facts-*`: durable facts (normalized, entity-linked)
*   `remram-chunks-*`: chunked Markdown passages for recall
*   `remram-events-*`: ingestion events, tool results, session summaries
*   `remram-embeddings-*`: if you choose to store vectors separately (optional)

Core mapping features you should exploit:

*   Dense vector fields via `knn_vector` for semantic retrieval. citeturn3search38turn16search2
*   Numeric relevance features via `rank_feature` / `rank_features` (e.g., recency boost, source reliability, user affinity), and query-time boosting via `rank_feature` query. citeturn5search3turn5search0turn5search10

### Embedding pipelines

You have two viable embedding patterns:

**Pattern A: External embedding via GPU router (recommended for an appliance)**

*   Compute embeddings on the GPU router box (as a node-host exec target or a separate service), then write to OpenSearch. This keeps OpenSearch CPU/memory pressure lower and consolidates model management. citeturn18view2turn18view1turn3search38

**Pattern B: OpenSearch ingest pipeline embedding (optional)**

*   OpenSearch provides an `ml_inference` ingest processor that can run inference during ingest, enabling embedding-at-write if you deploy ML inference in-cluster. citeturn3search34

### Retrieval and ranking

For high-quality recall in a family assistant, use hybrid retrieval:

*   Combine lexical relevance (BM25) with vector/semantic relevance and fuse results using a hybrid query pipeline. OpenSearch documents a `hybrid` query construct and RRF support (notably in the Neural Search plugin/blog materials). citeturn5search12turn5search1turn5search2
*   Add rank\_feature/rank\_features boosts for business logic: recency, “pinned memory”, sender affinity, and confidence scores. citeturn5search0turn5search3

### Privacy policies and tenancy

OpenClaw’s own security model recommends treating the Gateway operator boundary as trusted control plane, and split mixed-trust users into separate gateways/hosts. citeturn10search6turn12search14

Given your family scenario (trusted household, but still privacy-sensitive), implement **privacy by construction**:

*   Prefer **per-user indices** (`tenantMode: "per-user-index"`) to avoid complex doc-level security. (If you later need shared family memory, create an explicit shared index and write only curated facts there.)
*   Encode `visibility` fields (`private|family|kids`) and enforce them in the memory plugin’s query layer (do not rely only on prompt instructions).
*   Avoid indexing raw session transcripts unless necessary; OpenClaw stores transcripts on disk, so indexing them increases blast radius. If you do index transcripts, sanitize via plugin hooks before persistence and indexing. citeturn12search14turn26view1

## Deployment, operations, and governance

### OpenClaw operational behaviors that matter for deployments

*   **Strict schema validation**: unknown keys break boot; use `doctor` workflows and CI validation as gating. citeturn17view0
*   **Hot reload vs restart**: most fields hot-apply; `plugins` and `gateway.*` categories require restart (config doc explicitly calls this out). citeturn6view3turn7view3
*   **Config RPCs for automation**: `config.apply` and `config.patch` exist, but are rate limited and restart-coalesced; your deployment tooling should stage changes and avoid rapid-fire updates. citeturn6view3
*   **Backup scope**: backing up only the workspace misses sessions/auth; copy the state directory _and_ workspace for full migration/restore. citeturn12search6turn12search14

### OpenSearch appliance tuning

Minimal, high-impact baseline items (all sourced from OpenSearch docs):

*   **Kernel setting**: set `vm.max_map_count >= 262144` on Linux for production workloads. citeturn4search20
*   **Heap sizing**: OpenSearch guidance states setting JVM min/max heap sizes to ~50% of RAM improves indexing performance; tarball install docs also recommend starting at half of system memory. citeturn16search7turn16search22
*   **Dedicated NVMe**: set `path.data` to the NVMe mount path (supports multiple comma-separated locations). citeturn16search16turn16search3
*   **Vector memory pressure**: k-NN plugin uses native memory and has circuit breaker settings; budget for this if you do heavy semantic retrieval. citeturn16search2

### Backups, restores, and “memory safety”

You should treat snapshots as your OpenSearch backup primitive:

*   OpenSearch snapshots are not instantaneous and don’t represent perfect point-in-time views; they capture primary shards as they existed when initiated. citeturn27search0
*   Repositories must be registered via snapshot APIs; snapshots include cluster state such as settings and index metadata (mappings/templates). citeturn27search2turn27search6
*   Snapshot restore APIs exist and support selecting which indices/data streams to restore. citeturn27search1turn27search4

Operationally, pair this with OpenClaw’s “Markdown as source of truth” approach:

*   Even if OpenSearch is lost, you can rebuild derived indices from workspace Markdown (assuming ingestion sources are either stored or reproducible). citeturn12search4turn12search2

## Testing, CI/CD, and implementation roadmap

### Testing and validation strategy

**Config validation (always-on)**

*   Treat OpenClaw config as an artifact that must pass schema validation before deploy; invalid config prevents Gateway boot. citeturn17view0
*   Use `$include` modularization to keep diffs small and reviews meaningful. citeturn6view0

**Plugin testing**

*   OpenClaw explicitly recommends plugins ship tests: in-repo plugins can keep Vitest tests under `src/**`; published plugins should validate their `openclaw.extensions` entrypoints in CI. citeturn14view1turn7view3

**End-to-end validation**

*   Canary deployment pattern: roll config updates via `config.patch` for tool policy tweaks (hot apply) and schedule restarts only when plugin/gateway fields change. citeturn6view3
*   For safety-critical surfaces: test `before_tool_call` policies (deny/allow), transcript sanitization (`tool_result_persist`), and memory recall boundaries (private vs family index separation). citeturn26view1turn12search14

### Prioritized implementation roadmap

Assumption: “Owner” roles are placeholders (you can substitute real names). Effort is relative: **S/M/L**.

| Milestone | Scope | Owner | Effort | Acceptance criteria |
| --- | --- | --- | --- | --- |
| OS artifact foundation | Repo scaffold + modular JSON5 config with `$include`; baseline agents/channels/tools; CI schema gate | Project Owner | S | Gateway boots from deployed config; hot reload works for non-restart fields citeturn6view3turn6view0 |
| Multi-agent Family AI | Per-user agents + workspaces; secure DM scoping; bindings routing; “family group agent” | Agent Systems | M | No cross-sender DM context bleed; routing deterministic by `bindings` fields citeturn21view0turn10search3 |
| Memory-slot plugin skeleton | `kind:"memory"` plugin + tool surface + OpenSearch client; initial index templates | Memory/IR | L | `plugins.slots.memory` selects plugin; `memory_search` returns results with citations to workspace files citeturn26view1turn12search4turn3search36 |
| Ingestion pipelines | HTTP hooks mappings + ingestion agent runbooks; background indexing service; GPU router as node host | Ingestion/Infra | L | Webhook ingests land in correct session keys; indexing batches succeed; node exec allowlists enforced citeturn20view0turn18view2turn18view1 |
| Guardrails enforcement | Tool policy hardening + guardrails plugin using lifecycle hooks (`before_tool_call`, `tool_result_persist`) | Security | M | High-risk tools blocked by default; transcript/memory redaction verified; policy tests exist citeturn12search3turn26view1turn14view1 |
| OpenSearch ops hardening | NVMe `path.data`, heap sizing, vm.max\_map\_count, snapshot repo + restore runbook | Infra | M | Cluster stable under load; snapshots taken/restored; runbooks documented citeturn16search16turn16search7turn4search20turn27search2 |
| Release + canary | Config deployment tooling + canary rollouts; restart gating; smoke tests | Project Owner | M | Safe roll-forward/rollback; measurable SLOs for recall latency + retrieval quality |

### Roadmap timeline

```
gantt
  title OpenClaw Integration Roadmap (Family AI + Remram/OpenSearch)
  dateFormat  YYYY-MM-DD

  section Foundation
  Config repo scaffold + include tree           :a1, 2026-02-26, 7d
  Baseline channels + tools policy              :a2, after a1, 7d

  section Family agents
  Multi-agent workspaces + bindings             :b1, 2026-03-12, 10d
  Secure DM scoping + privacy checks            :b2, after b1, 5d

  section Memory (Remram/OpenSearch)
  Memory-slot plugin skeleton                   :c1, 2026-03-24, 15d
  OpenSearch templates + hybrid retrieval       :c2, after c1, 12d

  section Ingestion
  HTTP hooks ingress + ingestion agent          :d1, 2026-04-18, 10d
  Background indexing service + batching        :d2, after d1, 12d
  GPU router as node host + allowlists          :d3, after d1, 8d

  section Safety and operations
  Guardrails plugin hooks enforcement           :e1, 2026-05-20, 10d
  OpenSearch tuning + snapshots runbook         :e2, 2026-05-20, 10d

  section Release
  Canary + rollback playbooks                   :f1, 2026-06-10, 10d
```

This sequencing front-loads “OS artifacts” (config/skills/plugins) and then builds toward the two hardest pieces—memory indexing + safety enforcement—on a stable operational base. citeturn17view0turn26view1turn27search0