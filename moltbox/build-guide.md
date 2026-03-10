# Moltbox Build Guide

This guide is for building a Moltbox as a real appliance, not just a generic AI PC.

It is meant to help you make hardware choices that fit the actual Remram posture: local authority, local routing, stable storage, and enough headroom for containers, indexing, and growth.

If you want a specific example, see [Moltbox Prime](builds/Moltbox-Prime/moltbox-prime.md). If you want the conceptual framing of Moltbox in the wider ecosystem, see [docs/overview/moltbox.md](../docs/overview/moltbox.md).

## What You Are Actually Building

A Moltbox is not optimized for benchmark screenshots or maximum local model size.

It is optimized for:

- stable 24/7 operation
- a strong local routing tier
- predictable OpenSearch performance
- enough CPU concurrency for multiple containers and background jobs
- storage separation between system state, database state, and backups
- moderate cloud escalation when local reasoning should stop

That changes what matters.

For most Moltbox builds:

- `VRAM` matters more than raw gaming performance
- `system RAM` matters more than people expect because of OpenSearch and container pressure
- `CPU cores/threads` matter because this is a multi-service appliance
- `storage layout` matters more than buying one giant fast drive

## Pick A Build Family First

Do not start with parts. Start with the kind of box you are trying to build.

| Family | Best for | Local model posture | Typical memory posture | General feel |
| --- | --- | --- | --- | --- |
| `Edge` | light household use, remote-heavy cognition | little or no serious local inference | 32-64GB | simple, quiet, more cloud dependent |
| `Solo` | one primary user with a real local router | practical local routing, moderate cloud escalation | 64-128GB | personal, responsive, budget-aware |
| `Family` | shared use, heavier indexing, more services | strong local routing, moderate cloud escalation | 128GB+ | the serious default Moltbox |
| `Sovereign` | heavy local AI, specialized workloads, low cloud dependence | larger local models and more specialization | 256GB+ | expensive, powerful, intentionally overbuilt |

For most people building a first "real" Moltbox, `Family` is the center of gravity.

## The Main Design Rule

Build for routing, storage, and continuity first.

Do not overspend on deep local reasoning if:

- your local model is mainly doing orchestration through OpenClaw
- cloud escalation is still acceptable
- your bigger pain point is memory, indexing, or multi-service stability

That is why a serious Moltbox often spends more on `VRAM floor`, `system RAM`, and `drive layout` than a normal gaming PC would.

## Component Guide

### GPU

The GPU determines how capable your local routing layer can be before it has to escalate.

### What matters most

- VRAM capacity
- stable CUDA-class support
- thermals and sustained operation
- whether the card fits the case and power budget

### What matters less than people think

- gamer-prestige marketing
- peak FPS-oriented marketing
- buying the biggest possible card if the rest of the appliance is underbuilt

### Practical guidance

- `8-12GB VRAM`: acceptable only for a lighter edge box or experimental local inference
- `16GB VRAM`: practical minimum for a serious Moltbox routing tier
- `24-32GB VRAM`: stronger local headroom, lower escalation pressure, more comfortable with larger local models
- `48GB+ / multi-GPU`: only when you are intentionally building a higher-end sovereign box

For Moltbox, VRAM is usually more important than shader throughput alone. If a model only fits through aggressive compromise, the box is probably one tier too small for that workload.

### Practical 16GB GPU Allocation

On a `16GB` Moltbox GPU, the healthy posture is to preserve reliability instead of trying to consume every last gigabyte.

A good mental allocation looks like:

- `8-10GB`: local orchestration model plus KV headroom
- `1-2GB`: optional embeddings workload if you insist on keeping it GPU-resident
- `2-4GB`: safety margin for runtime overhead, prompt growth, and short spikes

If the box is primarily an OpenClaw appliance, the local router should win every resource argument. Optional image jobs, embeddings, or side experiments should not be allowed to make the orchestration tier feel sluggish.

### Quantization And Local Model Fit

The local model is usually there to route, classify intent, assemble context, and enforce structure. It is not there to impersonate a frontier reasoning model.

Historical Moltbox guidance for a `16GB` class GPU looked roughly like this:

| Model style | Typical quantization posture | What it is good at | Main tradeoff |
| --- | --- | --- | --- |
| `4B` instruct router | `Q8` | fast routing, schema output, large context headroom | less arbitration depth |
| `8B` instruct router | `Q8` | best overall balance for general routing | moderate latency |
| `14B` instruct router | `Q5` | stronger ambiguity handling, fewer unnecessary escalations | tighter context and lower throughput |

