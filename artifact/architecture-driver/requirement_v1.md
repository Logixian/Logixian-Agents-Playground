# Architecture Driver

## 1. Functional Requirements

- **System** – The IRALOGIX platform that automatically processes data, applies rules, and runs operations without human input.
- **Employer** – Business owners or HR staff who use the system to comply with state retirement program rules.
- **Compliance Team** – Internal experts who maintain regulatory data, help with complex eligibility decisions, and review compliance results.

### 1.1 Jurisdiction Intelligence Engine

| **No** | **Description** |
| --- | --- |
| FR-I01 | The system shall maintain a knowledge database containing regulatory rules. |
| FR-I02 | The system shall ingest jurisdictional requirements. |
| FR-I03 | The system shall support different types of jurisdictional requirements. |
| FR-I04 | The system shall know **WHEN** to trigger the ingestion. |
| FR-I05 | The system shall provide interface to query a knowledge database. |
| FR-I06 | The system shall support a subset of the 27 states initially with capability to expand coverage. |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 | The system shall evaluate employer characteristics against regulatory requirements to determine eligibility in TBD form (1. outcome 2. reason) |
| FR-D02 | The system shall maintain a client data in **TBD** format. |
| FR-D03 | The system shall handle multi-criteria decision logic for complex employer scenarios in eligibility determination. |
| FR-D04 | The system shall log all decision points in the eligibility determination process. |
| FR-D05 | The system shall allow compliance personnel to assist with regulatory determinations. |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 | The system shall calculate compliance deadlines accounting for phase-in schedules in TBD form (1. outcome 2. reason) |
| FR-C02 | The system shall calculate penalties for non-compliance based on jurisdiction-specific rules in TBD from (1. deadline 2. amount 3. ?). |

### 1.4 Automated Onboarding Workflow

| **No** | **Description** |
| --- | --- |
| FR-O01 | The system shall provide an automated onboarding interface to current system to streamline employer enrollment. |
| FR-O02 | The system shall enable the platform to extend from account execution to employer engagement workflows. |

### 1.5 Monitoring & Alert System

| **No** | **Description** |
| --- | --- |
| FR-M01 | The system shall track employer compliance status over time |
| FR-M02 | The system shall send notifications based on compliance status and deadlines. |

## 2. Quality Attributes

### Accuracy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| A1 | Rule Extraction Accuracy | PDF rule extraction fields are correct. Rank: (I=H, D=H) |
| A2 | Rule Extraction Recoverability | Extraction failures are safe and recoverable (no bad rules published). Rank: (I=H, D=M) |
| A3 | Rule Representation Consistency | Same rule types share a consistent schema; schema evolves without breaking the engine. Rank: (I=H, D=S) |
| A4 | Eligibility Decision Accuracy | Complex employer profile -> correct eligibility decision plus rule-based rationale. Rank: (I=H, D=M) |
| A5 | Deadline Computation Correctness | Phase-in / effective-date deadline calculations are correct. Rank: (I=H, D=H) |

### Timeliness

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| T1 | Change Detection | Regulatory source updates are detected in **TBD** time. Rank: (I=M, D=M) |
| T2 | Update Propagation Latency | New rule version becomes usable within **TBD** time; old version remains available. Rank: (I=H, D=S) |
| T3 | Effective-Date Semantics | Query uses the correct rule version as-of the effective date. Rank: (I=M, D=S) |
| T4 | Incremental Updates | Recompute only affected employers/rules after a change. Rank: (I=M, D=S) |
| T5 | Timely Triggers / Actions | Eligibility/deadline changes trigger downstream actions promptly. Rank: (I=H, D=H) |

### Auditability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| R1 | Decision Provenance | Each decision cites rule IDs/clauses plus key inputs used. Rank: (I=H, D=H) |
| R2 | Reproducibility | Same inputs + same rule version => same outputs (or differences are explainable). Rank: (I=H, D=S) |
| R3 | Audit Logging | Who changed/published what, when, and impact scope is recorded. Rank: (I=M, D=M) |

### Security & Privacy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| S1 | Authentication & Authorization | All API calls are authenticated; failures are denied and logged. Rank: (I=M, D=S) |
| S2 | PII Protection | PII is minimized, protected, and never leaked via logs. Rank: (I=H, D=H) |
| S3 | Encryption (In Transit / At Rest) | Encryption coverage meets baseline requirements; key rotation is feasible. Rank: (I=H, D=S) |
| S4 | Security Monitoring / Incident Traceability | Abnormal access patterns trigger alerts; evidence is retained for investigation. Rank: (I=S, D=H) |

### Compatibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| C1 | Compatibility with IRALOGIX systems | Scenario: When integrating with IRALOGIX portals/services, the system provides stable, versioned APIs/events so IRAlogix can consume compliance status and rule updates with minimal coupling.<br>Measure: Backward-compatible API changes; integration test pass rate >= TBD.<br>Ranking: (I: High, D: Medium) |

---

## 3. Constraints

### Technical Constraints

- **Coding Language Constraint:**  
  We cannot use Java.
- **Database Technology:**  
  The system must utilize PostgreSQL as the primary data store.  
  *Rationale:* The client is migrating away from Neo4j due to cost and scalability issues; the architecture must align with this relational migration.
- **Infrastructure & Deployment:**  
  The solution must be deployable within the client's existing AWS and Kubernetes environment.
- **Integration Interface:**  
  The system output must be consumable by the existing IRALOGIX Employer Portal and user experience.  
  *Rationale:* Our service is a component of a larger ecosystem; it cannot be a standalone silo.
- **Regulatory Validity (Temporal):**  
  The data model must support temporal versioning (effective dates) to track changes in legislation over time.  
  *Rationale:* Laws change. The system cannot just store the "current" state; it must handle history for auditability.

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
  The system is processing sensitive information; it must follow certain regulations like GDPR. This will affect the whole system pipeline design because data is everywhere (log, database, etc.).
