# Guest Lecture: ADRs in Practice (Michael Keeling)

> Michael Keeling (Kiavi), guest lecture for 17-633

## Speaker Background

- 25+ years in software; Principal Software Engineer at Kiavi
- Author of *Design It!*
- Practicing ADRs since 2013; written, reviewed, read 350+
- Based in Pittsburgh, PA

## Why ADRs Matter

1. **Design is essential** -- creativity, judgement, nuance that AI cannot replace
2. **ADRs provide context** -- for agents and people; AI "can't read your mind, doesn't care why"
3. **Mechanism for reflective friction** -- slow down with purpose; check direction and design appropriateness

## Architectural Design Decisions Recap

### What Makes a Decision "Architectural"?

A design decision might be architectural if it:
- Changes structures (static, dynamic, or physical)
- Directly influences high-priority quality attributes
- Is imposed by a new constraint or assumption
- Requires accepting substantial trade-offs
- Adds or removes dependencies
- Forces major changes on other systems
- Mitigates or introduces engineering risks
- Accepts technical debt

**Heuristic**: If your team spent half an hour or more debating it, it might be important enough to document.

### Three Kinds of Structures

| Kind | Elements | Relations |
|------|----------|-----------|
| **Static** (design time) | Class, module, package, layer | Uses, allowed to use, depends on |
| **Dynamic** (runtime) | Object, tier, process, thread, filter, client | Call, subscribe, pipe, publish, read |
| **Physical** (real-world) | Server, sensor, container, person | Runs on, deployed to, builds, pays for |

## The Design Decision Cycle

```
Contextual Forces -> Decision -> Consequences (Hypothesized resulting forces)
                                       |
                                       v
                              New Contextual Forces -> ...
```

### Contextual Forces

Facts that describe the world at the time of the decision. Reflects the team's awareness, assumptions, skills. May be:
- Technical, social, historical, political, business
- Previous decisions
- Architectural drivers

**Examples:**
- "By our governance policy, public-facing APIs must use GraphQL."
- "The team has experience with Ruby."
- "Image processing can take up to 90 seconds."
- "We previously decided to use CQRS."
- "Reliability is the most important quality attribute."

### Consequences

Hypothesized resulting forces:
- Promoted or inhibited quality attributes
- Accepted trade-offs
- New engineering risks
- Technical debt
- Follow-up work
- Positive, negative, or neutral

## Mechanics of an ADR

- **Plain, direct language**
- **Brief**: 1-2 pages max
- **Markdown** format
- **Stored close to context of use** (in the repo)
- **Sequentially ordered**
- **Never deleted** (deprecated or superseded instead)

### Nygard Template (Standard)

```markdown
# ADR N: Brief Decision Title

Context goes here. Value-neutral forces at play.

## Decision
"We will ..."

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Consequences
Positive, negative, and neutral outcomes.
```

### Full ADR Example: Use The Pipe-and-Filter Library

**Context**: Previously decided on pipe-and-filter pattern, but violations crept in when knowledgeable engineers left. Joe wrote an open-source library that enforces the style.

**Decision**: Use the pipe-and-filter library to organize all Training Agent application logic.

**Consequences**:
- All agents must fit within pipe-and-filter context (potential future constraint)
- Filters completely decoupled; per-filter concurrency control (faster but must be thread-safe)
- Easier error/failure reaction via message subscribers
- Stricter logging/metrics controls (less duplication, but more work for error response messages)
- Risk of uncaught race conditions in library; slightly higher test costs

> See `slides/(Keeling) Architecture Decision Records in Practice.pdf` for visual layout

### The Decision Log

- "Change over time" view of past, present, (sometimes) future decisions
- Design branches, dead ends, proposed decisions, open decisions
- Linear or web navigation; built incrementally, 1 ADR at a time
- Can be visualized (e.g., Structurizr tool) and recontextualized into new views

## Alternative ADR Formats

| Format | Key Difference |
|--------|---------------|
| **Nygard Markdown** | Context / Decision / Status / Consequences (standard) |
| **Jeff Tyree & Art Akerman** | Decision table format |
| **Alexandrian pattern** | Pattern-language style |
| **MADR** (Markdown Any Decision Records) | Extended markdown template |
| **Paulo Merson** | Simple markdown template |
| **Y-Decision** | Structured: Context / Facing / Decision / Rejected options / To achieve / Accepting downsides |

### Y-Decision Example

