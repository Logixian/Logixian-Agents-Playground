# Requirements

## 1. Functional Requirements

- **System** – The IRALOGIX platform that automatically processes data, applies rules, and runs operations without human input.
- **Employer** – Business owners or HR staff who use the system to comply with state retirement program rules.
- **Compliance Team** – Internal experts who maintain regulatory data, help with complex eligibility decisions, and review compliance results.

### 1.1 Jurisdiction Intelligence Engine

| **No** | **Description** |
| --- | --- |
| FR-I02 | The system shall trigger regulatory ingestion on a weekly schedule |
| FR-I03 | The system shall support both unstructured sources (PDFs, HTML) and structured sources (tables, APIs) for jurisdictional data ingestion. |
| FR-I05 | The system shall provide an interface to query the knowledge database, supporting point-in-time evaluation (e.g., "what was the rule on date X?"). |
| FR-I06 | The system shall support an initial scope of 5 states — California, New York, Illinois, New Jersey, and Minnesota — with capability to expand coverage. |
| FR-I08 | The system shall allow human expert review before regulatory rules are published to the knowledge database. |
| FR-I09 | The system shall detect changes in regulatory rules and emit events to downstream services upon updates. |
| FR-I10 | The system shall track rule versioning with effective dates and historical change lineage. |
| FR-I11 | The system shall preserve raw regulatory source material alongside structured extractions, with provenance tracked per record including source URL, retrieval date, and extraction method. |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 | The system shall evaluate employer eligibility per jurisdiction based on employee count, time in business, existing qualified plan status, and entity type, producing a structured outcome that includes eligibility and compliance status, applicable action items with severity, and a rule-based rationale. |
| FR-D02 | The system shall maintain client data in a defined JSON payload schema capturing employer identity, operating jurisdictions, and administrative operational status. Financial transaction data is explicitly excluded. |
| FR-D04 | The system shall log all decision points in the eligibility determination process. |
| FR-D07 | The system shall generate a compliance snapshot per employer capturing evaluation results per state, including eligibility and compliance status, applicable deadline, action items, risk exposure, and traceability metadata. |
| FR-D08 | The system shall apply state-specific employee count thresholds to determine mandatory coverage eligibility (CA: 1+, NY: 10+, IL: 5+, NJ: 25+, MN: 5+). |
| FR-D09 | The system shall apply exemption logic for employer types excluded from state program requirements, including sole proprietors, government entities, religious organizations, and tribal organizations. |
| FR-D10 | The system shall determine and return whether an employer must enroll in a state-run retirement program or may offer a qualified private-plan alternative. |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 | The system shall compute registration deadlines based on employer size and the jurisdiction's phase-in schedule, distinguishing mandatory from voluntary phases. |
| FR-C02 | The system shall calculate penalty exposure for non-compliant employers, including penalty amount, escalation tier, and enforcement timeline per jurisdiction. |
| FR-C03 | The system shall support rolling and future-dated deadlines (e.g., NY rolling Mar–Jul 2026, MN phased 2026–2028). |
| FR-C04 | The system shall support project phase-in deadlines for newly eligible employers |

### 1.4 Automated Onboarding Workflow

| **No** | **Description** |
| --- | --- |
| FR-O01 | The system shall provide a push API endpoint for employer data ingestion, covering both compliance profile submissions and onboarding enrollment, via versioned API contracts with IRAlogix. *(Consolidated from FR-D06.)* |

### 1.5 Monitoring & Alert System

| **No** | **Description** |
| --- | --- |
| FR-M02 | The system shall send notifications on a graduated schedule aligned to state penalty escalation timelines. |
| FR-M03 | The system shall generate structured alert payloads and deliver them to IRAlogix via webhook; IRAlogix retains sole responsibility for final user-facing message dispatch (email or UI notification). |

---

## 2. Quality Attributes

### Quality Attribute Refinements

