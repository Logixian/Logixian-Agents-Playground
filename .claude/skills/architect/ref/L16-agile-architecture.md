# Lecture 16: Agile Architecture Design

**Course:** 17-633/882 Architectures for Software Systems
**Authors:** Bradley Schmerl, David Garlan, George Fairbanks
**Date:** 3/16/2026

---

## Lecture Objectives

- Understand how architects design systems in practice
  - When to start designing the architecture
  - How to refine it during development
  - When architectural design is "done enough"
- Understand systemic architecture design processes
  - Attribute Driven Design (ADD)
  - Architecture Experimentation (inspired by ACDM) to reduce uncertainty
- Understand how architecture work fits within agile development

---

## Doing Architecture Design

Architectural design raises several practical questions:
- When should architecture design begin?
- How does the architecture evolve as we learn more about the system?
- When is architecture sufficiently stable to guide development?

---

## Architecture Design involves Uncertainty

Architects must make decisions before everything is known.

**Common sources of uncertainty:**
- **Requirements uncertainty** — Stakeholder needs and priorities may evolve
- **Quality attribute uncertainty** — Whether the architecture can achieve performance, scalability, reliability targets
- **Technology uncertainty** — New frameworks, platforms, or integrations may not behave as predicted
- **System context uncertainty** — Workload, users, or operating environment may change

---

## Risk-Driven Architecture Design

- Architecture work should focus on the most important and uncertain concerns
- Uncertainty implies risk; risk-driven approaches reduce risk early on
- Most structured architecture design methods follow this principle
- Prioritize scenarios that are **HIGH importance** and **HIGH difficulty**

---

## Architecture as Hypotheses

- Architectural choices are **hypotheses** about system behavior
  - E.g., "Using asynchronous messaging will support the required throughput"
- These hypotheses must be validated — the earlier, the cheaper
- This is especially true of large-impact decisions
- Through design and experimentation, some hypotheses become architectural decisions

---

## When to Start Architecture Design

Start when there is **sufficient understanding of the drivers** and when you can form plausible hypotheses about the system's high-level structure.

"Sufficient" does not mean complete. It means:
- The main architecture drivers are stable and understood
- Major requirement areas have been identified
- A candidate high-level structure can be proposed

---

## Where to Start

- Start from **System Context**
- Identify **Architecturally Significant Requirements (ASRs)** — i.e., drivers
  - Have a profound effect on the architecture
  - Often captured as Quality Attribute Scenarios
  - Gathered from requirements, stakeholder interviews, quality attribute workshops (e.g., ATAM)
- These drivers guide the initial architectural structure and decomposition

---

## Refining the Architecture

Architecture design proceeds **iteratively**.

**Typical refinement activities:**
- Decompose system elements into smaller components
- Introduce styles and tactics to address QAs
- Evaluate/refine whether the architecture satisfies QA Scenarios
- Refine the design based on new requirements or insights

The architecture evolves as additional drivers and constraints are considered.

---

## When to Stop Architecture Design

Architecture never stops entirely — it continues as development proceeds.

The real question is: **when can we move from architecture to development?**

Typically, when:
- Major architectural drivers have been addressed
- The architecture supports key quality attribute scenarios
- The core system structure is stable enough to guide development
- The largest architectural risks have been reduced

---

## Architecture Design needs Structure

Architecture design is difficult because of:
- Multiple stakeholders with different goals
- Conflicting quality attributes and tradeoffs
- Uncertainty about requirements, technologies, and system behavior
- Large design spaces with many possible architectural options

Architecture processes provide structure for reasoning about design decisions, while still allowing design creativity.

---

## Attribute Driven Design (ADD 3.0)

Developed at the Software Engineering Institute to help architects:
- Design architectures to meet users' needs
- Address important quality attribute requirements
- Select appropriate architectural strategies (styles & tactics)
- Understand tradeoffs among quality attributes

ADD structures architectural decision making.

### Architecturally Significant Requirements (ASRs)