| Field | Value |
|-------|-------|
| **Context** | Training Agents components maintained by the WIRE team |
| **Facing** | Previous architecture violations (inconsistency, lack of governance) |
| **Decision** | Adopt Joe's pipe-and-filter framework library |
| **Rejected options** | Drop pipe-and-filter; implement framework directly in Training Agent |
| **To achieve** | Hoist key qualities into library, enforce architectural style |
| **Accepting downsides** | Slightly higher testing costs, more friction to modify framework |

## ADR Review Tips

### Context
- Architecturally relevant forces only
- Directly related to the decision
- Avoid "pre-fetching" consequences
- Context is not only your desires -- what's missing?

### Decision
- Influences quality attributes?
- Materially alters structures?
- Accepts strategic technical debt?
- Driven by constraints?
- Costly to change later?

### Consequences
- Direct result of the decision
- Architecturally significant
- What changed from the context?
- Positive, negative, AND neutral
- Go beyond the obvious
- Goal: 3-5+ consequences

## Using Images in ADRs

- Keep it simple; apply "classic" documentation approaches
- Before/after diagrams
- Mermaid diagrams for inline rendering
- Build up visually to the decision

## Emphasize Quality Attributes in Consequences

- Call out which QAs are promoted or inhibited
- Capture reflection on past decisions (lessons learned)
- Use ADRs for organizing architecture descriptions

## Introducing ADRs to a Team

### Case Study: IBM WIRE Team

- 9 engineers, 1-20 years experience, limited architecture background, new to microservices
- Watson Discovery Service: cloud-based microservices, 80+ person product org

### Four-Phase Journey (3-12 months)

| Phase | Duration | Description |
|-------|----------|-------------|
| **1. ADR champion only** | 1-2 months | Tech lead writes all ADRs; team resistance ("no time", "what's the value?", "don't know how") |
| **2. First contributors emerge** | 1-3 months | Initial excitement; everything becomes an ADR; poor quality (shallow, non-architectural); tech lead taps a "first mate" |
| **3. Design practice development** | 2-6 months | Coaching through PR comments and whiteboard sessions; develop architecture fundamentals; delegate writing decisions |
| **4. ADRs become common practice** | Ongoing | New champions emerge; ADRs referenced from code, discussed casually; quality continues improving; tech lead can move on |

### Early ADR Example (Phase 2 quality)

> "The Ranker has configurable parameters for sample size. Research suggests n=50. Decision: Set n=50."

Not architectural -- but celebrating that someone wrote an ADR at all is part of the adoption journey.

## Psychology of ADRs

Six psychological principles that explain why ADRs work (Keeling, IEEE Software, 2022):

| Principle | Mechanism | Team Says |
|-----------|-----------|-----------|
| **Open invitation** | Plain text, no special tools, low barrier | "It's just text, I can do this. My ideas matter too." |
| **Association** | ADRs live in the repo alongside code | "The architecture is my responsibility, just like code." |
| **Consistency** | Written commitment = public promise; peer accountability | "Everyone knows what we decided. I want to follow through." |
| **Shared toil** | Everyone takes turns writing, reviewing, critiquing | "We all had a hand in creating the architecture." |
| **Social proof** | Visible artifact of design happening; positive feedback loop | "Others write ADRs, maybe I should too." |
| **Identity** | Over time, every ADR affirms team's commitment to design | "I am the kind of developer who thinks through design decisions." |

### Why ADRs Work (Summary)

ADRs produce **better designs** (think through decisions, share, preserve history, iterate) AND **better designers** (coach peers, practice safely, spread knowledge). All seeds needed to grow a strong design-focused team.

## Key Quotes

- "If you do anything as a software architect, don't draw diagrams. Write down what you did and why you did it." -- Carola Lilienthal
- "Think of ADRs as little love notes you write to your future children's children, who are compelled to understand your code." -- Grady Booch
- "The object isn't to make ADRs, it's to be in that wonderful state which makes awesome software designs inevitable." -- Keeling (after Robert Henri)

## Key Tradeoffs

| Tradeoff | Discussion |
|----------|-----------|
| Plain text vs. formal notation | ADRs are accessible but lack analytical power (no model checking, code generation) |
| Champion-driven vs. mandated | Organic adoption through phases works better than top-down mandates |
| Document everything vs. only architectural | Early on, accept non-architectural ADRs to build the habit; coach toward quality over time |
| Upfront training vs. learn-by-doing | Both paths can reach mastery; ADRs enable learning while doing real work |
