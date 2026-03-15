# Testers

Use this file as a quick bootstrap if you are validating platform behavior, runtime changes, or platform item readiness.

What to know first:

- every implemented platform item bundle includes a `test-plan.md`
- test plans are the platform-item-level definition of done
- gateway owns deployment metadata and deployment-event recording
- runtime validation must distinguish container health from mutable runtime state

How to read platform item test plans:

- `README.md` explains what the platform item is
- `spec.md` explains technical behavior and dependencies
- `design.md` explains the intended structure and tradeoffs
- `test-plan.md` defines the expected validation surface
- `operator-guide.md` explains real operational touchpoints

Validation posture:

- verify operator-visible behavior first
- verify deployment metadata when lifecycle work occurs
- verify runtime health and runtime state separately
- use snapshots and checkpoint concepts when assessing rollback or rebuild behavior

Canonical docs:

- [Deployment Models](../../overview/deployment-models.md)
- [CLI Reference](../../../reference/cli-reference.md)
- [Snapshot](../../concepts/snapshot.md)
- [Checkpoint](../../concepts/checkpoint.md)
- [Roadmap](../../../roadmap/README.md)
- [Platform Registry](../../../platform/README.md)
