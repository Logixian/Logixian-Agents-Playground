# Lecture 17: Principles of Architecture Documentation

**Course:** 17-635/17-882 Architectures for Software Systems
**Authors:** David Garlan, Bradley Schmerl, George Fairbanks
**Date:** 18 March 2026
**Source:** Based on *Documenting Software Architectures: Views and Beyond* (Clements et al., Addison Wesley 2003/2011)

---

## Lecture Objectives

1. Overview of Principles and Techniques of Good Architectural Documentation
2. General Principles
3. Context Diagrams
4. Overlays and Combined Styles
5. Hierarchy
6. Documenting Interfaces and Behavior
7. UML

---

## Why Documentation Fails

**Possible failures:**
- Poor diagram semantics
- Novel syntax
- High creation effort
- High comprehension effort

**Common problems in practice:**
- Ambiguous box-and-line diagrams
- Poor justification of rationale
- No discussion of alternatives
- Inconsistent use of notations
- Confusing combinations of view types

---

## 7 Rules of Sound Documentation

1. Write documentation from the **reader's point of view**
2. **Avoid unnecessary repetition**
3. **Avoid ambiguity**
4. Use a **standard organization**
5. Keep documentation **current, but not too current**
6. **Review** documentation for fitness of purpose

---

## Basic Principles of Good Architectural Documentation

- **Graphics communicate semantics effectively**
  - Elements have different shapes/colors with a key/legend
  - Connector types are clearly identified and defined
- **Diagrams contain appropriate amount of detail**
  - Each view fits on a page
  - Separate into multiple views and diagrams
  - Use hierarchy to hide/expose detail
- **Clear distinction between view types**
  - Separation of concerns
  - With mappings where appropriate

---

## Bad Documentation Checklist

- Lines all look the same — arrows don't mean anything
- Too little or too much detail; low-level concerns mixed with architectural abstraction
- No key or legend
- Missing relationships
- Inconsistent use of notations
- Inconsistent/mixed perspectives and view types
- Unclear project context
- Poor justification of rationale for design choices
- No discussion of alternatives considered

---

## Some General Points

- Architectures convey design decisions, including structure and semantics
- **Bad documentation usually indicates fuzzy thinking** — if you can't write it down, you probably don't understand what you are doing
- Documentation is not an afterthought; all stages of architecture should have appropriate documentation
- Different kinds of documentation are often needed at different times in the lifecycle:
  - Early on: informal sketches
  - Later: more formally defined structure
  - Then: semantics (protocols, interfaces)
- Pictures are not enough; documentation also needs:
  - Rationale and context
  - Prose to interpret the pictures

---

## Early-Stage Architectural Documentation

**"Minimum viable architecture" documentation:**

- One context diagram
- One or two key structural views
- Short interface/protocol notes for architecturally significant interactions
- A list of major decisions/rationale
- Pointers to constraints and QAS

---

## General Architecture Document Structure

### Front Matter
- Title page, table of contents, revision history, and author information
- Executive summary

### Document Description and Roadmap
- Intended audience and relevant sections
- Document structure and how to navigate
- Conventions and acronyms
- References and relevant documents

### Project Overview
- Purpose and scope
- Business, organization, mission, marketing context
- Relevant stakeholders and how they interact with the system

### Architectural Drivers
- High-level functional requirements, technical/business constraints
- Quality attribute requirements
- Prioritized functional and quality attribute requirements

### System Context
- Shows the system's relationship to external entities (systems, peripherals, organizations, stakeholders)

### Detailed Decomposition — Documenting Views
- System decomposed in each relevant perspective
- May be hierarchical
- Each perspective has at least one view, but may have many
- Includes drawings and prose (rationale)
- Describes element and relationship responsibilities

---

## Documenting Views

An architect must document software-intensive systems from at least **three perspectives**:

| Perspective | Description |
|-------------|-------------|
| **Static** | How is it structured as a set of code units? |
| **Dynamic** | How is it structured as a set of elements with run-time behavior and interactions? |
| **Allocation** | How does it relate to non-software structures in its environment? |

---

## Choosing a Notation

| Type | Examples | Notes |
|------|----------|-------|
| **Informal** | Boxes and lines | Effective if you follow good documentation guidelines |
| **Semi-formal** | UML | General-purpose; not specifically for architecture — needs care and discipline |
| **Formal** | Acme, Alloy | May be general-purpose (Alloy) or architecture-specific ADL (Acme); provides analytic leverage |

---

## Technique 1: Views & Styles

**Multiple views** are the most important concept — you will need multiple views to document your architecture.

- Each view captures some aspect of the system
- Allows focus on the right perspective to understand some property of the design
- Helps manage complexity through separation of concerns

