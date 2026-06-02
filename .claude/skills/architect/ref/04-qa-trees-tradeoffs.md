# Lecture 04: Quality Attribute Trees and Tradeoffs

## Objectives
- Introduce utility trees for organizing and ranking QA requirements
- Discuss the nature of architectural tradeoffs
- Explore common tradeoff spaces

## Key Concepts

### Utility Trees
Hierarchical organization of QAs and their scenarios:
- **Level 1**: Top-level QAs (Performance, Modifiability, Availability, Security, ...)
- **Level 2**: Finer-grained QA dimensions (e.g., Performance → Data Latency, Transaction Throughput)
- **Level 3**: Abbreviated scenarios with priority rankings

Purpose:
- Determine completeness of QA requirements
- Reduce cost of detailed exploration
- Prioritize investigations and discussions
- Predict areas of controversy

### Prioritization: (Importance, Difficulty) Pairs
Each scenario is ranked with two values:

**Importance** (to system success):
- **H** = must have (don't build it if we can't achieve this)
- **M** = should have (highly desirable but not essential)
- **L** = nice to have

**Difficulty** (to achieve):
- **H** = very difficult (never done before, tricky with current technology)
- **M** = straightforward (similar to prior systems, common solutions exist)
- **L** = simple (done all the time, mere matter of programming)

Focus attention on **(H,H)** scenarios — high importance AND high difficulty.

### Tradeoffs
- Architectural choices typically promote some QAs and inhibit others
- Understanding requirements is critical to balancing tradeoffs
- Often difficulty is linked to achieving one quality compromising another

### Pareto Front
- Multi-dimensional space of feasible alternatives
- Boundary of optimal tradeoffs where you can't improve one QA without degrading another
- Over time the boundary may shift (new technology) or new dimensions come into play
- See `slides/L04 - QA Trees and Tradeoffs.pdf` p.24 for Pareto front diagram

## Examples
- Utility tree example: Performance (data latency, transaction throughput), Modifiability (new products, change COTS), Availability (H/W failure, COTS S/W failures), Security (data confidentiality, data integrity) — see `slides/L04 - QA Trees and Tradeoffs.pdf` p.12
- In-class exercise: deciding where to place data validation (UI tier vs service tier vs data tier) — tradeoffs between responsiveness, consistency, and security

## Key Tradeoffs
- QAs and priorities change over time — utility trees should be revised
- Consider reversibility: what decisions are reversible if wrong? Which are practically impossible to change later?
- Some QAs may not be required now but need future planning
- Distributed systems tradeoff: geographic replication improves latency/availability but complicates consistency
