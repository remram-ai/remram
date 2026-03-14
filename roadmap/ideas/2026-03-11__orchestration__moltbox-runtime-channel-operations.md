# Moltbox Runtime Channel Operations

**Marketing Name (optional):** Moltbox Runtime Channel Operations
**Layer:** Orchestration
**Primary Surface / Agent:** Moltbox CLI runtime commands and control plane
**Relevant Hook or Stage (if applicable):** Runtime render, runtime deploy, runtime channel bootstrap, runtime promotion
**Dependencies (if any):** Moltbox CLI grammar, runtime render pipeline, runtime root sync, target registry, secret handling, OpenClaw channel config
**Date:** 2026-03-11
**Status:** Validated
**One-liner:** Add first-class runtime-owned channel operations to the Moltbox CLI so native OpenClaw channels such as Discord can be configured, inspected, validated, and promoted without SSH.

---

## Opportunity / Problem

The native Discord implementation for `remram-gateway` exposed a clear control-plane gap.

The runtime integration itself is thin and correct:

- Discord is native inside OpenClaw
- requests enter the normal reply lifecycle
- the Semantic Router still runs
- no custom router is required

But the operator path is still incomplete.

Today, standard channel bootstrap and lifecycle tasks still depend on host-shell access patterns such as:

- editing runtime env files manually
- editing rendered runtime channel config manually
- pushing per-runtime guild/channel allowlists manually
- inspecting channel-specific runtime config manually
- sending channel broadcasts manually through `docker exec`
- handling runtime-to-runtime promotion manually

That is exactly the class of work the Moltbox CLI should absorb.

The current CLI is strong at:

- `moltbox runtime <environment> deploy`
- `moltbox runtime <environment> status`
- `moltbox runtime <environment> logs`

It is weak at:

- runtime-owned ingress configuration
- runtime-owned channel secret management
- channel bootstrap and pairing workflows
- channel-specific diagnostics and promotion

As a result, the operator still falls back to SSH for the last mile of channel bring-up.

---

## What It Does

This idea adds a first-class channel-management layer to the runtime domain of the Moltbox CLI.

The goal is not to create a new application surface. The goal is to let an operator manage runtime-owned native channels from the CLI without host-shell edits.

For Discord, that means the CLI should be able to handle:

- enable or disable the runtime's Discord channel
- set or rotate the runtime's Discord bot token
- define guild and channel allowlists
- inspect effective Discord config and config provenance
- validate Discord access before deployment
- view and approve pairing state
- send outbound broadcast messages through the owning runtime
- promote channel config from `dev` to `test` safely

The same control-plane pattern should later be reusable for other runtime-owned native channels.

---

## Example / Scenario

Current painful flow:

1. Operator receives a Discord bot token.
2. Operator SSHs into the host.
3. Operator edits `container.env` manually.
4. Operator edits `channels.yaml` manually.
5. Operator restarts the runtime manually.
6. Operator uses raw Docker commands for channel test sends or pairing checks.
7. Operator repeats the whole process for `test`.

Desired future flow:

1. Operator stores the token through the CLI:

```text
moltbox runtime dev channels discord token set --from-env DISCORD_BOT_TOKEN
```

2. Operator configures the runtime-owned allowlist:

```text
moltbox runtime dev channels discord configure ^
  --enabled true ^
  --guild-id 1481179628323340393 ^
  --channel-id 1481180067580219402 ^
  --require-mention true
```

3. Operator validates access before deployment:

```text
moltbox runtime dev channels discord validate
```

4. Operator deploys normally:

```text
moltbox runtime dev deploy
```

5. Operator inspects channel health and pairing:

```text
moltbox runtime dev channels discord status
moltbox runtime dev channels discord pairings list
```

6. Operator sends a test broadcast:

```text
moltbox runtime dev channels discord broadcast ^
  --target channel:1481180067580219402 ^
  --message "dev runtime online"
```

7. Operator promotes the config to `test`:

```text
moltbox runtime dev channels discord promote --to test
```

That flow removes SSH from the normal operator loop.

---

## Core Mechanism (High-Level)

This should be implemented as a runtime-scoped control-plane layer, not as a second chat surface.

Conceptually:

1. The CLI targets a runtime environment.
2. The CLI manages runtime-owned channel inputs:
   - secrets
   - render-time channel overlays
   - runtime-root channel metadata
3. The control plane renders and deploys the runtime using those inputs.
4. The CLI can inspect the effective channel configuration and channel-specific status.
5. The CLI can invoke runtime-owned outbound channel actions in a structured way.

Important design principle:

- native channels remain runtime capabilities
- the CLI manages runtime channel configuration and operations
- no new execution stack is introduced
- no SSH is required for routine channel bring-up

---

## Concrete Gaps Observed

These were encountered directly during Discord bring-up:

1. There is no runtime-scoped command for enabling a native channel without editing files manually.
2. There is no runtime-scoped command for setting a channel token or secret without touching `container.env`.
3. There is no runtime-scoped command for defining guild/channel allowlists.
4. There is no runtime-scoped command for validating whether the bot can access the configured guild/channel before deploy.
5. There is no runtime-scoped command for Discord pairing inspection or approval.
6. There is no runtime-scoped command for outbound Discord broadcast.
7. There is no runtime-scoped promotion helper for copying channel configuration from `dev` to `test`.
8. There is no safety check preventing one bot token from being attached to multiple live runtimes concurrently.
9. There is no CLI-level way to show which rendered channel config and env inputs were used by the deployed runtime.

---

## Proposed CLI Surface

Recommended shape:

