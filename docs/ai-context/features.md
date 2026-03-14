# Platform Items

Active documented platform items:

- [gateway](../../overview/core/gateway/README.md)
- [caddy](../../overview/services/caddy/README.md)
- [ollama](../../overview/services/ollama/README.md)
- [opensearch](../../overview/services/opensearch/README.md)
- [discord-channel](../../overview/skills/discord-channel/README.md)
- [together-escalation](../../overview/skills/together-escalation/README.md)
- [moltbox-telemetry](../../overview/plugins/moltbox-telemetry/README.md)

Use platform item docs for:

- high-level capability intent
- technical specs
- operator guidance
- definition-of-done test plans

Builder guidance:

- platform item docs are not a substitute for the architecture bootstrap in `overview.md`, `topology.md`, `repositories.md`, `cli.md`, and `roles/builders.md`
- read the relevant platform item docs after the architecture bootstrap, not instead of it
- if a task touches service lifecycle, deployment orchestration, or rendered service state, read [gateway](../../overview/core/gateway/README.md) and its `spec.md`
- for service-specific work, also read the matching service item and confirm the repository boundary with `moltbox-services` and `moltbox-gateway`

Canonical source:

- [Platform Registry](../../overview/README.md)
