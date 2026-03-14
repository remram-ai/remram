# Platform Items

Active documented platform items:

- [gateway](../../platform/core/gateway/README.md)
- [caddy](../../platform/services/caddy/README.md)
- [ollama](../../platform/services/ollama/README.md)
- [opensearch](../../platform/services/opensearch/README.md)
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
- features live under `roadmap/features/`
- new platform deliverables begin in `platform/backlog/`
- once the type is known, the item moves to `platform/core/`, `platform/services/`, `platform/skills/`, or `platform/plugins/`
- new platform bundles should include `README.md`, `spec.md`, `design.md`, `operator-guide.md`, and `test-plan.md`
- user-facing feature documentation belongs under `docs/features/` once the capability is complete enough to document as one coherent feature

Builder guidance:

- platform item docs are not a substitute for the architecture bootstrap in `overview.md`, `topology.md`, `repositories.md`, `cli.md`, and `roles/builders.md`
- read the relevant platform item docs after the architecture bootstrap, not instead of it
- if a task touches service lifecycle, deployment orchestration, or rendered service state, read [gateway](../../platform/core/gateway/README.md) and its `spec.md`
- for service-specific work, also read the matching service item and confirm the repository boundary with `moltbox-services` and `moltbox-gateway`

Canonical source:

- [Roadmap](../../roadmap/README.md)
- [Platform Registry](../../platform/README.md)
- [Platform Backlog](../../platform/backlog/README.md)
- [Feature Documentation](../features/README.md)
