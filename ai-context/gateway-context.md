# Gateway Context

## Purpose

Gateway, expressed conceptually through Moltbox, is the local appliance boundary where runtime authority, infrastructure, and operator control become real. It is the place where live requests actually enter the system and where local-first ownership stops being an architectural idea and becomes an operational fact. When an AI agent needs to understand who owns execution, system posture, and governed appliance mutation, Gateway is the answer.

## Key Responsibilities

- Own the runtime surface that receives and executes live work.
- Host the Moltbox appliance boundary where sessions, infrastructure, and local authority are grounded.
- Expose the Moltbox control plane for inspection, diagnostics, testing, deployment, staging, promotion, rollback, and recovery of the appliance itself.
- Provide operator-facing CLI and bounded management tools instead of unrestricted machine-admin access.
- Serve as the implementation home for runtime configuration, deployment, appliance setup, and gateway-side infrastructure.

## Relationship To Other Parts Of The Ecosystem

Gateway sits below the App and above Cortex. It is adjacent to OpenClaw, but it is not the same thing as OpenClaw.

- App depends on Gateway to expose usable system capability to people and operators.
- OpenClaw is the live orchestration layer that interprets requests, compiles bounded context, selects tools, and decides when escalation is needed.
- The Moltbox control plane manages the appliance itself. It may be asked to do work by OpenClaw, but OpenClaw should not be treated as if it has direct kernel or full-system authority.
- Cortex depends on Gateway and orchestration to receive bounded requests and to return durable knowledge services into live runs.

The key distinction is runtime authority versus management authority. Gateway runs live execution. The Moltbox control plane governs appliance mutation. OpenClaw shapes runs. Those functions cooperate, but they should not collapse into one unrestricted layer.

## What Belongs Here

- Live runtime entry and execution surfaces.
- Moltbox deployment and appliance operations.
- Control-plane tooling for governed mutation of the appliance.
- Implementation-facing docs for runtime and appliance behavior.

## What Does Not Belong Here

- Durable knowledge truth, reconciliation logic, or artifact promotion decisions.
- User-facing product ownership and app UX.
- Reusable agent modules as a primary capability home.
- The conceptual charter for the whole ecosystem; that belongs in this repository.
- Treating OpenClaw as a raw machine-admin layer with unrestricted system power.

## Working Heuristic

If the question is "who owns live execution or appliance operations?" think Gateway. If the question is "who decides what should persist as long-term knowledge?" that is not Gateway.
