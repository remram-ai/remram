# Project Charter

## Purpose

Remram exists to turn fragile conversational continuity into durable knowledge.

The project is built on the belief that "memory" in AI systems should not mean unlimited transcript retention. It should mean a governed process for deciding what matters, what should persist, and how that knowledge should shape future behavior.

## Problem Statement

Most AI systems still fail at continuity in familiar ways:

- they lose important corrections
- they repeat mistakes across sessions
- they depend on oversized prompts to fake memory
- they store too much raw history and too little durable structure
- they improve inconsistently because reconciliation is missing

These are not just prompting issues. They are systems issues.

## Scope

This repository focuses on:

- project vision
- conceptual architecture
- ecosystem explanation
- contributor orientation
- backlog and idea pipeline

The ecosystem as a whole focuses on:

- local-first runtime authority
- long-term knowledge and retrieval
- reflection and reconciliation
- reusable agents and skills
- user-facing application surfaces

## Principles

### Memory is an orchestration problem

Context windows are temporary. Durable continuity must be engineered.

### Retrieval and mutation must be separated

The system should distinguish clearly between the path that serves a live run and the path that changes long-term knowledge.

### Runtime authority and knowledge authority are different

Execution belongs to the runtime layer. Long-term knowledge belongs to the memory layer.

### OpenClaw and Moltbox control should stay separate

OpenClaw shapes live runs for people and clients. The Moltbox control plane manages the appliance itself through CLI tools, tests, staged deployment, and approval gates. Those two layers should cooperate without collapsing into each other.

### OpenClaw and cognition should stay separate

OpenClaw should remain bounded and policy-driven. Stronger cognition should be invoked as a bounded expert tier, not allowed to become the runtime.

### Prompt compilation should be systemic

Users should not have to act like prompt engineers. The orchestration layer, currently expressed through OpenClaw, should interpret intent, shape context, and enforce output contracts on behalf of the system.

### Memory policy should govern similarity

Embeddings and ranking systems are useful signals, but they are not the authority on what is true, eligible, or safe to inject.

### Local-first matters

The user should retain control over the durable knowledge layer, artifacts, and system posture.

### Concepts should outlive implementation details

This repository should describe what the ecosystem is trying to become, not just how one repo happens to implement it today.

### Durable artifacts matter

Not everything worth preserving should remain an internal memory object. Some knowledge should mature into human-readable artifacts, reusable skills, and other durable outputs.

## Non-Goals

This repository is not trying to become:

- the implementation manual for the ecosystem
- the canonical home for runtime APIs
- the deployment guide for every subsystem
- a dumping ground for deep technical specs without context

Those concerns belong in the domain repositories.
