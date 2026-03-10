# Escalation Model

Remram assumes that not every task should be solved in the same way.

Some work should stay local. Some work should use stronger external models. Some work should become asynchronous or agent-driven.

## The Basic Idea

Escalation is not failure.

It is the system deciding that a different path is more appropriate for the task.

## Common Escalation Paths

- use a stronger model
- ask the user for clarification
- dispatch a longer-running workflow
- defer work into a background process

## Why This Is Conceptual Here

This repository describes the idea of escalation and why it matters.

Detailed implementation of model routing, OpenClaw hooks, tool selection, and policy logic belongs in the implementation repositories.
