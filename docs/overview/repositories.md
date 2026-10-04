# Repositories

Status: current ownership map, 2026-10-04.

Remram remains the landing page for the memory-enhanced OpenClaw experiment. Livonne is a separate product and architecture destination. See the [scope record](2026-10-04-repository-scope.md).

## Retained ownership

| Repository | Owns |
| --- | --- |
| [remram](https://github.com/remram-ai/remram) | Ecosystem framing, reusable concepts, orientation, feature records, and capability registry |
| [moltbox-gateway](https://github.com/remram-ai/moltbox-gateway) | Appliance CLI, control plane, deployment, verification, operator procedures, and recovery |
| [moltbox-services](https://github.com/remram-ai/moltbox-services) | Baseline service definitions, configuration examples, and service documentation |
| [moltbox-runtime](https://github.com/remram-ai/moltbox-runtime) | Final deployable runtime artifacts and private overlays |
| [remram-skills](https://github.com/remram-ai/remram-skills) | Portable skills and plugin source packages |
| [remram-forge](https://github.com/remram-ai/remram-forge) | Separate Forge/Lobster Reef workflow research and execution-design material |
| [.github](https://github.com/remram-ai/.github) | Organization introduction |

Services, Runtime, and Forge retain their existing private visibility.

## Retired ownership

`remram-cortex`, `elderclaw`, and `remram-app` are ready for archiving. Do not route new implementation work into them. Original sources and historical evidence remain available.

Cortex's recovered concepts now live in [Livonne Platform](https://github.com/livonne-ai/livonne-platform); ElderClaw's selected knowledge is split across [Company](https://github.com/livonne-ai/livonne), [Platform](https://github.com/livonne-ai/livonne-platform), and [Hardware](https://github.com/livonne-ai/livonne-hardware). This was a scoped knowledge migration, not a port of every file or implementation.

## Operational boundary

For current appliance behavior, read [Gateway's operator guide](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/operator-guide.md) and [service catalog](https://github.com/remram-ai/moltbox-gateway/blob/main/docs/guides/service-catalog.md).

Service baselines belong in Services; promoted deployable artifacts belong in Runtime; the CLI and operational procedures belong in Gateway. Live state is not continuously mirrored back into Git. This documentation cleanup does not change appliance configuration, deployment, or service availability.
