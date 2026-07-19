# Requirements

## 1. Functional Requirements

- **System** – The IRALOGIX platform that automatically processes data, applies rules, and runs operations without human input.
- **Employer** – Business owners or HR staff who use the system to comply with state retirement program rules.
- **Compliance Team** – Internal experts who maintain regulatory data, help with complex eligibility decisions, and review compliance results.

### Actor

### 1.1 Jurisdiction Intelligence Engine

| **No** | **Description** |
| --- | --- |
| FR-I01 | The system shall maintain a knowledge database containing regulatory rules. |
| FR-I02 *(updated)* | The system shall ingest jurisdictional requirements on a weekly scheduled basis. |
| FR-I03 | The system shall support different types of jurisdictional requirements. |
| FR-I04 *(updated)* | The system shall trigger regulatory ingestion on a weekly schedule; compliance calculations shall be triggered reactively upon detection of regulatory data updates. |
| FR-I05 | The system shall provide interface to query a knowledge database. |
| FR-I06 *(updated)* | The system shall support an initial scope of 5 states — California, New York, Illinois, New Jersey, and Minnesota — with capability to expand coverage. |
| FR-I07 | The system shall utilize an LLM (via AWS Bedrock, Anthropic models) to parse and extract regulatory data from unstructured sources (PDFs, websites) into a predefined schema. |
| FR-I08 | The system shall require a human expert review and approval step before newly LLM-extracted regulatory rules are published to the knowledge database. |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 | The system shall evaluate employer characteristics against regulatory requirements to determine eligibility in TBD form (1. outcome 2. reason) |
| FR-D02 | The system shall maintain a client data in **TBD** format. |
| FR-D03 | The system shall handle multi-criteria decision logic for complex employer scenarios in eligibility determination. |
| FR-D04 | The system shall log all decision points in the eligibility determination process. |
| FR-D05 | The system shall allow compliance personnel to assist with regulatory determinations. |
| FR-D06 | The system shall expose a push API endpoint to receive anonymized employer profile data from the external IRAlogix system. |
| FR-D07 | The system shall generate a compliance snapshot per employer that includes operational status, action items, time-based components (registration dates, compliance deadlines), and risk exposure. |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 | The system shall calculate compliance deadlines accounting for phase-in schedules in TBD form (1. outcome 2. reason) |
| FR-C02 | The system shall calculate penalties for non-compliance based on jurisdiction-specific rules in TBD from (1. deadline 2. amount 3. ?). |

### 1.4 Automated Onboarding Workflow

| **No** | **Description** |
| --- | --- |
| FR-O01 *(updated)* | The system shall provide a push API endpoint for employer onboarding data ingestion, enabling streamlined employer enrollment via versioned API contracts with IRAlogix. |
| FR-O02 | The system shall enable the platform to extend from account execution to employer engagement workflows. |

### 1.5 Monitoring & Alert System

| **No** | **Description** |
| --- | --- |
| FR-M01 | The system shall track employer compliance status over time. |
| FR-M02 | The system shall send notifications based on compliance status and deadlines. |
| FR-M03 | The system shall generate structured alert payloads and deliver them to IRAlogix via webhook; IRAlogix retains sole responsibility for final user-facing message dispatch (email or UI notification). |

---

## 2. Quality Attributes

### Quality Attribute Refinements

#### Accuracy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| A1 | Rule Extraction Accuracy | PDF rule extraction fields are correct. Rank: (I=H, D=H) |
| A2 | Rule Extraction Recoverability | Extraction failures are safe and recoverable (no bad rules published). Rank: (I=H, D=M) |
| A3 | Rule Representation Consistency | Same rule types share a consistent schema; schema evolves without breaking the engine. Rank: (I=H, D=S) |
| A4 | Eligibility Decision Accuracy | Complex employer profile -> correct eligibility decision plus rule-based rationale. Rank: (I=H, D=M) |
| A5 | Deadline Computation Correctness | Phase-in / effective-date deadline calculations are correct. Rank: (I=H, D=H) |
| A6 | LLM Extraction Schema Fidelity | LLM-parsed regulation output matches the predefined schema with no hallucinated fields; low-confidence extractions trigger the human review gate before publishing. Rank: (I=H, D=M) |