| Design Decision Category | Look for requirements addressing… |
|--------------------------|-----------------------------------|
| Allocation of responsibility | Planned evolution of responsibilities, user roles, system modes, major processing steps, commercial packages |
| Coordination model | Properties of coordination (timeliness, concurrency, correctness), names of external components, protocols, middleware, networks |
| Data model | Processing steps, information flows, major domain entities, access rights, persistence |
| Management of resources | Timing, concurrency, memory, scheduling, multiple users, energy usage, soft resources |
| Mapping among elements | Plans for teaming, processors, families of processors, configurations |
| Binding time decisions | Extension of or flexibility of functionality, regional distinctions, language distinctions, portability, calibrations, configurations |
| Choice of technology | Named technologies, changes to technologies |

### ADD Iterative Design

Each iteration consists of 4 steps:

1. **Select Drivers** — Review inputs; select ASRs for this iteration
2. **Choose Strategies** — Select styles and tactics; choose design concepts
3. **Instantiate Architecture** — Allocate responsibilities; define interfaces/connections; sketch views
4. **Evaluate Design** — Analyze the design; check if goals are met

### Example ADD Iteration

- **Goal:** API service responds to 500 req/sec within 1 second
- **Hypothesis:** Introducing a caching layer will give this response
- **Experiment:** Prototype API & cache and benchmark latency and throughput
- **Evaluation:** Did the architecture achieve the goal?
  - Yes → Note any new uncertainties introduced; make decision and record design
  - No → Try a different approach (new hypothesis)

### ADD Roadmap: Iteration Goals

| Iteration | Goal | Design Concepts |
|-----------|------|-----------------|
| Early | Structure the system | Reference Architectures / Styles, Deployment Patterns, External components |
| Mid | Support primary functionality | Architectural Styles/Patterns, External components (Domain objects/components) |
| Late | Support QAS and other concerns | Tactics, Architectural Patterns, Deployment Patterns, External components |

### What ADD Produces

- Architectural structures (components, connectors, deployment structures)
- Design decisions
- Design rationale and tradeoffs
- Design traceability — easy to see how requirements lead to architecture decisions/structures
- Captured architectural knowledge

### ADD Summary

- Iterative method to transform drivers into structures
- Structures the design process so it can be performed methodically
- **Design concepts** are the building blocks:
  - Reference architectures, deployment patterns, architecture styles and patterns, tactics, external components/frameworks

---

## Architecture-Centric Design Method (ACDM)

Places architecture at the **center of development**. Architecture is used to:
- Organize architectural drivers
- Guide design and evaluation
- Drive experiments to reduce uncertainty
- Support planning and tracking

In contrast to ADD, ACDM places greater emphasis on **evaluating architectural decisions** and **using experiments** to reduce uncertainty during development.

### ACDM Stages

**Requirements Phase:**
- Stage 1: Discover drivers
- Stage 2: Establish project scope

**Design/Refinement Phase:**
- Stage 3: Create/Refine architecture
- Stage 4: Architecture Evaluation

**Production Go/No-Go:**
- Stage 5: Production go/no go decision

**Experimentation:**
- Stage 6: Experiments
- Stage 7: Production

### ACDM: Requirements

- **Stage 1 (Divergent)** — Brainstorming, lots of ideas; focus is collection not analysis
  - Meet with stakeholders, focus on: Epic functional scenarios, Quality attribute scenarios, Business and technical constraints
- **Stage 2 (Convergent)** — Refine and scope on what will actually be done

### ACDM: Design/Refinement

**Create/Refine (Stage 3):**
- Design system based on drivers; start notionally and refine with each iteration
- Consider all architecture views
- Design should be detailed enough to support evaluation

**Evaluation (Stage 4):**
- Does the design support the drivers?
- Use Architecture Design Evaluation Workshop
- Subsequent iterations refine architecture based on experiment results

### ACDM: Go/No-Go Decision

For each issue uncovered in Stage 4, identify one of:
1. No action required
2. Repair, update, clarify documentation
3. More technical information required
4. Architecture drivers information required
5. Experimentation required

Use this to decide whether to Go to production.

### Architecture Experiments

**Purpose:** Test architecture hypotheses; reduce uncertainty about architecture decisions

**Examples:**
- Scalability benchmarks
- Technology prototypes
- Integration tests

**Example:**
- Question: Can RabbitMQ process 500 events/sec?
- Method: Prototype publisher/consumer and simulate workload
- Measure: Throughput

### ACDM Experiment Template