The old guidance was directionally clear:

- `4B Q8` is the speed-first option
- `8B Q8` is the balanced default
- `14B Q5` is the upper dense-model boundary for a normal `16GB` Moltbox

If you are forced into very aggressive quantization just to make the model fit, expect some loss in structured reliability. For Moltbox, that matters. A slightly smaller model that routes cleanly is often better than a larger one that barely fits.

### Local Model Profiles For A 16GB Moltbox

For most Moltbox builders, the real question is not "what is the best model in the abstract?" It is "what is the best local orchestration model for OpenClaw I can run on a `16GB` card without unacceptable latency or drift?"

These profiles assume the GPU is dedicated to one local orchestration model, not a pile of competing helpers.

| Model | Class | Quantization | Usable context on 16GB | First token | Typical throughput | Personality |
| --- | --- | --- | --- | --- | --- | --- |
| `Qwen3-4B-Instruct-2507` | 4B | `Q8` | `32k+` | `~0.4-0.8s` | `~160-260 tok/s` | speed-first |
| `Qwen3-8B-Instruct` | 8B | `Q8` | `16k-32k` | `~0.9-1.8s` | `~90-160 tok/s` | balanced default |
| `Qwen3-14B-Instruct` | 14B | `Q5` | `~16k` | `~1.8-3.5s` | `~45-95 tok/s` | maximum local judgment |

Assumptions:

- single-user execution
- no concurrent sessions
- moderate system prompt and tool definitions loaded
- CUDA acceleration via a `llama.cpp`-class runtime
- FP16/BF16 KV cache

These numbers are design envelopes, not lab guarantees. Prompt size, KV pressure, runtime choice, and decoding settings all change them.

### The Three Defensible Personalities

- `4B Q8`: use this if responsiveness is the priority and the box mainly needs to parse intent, emit clean JSON, and route quickly
- `8B Q8`: use this if you want the best overall balance of speed, schema discipline, and orchestration quality on a `16GB` card
- `14B Q5`: use this if the `8B` model feels too shallow and you want the smartest dense local orchestration model that still fits responsibly

The practical decision rule is simple:

- if `8B Q8` feels slow, go down to `4B Q8`
- if `8B Q8` feels dumb, go up to `14B Q5`

That is a better mental model than endlessly debating tiny family differences between nearby sizes.

If the model family offers an explicit "thinking" mode, the default local model for OpenClaw should usually keep it disabled. Moltbox works best when the local model behaves like a router and prompt compiler, not a deep-thinking agent.

### Why This Guide Uses A Qwen Ladder

This guide uses the `Qwen3` family for the default `4B / 8B / 14B` ladder because it gives a coherent set of instruction-tuned checkpoints with strong structured-output behavior across all three sizes.

That is not a claim that Qwen is the only serious option. It is a claim that on a `16GB` Moltbox, using one family across speed, balanced, and max-local-intelligence tiers gives builders a cleaner tradeoff story and fewer prompt-style surprises.

If you have more GPU headroom, more budget, or more tolerance for experimentation, other families get more interesting quickly, including `Llama`, `Gemma`, `DeepSeek`, and mixture-of-experts designs.

### One Local Model Is Usually Better Than Several

For a normal Moltbox, one local orchestration model is usually the right move.

Running multiple local models on the same card sounds flexible, but it often creates:

- VRAM pressure
- slower scheduling
- more debugging ambiguity
- more inconsistent behavior across turns

The clean pattern is:

- one local orchestration model backing OpenClaw
- deliberate escalation upward when the job is bigger than the box

### CPU

The CPU is not just "whatever feeds the GPU."

In a Moltbox, the CPU carries:

- container concurrency
- OpenSearch responsiveness
- indexing and embeddings work
- orchestration services
- background jobs and future extensions

### Practical guidance

- `8 cores`: workable lower bound for a smaller box
- `12-16 cores`: strong baseline for a real Moltbox
- `16+ cores`: recommended if you expect multiple services, multiple users, or heavier indexing
- `24+ cores`: only when the rest of the appliance is also scaled to match

The old design guidance was right here: more threads are not wasted if the machine is running many containers and background services. A Moltbox is a small appliance stack, not a single foreground app.

If your instinct is "I want enough threads that each always-on service can breathe," that instinct is correct. OpenClaw, OpenSearch, backup work, monitoring, and supporting containers all add up.