#### Timeliness

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| T1 *(updated)* | Change Detection | Regulatory source updates are detected within a 1-week scheduled ingestion cycle. Rank: (I=M, D=M) |
| T2 | Update Propagation Latency | New rule version becomes usable within **TBD** time after human approval; old version remains available. Rank: (I=H, D=S) |
| T3 | Effective-Date Semantics | Query uses the correct rule version as-of the effective date. Rank: (I=M, D=S) |
| T4 | Incremental Updates | Recompute only affected employers/rules after a change. Rank: (I=M, D=S) |
| T5 *(updated)* | Timely Triggers / Actions | Eligibility/deadline changes trigger downstream actions promptly via the SQS-based reactive pipeline. Rank: (I=H, D=H) |

#### Auditability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| R1 | Decision Provenance | Each decision cites rule IDs/clauses plus key inputs used. Rank: (I=H, D=H) |
| R2 | Reproducibility | Same inputs + same rule version => same outputs (or differences are explainable). Rank: (I=H, D=S) |
| R3 | Audit Logging | Who changed/published what, when, and impact scope is recorded. Rank: (I=M, D=M) |

#### Security & Privacy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| S1 | Authentication & Authorization | All API calls are authenticated; failures are denied and logged. Rank: (I=M, D=S) |
| S2 *(updated)* | PII Protection | PII is minimized, protected, and never leaked via logs; employer data received via push API is anonymized per API contract before storage. Rank: (I=H, D=H) |
| S3 | Encryption (In Transit / At Rest) | Encryption coverage meets baseline requirements; key rotation is feasible. Rank: (I=H, D=S) |
| S4 | Security Monitoring / Incident Traceability | Abnormal access patterns trigger alerts; evidence is retained for investigation. Rank: (I=S, D=H) |

#### Compatibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| C1 | Compatibility with IRALOGIX systems | Scenario: When integrating with IRALOGIX portals/services, the system provides stable, versioned APIs/webhooks so IRAlogix can consume compliance snapshots and alert payloads with minimal coupling.<br>Measure: Backward-compatible API changes; integration test pass rate >= TBD.<br>Ranking: (I: High, D: Medium) |

#### Performance

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| P1 | API Response Time | Compliance query API responds within **TBD** ms under normal operating conditions. Rank: (I=M, D=M) |
| P2 | Ingestion Throughput | Weekly regulatory ingestion pipeline completes within **TBD** time window without blocking concurrent compliance queries. Rank: (I=M, D=S) |

#### Reliability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| Rel1 | Message Queue Fault Tolerance | Failed SQS messages are routed to a Dead Letter Queue (DLQ) for investigation; no silent data loss. Rank: (I=H, D=M) |
| Rel2 | Service Availability | The compliance API remains available under partial infrastructure failures; degraded reads are acceptable over full outage. Rank: (I=M, D=S) |

---

## 3. Constraints

### Technical Constraints

- **Coding Language Constraint:**  
  We cannot use Java. The chosen backend language is **Python** (team authorized to use Python over the originally suggested Go). Synchronous frameworks (e.g., Django) are explicitly rejected; an asynchronous framework is mandatory.

- **Asynchronous API Framework:**  
  The API backend must use an async Python framework. **FastAPI + Uvicorn** is the confirmed selection; **ALB Ingress** is the load balancer.  
  *Rationale:* Brad required async capability to handle concurrent connections at scale; Flask/Django rejected for this reason.

- **Database Technology:**  
  The system must utilize **PostgreSQL 17** with the **Apache AGE graph extension** as the primary data store.  
  *Rationale:* The client is migrating away from Neo4j due to cost and scalability issues; PostgreSQL 17 + AGE provides both relational and graph capabilities at lower cost, supporting the knowledge graph requirements of the Jurisdiction Intelligence Engine.

- **Message Broker:**  
  The system must use **AWS SQS with Dead Letter Queue (DLQ)** as the message broker for all background and asynchronous job processing.  
  *Rationale:* Confirmed at March 11 meeting; DLQ ensures fault-tolerant processing without silent data loss.

