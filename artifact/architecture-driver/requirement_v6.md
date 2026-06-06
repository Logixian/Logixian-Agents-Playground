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
| FR-I03 | The system shall support ingestion from both unstructured and structured regulatory sources. |
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
| FR-D02 | The system shall maintain client data capturing employer identity, operating jurisdictions, and operational status. Financial transaction data is excluded. |
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

---

## 3. Constraints

### Technical Constraints

- **Backend Language:**  
  Python with an asynchronous framework (**FastAPI + Uvicorn**). Java and synchronous frameworks (Django, Flask) are rejected.  
  *Rationale:* Async capability required for concurrent connections at scale.

- **Database Technology:**  
  **PostgreSQL 17** with the **Apache AGE graph extension** as the primary data store.  
  *Rationale:* Migrating from Neo4j due to cost; AGE provides relational and graph capabilities at lower cost.

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

- **Business Rules Engine (Open — Blocking):**  
  Decision between custom BRE, existing solution (OPA, Drools), or IRALOGIX internal BRE is unresolved.  
  *Resolution requires:* domain knowledge transfer and sample data access.

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

## Changelog (v5 → v6)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| FR-I01 *(restored)*: The system shall maintain a knowledge database containing regulatory rules | 1.1 | Review v6 | Foundational "what" of the Jurisdiction Intelligence Engine; removal in v5 left the core data store obligation implicit |
| FR-I02 *(updated)*: Removed "weekly schedule" detail; generalized to "periodically ingest" | 1.1 | Review v6 | Ingestion frequency is operational configuration, not an architectural functional requirement; keeps focus on "what" not "how" |
| FR-I03 *(updated)*: Removed specific source type examples (PDFs, HTML, tables, APIs); simplified to "unstructured and structured" | 1.1 | Review v6 | Source format enumeration is implementation detail; the architecturally significant statement is the capability to handle both categories |
| FR-I11 *(updated)*: Removed granular field list (source URL, retrieval date, extraction method); simplified to "extraction provenance metadata" | 1.1 | Review v6 | Specific provenance fields are schema-level detail; the requirement captures the obligation to preserve provenance |
| FR-D01 *(updated)*: Removed specific evaluation criteria enumeration (employee count, time in business, etc.); generalized to "configurable rule criteria" | 1.2 | Review v6 | Specific criteria are jurisdiction rule data that changes per state; the architecturally significant "what" is configurable rule-based evaluation |
| FR-D02 *(updated)*: Removed "JSON payload schema" implementation detail | 1.2 | Review v6 | Schema format is a design decision, not a functional requirement; the requirement captures what data is maintained and what is excluded |
| FR-D04: Removed | 1.2 | Review v6 | Decision logging is a cross-cutting auditability concern already covered by quality attributes R1 (Decision Provenance), R3 (Audit Logging), and R4 (Calculation Storage) |
| FR-D08: Removed | 1.2 | Review v6 | State-specific employee thresholds (CA: 1+, NY: 10+, etc.) are rule configuration data, not architectural requirements; covered by FR-D01 ("configurable rule criteria") and E1 (data-driven jurisdiction onboarding) |
| FR-D09: Removed | 1.2 | Review v6 | Exemption types (sole proprietors, government entities, etc.) are rule configuration data; covered by FR-D01's configurable evaluation and the knowledge database (FR-I01) |
| FR-C03 *(updated)*: Merged FR-C04 content (phased deadlines for newly eligible employers) into FR-C03 | 1.3 | Review v6 | Both requirements describe deadline type support; consolidation eliminates redundancy |
| FR-C04: Removed (merged into FR-C03) | 1.3 | Review v6 | Content fully covered by updated FR-C03 |
| FR-M03 *(updated)*: Removed "webhook" mechanism detail; simplified delivery description | 1.5 | Review v6 | Delivery mechanism (webhook) is already captured in the Integration Interface technical constraint; functional requirement focuses on "what" (generate alert payloads) |
| FR-O01 *(updated)*: Removed "push API" and "versioned API contracts with IRAlogix" mechanism detail | 1.4 | Review v6 | Integration mechanism is already in technical constraints (Integration Interface); requirement now states "what" the endpoint does |
| Quality Attributes section: Removed "Quality Attribute Refinements" intermediary header | 2 | Review v6 | Follows v1 structural pattern; reduces nesting without losing clarity |
| T1 *(updated)*: Removed "1-week" specific interval | 2 — Timeliness | Review v6 | Ingestion frequency is operational configuration (see FR-I02 update); quality attribute focuses on the detection-within-cycle guarantee |
| T5 *(updated)*: Removed "via the SQS-based reactive pipeline" | 2 — Timeliness | Review v6 | Implementation mechanism (SQS) is already in technical constraints; quality attribute states the behavioral expectation only |
| R1 *(updated)*: Removed field names (`rule_version_id`, `reasoning_code`); reworded to concept level | 2 — Auditability | Review v6 | Field-level naming is schema detail; the quality attribute captures the traceability obligation |
| R2 *(updated)*: Removed `reasoning_code` delta reference | 2 — Auditability | Review v6 | Implementation-specific field reference; the attribute states the reproducibility guarantee |
| S2 *(updated)*: Removed "push API" and "per API contract" detail | 2 — Security | Review v6 | Integration mechanism detail belongs in constraints; quality attribute captures the anonymization principle |
| C1 *(updated)*: Simplified from verbose scenario/measure format to concise statement | 2 — Compatibility | Review v6 | Verbose format added noise without architectural value; concise form retains the coupling and versioning obligation |
| Rel1 *(updated)*: Removed "SQS" from description | 2 — Reliability | Review v6 | Mandated technology (SQS) is in technical constraints; quality attribute states the fault-tolerance pattern |
| P2 *(updated)*: Removed "Weekly" and "regulatory" qualifier | 2 — Performance | Review v6 | Ingestion schedule is configuration; throughput attribute is technology-neutral |
| Technical Constraints: Merged "Coding Language Constraint" and "Asynchronous API Framework" into single "Backend Language" constraint | 3 — Technical | Review v6 | Both constrain the same decision (language + framework); consolidation reduces redundancy |
