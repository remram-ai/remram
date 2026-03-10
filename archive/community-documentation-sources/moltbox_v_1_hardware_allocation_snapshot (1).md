# Moltbox v1 — tight hardware + allocation snapshot

## 1) Hardware bill (current known parts)

| Component             | Model / key specs                                                              | Price            | Notes                                        |
| --------------------- | ------------------------------------------------------------------------------ | ---------------- | -------------------------------------------- |
| **CPU**               | **AMD Ryzen 9 5900XT** — 16C/32T, 105W                                         | **\$311.00**     | AM4 Zen 3, strong mixed workload CPU.        |
| **Motherboard**       | **Gigabyte B550M AORUS ELITE AX (rev 1.3)** — mATX, PCIe 4.0, Wi‑Fi            | **\$119.99**     | B550 mATX platform.                          |
| **RAM**               | **G.Skill Trident Z Neo 128GB** — 4×32GB DDR4‑3200 CL16 (F4‑3200C16Q2‑128GTZN) | **\$544.92**     | 4‑DIMM config; check board QVL + BIOS.       |
| **GPU**               | **ASUS Dual RTX 5060 Ti 16GB GDDR7 OC**                                        | **\$579.99**     | 16GB VRAM, primary local model + embeddings. |
| **NVMe (OS/Apps)**    | **Crucial P310 2TB** — PCIe 4.0 x4 (w/ heatsink)                               | **\$264.99**     | Fast general NVMe.                           |
| **NVMe (OpenSearch)** | **Samsung 990 Pro 2TB** — PCIe 4.0 x4                                          | **\$399.99**     | Dedicated index / segment I/O.               |
| **Case**              | **Gamdias ATHENA M4M** — mATX, airflow, includes fans                          | **\$79.99**      | Airflow SFF.                                 |
| **CPU cooler**        | 240mm AIO (bundle shown)                                                       | **\$0 (bundle)** | Treat as included.                           |
| **PSU**               | **Thermaltake GF1 850W Gold**                                                  | **\$89.95**      | Headroom for spikes + future GPU.            |

### Total cost&#x20;

**\$2,390.81**

---

## 2) Resource allocation&#x20;

### GPU (RTX 5060 Ti 16GB)

Primary jobs:

- **Local orchestrator/router model** (8–14B class; Qwen3‑8B recommended)
- **Embeddings model** (small + stable) if you want it on‑GPU
- Optional: **light SDXL / image jobs** (only when it doesn’t disrupt orchestration latency)

Practical VRAM partition (targeting reliability over max size):

- **8–10GB**: Orchestrator model + KV cache headroom
- **1–2GB**: Embeddings model (if GPU‑resident)
- **2–4GB**: Safety margin / spikes / concurrent sessions

### CPU (Ryzen 9 5900XT, 16C/32T)

Primary jobs:

- **OpenSearch** (indexing, query execution, merges)
- **OpenClaw runtime** (routing, validation, tool execution)
- **Background memory compaction** (diffing, re‑chunking, batch embedding jobs when scheduled)

Core allocation (starting point):

- **OpenSearch**: 6–10 cores available (burstable)
- **OpenClaw + system services**: 2–4 cores
- **Headroom**: remaining cores for ingestion, file ops, compression, and spikes

### RAM (128GB DDR4)

Goal: keep OpenSearch fast by keeping hot data in memory and leaving OS page cache large.

Starting allocation (tune after observing heap + cache hit rate):

- **OpenSearch JVM heap**: **24–32GB**
- **OpenSearch off‑heap + native**: **8–16GB**
- **OS page cache (NVMe-backed)**: **48–72GB** (this is where performance “feels” fast)
- **Models / runtimes / containers**: **8–16GB**
- **Buffers / ingestion / safety headroom**: **8–16GB**

Rule of thumb for OpenSearch: **don’t oversize heap**; you want cache. Heap too big can hurt due to GC.

### Storage (2× NVMe)

- **Crucial P310 2TB**: OS, apps, Docker images, logs, artifact store (files)
- **Samsung 990 Pro 2TB**: OpenSearch data path (indices, translog)

---

## 3) Estimated throughput + capability envelope (tight)

### Local orchestration (GPU)

- **Orchestrator model (8B, quantized Q4/Q5)**: *fast enough for “always-on” routing + JSON tool discipline*.
- Expected usage: multi-user family queries, tool routing, retrieval bundle assembly, escalation decisions.

### Retrieval (CPU + RAM + NVMe)

- OpenSearch should feel **snappy** for hybrid retrieval (filters + BM25 + vector + rank features) as long as:
  - heap is sane (24–32GB),
  - OS cache stays large,
  - you avoid pathological shard counts.

### What this box is “great at”

- Deterministic control-plane behaviors: routing, tool execution, retrieval, memory promotion.
- High concurrency for retrieval + orchestration.
- Keeping your memory substrate local and fast.

### What this box is **not** trying to do

- Large local “thinking” models (32B+), long-horizon synthesis, or heavy multi-agent cognition.
- That stays API-tier by design.

---

## 4) Punchline configuration checklist (to lock stability)

- BIOS updated (AM4 + 16-core + 4-DIMM stability)
- RAM set to **XMP/DOCP 3200** (don’t chase unstable OC)
- OpenSearch:
  - heap **24–32GB**
  - data path on 990 Pro
  - conservative shard strategy
- Router model:
  - thinking disabled
  - strict JSON schema enforcement + bounded retries

