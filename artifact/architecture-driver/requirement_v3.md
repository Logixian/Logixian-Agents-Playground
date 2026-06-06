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
| FR-I07 *(updated)* | The system shall utilize an LLM (via AWS Bedrock, Anthropic models) to parse and extract regulatory data exclusively from officially designated state portals and FAQs (e.g., employer.calsavers.com), bypassing raw legal text, into a predefined schema. |
| FR-I08 | The system shall require a human expert review and approval step before newly LLM-extracted regulatory rules are published to the knowledge database. |
| FR-I09 | The system shall store each jurisdiction's regulatory rules in a unified rule model schema comprising: `state_code`, `program_name`, `status` (e.g., ACTIVE), `default_contribution` (initial rate and auto-escalation parameters including `annual_increment_rate` and `cap_rate`), `eligibility_rules` (minimum employees in state, minimum years in business, qualified-plan exclusion, exempt entity types), `compliance_deadlines` (employee-count tiers each with `deadline_date` and `is_voluntary` flag), `penalty_structure` (`evaluation_metric`, `grace_period_days`, penalty `tiers` with `threshold_value`/`amount_per_employee`/`is_cumulative`, `subsequent_period_penalty`, `penalty_multiplier`), and `audit_trail` (`source_urls` and `last_parsed_at` timestamp). |

### 1.2 Eligibility Determination Service

| **No** | **Description** |
| --- | --- |
| FR-D01 *(updated)* | The system shall evaluate employer characteristics against regulatory requirements to determine eligibility; the outcome shall include `eligibility_status` (MANDATED, EXEMPT, or VOLUNTARY), `compliance_status` (COMPLIANT, NON_COMPLIANT, ACTION_REQUIRED, or GRACE_PERIOD), applicable action items with severity, and a rule-based rationale. |
| FR-D02 *(updated)* | The system shall maintain client data in a defined JSON payload schema comprising: `employer_uuid`, `company_hq_state`, `incorporation_date`, `entity_type`, `offers_qualified_plan`, and per-state profiles containing `employee_count` and `operational_status` (`has_registered`, `has_uploaded_roster`, `has_facilitated_deductions`). The payload must not contain employee contribution amounts, payroll deductions, or financial transactions; compliance is determined by fulfillment of administrative obligations only. |
| FR-D03 | The system shall handle multi-criteria decision logic for complex employer scenarios in eligibility determination. |
| FR-D04 | The system shall log all decision points in the eligibility determination process. |
| FR-D05 | The system shall allow compliance personnel to assist with regulatory determinations. |
| FR-D06 | The system shall expose a push API endpoint to receive anonymized employer profile data from the external IRAlogix system. |
| FR-D07 *(updated)* | The system shall generate a compliance snapshot per employer comprising: `employer_uuid`, `calculated_at`, `profile_hash` (for deduplication of identical submissions), and per-state `evaluations` each containing `state_code`, `rule_version_id` (identifying the specific rule version used), `eligibility_status`, `compliance_status`, `applicable_deadline`, `action_items` (each with `action_code` and `severity`), and `risk_exposure` (with `max_penalty_amount` and a `calculation_breakdown` including `affected_employees`, `penalty_per_employee`, `is_cumulative_max_reached`, and `reasoning_code`). |

### 1.3 Compliance Deadline Calculator

| **No** | **Description** |
| --- | --- |
| FR-C01 *(updated)* | The system shall calculate compliance deadlines accounting for phase-in schedules; the output shall include an `applicable_deadline` date derived from employee-count-tier matching against the jurisdiction's `compliance_deadlines` array, distinguishing mandatory from voluntary phases. |
| FR-C02 *(updated)* | The system shall calculate penalties for non-compliance based on jurisdiction-specific `penalty_structure` rules; the output shall include `max_penalty_amount` and a breakdown of `affected_employees`, `penalty_per_employee`, `is_cumulative_max_reached`, `reasoning_code` (e.g., EXCEEDS_180_DAYS), and `evaluation_metric` (e.g., DAYS_LATE) with `grace_period_days` applied before tier escalation. |

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
| R2 *(updated)* | Reproducibility | Same `profile_hash` (identical employer payload) combined with the same `rule_version_id` yields identical compliance outputs; differences are explainable via `reasoning_code` delta. Rank: (I=H, D=S) |
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

