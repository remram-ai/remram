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
- operator guidance
- definition-of-done test plans

Builder guidance:

- platform item docs are not a substitute for the architecture bootstrap in `overview.md`, `topology.md`, `repositories.md`, `cli.md`, and `roles/builders.md`
- read the relevant platform item docs after the architecture bootstrap, not instead of it
- if a task touches service lifecycle, deployment orchestration, or rendered service state, read [gateway](../../platform/core/gateway/README.md) and its `spec.md`
- for service-specific work, also read the matching service item and confirm the repository boundary with `moltbox-services` and `moltbox-gateway`

Canonical source:

- [Platform Registry](../../platform/README.md)
