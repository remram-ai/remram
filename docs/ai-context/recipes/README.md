# Platform Item Type Recipes

Use this folder after the architecture bootstrap in [Builders](../roles/builders.md).

These recipes answer a narrower question:

- what kind of thing am I building
- which repository owns each part
- how does it deploy
- what should I test

Use this layer after approved feature work has defined a platform deliverable and you need to place it under the correct platform item type.

The current architecture exposes four implementation shapes in active platform item docs:

- [Plugin](plugin.md)
- [Skill](skill.md)
- [Service](service.md)
- [Gateway/Core](gateway-core.md)

## How To Use This Set

1. Read the platform bootstrap first.
2. Pick the primary platform item type.
3. Read the matching recipe.
4. If the capability spans multiple types, keep one primary type and treat the others as dependencies.

Examples from the current repo:

- `moltbox-telemetry` is primarily a plugin platform item
- `together-escalation` is primarily a skill platform item
- `ollama` is primarily a service platform item
- `gateway` is the control-plane platform item

## Selection Heuristic

Choose `plugin` when the capability is mainly a runtime-local OpenClaw extension installed through the native plugin lifecycle.

Choose `skill` when the capability is a portable RemRam package that may combine plugin code, runtime policy, manifests, prompts, and deploy recipe material.

Choose `service` when the capability needs a long-running container with its own lifecycle, health checks, networking, and storage posture on the appliance.

Choose `gateway/core` when the capability changes the operator control plane, CLI contract, deployment orchestration, metadata, or snapshot/recovery behavior.

## Upstream Source Policy

These docs intentionally summarize local architecture and link out to current upstream OpenClaw documentation instead of copying it.

Keep in this repo:

- RemRam and Moltbox ownership boundaries
- build and deployment recipes
- local assumptions and gaps
- platform-item-specific policy

Do not try to mirror all OpenClaw docs here. Link to the current upstream pages and update the local assumptions when upstream contracts change.

## Review Input

Before treating these recipes as final, review the unresolved contract questions in [Review Questions](review-questions.md).
