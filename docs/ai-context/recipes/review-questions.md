# Decisions And Remaining Questions

This file records what was decided in review and what still needs implementation or contract work.

## Locked Decisions

1. `plugin` is a first-class concept and should be documented as such.
2. OpenClaw passthrough is supported mode. The Moltbox contract should preserve the current upstream OpenClaw CLI families rather than inventing replacements.
3. Mechanical skill and plugin layout should follow the current upstream OpenClaw package rules, with RemRam using the superset of what OpenClaw supports.
4. Plugin install and config behavior should follow the OpenClaw reload model rather than a Moltbox-specific alternative.
5. Runtime containers are valid public targets of `moltbox gateway service ...`.
6. Runtime redeploy is expected to replay recorded skill and plugin installs since the last full runtime container deploy.
7. Service versus plugin or skill is decided by whether the capability needs its own container. Services still need plugin, skill, or runtime-config surfaces if OpenClaw must consume them.
8. Promotion is `dev` first, `test` through the CLI only, then UAT stop, then approved merge and `prod`.
9. Test plans are mandatory in `dev` before promotion and again in `test` before UAT handoff.
10. The promotion path itself is part of the definition of done and must be fixed if it fails.

## Remaining Open Questions

1. What exact deployment-event schema should gateway persist for replayable plugin and skill installs?
2. What exact artifact format should checkpoint promotion write back into `moltbox-runtime` when a runtime baseline is rebased?
3. What is the final approval and automation contract for the UAT-to-prod step once that workflow is implemented?
