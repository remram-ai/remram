# Moltbox

Moltbox is the appliance concept at the edge of the Remram ecosystem.

It is the local authority boundary where runtime, infrastructure, and operator responsibility meet.

## What Moltbox Means Conceptually

Moltbox is not just "the box that runs the model."

It is the place where the system becomes locally real:

- the runtime lives there
- sessions are owned there
- infrastructure is operated there
- local-first appliance authority becomes concrete there

It is also where the control-plane idea becomes tangible. In this context, the control plane is not OpenClaw. It is the Moltbox management surface: the CLI tools and services that inspect, test, stage, deploy, and promote changes to Moltbox itself.

That distinction matters because the system may be allowed to improve itself, but it should do so through governed Moltbox tools instead of unrestricted machine access.

## What Belongs Here vs Elsewhere

This repository keeps the conceptual explanation of Moltbox:

- why the appliance boundary matters
- how Moltbox fits into the ecosystem
- why local-first authority is part of the design
- why the Moltbox control plane is different from OpenClaw
- why a managed appliance surface matters more than just "having a model on a box"

Detailed implementation guidance for Moltbox belongs in `remram-gateway`.

## Relationship to Remram Gateway

If Remram is the ecosystem vision, Remram Gateway is where Moltbox becomes operational reality.

That repository owns the implementation details for:

- deployment
- runtime configuration
- Moltbox CLI and operator tooling
- appliance setup
- runtime infrastructure

See also:

- [Moltbox Control Plane](../concepts/control-plane.md)
- [Prompt Compilation](../concepts/prompt-compilation.md)
