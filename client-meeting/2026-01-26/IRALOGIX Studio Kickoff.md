## Quick recap

The team met to discuss their project with Brad regarding the development of an IRA logic system and software engineering platform. The team presented their initial system architecture and roadmap, which Brad approved while suggesting they focus on 5 states initially rather than all 27. The team discussed technical requirements including database selection (Postgres), infrastructure needs, and data collection approaches. Brad emphasized the importance of proper requirements gathering and estimation before proceeding with system design. After Brad left, Scott and Jonathan provided additional mentoring feedback, emphasizing the need for better estimation practices and understanding of quality attributes. The team agreed to set up regular bi-weekly meetings with Brad and maintain communication primarily through Confluence rather than frequent meetings.
## Next steps

- Brad: Put together a list of current sources for regulations data and share with the team
- Brad: Work on providing data provisioning, domain knowledge transfer materials, and relevant documentation/design documents for the existing system
- Brad: Get a list of priority states (top 5) for initial implementation
- Brad: Talk to CTO about infrastructure cost/budgeting and provide guidance
- Brad: Set up Confluence access and dedicated space for the project team
- Team: Send summary of requirements and needed items to Brad after the meeting
- Team: Provide phone numbers to Brad for emergency contact
- Team: Work on scheduling biweekly meetings before 5PM
- Brad: Send phone number to team
- Brad/Team: Set up recurring meeting for mentoring
- Brad/Claude: Aggregate and share existing knowledge transfer materials in Confluence or GitHub
## Summary

### AI System for Software Engineering

The team introduced their project focused on building a multi-agent AI system for software engineering tasks, with Kuan explaining their two main goals: developing an IRLogic Core for jurisdiction intelligence and automatic eligibility, and creating an AI-powered software engineering system. The team outlined their approach to building the AI system, starting with accumulating and organizing valuable context from communications, documents, and code, before moving on to implementing smaller tasks like meeting agenda generation and AI summaries. The project will be divided into three parts, with the first semester focusing on establishing the system architecture and functional requirements.
### IRA Logic Core Development Plan

Kuan outlined the project timeline and goals for the IRA logic core, including system architecture planning, data integration, and expansion of supported states. For the summer semester, the team will focus on developing a software engineering system with an AI agent for coding review and QA, as well as expanding the jurisdiction knowledge base. Kuan also presented a diagram of how IRA Logix currently handles client data, including regulations and client information, and asked Brad for clarification on the system's details.
### Architecture Design and Onboarding Review

Brad reviewed the architecture design and confirmed it aligned with his expectations, particularly regarding the external points of interest and database integration. He clarified that customer onboarding occurs through an employer portal, where employers provide company data rather than individual employee information, which is cross-referenced against regulations. Brad expressed approval of the design and suggested exploring notification systems beyond just a dashboard, potentially using data queues like RabbitMQ for triggering emails or text messages. Saul confirmed that the upper right portion of the design, developed by IRALogix, is already in place, while the central database and other components need to be built from scratch.
### Regulatory Data Processing System Development

Brad and Kuan discussed the development of a system to collect and process regulatory data from various sources. They agreed that the data collection would not need to be high-frequency, occurring perhaps once a year, but a mechanism for data updates would be necessary. Brad suggested using NLP tools to extract relevant information from unstructured data sources like PDFs. They also discussed using PostgreSQL as the database for storing the processed data, with Brad emphasizing its flexibility and ability to handle domain-driven architecture.
### Database Migration and API Integration

Brad explained that he had moved data from Neo4j to Postgres due to scalability issues, noting that Neo4j requires running the entire database in memory, which was costly. He mentioned that Postgres now provides better performance at a lower cost. Kuan inquired about the current databases in the system and the need for sample data to test the compliance engine. Brad suggested implementing an API for the onboarding feature to integrate with the existing user experience while keeping systems decoupled for scalability. Kuan agreed and proposed getting documentation on interacting with the current data without direct database access.
### Regulatory Versioning Strategy Discussion

The team discussed the strategy for handling regulatory changes and versioning in their system. Brad suggested implementing a temporal versioning system where each update to regulatory requirements would be tracked by a timestamp, though he clarified that focusing on the newest version would be sufficient for compliance purposes. They also discussed potential auditability features, with Brad recommending a simple solution using database triggers and S3 buckets for archiving version history. The conversation ended with Kuan outlining next steps, focusing on team accessibility to databases, domain knowledge transfer, and access to existing system documentation.
### Project Tech Stack and POC Planning

The team discussed technical requirements for a project, including the tech stack (excluding Java) and infrastructure needs. Brad offered to provide AWS and Kubernetes resources if needed, and they agreed to aim for a 5-state POC implementation by the end of February. They decided to establish bi-weekly meetings before 5 PM, and Kuan committed to sending a summary of requirements and system architecture blueprint after the meeting.
### Streamlining Communication and Requirements

The team discussed communication preferences with Brad, agreeing to use email and phone calls for emergencies, with the possibility of using Slack if needed. They planned to set up a Confluence page for project documentation and agenda items, following Brad's preference for asynchronous communication. Scott provided guidance on requirements gathering and estimation, emphasizing the importance of understanding workflows, workloads, and quality attributes before jumping into system design. The team acknowledged the need to clarify requirements and gather sample data before making timeline commitments to Brad.