- **Infrastructure & Deployment:**  
  The solution must be deployable on **Docker + Kubernetes (AWS EKS)**, using **GitHub Actions** for CI/CD and **ALB Ingress** for traffic management.

- **AI / LLM Integration:**  
  LLM capabilities must leverage **AWS Bedrock**; Anthropic models (e.g., Opus) are recommended for the POC.  
  *Rationale:* Brad confirmed IRALOGIX's AWS Bedrock access and recommended it for document parsing.

- **Integration Interface:**  
  The system must integrate with IRAlogix exclusively via: (a) **push APIs** for receiving anonymized employer data, and (b) **webhooks** for delivering compliance results and alert payloads. Direct database access from IRAlogix into Logixian's database is prohibited.  
  *Rationale:* Decoupled "black box" domain design ensures each system owns its data model and maintains independent evolvability.

- **Regulatory Validity (Temporal):**  
  The data model must support temporal versioning (effective dates) to track changes in legislation over time.  
  *Rationale:* Laws change. The system cannot store only the "current" state; it must handle history for auditability.

- **Business Rules Engine (Open — Blocking):**  
  The decision to build a custom BRE vs. adopt an existing solution (OPA, Drools, etc.) vs. use the IRALOGIX internal BRE is still **open and blocking** finalization of the architecture blueprint.  
  *Resolution requires:* domain knowledge transfer from Brad and access to sample data.

### Business Constraints

- **Schedule (Time-to-Market):**  
  The whole project should be completed by the end of 2026.

- **Resource Cap:**  
  The development effort is strictly limited to 60 person-hours per week (5 members × 12 hours).  
  *Rationale:* Course requirement. This constrains the volume of features we can deliver in a sprint.

- **Cost Sensitivity:**  
  The architecture must optimize for operational costs, favoring efficient relational models over expensive in-memory graph solutions.  
  *Rationale:* Explicit client feedback regarding the high cost of the previous Neo4j implementation.

- **Legal Constraint (Business):**  
  The system processes sensitive information and must comply with applicable data protection regulations (e.g., GDPR). This affects the entire pipeline design: logs, databases, and API payloads must minimize PII exposure.

- **POC Scope:**  
  The initial proof-of-concept targets **5 states**: California (CalSavers), New York (Secure Choice), Illinois (Secure Choice), New Jersey (RetireReady NJ), and Minnesota (Secure Choice Retirement Program). Expansion to remaining states follows POC validation.

---

