# Capability Integration Standard v2

This document is a proposed revision to the platform-wide capability integration contract.

It is intentionally separate from `capability-integration.md` so the current standard remains stable while the v2 direction is reviewed.

## Purpose

Capability integrations must behave predictably across the platform.

Every new capability must provide:

- repeatable deployment
- a clear management surface
- a CLI or equivalent subsystem command surface
- durable state outside replaceable runtime artifacts
- observable logging
- control-plane and MCP integration where appropriate
- structured JSON output for management and diagnostics
- at least one diagnostic command
- operator documentation before the capability is considered complete

## Capability Integration Rule v2

Every new capability must expose these surfaces:

1. Implementation surface
2. CLI surface
3. MCP surface when appropriate

Additionally, every capability must provide:

- structured JSON output
- at least one diagnostic command
- a documented ownership boundary

Rules:

- a capability is incomplete if normal operations require SSH, raw container-runtime commands, or undocumented host mutation
- the CLI or equivalent subsystem management surface must be the normal operator path
- MCP, when present, must wrap the canonical management path rather than inventing a second behavior model

## Lifecycle and Management

Every capability must expose an operator management surface through the owning subsystem.

Typical lifecycle coverage includes:

- `deploy`
- `start`
- `stop`
- `restart`
- `status`
- `logs`
- `inspect`

Additional verbs may include:

- `rollback`
- `health`
- `test`
- `debug`

Normal operations must not require raw container-runtime commands, ad hoc shell procedures, or undocumented host mutation.

Normal operations should also not require SSH except as a break-glass recovery path documented separately.

If the subsystem exposes a CLI, the capability should have a dedicated command surface rather than being buried inside unrelated commands.

That command surface is part of the capability contract, not optional polish.

## Control-Plane Integration

Each subsystem must integrate new capabilities into its control plane by providing:

- a clear implementation surface
- a CLI or equivalent local operator surface
- an MCP surface when remote control is appropriate
- a stable target identity
- canonical deployment assets or deployment definitions
- structured `status`, `inspect`, and `logs` behavior
- structured JSON output for management and diagnostics
- at least one diagnostic command
- policy-aware behavior for remote access when applicable
- clear ownership boundaries inside the subsystem

The control plane must know enough about the capability to manage it as a first-class concern.