### Styles (recap)
- Define a specialized vocabulary for a kind of view (pipes and filters, clients and servers, publishers and subscribers)
- Establish constraints (e.g., clients can't talk to each other directly; no cycles in a pipe-and-filter system)
- Provide analysis opportunities

### Module Views
**Elements:** Modules — code units that implement a set of responsibilities
**Relations:**
- *A is part of B* — part-whole relation
- *A depends on B* — dependency relation
- *A is a B* — specialization/generalization relation

**UML notation:** Class diagrams (Aggregation, Dependency, Generalization)

### Module Styles

| Style | Description | Use |
|-------|-------------|-----|
| **Decomposition** | Hierarchical decomposition of modules | Supports concurrent development; starting point for detailed design; change/impact analysis; work assignments |
| **Generalization** | Specialization hierarchy | Supports reuse; managing large numbers of definitions |
| **Layered** | Virtual machines | Supports portability, reuse |

#### Layered Style Rules
- Every piece of software is assigned to exactly one layer
- Software in a layer is allowed to use software in the next lower layer
- Variations: sidecars, layer bridging

**Informal notations:** boxes and arrows, stacks of boxes, concentric rings

### Component-and-Connector (C&C) Views
**Elements:**
- *Components* — principal units of run-time computation and data stores
- *Connectors* — interaction mechanisms

**Relations:** Attachment of components' ports to connectors' roles (interfaces with protocols)

**Properties:** Quality attributes and style-specific properties for construction and analysis

**Key question for C&C arrows:** What does the arrow mean?
- A passes control to B
- A passes data to B
- A gets a value from B
- A streams data to B
- A sends a message to B

### Allocation Views
**Elements:** Software elements + Environment elements
**Relations:** allocated-to

| Allocation Style | Description |
|-----------------|-------------|
| **Deployment** | Allocates software elements to processing and communication nodes; properties for performance and availability |
| **Implementation** | Allocates software elements to file system structures |
| **Work Assignment** | Allocates software elements to organizational work units |

---

## Technique 2: Context Diagrams

- Show the **system boundary** and the environment with which the system interacts
- Show external interfaces and other systems on which it relies
- Indicate what the system's environment is (users with different roles, other computing systems)
- May have multiple context diagrams (different contexts for different views; usually given for C&C view)

---

## Technique 3: Overlays

Combine multiple views to show the mapping between them or add annotations showing grouping and logical relationships.

**Examples:**
- Layers and modules
- Components and tiers
- Deployment

A simple approach: use **color coding and legend** to combine information from two styles in the same view.

---

## Technique 4: Hierarchy

To keep detail manageable:
- Elements are defined in more detail in separate views
- Different styles have different hierarchical relationships:
  - **Module Decomposition:** Part-whole relationships
  - **C&C Tiered view:** Substructure
  - **C&C:** High-level vs. low-level decomposition

---

## Technique 5: Interfaces and Behavior

A key step when moving from informal, high-level diagrams to more-detailed architectural specifications.

### Documenting Interfaces

An **interface** is a boundary across which two independent entities interact or communicate.

An **interface specification** is a statement of element properties that the architect chooses to make known.

**Organization for documenting an interface:**

```
Element Interface Specification
  Section 1. Interface identity
  Section 2. Resources provided
    Section a. Resource syntax
    Section b. Resource semantics
    Section c. Resource usage restrictions
  Section 3. Locally defined data types
  Section 4. Error handling
  Section 5. Variability provided
  Section 6. Quality attribute characteristics
  Section 7. What the element requires
  Section 8. Rationale and design issues
  Section 9. Usage guide
```

### Documenting Behavior

Interfaces tell only part of the story:
- Usually don't say what is the order of interactions
- Usually don't say how interactions occur across multiple elements

**Many notations for behavior** — level of detail/formality depends on context and audience.

---

## UML for Architecture

**What is UML?**
- OMG standard (from Booch, Jacobsen, Rumbaugh — "The Three Amigos")
- Object-oriented origin and focus
- Many diagram types (predefined and create-your-own)

Useful for: Module views, Runtime views, Allocation views

### Documenting C&C Views in UML

| Concept | UML Representation |
|---------|-------------------|
| Component types | UML components (in component catalog) |
| Components | UML component instances |
| Ports | UML ports |
| Connectors | UML connectors (stereotyped to indicate type) |
| Nested structure | UML Structure Diagrams |
| Styles | Stereotypes or Profiles |

### Component Types — Advice
- Show ports, possibly with port multiplicity
- Optionally include required/provided services
- Use stereotypes to relate to style component types

### Component Instances — Advice
- Distinguished by use of `:` (e.g., `f1:Filter` or `:Filter` for anonymous)
- Ports should be consistent with type
- Don't use interfaces (provides/requires lollypops) on component instances — only on component types

### Connectors

| Variation | Use Case |
|-----------|----------|
| Simple UML connector (unadorned line) | Default; stereotype to indicate connector type |
| UML component as connector | When connector is complex (has substructure or is n-ary) |
| Navigatable connectors | When you want to indicate directionality |
| Assembly connectors (ball-and-socket) | **Only** for call-return connectors |
| Tagged values | Adding auxiliary information via stereotype attributes |

**Connector advice:**
- Use simple UML connectors whenever possible
- Don't use arrows unless there is natural directionality
- Use stereotypes to indicate the connector type
- Tagged values associated with a stereotype are a good way to add auxiliary information
- **Never use dependencies in a C&C view**

### Hierarchy in UML
- UML components may have nested structure
- Internal structure is simply a UML C&C diagram
- Use **UML delegation connectors** (solid line with open arrowhead) to indicate how external ports relate to internal ports
  - Called "bindings" in Acme; "interface delegation" in *Documenting SW Arch, 2nd Edition*

### General Warnings
Many tools do not support all UML conventions:
- Ports with provides/requires interfaces
- Tagged values with stereotypes
- Navigatable connectors

In practice people commonly misuse:
- Lollypops everywhere (even for non-call/return connectors)
- No ports
- Dependencies for connectors
- Components for connectors

---

## Session Summary

**Key takeaways:**
1. Bad documentation usually indicates fuzzy thinking
2. Use multiple views
3. Level of detail/formality depends on the context of use
4. Producing good documentation is not easy, but following standard guidelines can help
5. It is worth the effort
