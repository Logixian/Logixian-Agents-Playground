workspace "Logixian Compliance Engine" "Logixian Compliance Engine" {
    !identifiers hierarchical
    model {

        # ── People (Indirect — interact via IRALOGIX Platform) ──
        iralogixCT = person "IRALOGIX Compliance Team" "Compliance staff with strong experience in regulatory rules." {
            tags "Indirect"
        }
        iralogixAdmin = person "IRALOGIX Admin Team" "Administrative staff responsible for managing system." {
            tags "Indirect"
        }
        iralogixCustomer = person "IRALOGIX Customer Team" "Handles employer onboarding and relays compliance results to employers." {
            tags "Indirect"
        }

        # ── Software Systems ──

        # Logixian Compliance Engine (internal)
        lce = softwareSystem "Logixian Compliance Engine" "Rules engine that evaluates employer compliance across state-mandated retirement programs." {
            tags "Internal"

            apiServer = container "API Server" "External API surface. Auth, business logic, and the in-process Compliance Engine: synchronous, user-initiated eligibility + compliance evaluation over event-sourced sessions. Internal write-back endpoints + webhook dispatch." "Python / FastAPI" {

                authMiddleware = component "Auth Middleware" "Validates external Auth0 JWTs and internal Ed25519 JWTs; resolves scopes." "FastAPI Middleware"

                externalAPI = component "External API" "IRALOGIX-facing route handlers (Auth0 JWT, scoped). Employers ↔ sessions ↔ events." "FastAPI Routers"

                complianceEngine = component "Compliance Engine" "IRA-230 stateless facade (in-process library). Verbs: start / append / view (create-session / append-event / project). Eligibility is a projected stage of the same session, not a separate verb. Per request it reconstructs the session from its event log via the ports and runs the projector; holds NO session state. Synchronous, user-initiated. No worker, no queue." "Python"

                projector = component "Projector" "Pure core. project(bundle, events) gives frontier / gates / outcome / snapshot. Deterministic, no I/O. Snapshot + payload are provisional on read, materialised on seal." "Python" {
                    tags "EngineInternal,Pure"
                }

                bundleStore = component "Bundle Store (port)" "Loads a sealed bundle by (state, rule_version). Backing is pluggable: static JSON / Git for the POC (versioned + PR-reviewed), DB later only if hot rule updates are needed." "Port" {
                    tags "EngineInternal,Port"
                }

                sessionStore = component "Session Store (port)" "Session row pins (state, rule_version, locale, catalog_version) at create = the single source of version truth; its append-only event log (versionless node/value events) is the answer truth. load() returns row + log in one read. Holds the materialised snapshot + payload projections. Backed by Postgres. Optimistic concurrency deferred (v2)." "Port" {
                    tags "EngineInternal,Port"
                }

                internalAPI = component "Internal API" "Write-back route handlers for the Pipeline Worker (Ed25519 JWT): staged regulations + alert events." "FastAPI Routers"

                webhookDispatcher = component "Webhook Dispatcher" "Signs and delivers webhook events; exponential-backoff retry." "Adapter"

                dataAccess = component "Data Access Layer" "SQLAlchemy ORM for all business tables." "SQLAlchemy"
            }

            cron = container "Scheduler" "K8s CronJobs that invoke the Pipeline Worker directly (no queue hop). Two schedules: weekly regulation scan (Phase 1 ingestion) and daily employer-session alert scan." "K8s CronJob" {
                tags "Container"
            }

            pipelineWorker = container "Pipeline Worker" "Cron-only batch worker. Two scheduled jobs: weekly regulation ingestion (scan state sources for new/changed rules) and a daily alert scan over employer sessions/snapshots. Performs NO compliance calculation — all compliance is user-initiated in the API Server." "Python" {

                triggerRouter = component "Trigger Router" "Dispatches by cron schedule: weekly → Ingestion, daily → Alert Scanner." "Python Entrypoint"

                scraper = component "Scraper" "Fetches raw HTML/PDF from configured state-source scopes." "HTTP Client"

                sourceStore = component "Source Store & Differ" "Writes raw to S3; reads prior object; content-hash compare for short-circuit." "S3 Client"

                llmOrchestrator = component "LLM Orchestrator" "Bedrock calls: LLM-1 (source resolution) and LLM-2 (rule parsing)." "Bedrock Client"

                alertScanner = component "Alert Scanner" "Walks sealed snapshots and per-employer standing: graduated deadline schedule (30/7/1) plus stale-rule-version detection. Emits compliance.alert and compliance.input_required. No calculation." "Python"

                apiClient = component "API Client" "Ed25519-JWT write-back to API Server internal endpoints." "HTTP Client"
            }

            db = container "PostgreSQL Database" "Source of truth: employers, sessions, session_events (append-only log), regulations, client_registry, webhook_subscriptions, alert_events. compliance_snapshots + employer_payloads are materialised projections (cache), frozen at seal — not independent truth." "PostgreSQL 17 / AWS RDS" {
                tags "Database"
            }

            s3 = container "Raw Source Archive" "Original PDFs/HTML with provenance metadata. Phase 1 stores scraped content and compares against the prior object hash to short-circuit LLM calls when content is unchanged." "AWS S3" {
                tags "Database"
            }
        }

        # IRALOGIX Platform — external portal hosting compliance + admin UIs
        iralogixPlatform = softwareSystem "IRALOGIX Platform" "IRALOGIX's internal systems. Serves as the portal for employers, compliance, and admin." {
            tags "External"
        }

        # Auth0 — external authorization server
        auth0 = softwareSystem "Auth0" "Authorization server issuing OAuth 2.0 JWTs via Client Credentials flow." {
            tags "External"
        }

        # State Portals — scraped regulation sources
        statePortals = softwareSystem "State Portals" "Official state retirement program websites (e.g. CalSavers, IL Secure Choice)." {
            tags "External"
        }

        # AWS Bedrock — managed LLM service for Phase 1 parsing and source resolution
        bedrock = softwareSystem "AWS Bedrock" "Managed LLM service. LLM-1 resolves/repairs broken data sources (Phase 1a). LLM-2 parses scraped raw content into the rule schema (Phase 1b)." {
            tags "External"
        }

        # ────────────────────────────────────────────────────────────────
        # System Context relationships (Level 1)
        # ────────────────────────────────────────────────────────────────

        iralogixCT -> iralogixPlatform "Reviews/Approves/Rejects regulation"
        iralogixAdmin -> iralogixPlatform "Registers and manages IRALOGIX users"
        iralogixCustomer -> iralogixPlatform "Onboards employer accounts; relays compliance results to employers"

        # ────────────────────────────────────────────────────────────────
        # Container-level relationships (Level 2)
        # ────────────────────────────────────────────────────────────────

        # IRALOGIX Platform <-> API Server
        iralogixPlatform -> lce.apiServer "Manages employer data, walks compliance sessions, onboarding" "JSON/HTTPS + Auth0 JWT"
        lce.apiServer -> iralogixPlatform "Dispatches webhooks (regulation.change_detected, compliance.input_required, compliance.snapshot_updated, compliance.alert)" "HTTPS + Ed25519"

        # Auth0 -> API Server
        auth0 -> lce.apiServer "Issues JWTs, JWKS endpoint for JWT verification" "HTTPS"

        # API Server -> internal containers
        lce.apiServer -> lce.db "Reads/writes business data (sessions, events, projections, regulations)" "PostgreSQL protocol"

        # Scheduler -> Pipeline Worker (direct; NO queue)
        lce.cron -> lce.pipelineWorker "Weekly regulation scan / Phase 1 ingestion (K8s CronJob creates worker pod)"
        lce.cron -> lce.pipelineWorker "Daily employer-session alert scan (K8s CronJob creates worker pod)"

        # Pipeline Worker — outbound
        lce.pipelineWorker -> statePortals "Scrapes raw regulation data (HTML/PDF) — Phase 1" "HTTPS"
        lce.pipelineWorker -> bedrock "LLM-1: resolves broken data source; LLM-2: parses raw content into rule schema — Phase 1" "HTTPS / Bedrock API"
        lce.pipelineWorker -> lce.s3 "Writes raw scraped content with provenance; reads prior object for content-hash diff" "S3 API"
        lce.pipelineWorker -> lce.db "Direct reads (sealed snapshots, employer standing, approved regulations, alert_events) for the daily scan" "PostgreSQL protocol"
        lce.pipelineWorker -> lce.apiServer "Writes staged regulations (weekly ingestion) and compliance alerts (daily scan)" "HTTP + Ed25519 JWT"

        # ────────────────────────────────────────────────────────────────
        # Component-level relationships (Level 3 — inside API Server)
        # ────────────────────────────────────────────────────────────────

        # Inbound -> Auth Middleware
        iralogixPlatform -> lce.apiServer.authMiddleware "Sends requests with Auth0 JWT" "HTTPS"
        auth0 -> lce.apiServer.authMiddleware "JWKS endpoint for JWT verification" "HTTPS"
        lce.pipelineWorker -> lce.apiServer.authMiddleware "Writes staged regulations, alerts (Ed25519 JWT)" "HTTP"

        # Inbound -> External API (unauthenticated path)
        iralogixPlatform -> lce.apiServer.externalAPI "Fetches webhook public keys (JWKS, unauthenticated)" "HTTPS"

        # Auth Middleware -> API boundaries
        lce.apiServer.authMiddleware -> lce.apiServer.externalAPI "Authenticated external request (Auth0 JWT + scopes)"
        lce.apiServer.authMiddleware -> lce.apiServer.internalAPI "Authenticated internal request (Ed25519 JWT)"
        lce.apiServer.authMiddleware -> lce.apiServer.dataAccess "Looks up client registry (enabled flag + scopes) for authorization"

        # External API -> outbound
        lce.apiServer.externalAPI -> lce.apiServer.complianceEngine "Creates/loads a session from its event log and appends one event; engine evaluates eligibility + compliance synchronously and returns the next questions (user-initiated)"
        lce.apiServer.externalAPI -> lce.apiServer.dataAccess "Reads/writes sessions, events, and materialised projections"
        lce.apiServer.externalAPI -> lce.apiServer.webhookDispatcher "Emits compliance.snapshot_updated when a session is sealed"

        # Compliance Engine (synchronous, in-process) — aggregate edge for the coarse component view
        lce.apiServer.complianceEngine -> lce.apiServer.dataAccess "Reads the active rule model + question catalog; appends/reads session_events; materialises snapshot + payload projections on seal"

        # Compliance Engine internals (module view)
        lce.apiServer.complianceEngine -> lce.apiServer.projector "Folds (bundle, events) into a view"
        lce.apiServer.complianceEngine -> lce.apiServer.bundleStore "get(state, rule_version)"
        lce.apiServer.complianceEngine -> lce.apiServer.sessionStore "create / load (row + log) / append"

        # Internal API -> outbound
        lce.apiServer.internalAPI -> lce.apiServer.dataAccess "Persists staged regulations and alert_events from the Pipeline Worker"
        lce.apiServer.internalAPI -> lce.apiServer.webhookDispatcher "Emits regulation.change_detected (staged/approved rule); compliance.input_required + compliance.alert (from the daily alert scan)"

        # Adapters -> external systems/containers
        lce.apiServer.webhookDispatcher -> iralogixPlatform "Delivers signed webhook events" "HTTPS + Ed25519"
        lce.apiServer.dataAccess -> lce.db "SQL queries" "SQLAlchemy"

        # ────────────────────────────────────────────────────────────────
        # Component-level relationships (Level 3 — inside Pipeline Worker)
        # ────────────────────────────────────────────────────────────────

        # Inbound -> Trigger Router
        lce.cron -> lce.pipelineWorker.triggerRouter "Weekly regulation-scan trigger"
        lce.cron -> lce.pipelineWorker.triggerRouter "Daily alert-scan trigger"

        # Trigger Router -> handlers
        lce.pipelineWorker.triggerRouter -> lce.pipelineWorker.scraper "Invokes weekly regulation ingestion"
        lce.pipelineWorker.triggerRouter -> lce.pipelineWorker.alertScanner "Invokes daily alert scan"

        # Phase 1 flow (weekly regulation ingestion)
        lce.pipelineWorker.scraper -> statePortals "Fetches raw HTML/PDF" "HTTPS"
        lce.pipelineWorker.scraper -> lce.pipelineWorker.sourceStore "Hands raw content for store + diff"
        lce.pipelineWorker.scraper -> lce.pipelineWorker.llmOrchestrator "Scrape failure → LLM-1 source resolution"
        lce.pipelineWorker.sourceStore -> lce.s3 "R/W raw content; content-hash diff" "S3 API"
        lce.pipelineWorker.sourceStore -> lce.pipelineWorker.llmOrchestrator "Diff detected → LLM-2 rule parsing"
        lce.pipelineWorker.llmOrchestrator -> bedrock "Invokes LLM-1 / LLM-2" "HTTPS / Bedrock API"
        lce.pipelineWorker.llmOrchestrator -> lce.pipelineWorker.apiClient "Post staged PENDING rule_version"

        # Alert flow (daily scan)
        lce.pipelineWorker.alertScanner -> lce.db "Queries sealed snapshots + per-employer standing; reads prior alert_events" "PostgreSQL protocol"
        lce.pipelineWorker.alertScanner -> lce.pipelineWorker.apiClient "Post alert_events + compliance.alert / compliance.input_required payloads"

        # API Client -> API Server
        lce.pipelineWorker.apiClient -> lce.apiServer "HTTP POST /internal/* (Ed25519 JWT)" "HTTPS"

        # ────────────────────────────────────────────────────────────────
        # Deployment
        # ────────────────────────────────────────────────────────────────

        production = deploymentEnvironment "Production" {

            deploymentNode "AWS Cloud" {
                tags "Amazon Web Services"

                deploymentNode "S3" {
                    s3Instance = containerInstance lce.s3
                }

                deploymentNode "Bedrock (managed LLM)" {
                    bedrockRef = infrastructureNode "AWS Bedrock Runtime" "LLM-1 + LLM-2 invocation endpoints" "AWS Bedrock"
                }

                deploymentNode "VPC: logixian-vpc" {

                    deploymentNode "Public Subnet" {
                        alb = infrastructureNode "Application Load Balancer" "HTTPS termination" "AWS ALB"
                    }

                    deploymentNode "Private Subnet" {

                        deploymentNode "EKS Kubernetes Cluster" {

                            deploymentNode "API Server (Deployment, HPA 2–4)" {
                                apiServerInstance = containerInstance lce.apiServer
                            }

                            deploymentNode "Pipeline Worker (CronJob-invoked, ephemeral pods)" {
                                pipelineWorkerInstance = containerInstance lce.pipelineWorker
                            }

                            deploymentNode "K8s CronJobs (weekly regulation scan + daily alert scan)" {
                                cronInstance = containerInstance lce.cron
                            }
                        }

                        deploymentNode "Amazon RDS" {
                            deploymentNode "PostgreSQL 17" {
                                dbInstance = containerInstance lce.db
                            }
                        }
                    }
                }
            }
        }
    }

    views {

        systemContext lce "SystemContext" "Level 1 — System Context diagram for Logixian Compliance Engine" {
            include *
            include iralogixCT
            include iralogixAdmin
            include iralogixCustomer
            include bedrock
            exclude auth0
            autoLayout lr
        }

        container lce "Container" "Level 2 — Container diagram for Logixian Compliance Engine" {
            include *
            autoLayout tb
        }

        component lce.apiServer "APIServerComponents" "Level 3 — Component diagram for the API Server" {
            include *
            exclude "element.tag==EngineInternal"
            autoLayout lr 300 100
        }

        component lce.apiServer "ComplianceEngineModule" "Level 3 (module) — inside the Compliance Engine: stateless facade, pure projector, and two storage ports" {
            include lce.apiServer.complianceEngine lce.apiServer.projector lce.apiServer.bundleStore lce.apiServer.sessionStore
            autoLayout lr 300 80
        }

        component lce.pipelineWorker "PipelineWorkerComponents" "Level 3 — Component diagram for the Pipeline Worker" {
            include *
            autoLayout lr 300 100
        }

        deployment lce production "Deployment" "Production deployment on AWS" {
            include *
            autoLayout lr
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
            }
            element "Indirect" {
                background #999999
                color #ffffff
            }
            element "Software System" {
                background #1168BD
                color #ffffff
            }
            element "Internal" {
                background #1168BD
                color #ffffff
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
            element "Adapter" {
                background #F5DA81
                color #000000
            }
            element "SQLAlchemy" {
                background #C3E6CB
                color #000000
            }
            element "FastAPI Middleware" {
                background #D4A5F5
                color #000000
            }
            element "FastAPI Routers" {
                background #85BBF0
                color #000000
            }
            element "Pure" {
                background #C9E7FF
                color #000000
            }
            element "Port" {
                background #FBE5C8
                color #000000
            }
        }
    }
}
