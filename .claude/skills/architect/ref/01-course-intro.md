# Lecture 01: Course Introduction

## Objectives
- Define software architecture and explain its importance
- Relate software architecture to programming
- Provide historical perspective on the field
- Outline 17-633 course content and mechanics

## Key Concepts

### Definition of Software Architecture
"The software architecture of a computing system is the set of structures needed to reason about the system, which comprise software elements, relations among them and properties of both." — *Documenting Software Architecture: Views and Beyond*, 2nd Ed., Clements et al. 2011

### Why Architecture Matters
- Bridges the gap between requirements and implementations
- Exposes critical system-level requirements and key tradeoffs
- Enables reuse of common patterns, styles, and expertise
- Reduces costs through product lines, platforms, frameworks
- AT&T Architecture Review Board (1988-2005): reviewed 700+ projects; "a correct architecture has the largest single impact on cost and quality" (Maranzano 1995)

### Architecture vs Programming
| Architecture | Programming |
|---|---|
| Interactions among parts | Implementation of parts |
| Structural properties | Computational properties |
| Declarative, mostly static | Operational, mostly dynamic |
| System-level properties | Algorithmic properties |
| Outside module boundary | Inside module boundary |

### Issues Addressed by Architecture
- Gross decomposition of a system into parts (using rich abstractions for interaction)
- Emergent system properties (performance, reliability, security, evolvability)
- Rationale (justifying architectural decisions and tradeoffs)
- Envelope of allowed change ("load-bearing walls" and constraints)

## Course Themes
1. **Architecture as decision-making** — design decisions that shape structure, behavior, and evolution
2. **Structural strategies for quality attributes** — styles, tactics, patterns
3. **Identifying architecture drivers and constraints** — from requirements to design
4. **Evaluating and justifying decisions** — tradeoff analysis
5. **Preserving architecture intent in code** — keeping implementation consistent with design
6. **Architecture and AI** — how architecture changes for AI-enabled systems

## Historical Evolution
- **1980s**: Informal box-and-line diagrams, ad hoc expertise, no identified architect role
- **1990s**: Recognition of architects, design reviews, product lines, codification of vocabulary
- **2000s**: UML-2, Model-Driven Architecture, enterprise standards (TOGAF), skepticism about architecture in agile
- **2010s**: Web services, SOA, clouds, platforms/ecosystems (iOS, Android, ROS), CI/CD, agile+architecture
- **2020s**: Microservices, cloud-native, Kubernetes, DevOps, AI-based systems, ML pipelines

## Course Mechanics
- **Grading**: Quizzes 15%, Assignments 25%, Midterm 25%, Project 20%, Oral defense 10%, Attendance 5%
- **Assignments**: A1 (Drivers), A2 (QAs), A3 (Styles & Tactics), A4 (Design), A5 (Critique)
- **Textbook**: Bass, Clements, Kazman. *Software Architecture in Practice*, 4th Ed. 2021
- **Course is linear by design, but architecture is iterative** — NOT encouraging big upfront design
