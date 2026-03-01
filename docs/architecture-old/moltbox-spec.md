# Moltbox Spec

Moltbox is the local hardware appliance and deployment environment for Remram.

Its purpose is to make your AI stack **sovereign by default** by keeping memory, retrieval, and routing local.

Moltbox separates **control** (local) from **cognition** (optional cloud or optional local acceleration).

---

## 1\. Goals

*   Local ownership of memory (facts, artifacts, indices)
*   Deterministic orchestration and retrieval latency
*   Token-efficient escalation to cloud cognition
*   Reliable always-on routing model
*   Voice-first input support (STT pipeline)
*   Stable OpenSearch performance
*   Simple, reproducible deployment
*   Secure remote access for family devices

---

## 2\. Full Software Stack (What Runs on Moltbox)

Moltbox hosts the full Remram runtime stack:

### 2.1 Core Runtime Surfaces

*   `openclaw gateway` - orchestration runtime and control plane
*   `remram memory slot plugin` - RAM retrieval surface (`memory_search` / `memory_get`)
*   `remram encode hooks and automation` - REM baseline encode + Dream Machine consolidation

### 2.2 Orchestration Runtime

*   **OpenClaw** (installed as a first-class dependency)
    *   core runtime
    *   schema/tool calling
    *   validation + retries
    *   escalation policy hooks

### 2.3 Memory Substrate

*   **OpenSearch** (local)
    *   indices for facts / artifacts metadata / chunks / embeddings / rank features
    *   plugins required for vector and hybrid retrieval (installed and pinned)
    *   dashboards optional (useful early; not required for headless appliance)

### 2.4 Artifact Store + Versioning

*   **Artifact file store** on local disk (canonical source of truth)
*   **Local Git repository** for artifact versioning
    *   versioned docs/specs/configs
    *   patch-based updates from REM (never blind overwrite)
    *   optional: scheduled snapshots/tags aligned to Dream Machine runs

### 2.5 Local Models

*   **Router model runtime** (local)
*   **Embedding model runtime** (local or hybrid)

### 2.6 Voice / Transcription

*   **Voice-to-text (STT) model** for a transcription agent
    *   runs locally when possible
    *   produces timestamped transcripts as artifacts
    *   feeds Baseline Encode (stage facts + chunk updates)

### 2.7 Cloud Cognition Connectors (Stateless)

*   API connectors for specialized models (reasoning, coding, image, etc.)
*   cost tracking + escalation logs

---

## 3\. Local Model Usage (Router Targets)

The local model is not intended for deep reasoning.

It is optimized for:

*   intent classification
*   context selection and budgeting
*   tool selection
*   strict schema output
*   short bounded reasoning loops

### 3.1 Router Model Characteristics

Preferred characteristics:

*   strong tool-use / function-calling behavior
*   high instruction following
*   low-latency on 16GB VRAM
*   stable JSON/schema compliance

### 3.2 Embeddings Model Characteristics

*   fast
*   consistent
*   supports batch refresh during Dream Machine

(Exact model picks can be pinned in `moltbox/models/` as the project converges.)

---

## 4\. Hardware Options (Appliance → Sweet Spot → Pro)

Moltbox is designed to be deployable across tiers.

### 4.1 Appliance-Class Options (Optional / Not Pursued Yet)

These are viable as runtimes improve and model efficiency increases.

Examples:

*   **Mac mini (high unified memory)**
*   **“AI appliance” class PCs** with large system RAM

Expected characteristics:

*   good for **1–2 users**
*   generally quieter / simpler
*   may feel **slower** under concurrent load
*   tends to escalate more due to smaller local routing headroom

Use case: household assistant + light orchestration + light retrieval.

---

### 4.2 Baseline Moltbox (Current Target / Sweet Spot)

A practical always-on baseline for routing + memory:

*   **GPU:** RTX 5060 Ti (16GB VRAM) or equivalent
*   **System RAM:** 64GB recommended (128GB ideal)
*   **CPU:** 12–16 cores preferred
*   **Storage:** dedicated NVMe for OpenSearch + separate NVMe for OS/artifacts recommended

Expected characteristics:

*   good for **2–4 users**
*   feels **snappy** for routing + retrieval
*   uses **moderate cloud escalation** for deep reasoning

This tier is sized for orchestration and memory, not large local cognition.

---

### 4.3 Pro Moltbox (Higher Concurrency / Lower Escalation)

For larger households, heavier workloads, or reduced cloud dependence:

*   **GPU:** higher VRAM / higher throughput tier (e.g., 24GB+)
*   **System RAM:** 128GB+
*   **CPU:** modern high-core platform
*   **Storage:** separated NVMe lanes; stronger I/O sustain

Examples (illustrative):

*   high VRAM consumer GPU tier (e.g., 3090-class and above)
*   workstation-tier GPUs
*   AM5 platform build with stronger CPU + DDR5 bandwidth

Expected characteristics:

*   supports **more concurrent users**
*   maintains speed under load
*   can run a **stronger router model**
*   reduces escalation frequency

---

## 5\. Optional Local Cognition Layer

Local cognition acceleration is an **optional** layer.

### 5.1 DGX Spark (Recommended Optional Path)

DGX Spark (or an equivalent local accelerator tier) can reduce cloud token spend **if and when**:

*   usage volume is high
*   deep reasoning is frequent
*   payback beats token economics

Current assumption:

*   cloud tokens remain cheaper for now
*   builder’s choice based on use pattern and budget

---

## 6\. Network and Security (Appliance Reality)

Moltbox should be treated like a network appliance.

Minimum expectations:

*   host firewall configured (deny-by-default inbound)
*   services bound to LAN/VPN only
*   TLS for any web interfaces
*   secrets management (env/keystore, not committed)

### 6.1 Remote Access

*   VPN access for phones and remote devices
*   no open public ports required
*   optional split-tunnel policy

### 6.2 Multi-User Separation

*   per-user scopes enforced at the memory policy layer
*   separate credentials/tokens per user where applicable

---

## 7\. Storage Layout

Moltbox separates:

*   **OpenSearch data path** (indices, translog, segments)
*   **Artifact store** (canonical files)
*   **Local Git repo** (artifact version history)
*   **OS/containers/logs**

OpenSearch stores pointers.  
Disk stores canonical sources.  
Git preserves history.

---

## 8\. Deployment Model

Moltbox is deployed as a containerized stack.

Repository contents typically include:

*   `docker/` (compose + service definitions)
*   `install/` (bootstrap scripts)
*   `opensearch/` (config + tuning notes + plugins)
*   `models/` (router + embeddings runtime config)
*   `voice/` (STT runtime config)
*   `artifacts/` (directory conventions)
*   `security/` (firewall/VPN notes + hardening checklist)
*   `hardware/` (recommended builds + stability notes)

---

## 9\. Observability

Moltbox should expose:

*   OpenSearch health and query latency
*   GPU memory utilization
*   router model latency
*   encode/consolidation throughput
*   embedding refresh batches
*   disk I/O saturation
*   VPN/auth logs

---

## 10\. Invariants

*   Moltbox owns state; cloud cognition does not
*   Memory remains local by default
*   Router model prioritizes determinism over deep thinking
*   RAM never mutates memory
*   REM never serves live queries
*   OpenSearch is tuned for low-latency retrieval and high cache hit rates

---

## 11\. Next Steps

*   Pin router + embeddings model targets (initial baseline)
*   Define OpenSearch plugin set + index templates
*   Lock a minimal docker-compose stack
*   Define artifact store + git repo conventions
*   Define VPN + firewall baseline configuration

Moltbox is the appliance that makes Remram real.
