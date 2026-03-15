# Repo Setup

This repository is documentation-first.

You do not need a full appliance environment just to work on the documentation set.

## Minimum Setup

1. Clone `remram`.
2. Open the repository in your editor.
3. Use the active docs under `docs/`, `platform/`, and `roadmap/`.
4. Use `archive/` only as historical source material.

## Adjacent Repositories

Documentation in this repository often describes work owned elsewhere.

The most common adjacent repositories are:

- `remram-forge` (private internal development pipeline)
- `moltbox-gateway`
- `moltbox-runtime`
- `moltbox-services`
- `remram-skills`
- `remram-cortex`
- `remram-app`

If your change crosses from documentation into implementation, you will usually need one or more of those repositories checked out locally as sibling workspaces.

## Practical Setup Guidance

- keep `remram` available as the documentation source of truth
- clone `remram-forge` when the task touches private lifecycle governance, orchestration contracts, or lifecycle schema definitions
- clone the owning implementation repository only when you need to verify behavior or code
- prefer reading active implementation sources instead of relying on stale historical notes

## Repository Layout To Know

- `docs/` for shared documentation
- `platform/` for active capability documentation
- `roadmap/` for ideas and proposals, and `features/` for approved feature records plus local enhancement/project scaffolding
- `remram-forge/` for private internal lifecycle governance, workflows, and lifecycle-owned schemas
- `archive/` for frozen historical material

## Next Step

Once your local setup is ready, use [Getting Started](getting-started.md) for orientation and [Development Workflow](development-workflow.md) for the normal contribution flow.