```text
moltbox runtime <environment> channels <channel> <action>
```

Examples:

```text
moltbox runtime dev channels discord status
moltbox runtime dev channels discord inspect
moltbox runtime dev channels discord validate
moltbox runtime dev channels discord token set --from-env DISCORD_BOT_TOKEN
moltbox runtime dev channels discord token rotate --from-env DISCORD_BOT_TOKEN
moltbox runtime dev channels discord token unset
moltbox runtime dev channels discord configure --enabled true --guild-id ... --channel-id ...
moltbox runtime dev channels discord pairings list
moltbox runtime dev channels discord pairings approve <code>
moltbox runtime dev channels discord broadcast --target channel:... --message "..."
moltbox runtime dev channels discord promote --to test
```

If the CLI team wants a slightly different noun, `channel` or `ingress` would also work. The important part is that the surface is runtime-scoped and channel-specific.

---

## Required Behaviors

### 1. Token / Secret Management

The CLI must support runtime-scoped secret operations for native channels.

Minimum behavior:

- set token from env var
- set token from stdin or secure prompt
- rotate token
- unset token
- report whether a token is configured without printing the secret

### 2. Channel Configuration

The CLI must support runtime-scoped channel config mutation without raw file editing.

Minimum behavior:

- enable or disable channel
- set guild allowlist
- set channel allowlist
- set mention policy
- set sender allowlist when relevant
- clear or replace existing mappings intentionally

### 3. Validation

The CLI must support a preflight validation pass for native channels.

For Discord, validation should confirm at least:

- token resolves
- bot identity resolves
- configured guild is visible
- configured channel is visible
- required access is present

### 4. Inspection / Provenance

The CLI must show:

- effective channel config
- source of each input
  - git-tracked default
  - render-time override
  - runtime-root override
  - secret source
- whether the deployed runtime matches the desired config

### 5. Pairing Operations

If the native channel uses pairing, the CLI should wrap the runtime's pairing surface.

For Discord, minimum useful commands:

- list pending pairings
- approve pairing
- reject pairing

### 6. Broadcast Operations

The CLI should wrap runtime-owned outbound message sends for operator usage.

For Discord, minimum useful behavior:

- send text message to configured target
- support explicit `user:<id>` and `channel:<id>` targets
- return structured delivery result

### 7. Promotion

The CLI must support promotion or cloning of channel configuration between runtimes.

For example:

- `dev` to `test`
- optionally with or without secrets

This is required because native channel bring-up otherwise becomes manual re-entry.

### 8. Collision Detection

The CLI must detect unsafe shared-identity usage.

For Discord, that means warning or blocking when:

- one bot token is configured for multiple live runtimes
- one guild/channel mapping is attached to multiple active runtimes in an ambiguous way

There should be an explicit override if the operator truly intends a cutover, but the default should be safe.

---

## Output Expectations

All new commands should return structured JSON, consistent with the rest of the CLI.

Useful fields include:

- `environment`
- `channel`
- `status`
- `configured`
- `deployed`
- `validated`
- `config_sources`
- `warnings`
- `recovery_message`

For validation and inspection commands, the JSON should be machine-usable by MCP and automation.

---

## Benefits

- Eliminates SSH for routine native-channel bootstrap
- Makes Discord and future native channels genuinely operable through Moltbox
- Reduces manual file editing and config drift
- Makes runtime promotion more reproducible
- Creates a safer operational story for channel secrets and identity ownership
- Keeps control-plane responsibility where it belongs instead of leaking into shell rituals

---

## Feasibility (High-Level)

This is feasible with the current stack.

The gateway already has:

- a runtime-scoped CLI domain
- a render pipeline
- runtime root sync
- target registry and deployment records
- structured JSON command outputs

The missing piece is a deliberate runtime-channel operations layer.

This does not require:

- a new runtime model
- a new orchestration loop
- a shared Discord service
- a gateway-side router

It likely requires:

- CLI grammar expansion under `runtime`
- runtime-scoped channel config storage or overlay handling
- runtime-scoped secret handling for channel tokens
- runtime-aware channel validation primitives
- runtime-owned channel action wrappers

---

## Guardrails / Constraints

- Must remain runtime-scoped, not host-scoped, for native channels like Discord.
- Must not create a new execution path outside the normal runtime lifecycle.
- Must not require operators to edit tracked repo config just to bootstrap one runtime.
- Must not print secrets in CLI output.
- Must block or strongly warn on unsafe shared-token multi-runtime configurations.
- Must preserve explicit environment routing.
- Must remain compatible with MCP wrappers later.

---

## Suggested Acceptance Criteria

- An operator can bootstrap Discord on `dev` entirely through Moltbox CLI plus a bot invite.
- An operator can inspect effective Discord runtime config without SSH.
- An operator can validate guild/channel access without SSH.
- An operator can manage pairings without SSH.
- An operator can send a test broadcast without raw Docker commands.
- An operator can promote Discord config from `dev` to `test` through a documented CLI path.
- Unsafe multi-runtime shared-token usage is detected before deployment.

---

## Open Questions

- Should runtime channel config be persisted as a runtime-owned overlay file, registry metadata, or both?
- Should channel token management live in the general secret system or a runtime-scoped secret helper?
- Should pairing operations be generic across channels, or channel-specific wrappers?
- How opinionated should promotion be about carrying secrets across environments?
- Should the CLI team build this as a generic runtime-channel framework immediately, or land Discord-first and generalize afterward?

---

## Links (Related Ideas)

- Discord native ingress in `remram-gateway`
- Moltbox Remote Runtime Dev Loop
- Runtime-owned channel operations
