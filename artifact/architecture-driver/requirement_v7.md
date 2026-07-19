# Requirements

## 1. Functional Requirements

- **System** – The IRALOGIX platform that automatically processes data, applies rules, and runs operations without human input.
- **Employer** – Business owners or HR staff who use the system to comply with state retirement program rules.
- **Compliance Team** – Internal experts who maintain regulatory data, help with complex eligibility decisions, and review compliance results.

### 1.1 Jurisdiction Intelligence Engine

| **No** | **Description** |
| --- | --- |
| FR-I01 | The system shall maintain a knowledge database containing regulatory rules. |
| FR-I02 | The system shall periodically ingest regulatory data from jurisdictional sources. |
| FR-I03 | The system shall support ingestion from both unstructured and structured regulatory sources, including state program websites (e.g., CalSavers FAQ pages). |
| FR-I05 | The system shall provide an interface to query the knowledge database, supporting point-in-time evaluation. |
| FR-I06 | The system shall support an initial scope of 5 states with capability to expand coverage. |
| FR-I08 | The system shall require human expert review before publishing extracted regulatory rules. |
| FR-I09 | The system shall detect changes in regulatory rules and emit events to downstream services. |
| FR-I10 | The system shall track rule versioning with effective dates and historical change lineage. |
| FR-I11 | The system shall preserve raw regulatory source material with extraction provenance metadata. |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 | The system shall evaluate employer eligibility per jurisdiction using configurable rule criteria, producing eligibility status, action items, and rule-based rationale. |
| FR-D02 *(updated)* | The system shall maintain client data capturing employer identity, operating jurisdictions, operational status, and timestamps for compliance-relevant actions (registration date, roster upload date, payroll deduction date). Financial transaction data is excluded. |
| FR-D07 | The system shall generate a compliance snapshot per employer with per-state evaluation results and traceability metadata. |
| FR-D10 | The system shall determine whether an employer must enroll in a state-run retirement program or may offer a qualified private-plan alternative. |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 | The system shall compute registration deadlines based on employer size and the jurisdiction's phase-in schedule. |
| FR-C02 | The system shall calculate penalty exposure for non-compliant employers, including penalty amount, escalation tier, and enforcement timeline. |
| FR-C03 | The system shall support rolling, future-dated, and phased deadlines for newly eligible employers. |

### 1.4 Automated Onboarding Workflow

| **No** | **Description** |
| --- | --- |
| FR-O01 | The system shall provide an API endpoint for employer data ingestion covering compliance profile submissions and onboarding enrollment. |

### 1.5 Monitoring & Alert System

| **No** | **Description** |
| --- | --- |
| FR-M01 | The system shall track compliance status across all enrolled employers. |
| FR-M02 | The system shall send notifications on a graduated schedule aligned to penalty escalation timelines. |
| FR-M03 | The system shall generate structured alert payloads for delivery to IRAlogix; IRAlogix retains responsibility for final user-facing dispatch. |

---

## 2. Quality Attributes

### Accuracy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| A1 | Rule Extraction Accuracy | Rule extraction fields are correct. Rank: (I=H, D=H) |
| A2 | Rule Extraction Recoverability | Extraction failures are safe and recoverable; no bad rules published. Rank: (I=H, D=M) |
| A3 | Rule Representation Consistency | Same rule types share a consistent schema; schema evolves without breaking the engine. Rank: (I=H, D=S) |
| A4 | Eligibility Decision Accuracy | Complex employer profile yields correct eligibility decision with rule-based rationale. Rank: (I=H, D=M) |
| A5 | Deadline Computation Correctness | Phase-in and effective-date deadline calculations are correct. Rank: (I=H, D=H) |
| A6 | LLM Extraction Schema Fidelity | LLM-parsed output matches the predefined rule model schema with no hallucinated fields; low-confidence extractions trigger human review before publishing. Rank: (I=H, D=M) |

### Timeliness

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| T1 | Change Detection | Regulatory source updates are detected within the scheduled ingestion cycle. Rank: (I=M, D=M) |
| T2 | Update Propagation Latency | New rule version becomes usable within **TBD** time after human approval; old version remains available. Rank: (I=H, D=S) |
| T3 | Effective-Date Semantics | Query uses the correct rule version as-of the effective date. Rank: (I=M, D=S) |
| T5 | Timely Triggers / Actions | Eligibility and deadline changes trigger downstream actions promptly. Rank: (I=H, D=H) |

