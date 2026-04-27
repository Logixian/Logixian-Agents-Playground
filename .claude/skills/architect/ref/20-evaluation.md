# Lecture 20: Architecture Evaluation

> Garlan & Schmerl & Fairbanks, 30 March 2026
> Two slide decks: main evaluation lecture + NASA SARB supplementary

## Objectives

- Understand general concepts of software architecture evaluation: why needed, costs, benefits
- Examine three evaluation mechanisms: AT&T Architecture Review Process, SEI ATAM, NASA SARB
- Reflect on agile evaluation mechanisms and continuous evaluation via ADRs

## Key Concepts

### Why Evaluate Architecture?

Architecture bridges requirements and implementation. Three critical relationships:
1. Requirements <-> Architecture
2. Architecture <-> Implementation
3. Alternative architectures (comparison)

### Value of Architecture Reviews

- "The average review pays back at least **12x its cost**" (Starr & Zimmerman, 2002)
- Projects of 100K SLOC saved **~$1M each** by finding problems early (Maranzano et al., 2005)
- Beneficial side effects: cross-org learning, management attention without retribution, organizational change catalyst
- Preparation alone forces teams to do more complete analysis; team members ask more questions than reviewers

### Architecture in Agile Context

Reviews fit between "Big Upfront Design" and "Evolutionary Design" as a hybrid approach. See Simon Brown's "The lost art of software design."

## AT&T Architecture Review Board (ARB)

### Structure

- Established 1988; reviewed **350+ projects** (voluntary participation)
- Two-phase review process; ~70 staff-days across ~15 people
- "A correct architecture has the largest single impact on cost and quality" (Maranzano, 1995)
- Key participants later adapted the method at Lucent, Avaya, Millennium, NASA -- results from **700+ reviewed projects**

### Two Review Phases

| Phase | When | Focus |
|-------|------|-------|
| **Discovery Review** | Early lifecycle (business goals, requirements) | Validate problem statement vs. requirements; ensure architecture headed in right direction |
| **Architecture Review** | After major architectural decisions made | Functionality, performance, error recovery, OA&M (operability, observability, SRE/DevOps) |

### How a Review is Conducted

**Before:**
- ARB Chairperson meets project to determine technical focus
- Assembles review team of subject matter experts (voluntary, management-encouraged)
- Project sends review material 2 weeks before
- ARB generates questions/concerns several days before

**During (2-3 days):**
- Project personnel present detailed talks on key technical areas
- Issues recorded on **"snow cards"**
- Cards grouped: "Things done right", "Issues", "Recommendations"
- Immediate feedback at end of review

**After:**
- Written report to project management
- Project develops action plan based on findings
- Joint presentation of evaluation + action plan to management and ARB directors

### What the Review Board Looks For

- Purpose of the system
- Major functional components/platforms
- Relationships and dynamic interplay of control and communication
- System ease of use and operation
- Data storage and flow between components
- Resources consumed by each component

### Common Findings

**Project Management:**
1. Aggressive schedule forcing inadequate architecture focus
2. No central management or architecture consistency for integrated systems
3. No clear success criteria (multiple subjective views)
4. No clear problem statement (conflicting goals)
5. No architect; no central coordination of technical decisions
6. Lack of stakeholder buy-in on requirements/decisions

**Requirements:**
1. Missing functional requirements (scenarios, incomplete functionality, no acceptance criteria)
2. Missing performance/capacity requirements (user counts, transaction volumes unknown)
3. Missing OA&M requirements (no availability requirements tied to customer needs)

**Design:**
1. **Performance**: No resource budgets, "build now; tune later" mindset, underestimating RDBMS costs, assuming linear scalability
2. **OA&M/Error Recovery**: No error handling architecture for network failures, hw/sw errors, DB conversion, system admin
3. **Scalability**: Non-linear effects from interactions, contention, queuing, side effects on other systems

### AT&T Recommendations

**Requirements:**
- Document all functionality via operational scenarios
- Specify performance/capacity (loads, transactions, data volumes, DB size)
- Define availability per system function (not system as a whole)
- Document all OA&M and critical error scenarios

**Design:**
- Appoint an architect for consistency
- Assign one person to budget and track performance throughout development
- Construct performance budget upfront (CPU, disk, memory, I/O, bandwidth)
- Build an availability model
- Walk through error scenarios to validate recovery
- Hold Discovery and Architecture reviews

### Error Recovery Checklist (Selected)

1. Primary/secondary: Can two systems come up as primary simultaneously?
2. Can the system operate without the database? Accept input for later processing?
3. How complex is database conversion? What if DB is corrupted?
4. Interface consistency for downstream DB updates? Positive acknowledgment required? Retransmit capability?
5. Distributed system failure modes documented? Recovery actions defined?
6. >50% of trouble reports in some systems are communications interface issues

### Key Takeaways from AT&T

