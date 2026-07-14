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
            portal = container "Portal" {
                user_admin = component "User administration" {
                    tags "interface"
                }
                rules_admin = component "Rules administration" {
                    tags "interface"
                }
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
            tags "iralogix"
        }
        admin_team = person "IRALOGIX administrators" {
            tags "iralogix"
        }
        customer = person "IRALOGIX customer" {
            tags "external"
        }
        authenticator = softwareSystem "Authenticator" {
            tags "iralogix"
        }
        bedrock = element "AWS Bedrock" {
            tags "ai"
        }
        internet = element "WWW" {
            tags "internet"
        }

        # Users
        compliance_team -> logixian.portal.rules_admin {
            tags "uses"
        }
        admin_team -> logixian.portal.user_admin {
            tags "uses"
        }
        customer -> logixian.portal.engine {
            tags "uses"
        }

        # Portal 
        logixian.portal.user_admin -> authenticator "Administer users" {
            tags "readsWrites"
        }
        logixian.portal.rules_admin -> logixian.verificator.unverified_schemas {
            tags "calls"
        }
        logixian.verificator.unverified_schemas -> logixian.portal.rules_admin "List of bundles" {
            tags "returns"
        }
        logixian.portal.rules_admin -> logixian.verificator.accept_verification {
            tags "calls"
        }
        logixian.portal.engine -> logixian.compliance_engine.initializer "Start session - Employer ID, State ID" {
            tags "calls"
        }
        logixian.compliance_engine.initializer -> logixian.portal.engine "Session ID" {
            tags "returns"
        }
        logixian.portal.engine -> logixian.compliance_engine.get_question "Request question" {
            tags "calls"
        }
        logixian.compliance_engine.get_question -> logixian.portal.engine "Current question" {
            tags "returns"
        }
        logixian.portal.engine -> logixian.compliance_engine.register_response "Post answer (action + Session ID)" {
            tags "calls"
        }
        logixian.compliance_engine.register_response -> logixian.portal.engine "Next question/status" {
            tags "returns"
        }
        logixian.portal.engine -> logixian.compliance_engine.load "Load saved session - Session ID" {
            tags "calls"
        }
        logixian.compliance_engine.load -> logixian.portal.engine "Next question" {
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
        logixian.pipeline.state_id -> logixian.pipeline.basic_comparison {
            tags "takes"
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
        logixian.pipeline.state_id -> logixian.pipeline.advanced_comparison {
            tags "requires"
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
        logixian.pipeline.llm_fetcher -> compliance_team "If new rules exist" {
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
        logixian.compliance_engine.rules_backbone -> logixian.compliance_engine.get_question {
            tags "takes"
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
        logixian.alerter.alert_sender -> compliance_team {
            tags "alerts"
        }

        # Big picture relations

        logixian.portal -> logixian.compliance_engine {
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
                background #6AA1D8
                color #ffffff
            }
            element "iralogix" {
                background #81377F
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
            }
            element "internet" {
                background #8989B3
                color #ffffff
                shape WebBrowser
            }
            element "ai" {
                background #4E1F05
                color #ffffff
                shape Robot
            }
            element "database"{
                background #157A09
                shape Cylinder
            }
            element "Container" {
                background #438DD5
                color #ffffff
            }
            element "method" {
                background #ff0000
                color #ffffff
            }
            element "property" {
                background #34C934
                color #ffffff
            }
            element "process" {
                background #34C934
                shape Diamond
            }
            relationship "readsWrites" {
                color #1DB8C0
                dashed false
            }
            relationship "reads" {
                color #0B4725
                dashed false
            }
            relationship "writes" {
                color #8B2626
                dashed false
            }
            relationship "calls" {
                color #BF8221
            }
            relationship "returns" {
                color #1015A1
            }
            relationship "uses" {
                color #000000
                dashed false
            }
            relationship "alerts" {
                color #EE00FF
            }
        }
    }
}