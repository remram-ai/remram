# Platform Items

This file indexes the active platform registry and the main ownership rules around it.

Approved feature records live separately under [../../features/](../../features/README.md). Some of those feature records point to dedicated implementation repositories, but the public capability and platform registry still stay in `remram`.

Active registry entry points:

- [gateway](../../platform/core/gateway/README.md)
- [services category](../../platform/services/README.md)
- [discord-channel](../../platform/skills/discord-channel/README.md)
- [together-escalation](../../platform/skills/together-escalation/README.md)
- [moltbox-telemetry](../../platform/plugins/moltbox-telemetry/README.md)

Use platform item docs for:

- high-level capability intent
- technical specs
- design intent
- operator guidance
- definition-of-done test plans

Registry rules:

- ideas live under `roadmap/ideas/`
- proposals live under `roadmap/proposals/`
- approved feature work lives under `features/`
- feature projects create platform deliverables directly under `platform/core/`, `platform/services/`, `platform/skills/`, or `platform/plugins/`
- new platform bundles should include `README.md`, `spec.md`, `design.md`, `operator-guide.md`, and `test-plan.md`
- user-facing feature documentation belongs under `docs/features/` once the capability is complete enough to document as one coherent feature

Builder guidance:

- platform item docs are not a substitute for the architecture bootstrap in `overview.md`, `topology.md`, `repositories.md`, `cli.md`, and `roles/builders.md`
- read the relevant platform item docs after the architecture bootstrap, not instead of it
- if a task touches service lifecycle, deployment orchestration, or rendered service state, read [gateway](../../platform/core/gateway/README.md) and confirm the repo boundary with `moltbox-gateway`, `moltbox-services`, and `moltbox-runtime`
- service-specific implementation details now live in the owning service repo rather than in local per-service platform bundles under `remram`
- use the local platform registry for ecosystem framing and capability status, not as the detailed service authority

Canonical source:

- [Roadmap](../../roadmap/README.md)
- [Features](../../features/README.md)
- [Platform Registry](../../platform/README.md)
- [Feature Documentation](../features/README.md)