## Changelog (v1 → v2)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| FR-I02 *(updated)*: ingestion now explicitly weekly scheduled | 1.1 | `client-meeting/2026-02-18/Client Meeting.md` | Brad confirmed weekly scheduled ingestion during architecture review |
| FR-I04 *(updated)*: trigger is weekly for ingestion, reactive for calculations | 1.1 | `client-meeting/2026-02-18/Client Meeting.md` | Two-phase pipeline agreed: weekly batch ingestion + reactive compliance calculations |
| FR-I06 *(updated)*: 5 states named explicitly (CA, NY, IL, NJ, MN) | 1.1 | `client-meeting/2026-03-11/client-decision-before-update.md`; `client-meeting/2026-02-18/Top_5_State-Mandated_Retirement_Program_Markets.md` | POC scope locked to specific 5 states at March 11 meeting (item 1.9) |
| FR-I07 *(new)*: LLM-based regulatory parsing via AWS Bedrock | 1.1 | `client-meeting/2026-03-11/Client Meeting.md` | Brad confirmed Bedrock access and recommended Anthropic model for PDF/website parsing |
| FR-I08 *(new)*: human expert review gate before publishing extracted rules | 1.1 | `client-meeting/2026-03-11/Client Meeting.md` | Data pipeline includes human approval step after LLM extraction before rules go live |
| FR-D06 *(new)*: push API endpoint for anonymized employer data | 1.2 | `client-meeting/2026-02-18/Client Meeting.md` | Brad specified employer data exchanged via push API; no direct DB access permitted |
| FR-D07 *(new)*: compliance snapshot structure (status, action items, deadlines, risk) | 1.2 | `client-meeting/2026-03-11/Client Meeting.md` | Brad reviewed and approved compliance snapshot structure at March 11 meeting |
| FR-O01 *(updated)*: clarified as push API with versioned contracts for onboarding | 1.4 | `client-meeting/2026-02-18/Client Meeting.md` | Brad confirmed API contracts as the integration mechanism for employer onboarding |
| FR-M03 *(new)*: Logixian generates payloads; IRAlogix dispatches to users | 1.5 | `client-meeting/2026-02-18/Client Meeting.md` | Alerting protocol split decided for brand consistency; IRAlogix owns email/UI delivery |
| A6 *(new)*: LLM extraction schema fidelity scenario added | 2 — Accuracy | `client-meeting/2026-03-11/Client Meeting.md` | New LLM pipeline introduces risk of hallucinated/incorrect field extractions |
| T1 *(updated)*: change detection cycle now explicitly 1-week | 2 — Timeliness | `client-meeting/2026-02-18/Client Meeting.md` | Weekly ingestion schedule confirmed by Brad |
| T5 *(updated)*: SQS-based reactive pipeline noted | 2 — Timeliness | `client-meeting/2026-03-11/client-decision-before-update.md` | SQS confirmed as message broker at March 11 meeting |
| S2 *(updated)*: anonymized employer data per push API contract noted | 2 — Security & Privacy | `client-meeting/2026-02-18/Client Meeting.md` | Employer data anonymized by IRAlogix before being pushed to Logixian |
| Performance category added (P1, P2) | 2 | `client-meeting/2026-03-11/client-decision-before-update.md` | Non-functional requirement draft lists performance as a required category |
| Reliability category added (Rel1, Rel2) | 2 | `client-meeting/2026-03-11/client-decision-before-update.md` | Non-functional requirements draft includes reliability; SQS DLQ confirmed |
| Coding language constraint updated: Python confirmed, Django rejected | 3 — Technical | `client-meeting/2026-02-18/Client Meeting.md` | Team authorized to use Python + async framework; synchronous frameworks rejected |
| Async framework constraint added: FastAPI + Uvicorn + ALB mandatory | 3 — Technical | `client-meeting/2026-02-18/Client Meeting.md`; `client-meeting/2026-03-11/client-decision-before-update.md` | FastAPI selected at Feb 18; confirmed with Uvicorn + ALB at March 11 |
| Database constraint updated: PostgreSQL 17 + Apache AGE extension | 3 — Technical | `client-meeting/2026-03-11/client-decision-before-update.md` | Apache AGE selected for graph capabilities alongside relational PostgreSQL |
| Message broker constraint added: AWS SQS with DLQ | 3 — Technical | `client-meeting/2026-03-11/client-decision-before-update.md` | SQS with DLQ confirmed for background jobs at March 11 meeting |
| Infrastructure constraint updated: Docker + K8s (EKS), GitHub Actions, ALB | 3 — Technical | `client-meeting/2026-03-11/client-decision-before-update.md` | Full deployment stack confirmed at March 11 meeting |
| AI/LLM constraint added: AWS Bedrock with Anthropic models | 3 — Technical | `client-meeting/2026-03-11/Client Meeting.md` | Brad confirmed Bedrock access and recommended it for document processing POC |
| Integration constraint updated: push APIs + webhooks only, no direct DB access | 3 — Technical | `client-meeting/2026-02-18/Client Meeting.md` | Decoupled black-box domain design confirmed at February 18 meeting |
| BRE decision noted as open/blocking constraint | 3 — Technical | `client-meeting/2026-03-11/client-decision-before-update.md` | Item 1.4 is blocking architecture blueprint finalization; requires domain transfer from Brad |
| POC scope constraint added: 5 specific states named | 3 — Business | `client-meeting/2026-03-11/client-decision-before-update.md` | Item 1.9 locked at March 11 meeting |

> [HUMAN REVIEW REQUIRED] — Review changelog before merging this version.
