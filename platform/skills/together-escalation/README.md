# Together Escalation

Status: transitional packaging record

Together Escalation originally entered the registry as a skill-oriented runtime capability.

Current correction:

- the live Moltbox appliance does not rely on a Gateway-owned replay-era skill deploy model for this behavior
- the current appliance baseline implements local-first plus Together fallback through native OpenClaw provider/model policy in the owning service and runtime repos

So this local platform item should now be read as:

- a record of the reusable skill-packaging direction for this capability
- not the authoritative description of the current live appliance deployment

## What Problem It Solves

It records the reusable capability idea behind local-first chat with Together-backed recovery when local inference fails.

## Current Appliance Authority

Use these repos for the live implementation:

- `moltbox-gateway` for operator flow and validation
- `moltbox-services` for baseline service config
- `moltbox-runtime` for final deployable runtime artifacts

## Related Documents

- [Together Escalation Feature Record](../../../features/together-escalation/README.md)
- [Together AI Escalation Feature Guide](../../../docs/features/together-escalation.md)
- [Deployment Models](../../../docs/overview/deployment-models.md)
- [Runtime Concept](../../../docs/concepts/runtime.md)
