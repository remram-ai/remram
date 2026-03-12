# Memory Layers

Remram makes more sense when its memory posture is described in layers.

## Memory Policy

This is the authority layer.

It decides:

- what kinds of memory objects exist
- what is eligible for retrieval
- what is private, shared, provisional, or durable
- what may be promoted, demoted, merged, or rejected

Similarity systems do not replace this layer.

## Session Context

This is the short-lived state used during an active run.

It is useful, but it is not durable truth.

## Episodic Evidence

This is the layer of chunks, evidence, and traceable material that can later support retrieval.

It helps the system rehydrate context without pretending that every stored fragment is canonical.

## Similarity and Ranking

This is the retrieval-signal layer.

It includes:

- embeddings
- lexical search
- rank features such as recency, trust, or usage

It helps the system find candidates, but it should not decide truth or policy on its own.

## Context Assembly

This is the bounded bundle layer.

It is where the system turns policy-gated and similarity-ranked material into a small, useful packet for a live run.

This is an important distinction: retrieval does not mean dumping everything relevant into a prompt.

## Durable Knowledge

This is the layer the system wants to trust over time.

It should be structured, scoped, provenance-aware, and bounded.

## Artifacts

Some knowledge deserves human-readable form:

- charters
- summaries
- plans
- evolving long-lived documents

Artifacts are not the whole memory system, but they are an important output of it.

## Why The Layering Matters

Without layers, systems either forget too much or keep too much.

The Remram approach is to preserve different kinds of state differently and let different parts of the system own different decisions:

- policy decides eligibility
- similarity ranks candidates
- context assembly builds bundles
- durable knowledge preserves what should endure
