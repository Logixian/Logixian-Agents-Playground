# CMU Studio 2026 – Decisions & Open Items for Today's Call

| # | Item | Status | Detail |
|---|------|--------|--------|
| 1.3 | Storage tier | **Decided** | PostgreSQL 17 + Apache AGE graph extension |
| 1.6 | Background jobs | **Decided** | Async, webhooks-based. SQS as message broker with DLQ |
| 1.7 | Tech stack | **Decided** | Python + FastAPI + Uvicorn, ALB Ingress, Docker/K8s, GitHub Actions. (Team proposed Python over original Go suggestion) |
| 1.9 | POC scope | **Decided** | 5 states: California, New York, Illinois, New Jersey, Minnesota |
| 1.5 | API framework | **Provisional** | FastAPI + Uvicorn + ALB. API surface design (endpoints/queries) still open pending BRE decision |
| 1.1 | Functional requirements | **Drafted** | 18 requirements across 5 components – needs team review |
| 1.2 | Non-functional requirements | **Drafted** | 6 categories (auditability, temporal integrity, source fidelity, performance, reliability, security) – needs team review |
| 1.11 | Architecture blueprint | **Drafted** | Mermaid diagram published to Confluence – blocked on BRE to finalize |
| **1.4** | **Business rules engine** | **Open – blocking** | Build custom vs adopt existing (OPA, Drools, etc.) vs use IRALOGIX BRE. Needs domain knowledge transfer + sample data to decide |
| **1.8** | **Budget estimation** | **Open** | K8s cluster, RDS/PostgreSQL hosting, SQS, GitHub Actions minutes |
| 1.10 | Sprint-level timeframe | **Deferred** | Semester-level timeline in place; sprint breakdown deferred |

---

**Links:**
- Requirements: `CMUST26 > Designs > V1 > Requirements`
- Architecture Blueprint: `CMUST26 > Designs > V1 > Architecture Blueprint`
- Milestones tracker: `CMUST26 > Project > Milestones`
