# Architecture Tactics Reference

> **How to use:** After selecting a style, identify which QAs it *inhibits*. Go to the matching QA section and pick a tactic to compensate. Record the chosen tactic and its cost in your trade-off statement.

---

## Quick Lookup — Style Inhibits → Apply Tactic

| Style inhibits | Go to QA section |
|---|---|
| Availability (e.g. single point of failure) | [Availability](#availability) |
| Performance (e.g. latency, throughput) | [Performance](#performance) |
| Modifiability (e.g. tight coupling, ripple changes) | [Modifiability](#modifiability) |
| Testability / Traceability (e.g. event spaghetti) | [Modifiability → Use Intermediaries](#modifiability) |
| Usability (e.g. user error, cognitive load) | [Usability](#usability) |
| Security (e.g. data exposure, unauthorized access) | [Security](#security) |

---

## Availability

Goal: detect, recover from, and prevent faults.

### Fault Detection

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Heartbeat / Ping-Echo** | Detects dead components via periodic liveness checks | Continuous network + CPU polling overhead |
| **Exception Handling** | Traps runtime errors and restores safe internal state | Scatters error logic, cluttering business code |

### Fault Recovery

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Active-Active (A-A)** | Parallel replicas mask faults with zero downtime | Constant state-sync consumes bandwidth + consensus latency |
| **Active-Passive (A-P)** | Standby takes over when primary fails | Short failover delay + paying for idle standby hardware |
| **Rollback / Retry** | Restores safe state or retries failed operations | Retries multiply latency; risk of "retry storms" |
| **State Re-synchronization** | Restores failed component state from backup | Heavy I/O from large state payloads degrades throughput |

### Fault Prevention

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Transactions** | Grouped DB operations succeed or fail atomically | DB locks limit concurrency and throughput |
| **Process Monitor** | Detects and restarts frozen/dead processes | Host-level monitoring overhead + restart startup delay |
| **Rolling Update / Draining** | Isolates failing components to stop cascading failures | Temporarily shrinks active pool → higher load on remaining nodes |

---

## Performance

Goal: reduce latency or increase throughput.

### Control Resource Demand

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Increase Efficiency / Reduce Overhead** | Faster algorithms reduce processing steps | Optimized low-level code is dense and hard to maintain |
| **Control Sampling / Throttling** | Limits event influx to prevent overload | Drops data resolution; can block legitimate users during spikes |

### Resource Management

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Introduce Concurrency** | Simultaneous processing boosts throughput | Race conditions and deadlocks make testing difficult |
| **Replication / Caching** | Stores data close to consumer, bypasses slow DB queries | Cache invalidation is hard; risk of stale/conflicting data |
| **Autoscaling** | Adds CPU/memory/nodes to handle traffic spikes | Cloud costs scale linearly; requires complex orchestration |

### Resource Arbitration

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Priority Scheduling (QoS)** | Allocates resources to meet mission-critical deadlines | Lower-priority tasks risk starvation under heavy load |

---

## Modifiability

Goal: localize changes, prevent ripple effects, defer binding.

### Localize Changes

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Maintain Semantic Coherence (SRP)** | Groups elements by single responsibility to localize updates | Fine-grained modules (e.g. microservices) add network latency |
| **Generalize Modules** | Interfaces/abstractions make extensions plug-and-play | Indirection slows execution and makes bug tracing harder |
| **Anticipate Expected Changes** | Upfront flexibility for probable business pivots | Over-engineering for features never requested wastes time |

### Prevent Ripple Effects

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Hide Information (Encapsulate)** | Blocks external components from depending on internals | Obscured internals require extensive mocking to unit test |
| **Maintain Existing Interfaces** | Stable/versioned APIs protect downstream consumers | Maintaining multiple legacy API versions increases tech debt |
| **Use Intermediaries (Gateway/Broker)** | Decouples producers from consumers | Extra network hops and serialization add latency |

### Defer Binding Time

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Configuration Files / Env Vars** | Behavior changes at deploy without recompiling | Typos not caught by compiler; risk of runtime crashes |
| **Runtime Registration (Plugin/Service Discovery)** | Dynamic module loading while system is running | Dynamically loaded modules are a major attack vector |

---

## Usability

Goal: reduce user error and cognitive load.

### User Initiative

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Cancel / Undo** | Users recover from mistakes safely | Maintaining command histories complicates the codebase |
| **Pause / Resume** | Long-running tasks pushed to background | Requires serializing and rehydrating partial state across sessions |
| **Preview Before Commit** | Inspection before finalizing prevents user errors | Generating "what-if" state consumes extra CPU and memory |
| **Aggregation (Bulk)** | Bundles repeated tasks into efficient bulk operations | Large synchronous bulk ops can block threads and freeze UI |

### System Initiative

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Guided Workflow (Wizard)** | Constrains task sequence to reduce cognitive load | Hardcoded flows are hard to alter or bypass for expert users |
| **Constrained Input** | Rejects invalid data immediately at UI level | UI rules must stay in sync with backend logic → duplicated code |
| **Autosave** | Persists progress incrementally, prevents data loss | Continuous background writes consume network bandwidth + disk I/O |

### User Feedback

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Immediate Feedback** | Rapid visual response to user actions | Optimistic UI causes jarring rollbacks if server fails |
| **Progress Indicators** | Sets expectations during long operations | Requires WebSocket or polling to stream real-time updates |
| **Validation Messages** | Explains input errors so users can fix them | Detailed error messages can leak system architecture to attackers |

---

## Security

| Tactic | What it solves | Cost |
|--------|---------------|------|
| **Encrypt Data (at rest + in transit)** | Prevents unauthorized access; protects integrity | High CPU for cryptographic math → increased latency |
| **Authenticate Users** | Verifies identity before granting access | Adds user friction; lengthens time to complete basic tasks |
| **Authorize Access (RBAC/ABAC)** | Enforces least-privilege access control | Policy management grows complex as roles/resources scale |
| **Audit Logging** | Creates tamper-evident record of all actions | Storage and I/O overhead; sensitive log data must itself be secured |
| **Centralized Shared Data** | Single source of truth, avoids conflicting states | Central DB becomes bottleneck under load + single point of failure |

---

## Trade-off Statement Template

> "My design using **[Style]** promotes **[QA 1, QA 2]** because **[structural reason]**.  
> It inhibits **[QA 3]** because **[structural reason]**.  
> To mitigate this, I applied **[Tactic]**, which **[mechanism]** at the cost of **[overhead/complexity]**.
