# Decisions And Remaining Questions

This file records what was decided in review and what still needs implementation or contract work.

## Locked Decisions

1. `plugin` is a first-class concept and should be documented as such.
2. OpenClaw passthrough is a supported mode. The Moltbox contract should preserve the current upstream OpenClaw CLI families rather than inventing replacements.
3. Plugin install and config behavior should follow the OpenClaw reload model rather than a Moltbox-specific alternative.
4. Service versus plugin or skill is decided by whether the capability needs its own container. Services still need plugin, skill, or runtime-config surfaces if OpenClaw must consume them.
5. `test` is the proving lane and `prod` is the protected managed pet.
6. Test plans are mandatory before promotion.

## Remaining Open Questions

1. What exact promotion format should write final deployable runtime artifacts into `moltbox-runtime` from service-owned baselines?
2. What is the final approval and automation contract for the UAT-to-prod step once that workflow is implemented?
