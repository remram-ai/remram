# Gateway/Core Recipe

Use this recipe when the feature is primarily a Moltbox control-plane change rather than a runtime-local extension or one service alone.

## Use This Type When

- the operator-facing CLI contract changes
- deployment orchestration changes
- service lifecycle policy changes
- runtime snapshot, replay, checkpoint, or metadata behavior changes
- the feature affects how the appliance is managed as a whole

Current repo example:

- `gateway`

## Do Not Use This Type When

- the capability is only a runtime-local plugin or skill
- the capability is mainly one service with ordinary lifecycle needs
- the change can stay inside runtime config without changing control-plane behavior

In those cases, use [Plugin](plugin.md), [Skill](skill.md), or [Service](service.md).

## Ownership Model

Local ownership usually splits like this:

- `remram`: platform item docs and architecture contract
- `moltbox-gateway`: CLI, orchestration logic, deployment metadata, snapshots, and appliance control-plane behavior
- `moltbox-services`: service definitions consumed by the gateway
- `moltbox-runtime`: baseline runtime inputs consumed by the gateway
- `remram-skills`: skill and plugin packages the gateway deploys into runtimes

Gateway owns orchestration, not every source artifact it consumes.

## OpenClaw Source Of Record

Use local Moltbox docs in this repo for the appliance control-plane contract.

When gateway behavior depends on current upstream OpenClaw behavior, confirm it in:

- [Gateway CLI](https://docs.openclaw.ai/cli/gateway)
- [Network Model](https://docs.openclaw.ai/gateway/network-model)
- [Gateway Configuration](https://docs.openclaw.ai/gateway/configuration)
- [Configuration](https://docs.openclaw.ai/configuration)
- [CLI Plugins](https://docs.openclaw.ai/cli/plugins) for passthrough assumptions

Do not freeze upstream gateway semantics into this repo without a local note that the assumption was checked against current docs.

## Capabilities

Gateway/core is a good fit when the feature needs to define or change:

- `moltbox` command surfaces
- service deployment flow
- gateway self-update behavior
- runtime reload and checkpoint orchestration
- deployment metadata authority
- rollback, replay, snapshot, or reconciliation behavior

## Limitations

Assume these limits unless the architecture changes:

- gateway should not absorb ownership of service definitions, runtime baselines, or skill source
- direct Docker commands remain break-glass diagnostics, not the normal operator contract
- gateway must preserve native OpenClaw lifecycle where that lifecycle already exists
- internal runtime identifiers stay implementation details rather than top-level CLI namespaces

## Implementation Recipe

1. Start with the operator contract. Write the exact `moltbox ...` surface or lifecycle rule that is changing.
2. Confirm which repository owns the source artifacts and which repository only orchestrates them.
3. Define the deployment metadata and reconciliation behavior the change requires.
4. Define snapshot, rollback, replay, and health-validation implications before writing implementation details.
5. Keep the CLI resource-oriented and avoid leaking container names or Docker-first workflows into the public contract.
6. Document the platform item in `remram/platform/core/<name>/` with `README.md`, `spec.md`, `operator-guide.md`, and `test-plan.md`.
7. Update the platform docs if the change alters the canonical operator model.

## Deployment Method

Primary control-plane surfaces are:

```text
moltbox gateway ...
moltbox gateway service ...
moltbox <env> reload
moltbox <env> checkpoint
```

Gateway/core work often affects more than one deployment path:

- service deployment
- runtime baseline sync
- runtime mutation tracking
- gateway self-update

Treat provenance and metadata consistency as part of the feature, not as follow-up cleanup.

Runtime containers are also valid `gateway service` deployment targets in the current architecture. When that path is used, replay of recorded skill and plugin deployment events is part of the deploy contract.

## Testing Surfaces

Always test these surfaces:

- CLI contract shape and retired-command failure behavior
- service deploy, restart, and status flows
- runtime reload or checkpoint flows
- native OpenClaw passthrough remaining reachable where required
- deployment metadata reconciliation against the running artifact
- cross-environment isolation between `dev`, `test`, and `prod`
- logs and status surfaces for operator diagnosis

## Common Combination Pattern

Gateway/core work often coordinates [Service](service.md), [Skill](skill.md), and [Plugin](plugin.md) features without changing their ownership. If the main change is orchestration or operator contract, gateway/core remains the primary type.
