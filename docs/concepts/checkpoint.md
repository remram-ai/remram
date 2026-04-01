# Checkpoint

A Checkpoint is a promoted runtime baseline image plus gateway metadata describing that baseline.

Checkpointing is how Moltbox rebases a mutable runtime onto a new golden image and clears the replay chain.

## Gateway-Owned Checkpoint State

Checkpoint state lives under `/srv/moltbox-state/runtime-baselines/<runtime>/`.

Current artifacts are:

- active baseline metadata: `/srv/moltbox-state/runtime-baselines/<runtime>/current.json`
- captured runtime snapshot: `/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/snapshot/`
- image build context: `/srv/moltbox-state/runtime-baselines/<runtime>/<checkpoint_id>/image/`

`current.json` is the control-plane record that selects the baseline image for future runtime redeploys.

## Checkpoint Behavior

For:

```text
moltbox <env> checkpoint
```

the gateway:

1. captures the current runtime container state
2. builds a promoted runtime image named `moltbox-runtime:<runtime>-<checkpoint_id>`
3. records checkpoint metadata in `current.json`
4. clears the runtime replay log
5. redeploys the runtime from the new image
6. records the checkpoint operation in deployment history

After a successful checkpoint, future runtime redeploys start from the promoted image with an empty replay list.

## Base Image Updates

Runtime configuration still comes from the `moltbox-runtime` templates rendered during `moltbox gateway service deploy <env>`.

The runtime image used for that redeploy is still selected by the active checkpoint metadata in `current.json`.

If `current.json` points to a promoted `moltbox-runtime:<runtime>-<checkpoint_id>` image, later runtime redeploys continue to boot that checkpoint image even when upstream `ghcr.io/openclaw/openclaw:latest` has moved.

That means template changes alone do not move a checkpointed environment onto a newer upstream OpenClaw base image.

To adopt a newer upstream base image, operators must first update or replace the selected baseline image and then redeploy the environment through `moltbox gateway service deploy <env>`.

After the redeploy, verify the selected image with `moltbox gateway service status <env>` and verify the running runtime version with `moltbox <env> openclaw --version`.

## Relationship To Replay

Replay only covers post-checkpoint mutations.

Before checkpoint:

```text
baseline image + replay log = current runtime state
```

After checkpoint:

```text
new baseline image + empty replay log = current runtime state
```

This prevents replay history from growing forever.

## Promotion Model

Checkpointing is environment-scoped. The normal operator path is:

```text
dev -> checkpoint -> verify -> promote -> test -> verify -> promote -> prod
```

`dev` is the place to create and validate the checkpointed baseline. Promotion to `test` and `prod` is a deliberate operator step, not an automatic side effect of checkpoint creation.

## Runtime Containers Remain Stateless Executors

Checkpoint promotion does not make the runtime container the source of truth.

The authoritative baseline selection remains the gateway metadata in `current.json`, and replay remains driven from gateway deploy state.

## Related Concepts

- [Gateway](gateway.md)
- [Runtime](runtime.md)
- [Deployment Event](deployment-event.md)
