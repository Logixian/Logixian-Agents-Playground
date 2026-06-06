# Sequence diagram

## Part 1: High-Level Data Flow

```mermaid
%%{init: {'theme': 'dark'}}%%
flowchart LR
    %% Define Nodes
    State["Regulation Data Sources<br/>(CA, NY, IL, NJ, MN)<br/><i>State program websites</i>"]
    LX((Logixian Engine))
    IRA[IRALOGIX<br/>Internal System]

    %% 1. From State to Engine
    State -->|"(1) Auto-Fetch (Periodic)"| LX

    %% 2. Logixian Engine TO IRALOGIX (Push/Webhooks)
    LX -->|"(2) Webhook: Pending Review<br/>(5) Webhook: Snapshot Ready<br/>(7) Event Payload: Alerts"| IRA

    %% 3. IRALOGIX TO Logixian Engine (API Calls)
    IRA -->|"(3) Action API: Approve/Reject<br/>(4) Push API: UUID + Metrics + Timestamps (No PII)<br/>(6) Query API: Fetch Snapshot"| LX

    %% Styling for Dark Mode
    classDef engine fill:#1e3a8a,stroke:#60a5fa,stroke-width:2px,color:#ffffff;
    classDef client fill:#4c1d95,stroke:#c084fc,stroke-width:2px,color:#ffffff;
    classDef source fill:#374151,stroke:#9ca3af,stroke-width:2px,color:#ffffff;

    class LX engine;
    class IRA client;
    class State source;
```

## Part 2: Core Assumptions for Validation

### 1. The Two-Phase Data Pipeline

The Engine's heavy workloads are strictly decoupled into two phases to optimize performance and costs:

- **Phase 1 (Ingestion):** Runs on a periodic scheduled job to fetch and parse raw regulations from state program websites into 'Pending' structured data.
- **Phase 2 (Calculation):** Is **strictly reactive**. Compliance calculations are only triggered when your team explicitly approves a rule or pushes an employer profile update.

### 2. Regulation Updates & The Unified Model

The system automatically tracks state regulations from program websites (e.g., CalSavers FAQ). Detected changes require a 'Human-in-the-Loop' approval before taking effect.

- Proposed Interface
  - `[Logixian → IRALOGIX]` **Webhook:** "New regulation changes are pending your review."
  - `[IRALOGIX -> Logixian]` **Action API:** Approve or reject pending rules.
  - `[IRALOGIX -> Logixian]` **Query API:** Fetch details of active or pending regulations for your internal dashboard.

```mermaid
%%{init: {'theme': 'dark'}}%%
sequenceDiagram
    autonumber
    participant State as Regulation Data Source
    participant LX as Logixian Engine
    participant IRA as IRALOGIX System

    Note over State,IRA: Phase 1: Scheduled Ingestion & Parsing (Cron Job)
    LX->>State: Auto-Fetch Regulations (periodic schedule)
    State-->>LX: Raw Document Data (PDF/HTML — from program websites)
    LX-->>LX: Trigger Phase 1 Ingestion
    LX->>IRA: [Webhook] Structured rules pending review

    Note over State,IRA: Phase 2: Human-in-the-Loop & Calculation (Reactive)
    IRA->>LX: [Action API] Approve pending rules
    LX-->>LX: Trigger Phase 2 Calculation

```

### 3. Client Data Boundary & Privacy

To comply with strict PII protection policies, the Engine will **NOT** store identifiable employer data. We will only store an "Anonymized Compliance Profile" using a reference UUID.

- **Proposed Interface:**
  - `[IRALOGIX -> Logixian]` **Push Employer Profile:** Sends `Employer_UUID`, required metrics (e.g., `Employee_Count`), and compliance-relevant action timestamps (`registration_date`, `roster_upload_date`, `payroll_deduction_date`). No names or contact info.

```mermaid
%%{init: {'theme': 'dark'}}%%
sequenceDiagram
    autonumber
    participant LX as Logixian Engine
    participant IRA as IRALOGIX System

    Note over LX,IRA: Scenario 3: Client Profile Updates
    IRA->>LX: [Push API] Employer_UUID, Metrics & Compliance Timestamps (No PII)
    LX-->>LX: Trigger Phase 2 Calculation
```

### 4. Delivering Results: Integration Pattern

When a calculation is finished, the Engine produces a "**Compliance Snapshot**" mapping the `Employer UUID` to their `[Action Items, Deadlines, Penalties]`.

- **Proposed Interface Options:**
  - **Option A (Polling):** `[IRALOGIX -> Logixian]` **Query API:** IRALOGIX periodically asks "Give me the latest snapshot for UUID X."
  - **Option B (Event-Driven):** `[Logixian -> IRALOGIX]` **Webhook:** "Snapshot updated for UUID X" → *followed by* → `[IRALOGIX -> Logixian]` **Query API** to fetch the exact details.