| Element | Description |
|---------|-------------|
| Experiment ID | Unique identifier/title |
| Responsible Engineer | Team member responsible |
| Purpose | Reason for conducting; how it will refine the architecture |
| Expected Outcomes | What the engineer expects from the experiment |
| Resources Required | Compute resources (software/hardware), people, time, money |
| Artifacts | Software, documentation, etc. created as a result |
| Experiment Description | Software to be written, research to be performed, information to be collected |
| Duration | Explicit start date, stop date, milestones |
| Results and Recommendations | Actual results, deviations from expected outcomes, recommendations |

---

## Architecture Backlog

Track architecture tasks explicitly — just like other development tasks.

**Examples:**
- Prototype technologies
- Evaluate a framework
- Measure performance

**Benefits:**
- Makes architecture work visible
- Helps scope and track experiments
- Connects experiments to architecture decisions and documentation

---

## Agile Architecture

Architecture processes must balance **guidance** and **adaptability**.

**Key ideas:**
- Avoid excessive upfront design
- Establish rough structure to guide development
- Refine the architecture as the system evolves
- Evaluate architectural decisions continuously

Architecture work continues throughout development, not just at the beginning.

### Three Approaches to Architecture in Agile

| Approach | Description |
|----------|-------------|
| **Big Upfront Design** | Full architecture specified before development |
| **Evolutionary Design** | Architecture emerges from development |
| **Hybrid / Continuous Approach** | Architecture decisions made based on cost of change; delay when possible, make early when change is costly |

### Continuous Architecture: Timing Decisions

Make architectural decisions based on **cost of change**.

**Key ideas:**
- Delay architectural decisions when possible
- Make decisions early when the cost of change is high
- Use experiments and evaluation to reduce uncertainty
- Continuously refine the architecture as development proceeds

**Goal:** Maximize flexibility while managing architectural risk.

### Types of Systems

| Type | Examples | Approach |
|------|----------|----------|
| **Greenfield in novel domains** | Google, Amazon (2000s), OpenAI (2022) | Domain mostly unknown, lots of uncertainty, more innovative |
| **Greenfield in mature domains** | Traditional enterprise apps, standard mobile apps | Well-known domains, less innovative |
| **Brownfield** | Changes to existing systems | — |

### Agile Architecture — Advice

> "A good architecture enables agility" — Simon Brown

1. **Establish strong architectural foundation** — Define a clear high-level architecture early
2. **Work iteratively** — Mix architecture and development activities; focus on small parts at a time
3. **Manage technical debt deliberately** — Understand where shortcuts are taken; document them and plan for refactoring/refinement

### Agile Architecture by Project Type

| Project Type | Recommendation |
|--------------|----------------|
| Large and complex systems with stable, well-understood requirements | Worthwhile to do a lot of architecture upfront |
| Big projects with vague, unstable requirements | Quickly come to a complete candidate architecture; iterate through architecture activities along with development |
| Smaller projects with uncertain requirements | Try to agree on central patterns/tactics |

---

## Design Kanban Board

Track architecture concerns in three states:

| Not yet addressed | Partially addressed | Completely addressed |
|------------------|--------------------|--------------------|
| Open QAS and constraints | In-progress experiments (e.g., Can RabbitMQ process 500 events/sec?) | Resolved QAS and experiments |

---

## Summary

- Architecture design can be guided by structured processes
  - **ADD:** Transforms architectural drivers into architectural structures
  - **ACDM:** Explicit process for evaluation and experimentation
- Architecture in agile environments:
  - Architecture evolves alongside development
  - Architecture decisions based on risk and cost of change
  - Architecture work should reduce risk while preserving flexibility
- All these approaches produce **architecture knowledge** → needs to be captured in architecture documentation

---

## References

- *Architecting Software Intensive Systems: A Practitioners Guide*, Anthony J. Lattanze, Auberbach Publications, 2008
- *Architecture Centric Design Method*, Anthony J. Lattanze, SEI Presentation, 2006
- *Tutorial Summary for Designing Software Architecture using ADD 3.0*, Rick Kazman, Humberto Cervantes, Serge Haziyev, Olha Hrytsay, 2016 13th Working IEEE/IFIP Conference on Software Architecture (WICSA)
