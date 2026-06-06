## Quick recap

The team discussed the data schema design for a compliance rules engine, focusing on how to structure client data, rules, and compliance snapshots across different states. They reviewed a proposed schema for handling state-specific regulations and penalties, with Brad approving the overall approach and offering to generate additional state data to help validate the model. The team agreed to use FastAPI as the Python framework for the API backend, and confirmed they would use SQS for queuing services. Brad committed to setting up an AWS account with Bedrock access for the team, and they discussed how to handle external AI services integration. The conversation ended with confirmation that all team members had access to necessary systems including Okta and Confluence.
## Next steps

- Brad: Set up AWS account for the team, including access to Bedrock and an EKS cluster, by tomorrow
- Brad: Generate and share a document with data model information for additional states (approximately 15-22 states) by Friday
- Brad: Create budget estimation for the project and share with the team
- LI-FU team: Refine functional requirements and data schema, adding more details for each field
- LI-FU team: Review Brad's functional requirements and reshape/merge with previous ER, then send back to Brad
- LI-FU team: Synthesize additional data not covered in current schema into a table and add to Confluence pages
- Brad: Send light reading material about Bedrock integration to the team
- LI-FU team: Review Bedrock integration documentation and begin testing with Bedrock in AWS environment
- All team members: Attend weekly meeting next week to review progress

## Summary

### Studio Project Meeting Logistics

Brad and Li-Fu discussed aligning on meeting logistics for a studio project. Li-Fu explained that their faculty was surprised by the limited number of meetings with Brad and suggested having weekly check-ins to track progress and address obstacles. Brad agreed to the weekly meetings, though the specific time was not decided.
### Project Progress and Milestone Review

Brad and Li-Fu discussed the progress of their project and agreed to sync up regularly to review the data model and schema they had been working on. They planned to go through the functional and non-functional requirements to finalize Milestone 1, with Brad having compiled a list of objectives and decision points for their review.
### System Boundaries and Data Schemas

The team discussed system boundaries and data schemas, focusing on uncertainties around client data and compliance requirements. Li-Fu uploaded a draft to Confluence and shared a screen to explain their understanding of state-specific rules and contribution models. They expressed uncertainty about the scope of services provided to clients, questioning whether it included audit services or payroll deductions, and discussed the need to clarify these details.
### State Entity Compliance Schema Synchronization

LI-Fu and Brad discussed the need to synchronize entity types across different states to identify commonalities and establish a unified compliance schema. They explored the complexities of compliance deadlines, penalty structures, and grace periods, noting variations in how states calculate penalties and the existence of voluntary compliance phases. The conversation highlighted the challenges of creating a unified model that accounts for state-specific regulations and the need to address these complexities to ensure accurate compliance tracking.
### Data Pipeline and Schema Process

The team discussed a data pipeline process where the system fetches new laws and generates a schema based on website content, which will then be reviewed by human experts at IRLogix to ensure accuracy. Brad approved of this process, noting that after expert verification, the rules engine would pull in the new version of rules. The team also considered integrating LLM to parse data into the predefined structure, though this was not finalized.
### LLM Implementation Strategy Discussion

Brad explained that IRLOGIS can use their own AWS account to access Bedrock, which provides an LLM backend for processing documents. He recommended using one of the anthropic models, such as Opus 4.6, for the proof of concept, and suggested comparing it to OpenAI models like Codex 5.3 or 5.4. Brad also confirmed that the data model for processing PDF files and comparing it to websites was on the right path. The discussion concluded with a question about client data payload, as there was uncertainty about the sufficiency of the data and the process for obtaining additional information like employee count and operational status.
### Component Snapshot Structure Discussion

Brad and Li-Fu discussed the structure of a component snapshot for tracking employer compliance with state regulations. They identified the need to include time-based components, such as the date of registration and compliance deadlines, to accurately assess eligibility. Li-Fu outlined the structure of the snapshot, which includes operational status, action items, and risk exposure calculations. Brad agreed that the proposed structure was on the right track and offered to review the schema to determine how it would integrate with their employer portal.
### Data Schema and API Planning

The team discussed progress on data schema design and agreed to refine it further using additional state data while focusing implementation on the initial five states. Brad recommended FastAPI as the Python framework for the API backend due to its async capabilities and integration with Pydantic. They decided to use SQS for queueing and AWS for hosting, with Brad offering to set up the necessary AWS infrastructure and provide guidance on Bedrock integration. The team also aligned on using their existing project management system rather than creating a new JIRA instance.
