# Control Plane

The control plane is the local authority surface of the system.

It is the part that must stay stable enough to own live execution while still being flexible enough to evolve.

## Why The Concept Matters

A serious AI system needs more than "a model on a machine."

It needs a governed local surface that can:

- receive requests
- own sessions
- invoke tools
- gate escalation
- expose operator controls
- keep the appliance stable during iteration

That is what the control plane is for.

## What The Control Plane Owns

Conceptually, the control plane owns:

- runtime authority
- request intake
- session and identity boundaries
- tool invocation and validation
- escalation gating
- operator-facing mutation surfaces

In the Moltbox world, this is why runtime environments, host services, and tooling need to remain distinct even when they live on the same appliance.

## What The Control Plane Does Not Own

The control plane does not own:

- deep reasoning as a default behavior
- durable knowledge authority
- the full user-facing product experience
- the truth of long-term memory

Those concerns belong to other layers.

## Control Plane vs Cognition Plane

The control plane should remain local, inspectable, and boring in the best way.

The cognition plane can be stronger, slower, and more replaceable.

That means:

- the control plane owns execution
- the cognition plane performs deeper reasoning when required
- the control plane decides when escalation happens
- the cognition plane does not become the runtime

## Why This Helps Rapid Iteration

The system needs to improve without destabilizing itself.

A good control plane makes that possible by keeping authority surfaces explicit:

- runtime operation stays governed
- shared services stay inspectable
- tooling evolves without becoming the runtime itself

That is how you get both stability and iteration instead of constantly trading one for the other.
