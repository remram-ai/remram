# Artifact Promotion V2

Container images and synchronized runtime artifacts are promoted across environment-specific service identities.

Example path:

- `openclaw-dev`
- `openclaw-test`
- `openclaw-prod`

The same underlying version may be promoted across all three environments over time.

## Promotion Rules

Default deployment behavior is environment-aware.

- dev: newest candidate artifact
- test: latest approved candidate
- prod: approved stable artifact

Explicit overrides remain available:

```text
--version <tag>
--commit <sha>
```

Promotion model requirements:

- service deployment must support artifact selection and explicit overrides
- runtime configuration synchronization must support the same selector model where the source repository supports it
- approval and promotion state must be resolved independently from feature names

Feature definitions may describe a rollout path, but feature names are never deployment selectors.
