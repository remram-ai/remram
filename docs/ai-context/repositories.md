# Repositories

Core ownership summary:

- `remram`: ecosystem framing, approved feature records, platform registry, and high-level architecture docs
- `remram-forge` (private): lifecycle governance, orchestration rules, and lifecycle-owned templates/state contracts
- `moltbox-gateway`: live Moltbox appliance contract, CLI, control plane, operator docs, and deployment orchestration
- `moltbox-services`: baseline service definitions, baseline config examples, and service docs
- `moltbox-runtime`: final deployable runtime artifacts and private/base-specific overlays
- `remram-skills`: reusable skills and plugin packages
- `remram-cortex`: Cortex implementation
- `remram-app`: user-facing applications and APIs

Important boundary rule:

- if the task is about how the live Moltbox appliance works, use `moltbox-gateway` as the authority
- if the task is about service baselines or service docs, use `moltbox-services`
- if the task is about the final deployable runtime layer, use `moltbox-runtime`
- if the task is about ecosystem architecture or feature intent across repos, `remram` is still the right place to start

Start here for appliance truth:

- [Moltbox Gateway README](https://github.com/remram-ai/moltbox-gateway/blob/main/README.md)
- [Moltbox Gateway Docs](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/README.md)
- [Moltbox AI Context](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/ai-context/README.md)
