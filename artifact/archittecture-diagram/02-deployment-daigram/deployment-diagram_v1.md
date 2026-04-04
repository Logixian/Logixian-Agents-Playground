# Container Diagram (C4 Level 2)

> **C4 Level 2** — Shows the internal deployable containers (services, processes, databases) inside the Logixian Compliance Engine. External systems are shown at the boundary.

## 2.1 Component Topology

```mermaid
graph TD
    subgraph External["External Systems"]
        SRS["🌐 State Regulation Sources<br>(HTTP / PDF)"]
        IRA["🏢 IRALOGIX System<br>(REST + Webhook)"]
        CT["👤 IRALOGIX Compliance Team<br>(Action API)"]
    end

    subgraph VPC["☁️ AWS VPC — Logixian"]
        subgraph K8s["Kubernetes Cluster"]
            subgraph AlwaysOn["Always-On (Deployment)"]
                API["🟢 API Server<br>(FastAPI / Python)<br><br>• Receives Push API calls<br>• Serves Query API<br>• Emits webhooks<br>• Orchestrates calculation"]
            end

            subgraph OnDemand["On-Demand (CronJob / Job)"]
                WORKER["🔵 Data Pipeline Worker<br>(Python)<br><br>Triggered: weekly cron<br>Tasks:<br>1. Fetch state sources<br>2. Parse PDF/HTML<br>3. Detect changes<br>4. Stage into DB"]
            end

            subgraph Modules["Internal Modules (within API process)"]
                JIE["📚 Jurisdiction Intelligence Engine<br>(knowledge graph queries)"]
                EDS["⚖️ Eligibility Determination Service<br>(multi-criteria rule evaluation)"]
                CDC["📅 Compliance Deadline Calculator<br>(date arithmetic + phase-in)"]
                MON["🔔 Monitoring & Alert Service<br>(deadline tracking + payload gen)"]
                ONB["🚪 Onboarding Workflow Engine<br>(employer enrollment steps)"]
            end
        end

        subgraph Storage["Storage"]
            DB["🗄️ PostgreSQL (AWS RDS)<br><br>Tables:<br>• jurisdictions / regulations<br>• employers / compliance_snapshots<br>• deadlines / alerts<br>• audit_log"]
        end
    end

    %% External → Internal
    SRS -- "HTTP/PDF<br>(weekly fetch)" --> WORKER
    IRA -- "Push API POST /employers/{id}/profile" --> API
    IRA -- "Query API GET /employers/{id}/snapshot" --> API
    CT -- "Action API POST /regulations/{id}/review" --> API

    %% Internal → External
    API -- "Webhook: pending-review<br>snapshot-ready<br>alert" --> IRA

    %% Internal flows
    WORKER --> JIE
    JIE --> DB
    API --> EDS
    API --> CDC
    API --> MON
    API --> ONB
    EDS --> DB
    CDC --> DB
    MON --> DB
    ONB --> DB
    API --> DB
```

## 2.2 Deployment View

```mermaid
graph TD
    subgraph AWS["☁️ AWS Cloud"]
        subgraph VPC["VPC: logixian-vpc"]
            subgraph Public["Public Subnet"]
                ALB["Application Load Balancer<br>(HTTPS)"]
            end

            subgraph Private["Private Subnet"]
                subgraph K8s["EKS Kubernetes Cluster"]
                    API["API Server Pod<br>(FastAPI)<br>Replicas: 2–4<br>Always-on"]
                    WORKER["Pipeline Worker Pod<br>(Python CronJob)<br>Schedule: 0 2 * * 0<br>(weekly, Sunday 2AM)"]
                end
                RDS["PostgreSQL<br>(AWS RDS)<br>Isolated — no public access"]
            end
        end
    end

    IRALOGIX["🏢 IRALOGIX System"] -- "HTTPS REST + Webhook" --> ALB
    ALB --> API
    API --> RDS
    WORKER --> RDS
    WORKER -- "HTTPS" --> State["🌐 State Regulation Sources"]
```

## Container Descriptions

| Container | Technology | Responsibility | Scaling |
|---|---|---|---|
| **API Server** | Python, FastAPI (async), K8s Deployment | External API surface, request routing, orchestrates calculation modules, emits webhooks | Horizontal: 2–4 replicas behind ALB |
| **Data Pipeline Worker** | Python, K8s CronJob | Weekly ingestion: fetch → parse → diff → stage regulations into PostgreSQL | On-demand, triggered by cron or manual |
| **Jurisdiction Intelligence Engine** | Python module (in-process) | Queries the knowledge graph for applicable rules per state/employer type | Shared with API Server process |
| **Eligibility Determination Service** | Python module (in-process) | Evaluates employer characteristics against loaded rules; returns eligibility + reason | Shared with API Server process |
| **Compliance Deadline Calculator** | Python module (in-process) | Computes deadlines, penalties, and phase-in schedules using effective-date logic | Shared with API Server process |
| **Monitoring & Alert Service** | Python module (in-process) | Tracks snapshot expiry and upcoming deadlines; generates alert payloads | Runs as background task or scheduled job |
| **Onboarding Workflow Engine** | Python module (in-process) | Manages employer onboarding step state machine | Shared with API Server process |
| **PostgreSQL (AWS RDS)** | PostgreSQL 15, AWS RDS | Single source of truth: regulations, compliance snapshots, deadlines, audit log | Vertical scale + read replicas as needed |

## References

- [Context Diagram (C4 Level 1)](../00-context-diagram/context-diagram_v1.md)
- [Sequence Diagram](../01-sequence-diagram/sequence-diagram_v1.md)
