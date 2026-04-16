workspace "Logixian API Server — Component View" {

    model {
        # External actors
        iralogix = softwareSystem "IRALOGIX Platform" "IRALOGIX's internal systems that consume compliance data and push employer profiles." "External"
        auth0 = softwareSystem "Auth0" "Authorization server issuing OAuth 2.0 JWTs via Client Credentials flow." "External"
        statePortals = softwareSystem "State Portals" "Official state retirement program websites (CalSavers, IL Secure Choice, etc.)." "External"

        # Logixian system
        logixian = softwareSystem "Logixian Compliance Engine" "Rules engine that evaluates employer compliance across state-mandated retirement programs." {

            # Containers
            apiServer = container "API Server" "Handles all inbound HTTP requests (external and internal), auth, business logic, webhook dispatch." "Python / FastAPI" {

                # Request handling
                authMiddleware = component "Auth Middleware" "Validates Auth0 JWTs (external) and Ed25519 JWTs (internal). Resolves client_id to scopes via client registry." "FastAPI Middleware"
                regulationRoutes = component "Regulation Routes" "GET /regulations, POST approve/reject/modify. Serves regulation data to IRALOGIX compliance team." "FastAPI Router"
                employerRoutes = component "Employer Routes" "POST /employers/{uuid}/profiles, GET .../profiles/{version|latest}. Append-only versioned profiles." "FastAPI Router"
                complianceRoutes = component "Compliance Routes" "GET /employers/{uuid}/snapshot, GET .../snapshot/history. Returns compliance evaluation results." "FastAPI Router"
                adminRoutes = component "Admin Routes" "POST/PUT/DELETE /admin/clients. Client registry and scope management." "FastAPI Router"
                webhookMgmtRoutes = component "Webhook Management Routes" "POST/PUT/DELETE /webhooks/subscriptions. Manages callback registrations." "FastAPI Router"
                internalRoutes = component "Internal Routes" "POST /internal/compliance-snapshots. Pipeline Worker writes results back through these endpoints." "FastAPI Router"

                # Service layer
                regulationService = component "Regulation Service" "CRUD for regulation rules. Handles approval workflow (PENDING -> ACTIVE/REJECTED). Triggers recalculation on approval." "Service"
                employerService = component "Employer Service" "Creates new profile versions (append-only). Triggers compliance recalculation via SQS on each new version." "Service"
                complianceService = component "Compliance Service" "Reads compliance snapshots. Handles snapshot writes from Pipeline Worker (internal endpoint)." "Service"
                clientRegistryService = component "Client Registry Service" "Maps client_id to scopes. Manages client lifecycle (register, update, soft-delete, enable/disable)." "Service"
                webhookService = component "Webhook Service" "Manages subscriptions. Dispatches webhook events with Ed25519 signing and exponential backoff retry." "Service"

                # Adapters
                sqsProducer = component "SQS Producer" "Enqueues pipeline trigger messages to SQS. Generates idempotency keys. Handles SQS unavailability." "Adapter"
                webhookDispatcher = component "Webhook Dispatcher" "Signs payloads with Ed25519, delivers to subscriber callback URLs. Retries on 5xx/timeout (1m, 5m, 30m). Dead-letters after 3 failures." "Adapter"

                # Repository layer
                regulationRepo = component "Regulation Repository" "Read/write access to regulations and approved_regulations tables." "SQLAlchemy"
                employerRepo = component "Employer Repository" "Read/write access to employer_profiles table. Append-only version inserts." "SQLAlchemy"
                complianceRepo = component "Compliance Repository" "Read/write access to compliance_snapshots table." "SQLAlchemy"
                clientRepo = component "Client Repository" "Read/write access to client_registry table." "SQLAlchemy"
                webhookRepo = component "Webhook Repository" "Read/write access to webhook_subscriptions and webhook_deliveries tables." "SQLAlchemy"
            }

            pipelineWorker = container "Pipeline Worker" "Long-polls SQS for trigger messages. Runs compliance calculations. Writes results back through API Server internal endpoints." "Python"
            sqs = container "SQS Queue" "pipeline-trigger-queue + dead-letter queue. Decouples API Server from Pipeline Worker." "AWS SQS" "Queue"
            database = container "PostgreSQL" "Stores employer profiles, regulations, compliance snapshots, client registry, webhook subscriptions, pipeline_jobs." "AWS RDS PostgreSQL" "Database"
        }

        # Relationships: External -> API Server components
        iralogix -> authMiddleware "Sends requests with Auth0 JWT" "HTTPS"
        auth0 -> authMiddleware "JWKS endpoint for JWT signature verification" "HTTPS"

        # Auth middleware -> routes
        authMiddleware -> regulationRoutes "Authenticated request" ""
        authMiddleware -> employerRoutes "Authenticated request" ""
        authMiddleware -> complianceRoutes "Authenticated request" ""
        authMiddleware -> adminRoutes "Authenticated request (admin scope)" ""
        authMiddleware -> webhookMgmtRoutes "Authenticated request" ""
        authMiddleware -> internalRoutes "Authenticated request (Ed25519 JWT)" ""

        # Routes -> services
        regulationRoutes -> regulationService "Delegates business logic" ""
        employerRoutes -> employerService "Delegates business logic" ""
        complianceRoutes -> complianceService "Delegates business logic" ""
        adminRoutes -> clientRegistryService "Delegates business logic" ""
        webhookMgmtRoutes -> webhookService "Delegates business logic" ""
        internalRoutes -> complianceService "Pipeline write-back" ""

        # Services -> repos
        regulationService -> regulationRepo "Reads/writes regulations" ""
        employerService -> employerRepo "Appends profile versions" ""
        complianceService -> complianceRepo "Reads/writes snapshots" ""
        clientRegistryService -> clientRepo "Manages client records" ""
        webhookService -> webhookRepo "Manages subscriptions and delivery logs" ""

        # Services -> adapters
        employerService -> sqsProducer "Enqueues recalculation trigger on new profile version" ""
        regulationService -> sqsProducer "Enqueues bulk recalculation on regulation approval" ""
        complianceService -> webhookService "Notifies on snapshot update" ""
        regulationService -> webhookService "Notifies on regulation change" ""

        # Adapters -> external
        sqsProducer -> sqs "Sends trigger messages" "AWS SDK"
        webhookDispatcher -> iralogix "Delivers signed webhook events" "HTTPS + Ed25519"

        # Webhook service -> dispatcher
        webhookService -> webhookDispatcher "Dispatches events" ""

        # Repos -> database
        regulationRepo -> database "SQL queries" "SQLAlchemy"
        employerRepo -> database "SQL queries" "SQLAlchemy"
        complianceRepo -> database "SQL queries" "SQLAlchemy"
        clientRepo -> database "SQL queries" "SQLAlchemy"
        webhookRepo -> database "SQL queries" "SQLAlchemy"

        # Pipeline -> API Server (internal)
        pipelineWorker -> internalRoutes "Writes compliance snapshots" "HTTP + Ed25519 JWT"
        pipelineWorker -> sqs "Polls for trigger messages" "AWS SDK"
        pipelineWorker -> database "Direct reads (employer profiles, regulations)" "SQLAlchemy"
    }

    views {
        component apiServer "APIServerComponents" {
            include *
            autoLayout lr 300 100
        }

        styles {
            element "Software System" {
                background #999999
                color #ffffff
                shape RoundedBox
            }
            element "External" {
                background #999999
                color #ffffff
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
            element "Service" {
                background #85BBF0
            }
            element "Adapter" {
                background #F5DA81
                color #000000
            }
            element "SQLAlchemy" {
                background #C3E6CB
                color #000000
            }
            element "FastAPI Router" {
                background #85BBF0
            }
            element "FastAPI Middleware" {
                background #D4A5F5
                color #000000
            }
        }
    }

}
