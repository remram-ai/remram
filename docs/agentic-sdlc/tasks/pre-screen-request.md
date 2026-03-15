# Pre-screen Request

## Purpose

Classify the incoming request and determine whether it should proceed through the full intake workflow.

## Inputs

- incoming user request

## Outputs

- request classification
- routing decision for the appropriate queue

## Steps

1. Receive the incoming request.
2. Classify it as one of: `feature request`, `bug report`, `support question`, `configuration change`, or `documentation request`.
3. Route only `feature request` into the full intake workflow.
4. Route non-feature requests to the appropriate queue.

## Artifacts Created

- none explicitly defined in the workbook

## Tools Used

- not specified in the workbook
