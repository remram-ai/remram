# Concept Mock Request

## Purpose

Coordinate design outputs for review during intake or proposal development.

## Inputs

- [Idea document](../../schemas/artifacts/planning/idea-document.template.md) or [Product proposal](../../schemas/artifacts/planning/product-proposal.template.md)
- example workflows
- current review objective

## Outputs

- [Concept materials](../../schemas/artifacts/design/concept-materials.template.md) or [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md)

## Steps

1. Invoke the designer recipe `conceptual-mock`.
2. Pass the current planning artifact and example workflows as inputs.
3. If the request is part of Stage 1, generate concept materials that communicate the intended experience at a conceptual level.
4. If the request is part of Stage 2, generate higher-fidelity proposal mockups for leadership review.

## Artifacts Created

- [Concept materials](../../schemas/artifacts/design/concept-materials.template.md)
- [Proposal mockups](../../schemas/artifacts/design/proposal-mockups.template.md)

## Tools Used

- [Visual Mockup Generator](../tools/visual-mockup-generator.md)
- may use the [Diagram Generator](../tools/diagram-generator.md) for workflow diagrams

