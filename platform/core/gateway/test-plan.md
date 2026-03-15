# Moltbox Gateway Test Plan

## Definition Of Done

Gateway is done when the appliance can be operated through the documented control path without falling back to undocumented Docker-first behavior.

That means:

- the CLI surface is coherent
- deployment metadata is trustworthy
- service lifecycle commands work
- environment lifecycle commands work
- native OpenClaw passthrough remains reachable through the environment namespaces

## Core Validation

### 1. CLI Contract Validation

Verify the documented namespaces exist:

- `gateway`
- `dev`
- `test`
- `prod`
- `ollama`
- `opensearch`
- `caddy`

Verify retired namespaces fail rather than silently redirect.

### 2. Gateway Status And Logs

Verify:

- `moltbox gateway status` returns a meaningful control-plane view
- `moltbox gateway logs` returns the expected diagnostics surface
- `moltbox gateway mcp-stdio` returns a valid MCP stdio session
- `moltbox gateway docker ping` reports Docker reachability
- `moltbox gateway docker run hello-world` creates the expected test container

### 3. MCP Token Validation

Verify:

- `moltbox gateway token create <name>` returns a token value once
- `moltbox gateway token list` returns token names without secret values
- unauthenticated `POST /mcp` returns `401`
- authenticated `POST /mcp` returns a valid MCP response
- `moltbox gateway token rotate <name>` invalidates the old token and activates the new one
- `moltbox gateway token delete <name>` removes access
- token records are stored through the encrypted appliance secret store rather than a separate token database

### 4. Service Pipeline Validation

Verify the gateway service pipeline can:

- report service status
- deploy a service
- restart a service
- reject `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` with guidance to use `moltbox gateway update`

At minimum, validate against a stable shared service such as `opensearch`.

### 5. Self-Update Validation

Verify `moltbox gateway update`:

- refreshes the gateway source or build input
- rebuilds and replaces the host `moltbox` CLI binary without a manual operator `go build`
- resolves a target artifact
- updates the running gateway safely
- writes authoritative deployment metadata
- appends `/var/lib/moltbox/history.jsonl`

After update, verify newly added CLI surfaces are available from the appliance host binary.

### 6. Environment Lifecycle Validation

Verify:

- `moltbox dev reload` works
- `moltbox dev skill deploy <skill>` works for a pure skill package
- `moltbox dev skill list` reports the deployed skill
- `moltbox dev skill remove <skill>` removes the replayed skill
- the target runtime remains healthy
- environment-scoped operations do not leak across environments

### 7. Native OpenClaw Passthrough Validation

Verify an environment-scoped native command works through Moltbox.

Example class:

- plugin install or plugin inspection

### 8. SSH Automation Validation

Verify:

- `jason-codex` can run `moltbox <args>` over SSH
- `jason-codex` cannot open unrestricted shell commands
- `codex-bootstrap` can run full CLI diagnostics in `dev`
- `codex-bootstrap` is denied mutating actions in `test` and `prod`

### 9. Metadata Reconciliation

For a deployment action, verify the following reconcile:

- running artifact identity
- rendered artifact identity
- deployment record fields

## Failure Cases To Test

- deployment metadata does not match the running artifact
- a service deploy fails health validation
- environment reload succeeds mechanically but leaves the runtime unhealthy
- passthrough commands work in one environment and not another
- legacy namespaces are still accepted
- invalid MCP tokens are accepted
- restricted SSH identities can escape their command wrapper

## Operator-Visible Success Criteria

- operators can manage the appliance through `moltbox` alone
- service deploys and runtime lifecycle actions are distinguishable and predictable
- gateway update does not create provenance ambiguity
- failures point to a specific service, runtime, or metadata problem

## Deployment And Runtime Checks

- inspect deployment records after service changes
- confirm checkpoint metadata and replay state reconcile after runtime mutation
- confirm runtime deployment events are tracked where expected
- confirm logs and status surfaces expose enough information for diagnosis

## Repeatable Validation Script

The repeatable CLI validation script for this plan lives at:

```text
scripts/validate-moltbox-cli.ps1
```

The script is designed to be rerunnable, creates temporary runtime artifacts, and cleans up afterward. `gateway update` is opt-in because it intentionally mutates appliance release state.
