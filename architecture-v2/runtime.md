# Runtime

Runtime configuration comes from:

```text
moltbox-runtime/<service>/
```

The gateway must read runtime inputs through repository adapters.

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