### Auditability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| R1 | Decision Provenance | Each compliance evaluation cites the rule version used and the reasoning for each decision, preserving traceability from snapshot to approved rule. Rank: (I=H, D=H) |
| R2 | Reproducibility | Same input snapshot and rule version produce the same result; differences are explainable. Rank: (I=H, D=S) |
| R3 | Audit Logging | Audit trail is queryable by employer, jurisdiction, and time range; records who changed what and when. Rank: (I=M, D=M) |
| R4 | Calculation Storage | All calculations must be stored with full input snapshot, rule version used, and evaluation timestamp. Rank: (I=H, D=H) |

### Security & Privacy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| S1 | Authentication & Authorization | All API calls are authenticated; failures are denied and logged. Rank: (I=M, D=S) |
| S2 | PII Protection | PII is minimized, protected, and never leaked via logs; employer data is anonymized before storage. Rank: (I=H, D=H) |
| S3 | Encryption (In Transit / At Rest) | Encryption coverage meets baseline requirements; key rotation is feasible. Rank: (I=H, D=S) |
| S4 | Security Monitoring / Incident Traceability | Abnormal access patterns trigger alerts; evidence is retained for investigation. Rank: (I=S, D=H) |

### Compatibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| C1 | Compatibility with IRALOGIX systems | The system provides stable, versioned APIs so IRAlogix can consume compliance data with minimal coupling. Rank: (I=H, D=M) |

### Performance

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| P2 | Ingestion Throughput | Regulatory ingestion completes within **TBD** time window without blocking concurrent queries. Rank: (I=M, D=S) |
| P3 | Sync API Response Time | Single-employer eligibility check completes within 500ms. Rank: (I=M, D=M) |
| P4 | Async Batch Re-evaluation | Full client base re-evaluation triggered by a rule change completes within **TBD** time. Rank: (I=M, D=S) |

### Reliability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| Rel1 | Message Queue Fault Tolerance | Failed messages are routed to a dead letter queue for investigation; no silent data loss. Rank: (I=H, D=M) |
| Rel2 | Service Availability | Compliance API remains available under partial failures; degraded reads acceptable over full outage. Rank: (I=M, D=S) |
| Rel3 | ETL Integrity | Pipeline failures must not corrupt existing rules; failed runs are rolled back or isolated. Rank: (I=H, D=H) |

### Extensibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| E1 | State Coverage Scalability | Scale from 5-state POC to 20+ states without architectural changes; new jurisdictions onboarded via data configuration. Rank: (I=H, D=M) |

### Utility Tree (Priority)

| Rank | QA | Business Importance | Architectural Difficulty | Driver Score |
|------|-----|--------------------|-----------------------------|--------------|
| 1 | Accuracy (Rule Extraction + Schema Fidelity) | H | H | HH |
| 2 | Auditability (Decision Provenance + Calculation Storage) | H | H | HH |
| 3 | Reliability (ETL Integrity) | H | H | HH |
| 4 | Timeliness (Timely Triggers + Propagation Latency) | H | H | HH |
| 5 | Security (PII Protection) | H | H | HH |
| 6 | Extensibility (State Coverage Scalability) | H | M | HM |
| 7 | Compatibility (IRALOGIX API Stability) | H | M | HM |
| 8 | Performance (Sync Response + Batch Re-evaluation) | M | S | MS |

### Key Architecture Tradeoff

**Accuracy vs Timeliness:** The human expert review gate (FR-I08) is the primary mechanism for ensuring rule extraction accuracy (A1, A6) — no rule is published without compliance team approval. This gate deliberately slows update propagation latency (T2): a new regulatory rule detected today may not become available to the eligibility engine for days until a human reviews and approves it. The architecture favors accuracy over speed because publishing a wrong rule could cause systemic mis-compliance across all enrolled employers. Mitigation: the existing rule version remains fully available while new versions await approval, so the system remains functional and consistent throughout the review window.

---

## 3. Constraints

### Technical Constraints

- **Backend Language:**
  Python with an asynchronous framework (**FastAPI + Uvicorn**). Java and synchronous frameworks (Django, Flask) are rejected.
  *Rationale:* Async capability required for concurrent connections at scale.

- **Database Technology:**
  **PostgreSQL 17** as the primary data store. The **Apache AGE graph extension** is available in the stack but is **advisory** — the team will adopt it only if graph traversal is required after the relational data model is finalized.
  *Rationale:* Migrating from Neo4j due to cost; a relational model may fully satisfy the data structure; AGE remains available as an option.

- **Data Model Column Design:**
  Once the data model is stabilized, minimize JSON/semi-structured columns; prefer typed relational columns to support indexing and maintain schema clarity.
  *Rationale:* JSON columns are difficult to index and obscure schema evolution; explicit typed columns improve query performance and team-wide comprehension as the system grows.

