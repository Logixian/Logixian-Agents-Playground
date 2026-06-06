# Client Meeting Notes

## Executive Summary
The meeting finalized the architectural boundaries for the "Logixian" compliance engine, confirming it will operate as a decoupled domain with its own database, integrating with the IRAlogix core system strictly via API contracts and webhooks. The team agreed on a two-phase data pipeline consisting of weekly regulatory ingestion and on-demand compliance calculations, while deciding that IRAlogix will retain responsibility for the final delivery of alerts to users. Technical constraints were clarified to allow a Python backend, provided it utilizes an asynchronous framework like Quart or FastAPI.

## Key Decisions Made
- **System Architecture**: Logixian will function as a separate "black box" domain with its own database, interacting with IRAlogix solely through APIs (for data ingestion) and webhooks (for results/alerts).
- **Data Schedule**: Regulatory data ingestion will run on a weekly schedule; compliance calculations will be reactive (triggered by data updates).
- **Alerting Protocol**: Logixian will generate alert payloads, but IRAlogix will handle the actual message dispatch (email or UI notification) to ensure brand consistency.
- **Tech Stack**: The team is authorized to use Python instead of Go, with the strict requirement of using an asynchronous API framework (e.g., Quart or FastAPI); Django was explicitly rejected.
- **Meeting Schedule**: The next bi-weekly sync is rescheduled to March 11th to accommodate Spring Break.

## Action Items
- **[Brad Campbell]**:
  - Set up Okta accounts and the Confluence space for the Logixian team by **Today/Tomorrow**.
  - Define the required employer metrics and upload data schema specifications/ERD diagrams to Confluence by **ASAP/Next Steps**.
  - Review Milestone 1 requirements and confirm completion via email by **ASAP**.
- **[Team]**:
  - Migrate current project documentation to the new Confluence space by **After access is granted**.
  - Update the calendar invite for the next meeting on March 11th by **ASAP**.

## Quick Recap
The meeting focused on reviewing the overall system architecture and workflow for the Logixian Engine project, which will interact with IRALogix's internal system through APIs and webhooks. The team discussed the data pipeline structure, including weekly scheduled jobs for data ingestion and reactive calculations triggered by new laws or client data updates. Brad confirmed that IRALOGIX does not currently have an internal database for managing laws, making the Logixian Engine's data storage a new implementation. The team agreed to use Python for the engine's development, with a focus on asynchronous API servers like Quart or FastAPI, while Brad emphasized the importance of well-defined API contracts for system integration. They also discussed fault tolerance and database consistency, with Brad explaining their current architectural approach of maintaining separate domain-specific databases. The conversation ended with an agreement to move forward with designing APIs and data schemas for the regulation data in milestone 2, while adjusting the next bi-weekly sync-up meeting to March 11th due to spring break.

## Next Steps
- **Team**:
  - Work out the required matrix/data schema for employer profiles and calculation outcomes, based on provided documents and further information as needed.
  - Review and migrate meeting documentation to the new Confluence space once access is available.
  - Update the calendar schedule with the new sync-up date (March 11th) and share with Brad.
  - Begin designing APIs and data schema for regulation data as part of milestone 2.
  - Choose and synchronize on an asynchronous Python framework (e.g., FastAPI, Quart) for the API server, ensuring it can handle multiple concurrent connections at scale.
  - Ensure API server implementation supports asynchronous operations as required by Brad.
  - Define the API contracts/specifications for employer onboarding and data exchange, and share with Brad for review when ready.
- **Brad**:
  - Provide employer data schema specifications and related documentation in Confluence once team Okta/Confluence accounts are set up.
  - Review milestone 1 deliverables and send email confirmation if all requirements are met.
  - Provide feedback on the API contracts/specifications once received from the team.

## Summary
### Data Pipeline Design Discussion
The team discussed the project's overall structure and data pipeline, with Team presenting a diagram of the system. They agreed on a two-phase data pipeline: weekly scheduled ingestion of laws from the internet, and reactive calculations triggered by new law approvals or client data. Brad confirmed that IRALOGIX does not currently have an internal database for managing laws, which was part of the project's scope. They also discussed the possibility of using webhooks for notifications and subscriptions, though Brad did not confirm if their system supports webhooks.

### Regulation Pipeline and Data Processing
Brad and Team discussed a pipeline for processing regulation updates and client data. They agreed on a three-phase process: automatic tracking of state regulations with one-week latency, human approval for changes, and calculations by the Logic Engine. Team proposed using a query API for reviewing laws and visualizing data systematically. They also discussed the need for anonymized client data storage and the client onboarding pipeline, which Brad suggested should be defined through API contracts.

### Employer Data Integration Process
Brad and Team discussed the process of onboarding employers and exchanging data between their systems. They agreed that a push API would be used to receive anonymized employer data from Brad's system, which would then be used to create profiles in Team's logic engine. The next step is to determine the required metrics for calculating outcomes based on state plans. Brad mentioned that Okta accounts would be set up for Team's team, and they would gain access to a Confluence space where documentation would be stored. They also discussed the process of exchanging compliance snapshots between their systems after calculations are complete.

### Compliance System Architecture Planning
The team discussed the overall workflow for compliance and alerting responsibilities, deciding to handle email notifications through a logic system that can choose the best method for user communication. They reviewed the system architecture, which includes an API server and data pipeline, with Brad explaining how the two separate databases will maintain consistency through API contracts. The team agreed to use Python for the logic engine, with Brad recommending asynchronous frameworks like Quart or FastAPI for the API server. They concluded that well-defined API contracts will facilitate integration between the two systems, and decided to treat the current discussion as the completion of milestone one, with plans to design APIs and data schemas for regulation data in milestone two.