```mermaid
%%{init: {'theme': 'dark'}}%%
sequenceDiagram
    autonumber
    participant LX as Logixian Engine
    participant IRA as IRALOGIX System

    Note over LX,IRA: Scenario 4: Delivering Results (Assuming Option B)
    LX->>IRA: [Webhook] Snapshot updated for UUID X
    IRA->>LX: [Query API] Fetch latest snapshot
    LX-->>IRA: Returns [Action Items, Deadlines, Penalties]
```

### 5. Alerting Responsibility

Our Engine determines ***when*** an alert is needed based on deadlines, but it will **not** send emails directly to end-employers.

- **Proposed Interface:**
  - `[Logixian -> IRALOGIX]` **Event Payload:** Sends the alert context (e.g., "UUID 1234: 30 days until deadline") to your existing notification service.

```mermaid
%%{init: {'theme': 'dark'}}%%
sequenceDiagram
    autonumber
    participant LX as Logixian Engine
    participant IRA as IRALOGIX System

    Note over LX,IRA: Scenario 5: Alerting Responsibility
    LX->>IRA: [Event Payload] Alert Context (e.g., 30 days until deadline)
    Note over IRA: IRALOGIX handles actual<br/>email delivery to employer
```

---

### Detail

## Sequence Diagrams — Use Cases

---

## UC-01: Regulatory Data Ingestion + Human-in-the-Loop Review

**Requirements covered:** FR-I01 (knowledge database), FR-I02 (periodic ingest), FR-I03 (state program websites), FR-I08 (human review), FR-I09 (detect changes)
**Trigger:** Periodic cron (e.g., weekly Sunday 2AM)

```mermaid
sequenceDiagram
    participant CRON as ⏰ Scheduler (CronJob)
    participant WORKER as 🔵 Data Pipeline Worker
    participant SRS as 🌐 State Regulation Sources
    participant DB as 🗄️ PostgreSQL
    participant API as 🟢 API Server
    participant CT as 👤 IRALOGIX Compliance Team

    CRON ->> WORKER: trigger periodic ingestion job

    loop For each state (5–27 states)
        WORKER ->> SRS: HTTP GET program website / PDF download<br>(e.g., CalSavers FAQ page)
        SRS -->> WORKER: raw HTML / PDF document

        WORKER ->> WORKER: parse document<br>(Docling / HTML parser)
        WORKER ->> DB: load staged_regulations (status=PENDING)

        WORKER ->> DB: diff vs current approved rules
        alt New or changed rules detected
            WORKER ->> DB: mark rules as PENDING_REVIEW
            WORKER ->> API: notify: rules ready for review
            API ->> CT: Webhook POST /webhooks<br>{event: "rules_pending_review", count: N}
        else No changes detected
            WORKER ->> DB: update last_checked_at timestamp
        end
    end

    Note over CT: Human reviewer evaluates each rule

    alt Compliance Team Approves
        CT ->> API: POST /regulations/{id}/review<br>{action: "approve"}
        API ->> DB: set regulation status = APPROVED,<br>effective_date = now()
        API ->> API: trigger compliance recalculation<br>for affected employers
    else Compliance Team Rejects
        CT ->> API: POST /regulations/{id}/review<br>{action: "reject", reason: "..."}
        API ->> DB: set regulation status = REJECTED
        Note over DB: Rejected rules never enter active compliance logic
    end
```

---

## UC-02: Employer Profile Push & Eligibility Determination

**Requirements covered:** FR-D01 (evaluate employer), FR-D02 (store employer data + compliance-relevant timestamps), FR-O01 (API endpoint)
**Trigger:** IRALOGIX pushes employer data (new employer or profile change)

```mermaid
sequenceDiagram
    participant IRA as 🏢 IRALOGIX System
    participant API as 🟢 API Server
    participant JIE as 📚 Jurisdiction Intelligence Engine
    participant EDS as ⚖️ Eligibility Determination Service
    participant DB as 🗄️ PostgreSQL

    IRA ->> API: POST /employers/{uuid}/profile<br>{state, employee_count, industry,<br>business_start_date,<br>registration_date,<br>roster_upload_date,<br>payroll_deduction_date}<br>(no PII — UUID only)

    API ->> API: validate request schema

    alt Invalid payload
        API -->> IRA: 400 Bad Request<br>{error: "missing required field: state"}
    else Valid payload
        API ->> JIE: load applicable regulations<br>for employer.state
        JIE ->> DB: SELECT regulations WHERE<br>state = ? AND status = APPROVED<br>AND effective_date <= now()
        DB -->> JIE: regulation rules[]
        JIE -->> API: applicable_rules[]

        API ->> EDS: evaluate(employer_profile, applicable_rules)
        EDS ->> EDS: multi-criteria rule evaluation<br>(employee count, industry, date thresholds,<br>compliance action timestamps)

        alt Employer is ELIGIBLE
            EDS -->> API: {eligible: true, matched_rules: [...], reason: "..."}
            API ->> DB: upsert eligibility_decisions<br>{uuid, eligible=true, rules, timestamp}
            API -->> IRA: 202 Accepted<br>{status: "processing"}
            Note over API: Async: triggers UC-03 (Deadline Calc)
        else Employer is NOT ELIGIBLE
            EDS -->> API: {eligible: false, reason: "employee_count < threshold"}
            API ->> DB: upsert eligibility_decisions<br>{uuid, eligible=false, reason, timestamp}
            API -->> IRA: 202 Accepted<br>{status: "not_eligible"}
        else Missing data — cannot determine
            EDS -->> API: {eligible: null, reason: "missing: industry"}
            API -->> IRA: 202 Accepted<br>{status: "incomplete", missing_fields: ["industry"]}
        end
    end
```