### Platform tradeoff

- `AM4 / DDR4`: cheaper memory, mature platform, great value when you want lots of threads without platform inflation
- `AM5 / DDR5`: better upgrade path, stronger memory bandwidth, higher ceiling, higher cost

If budget pressure is real, an older mature platform with enough cores can be the smarter Moltbox choice than a newer platform that forces you to cut RAM or storage. That is especially true when memory pricing is ugly and the "old" platform lets you keep the `128GB` target.

### System Memory

This is where many first builds get it wrong.

A Moltbox does not need huge RAM only because of the model. It needs RAM because the appliance is also carrying:

- OpenSearch
- filesystem cache
- embeddings and indexing work
- multiple containers
- orchestration services
- background jobs
- future memory growth

For many Moltbox builders, the local model is not the real reason system memory gets large.

The real reason is that OpenSearch is a RAM-and-cache workload:

- JVM heap needs room
- Lucene wants filesystem cache
- indexing and merges create bursts
- co-resident services still need space to breathe

In the Moltbox design, OpenSearch is not just a vector bucket. It is the local context router combining:

- hard filters
- BM25 or lexical scoring
- rank features like recency and trust
- optional embedding similarity

That is another reason RAM matters so much. The system is asking OpenSearch to be a real retrieval engine, not a toy metadata store.

If the box feels mysteriously slow under load, the failure mode is often memory pressure, not lack of raw CPU speed.

### Practical guidance

- `32GB`: edge-only territory
- `64GB`: practical solo baseline
- `128GB`: strong Family-tier target
- `256GB+`: sovereign, heavy indexing, or heavier multi-user growth

If you have to choose between slightly more CPU and much more RAM, the RAM often helps the appliance more, especially once OpenSearch and retrieval become real.

Capacity also matters more than chasing memory-speed bragging rights after a certain point. The point is to keep the system stable and reduce disk pressure, not to win a synthetic benchmark.

### OpenSearch Changes The RAM Equation

If Moltbox is running `OpenClaw`, a local model, and `OpenSearch` on the same machine, these are the meaningful RAM tiers:

- `32GB`: workable minimum, but you need to stay disciplined about ingest, background jobs, and co-resident services
- `64GB`: the box starts feeling consistently fast instead of intermittently stressed
- `128GB`: the box gets headroom for OpenSearch cache, merges, embeddings, backups, and "random other containers" without fighting itself

That is why an `AM4 + DDR4 + 128GB` build can be smarter than a newer `AM5 + DDR5 + 64GB` build if the price is close. For this workload, capacity usually beats memory bandwidth.

### Practical OpenSearch Memory Posture

Treat OpenSearch as a real service, not just another container.

Good single-box rules:

- do not give the JVM more than `50%` of system RAM
- on a `64GB` box, a rough OpenSearch heap target is `8-10GB`
- on a `128GB` box, a rough OpenSearch heap target is `12-16GB`
- leave substantial RAM for filesystem cache, because Lucene performance depends on it

The point is not maximizing heap. The point is keeping both the JVM and the page cache healthy at the same time.

### Storage

Storage layout matters more than most first-time builders expect.

The clean pattern is:

- one drive for the OS and runtime surfaces
- one dedicated fast drive for OpenSearch and primary database state
- one separate backup drive for recovery and bulk retention

### Recommended posture

- Put the OpenSearch drive in the fastest CPU-attached NVMe slot
- Keep the OS/runtime drive separate if possible
- Keep backups on a separate physical device
- Do not treat the database drive as an overflow disk

This is not overengineering. It is basic appliance hygiene.

If OpenSearch shares the box, the second fast drive is especially important.

OpenSearch writes:

- translogs
- segments
- merges
- index metadata

Those writes compete badly with OS activity, logs, model assets, and container churn if they all share one drive.

### Capacity guidance

- `2TB OS/runtime NVMe`: comfortable
- `2TB OpenSearch/data NVMe`: strong starting point
- `large HDD for backups`: excellent if you already have one

For Moltbox Prime, the fast `990 PRO` was reserved for OpenSearch and the second NVMe handled OS/runtime duties. That is the right kind of decision.

### OpenSearch Drive Guidance

If you care about "instant-feeling" memory recall, prioritize:

1. dedicated NVMe for OpenSearch
2. lots of system RAM for filesystem cache
3. low shard count and sane refresh settings

