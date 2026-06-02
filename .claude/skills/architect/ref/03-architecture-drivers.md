# Lecture 03: Architecture Drivers

## Objectives
- Examine the source and nature of architecture requirements
- Recognize different categories of requirements and their impact
- Understand quality attribute requirements and how to describe them clearly

## Key Concepts

### Architecture Drivers
Requirements that **shape** the software architecture. Not all requirements are drivers — many are about implementation details rather than system structure and tradeoffs.

Three categories:
1. **Functional Requirements** — what the system must do (use cases, user perspective, "what" not "how")
2. **Constraints** — decisions already made, outside architect's control
3. **Quality Attributes** — characteristics beyond functionality (performance, security, availability, etc.)

### Constraints
Context outside the architect's control. Two categories:
- **Technical**: legacy systems, external APIs, mandated technologies/protocols
- **Business**: time-to-market, rollout schedule, projected lifetime, workforce, team structure

Constraints may need negotiation if they impose too many restrictions or are arbitrary.

### Quality Attributes (QAs)
- Define qualities beyond functionality (performance, security, availability, portability)
- Prefer "quality attributes" over "non-functional requirements" — the latter is a dysfunctional term that introduces false partitioning
- **QAs must be designed in** — can't just implement functionality and add QAs later
- Architectural choices promote some QAs and inhibit others → **tradeoffs**

### Quality Attribute Scenarios (6-part format)
| Part | Definition |
|---|---|
| **Stimulus** | A condition that affects the system |
| **Source** | Entity that generated the stimulus |
| **Environment** | Context/conditions when stimulus occurs |
| **Artifact** | What was stimulated |
| **Response** | Activity resulting from the stimulus |
| **Response Measure** | How the response will be evaluated |

Example: "An external smoke detector sends an alarm event under peak load. The building management system receives the event and raises an alarm within .5 seconds."

### Four Example QA Areas

#### Availability
- Concerned with system failure and consequences
- Areas: preventing catastrophic failures, detecting/recovering from failures, degraded modes
- Example: "An unanticipated oil low signal is received during engine startup. The system prevents engine start and illuminates check engine light in 1 second."

#### Modifiability
- About the cost of change
- Areas: what can change (functions, platforms, QAs), when, and by whom
- Example: "The existing 4-cylinder engine controller must support 6 and 8 cylinders with no changes to base source code."

#### Performance
- About timing and response to events
- Areas: varying event sources/rates, response time
- Example: "500 users initiate 1,000 transactions/min stochastically; each processed with average latency of 2 seconds."

#### Security
- Ability to resist unauthorized access while serving legitimate users
- Areas: non-repudiation, confidentiality, integrity, assurance, accessibility, auditing
- Example: "An unauthorized individual gains access and tries to modify consumer data. System detects, maintains audit trail, notifies admin, and shuts down."

## Key Tradeoffs
- Functionality alone doesn't determine architecture — two systems with same functionality can have very different structures supporting different QAs
- A change that improves one QA may inhibit others
- "How much response time am I willing to give up to guarantee confidentiality?"
- Not all "ilities" are architectural — radio button choice affects usability but isn't architectural; isolating UI decisions so they can change IS architectural