---

## UC-03: Compliance Deadline Calculation

**Requirements covered:** FR-C01 (calculate deadlines), FR-C02 (penalty exposure), FR-C03 (rolling/phased deadlines)
**Trigger:** Fired automatically after UC-02 determines eligibility = true, OR after a regulation is approved in UC-01

```mermaid
sequenceDiagram
    participant API as 🟢 API Server
    participant JIE as 📚 Jurisdiction Intelligence Engine
    participant CDC as 📅 Compliance Deadline Calculator
    participant DB as 🗄️ PostgreSQL

    API ->> JIE: load deadline rules<br>for employer.state
    JIE ->> DB: SELECT deadline_rules, penalty_schedules<br>WHERE state = ? AND status = APPROVED
    DB -->> JIE: deadline_rules[]
    JIE -->> API: deadline_rules[]

    API ->> CDC: calculate(employer_profile, deadline_rules)

    CDC ->> CDC: compute registration deadline<br>using business_start_date + threshold_days
    CDC ->> CDC: evaluate compliance window<br>using registration_date, roster_upload_date,<br>payroll_deduction_date vs. deadline
    CDC ->> CDC: compute phase-in schedule<br>(if applicable by state)
    CDC ->> CDC: compute penalty amounts<br>(per-day or flat fee by rule)

    alt Deadlines computed successfully
        CDC -->> API: {deadlines: [...], penalties: [...],<br>phase_in_schedule: [...]}
        API ->> DB: upsert compliance_snapshots<br>{uuid, action_items, deadlines,<br>penalties, snapshot_at=now()}
        Note over DB: Snapshot is now queryable by IRALOGIX
    else Calculation error (missing base date)
        CDC -->> API: {error: "business_start_date required"}
        API ->> DB: log error in audit_log
        Note over API: No snapshot written; IRALOGIX<br> notified via next profile push retry
    end
```

---

## UC-04: Compliance Snapshot Retrieval

**Requirements covered:** FR-D01 (provide output: action items, deadlines, penalties)
**Trigger:** IRALOGIX receives webhook ⑤ (snapshot-ready) OR polls on demand

```mermaid
sequenceDiagram
    participant IRA as 🏢 IRALOGIX System
    participant API as 🟢 API Server
    participant DB as 🗄️ PostgreSQL

    Note over API,IRA: Path A — Webhook-driven (recommended)
    API ->> IRA: Webhook POST /webhooks<br>{event: "snapshot_ready",<br> employer_uuid: "abc-123",<br> snapshot_id: "snap-456"}

    IRA ->> API: GET /employers/abc-123/snapshot<br>?snapshot_id=snap-456<br>Authorization: Bearer <token>

    API ->> DB: SELECT * FROM compliance_snapshots<br>WHERE employer_uuid = ?<br>AND id = ?
    DB -->> API: snapshot row

    alt Snapshot found
        API -->> IRA: 200 OK<br>{<br>  action_items: [...],<br>  deadlines: [...],<br>  penalties: [...],<br>  snapshot_at: "2026-02-21T10:00:00Z",<br>  regulation_version: "v2.3"<br>}
    else Snapshot not found
        API -->> IRA: 404 Not Found<br>{error: "snapshot not yet available"}
        Note over IRA: Retry after short delay
    end

    Note over API,IRA: Path B — On-demand polling (fallback)
    IRA ->> API: GET /employers/abc-123/snapshot/latest
    API ->> DB: SELECT * FROM compliance_snapshots<br>WHERE employer_uuid = ?<br>ORDER BY snapshot_at DESC LIMIT 1
    DB -->> API: latest snapshot row
    API -->> IRA: 200 OK { ... latest snapshot ... }
```

---

## UC-05: Compliance Alerting (Payload Generation)

