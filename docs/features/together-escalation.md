# Together AI Escalation

## Overview

Together AI Escalation is the appliance feature that keeps ordinary chat local first while allowing OpenClaw to recover to Together-hosted models when local inference fails.

The current appliance implements this as native OpenClaw provider and model policy in the service/runtime baseline. It is not a separate appliance service, and it is not a Gateway-owned replay feature.

## What this feature does

The feature gives each OpenClaw runtime an explicit local-first and cloud-fallback posture:

- local inference remains the default path
- Together is available as a configured fallback chain
- operators manage the required credentials through the appliance secret store
- the behavior is runtime-native, not a separate browser, search, or control-plane subsystem

Important current constraint:

- fallback is failure-driven
- it is not the same thing as "low confidence" semantic escalation

## How to enable it

Store the Together API key through the appliance secret store for the target scope:

```text
moltbox secret set test TOGETHER_API_KEY
```

Then deploy the target runtime through the normal service plane:

```text
moltbox service deploy test
```

Verify the feature is active:

```text
moltbox test openclaw models status --json
moltbox test openclaw backup create --verify
```

## Required components

- OpenClaw native provider/model failover
- appliance secret storage and injection
- service: `ollama` for the local primary model
- service: `test` or `prod`

## Deployment steps

1. Store `TOGETHER_API_KEY` for the target scope with `moltbox secret set <scope> TOGETHER_API_KEY`.
2. Deploy the runtime with `moltbox service deploy <scope>`.
3. Confirm the model chain with `moltbox <scope> openclaw models status --json`.
4. Validate a normal local request in `test`.
5. Validate failure-driven fallback in `test` before promoting the same baseline toward `prod`.

## User workflow

For normal use, operators and users do not manually route between local and Together models. They use the runtime normally. When the local path is healthy, the response stays local. When the local provider fails through OpenClaw failover conditions, the runtime can recover to Together using the configured fallback chain.

## Operational notes

- Together uses the provider id `together` and canonical `together/<publisher>/<model>` refs.
- Secrets should flow through the documented `moltbox secret ...` path.
- Operators should validate the behavior in `test` before treating it as production-ready.
- The detailed live baseline belongs in the owning repos, not in this feature guide:
  - `moltbox-gateway`
  - `moltbox-services`
  - `moltbox-runtime`

## Related records

- [Together Escalation Feature Record](../../features/together-escalation/README.md)
- [Runtime Concept](../concepts/runtime.md)
- [Gateway Concept](../concepts/gateway.md)
