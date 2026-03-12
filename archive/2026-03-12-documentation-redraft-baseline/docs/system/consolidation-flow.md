# Consolidation Flow

This page describes the slow path of the system: how interactions become durable knowledge over time.

## 1. Reflection captures candidate signal

After a run completes, the system identifies what may be worth retaining.

This does not mean the system turns every exchange into a permanent fact. It means it extracts candidate signal.

## 2. Candidate knowledge is stored provisionally

The system records structured changes, evidence, and potential long-term updates in a form that can be revisited later.

## 3. Dream revisits the accumulated state

Scheduled reconciliation examines what has been collected and asks:

- what conflicts
- what repeats
- what has become stable
- what should be promoted, merged, or rejected

## 4. Stable knowledge becomes more durable

Some knowledge remains as structured internal state.

Some knowledge is promoted into evergreen artifacts that humans can inspect, review, and reuse.

## 5. The system improves without relying on transcript sprawl

The goal of consolidation is not maximal retention. The goal is compounding clarity.
