# Deployment Event

A Deployment Event is a gateway-owned record of a runtime mutation.

Deployment events are the source material for runtime replay. The runtime container is never the source of truth for installed skills or post-baseline mutations.

## Gateway-Owned State

The gateway records runtime mutation state under `/srv/moltbox-state`.

Current replay-related paths are:

- deployment history: `/srv/moltbox-state/deploy/history.jsonl`
- per-runtime replay log: `/srv/moltbox-state/deploy/runtime/<runtime>/replay-log.json`
- staged replay packages: `/srv/moltbox-state/deploy/runtime/<runtime>/packages/<event_id>/`

`history.jsonl` is the durable historical ledger.

`replay-log.json` is the ordered per-runtime list the gateway uses during runtime redeploy.

The staged package directory is the replay artifact the gateway validates and copies into the runtime during replay.

## Skill Deploy Lifecycle

For a runtime skill deploy such as:

```text
moltbox dev skill deploy together
```

the gateway performs this sequence:

1. resolve the deployable skill and compute its package digest
2. check the current checkpoint metadata for the runtime baseline
3. if the same skill digest is already present in the baseline, return a no-op result and do not create a replay entry
4. stage the skill package under the runtime package directory in appliance state
5. append a structured `skill_install` event to the runtime replay log
6. redeploy the runtime through the normal control-plane path so replay applies the install
7. append the deployment record to `history.jsonl`

The replay log is therefore derived from gateway deploy events, not from container inspection.

## Rollback Lifecycle

For:

```text
moltbox <env> skill rollback <skill>
```

the gateway:

1. finds the latest matching replay event in the runtime replay log
2. removes that replay entry
3. redeploys the runtime from the baseline plus the remaining replay events
4. appends a rollback record to `history.jsonl`

Rollback removes the replay entry but does not erase the historical record from `history.jsonl`.

## Replay During Runtime Redeploy

When the runtime is redeployed through:

```text
moltbox gateway service deploy <env>
```

the gateway:

1. restores the current runtime baseline
2. reads the runtime replay log
3. replays events in order
4. verifies each staged package directory exists
5. verifies each staged package digest before executing the install

If a staged package is missing or corrupted, replay fails fast.

## Source Of Truth

The source of truth is always gateway state under `/srv/moltbox-state`.

The runtime container only executes installs during replay. It does not own a managed-skill manifest or any other authoritative deployment registry.

## Related Concepts

- [Gateway](gateway.md)
- [Runtime](runtime.md)
- [Checkpoint](checkpoint.md)
