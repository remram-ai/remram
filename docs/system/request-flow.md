# Request Flow

This page explains the conceptual path of a live request through the ecosystem.

## 1. A user or client sends a request

The request typically originates from a person using an app, client, or connected channel.

## 2. The gateway receives the request

The runtime layer, centered on Gateway / Moltbox, receives the request and owns the live execution boundary.

## 3. Orchestration shapes the run

The orchestration layer determines how the run should proceed:

- what context is needed
- what model path is appropriate
- whether escalation is required
- which agents or tools are relevant

## 4. Cortex may provide knowledge

If the run needs durable knowledge, Cortex provides a bounded retrieval bundle rather than a raw dump of history.

## 5. The live run completes

The system returns a response through the runtime and user-facing layers.

## 6. Post-run processing begins

Only after the visible run completes does the system begin the write-side work of reflection and later reconciliation.

That separation is one of the core architectural ideas of Remram.
