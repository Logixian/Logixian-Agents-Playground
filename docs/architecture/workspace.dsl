workspace "Logixian Compliance Engine" {
    !identifiers hierarchical

    model {
        logixian = softwareSystem "Logixian System" {
            pipeline = container "Pipeline worker" "States' regulations fetcher" {
                initializer = component "Initializer" {
                    tags "method"
                }
                state_id = component "State Id" {
                    tags "property"
                }
                basic_comparison = component "Basic comparison" {
                    tags "method"
                }
                advanced_comparison = component "Advanced comparison" {
                    tags "method"
                }
                dumb_scrapper = component "Basic scrapper" {
                    tags "method"
                }
                llm_fetcher = component "LLM scrapper" {
                    tags "method"
                }
            }
            compliance_engine = container "Compliance engine" "Client eligibility and compliance determination" {
                initializer = component "Initializer" {
                    tags "method"
                }
                ids = component "IDs" "Employer & session ID" {
                    tags "property"
                }
                rules_backbone = component "Rules backbone" {
                    tags "property"
                }
                version_id = component "Rules information" "Bundle ID" {
                    tags "property"
                }
                date = component "Date" {
                    tags "property"
                }
                register_response = component "Answer question" {
                    tags "method"
                }
                get_question = component "Get question" {
                    tags "method"
                }
                save = component "Save log" {
                    tags "method"
                }
                load = component "Get session" {
                    tags "method"
                }
            }
            alerter = container "Notification dispatcher" {
                outdated_rules = component "Outdated rules" "Get payloads generated with out-of-date rules" {
                    tags "method"
                }
                outdated_payloads = component "Outdated payloads" "Get old payloads" {
                    tags "method"
                }
                bad_payloads = component "Bad payloads" "Get unfinished/uncompliant payloads"{
                    tags "method"
                }
                alert_sender = component "Alert sender" {
                    tags "method"
                }
            }
            verificator = container "Verification interface" {
                accept_verification = component "Accept verification" {
                    tags "method"
                }
                unverified_schemas = component "List unverified schemas" {
                    tags "method"
                }
            }
            compliance_portal = container "Compliance team portal" "IRALOGIX-facing user stories" {
                user_admin = component "User administration" {
                    tags "interface"
                }
                rules_admin = component "Rules administration" {
                    tags "interface"
                }
            }
            customer_portal = container "Customer portal" "Customer-facing user stories" {
                engine = component "Engine interface" {
                    tags "interface"
                }
            }

            raw_state_db = container "Raw state data" {
                tags "database"
            }
            state_bundles_db = container "State bundles database" {
                tags "database"
            }
            snapshots = container "Snapshots" {
                tags "database"
            }
            cron = container "Weekly cron" {
                tags "process"
            }
        }

        compliance_team = person "IRALOGIX compliance team" {
            tags "IRALOGIX"
        }
        admin_team = person "IRALOGIX administrators" {
            tags "IRALOGIX"
        }
        customer = person "IRALOGIX customer" {
            tags "external"
        }
        authenticator = softwareSystem "Authenticator" {
            tags "IRALOGIX"
        }
        iralogix_alerts = softwareSystem "IRALOGIX alert system" "Owned by IRALOGIX. Decides how an alert payload is routed to staff." {
            tags "IRALOGIX"
        }
        bedrock = element "AWS Bedrock" {
            tags "AI"
        }
        internet = element "WWW" {
            tags "Internet"
        }

        # Users
        compliance_team -> logixian.compliance_portal.rules_admin {
            tags "uses"
        }
        admin_team -> logixian.compliance_portal.user_admin {
            tags "uses"
        }
        customer -> logixian.customer_portal.engine {
            tags "uses"
        }

        # Portals
        # Shared login, then customer and IRALOGIX staff diverge to separate endpoint sets
        logixian.customer_portal -> authenticator "Log in" {
            tags "calls"
        }
        logixian.compliance_portal -> authenticator "Log in" {
            tags "calls"
        }
        logixian.compliance_portal.user_admin -> authenticator "Administer users" {
            tags "readsWrites"
        }
        logixian.compliance_portal.rules_admin -> logixian.verificator.unverified_schemas {
            tags "calls"
        }
        logixian.verificator.unverified_schemas -> logixian.compliance_portal.rules_admin "List of bundles" {
            tags "returns"
        }
        logixian.compliance_portal.rules_admin -> logixian.verificator.accept_verification {
            tags "calls"
        }
        logixian.customer_portal.engine -> logixian.compliance_engine.initializer "Start session - Employer ID, State ID" {
            tags "calls"
        }
        logixian.compliance_engine.initializer -> logixian.customer_portal.engine "Session ID" {
            tags "returns"
        }
        logixian.customer_portal.engine -> logixian.compliance_engine.get_question "Request question" {
            tags "calls"
        }
        logixian.compliance_engine.get_question -> logixian.customer_portal.engine "Current question" {
            tags "returns"
        }
        logixian.customer_portal.engine -> logixian.compliance_engine.register_response "Post answer (action + Session ID)" {
            tags "calls"
        }
        logixian.compliance_engine.register_response -> logixian.customer_portal.engine "Next question/status" {
            tags "returns"
        }
        logixian.customer_portal.engine -> logixian.compliance_engine.load "Load saved session - Session ID" {
            tags "calls"
        }
        logixian.compliance_engine.load -> logixian.customer_portal.engine "Next question" {
            tags "returns"
        }
        
        # Authentication activities
        logixian.compliance_engine.initializer -> authenticator "Verify permissions" {
            tag "calls"
        }
        logixian.compliance_engine.get_question -> authenticator "Verify permissions" {
            tag "calls"
        }
        logixian.compliance_engine.register_response -> authenticator "Verify permissions" {
            tag "calls"
        }
        logixian.compliance_engine.load -> authenticator "Verify permissions" {
            tag "calls"
        }

        # Fetching regulations
        
        logixian.cron -> logixian.pipeline.initializer {
            tags "calls"
        }
        logixian.pipeline.initializer -> logixian.pipeline.state_id {
            tags "writes"
        }
        logixian.pipeline.basic_comparison -> logixian.pipeline.state_id {
            tags "reads"
        }
        logixian.pipeline.initializer -> logixian.pipeline.basic_comparison {
            tags "calls"
        }
        logixian.pipeline.basic_comparison -> logixian.pipeline.dumb_scrapper {
            tags "calls"
        }
        logixian.pipeline.dumb_scrapper -> logixian.pipeline.basic_comparison "Registered website" {
            tags "returns"
        }
        logixian.pipeline.basic_comparison -> logixian.raw_state_db "Saved website image" {
            tags "reads"
        }
        logixian.pipeline.basic_comparison -> logixian.pipeline.advanced_comparison "If saved and new image differ" {
            tags "calls"
        }
        logixian.pipeline.advanced_comparison -> logixian.pipeline.state_id {
            tags "reads"
        }
        logixian.pipeline.advanced_comparison -> logixian.pipeline.llm_fetcher {
            tags "calls"
        }
        logixian.pipeline.llm_fetcher -> logixian.pipeline.advanced_comparison "State bundle + website url" {
            tags "returns"
        }
        logixian.pipeline.llm_fetcher -> logixian.pipeline.dumb_scrapper "Website URL" {
            tags "calls"
        }
        logixian.pipeline.dumb_scrapper -> logixian.pipeline.llm_fetcher "Raw website" {
            tags "returns"
        }
        logixian.pipeline.llm_fetcher -> logixian.raw_state_db "Saved website image" {
            tags "writes"
        }
        logixian.pipeline.llm_fetcher -> logixian.state_bundles_db "PENDING new fetched rules (only if changed)" {
            tags "writes"
        }
        logixian.pipeline.llm_fetcher -> iralogix_alerts "If new rules exist" {
            tags "alerts"
        }

        logixian.pipeline.llm_fetcher -> bedrock {
            tags "uses"
        }
        logixian.pipeline.llm_fetcher -> internet {
            tags "reads"
        }
        logixian.pipeline.dumb_scrapper -> internet {
            tags "reads"
        }

        # Engine

        logixian.compliance_engine.initializer -> logixian.state_bundles_db "Get state bundle (State ID)" {
            tags "reads"
        }
        logixian.compliance_engine.initializer -> logixian.compliance_engine.rules_backbone {
            tags "writes"
        }
        logixian.compliance_engine.initializer -> logixian.compliance_engine.version_id {
            tags "writes"
        }
        logixian.compliance_engine.initializer -> logixian.compliance_engine.ids {
            tags "writes"
        }
        logixian.compliance_engine.initializer -> logixian.compliance_engine.date {
            tags "writes"
        }
        logixian.compliance_engine.register_response -> logixian.compliance_engine.ids {
            tags "writes"
        }
        logixian.compliance_engine.register_response -> logixian.compliance_engine.date {
            tags "writes"
        }
        logixian.compliance_engine.register_response -> logixian.compliance_engine.save "New step" {
            tags "calls"
        }
        logixian.compliance_engine.save -> logixian.compliance_engine.register_response "Status projection" {
            tags "returns"
        }
        logixian.compliance_engine.save -> logixian.compliance_engine.load "Session ID" {
            tags "calls"
        }
        logixian.compliance_engine.save -> logixian.snapshots "New step" {
            tags "writes"
        }

        logixian.compliance_engine.load -> logixian.compliance_engine.save "Session history" {
            tags "returns"
        }
        logixian.compliance_engine.load -> logixian.compliance_engine.version_id {
            tags "writes"
        }
        logixian.compliance_engine.load -> logixian.compliance_engine.rules_backbone {
            tags "writes"
        }
        logixian.compliance_engine.load -> logixian.snapshots {
            tags "reads"
        }

        logixian.compliance_engine.register_response -> logixian.compliance_engine.get_question "Session ID" {
            tags "calls"
        }
        logixian.compliance_engine.get_question -> logixian.compliance_engine.rules_backbone {
            tags "reads"
        }
        logixian.compliance_engine.get_question -> logixian.compliance_engine.register_response "New question/status" {
            tags "returns"
        }
        
        # Alerter

        logixian.alerter.outdated_rules -> logixian.snapshots {
            tags "reads"
        }
        logixian.alerter.outdated_rules -> logixian.state_bundles_db {
            tags "reads"
        }
        logixian.alerter.outdated_payloads -> logixian.snapshots {
            tags "reads"
        }
        logixian.alerter.bad_payloads -> logixian.snapshots {
            tags "reads"
        }

        logixian.alerter.outdated_rules -> logixian.alerter.alert_sender {
            tags "calls"
        }
        logixian.alerter.outdated_payloads -> logixian.alerter.alert_sender {
            tags "calls"
        }
        logixian.alerter.bad_payloads -> logixian.alerter.alert_sender {
            tags "calls"
        }
        logixian.alerter.alert_sender -> iralogix_alerts "Deliver alert payload (webhook)" {
            tags "alerts"
        }
        iralogix_alerts -> compliance_team "SMS / email / workspace notification" {
            tags "alerts"
        }

        # Big picture relations

        logixian.customer_portal -> logixian.compliance_engine {
            tags "uses"
        }
    }

    views {
        systemContext logixian "SystemContext" {
            include *
        }
        container logixian "ContainerDiagram"{
            include *
        }

        component logixian.compliance_engine "ComplianceEngineDiagram"{
            include *
            autoLayout
        }

        component logixian.pipeline "WorkerPipelineDiagram" {
            include *
            autoLayout
        }

        component logixian.alerter "AlerterDiagram" {
            include *
            autoLayout
        }

        styles {
            element "Software System" {
                background #75B9BE
                color #000000
            }
            element "IRALOGIX" {
                background #4059AD
                color #ffffff
            }
            element "external" {
                background #F1E3F3
                color #000000
            }
            element "Person" {
                shape Person
            }
            element "Internet" {
                background #F1E3F3
                color #000000
                shape WebBrowser
            }
            element "AI" {
                background #ff6666
                color #000000
                shape Robot
            }
            element "database" {
                background #FF6666
                color #ffffff
                shape Cylinder
            }
            element "Container" {
                background #75b9be
                color #ffffff
            }
            element "method" {
                background #4059ad
                color #ffffff
            }
            element "property" {
                background #CCFF66
                color #000000
            }
            element "process" {
                background #FF6666
                color #ffffff
                shape Diamond
            }
            relationship "readsWrites" {
                color #75B9BE
                dashed false
            }
            relationship "reads" {
                color #4059AD
                dashed false
            }
            relationship "writes" {
                color #000000
                dashed false
            }
            relationship "calls" {
                color #FF6666
            }
            relationship "returns" {
                color #99aa66
            }
            relationship "uses" {
                color #000000
            }
            relationship "alerts" {
                color #75B9BE
            }
            element "Boundary" {
                strokeWidth 5
            }
            relationship "Relationship" {
                thickness 4
            }
        }
    }
}