- Different logical times for review have different cost/benefit profiles
- Requirements/Architecture/Implementation evolve in parallel (waterfall is unrealistic)
- Checklists encode domain-specific design knowledge and experience
- Significant cross-organizational benefits (expertise transfer between projects)
- Average **10% saving on effort** from early problem identification

## NASA Software Architecture Review Board (SARB)

> See `slides/L19 - Evaluation - NASA.pdf` for full details

### Background

- Established 2009 based on Flight Software Complexity Study recommendation to NASA Chief Engineer
- Single Architecture Review Board for all of NASA, funded by NESC
- Participants from GSFC, JPL, JSC, MSFC, APL, IV&V, LaRC, GRC

### Mission and Charter

**Mission**: Manage flight software complexity through better software architecture

**Charter:**
- Provide constructive feedback to projects in **formative stages** (target Formulation Phase, before PDR)
- Focus on architectural improvements to reduce/manage complexity in requirements, design, implementation, V&V, operations
- Spread best practices across flight software centers
- Contribute to NASA Lessons Learned

### Scope of Architectural Concerns

| Layer | Concern |
|-------|---------|
| Requirements complexity | Quality attributes (performance, availability, maintainability, modifiability, security, testability, operability); watch for unsubstantiated/ambiguous requirements |
| System-level analysis & design | Analyzability -- "point of view is worth 80 IQ points" |
| Flight software complexity | Principles of design; leverage appropriate architectural patterns |
| V&V complexity | Design can simplify or complicate verification |
| Operations complexity | Inadequate design complicates operations; operational workarounds raise risk |

### Review Process

- Pre-review telecons with architect (probes for driving requirements, key decisions, rationale)
- Reviews range from 1-hour telecons to multi-day face-to-face sessions
- SARB provides checklist, quality attributes table, problem statement template, architecture description document guidelines
- Reports are **confidential** to the project

### Notable Reviews

| Project | Scope |
|---------|-------|
| SLS Flight Software | 2- and 3-day face-to-face reviews; "most thorough review ever performed for this FSW design" |
| Orion GNC FDIR FSW | Teleconference + document review |
| cFE/CFS reference architecture | 2-day face-to-face; good separation of concerns but needed governance, scope definition |
| SpaceX dCDR (Commercial Crew) | Teleconference + document review |
| Gateway Vehicle System Manager | Document review |

### Common NASA Architectural Issues

- Boxes-and-lines diagrams lacking clear semantics
- FSW design unnecessarily coupled to hardware details
- Software "gadgets" without domain-tailored abstractions
- Excessive cross-strapping of hardware complicating software without reliability benefit
- Underestimation of fault management testing time
- Fault management that doesn't scale or only handles a laundry list of faults (no defensive mindset)

### SARB Documents (on NEN)

1. Contextually Driven Architecture Reviews
2. Preparing for a Software Architecture Review
3. Project Problem Statement template
4. Quality Attributes Table (with tactics, evidence, prioritization)
5. Reference Architecture Questions
6. Architecture Review Checklist
7. Scope of Architectural Concerns

### Two Notions of "Architecture" (NASA perspective)

| Notion | Focus |
|--------|-------|
| architecture (lowercase) | What gets built: components, interfaces, assembly details |
| Architecture (uppercase) | Why it's built that way: properties of interest, abstractions, domain concepts, guiding principles, body of experience |

"Architecting is about managing complexity" -- Bob Rasmussen, JPL

## SEI ATAM (Architecture Tradeoff Analysis Method)

### Purpose

"Assess the consequences of architectural decisions in light of quality attribute requirements and business goals."

### Goals and Non-Goals

| Goal | Non-Goal |
|------|----------|
| Find trends/correlations between decisions and properties | Resolve problems |
| Discover risks from architectural decisions | Provide precise analyses |

### When to Use

- After architecture specified, before implementation (primary)
- To evaluate architectural alternatives
- To evaluate existing system architecture

### Four Phases

| Phase | Duration | Activities |
|-------|----------|------------|
| **Phase 0**: Partnership & Preparation | Varies (phone/email) | Exchange understanding, agreement to evaluate, field core team |
| **Phase 1**: Initial Evaluation | 1.5-2 days | Architecture-centric, top-down, small technical group |
| **Phase 2**: Complete Evaluation | 1.5-2 days | Stakeholder-centric, bottom-up, larger group |
| **Phase 3**: Follow-Up | Varies (phone/email) | Final report, quality assessment of evaluation |

### Phase 1 Steps (Architecture-Centric)

1. **Present the ATAM** -- rationale, steps, techniques, outputs
2. **Present business drivers** -- business context, high-level functional/QA requirements, architectural drivers, critical requirements
3. **Present architecture** -- technical constraints, external system interactions, architectural approaches
4. **Identify architectural approaches** -- distill drivers, identify key approaches and their rationale
5. **Generate quality attribute utility tree** -- top-down prioritization of QA scenarios with (Importance, Difficulty) pairs
6. **Analyze architectural approaches** -- walk through scenarios against architecture

