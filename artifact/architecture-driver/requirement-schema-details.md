# Requirement Schema Details

This document contains detailed schema and output specifications extracted from `requirement_v4.md` to preserve the *what* vs *how* separation in the main requirements file. Each section is identified by its originating requirement number for traceability.

---

## FR-I09 — Unified Rule Model Schema

Each jurisdiction's regulatory rules shall be stored using the following unified schema fields:

- `state_code`
- `program_name`
- `status` (e.g., `ACTIVE`)
- `default_contribution`: initial rate and auto-escalation parameters including `annual_increment_rate` and `cap_rate`
- `eligibility_rules`: minimum employees in state, minimum years in business, qualified-plan exclusion, exempt entity types
- `compliance_deadlines`: employee-count tiers each with `deadline_date` and `is_voluntary` flag
- `penalty_structure`: `evaluation_metric`, `grace_period_days`, penalty `tiers` with `threshold_value` / `amount_per_employee` / `is_cumulative`, `subsequent_period_penalty`, `penalty_multiplier`
- `audit_trail`: `source_urls` and `last_parsed_at` timestamp

---

## FR-D01 — Eligibility Determination Output Schema

The eligibility determination output shall comprise:

- `eligibility_status`: `MANDATED`, `EXEMPT`, or `VOLUNTARY`
- `compliance_status`: `COMPLIANT`, `NON_COMPLIANT`, `ACTION_REQUIRED`, or `GRACE_PERIOD`
- `action_items`: list of applicable actions each with `action_code` and `severity`
- `rationale`: rule-based explanation of the determination

---

## FR-D02 — Employer Data Payload Schema

The employer data payload shall comprise:

- `employer_uuid`
- `company_hq_state`
- `incorporation_date`
- `entity_type`
- `offers_qualified_plan`
- Per-state profiles containing:
  - `employee_count`
  - `operational_status`: `has_registered`, `has_uploaded_roster`, `has_facilitated_deductions`

**Constraint:** The payload must not contain employee contribution amounts, payroll deductions, or financial transactions. Compliance is determined by fulfillment of administrative obligations only.

---

## FR-D07 — Compliance Snapshot Schema

The compliance snapshot per employer shall comprise:

- `employer_uuid`
- `calculated_at`
- `profile_hash` (for deduplication of identical submissions)
- Per-state `evaluations`, each containing:
  - `state_code`
  - `rule_version_id` (identifying the specific rule version used)
  - `eligibility_status`
  - `compliance_status`
  - `applicable_deadline`
  - `action_items` each with `action_code` and `severity`
  - `risk_exposure`:
    - `max_penalty_amount`
    - `calculation_breakdown`: `affected_employees`, `penalty_per_employee`, `is_cumulative_max_reached`, `reasoning_code`

---

## FR-C01 — Compliance Deadline Output Specification

The compliance deadline output shall include:

- `applicable_deadline`: date derived from employee-count-tier matching against the jurisdiction's `compliance_deadlines` array
- Phase type distinction: mandatory vs. voluntary (driven by the `is_voluntary` flag on each tier)

---

## FR-C02 — Penalty Calculation Output Specification

The penalty calculation output shall include:

- `max_penalty_amount`
- `affected_employees`
- `penalty_per_employee`
- `is_cumulative_max_reached`
- `reasoning_code` (e.g., `EXCEEDS_180_DAYS`)
- `evaluation_metric` (e.g., `DAYS_LATE`)
- `grace_period_days` applied before tier escalation
- `subsequent_period_penalty` for ongoing non-compliance
