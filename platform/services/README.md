# Service Platform Items

`platform/services/` is now an ecosystem pointer, not the service-authority home.

Use the owning service repo for live service definitions, baseline service config, and service-local docs.

Current owner:

- `moltbox-services`

Current rule:

- this directory should not be used as a second detailed service-doc tree
- when a service belongs to the live Moltbox appliance, the long-form service contract lives in `moltbox-services`
- `remram` may keep only short registry or transition pointers here

Go next:

- Use [Platform Registry](../README.md) for lifecycle and bundle rules.
- Use [Repository Authority Rules](../../docs/overview/repository-authority-rules.md) for repo placement decisions.
- Use the matching service README in `moltbox-services/services/<service>/`.
