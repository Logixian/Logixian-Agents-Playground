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
| FR-I02 *(updated)* | The system shall trigger regulatory ingestion on a weekly schedule; compliance calculations shall be triggered reactively upon detection of regulatory data updates. |
| FR-I03 *(updated)* | The system shall support both unstructured sources (PDFs, HTML) and structured sources (tables, APIs) for jurisdictional data ingestion. |
| FR-I05 *(updated)* | The system shall provide an interface to query the knowledge database, supporting point-in-time evaluation (e.g., "what was the rule on date X?"). |
| FR-I06 *(updated)* | The system shall support an initial scope of 5 states — California, New York, Illinois, New Jersey, and Minnesota — with capability to expand coverage. |
| FR-I08 | The system shall require a human expert review and approval step before newly LLM-extracted regulatory rules are published to the knowledge database. |
| FR-I09 *(updated)* | The system shall detect changes in regulatory rules and emit events to downstream services upon updates. See [FR-I09 Schema Details](requirement-schema-details.md#fr-i09) for the unified rule model schema. |
| FR-I10 *(new)* | The system shall track rule versioning with effective dates and historical change lineage. |
| FR-I11 *(new)* | The system shall preserve raw regulatory source material alongside structured extractions, with provenance tracked per record including source URL, retrieval date, and extraction method. |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 *(updated)* | The system shall evaluate employer eligibility per jurisdiction based on employee count, time in business, existing qualified plan status, and entity type, producing a structured outcome that includes eligibility and compliance status, applicable action items with severity, and a rule-based rationale. See [FR-D01 Output Schema](requirement-schema-details.md#fr-d01). |
| FR-D02 *(updated)* | The system shall maintain client data in a defined JSON payload schema capturing employer identity, operating jurisdictions, and administrative operational status. Financial transaction data is explicitly excluded. See [FR-D02 Payload Schema](requirement-schema-details.md#fr-d02). |
| FR-D04 | The system shall log all decision points in the eligibility determination process. |
| FR-D05 | The system shall allow compliance personnel to assist with regulatory determinations. |
| FR-D07 *(updated)* | The system shall generate a compliance snapshot per employer capturing evaluation results per state, including eligibility and compliance status, applicable deadline, action items, risk exposure, and traceability metadata. See [FR-D07 Snapshot Schema](requirement-schema-details.md#fr-d07). |
| FR-D08 *(new)* | The system shall apply state-specific employee count thresholds to determine mandatory coverage eligibility (CA: 1+, NY: 10+, IL: 5+, NJ: 25+, MN: 5+). |
| FR-D09 *(new)* | The system shall apply exemption logic for employer types excluded from state program requirements, including sole proprietors, government entities, religious organizations, and tribal organizations. |
| FR-D10 *(new)* | The system shall determine and return whether an employer must enroll in a state-run retirement program or may offer a qualified private-plan alternative. |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 *(updated)* | The system shall compute registration deadlines based on employer size and the jurisdiction's phase-in schedule, distinguishing mandatory from voluntary phases. See [FR-C01 Output Details](requirement-schema-details.md#fr-c01). |
| FR-C02 *(updated)* | The system shall calculate penalty exposure for non-compliant employers, including penalty amount, escalation tier, and enforcement timeline per jurisdiction. See [FR-C02 Output Details](requirement-schema-details.md#fr-c02). |
| FR-C03 *(new)* | The system shall support rolling and future-dated deadlines (e.g., NY rolling Mar–Jul 2026, MN phased 2026–2028). |
| FR-C04 *(new)* | The system shall support project phase-in deadlines for newly eligible employers |

### 1.4 Automated Onboarding Workflow

| **No** | **Description** |
| --- | --- |
| FR-O01 *(updated)* | The system shall provide a push API endpoint for employer data ingestion, covering both compliance profile submissions and onboarding enrollment, via versioned API contracts with IRAlogix. *(Consolidated from FR-D06.)* |
| FR-O02 | The system shall enable the platform to extend from account execution to employer engagement workflows. |

### 1.5 Monitoring & Alert System

| **No** | **Description** |
| --- | --- |
| FR-M01 *(updated)* | The system shall track compliance status across all enrolled employers over time. |
| FR-M02 *(updated)* | The system shall send notifications on a graduated schedule aligned to state penalty escalation timelines. |
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
| T1 *(updated)* | Change Detection | Regulatory source updates are detected within a 1-week scheduled ingestion cycle. Rank: (I=M, D=M) |
| T2 | Update Propagation Latency | New rule version becomes usable within **TBD** time after human approval; old version remains available. Rank: (I=H, D=S) |
| T3 | Effective-Date Semantics | Query uses the correct rule version as-of the effective date. Rank: (I=M, D=S) |
| T4 | Incremental Updates | Recompute only affected employers/rules after a change. Rank: (I=M, D=S) |
| T5 *(updated)* | Timely Triggers / Actions | Eligibility/deadline changes trigger downstream actions promptly via the SQS-based reactive pipeline. Rank: (I=H, D=H) |

#### Auditability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| R1 *(updated)* | Decision Provenance | Each compliance evaluation cites the `rule_version_id` of the rule version used and the `reasoning_code` for each decision, preserving full traceability from snapshot back to the approved rule version. Rank: (I=H, D=H) |
| R2 *(updated)* | Reproducibility | Calculation results must be reproducible given the same input snapshot and rule version; differences are explainable via `reasoning_code` delta. Rank: (I=H, D=S) |
| R3 *(updated)* | Audit Logging | Audit trail is queryable by employer, jurisdiction, and time range; records who changed/published what and when. Rank: (I=M, D=M) |
| R4 *(new)* | Calculation Storage | All eligibility and compliance calculations must be stored with the full input snapshot, rule version used, and timestamp of evaluation. Rank: (I=H, D=H) |

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
| P2 | Ingestion Throughput | Weekly regulatory ingestion pipeline completes within **TBD** time window without blocking concurrent compliance queries. Rank: (I=M, D=S) |
| P3 *(new)* | Sync API Response Time | Single-employer eligibility check API responses must complete within 500ms. Rank: (I=M, D=M) |
| P4 *(new)* | Async Batch Re-evaluation | Async batch re-evaluation of the full client base triggered by a rule change must complete within 1 hour. Rank: (I=M, D=S) |

#### Reliability

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| Rel1 | Message Queue Fault Tolerance | Failed SQS messages are routed to a Dead Letter Queue (DLQ) for investigation; no silent data loss. Rank: (I=H, D=M) |
| Rel2 | Service Availability | The compliance API remains available under partial infrastructure failures; degraded reads are acceptable over full outage. Rank: (I=M, D=S) |
| Rel3 *(new)* | ETL Integrity | ETL pipeline failures must not corrupt existing stored rules; failed ingestion runs must be rolled back or isolated without affecting the active rule set. Rank: (I=H, D=H) |

#### Extensibility

| **No** | **Attribute Refinement** | **ASR Scenario (ranking in scenario)** |
| --- | --- | --- |
| E1 *(new)* | State Coverage Scalability | The system must scale from the initial 5-state POC to 20+ states without requiring architectural changes; new jurisdictions are onboarded via data configuration, not code changes. Rank: (I=H, D=M) |

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

- **Ingestion Liability Disclaimer:**  
  The automated ingestion pipeline bears no liability for typographical errors on state regulatory websites or portals. The IRALOGIX Compliance Team is the sole Source of Truth and must approve all LLM-extracted rule data before it is activated for compliance calculations.  
  *Rationale:* Established in the agreed data pipeline design (`docs/data-model/data_model_v1.md` Part 1); the human expert review gate (FR-I08) serves as the source-of-truth enforcement boundary.

---

## Changelog (v3 → v4)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| FR-I05 *(updated)*: Enhanced from generic query interface to explicitly require point-in-time evaluation support ("what was the rule on date X?") | 1.1 | Review v4 | Point-in-time querying is essential for historical audits and reproducibility; aligns with quality attributes T3 (Effective-Date Semantics) and R2 (Reproducibility) |
| FR-I11 *(new)*: Raw regulatory source material preserved alongside structured extractions; provenance tracked per record (source URL, retrieval date, extraction method) | 1.1 | Review v4 | Preserving raw sources and extraction provenance supports human review (FR-I08), enables re-extraction if the schema evolves, and provides an evidence trail for audit and liability purposes |
| P1: Removed; replaced by P3 with a concrete SLA (500ms for single-employer eligibility checks) | 2 — Performance | Review v4 | TBD target was not actionable; concrete threshold enables testability and sets a clear design constraint |
| P3 *(new)*: Sync API responses < 500ms for single-employer eligibility checks | 2 — Performance | Review v4 | Replaces P1 with a measurable latency target; single-employer path is the primary interactive use case requiring a concrete SLA |
| P4 *(new)*: Async batch re-evaluation on rule changes must complete within 1 hour for full client base | 2 — Performance | Review v4 | Bounds the latency between a rule approval and all affected employers being re-evaluated; critical for timely alert dispatch (FR-M02) and downstream SQS pipeline sizing |
| Rel3 *(new)*: ETL pipeline failures must not corrupt existing stored rules | 2 — Reliability | Review v4 | Rule corruption would silently invalidate all downstream compliance calculations; explicit isolation guarantee is required to uphold data integrity and auditability obligations |
| E1 *(new)*: System must scale from 5 to 20+ states without architectural changes; new jurisdictions onboarded via data configuration | 2 — Extensibility | Review v4 | POC targets 5 states but production must support national expansion; data-driven jurisdiction configuration avoids re-architecture and constrains scope-creep risk |
| FR-I02 *(updated)*: Combined with FR-I04; now covers both the weekly ingestion trigger and the reactive compliance calculation trigger in a single requirement | 1.1 | Review v4 | FR-I02 and FR-I04 were duplicative; consolidation removes ambiguity and reduces requirement count |
| FR-I03 *(updated)*: Refined from "support different types of jurisdictional requirements" to explicitly specify unstructured (PDFs, HTML) and structured (tables, APIs) source types | 1.1 | Review v4 | Original phrasing was implicit; explicit source-type categories provide actionable guidance for ingestion pipeline design |
| FR-I04: Removed (consolidated into FR-I02) | 1.1 | Review v4 | Content now fully covered by updated FR-I02 |
| FR-I07: Removed from functional requirements; moved to `docs/architecture-driver/implementation-design-notes.md` | 1.1 | Review v4 | FR-I07 describes implementation mechanism (LLM + Bedrock tooling) rather than system behavior; separation preserves what-vs-how discipline |
| FR-I09 *(updated)*: Simplified to focus on behavioral outcome (detect rule changes, emit events to downstream services); detailed unified rule model schema moved to `docs/architecture-driver/requirement-schema-details.md#fr-i09` | 1.1 | Review v4 | Schema field enumeration is specification-level detail; functional requirement should state what the system does, not enumerate field names |
| FR-I10 *(new)*: Track rule versioning with effective dates and historical change lineage | 1.1 | Review v4 | Makes temporal traceability a first-class system obligation, reinforcing quality attributes R1 (Decision Provenance), R2 (Reproducibility), and T3 (Effective-Date Semantics) |
| FR-D01 *(updated)*: Simplified; detailed output schema (status enumerations, action item structure) moved to `docs/architecture-driver/requirement-schema-details.md#fr-d01` | 1.2 | Review v4 | Over-specification in the requirement body; schema detail belongs in a dedicated specification document |
| FR-D02 *(updated)*: Simplified; detailed JSON payload field list moved to `docs/architecture-driver/requirement-schema-details.md#fr-d02`; financial data exclusion constraint retained in the requirement | 1.2 | Review v4 | Payload schema is implementation-level detail; the requirement captures intent (employer identity + administrative status, no financials) |
| FR-D06: Removed; consolidated into FR-O01 | 1.2 | Review v4 | FR-D06 and FR-O01 both described the same push API endpoint for receiving employer data from IRAlogix; duplication eliminated |
| FR-D07 *(updated)*: Simplified; detailed compliance snapshot schema moved to `docs/architecture-driver/requirement-schema-details.md#fr-d07` | 1.2 | Review v4 | Snapshot field enumeration belongs in a dedicated specification; the requirement states the intent (per-state evaluation with traceability metadata) |
| FR-C01 *(updated)*: Refined to specify computation based on employer size and jurisdiction phase-in schedule; output schema detail remains in `docs/architecture-driver/requirement-schema-details.md#fr-c01` | 1.3 | Review v4 | Previous wording was abstract; explicit driver criteria (employer size, phase-in schedule) align the requirement with jurisdiction rule model |
| FR-C02 *(updated)*: Refined to specify penalty exposure output as amount, escalation tier, and enforcement timeline per jurisdiction; output schema detail remains in `docs/architecture-driver/requirement-schema-details.md#fr-c02` | 1.3 | Review v4 | Adds actionable output dimensions (escalation tier, timeline) that were previously implicit |
| FR-C03, FR-C04 *(new)*: Support rolling and future-dated deadlines; project phase-in deadlines for newly eligible employers (e.g., NY Mar–Jul 2026, MN 2026–2028) | 1.3 | Review v4 | Static deadline lookup is insufficient for jurisdictions with rolling enrollment windows or multi-year phase-in schedules; this requirement ensures forward-looking deadline projection |
| FR-O01 *(updated)*: Consolidated with FR-D06; endpoint now explicitly covers both compliance profile submissions and onboarding enrollment under a single versioned API contract | 1.4 | Review v4 | Eliminates duplication between sections 1.2 and 1.4; single canonical requirement for the IRAlogix push API integration point |
| FR-D01 *(updated)*: Refined eligibility evaluation criteria to explicitly enumerate: employee count, time in business, existing qualified plan status, and entity type | 1.2 | Review v4 | Previous wording was generic; explicit criteria align the requirement directly with the jurisdiction eligibility rules defined in FR-I09 schema |
| FR-D03: Removed; split into FR-D08 and FR-D09 | 1.2 | Review v4 | Original requirement conflated threshold logic and exemption logic; separating them clarifies distinct decision paths and improves traceability |
| FR-D08 *(new)*: Apply state-specific employee count thresholds for mandatory coverage eligibility (CA: 1+, NY: 10+, IL: 5+, NJ: 25+, MN: 5+) | 1.2 | Review v4 | Makes per-state threshold rules a testable, traceable requirement; previously implicit in FR-D03 |
| FR-D09 *(new)*: Apply exemption logic for excluded employer types (sole proprietors, government entities, religious organizations, tribal organizations) | 1.2 | Review v4 | Exemption categories are substantively distinct from threshold logic; explicit requirement enables targeted rule coverage and audit verification |
| FR-D10 *(new)*: Determine and return whether employer must enroll in state-run program or may offer a qualified private-plan alternative | 1.2 | Review v4 | Enrollment pathway determination is a core compliance output not previously captured as its own requirement; directly informs action items in FR-D01 output |
| FR-M01 *(updated)*: Scoped to cover all enrolled employers explicitly, replacing "over time" framing with an active monitoring scope | 1.5 | Review v4 | Previous wording was passive; explicit scope (all enrolled employers) clarifies the monitoring surface and aligns with FR-D07 compliance snapshot coverage |
| FR-M02 *(updated)*: Replaced generic deadline-based trigger with a graduated notification schedule aligned to state penalty escalation timelines | 1.5 | Review v4 | Notification urgency should mirror penalty escalation progression; graduated schedule ensures employers receive early warnings before tier escalation, reducing non-compliance risk |
| R2 *(updated)*: Simplified to focus on the reproducibility contract (same inputs + same rule version = same result); `profile_hash` and `rule_version_id` implementation detail retained in schema spec | 2 — Auditability | Review v4 | Aligns with what-vs-how discipline; the mechanism is in the schema spec, the requirement states the behavioral guarantee |
| R3 *(updated)*: Audit trail now explicitly queryable by employer, jurisdiction, and time range | 2 — Auditability | Review v4 | Adds query dimensions needed by compliance personnel and auditors; aligns with FR-D05 (compliance personnel assistance) |
| R4 *(new)*: All eligibility/compliance calculations must be stored with full input snapshot, rule version, and timestamp | 2 — Auditability | Review v4 | Formalises storage obligation for calculation provenance; complements R1 (Decision Provenance) and enables R2 (Reproducibility) by guaranteeing inputs are always retrievable |

> [HUMAN REVIEW REQUIRED] — Review changelog before merging this version.
