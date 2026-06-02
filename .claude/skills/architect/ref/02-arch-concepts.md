# Lecture 02: Basic Software Architecture Concepts

## Objectives
- Clarify architecture terminology (enterprise, system, software architecture)
- Discuss the role of a software architect
- Introduce three core concepts: views, styles, tactics

## Key Concepts

### Levels of Architecture
- **Enterprise architecture**: describes business structures and processes; may or may not involve software
- **System architecture**: elements and interactions of a complete system (HW + SW); not substructure
- **Software architecture**: structures needed to reason about a software system

### Role of a Software Architect
- Refine/clarify product properties; ensure necessary properties are present
- Partition and structure the system; constrain downstream designers
- Provide technical leadership (prototyping, design oversight, technology tracking)
- **The role is changing**: from single architect to distributed responsibility (product manager, framework designer, framework integrator, programmers, end users)

### Three Core Concepts

#### 1. Views
A **view** is a representation of a set of system elements and the relations associated with them — not all elements, just some.

Three categories of views:
- **Module views** (static): code units, classes, functions, interfaces
- **Component-and-Connector (C&C) views** (runtime): processes, dataflow, sequence diagrams
- **Allocation views** (physical): deployment to hardware, file systems, team assignments

Different stakeholders need different views (like a cardiologist vs orthopedist viewing the human body).

#### 2. Styles
"An architectural style is a set of element and relation types, together with a set of constraints on how they can be used."

- Recurring structural forms observed across systems
- Known properties that can be reused
- See `slides/L02 - Arch Concepts.pdf` p.25-52 for style taxonomy diagrams

#### 3. Tactics
- Techniques that work within a style to improve some quality attribute
- Styles determine element/relationship kinds; tactics refine quality achievement
- Examples: redundancy (availability), caching (performance), firewalls (security)

## Styles/Tactics/Patterns

### Module View Styles
| Style | Elements | Relations | Use |
|---|---|---|---|
| Decomposition | Modules | Is-part-of | Work assignments, impact analysis |
| Generalization | Modules | Is-a | Reuse, managing definitions |
| Layered | Layers (virtual machines) | Allowed-to-use | Portability, reuse |

### C&C View Styles (Taxonomy)
- **Dataflow**: batch sequential, pipes & filters, workflow
- **Call-return**: main-subroutine, OO, component-based, P2P, SOA, N-tiered
- **Event-based**: async messaging, pub-sub, implicit invocation, data-triggered
- **Data-centered**: repository, blackboard, shared variables

### Allocation View Styles
- **Deployment**: SW to HW nodes (performance, availability)
- **Implementation**: SW to file system structures
- **Work assignment**: SW to organizational units

## Examples
- Alternating characters system: module view (decomposition with uses relations) vs C&C view (pipe-and-filter) — see `slides/L02 - Arch Concepts.pdf` p.23-24
- Availability tactics tree — see `slides/L02 - Arch Concepts.pdf` p.60

## Key Tradeoffs
- Views are complementary, not competing — you need multiple perspectives
- Styles provide reusable structure but constrain design choices
- Tactics complement styles to address quality attributes the style alone doesn't achieve
