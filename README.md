# remram

**Real, structured long-term memory for AI systems.**

Remram gives your AI stack organized, persistent memory across users, domains, and time.

You do not need to wait for foundation model labs to solve “infinite memory.”

Memory is not a model problem.

It is an orchestration problem.

Remram solves it at the system layer, While keeping your context in your control!

---

## The Core Thesis

Large models are stateless.

Context windows are temporary.

Chat history is not memory.

Remram treats memory as engineered state:

- Structured
- Policy-driven
- Continuously consolidated
- Deterministically retrieved

Models reason.
Remram remembers.

---

## System Architecture

Remram is composed of four layers:

- **remram-os** — orchestration and OpenClaw integration  
- **remram-recall** — RAM (retrieval / read path)  
- **remram-encode** — REM (consolidation / write path)  
- **moltbox** — local hardware control plane  

Memory is never blindly appended.
It is assembled and refined.

---

## The Memory Model

Remram operates on two coordinated paths:

### RAM — Recall

- Hybrid retrieval (filters + rank + vectors)
- Deterministic context bundles
- Confidence-aware selection
- Policy-gated eligibility

RAM retrieves memory.
It does not mutate it.

---

### REM — Encode

REM operates as a two-layer system:

**1. Baseline Encode**
- Runs post-request
- Updates relevant context chunks
- Stages low-confidence changes

**2. Dream Machine**
- Nightly structured consolidation
- Fact promotion
- Artifact reconciliation
- Pruning
- User clarification loop

REM refines memory.
RAM recalls it.

---

## Why Remram Exists

Modern AI systems:

- Repeat mistakes  
- Lose corrections  
- Drift across sessions  
- Accumulate noisy state  

They lack continuity.

Remram enforces it.

---

## Design Principles

- Local-first ownership of context
- Explicit read/write separation
- Deterministic orchestration
- Policy-driven mutation
- Token-efficient cloud escalation

Remram is not a chatbot.

It is the memory substrate beneath intelligent systems.

---

## Status

Early-stage infrastructure.  
Architecture-first.  
Open to experimentation.
