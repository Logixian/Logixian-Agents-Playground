# Architecture Decision Guideline

## Step 1 — Identify Drivers

| Type | Question | Signal Words |
|------|----------|--------------|
| **Functional Requirement (FR)** | What must it *do*? | "shall allow," "users can" |
| **Constraint** | What can we *not* do? | "must use X," "legacy API," "budget cap" |
| **Quality Attribute (QA)** | How *well* must it do it? | "within 2s," "99.9% uptime," "secure" |

> QAs are your most important architectural clues — they force structural decisions.

---

## Step 2 — Prioritize QAs (Utility Tree)

Rank each QA by **(Business Importance × Architectural Difficulty)**. Focus on **High/High** first.

| QA | Business Importance | Arch. Difficulty | Priority |
|----|--------------------|-----------------:|---------|
| e.g. Performance | High | High | **1** |
| e.g. Security | High | Medium | 2 |

Write a **6-part scenario** for each High/High QA:
`Source → Stimulus → Environment → Artifact → Response → Response Measure`

---

## Step 3 — Choose Architectural Style

| If you need… | Use style |
|---|---|
| High throughput / data streaming | **Pipe-and-Filter** |
| Loose coupling / async extensibility | **Event-Based / Pub-Sub** |
| Determinism / strict control flow | **Call-Return / Client-Server** |
| Shared state / data consistency | **Data-Centered / Repository** |

Styles can be combined — one dominant, others applied to subsystems.

---

## Step 4 — Apply Tactics

Tactics plug the gaps your chosen style doesn't cover.

| QA | Tactic examples |
|----|----------------|
| **Availability** | Heartbeat, Active Redundancy, Circuit Breaker |
| **Performance** | Caching, Concurrency, Autoscaling, Connection Pool |
| **Modifiability** | Encapsulate, Defer Binding, Use Intermediary (façade/adapter) |
| **Security** | Authenticate users, Authorize access, Encrypt data, Audit log |

---

## Step 5 — Describe the Structure (C&C View)

Define explicitly:

- **Components** — runtime execution units (services, processes, stores)
- **Connectors** — how they communicate (sync REST, async queue, gRPC, shared DB)
- **Boundaries** — where does the system end, and how is failure contained?

---

## Step 6 — Document the Trade-off

> "My design using **[Style]** promotes **[QA 1, QA 2]** because **[structural reason]**.  
> However, it inhibits **[QA 3]** because **[structural reason]**.  
> To mitigate this, I applied **[Tactic]**, which handles **[mechanism]** at the cost of **[complexity/overhead]**."

---

## Reference Example — Ride-Sharing Dispatch

| Decision | Detail |
|---|---|
| **Style** | Event-Based — rider request → dispatch → notification |
| **Promotes** | Extensibility, loose coupling |
| **Inhibits** | Traceability, control flow visibility |
| **Tactics** | Active Redundancy (dispatch), Location Cache (performance), Encapsulate Pricing (modifiability) |
| **Trade-off** | "Event-based promotes extensibility but makes control flow hard to trace. Active redundancy improves availability at the cost of doubled resources and consistency complexity." |
