# Lecture 17: Principles of Architecture Documentation

## Objectives
- Overview of principles and techniques of good architectural documentation
- Context diagrams, overlays, hierarchy, interfaces, behavior
- UML for architecture documentation
- Examine examples of good and bad documentation

## Key Concepts

### Why Documentation Matters
- Architecture documentation is for communicating information and ideas
- If you can't explain it to someone, it has little value
- Bad documentation usually indicates fuzzy thinking

### Common Documentation Problems
- Ambiguous box-and-line diagrams
- Poor justification of rationale
- No discussion of alternatives
- Inconsistent use of notations
- Confusing combinations of view types

### 7 Rules of Sound Documentation
1. Write from the reader's point of view
2. Avoid unnecessary repetition
3. Avoid ambiguity
4. Use a standard organization
5. Keep documentation current, but not too current
6. Review for fitness of purpose

### Basic Principles of Good Documentation
- Graphics communicate semantics (different shapes/colors with key/legend; connector types identified)
- Appropriate detail (fits on a page; separate views; use hierarchy)
- Clear distinction between view types (separation of concerns with mappings)

### General Architecture Document Structure
1. **Front Matter**: Title, TOC, revision history, executive summary
2. **Document Description & Roadmap**: Audience, structure, conventions, references
3. **Project Overview**: Purpose/scope, stakeholders, business context
4. **Architectural Drivers**: Functional requirements, constraints, QA requirements (prioritized)
5. **System Context**: Relationship to external entities
6. **Detailed Decomposition (Views)**: Static views, dynamic views, physical views with drawings and prose/rationale

### Early-Stage "Minimum Viable Architecture" Documentation
- One context diagram
- One or two key structural views
- Short interface/protocol notes for significant interactions
- List of major decisions/rationale
- Pointers to constraints and QAS

## Styles/Tactics/Patterns

### Documentation Techniques

**1. Views & Styles**
Multiple views needed — each captures some aspect, manages complexity through separation of concerns.

**Three perspectives (at minimum):**
- **Static (Module views)**: How it's structured as code units
- **Dynamic (C&C views)**: Runtime behavior and interactions
- **Allocation views**: Relationship to non-software structures (hardware, file system, organization)

**Module View Styles:**
- Decomposition (is-part-of), Generalization (is-a), Layered (allowed-to-use)

**C&C Structural Concepts:**
- System, Component, Port, Connector, Role

**Allocation View Styles:**
- Deployment (SW → HW nodes), Implementation (SW → file system), Work assignment (SW → org units)

**2. Context Diagrams**
- Show system boundary, external interfaces, other systems
- Indicate environment (users with roles, other computing systems)
- May have multiple context diagrams for different views

**3. Overlays**
- Combine multiple views to show mappings or annotations
- Examples: Layers + modules, C&C + tiers, allocation + C&C

**4. Hierarchy**
- Hide/expose detail at different levels
- Part-whole in module decomposition; substructure in C&C tiers
- Elements defined in more detail in separate views

**5. Documenting Interfaces**
Organization: Interface identity → Resources provided (syntax, semantics, usage restrictions) → Data types → Error handling → Variability → QA characteristics → Requirements → Rationale → Usage guide

**6. Documenting Behavior**
Interfaces alone don't capture order of interactions or cross-element behavior. Many notations available; formality depends on context.

### Choosing a Notation
| Level | Examples | Notes |
|---|---|---|
| **Informal** | Boxes and lines | Effective if following good guidelines |
| **Semi-formal** | UML | General-purpose, needs care and discipline |
| **Formal** | Acme, Alloy | ADLs; provide analytic leverage |

### UML for Architecture
- **Component types** → UML components with ports, interfaces, stereotypes
- **Component instances** → UML component instances (distinguished by `:`)
- **Connectors** → UML connectors (unadorned lines), stereotyped for type
- **Variations**: Navigatable connectors (directionality), assembly connectors (ball-and-socket, ONLY for call-return), tagged values
- **Hierarchy** → UML nested structure with delegation connectors
- **Module views** → UML class diagrams (aggregation, dependency, generalization)

### UML Advice
- Don't mix component types and instances in same diagram
- Use named ports on components
- Use simple connectors whenever possible; stereotypes for type
- Never use dependencies in a C&C view
- Don't use interfaces (lollipops) on component instances, only on types

## Examples
- Bad: Controller Process diagram with no legend, same-looking lines, missing relationships — see `slides/L17 - Documentation.pdf` p.10-11
- Good: Metadirectory system with full legend, typed connectors, clear boundaries — see `slides/L17 - Documentation.pdf` p.12
- Alternating characters: Module view (decomposition with uses) vs C&C view (pipe-and-filter) of same system
- Overlay examples: Decomposition + layered view using color coding; C&C + tiers; allocation + C&C — see `slides/L17 - Documentation.pdf` p.49-51
- A-7E avionics decomposition — see `slides/L17 - Documentation.pdf` p.33

## Key Tradeoffs
- Different documentation needed at different lifecycle stages (informal sketches → formal structure → semantics)
- Pictures are not enough — need rationale and prose
- Level of detail/formality depends on context and audience
- Producing good documentation is not easy but worth the effort
- Documentation should evolve alongside the architecture, not be an afterthought
