# Together Escalation Test Plan

## Definition Of Done

Together Escalation is done for an environment when:

- the skill is staged successfully into the target runtime
- the runtime recognizes the skill as eligible
- Together-backed models are resolvable to the runtime
- chat can recover from local-model failure to Maverick
- reasoning work uses Kimi K2.5 and can fall back to Qwen 3.5 397B
- coding work uses Qwen Coder Next and can fall back to Qwen Coder 480B
- fallback behavior is visible through runtime logs, model status, or equivalent selection output

## Core Validation

### 1. Install Validation

Verify:

- `moltbox gateway service deploy <env>` or `moltbox <env> reload` succeeds
- `moltbox <env> openclaw skills list` shows `together-escalation`
- `moltbox <env> openclaw skills info together-escalation` resolves correctly

### 2. Config Validation

Verify the target runtime contains:

- the local chat primary model `ollama/qwen3:8b`
- the Maverick chat fallback in the default-agent model chain
- Together model catalog entries for all reasoning and coding models
- Together provider auth for the environment
- reasoning and coding role policy aligned with the documented chains

### 3. Chat Fallback Validation

Use a chat turn that starts on the normal local model, then induce a fallback-eligible local-model failure.

Expected result:

- the request begins on `ollama/qwen3:8b`
- the runtime advances to `together/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8`
- logs or model-selection output make that fallback visible
- the response envelope remains the standard OpenClaw JSON shape with `payloads` and `meta`

### 4. Reasoning Validation

Use a task that routes through the reasoning path.

Expected result:

- the runtime selects `together/moonshotai/Kimi-K2.5` first
- a fallback-eligible failure advances to `together/Qwen/Qwen3.5-397B-A17B`
- the result completes without drifting to an unrelated model

### 5. Coding Validation

Use a task that routes through the coding path.

Expected result:

- the runtime selects `together/Qwen/Qwen3-Coder-Next-FP8` first
- a fallback-eligible failure advances to `together/Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8`
- the coding response remains successful and observable

### 6. Observability Validation

Verify at least one operator-visible surface exposes the effective model path.

Examples:

- runtime logs
- skill diagnostics
- OpenClaw model status or equivalent runtime model-selection output

Also verify logs do not leak:

- `TOGETHER_API_KEY`
- Together bearer-token material
- secret-file contents

### 7. Environment Promotion Validation

Validate the skill independently in:

- `dev`
- `test`
- `prod`

Each environment should have:

- the skill staged
- Together credentials present
- the same documented fallback chains

## Failure Cases To Test

- runtime deploy fails to stage the skill folder from `remram-skills`
- `TOGETHER_API_KEY` is missing in the target environment
- the Together provider is present but one or more required model refs are not in the allowlist
- chat falls back to the wrong Together model
- reasoning or coding paths bypass their documented fallback order
- provider failure occurs in a way that is not fallback-eligible under current OpenClaw rules
- the skill is present in `dev` but missing in `test` or `prod`
- deprecated legacy runtime artifacts reappear in runtime startup, skill inventory, or staged runtime state

## Operator-Visible Success Criteria

- operators can confirm staged skill state with native OpenClaw skill commands through Moltbox
- operators can see Together-backed models in the runtime's model surfaces
- chat, reasoning, and coding paths all use the documented model order
- failures point to a specific auth, allowlist, or provider problem

## Deployment And Runtime Checks

- verify checkpoint metadata and replay state reconcile after the mutation
- verify the runtime remains healthy after runtime deploy or reload
- verify deployment events are captured if runtime deployment-event recording is enabled
- verify environment-specific secrets are present before promotion
