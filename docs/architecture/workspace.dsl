workspace "Logixian Compliance Engine" {

    model {
        # External actors
        iralogix = softwareSystem "IRALOGIX Platform" "IRALOGIX's internal systems that consume compliance data and push employer profiles." "External"
        auth0 = softwareSystem "Auth0" "Authorization server issuing OAuth 2.0 JWTs via Client Credentials flow." "External"
        statePortals = softwareSystem "State Portals" "Official state retirement program websites (CalSavers, IL Secure Choice, etc.)." "External"
        complianceTeam = person "IRALOGIX Compliance Team" "Reviews and approves regulation changes detected by the ingestion pipeline." "External"

        # Logixian system
        logixian = softwareSystem "Logixian Compliance Engine" "Rules engine that evaluates employer compliance across state-mandated retirement programs." {

            # Containers
            apiServer = container "API Server" "Handles all inbound HTTP requests (external and internal), auth, business logic, webhook dispatch. Always-on K8s Deployment." "Python / FastAPI" {

                # Auth boundary
                authMiddleware = component "Auth Middleware" "Validates Auth0 JWTs (external requests) and Ed25519 JWTs (internal requests from Pipeline Worker). Resolves client_id to scopes via client registry." "FastAPI Middleware"

                # External API boundary (IRALOGIX-facing)
                externalAPI = component "External API" "All IRALOGIX-facing endpoints: regulations, employer profiles, compliance snapshots, admin, webhook subscriptions. Contract defined by OpenAPI v0.3.0-draft (IRA-89)." "FastAPI Routers"

                # Internal API boundary (Pipeline Worker-facing)
                internalAPI = component "Internal API" "Pipeline Worker write-back endpoints: POST /internal/compliance-snapshots, POST /internal/employer-profile-snapshots. Authenticated via Ed25519 JWT (ADR-004). Triggers webhook dispatch on snapshot write." "FastAPI Routers"

                # Outbound adapters
                sqsProducer = component "SQS Producer" "Enqueues pipeline trigger messages to pipeline-trigger-queue. Generates idempotency keys. Triggered by employer profile creation and regulation approval." "Adapter"
                webhookDispatcher = component "Webhook Dispatcher" "Delivers signed webhook events to subscriber callback URLs. Ed25519 payload signing (ADR-001). Retry with exponential backoff (1m, 5m, 30m). Dead-letters after 3 failures." "Adapter"

                # Data access
                dataAccess = component "Data Access Layer" "SQLAlchemy ORM. Read/write access to all business tables: employer_profiles, regulations, compliance_snapshots, client_registry, webhook_subscriptions." "SQLAlchemy"
            }

            pipelineWorker = container "Pipeline Worker" "Long-polls SQS for trigger messages (always-on, 1 replica). Runs compliance calculations and regulation ingestion. Writes results back through API Server internal endpoints. Reads DB directly for bulk data (ADR-003)." "Python"
            sqs = container "SQS Queue" "pipeline-trigger-queue + dead-letter queue. Decouples API Server from Pipeline Worker (ADR-002). No callback queue needed." "AWS SQS" "Queue"
            database = container "PostgreSQL" "Stores employer profiles, regulations, compliance snapshots, client registry, webhook subscriptions, pipeline_jobs." "AWS RDS PostgreSQL" "Database"
        }

        # =====================================================================
        # System Context relationships (Level 1)
        # =====================================================================
        iralogix -> logixian "Pushes employer profiles, queries compliance snapshots, manages subscriptions" "HTTPS + Auth0 JWT"
        logixian -> iralogix "Delivers webhook events (regulation changes, snapshot updates, alerts)" "HTTPS + Ed25519"
        statePortals -> logixian "Scraped for regulation data (weekly ingestion)" "HTTPS"
        complianceTeam -> logixian "Reviews and approves/rejects pending regulations" "HTTPS (via IRALOGIX dashboard)"
        auth0 -> logixian "Issues JWTs, provides JWKS for verification" "HTTPS"

        # =====================================================================
        # Container relationships (Level 2)
        # =====================================================================
        # External -> API Server
        iralogix -> apiServer "API calls (employer profiles, regulations, snapshots, admin)" "HTTPS + Auth0 JWT"
        apiServer -> iralogix "Webhook events (regulation.change_detected, compliance.snapshot_updated, compliance.alert)" "HTTPS + Ed25519"
        auth0 -> apiServer "JWKS endpoint for JWT verification" "HTTPS"
        complianceTeam -> apiServer "Approve/reject pending regulations" "HTTPS"

        # API Server <-> SQS <-> Pipeline Worker
        apiServer -> sqs "Enqueues trigger messages (profile created, regulation approved)" "AWS SDK"
        pipelineWorker -> sqs "Long-polls for trigger messages" "AWS SDK"

        # Pipeline Worker -> API Server (write-back, no callback queue)
        pipelineWorker -> apiServer "Writes compliance snapshots via internal endpoints" "HTTP + Ed25519 JWT"

        # DB access (ADR-003: hybrid)
        apiServer -> database "Full read/write access" "SQLAlchemy"
        pipelineWorker -> database "Direct reads only (employer profiles, regulations). Writes go through API Server." "SQLAlchemy (read-only)"

        # Pipeline Worker -> State Portals (ingestion)
        pipelineWorker -> statePortals "Scrapes regulation data" "HTTPS"

        # =====================================================================
        # Component relationships (Level 3 - inside API Server)
        # =====================================================================
        # External -> Auth Middleware
        iralogix -> authMiddleware "Sends requests with Auth0 JWT" "HTTPS"
        auth0 -> authMiddleware "JWKS endpoint for JWT verification" "HTTPS"

        # Auth Middleware -> API boundaries
        authMiddleware -> externalAPI "Authenticated external request (Auth0 JWT + scopes)" ""
        authMiddleware -> internalAPI "Authenticated internal request (Ed25519 JWT)" ""

        # External API -> outbound
        externalAPI -> sqsProducer "Triggers recalculation (profile created, regulation approved)" ""
        externalAPI -> dataAccess "Reads/writes business data" ""
        externalAPI -> webhookDispatcher "Emits regulation.change_detected events" ""

        # Internal API -> outbound
        internalAPI -> dataAccess "Persists compliance snapshots from Pipeline Worker" ""
        internalAPI -> webhookDispatcher "Emits compliance.snapshot_updated on snapshot write" ""

        # Adapters -> external containers
        sqsProducer -> sqs "Sends trigger messages" "AWS SDK"
        webhookDispatcher -> iralogix "Delivers signed webhook events" "HTTPS + Ed25519"
        dataAccess -> database "SQL queries" "SQLAlchemy"

        # Pipeline Worker -> Auth Middleware (internal write-back)
        pipelineWorker -> authMiddleware "Writes compliance snapshots" "HTTP + Ed25519 JWT"
        pipelineWorker -> sqs "Polls for trigger messages" "AWS SDK"
        pipelineWorker -> database "Direct reads (employer profiles, regulations)" "SQLAlchemy (read-only)"
    }

    views {
        # Level 1: System Context
        systemContext logixian "SystemContext" {
            include *
            autoLayout tb 400 200
        }

        # Level 2: Container
        container logixian "Containers" {
            include *
            autoLayout lr 400 200
        }

        # Level 3: Component (API Server internals)
        component apiServer "APIServerComponents" {
            include *
            autoLayout lr 300 100
        }

        styles {
            element "Software System" {
                background #1168BD
                color #ffffff
                shape RoundedBox
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Person" {
                background #08427B
                color #ffffff
                shape Person
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "Component" {
                background #85BBF0
                color #000000
            }
            element "Database" {
                shape Cylinder
            }
            element "Queue" {
                shape Pipe
            }
            element "Adapter" {
                background #F5DA81
                color #000000
            }
            element "SQLAlchemy" {
                background #C3E6CB
                color #000000
            }
            element "FastAPI Routers" {
                background #85BBF0
            }
            element "FastAPI Middleware" {
                background #D4A5F5
                color #000000
            }
        }
    }

}
