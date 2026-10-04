# Repository scope and retirement — 2026-10-04

Status: owner-approved cleanup scope. Remram remains active; archival actions are performed separately by the owner.

## Decision

Remram remains the landing page for its memory-enhanced OpenClaw experiment. Keep Moltbox Gateway, Services, Runtime, Remram Skills, and Forge. Keep the organization introduction. Preserve existing public/private visibility.

Retire Remram Cortex, ElderClaw, and Remram App. Their README notices identify the current destinations and preserve the distinction between knowledge recovery and implementation delivery.

## Livonne boundary

Commercial care, family, community, hardware, and product strategy belong to the three [Livonne organization repositories](https://github.com/livonne-ai). The [knowledge-migration closure](https://github.com/livonne-ai/livonne/blob/main/projects/remram-review-and-system-audit/completion.md) records selected recovery and its examination limits.

The open Remram experiment can continue to explore memory, retrieval, reflection, and OpenClaw integration. Retiring the old Cortex repository does not remove those general ideas from the experiment or select a replacement memory implementation.

## Historical documents

Earlier App → Gateway → OpenClaw → Cortex diagrams, fixed-stack proposals, and Cortex feature records describe prior directions. They are retained as historical or conceptual material, not as the current required topology. Use [the current ownership map](repositories.md) to route work.

Forge has not been migrated into Livonne. Its dedicated source remains a separate private workflow experiment and reference corpus.

## Public-content boundary

Do not add Livonne product requirements, partner/customer records, commercial pricing, household data, work-specific architecture mappings, or secrets to the public Remram repositories. General engineering patterns can remain. Private repositories keep their existing visibility.

The work-context-specific Tango crosswalk was replaced in the current tree with general architecture-reuse guidance. Earlier Git revisions remain historical evidence; this cleanup does not rewrite history or certify prior disclosure review.

## Website boundary

The current website remains served by [SublimeDelusion/livonne](https://github.com/SublimeDelusion/livonne). The successor publication repository is the public [livonne-ai/livonne-web](https://github.com/livonne-ai/livonne-web), with fully formed output at the root of `main`. Strategy, original media, and source/build inputs belong to private [Company website source](https://github.com/livonne-ai/livonne/tree/main/website). Binary transfer preparation is still in progress; the earlier `livonne-ai/website` proposal is superseded. Do not archive the serving repository until the owner confirms that hosting has switched and the replacement is working.
