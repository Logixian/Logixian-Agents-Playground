# IRALOGIX — MSE Pro 2026 Studio Project Description

**Client:** IRALOGIX Inc.
**Project Manager:** Brad Campbell (bcampbell@iralogix.com)
**Student Contact:** Brad Campbell, Andy Daniel (adaniel@iralogix.com)
**Availability:** 4 hrs/wk

---

## Business Motivation

Twenty U.S. states have enacted state-mandated retirement programs covering 40M+ workers without employer-sponsored plans. Employers face escalating penalties for non-compliance (e.g., California: $250–$500 per employee).

IRALOGIX seeks a rules engine backed by jurisdictional-specific knowledge to streamline employer compliance and automate onboarding within these jurisdictions.

## Project Description

The MSE team develops a proof-of-concept rules engine that:
- Ingests jurisdictional requirements
- Evaluates employer characteristics
- Generates compliance recommendations

This extends IRALOGIX's platform from account execution to the "first mile" of employer engagement.

### Five Core Components

| Component | Description |
|-----------|-------------|
| Jurisdiction Intelligence Engine | Knowledge graph maintaining real-time regulatory rules across all state programs |
| Eligibility Determination Service | Multi-criteria decision system handling complex employer scenarios |
| Compliance Deadline Calculator | Sophisticated date arithmetic accounting for phase-in schedules |
| Automated Onboarding Workflow | Streamlined process reducing onboarding from days to hours |
| Monitoring & Alert System | Proactive compliance tracking with graduated notifications |

## Milestones

### Core Features Pillar
| Milestone | Deliverable |
|-----------|-------------|
| M1 | Initial requirements complete and documented. All decision points completed and documented. |
| M2 | Knowledge graph schema complete and documented. Initial API design complete. |
| M3 | Regulatory data collection complete and ingested into storage. |
| M4 | Initial API prototype complete. |
| M5 | Eligibility engine and compliance date calculator prototypes complete. |
| M6 | Eligibility engine and compliance date calculator integrated into API layer. |

### Moonshot Pillar
| Milestone | Deliverable |
|-----------|-------------|
| M7 | Automated onboarding workflow prototype complete. |
| M8 | Monitoring and alerting system prototype complete. |

## Technical Constraints

- Greenfield project — no significant legacy constraints
- Stack decisions: Python + FastAPI (async), AWS Kubernetes, PostgreSQL
- IRALOGIX will grant access to relevant databases and documentation stores

## Use of AI

IRALOGIX is an AI-first organization. Participants must use IRALOGIX enterprise instances of:
- Cursor, ChatGPT, Claude, CoPilot

All use must comply with IRALOGIX Data Protection Policy and AI Usage Policy.
