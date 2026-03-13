# Features

Active documented feature bundles:

- [semantic-router [plugin]](../../features/semantic-router%20%5Bplugin%5D/README.md)
- [moltbox-telemetry [plugin]](../../features/moltbox-telemetry%20%5Bplugin%5D/README.md)
- [together-escalation [skill]](../../features/together-escalation%20%5Bskill%5D/README.md)
- [discord-channel [skill]](../../features/discord-channel%20%5Bskill%5D/README.md)
- [gateway [core]](../../features/gateway%20%5Bcore%5D/README.md)
- [caddy [service]](../../features/caddy%20%5Bservice%5D/README.md)
- [ollama [service]](../../features/ollama%20%5Bservice%5D/README.md)
- [opensearch [service]](../../features/opensearch%20%5Bservice%5D/README.md)

Use feature docs for:

- high-level capability intent
- technical specs
- operator guidance
- definition-of-done test plans

Builder guidance:

- feature docs are not a substitute for the architecture bootstrap in `overview.md`, `topology.md`, `repositories.md`, `cli.md`, and `roles/builders.md`
- read the relevant feature docs after the architecture bootstrap, not instead of it
- if a task touches service lifecycle, deployment orchestration, or rendered service state, read [gateway [core]](../../features/gateway%20%5Bcore%5D/README.md) and its `spec.md`
- for service-specific work, also read the matching service feature bundle and confirm the repository boundary with `moltbox-services` and `moltbox-gateway`

Canonical source:

- [Features](../../features/README.md)
