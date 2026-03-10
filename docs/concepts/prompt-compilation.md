# Prompt Compilation

Prompt compilation is the idea that the system should turn human intent into machine-ready context deliberately, rather than forcing users to do that work by hand.

## Why This Matters

People speak naturally.

They do not naturally provide:

- the right scope
- the right constraints
- the right context bundle
- the right output contract

If a system expects users to provide all of that themselves, it pushes OpenClaw's job back onto the human.

## What Prompt Compilation Does

Conceptually, prompt compilation includes:

- interpreting the request
- identifying the likely task mode
- selecting relevant context
- enforcing a bounded bundle
- choosing an output contract
- preparing escalation payloads when needed

The system is not just passing text through. It is compiling intent into a governed run.

## Not The Same As The Moltbox Control Plane

Prompt compilation belongs to OpenClaw in the community-facing architecture.

It is about shaping live requests for work.

The Moltbox control plane is different. It is about managing the appliance itself through bounded CLI tools, staged mutation flows, and human approval surfaces.

## Relationship To Escalation

Good escalation depends on good prompt compilation.

If the system escalates by forwarding raw transcript history plus a few loose notes, it wastes tokens and increases drift.

If it escalates with a deliberate bundle, the higher-tier model receives:

- clear framing
- bounded evidence
- explicit task expectations

That makes cognition more effective and more replaceable.

## Relationship To Retrieval

Prompt compilation is downstream of retrieval, but it is not the same thing.

Retrieval finds candidate material.

Prompt compilation decides what actually belongs in the live run and how it should be framed.

## Why It Belongs In This Repository

Prompt compilation is a conceptual architecture idea, not just a prompting trick.

It explains how Remram thinks about:

- OpenClaw
- bounded context
- token efficiency
- model replaceability

The implementation details belong in the domain repositories, but the idea belongs here.
