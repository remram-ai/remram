# Platform Registry

`platform/` is the living registry of active RemRam and Moltbox capabilities.

Platform items are organized by primary type:

- `core/` for control-plane and shared platform subsystems
- `services/` for appliance services with their own lifecycle
- `skills/` for portable capability bundles deployed into runtimes
- `plugins/` for runtime extensions installed through the native plugin lifecycle
- `backlog/` for uncategorized candidates that have not yet been promoted

Enhancements stay near the owning platform item so capability history remains local to that item.
