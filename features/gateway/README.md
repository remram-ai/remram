# Gateway

## Summary

Gateway is the approved feature for the Moltbox appliance control plane.

It gives operators one governed path for deployment, runtime lifecycle, automation access, and appliance self-update.

## Status

Active feature.

Historical proposal and project artifacts for this feature have not yet been reconstructed from the older documentation set.

## User And Operator Outcome

- operators manage the appliance through `moltbox` instead of undocumented Docker-first workflows
- service deployment and restart actions route through one control plane
- environment lifecycle actions such as reload and checkpoint stay environment-scoped
- internal automation reaches the appliance through an authenticated MCP surface

## Primary Platform Deliverables

- [Moltbox Gateway](../../platform/core/gateway/README.md)
- managed targets commonly exercised through the feature:
  - [Caddy](../../platform/services/caddy/README.md)
  - [Ollama](../../platform/services/ollama/README.md)
  - [OpenSearch](../../platform/services/opensearch/README.md)

## Current Lifecycle Artifacts

- [Feature Spec](feature-spec.md)
- [Master Test Plan](test-plan.md)
- [Enhancements](enhancements/README.md)
- [Projects](projects/README.md)

## Related Documentation

- [Gateway Concept](../../docs/concepts/gateway.md)
- [Feature Concept](../../docs/concepts/feature.md)
- [Platform Registry](../../platform/README.md)
