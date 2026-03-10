# App Context

## Purpose

App is the user-facing and operator-facing layer of the Remram ecosystem. It turns the deeper system into something people can actually use: APIs, interfaces, workflows, and product surfaces. Its role is presentation, interaction, and product assembly. It should expose system capability clearly without taking over authority that belongs to runtime, orchestration, or durable knowledge. In practical terms, App is where Remram becomes a product experience, not where the foundational authority boundaries are redefined.

## Key Responsibilities

- Provide user-facing APIs, client experiences, and admin or operator product surfaces.
- Package underlying memory, orchestration, and runtime capabilities into workflows that feel coherent to the user.
- Preserve the system's safety and authority boundaries by routing through the correct lower layers instead of bypassing them.
- Surface durable artifacts, briefings, stories, project memory, and other outputs in a usable way.
- Support strategic directions such as family memory, guided building, research briefing, and structured creation workflows by presenting them as understandable product experiences.

## Relationship To Other Parts Of The Ecosystem

App depends on the layers beneath it and should not try to replace them.

- Gateway owns live runtime execution and appliance operations.
- OpenClaw owns live run shaping, prompt compilation, tool selection, and escalation policy.
- Cortex owns long-term knowledge, retrieval, reflection, reconciliation, and artifact promotion.
- Agents provide reusable skills or modules that App can expose or invoke as part of product workflows.

This means App is a consumer and presenter of ecosystem capability. It should not quietly become a shadow runtime, a shadow knowledge system, or a direct machine-admin surface. The user may experience one cohesive product, but the implementation should still respect the architecture underneath.

## What Belongs Here

- API surfaces.
- User and operator workflows.
- Client and application experiences.
- Presentation of memory-backed capability and durable artifacts.

## What Does Not Belong Here

- Direct ownership of appliance mutation, deployment, or runtime infrastructure.
- Durable knowledge authority or reconciliation internals.
- Reusable agent modules as their primary implementation home.
- Conceptual ecosystem governance that belongs in the architecture repository.
- Any shortcut that bypasses lower-layer policy because it seems easier at the UI layer.

## Working Heuristic

If the question is "how does a person or operator access this capability?" think App. If the question is "who owns the underlying authority?" follow the boundary down to Gateway, OpenClaw, Cortex, or Agents as appropriate.
