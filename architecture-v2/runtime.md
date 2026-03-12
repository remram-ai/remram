# Runtime

Runtime configuration comes from:

```text
moltbox-runtime/<service>/
```

The gateway must read runtime inputs through repository adapters.

The current platform target is a Linux host appliance. Runtime containers share the host kernel and should be treated as Linux workloads running on that host, not as alternate host platforms.

## Runtime Operations

Examples:

```text
moltbox openclaw config sync
moltbox openclaw reload

moltbox openclaw-dev config sync
moltbox openclaw-dev reload
```

`openclaw` targets production through the alias:

```text
openclaw == openclaw-prod
```

## Runtime Flow

Canonical flow:

1. refresh the external runtime repository
2. resolve the target component configuration
3. synchronize configuration into the appliance runtime root
4. execute the required runtime lifecycle operation
5. report diagnostics

## Responsibility Boundary

Runtime operations own:

- configuration synchronization
- reload and restart coordination
- runtime-specific diagnostics

Runtime operations do not own:

- service topology definition
- product feature naming
- generic service deployment policy

Canonical appliance storage for runtime material:

- runtime artifacts and synced component state under `/srv/moltbox-state/runtime/`
- logs under `/srv/moltbox-logs/`

User-home runtime paths should be treated as legacy current-state behavior until the appliance has been normalized onto the machine-scoped storage roots.
