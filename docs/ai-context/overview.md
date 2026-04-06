# Overview

RemRam is the architecture and documentation hub for an ecosystem built around a managed local appliance.

For the live Moltbox appliance contract, load the Gateway repo first:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)
- [Moltbox Operator Guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md)

## Ecosystem Summary

At a high level:

- `remram` owns ecosystem framing, feature records, and platform registry docs
- `moltbox-gateway` owns the live Moltbox appliance/operator contract
- `moltbox-services` owns baseline service definitions, baseline config examples, and service docs
- `moltbox-runtime` owns the final deployable runtime layer
- `remram-cortex` owns Cortex implementation

Current Moltbox summary:

- the host stays minimal
- the gateway is the control plane
- the appliance service set is `gateway`, `caddy`, `ollama`, `searxng`, `test`, and `prod`
- `test` is the proving lane
- `prod` is a protected managed pet
- operators should reason from the CLI/service-plane model rather than direct Docker
