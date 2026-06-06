# Architectural Style Reference

## Style Families — Mental Model

| Family | Coupling | Coordination |
|--------|----------|--------------|
| **Dataflow** | Data format (outputs must match inputs) | Data availability — runs when data arrives |
| **Call-Return** | Interface / signature (caller knows the callee) | Explicit control — caller blocks and waits |
| **Event-Based** | Event schema (publishers don't know subscribers) | Event triggers — async, non-deterministic |
| **Data-Centered** | Shared data schema (all depend on the DB model) | State changes — components react to data updates |

---

## Dataflow Styles

### Batch Sequential

**Use when:** each stage must fully complete before the next begins; simplicity matters more than speed.

| Promotes | Inhibits |
|----------|---------|
| Simplicity — uniform, predictable computation | Performance — high latency (no output until all input consumed) |
| Reuse — filters are independent (like `grep`) | Interactivity — poor for real-time use |
| Modifiability — easy to swap stages | Concurrency — none by design |

### Pipe-and-Filter *(preferred for streaming)*

**Use when:** data flows continuously and parallel processing is valuable.

| Promotes | Inhibits |
|----------|---------|
| Low latency — incremental processing | Inefficiency — repeated encode/decode between filters |
| Concurrency — filters run in parallel | Error handling — hard to propagate errors backward |
| Modifiability — swap/add filters freely | Statefulness — filters must remain stateless |

> **Trade-off:** Pipe-and-Filter promotes Modifiability and Low Latency via concurrent filter processing. It inhibits Reliability because unidirectional flow blocks backward error propagation. Mitigation: **Process Monitor** (auto-restart crashed filters) at the cost of monitoring overhead.

---

## Event-Based Styles

### Pure Event System (Pub-Sub)

**Use when:** producers and consumers must be fully decoupled; throughput and extensibility are top priorities.

| Promotes | Inhibits |
|----------|---------|
| Extensibility — add subscribers without touching publishers | Non-determinism — no control over delivery order |
| Dynamic reconfiguration — components aren't hardwired | Testability — unpredictable ordering is hard to reproduce |
| Parallelism — events handled concurrently | Event spaghetti — complex chains are hard to trace |

### Implicit Invocation (Callback)

**Use when:** loose coupling within a single process (UI handlers, plugin hooks).

| Promotes | Inhibits |
|----------|---------|
| Loose coupling — publisher doesn't know listeners | Real-time guarantees — timing is uncontrollable |
| Maintainability — add listeners without changing source | Error handling — failures in callbacks can be silently swallowed |

> **Trade-off:** Event-Based promotes Extensibility and Throughput via full producer-consumer decoupling. It inhibits Testability due to non-deterministic flows. Mitigation: **Distributed Audit Logging with correlation IDs** at the cost of storage and I/O overhead.

---

## Call-Return Styles

### Client-Server

**Use when:** clear UI/logic separation is needed; server-side scaling is a priority.

| Promotes | Inhibits |
|----------|---------|
| Modifiability — change server logic without touching clients | Availability — centralized server = single point of failure |
| Scalability — scale server replicas or split into N tiers | Coupling — client must know server location/interface |
| Separation of concerns — UI vs. business logic | |

### Service-Oriented Architecture (SOA)

**Use when:** integrating heterogeneous or legacy systems via a shared bus.

| Promotes | Inhibits |
|----------|---------|
| Interoperability — services expose standard contracts | Complexity — managing ESB and service registry |
| Loose coupling — late binding via registry | Performance — multiple indirection layers add latency |
| Legacy integration — wraps older systems cleanly | |

### Peer-to-Peer

**Use when:** no central authority is acceptable; availability and horizontal scale are critical.

| Promotes | Inhibits |
|----------|---------|
| Availability — no single point of failure | Distributed control — global state is hard to reason about |
| Scalability — capacity grows as peers join | Trust & security — no central authority to verify behavior |

> **Trade-off:** Client-Server promotes Scalability and Modifiability by separating UI from business logic. It inhibits Availability due to a centralized server. Mitigation: **Active Redundancy** (multiple instances behind a load balancer) at the cost of doubled compute and state-sync complexity.

---

## Decision Cheat Sheet

| Primary need | Recommended style |
|---|---|
| Stream processing / parallel transforms | Pipe-and-Filter |
| Full producer-consumer decoupling / high throughput | Event-Based (Pub-Sub) |
| Strict control flow / synchronous request-response | Client-Server |
| Shared state / transactional data | Data-Centered / Repository |
| Legacy system integration | SOA |
| No central authority / distributed resilience | Peer-to-Peer |

> Styles can be combined — pick one dominant style and apply others to subsystems where their trade-offs are acceptable.