- **Ingestion Liability Disclaimer:**  
  The automated ingestion pipeline bears no liability for typographical errors on state regulatory websites or portals. The IRALOGIX Compliance Team is the sole Source of Truth and must approve all LLM-extracted rule data before it is activated for compliance calculations.  
  *Rationale:* Established in the agreed data pipeline design (`docs/data-model/data_model_v1.md` Part 1); the human expert review gate (FR-I08) serves as the source-of-truth enforcement boundary.

---

## Changelog (v2 → v3)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| FR-I07 *(updated)*: LLM extraction source narrowed to officially designated state portals and FAQs; raw legal text explicitly excluded | 1.1 | `docs/data-model/data_model_v1.md` Part 1 | Data model specifies state portals (e.g., CalSavers FAQs) as the designated scraping target; raw law complexity intentionally bypassed |
| FR-I09 *(new)*: Unified rule model schema defined with all top-level fields (state_code, status, default_contribution with auto-escalation, eligibility_rules, compliance_deadlines, penalty_structure, audit_trail) | 1.1 | `docs/data-model/data_model_v1.md` Part 2 | Resolves previously TBD knowledge database schema for FR-I01; concrete schema establishes the LLM extraction contract and BRE input contract |
| FR-D01 *(updated)*: Eligibility outcome now specifies eligibility_status (MANDATED, EXEMPT, VOLUNTARY) and compliance_status (COMPLIANT, NON_COMPLIANT, ACTION_REQUIRED, GRACE_PERIOD) | 1.2 | `docs/data-model/data_model_v1.md` Part 4 | Compliance snapshot schema defines the complete output state machine; closes TBD on outcome form |
| FR-D02 *(updated)*: Client data payload schema fully defined; explicit prohibition on financial transaction data added | 1.2 | `docs/data-model/data_model_v1.md` Part 3 | Resolves previously TBD format; financial data prohibition limits scope strictly to administrative obligations, reducing PII and regulatory risk |
| FR-D07 *(updated)*: Compliance snapshot enhanced with profile_hash, rule_version_id per evaluation, action_code/severity in action_items, and reasoning_code in calculation_breakdown | 1.2 | `docs/data-model/data_model_v1.md` Part 4 | profile_hash enables deduplication; rule_version_id provides point-in-time traceability; reasoning_code documents the penalty calculation basis |
| FR-C01 *(updated)*: Output defined as applicable_deadline derived from employee-count-tier matching; mandatory vs. voluntary phase distinction added | 1.3 | `docs/data-model/data_model_v1.md` Part 2 & Part 4 | compliance_deadlines array with is_voluntary flag resolves TBD output form for deadline calculation |
| FR-C02 *(updated)*: Penalty output fully defined — DAYS_LATE evaluation metric, grace_period_days, tier-based cumulative logic, subsequent_period_penalty, is_cumulative_max_reached, reasoning_code | 1.3 | `docs/data-model/data_model_v1.md` Part 2 & Part 4 | penalty_structure schema and calculation_breakdown in snapshot together resolve TBD output form for penalty calculation |
| R1 *(updated)*: Decision provenance now cites rule_version_id and reasoning_code as concrete provenance artifacts | 2 — Auditability | `docs/data-model/data_model_v1.md` Part 4 | Compliance snapshot schema introduces these fields as the formal traceability mechanism from evaluation back to approved rule version |
| R2 *(updated)*: Reproducibility formalised using profile_hash as deduplication key and rule_version_id for version-locked replay | 2 — Auditability | `docs/data-model/data_model_v1.md` Part 4 | Same profile_hash + same rule_version_id must yield identical outputs; reasoning_code explains any delta |
| Ingestion Liability Disclaimer *(new)* added to Business Constraints | 3 — Business Constraints | `docs/data-model/data_model_v1.md` Part 1 | Establishes legal/operational boundary; positions IRALOGIX Compliance Team as sole Source of Truth; FR-I08 human review gate is the enforcement point |

> [HUMAN REVIEW REQUIRED] — Review changelog before merging this version.