### Utility Tree

Structure: `Utility -> Quality Attribute -> Refinement -> Scenario (I, D)`

Example:
```
Utility
├── Performance
│   ├── Data Latency
│   │   ├── (L,M) Reduce storage latency on customer DB to < 200ms
│   │   └── (M,M) Deliver video in real time
│   └── Transaction Throughput
│       └── (H,H) ...
├── Modifiability
│   ├── New products: (H,H) Add CORBA middleware in < 20 person-months
│   └── Change COTS: (H,L) Change web UI in < 4 person-weeks
├── Availability
│   ├── H/W failure: (H,H) Power outage at site1 -> redirect to site2 in < 3 sec
│   └── COTS S/W: (H,H) Network failure detected and recovered in < 1.5 min
└── Security
    ├── Confidentiality: (H,M) Credit card transactions secure 99.999%
    └── Integrity: (H,L) Customer DB authorization works 99.999%
```

### Scenario Types

| Type | Purpose | Example |
|------|---------|---------|
| **Use case** | Anticipated uses | Remote user requests DB report via web at peak, receives in 5 sec |
| **Growth** | Anticipated changes | Add new data server to reduce latency to 2.5 sec within 1 person-week |
| **Exploratory** | Unanticipated stress | Half of servers go down during normal operation without affecting availability |

### Analysis Outputs

| Output | Definition |
|--------|-----------|
| **Risk** | Potentially problematic architectural decision |
| **Non-risk** | Good architectural decision (often implicit) |
| **Sensitivity point** | Property of component(s) critical for achieving a particular QA response |
| **Tradeoff** | Property affecting multiple QAs; sensitivity point for more than one attribute |

**Risk example**: "Rules for writing business logic modules in 2nd tier not clearly articulated -- could replicate functionality, compromising modifiability of 3rd tier."

**Tradeoff example**: "Changing encryption level could significantly impact both security and performance."

**Sensitivity point example**: "Average person-days for maintenance might be sensitive to degree of encapsulation of communication protocols."

### Phase 2 Steps (Stakeholder-Centric)

Steps 1-6 recap Phase 1 results, then:
7. **Brainstorm and prioritize scenarios** -- stakeholders generate scenarios; each gets ~0.3 x #scenarios votes
8. **Analyze architectural approaches** -- continue analysis with new scenarios
9. **Present results** -- approaches, utility tree, scenarios, risks/non-risks, sensitivity points, tradeoffs, risk themes

### Problems with ATAM

1. **Disruptive** -- requires stopping everything to prepare, evaluate, fix
2. **Fits waterfall** better than agile, despite claims otherwise
3. **Expensive** -- small projects/orgs reluctant to adopt
4. **Quality depends on evaluators'** training, intuition, experience
5. **No functional requirements coverage**
6. **No guidance** on what to do with output
7. **Significant infrastructure** needed to adopt and maintain as organizational practice

### Tailoring the ATAM

- If architecture drivers already described/prioritized during design, skip those ATAM steps
- Can eliminate stakeholder-centric portions and scenario generation if already done
- May include functional driver reviews
- Continuous evaluation via ADRs as an alternative (treat design as ongoing process, not milestone)

## Continuous Evaluation via ADRs

An alternative to heavyweight review methods:
- Treat design as an ongoing technical process, not an early milestone
- Weave architecture into design, production, and maintenance processes
- Use architecture as anchor for plans, risk mitigation, workforce alignment
- Maintain evolving Architecture Decision Record to document key decisions

## Key Tradeoffs

| Tradeoff | Discussion |
|----------|-----------|
| Early review vs. late review | Discovery reviews catch direction problems cheaply; architecture reviews catch design problems after decisions solidify |
| Heavyweight (ATAM) vs. lightweight (ADRs) | ATAM is thorough but expensive/disruptive; ADRs are continuous but less rigorous |
| External reviewers vs. self-evaluation | External reviewers bring fresh perspective but cost more; self-evaluation builds team capability |
| Breadth vs. depth of review | AT&T checklists ensure coverage; ATAM utility trees focus on highest-priority scenarios |
| Formality vs. agility | NASA SARB targets formulation phase (before PDR); agile teams need lighter-weight continuous evaluation |

## References

- Maranzano et al., "Architecture Reviews: Practice and Experience," IEEE Software, 2005
- Kazman, Klein, Clements, "ATAM: Method for Architecture Evaluation," SEI Technical Report CMU/SEI-2000-TR-004, 2000
- Best Current Practices, Architectural Evaluation, J. Maranzano, AT&T Technical Report
- NASA SARB resources: https://nen.nasa.gov/web/sarb
