# Proposal Review Package Assembly

## Purpose

Assemble the decision package for leadership review.

## Inputs

- [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md)
- [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md)
- architecture commentary
- assumptions
- open questions

## Outputs

- [Proposal decision](../../schemas/artifacts/planning/proposal-decision.template.md)
- leadership review package
- optional audio brief

## Steps

1. Create the decision document at `/roadmap/proposals/<proposal>/decision.md` with an initial `pending` status.
2. Attach the proposal document.
3. Attach proposal mockups when they exist.
4. Attach architecture commentary and any supporting architecture sketches.
5. Attach assumptions and open questions.
6. Optionally produce an audio brief at `/roadmap/proposals/<proposal>/brief.mp3`.
7. Present the package for leadership review.
8. Update the decision document with the decision status, rationale, and review participants.

## Artifacts Created

- `/roadmap/proposals/<proposal>/decision.md`
- leadership review package
- optional proposal briefing audio

## Tools Used

- may use the [Audio Brief Generator](../tools/audio-brief-generator.md)