- **Message Broker:**
  **AWS SQS** with Dead Letter Queue (DLQ) for asynchronous job processing.

- **Infrastructure & Deployment:**
  **Docker + Kubernetes (AWS EKS)**, **GitHub Actions** for CI/CD, **ALB Ingress** for load balancing.

- **AI / LLM Integration:**
  **AWS Bedrock** for LLM capabilities; Anthropic models recommended for POC.

- **Integration Interface:**
  Integration with IRAlogix exclusively via **push APIs** (inbound employer data) and **webhooks** (outbound compliance results). Direct database access prohibited.
  *Rationale:* Decoupled domain design ensures each system owns its data model independently.

- **Temporal Data Model:**
  Data model must support temporal versioning with effective dates.
  *Rationale:* Laws change; the system must handle history for auditability.

- **Business Rules Engine:**
  ~~Decision between custom BRE, existing solution (OPA, Drools), or IRALOGIX internal BRE is unresolved.~~ **Resolved (2026-03-11):** No external BRE will be adopted. The Logixian system itself constitutes the business rules engine — the knowledge database and rule enforcement code together perform eligibility assessment against regulatory rules.

### Business Constraints

- **Schedule (Time-to-Market):**
  Project completion by end of 2026.

- **Cost Sensitivity:**
  Optimize for operational costs; favor relational models over expensive graph solutions.
  *Rationale:* Client feedback on high cost of previous Neo4j implementation.

- **Data Protection:**
  Must comply with data protection regulations (e.g., GDPR). Minimize PII across logs, databases, and API payloads.

- **POC Scope:**
  Initial 5 states: California (CalSavers), New York (Secure Choice), Illinois (Secure Choice), New Jersey (RetireReady NJ), Minnesota (Secure Choice Retirement Program). Expansion follows POC validation.

- **Ingestion Liability:**
  No liability for source website errors. IRALOGIX Compliance Team is sole Source of Truth; human review gate (FR-I08) enforces approval before activation.

---

## Changelog (v6 → v7)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| FR-I03 *(updated)*: Added explicit mention of state program websites (e.g., CalSavers FAQ) as confirmed ingestion source type | 1.1 Jurisdiction Intelligence Engine | client-meeting/2026-03-11/GMT20260311-200440_Recording.transcript.vtt (00:10:03–00:10:43) | Brad confirmed the system fetches regulatory content from state program websites, not raw statutes; source type is architecturally significant because it determines what the LLM must parse |
| FR-D02 *(updated)*: Added timestamps for compliance-relevant actions (registration date, roster upload date, payroll deduction date) to client data | 1.2 Eligibility Determination Service | client-meeting/2026-03-11/GMT20260311-200440_Recording.transcript.vtt (00:16:31–00:17:04) | Brad clarified that compliance deadlines are time-window-based; the system must know *when* each action occurred to evaluate whether an employer is within their compliance window |
| Technical Constraint — Business Rules Engine *(updated)*: Closed open-blocking item; custom BRE built in-house | 3. Constraints / Technical | client-meeting/2026-03-11/GMT20260311-200440_Recording.transcript.vtt (00:29:35–00:30:42) + Client Meeting.md | Brad explicitly resolved item 1.4: the data model + rule enforcement code IS the BRE; no external BRE (OPA, Drools) will be adopted |
| Technical Constraint — PostgreSQL AGE *(updated)*: Changed from mandated to advisory | 3. Constraints / Technical | client-meeting/2026-03-11/GMT20260311-200440_Recording.transcript.vtt (00:23:35–00:23:46) | Brad indicated the graph extension may not be needed given the relational data model; making it advisory avoids premature adoption of a component that adds operational complexity |
| Technical Constraint — Data Model Column Design *(new)*: Typed relational columns preferred; minimize JSON columns | 3. Constraints / Technical | client-meeting/2026-03-11/GMT20260311-200440_Recording.transcript.vtt (00:23:47–00:24:25) | Brad explicitly constrained the data model design: JSON columns create indexing and schema-clarity problems at scale; this choice constrains the physical data model design |
| Utility Tree section added | 2. Quality Attributes | Synthesis across v6 baseline | Required by architecture-driver skill (update mode); priorities unchanged from v6 but now explicitly ranked |
| Key Architecture Tradeoff section added | 2. Quality Attributes | Synthesis across v6 baseline | Required by architecture-driver skill (update mode); Accuracy vs Timeliness tradeoff is the primary structural tension |

> [HUMAN REVIEW REQUIRED] — Review changelog before accepting this as the new baseline.