#### Accuracy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| A1 | Rule Extraction Accuracy | Portal/FAQ rule extraction fields are correct. Rank: (I=H, D=H) |
| A2 | Rule Extraction Recoverability | Extraction failures are safe and recoverable (no bad rules published). Rank: (I=H, D=M) |
| A3 | Rule Representation Consistency | Same rule types share a consistent schema; schema evolves without breaking the engine. Rank: (I=H, D=S) |
| A4 | Eligibility Decision Accuracy | Complex employer profile -> correct eligibility decision plus rule-based rationale. Rank: (I=H, D=M) |
| A5 | Deadline Computation Correctness | Phase-in / effective-date deadline calculations are correct. Rank: (I=H, D=H) |
| A6 | LLM Extraction Schema Fidelity | LLM-parsed regulation output matches the predefined unified rule model schema with no hallucinated fields; low-confidence extractions trigger the human review gate before publishing. Rank: (I=H, D=M) |

#### Timeliness

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| T1 | Change Detection | Regulatory source updates are detected within a 1-week scheduled ingestion cycle. Rank: (I=M, D=M) |
| T2 | Update Propagation Latency | New rule version becomes usable within **TBD** time after human approval; old version remains available. Rank: (I=H, D=S) |
| T3 | Effective-Date Semantics | Query uses the correct rule version as-of the effective date. Rank: (I=M, D=S) |
| T5 | Timely Triggers / Actions | Eligibility/deadline changes trigger downstream actions promptly via the SQS-based reactive pipeline. Rank: (I=H, D=H) |

#### Auditability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| R1 | Decision Provenance | Each compliance evaluation cites the `rule_version_id` of the rule version used and the `reasoning_code` for each decision, preserving full traceability from snapshot back to the approved rule version. Rank: (I=H, D=H) |
| R2 | Reproducibility | Calculation results must be reproducible given the same input snapshot and rule version; differences are explainable via `reasoning_code` delta. Rank: (I=H, D=S) |
| R3 | Audit Logging | Audit trail is queryable by employer, jurisdiction, and time range; records who changed/published what and when. Rank: (I=M, D=M) |
| R4 | Calculation Storage | All eligibility and compliance calculations must be stored with the full input snapshot, rule version used, and timestamp of evaluation. Rank: (I=H, D=H) |

#### Security & Privacy

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| S1 | Authentication & Authorization | All API calls are authenticated; failures are denied and logged. Rank: (I=M, D=S) |
| S2 | PII Protection | PII is minimized, protected, and never leaked via logs; employer data received via push API is anonymized per API contract before storage. Rank: (I=H, D=H) |
| S3 | Encryption (In Transit / At Rest) | Encryption coverage meets baseline requirements; key rotation is feasible. Rank: (I=H, D=S) |
| S4 | Security Monitoring / Incident Traceability | Abnormal access patterns trigger alerts; evidence is retained for investigation. Rank: (I=S, D=H) |

#### Compatibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| C1 | Compatibility with IRALOGIX systems | Scenario: When integrating with IRALOGIX portals/services, the system provides stable, versioned APIs/webhooks so IRAlogix can consume compliance snapshots and alert payloads with minimal coupling.<br>Measure: Backward-compatible API changes; integration test pass rate >= TBD.<br>Ranking: (I: High, D: Medium) |

#### Performance

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| P2 | Ingestion Throughput | Weekly regulatory ingestion pipeline completes within **TBD** time window without blocking concurrent compliance queries. Rank: (I=M, D=S) |
| P3 | Sync API Response Time | Single-employer eligibility check API responses must complete within 500ms. Rank: (I=M, D=M) |
| P4 | Async Batch Re-evaluation | Async batch re-evaluation of the full client base triggered by a rule change must complete within **TBD** hour. Rank: (I=M, D=S) |

#### Reliability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| Rel1 | Message Queue Fault Tolerance | Failed SQS messages are routed to a Dead Letter Queue (DLQ) for investigation; no silent data loss. Rank: (I=H, D=M) |
| Rel2 | Service Availability | The compliance API remains available under partial infrastructure failures; degraded reads are acceptable over full outage. Rank: (I=M, D=S) |
| Rel3 | ETL Integrity | ETL pipeline failures must not corrupt existing stored rules; failed ingestion runs must be rolled back or isolated without affecting the active rule set. Rank: (I=H, D=H) |

#### Extensibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| E1 | State Coverage Scalability | The system must scale from the initial 5-state POC to 20+ states without requiring architectural changes; new jurisdictions are onboarded via data configuration, not code changes. Rank: (I=H, D=M) |

---

## 3. Constraints

### Technical Constraints

- **Coding Language Constraint:**<br>We cannot use Java. The chosen backend language is **Python** (team authorized to use Python over the originally suggested Go). Synchronous frameworks (e.g., Django) are explicitly rejected; an asynchronous framework is mandatory.
- **Asynchronous API Framework:**<br>The API backend must use an async Python framework. **FastAPI + Uvicorn** is the confirmed selection; **ALB Ingress** is the load balancer.<br>*Rationale:* Brad required async capability to handle concurrent connections at scale; Flask/Django rejected for this reason.
- **Database Technology:**<br>The system must utilize **PostgreSQL 17** with the **Apache AGE graph extension** as the primary data store.<br>*Rationale:* The client is migrating away from Neo4j due to cost and scalability issues; PostgreSQL 17 + AGE provides both relational and graph capabilities at lower cost, supporting the knowledge graph requirements of the Jurisdiction Intelligence Engine.
- **Message Broker:**<br>The system must use **AWS SQS with Dead Letter Queue (DLQ)** as the message broker for all background and asynchronous job processing.<br>*Rationale:* Confirmed at March 11 meeting; DLQ ensures fault-tolerant processing without silent data loss.
- **Infrastructure & Deployment:**<br>The solution must be deployable on **Docker + Kubernetes (AWS EKS)**, using **GitHub Actions** for CI/CD and **ALB Ingress** for traffic management.
- **AI / LLM Integration:**<br>LLM capabilities must leverage **AWS Bedrock**; Anthropic models (e.g., Opus) are recommended for the POC.<br>*Rationale:* Brad confirmed IRALOGIX's AWS Bedrock access and recommended it for document parsing.
- **Integration Interface:**<br>The system must integrate with IRAlogix exclusively via: (a) **push APIs** for receiving anonymized employer data, and (b) **webhooks** for delivering compliance results and alert payloads. Direct database access from IRAlogix into Logixian's database is prohibited.<br>*Rationale:* Decoupled "black box" domain design ensures each system owns its data model and maintains independent evolvability.
- **Regulatory Validity (Temporal):**<br>The data model must support temporal versioning (effective dates) to track changes in legislation over time.<br>*Rationale:* Laws change. The system cannot store only the "current" state; it must handle history for auditability.
- **Business Rules Engine (Open — Blocking):**<br>The decision to build a custom BRE vs. adopt an existing solution (OPA, Drools, etc.) vs. use the IRALOGIX internal BRE is still **open and blocking** finalization of the architecture blueprint.<br>*Resolution requires:* domain knowledge transfer from Brad and access to sample data.

### Business Constraints

- **Schedule (Time-to-Market):**<br>The whole project should be completed by the end of 2026.
- **Cost Sensitivity:**<br>The architecture must optimize for operational costs, favoring efficient relational models over expensive in-memory graph solutions.<br>*Rationale:* Explicit client feedback regarding the high cost of the previous Neo4j implementation.
- **Legal Constraint (Business):**<br>The system processes sensitive information and must comply with applicable data protection regulations (e.g., GDPR). This affects the entire pipeline design: logs, databases, and API payloads must minimize PII exposure.
- **POC Scope:**<br>The initial proof-of-concept targets **5 states**: California (CalSavers), New York (Secure Choice), Illinois (Secure Choice), New Jersey (RetireReady NJ), and Minnesota (Secure Choice Retirement Program). Expansion to remaining states follows POC validation.
- **Ingestion Liability Disclaimer:**<br>The automated ingestion pipeline bears no liability for typographical errors on state regulatory websites or portals. The IRALOGIX Compliance Team is the sole Source of Truth and must approve all LLM-extracted rule data before it is activated for compliance calculations.<br>*Rationale:* Established in the agreed data pipeline design (`docs/data-model/data_model_v1.md` Part 1); the human expert review gate (FR-I08) serves as the source-of-truth enforcement boundary.