**Requirements covered:** FR-M01 (track compliance status), FR-M02 (send notifications), FR-M03 (structured alert payloads)
**Trigger:** Monitoring service detects an employer deadline is approaching (e.g., ≤30 / ≤7 days away)
**Note:** Logixian generates the alert payload only. IRALOGIX owns final delivery (email/UI/SMS).

```mermaid
sequenceDiagram
    participant MON as 🔔 Monitoring & Alert Service
    participant DB as 🗄️ PostgreSQL
    participant API as 🟢 API Server
    participant IRA as 🏢 IRALOGIX System

    loop Daily check (background task)
        MON ->> DB: SELECT compliance_snapshots<br>WHERE deadline BETWEEN now()<br>AND now() + INTERVAL '30 days'<br>AND alert_sent = false
        DB -->> MON: upcoming_deadlines[]

        loop For each upcoming deadline
            MON ->> MON: build alert payload<br>{employer_uuid, deadline_type,<br>days_remaining, required_action,<br>penalty_if_missed}

            MON ->> DB: INSERT INTO alert_events<br>(uuid, payload, triggered_at)

            MON ->> API: emit alert
            API ->> IRA: Webhook POST /webhooks<br>{event: "compliance_alert",<br> employer_uuid: "...",<br> days_remaining: 28,<br> deadline_type: "registration",<br> required_action: "...",<br> penalty_if_missed: "$250/day"}

            alt IRALOGIX acknowledges
                IRA -->> API: 200 OK
                API ->> DB: UPDATE alert_events<br>SET delivered = true, ack_at = now()
            else IRALOGIX fails / timeout
                IRA -->> API: 5xx / timeout
                API ->> DB: UPDATE alert_events<br>SET retry_count = retry_count + 1
                Note over API: Retry with exponential backoff<br>(max 3 attempts)
            end

            MON ->> DB: UPDATE compliance_snapshots<br>SET alert_sent = true<br>WHERE id = ?
        end
    end
```

---

## References

- [Architecture Driver](../../architecture-driver/requirement_v7.md) — FR-I, FR-D, FR-C, FR-M requirement IDs referenced in each use case header
- [Context Diagram (C4 Level 1)](../00-context-diagram/context-diagram_v2.md) — System boundary, external actors, and the eight numbered interface flows that these sequences implement

---

## Changelog (v1 → v2)

| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
| **Updated** — Part 1 High-Level Data Flow: changed "Weekly" to "Periodic" for auto-fetch label; added "State program websites" sub-label to State node | Part 1 | requirement_v7.md — FR-I03 update | FR-I03 confirmed source is program websites; frequency is operational configuration (FR-I02 v6 update) |
| **Updated** — Part 2 section 1: changed "weekly scheduled job" to "periodic scheduled job" and added "state program websites" | Part 2 §1 | requirement_v7.md — FR-I03 update | Source type is architecturally significant for LLM parsing strategy |
| **Updated** — Part 2 section 2 intro: replaced "1-week latency" with "program websites (e.g., CalSavers FAQ)" | Part 2 §2 | requirement_v7.md — FR-I03 update | Detection latency is operational; source type is structurally significant |
| **Updated** — Part 2 section 3: Push API description updated to include compliance-relevant timestamps | Part 2 §3 | requirement_v7.md — FR-D02 update | Brad clarified compliance deadlines are time-window-based; system must know when each action occurred |
| **Updated** — UC-01 requirements header: updated trigger annotation from "Weekly cron (Sunday 2AM)" to "Periodic cron"; updated fetch step to reference "program website / PDF download (e.g., CalSavers FAQ page)" | UC-01 | requirement_v7.md — FR-I03 update | Reflects confirmed source type; frequency is configuration |
| **Updated** — UC-02 payload: added `registration_date`, `roster_upload_date`, `payroll_deduction_date` to `POST /employers/{uuid}/profile` message body | UC-02 | requirement_v7.md — FR-D02 update | These timestamps are compliance-relevant actions required to evaluate time-window-based compliance; crosses the API boundary |
| **Updated** — UC-02 EDS evaluation step: added "compliance action timestamps" to multi-criteria evaluation note | UC-02 | requirement_v7.md — FR-D02 update | Eligibility determination now factors in when actions occurred, not just what employer characteristics are |
| **Updated** — UC-03 calculation steps: added "evaluate compliance window using registration_date, roster_upload_date, payroll_deduction_date vs. deadline" step | UC-03 | requirement_v7.md — FR-D02 update | Deadline calculator must compare actual action timestamps against phase-in deadlines to determine compliance status |
| **Updated** — References: point to requirement_v7 and context-diagram_v2 | References | requirement_v7.md | Version alignment |

> [HUMAN REVIEW REQUIRED] — Verify all Mermaid diagrams render correctly and that
> changes align with the current architecture driver baseline before accepting this
> as the new version.

## References

- [Architecture Driver](../../architecture-driver/requirement_v7.md)
