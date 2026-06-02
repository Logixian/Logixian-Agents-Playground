# Lecture 24: C4 and Architecture as Code

> Schmerl & Garlan & Fairbanks, 13 April 2026.
> Subtitle: *From Visualization to Machine-Readable Architecture*.

## Objectives
- Industry trends in realizing architecture concepts.
- C4 as a visualization approach.
- Architecture-as-Code (AaC) as the emerging practice.
- How likeC4 and CALM bring architecture closer to code — what they bring beyond visualization.
- Opportunities and limits of AaC.

## The Architecture-Code Gap
Once architecture exists, it must be implemented. The gap between the two is often large because architectural intent is not explicit in code, diagrams drift, and consistency is manual. AaC aims to shrink this gap.

## Notation Spectrum (recap from L19)
- **Informal**: boxes and lines — easy, ambiguous.
- **Semi-formal**: UML, SysML — disciplined, limited analysis.
- **Formal**: Acme, Alloy — precise, automated validation, higher effort.

## C4: Visualizing Architecture
Primarily for diagramming and communication. A disciplined hierarchy of **four related views** over the same system (like zoom levels). Better visual discipline than ad-hoc box-and-line, but little automated analysis on its own. Source: https://c4model.com.

| View | Scope | Audience |
|---|---|---|
| **Context** | System in its environment: users, external systems, relationships. No tech/protocol detail. | Non-technical, mixed audiences |
| **Container** | Major running/deployable parts — server app, client app, mobile app, blob store, file system, shell script. "Container" ≠ Docker. | Dev teams, product managers, clients |
| **Component** | Zoom into each container: internal components, responsibilities, key interactions, technologies. | Developers, security analysts |
| **Code** | How selected components are implemented (UML class, ER, interfaces). Only for most important/complex parts. | Developers |

**Diagram legend** (`slides/L24 - C4 and Architecture as Code.pdf` p.7–14): person/customer icon; rounded boxes for system under development; different style for external systems; labeled relationships.

**Strengths**: communication, navigation, lightweight discipline through hierarchy.
**Limits**: consistency is mostly manual; limited semantics and checking; view types can blur; tooling is mostly language-based.

## Beyond Better Diagrams
C4 still has drift. Diagrams stay inconsistent with code. Architecture is hard to validate automatically. Diagrams often get filed away. **Question**: can architectural models be treated more like code?

## Architecture as Code
Treat architecture as a **machine-readable artifact** that is:
- Written and maintained like code.
- Versioned with the system.
- Used to generate views and documentation.
- Amenable to validation and automation.
- Easier for tools (including generative AI) to inspect and transform.

Leverages the success of ADRs, Infrastructure as Code, and automated deployment.

## likeC4 (https://likec4.dev)
A bridge from C4 to AaC.
- Expresses C4-style architecture in a textual DSL.
- Keeps one model as source of truth.
- Generates multiple views/diagrams from that model.
- Allows project-specific element and relationship types.

Still primarily visualization + communication.

### Three aspects of likeC4
1. **Specification** — defines the types of elements and relationships used in the model (shape, style, and other properties that instances can override).
2. **Model** — the actual architecture of the system.
3. **Views** — projections of the model into diagrams for different audiences.

In C4 you draw each view separately. In likeC4 you define the model once and derive views. Compare to Acme: likeC4 specification ≈ Acme family / types; model ≈ system; views are visualization-only (unlike Acme's semantic analyses).

**DSL examples** (see `slides/L24 - C4 and Architecture as Code.pdf` p.21–24):
```
specification {
  element actor { style { shape person } }
  element system
  element component
  relationship async
}
model {
  customer = actor 'Customer' { -> ui 'opens in browser' }
  cloud = system 'Our SaaS' {
    backend = component 'Backend' { icon tech:graphql }
    ui = component 'Frontend' { style { icon tech:nextjs shape browser } }
    ui -[async]-> backend 'requests via HTTPS'
  }
}
views {
  view index { title 'Landscape view' include *, cloud.* }
}
```

### What likeC4 gives us (and what it doesn't)
✅ Structured model, generated views, project-specific typing/styling.
❌ Reusable patterns, rule checking, architecture validation.

## CALM — Common Architecture Language Model (https://calm.finos.org)
A step beyond generated views toward **validation and governance**. Defines architectures in a standardized, machine-readable JSON schema. Adds:
- **Patterns** — reusable expected structure (e.g., "internet-facing traffic goes through an API gateway"; "database access goes through an approved service layer").
- **Constraints** — org/domain-specific rules (e.g., "public services must declare an owner"; "regulated-data services must declare data classification").
- **Validation** — check for missing elements/relationships, forbidden direct connections, missing metadata, policy violations.
- **Compliance/governance** workflows in CI/CD tooling.

Still supports visualization, but that is not the main point.

### CALM validation example
See `slides/L24 - C4 and Architecture as Code.pdf` p.31–35:
- **Pattern**: internet-facing traffic goes through an API gateway → model that bypasses the gateway fails validation.
- **Constraint**: public services must declare an owner in a particular format → model with bad owner format fails validation.

CALM is emerging, not out-of-the-box usable — points toward richer AaC workflows.

## AaC Summary
- Architecture becomes machine-readable.
- Views are generated from a shared model.
- Models support validation and checking.
- Can integrate into AI workflows.

**Limits**:
- Still needs human architectural judgment and authorship.
- Models can become stale if not maintained.
- Tooling and standards are evolving.
- Not every stakeholder wants to read architecture "as code".
- Richer checking means more modeling effort.

## AaC and ADLs: Everything Old Is New Again
1990s/2000s ADLs (Acme, Wright) aimed for explicit, precise, analyzable, tool-supported architecture. AaC revisits the same ideals but through modern enablers: repositories, versioning, generated views, validation, governance, integration with modern dev workflows. The goal remains: **make architecture a real engineering artifact**.

## Opportunities
- Architecture recovery via static analysis → generate models or check consistency with code.
- Dependency analysis against the architecture model.
- Security analysis via data-flow analysis of the model.
- Other analyses from prior lectures (e.g., deadlock, style conformance).

## Key Tradeoffs
- **C4 only** vs **AaC**: C4 is quick and human-friendly; AaC takes more modeling effort but enables validation and automation.
- **likeC4** vs **CALM**: likeC4 focuses on model-backed visualization; CALM adds patterns, constraints, and compliance at the cost of schema complexity.
- **Generated views** (consistent, but only as good as the model) vs **hand-drawn** (flexible, drift-prone).
- **Validation automation** (enforceable rules, visible in CI) vs **human judgment** (richer, not checkable).
