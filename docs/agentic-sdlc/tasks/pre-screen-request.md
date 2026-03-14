# Pre-screen Request

## Purpose

Classify the incoming request and determine whether it is a feature idea.

## Inputs

- incoming user request

## Outputs

- request classification
- routing decision on whether the request enters the full intake workflow

## Steps

1. Receive the incoming request.
2. Classify it as one of: `feature_request`, `bug_report`, `question`, `configuration_change`, `documentation`, `support_request`, or `research`.
3. Route only `feature_request` into the full intake workflow.

## Artifacts Created

- none explicitly defined in the workbook

## Tools Used

- not specified in the workbook
