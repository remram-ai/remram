# Moltbox Gateway Operator Guide

## Purpose

Gateway is the normal operator entrypoint for the appliance.

Use it for service lifecycle, gateway lifecycle, environment lifecycle, and native runtime passthrough.

## Primary Control Path

Preferred path:

```text
Workstation -> ssh -> Moltbox CLI -> Gateway
```

Canonical workstation form:

```text
ssh -T -i ~/.ssh/jason-codex jason-codex@<gateway-host> "moltbox <args>"
```

Replace `<gateway-host>` with the SSH hostname or host alias for the appliance.

Do not run a host-local `moltbox` binary on the workstation and expect runtime mutation to execute correctly there. Runtime operations must be initiated from the gateway host CLI over the SSH wrapper path.

Internal agents and containers may use the gateway MCP HTTP surface over the appliance network with bearer tokens managed by `moltbox gateway token ...`.

## Common Commands

Gateway status and logs:

```text
moltbox gateway status
moltbox gateway logs
moltbox gateway mcp-stdio
moltbox gateway docker ping
moltbox gateway docker run hello-world
moltbox gateway token list
```

Gateway update:

```text
moltbox gateway update
```

`moltbox gateway update` writes the control-plane deployment record under `/srv/moltbox-state/deploy/history.jsonl` and appends a host-level appliance history entry to `/var/lib/moltbox/history.jsonl`.

Gateway self-mutation uses `moltbox gateway update`. `moltbox gateway service deploy gateway` and `moltbox gateway service restart gateway` are intentionally rejected.

Service lifecycle:

```text
moltbox gateway service deploy opensearch
moltbox gateway service restart caddy
moltbox gateway service status ollama
```

`moltbox gateway service restart <service>` reuses the deploy lifecycle and waits for health before it returns success.

Environment lifecycle:

```text
moltbox dev reload
moltbox dev checkpoint
moltbox dev skill deploy together
moltbox dev skill list
moltbox dev skill remove together
```

Native runtime passthrough:

```text
moltbox dev openclaw models status
```

## How To Use It In Practice

Use the gateway service pipeline when you are changing appliance services.

Use the environment lifecycle surface when you are changing a runtime environment.

Use native OpenClaw passthrough when the runtime already has a real lifecycle command and Moltbox is intentionally forwarding it rather than replacing it.

## Main Operational Touchpoints

- control-plane status and logs
- deployment records in appliance state
- service health
- runtime health after reload or mutation
- snapshot and checkpoint behavior for runtime changes

## What To Check First

If something is not working:

1. check `moltbox gateway status`
2. inspect `moltbox gateway logs`
3. check the affected service or environment
4. compare deployment metadata with the expected artifact

## Troubleshooting Basics

Common failure areas:

- the wrong artifact is running after an update
- a service container restarts but fails health validation
- runtime mutation succeeds partially and leaves the runtime unhealthy
- operator commands are routed through the wrong environment

## Break-Glass Posture

Direct Docker commands remain a diagnostic fallback, not the normal operating contract.

If Docker is needed to diagnose a failure, treat that as an exception path and return to the gateway surface once the issue is understood.

## SSH Automation

Supported restricted identities:

- `jason-codex` for CLI-only automation
- `codex-bootstrap` for break-glass diagnostics

## Validation Script

The repeatable CLI validation script lives at:

```text
scripts/validate-moltbox-cli.ps1
```

It creates temporary runtime artifacts, exercises the documented command groups, and cleans up afterward. `gateway update` remains opt-in because it intentionally mutates appliance release state.
