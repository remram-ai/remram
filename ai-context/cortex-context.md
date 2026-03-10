# Cortex Context

## Purpose

Cortex is the long-term knowledge layer of the Remram ecosystem. Its job is not to impersonate the runtime or the app. Its job is to decide how durable memory works over time: what is eligible to persist, how knowledge is retrieved, how reflection improves it, how reconciliation resolves drift, and when internal memory should mature into durable artifacts. When Remram talks about continuity becoming structured instead of improvised, Cortex is the layer carrying that responsibility.

## Key Responsibilities

- Own long-term knowledge services and the boundary between ephemeral session state and durable memory.
- Provide retrieval behavior that is bounded, policy-aware, and separate from mutation.
- Handle reflection and reconciliation so corrections and repeated patterns can mature instead of being forgotten between sessions.
- Distinguish memory policy from ranking signals such as embeddings or similarity scores.
- Promote some matured knowledge into artifacts, briefs, stories, plans, skills, or other reusable outputs when that is the right durable form.

## Relationship To Other Parts Of The Ecosystem

Cortex works with the rest of the system, but it should not absorb their authority.

- OpenClaw or another orchestration layer requests bounded context and shapes live runs. Cortex supports that process with retrieval and durable knowledge services.
- Gateway provides the local runtime and appliance boundary that executes work. Cortex does not own runtime operations or machine management.
- App exposes user-facing capability built on top of the knowledge layer. App should present memory-backed behavior without bypassing knowledge policy.
- Agents may consume or produce durable artifacts, but Cortex remains the place where long-term knowledge authority and promotion logic live.

The architecture depends on keeping retrieval and mutation separate. A live request may consult Cortex for relevant context, but the path that changes durable knowledge should stay governed and explicit.

## What Belongs Here

- Memory policy.
- Retrieval and ranking pipelines in service of durable knowledge.
- Reflection, reconciliation, and consolidation behavior.
- Artifact promotion and durable knowledge outputs.

## What Does Not Belong Here

- Raw runtime execution or appliance mutation authority.
- Prompt compilation as the primary live-run responsibility.
- User-interface ownership.
- Treating similarity alone as truth, safety, or injection authority.
- Letting the memory layer become a shadow runtime that decides everything else in the system.

## Working Heuristic

If the problem is about what should endure, how it should be resurfaced, or how durable knowledge improves over time, it belongs in Cortex. If the problem is about live execution, UI, or appliance operations, it belongs elsewhere.
