# Semantic Router Operator Guide

## Purpose

Use this feature when you want a runtime to answer locally when possible and escalate only when necessary.

## Where It Runs

Semantic Router is installed per environment:

- `dev`
- `test`
- `prod`

## Prerequisites

Before enabling it, confirm:

- the target runtime is healthy
- `ollama` is reachable for the local stage
- remote provider credentials are present if escalations are expected
- the runtime baseline includes the router policy files

## Install

Install the plugin through the environment-scoped OpenClaw passthrough:

```text
moltbox dev openclaw plugins install semantic-router
```

Then verify:

```text
moltbox dev openclaw plugins list
moltbox dev openclaw plugins info semantic-router
```

If the runtime requires explicit trust, apply the required OpenClaw config changes through the same passthrough surface.

## Use In Practice

Once installed, normal chat traffic can use the router automatically.

The feature does not introduce a new operator-facing chat endpoint. It changes routing behavior inside the existing runtime.

Use `dev` first, then promote to `test` and `prod` after validation.

## What To Check

If the feature is not working:

- confirm the plugin is installed
- confirm the plugin is trusted and allowed
- confirm the runtime can reach `ollama`
- confirm remote provider keys are present if escalation is expected
- confirm the router config files are present and valid

## Troubleshooting Basics

Common problems:

- local stage fails because `ollama` is unavailable
- plugin route is configured against the wrong port
- cloud escalation fails because provider credentials are missing
- the feature is installed in one environment but missing in another

## TODO

- document the exact Moltbox-wrapped OpenClaw config commands that operators should prefer for plugin trust and provider config once the passthrough contract is finalized
