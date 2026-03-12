# RemRam / Moltbox Repository Taxonomy (Initial Stake in the Ground)

## Purpose

This document defines the current repository structure and naming taxonomy for the RemRam ecosystem and the Moltbox appliance platform. It is not intended to be permanent doctrine, but rather a clear starting point so contributors understand where new work belongs and why the repositories are separated the way they are.

The system deliberately separates **products**, **platform infrastructure**, **runtime wiring**, and **portable capabilities**.

---

# Core Principle

The ecosystem is split into two top-level domains:

**RemRam** — product layer and portable capabilities.

**Moltbox** — appliance platform and operational infrastructure.

The rule of thumb:

- If something is a **product or reusable capability**, it belongs under RemRam.
- If something exists **only to run the appliance**, it belongs under Moltbox.

---

# Repository Taxonomy

## RemRam Layer (Products + Portable Capability)

### remram

Product architecture and ecosystem documentation.

Contains:
- Feature definitions
- Architecture descriptions
- Ecosystem map
- Product proposals

Features are conceptual capabilities. They may be implemented through one or more skills, services, or runtime configuration.

---

### remram-cortex

Cortex memory system.

Responsibilities:
- Durable knowledge layer
- Retrieval pipelines
- Reflection and reconciliation
- Artifact promotion

Cortex is the first major RemRam product.

---

### remram-app

User-facing product surface.

Responsibilities:
- APIs
- application UI
- operator workflows
- user interaction surfaces

This repository turns the underlying system into something people can use.

---

### remram-skills

Portable capability packages built for the OpenClaw ecosystem.

Skills may contain:
- tools
- workflows
- helper modules
- skill packaging metadata

Skills are designed to be **reusable across runtimes**, not tied to a single appliance.

Example skills:

- research briefing
- semantic router helpers
- document summarization
- agent workflow utilities

Skills implement capabilities that features depend on.

---

# Moltbox Layer (Appliance Platform)

## moltbox-gateway

The Moltbox control plane.

Responsibilities:

- CLI
- deployment engine
- runtime orchestration
- diagnostics
- appliance lifecycle management

Gateway is where the appliance becomes operational.

It owns commands like:

```
moltbox runtime dev deploy
moltbox host ssl status
moltbox tools health
```

---

## moltbox-runtime (private)

The runtime configuration repository for the appliance.

This repository contains the **live system wiring**.

Examples:

- OpenClaw configuration
- agent definitions
- channel definitions
- routing policies
- environment manifests

Example structure:

```
openclaw/
  agents/
  router/
  channels/

 environments/
  dev.yaml
  test.yaml
  prod.yaml
```

This repository defines *how the system behaves*.

---

## moltbox-services (private)

Container definitions and adapter services for the appliance.

Examples:

- OpenClaw runtime
- OpenSearch
- Caddy
- Signal bridge
- Discord bridge

Service files describe the container topology of the appliance.

Example service definition:

```
service: openclaw
image: ghcr.io/remram/openclaw:1.4.2
state: /Moltbox/openclaw
ports:
  - 8080
```

If a capability requires a running process or container, it belongs here.

---

# Conceptual Vocabulary

To avoid confusion across repositories, the ecosystem uses these terms:

**Feature**

A product-level capability defined in documentation.

Location:

```
remram/features/
```

A feature may require skills, services, or runtime configuration.

---

**Skill**

A portable capability package implemented in code.

Location:

```
remram-skills
```

Skills implement reusable behaviors that can be deployed across runtimes.

---

**Service**

A containerized process that runs on the appliance.

Location:

```
moltbox-services
```

Examples include OpenClaw, search services, and communication bridges.

---

**Runtime**

The wiring and configuration that defines how the appliance behaves.

Location:

```
moltbox-runtime
```

---

**Gateway**

The appliance control plane responsible for deployment and management.

Location:

```
moltbox-gateway
```

---

# Architectural Flow

A feature typically moves through the system like this:

```
Feature (remram docs)
      ↓
Skill (remram-skills)
      ↓
Runtime wiring (moltbox-runtime)
      ↓
Service deployment if required (moltbox-services)
```

Gateway then deploys and manages the appliance state.

---

# Design Goals

This structure aims to achieve several goals:

1. Separate product logic from infrastructure.
2. Keep appliance deployment deterministic.
3. Allow skills to be portable across runtimes.
4. Avoid coupling software projects to appliance deployment.
5. Keep the system understandable for contributors.

---

# Expected Evolution

As the ecosystem grows we expect:

- additional RemRam products
- additional portable skills
- more services deployed through Moltbox

The repository structure is intentionally simple so it can scale without constant renaming.

---

# Deployment Model

This section explains how code and configuration from each repository actually reaches a running appliance.

The deployment model intentionally separates **build**, **artifact**, and **runtime wiring**.

---

## remram

Not deployable.

This repository contains:

- feature definitions
- architecture
- product documentation

It acts as the conceptual map for the ecosystem.

---

## remram-cortex

Deployment type:

```
compiled / packaged service
```

Typical flow:

```
source code
   ↓ build
container image or packaged service
   ↓
referenced by moltbox-services
```

Cortex ultimately runs as a service on the appliance but is built and versioned independently.

---

## remram-app

Deployment type:

```
compiled application
```

Typical flow:

```
source code
   ↓ build
web or mobile artifact
   ↓
deployed independently of the appliance runtime
```

App is a consumer of the system rather than part of the appliance infrastructure.

---

## remram-skills

Deployment type:

```
OpenClaw skill lifecycle
```

Skills are packaged capabilities that follow the OpenClaw packaging model.

Typical flow:

```
skill source
   ↓ package
OpenClaw skill artifact
   ↓ installed into runtime
```

Skills may include:

- tools
- workflows
- helper modules

They are portable and may be reused across multiple runtimes.

---

## moltbox-gateway

Deployment type:

```
bootstrap + self-managed updates
```

Gateway is the control plane for the appliance.

Deployment model:

```
initial bootstrap
   ↓
install tools container
   ↓
tools container manages updates
```

The control-plane tools service supports commands such as:

```
moltbox tools update
moltbox tools rollback
```

This allows the gateway to update itself without requiring full appliance bootstrap each time. See the CLI reference for operator command structure. fileciteturn0file0

---

## moltbox-runtime (private)

Deployment type:

```
configuration artifact store
```

This repository acts as the **source of truth for runtime wiring**.

Typical flow:

```
git commit
   ↓
render deployment artifacts
   ↓
runtime deploy via gateway
```

The repository may use branch environments such as:

```
dev
 test
 prod
```

These environments correspond to runtime deployments managed by Moltbox.

---

## moltbox-services (private)

Deployment type:

```
container deployment definitions
```

This repository defines what containers run on the appliance.

Typical flow:

```
service definition
   ↓
git push
   ↓
appliance pulls latest definitions
   ↓
containers deployed or updated
```

Example services:

- OpenClaw
- OpenSearch
- Caddy
- communication bridges

Service definitions reference container images built elsewhere.

---

# Combined Deployment Pipeline

A typical feature deployment might look like this:

```
Feature defined
(remram)
      ↓
Skill implemented
(remram-skills)
      ↓
Runtime wiring
(moltbox-runtime)
      ↓
Service deployment if needed
(moltbox-services)
      ↓
Gateway orchestrates runtime
(moltbox-gateway)
```

---

# Status

This document represents the **initial taxonomy and deployment baseline** for the RemRam ecosystem.

Future updates should keep repository responsibilities and deployment paths clearly defined so contributors know where work belongs.

