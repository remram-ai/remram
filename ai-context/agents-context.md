# Agents Context

## Purpose

Agents is the reusable capability layer of the Remram ecosystem. It exists so skills, modules, and workflows can be composed across products and runtimes instead of being trapped inside one app, one prompt, or one appliance implementation. The intent is to make useful behavior durable and portable: a capability should be able to serve multiple surfaces without the ecosystem duplicating it in several places.

## Key Responsibilities

- Package reusable skills that can be shared across the ecosystem.
- Provide agent modules and workflow building blocks that can be composed into larger systems.
- Preserve capability as durable, inspectable components instead of burying it inside ad hoc prompts or single-use app code.
- Support the ecosystem goal that some knowledge should mature into reusable artifacts, including skills and workflow components.
- Remain compatible with the broader authority model: agents provide capability, not blanket permission.

## Relationship To Other Parts Of The Ecosystem

Agents sits alongside the major operational layers rather than above them.

- App may expose or orchestrate agent-backed workflows in user-facing products.
- OpenClaw may call or compose agent capabilities when shaping a live run.
- Cortex may help promote durable knowledge into reusable artifacts that later become agent-facing building blocks.
- Gateway may host or execute systems that use these capabilities, but Gateway does not turn Agents into the authority over runtime or appliance control.

The important architectural idea is that reusable capability is not the same thing as global control. Agents should remain modular and composable. They should not become a hidden place where runtime policy, knowledge authority, or control-plane privilege accumulates by accident.

## What Belongs Here

- Reusable skills.
- Agent modules.
- Shared workflow logic for agent-driven behavior.
- Capability components designed to be used across multiple products or runtime contexts.

## What Does Not Belong Here

- User-facing app ownership.
- Gateway deployment, runtime configuration, or appliance management.
- Cortex ownership of durable knowledge truth, retrieval policy, or reconciliation.
- Ecosystem-level conceptual framing that belongs in this repository.
- Treating an agent package as if it automatically owns authority over every layer it can touch.

## Working Heuristic

If a behavior should be portable across products and runtimes, it probably belongs in Agents. If it depends on owning the UI, the runtime, or long-term knowledge authority, it probably belongs somewhere else and should consume agent capability rather than be stored here.
