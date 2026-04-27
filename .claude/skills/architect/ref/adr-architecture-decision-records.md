# Architecture Decision Records (ADRs)

## Sources
1. Michael Nygard, "Documenting Architecture Decisions" (2011) — https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions
2. Agile Alliance, "Distribute Design Authority with Architecture Decision Records" — https://agilealliance.org/resources/experience-reports/distribute-design-authority-with-architecture-decision-records/

## Definition

An ADR is a short document capturing a single architecturally significant decision — one that affects structure, non-functional characteristics (quality attributes), dependencies, interfaces, or construction techniques.

## Nygard's Template (5 sections)

| Section | Content |
|---------|---------|
| **Title** | Short noun phrase, numbered sequentially (e.g., "ADR 1: Deployment on Ruby on Rails 3.0.10") |
| **Context** | Forces at play — technological, political, social, project-local. Written neutrally. |
| **Decision** | Active voice: "We will..." |
| **Status** | proposed / accepted / deprecated / superseded (with cross-reference to replacement) |
| **Consequences** | All outcomes — positive, negative, neutral — that affect future work |

### Rules
- 1-2 pages max
- Sequentially numbered; never reuse numbers
- Superseded ADRs retained for historical context (do not delete)
- Written conversationally for future developers

## When to Write an ADR

Write one when the decision is architecturally significant:
- Affects system structure
- Affects quality attributes (non-functional characteristics)
- Affects dependencies or interfaces
- Affects construction techniques
- Would show up in a C&C view, module view, or quality attribute scenario

## Core Rationale

New team members face a dilemma: blindly accept past decisions (risking stale practices) or blindly change them (risking breakage of non-obvious quality attribute requirements). ADRs preserve the *why* so teams can make informed decisions about change.

## Distributing Design Authority (Agile Alliance Experience Report)

The WIRE team used ADRs for nearly a decade. Key findings:
- **Proximity to code**: ADRs stored in markdown close to the code they govern
- **Democratization**: Multiple team members participate in architectural decisions, reducing dependency on individual architects
- **Institutional memory**: Decisions survive team transitions
- **Lightweight adoption**: Simple markdown format encourages consistent use; heavyweight docs atrophy

## Connection to 17-633 Concepts

| Course Topic | ADR Connection |
|-------------|----------------|
| **Architecture Drivers (L03)** | ADR *Context* section captures the drivers — QA scenarios, constraints, functional requirements |
| **QA Tradeoffs (L04)** | ADR *Consequences* section makes tradeoffs explicit — which QAs were prioritized vs. sacrificed |
| **Agile Architecture (L16)** | ADRs are a core practice in continuous architecture and ADD 3.0 — "just enough" incremental documentation |
| **Documentation (L17)** | ADRs complement architectural views: views show *what*, ADRs explain *why* |
| **Modifiability Tactics (L11)** | ADRs reduce cost of future changes by preserving decision rationale — teams can assess whether original drivers still hold |

## ADR Example Skeleton

```markdown
# ADR N: [Short Decision Title]

## Status
[proposed | accepted | deprecated | superseded by ADR-X]

## Context
[What forces are at play? What quality attributes matter most?
 What constraints exist? Written neutrally.]

## Decision
We will [decision in active voice].

## Consequences
- [Positive consequence]
- [Negative consequence / tradeoff]
- [Neutral consequence / future implication]
```