The hardware lesson is simple: OpenSearch is usually more sensitive to `NVMe + RAM stability` than to exotic CPU or motherboard choices.

### Small Family-Scale OpenSearch Posture

For a family memory store, the fast and sane default is:

- single node
- low shard count
- one primary shard per index
- no replicas until there is a real operational reason

That keeps search simple, reduces hidden overhead, and makes the most of a single-box Moltbox build.

### Motherboard

Motherboard selection should be boring in the best way.

What actually matters:

- enough RAM capacity and slots
- the right number of NVMe slots
- sensible PCIe lane layout
- stable BIOS support
- networking you trust
- physical fit for the case and cooler

What usually matters less:

- flashy branding
- RGB features
- decorative extras that do not improve reliability

Do not buy a board that forces storage compromises you will regret later.

### Power Supply

The PSU is part of the appliance reliability story.

Practical guidance:

- buy quality before buying excess wattage
- leave thermal and transient headroom
- prefer modern standards that match the GPU generation you are using
- modular cables help in compact builds

The goal is a quiet, stable system that does not become unstable under sustained GPU load.

### Case And Cooling

A Moltbox is allowed to be tangible and desk-friendly.

That does not mean thermals stop mattering.

Priorities:

- real airflow
- radiator and GPU clearance
- acceptable noise
- room for the drives you actually plan to use
- maintenance without frustration

Airflow beats aesthetics. A beautiful box that heat-soaks under continuous load is a bad Moltbox.

### Networking And Appliance Posture

Even the hardware guide should acknowledge the machine's role:

- wired Ethernet is preferred
- the box should behave like an appliance, not a random lab desktop
- backups matter
- recovery posture matters
- remote access should be deliberate, not accidental

This guide does not replace deployment docs, but the hardware should be selected with that appliance posture in mind.

### Model Selection Guidance

For a normal Moltbox, the local model should be chosen for:

- schema reliability
- low first-token latency
- tool-use consistency
- stable routing behavior
- good enough reasoning for arbitration, not maximal reasoning depth

That is why the old docs preferred strong instruct routers over oversized local reasoning stacks.

As a rule:

- use a smaller local model if you want speed, clean routing, and bigger context headroom
- use a medium local model if you want the best balance
- move higher only when you can afford the VRAM, latency, and context tradeoff

Do not confuse "can technically run" with "should be the default local orchestration choice."

### A Note On Terminology

In this guide, the local model discussion is about the orchestration layer.

That is different from the Moltbox control plane.

The local model handles live runs, routing, and bounded prompt compilation through OpenClaw. The Moltbox control plane is the separate Gateway / CLI / tooling surface that manages Moltbox itself.

Judge the local orchestration model by the right metrics:

- tool-schema retry rate
- JSON validity
- routing accuracy
- escalation quality

Those matter more than quoting peak tokens per second alone.

### Spend More Here

- GPU VRAM, if local model size is consistently constraining the box
- system RAM, if OpenSearch and containers are becoming the bottleneck
- storage separation, if you care about retrieval stability and sane recovery
- platform headroom, if you know the machine will grow into heavier multi-user use

### Save Money Here

- do not chase the newest platform if it forces you to cut RAM
- do not overspend on a giant local reasoning GPU if cloud escalation is still acceptable
- do not buy decorative motherboard features instead of real storage and memory capacity

### Recommended Default Build Posture

If you want the short version, this is the most defensible first serious Moltbox posture:

- `12-16+` CPU cores
- `128GB` system RAM if budget allows, `64GB` minimum for a practical solo box
- `16GB VRAM` GPU as the serious floor
- `2 NVMe drives`, with the faster CPU-attached drive reserved for OpenSearch
- `1 backup drive`
- moderate cloud escalation for deep reasoning

That is not the final form of Moltbox. It is the point where the appliance starts feeling real.

### Common Mistakes

- buying for gaming-tier image instead of VRAM and stability
- undersizing RAM because "the model is on the GPU anyway"
- putting OS and database load on one drive when you do not have to
- ignoring NVMe slot layout and lane sharing
- buying a giant local model setup when your actual use case still wants cloud escalation
- treating the machine like a one-process PC instead of a multi-service appliance

### Final Framing

Moltbox should be opinionated enough to be useful.

The opinion is simple:

- build for continuity, not headline specs
- buy enough VRAM to route locally with confidence
- buy enough RAM to keep the database and containers happy
- separate storage roles
- treat the box like an appliance

Everything else is a tradeoff on top of that.
