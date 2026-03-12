# Capability Integration Standard

This document defines the platform-wide contract for integrating a capability into the Remram platform.

It applies across:

- `remram-gateway`
- `remram-cortex`
- `remram-agents`
- future Remram subsystem repositories

Subsystem repositories implement this standard in their own deployment, control-plane, and operator surfaces. This document defines the invariant rules. Subsystem docs define the concrete paths, namespaces, and operating procedures.

## Purpose

Capability integrations must behave predictably across the platform.

Every new capability must provide:

- repeatable deployment
- a clear management surface
- durable state outside replaceable runtime artifacts
- observable logging
- control-plane and MCP integration where appropriate
- operator documentation before the capability is considered complete

## Applicability

A capability is any new deployable or long-lived subsystem integration such as:

- a channel adapter
- a model-serving component
- a search or index service
- a memory service
- a background worker
- a synchronization daemon
- a bridge to an external system

If a subsystem adds a new capability, that subsystem must document how it implements this standard.

## 1. Containerization Preferred

New capabilities should default to containerized deployment.

Reasons:

- deployment stays consistent
- runtime isolation is clearer
- lifecycle management is easier to standardize
- redeploy is safer than hand-mutating a live host
- the capability remains replaceable as an operational artifact

Host-local services are exceptions. When a capability cannot be containerized, the subsystem implementation guide must document the exception and explain how the lifecycle, state, logging, and recovery requirements are still satisfied.

## 2. Lifecycle Management Required

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

## 3. Dedicated Management Namespace

Each capability should have a dedicated subsystem-owned management namespace.

If the subsystem exposes a CLI, the capability should have a dedicated command surface rather than being buried inside unrelated commands.

If the subsystem exposes a control-plane API, the capability should appear as a first-class managed target or resource.

The exact syntax is subsystem-specific, but the management surface must be clear, stable, and documented.

## 4. Management Surface Is Not the Application Surface

The management interface exists to operate the capability, not to replace the capability's normal service interface.

Correct pattern:

```text
management surface -> lifecycle, inspection, diagnostics
service interface -> application traffic
```

Incorrect pattern:

```text
management surface -> proxy ordinary application use of the capability
```

The capability should expose its own API, protocol, or network interface to the systems that actually consume it.

## 5. MCP-Compatible Wrappers Required Where Remote Control Exists

If a subsystem exposes remote operator control or agent-facing control-plane access, capability management actions must also have MCP-compatible wrappers where appropriate.

Rules:

- MCP should wrap the canonical management path rather than reimplement service logic
- policy may restrict which verbs are exposed remotely
- local operator access and remote MCP access must not silently drift into different behaviors
- subsystem docs must state which actions are available remotely and which remain local-only

## 6. Logging Contract

Capability logs must be operationally visible.

Rules:

- logs must not be hidden only inside a writable container filesystem
- the owning subsystem must define a canonical host or durable log root
- the capability must document how logs are mounted, stored, or retrieved
- the management surface must expose a normal operator log path such as `logs`

Exact log paths are subsystem implementation details, but every subsystem must define them clearly.

## 7. Durable State Must Live Outside Replaceable Runtime Artifacts

Durable state must survive redeploy and container replacement.

This includes:

- databases
- indexes
- account credentials
- sessions
- downloaded artifacts
- model weights
- service-specific configuration that must persist

Rules:

- durable state must live outside the container or other replaceable runtime artifact
- the subsystem implementation guide must define the canonical durable state location
- redeploying the capability must not destroy durable system state

## 8. Redeploy Instead of Mutate

Operational change must happen through managed redeploy, not live mutation of runtime artifacts.

Correct pattern:

1. update configuration or deployment inputs
2. render or build the new artifact
3. redeploy through the subsystem management surface

Incorrect pattern:

1. attach to the running artifact
2. hand-edit files
3. treat the live artifact as the source of truth

Emergency debugging is acceptable. Durable fixes must be codified and redeployed.

## 9. Health and Operational Testing Requirement

Every capability must support a basic verification path.

Operators must be able to confirm:

- the capability is running
- the capability is reachable
- the capability responds correctly enough for basic confidence

The exact verb may vary, but a capability should expose one or more of:

- `health`
- `test`
- `ping`
- `debug`

The subsystem implementation guide must define the expected success signal.

## 10. Control-Plane Integration Requirement

A capability is not considered integrated just because it can be started manually.

Each subsystem must integrate new capabilities into its control plane by providing:

- a stable target identity
- canonical deployment assets or deployment definitions
- structured `status`, `inspect`, and `logs` behavior
- policy-aware behavior for remote access when applicable
- clear ownership boundaries inside the subsystem

The control plane must know enough about the capability to manage it as a first-class concern.

## 11. Runtime Ownership and Request-Path Clarity

Each capability must document where it sits in the system.

That documentation must define:

- which subsystem owns the capability
- which environments consume it
- whether one environment owns it exclusively or several share it
- how it participates in the request path
- what failure mode appears when it is unavailable

Ports and network exposure should default to the minimum required surface.

## 12. Capability Documentation Requirement

Every capability must ship with operator-facing documentation in the owning subsystem repository.

The subsystem must define the canonical location for those guides.

Each capability guide must include:

- Purpose
- Access Method
- Ports
- CLI or control-plane Operations
- Runtime Behavior
- Logs
- Persistent State
- Health / Debugging
- Bootstrap Steps
- Failure Recovery

Minimum expectations:

- `Purpose`
  - what the capability is
  - why it exists
  - what it provides
  - which subsystem depends on it
- `Access Method`
  - protocol
  - endpoint or network name
  - authentication model if applicable
- `Ports`
  - internal port
  - external port if any
  - exposure scope
- `CLI or control-plane Operations`
  - supported management commands or actions
  - what each action does
- `Runtime Behavior`
  - environments
  - ownership
  - request-path role
  - failure impact
- `Logs`
  - canonical log location
  - retrieval method
  - expected behavior
- `Persistent State`
  - canonical durable state location
  - what data lives there
- `Health / Debugging`
  - verification steps
  - expected healthy response
- `Bootstrap Steps`
  - one-time setup only
  - clearly separated from steady-state operations
- `Failure Recovery`
  - common failure modes
  - restart or redeploy path
  - state recovery guidance

## 13. Completion Rule

A capability is not complete until all of the following are true:

- deployment is repeatable through the owning subsystem
- lifecycle and inspection operations exist for normal management
- logs are operationally visible through the documented management surface
- durable state survives runtime replacement
- ownership and access patterns are documented
- MCP management coverage exists where appropriate
- operator documentation exists in the owning subsystem repository
- bootstrap and recovery procedures are written down

If any of those conditions are missing, the capability is still incomplete.
