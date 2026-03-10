# Moltbox

Moltbox is the appliance concept at the edge of the Remram ecosystem.

It is the local authority boundary where runtime, infrastructure, and operator responsibility meet.

## What Moltbox Means Conceptually

Moltbox is not just "the box that runs the model."

It is the place where the system becomes locally real:

- the runtime lives there
- sessions are owned there
- infrastructure is operated there
- local-first control becomes concrete there

It is also where the control-plane idea becomes tangible. Moltbox is the place where runtime authority, host services, and operator tooling have to stay stable enough for daily use while still leaving room for rapid iteration.

## What Belongs Here vs Elsewhere

This repository keeps the conceptual explanation of Moltbox:

- why the appliance boundary matters
- how Moltbox fits into the ecosystem
- why local-first authority is part of the design
- why a local control plane matters more than just "having a model on a box"

Detailed implementation guidance for Moltbox belongs in `remram-gateway`.

## Relationship to Remram Gateway

If Remram is the ecosystem vision, Remram Gateway is where Moltbox becomes operational reality.

That repository owns the implementation details for:

- deployment
- runtime configuration
- operator tooling
- appliance setup
- runtime infrastructure

See also:

- [Control Plane](../concepts/control-plane.md)
- [Prompt Compilation](../concepts/prompt-compilation.md)
