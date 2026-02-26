# Write That Down
Feature Definition

---

## 1. Overview

Write That Down is a low-friction idea capture and structuring feature that converts spontaneous thoughts into organized, analyzed, and connected artifacts inside the Idea Vault. It allows ideas to be captured instantly (primarily via voice), refined through structured feedback, linked to related concepts, and revisited over time as technologies, signals, or strategic context evolve.

---

## 2. Problem Statement

Ideas emerge unpredictably — while walking, driving, working, or transitioning between tasks. Most of them are either:

- Lost due to friction in capture
- Captured but never structured
- Disconnected from related ideas
- Never revisited
- Not pressure-tested for feasibility

Additionally:

- Sub-ideas are rarely linked to parent concepts
- Updates to existing ideas are hard to reconcile
- There is no systematic way to detect when new technologies or market changes affect dormant ideas
- Idea management becomes cluttered instead of compounding

The result is idea entropy rather than idea leverage.

---

## 3. Value Proposition

Write That Down transforms inspiration into structured intellectual capital.

- Capture instantly via voice without breaking flow
- Convert raw thought into outline + definitions + clarified assumptions
- Run lightweight feasibility analysis automatically
- Link ideas to related vault artifacts
- Update existing ideas rather than duplicate them
- Periodically resurface dormant ideas when context shifts

Strategically, this feature turns the Idea Vault into a living system rather than a static archive. Ideas compound, evolve, and interconnect over time.

---

## 4. User Experience Model

Entry:
- Voice command or quick capture interface

Flow:
1. User brain dumps idea (voice or text).
2. System summarizes what it heard.
3. System structures into:
   - Core thesis
   - Supporting points
   - Assumptions
   - Open questions
4. System runs feasibility scan (technical, market, effort).
5. System asks for confirmation before vaulting.
6. Idea is stored, linked, and tagged.

Ongoing Interaction:
- "You haven’t revisited this idea in 6 months."
- "New AI hardware may unlock this constraint."
- "Related signal detected in MyFeed."

Ideas appear as nodes in the primary brain-map interface.

---

## 5. Feature Scope

### In Scope

- Instant voice-first capture
- Structured summarization and clarification
- Feasibility analysis (lightweight by default)
- Linking to related ideas or parent concepts
- Updating existing artifacts
- Tagging and categorization
- Periodic resurfacing of dormant ideas
- Signal-based notifications when external context changes

### Out of Scope

- Full project management
- Automatic execution of ideas
- Independent research without user trigger (unless configured)

---

## 6. Dependencies

### Architectural Dependencies

- Retrieval engine (to detect related ideas)
- Memory policy layer
- Artifact encoding pipeline
- Escalation engine (for deeper feasibility analysis)
- Optional MyFeed integration for signal detection

### Data & Memory Interactions

Reads:
- Idea Vault index
- Tag and relationship graph
- Trust graph (for feasibility sourcing)
- External signal summaries (via MyFeed)

Writes:
- Idea artifact
- Linked relationship edges
- Updated artifacts when refining existing ideas
- Rank features for resurfacing logic

---

## 7. Governance & Risk

Potential risks:

- Hallucinated feasibility claims
- Over-structuring early-stage creativity
- Idea clutter without pruning
- Incorrect linking of unrelated ideas

Mitigations:

- Confirmation step before vaulting
- Confidence tagging on feasibility outputs
- Manual edit capability
- Version history preservation

---

## 8. Success Metrics

- Increase in captured ideas per month
- Percentage of ideas structured beyond raw dump
- Number of linked ideas per artifact
- Dormant idea resurfacing engagement rate
- Reduction in duplicate idea artifacts

---

## 9. Open Questions

- Should feasibility always run, or be optional?
- How aggressive should dormant idea resurfacing be?
- Should ideas auto-promote into projects when refined enough?
- What defines an "unlocking technology" trigger?

---

End of Feature Definition.

