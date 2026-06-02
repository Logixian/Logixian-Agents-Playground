# Lecture 16: Agile Architecture Design

## Objectives
- Understand how architects design systems in practice (when to start, refine, stop)
- Understand systemic architecture design processes: ADD 3.0 and ACDM
- Understand how architecture work fits within agile development

## Key Concepts

### Architecture Design Involves Uncertainty
Common sources:
- **Requirements uncertainty**: Stakeholder needs/priorities evolve
- **QA uncertainty**: Whether architecture achieves performance/scalability/reliability targets
- **Technology uncertainty**: New frameworks/platforms may not behave as predicted
- **System context uncertainty**: Workload, users, operating environment may change

### Risk-Driven Architecture Design
- Focus on most important and uncertain concerns
- Prioritize scenarios that are HIGH importance and HIGH difficulty
- Reduce risk early

### When to Start Architecture Design
When there is sufficient (not complete) understanding of drivers:
- Main architecture drivers are stable and understood
- Major requirement areas identified
- A candidate high-level structure can be proposed

### Where to Start
- Start from system context
- Identify Architecturally Significant Requirements (ASRs / drivers)
- These guide initial structure and decomposition

### Refining the Architecture
Iterative: decompose elements → introduce styles/tactics → evaluate against QAS → refine based on new requirements

### When to Stop
When: major drivers addressed, architecture supports key QAS, core structure stable enough to guide development, largest risks reduced.

## Styles/Tactics/Patterns

### Attribute Driven Design (ADD 3.0)
Developed at SEI to help architects design architectures meeting user needs.

**Iterative Design Process:**
1. **Select Drivers**: Review inputs, select ASRs for this iteration
2. **Choose Strategies**: Select styles, tactics, design concepts
3. **Instantiate Architecture**: Allocate responsibilities, define interfaces/connections, sketch views
4. **Evaluate Design**: Analyze, check if goals met

**ADD Roadmap (Iteration Goals):**
| Iteration | Goal | Design Concepts |
|---|---|---|
| Early | Structure the system | Reference architectures, deployment patterns |
| Middle | Support primary functionality | Domain objects/components, external components |
| Late | Support QAS and other concerns | Architectural patterns, tactics |

**Outputs**: Architectural structures, design decisions, design rationale and tradeoffs

### Architecture-Centric Design Method (ACDM)
Places architecture at center of development. Greater emphasis on evaluation and experiments.

**Stages:**
1. **Discover drivers** (divergent — brainstorm)
2. **Establish project scope** (convergent — refine)
3. **Create/refine architecture** (design based on drivers)
4. **Architecture evaluation** (does design support drivers?)
5. **Production go/no-go** (assess readiness, classify issues: no action / repair / need more info / need experiments)
6. **Experiments** (test architecture hypotheses, reduce uncertainty)
7. **Production planning**

### Architecture Experiments
Purpose: Test architecture hypotheses, reduce uncertainty
- Example: "Can RabbitMQ process 500 events/sec?" → Prototype publisher/consumer, simulate workload, measure throughput
- Template includes: Experiment ID, purpose, expected outcomes, resources, artifacts, description, duration, results/recommendations

### Architecture Backlog
Track architecture tasks explicitly alongside development tasks (prototype technologies, evaluate frameworks, measure performance).

### Agile Architecture Approaches
| Approach | Description |
|---|---|
| Big Upfront Design | Extensive architecture before development |
| Evolutionary Design | Architecture emerges during development |
| Hybrid | Mix architecture and development activities |
| Continuous Architecture | Make decisions based on cost of change — delay when possible, decide early when cost of change is high |

### Types of Systems and Architecture Approach
- **Greenfield in novel domains**: Lots of uncertainty, more innovative → quickly come to candidate architecture, iterate
- **Greenfield in mature domains**: Well-known, less innovative → more upfront architecture worthwhile
- **Brownfield**: Changes to existing systems

### Design Kanban Board
Track QAS and experiments across three columns: Not Yet Addressed → Partially Addressed → Completely Addressed

## Examples
- ADD iteration: "API service responds to 500 req/sec within 1 second" → hypothesis: caching layer → experiment: prototype and benchmark → evaluate: did it work?
- ACDM experiment template — see `slides/L16 - Agile Architecture.pdf` p.32

## Key Tradeoffs
- Architecture processes balance guidance and adaptability
- Avoid excessive upfront design, but establish rough structure
- Architecture decisions based on risk and cost of change
- Architecture work should reduce risk while preserving flexibility
- "A good architecture enables agility" — Simon Brown
- Manage technical debt deliberately: understand shortcuts, document them, plan for refactoring
