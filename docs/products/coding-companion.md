# Coding Companion

Feature Definition

---

## 1\. Overview

Coding Companion is a guided development feature that helps users (especially young coders) build software step-by-step with enforced workflow discipline, structured context management, and a mixture-of-experts pipeline for code, assets, and reusable patterns. It integrates directly with the Remram memory architecture so projects accumulate reusable components, templates, walkthrough guidance, and learned patterns over time — eliminating “sliding context window” frustration by keeping durable project knowledge in structured memory.

---

## 2\. Problem Statement

One-shot coding is unreliable, especially for beginners.

*   Novices do not know the correct order of operations (plan → scaffold → implement → test → iterate).
*   Context management is hard; models forget prior constraints, decisions, and architecture.
*   “Vibe coding” tools can feel intimidating and opaque.
*   Asset creation (sprites, UI, sound) requires separate tools and workflows.
*   Reuse is weak: useful components and patterns are not systematically captured.
*   Current agentic coding tools often rely on a sliding context window and compaction that loses important details.

Young coders need a workflow that is both productive and educational: showing what is being built, why it is built next, and how it connects — while preserving durable project memory outside the model.

---

## 3\. Value Proposition

Coding Companion turns coding into a guided, compounding learning and building loop.

*   Enforces a clear, repeatable workflow (plan, scaffold, implement, test, refine).
*   Maintains project context through structured memory artifacts and a chunked memory map of the codebase (token-efficient navigation and planning).
*   Uses mixture-of-experts models for specialized tasks (coding, sprites/assets, explanation, debugging).
*   Builds a reusable library of components, templates, walkthroughs, and patterns over time.
*   Provides an educational experience that makes progress legible to young builders (explain-as-we-go, follow-along).
*   Reduces wasted tokens by enforcing discipline and using persistent memory instead of relying on a transient window.

Strategically, this feature converts projects into lasting capability: code reuse, pattern libraries, and a growing “family dev studio” knowledge base.

---

## 4\. User Experience Model

Entry:

*   Start new project or open an existing project.

Modes:

*   **Builder Mode** (fast, minimal narration)
*   **Follow-Along / Learning Mode** (step-by-step + explanations, optionally streamed as audio)
*   **Walkthrough Mode** (guided review of changes and rationale across artifacts)

### Guided Build Loop

1.  Define goal (game/app) and constraints.
2.  System proposes a build plan broken into small steps.
3.  During planning, the system explicitly identifies **which artifacts will be updated** and the **purpose** of each update (e.g., README, architecture notes, module docs, code files).
4.  User selects the next step.
5.  System updates artifacts **one at a time**.
6.  System runs checks (lint/test/run) and suggests fixes.
7.  System captures decisions, walkthrough notes, and reusable patterns into memory.

### Walkthrough Mode (youth-first)

*   For each artifact change, the system provides:
    *   What changed
    *   Why it changed
    *   How it supports the current goal
    *   What to verify next
*   Walkthrough guidance is saved and reusable:
    *   “Remember: this change was for adding triple-shot.”
    *   Future walkthroughs can replay the same tips when similar changes occur.

### Natural Language Change Descriptions (optional audio)

In Follow-Along / Learning Mode:

*   Changes are narrated in natural language while code/artifacts update.
*   Optionally stream narration as audio.

### Asset + “Reskin” Flow

*   User requests sprites/UI assets.
*   System generates assets via a specialized model.
*   Assets are stored and indexed for reuse.
*   Supports “reskin” operations:
    *   “Skin yesterday’s frog game into a space frog theme.”
    *   Uses prior project artifacts + asset library + templates/sub-templates.

### Asynchronous Follow-Up Questions

When confidence is low or ambiguity is detected:

*   The system queues follow-up questions instead of blocking.
*   Questions appear in a pending list for the user to answer when convenient.

---

## 5\. Feature Scope

### In Scope

*   Project scaffolding and step planning.
*   Planning that identifies which artifacts will be updated and why.
*   Workflow enforcement (bounded steps, explicit progression).
*   Walkthrough Mode with reusable walkthrough tips.
*   Follow-Along / Learning Mode with natural language explanations (optional audio stream).
*   Confidence-based follow-up question queue.
*   Context packaging and prompt compilation for coding tasks.
*   Mixture-of-experts selection for:
    *   Coding
    *   Debugging
    *   Sprite/asset generation
    *   Explanations and tutoring
*   Component/pattern library creation and reuse.
*   Templates and sub-templates (lightweight initial support; deeper catalog later).
*   README as a managed, evolving project artifact.
*   Chunked “memory map” of codebase for token-efficient retrieval and planning.
*   Optional MyFeed hook for:
    *   targeted updates (libraries, engines, releases)
    *   answering follow-up questions with fresh external signal

### Out of Scope

*   Full replacement of professional IDE tooling.
*   Unbounded autonomous refactors without review.
*   Full publishing/deployment automation (initially).

---

## 6\. Dependencies

### Architectural Dependencies

*   Memory policy layer.
*   Artifact encoding pipeline.
*   Retrieval engine (project context + pattern reuse + codebase memory map).
*   Escalation engine (to call best-fit expert models).
*   Optional integration with local dev environment tooling (git, tests, build scripts).
*   Optional MyFeed integration for external signal and research follow-through.

### Data & Memory Interactions

Reads:

*   Project artifacts (repo state, files, prior decisions).
*   Codebase memory map (chunk index + summaries + embeddings + rank features).
*   Walkthrough tip library.
*   Component/pattern library.
*   Template/sub-template library (when present).
*   User skill profile (Jason vs Asher vs others).

Writes:

*   Project planning artifacts (plan, checklist, milestones).
*   Decision records (project-specific).
*   Walkthrough notes/tips (reusable guidance).
*   Reusable components/patterns (promoted artifacts).
*   Asset artifacts (sprites/UI) with tags for reuse.
*   Follow-up question queue items.
*   README updates.

---

## 7\. Governance & Risk

Potential risks:

*   Over-automation that reduces learning.
*   Incorrect code changes without clear diffs.
*   Context drift leading to inconsistent behavior.
*   Asset generation inconsistency across iterations.
*   Over-narration that becomes distracting.

Mitigations:

*   One-step-at-a-time changes with explicit diffs.
*   Follow-Along / Learning Mode toggle; defaults on for youth profiles.
*   Versioning of templates, patterns, and walkthrough tips.
*   Clear rollback and snapshot support.
*   Confidence thresholds + queued follow-up questions.

---

## 8\. Success Metrics

*   Project completion rate for youth builders.
*   Reduction in stalled sessions.
*   Reuse rate of patterns/components/walkthrough tips.
*   Time-to-first-working-prototype.
*   Reduction in repeated mistakes (measured by recurring follow-up topics).
*   Token efficiency improvements versus transient-window workflows.

---

## 9\. Open Questions

*   What is the minimum viable “memory map” representation (file-level vs module-level vs function-level chunks)?
*   Should pattern and walkthrough promotion be automatic or require approval?
*   How should asset consistency be maintained across revisions?
*   What is the best UX for the follow-up question queue (per-project vs global inbox)?
*   How should MyFeed signals be scoped so they are helpful without becoming noisy?

---

End of Feature Definition.