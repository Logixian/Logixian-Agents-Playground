# Lecture 09: Data-Centered Styles and Styles in Practice

## Objectives
- Part 1: Explain data-centered style elements, constraints, and QA tradeoffs
- Part 2: Identify and reason about style combinations in practice
- Develop intuition for recognizing implicit architecture styles in real systems

## Key Concepts

### Data-Centered Styles
Focuses on access to shared data as the principal form of interaction:
- Data components typically passive (perform no computation, but enforce invariants)
- Components coordinate by reading and writing shared data, not invoking each other directly

## Styles/Tactics/Patterns

### Repository (Shared-Data)
- **Types**: Repository (shared data store), independent readers/writers
- **Properties**: Indirect interaction via read/write; common data model and semantics; logical centrality
- **Promotes**: Consistency (within model), tooling reuse (queries, reporting, analytics), integration simplicity
- **Inhibits**: Scalability (contention), availability (shared dependency), modifiability (schema evolution)
- **Variations**: Centralized vs distributed; logical vs physical centrality; replication and sharding; consistency models (strong vs eventual — where CAP tradeoffs occur)

### Data Warehouses, Lakes, and Lakehouses
| Aspect | Warehouse | Data Lake | Lakehouse |
|---|---|---|---|
| Write discipline | Strict | Minimal | Zoned |
| Schema | On write | On read | Both |
| Update model | Mutable | Append-only | Controlled |
| Coordination | Strong | Weak | Balanced |
| Coupling | Higher | Lower | Balanced |

### Blackboard
Architecture explicitly defines how decisions are made about which component runs next:
- **Types**: Blackboard (shared state), Knowledge Sources (KS), Control component
- **Properties**: Opportunistic application of knowledge; indirect coordination via shared state; explicit control over activation
- **Promotes**: Complex ill-structured problem solving; incremental refinement
- **Use when**: No fixed processing order known; multiple independent contributors; progress is incremental; decisions depend on current global state

**Reasons to choose blackboard**: Adaptive control, state-driven selection, extensibility (new KS can be added), components remain independent

**Reasons NOT to choose**: Complex control logic, unpredictable behavior, performance overhead, difficult debugging, hard to understand emergent behavior, poor fit for simple problems

### Combining Styles (Hybrid Architectures)
Real systems rarely follow a single style. Styles can be combined:

1. **Hierarchical combination**: One style nested inside another (e.g., Apache: client-server overall, pipe-filter internally)
2. **Composition combination**: Different subsystems follow different styles, coexisting and interacting directly (e.g., microservices: call-return for client interaction, event-based for service coordination, repository for data)

**Key question**: Which style dominates system behavior or quality attributes?

### Platonic vs Embodied Styles
- **Platonic**: Idealized style definition (e.g., pipe-and-filter with fully independent filters; server never contacts client)
- **Embodied**: Style as seen in real systems with relaxed constraints (e.g., first/last filter not independent; occasional server push)
- **Tradeoff**: Relaxing constraints may lose the style's guaranteed benefits

### Style Specialization
- Styles define families of designs; specialization adds constraints to narrow the family
- Examples: "Middle tier must be stateless" (scalability), "Repository is append-only" (fast writes), "Event ordering maintained" (easier coordination)

### Why Styles Are Not Enough
- Styles define structural families but not concrete designs
- Styles support QAs at a broad level but don't resolve them — they create "load-bearing walls"
- Many QAs require localized design decisions within the style → **tactics**

## Examples
- Enterprise Reporting/Analytics: Data sources write to central database; reporting tools read; no call-return, no events, no dataflow — repository is the backbone
- Blackboard for speech recognition: Audio → phonemes → words → sentences → context, with KS competing and control component selecting next step — see `slides/L09 - Repository and Styles in Practice.pdf` p.18
- Jigsaw puzzle analogy: Edge/region KS work opportunistically on shared blackboard
- Microservices as composition: Client-server + pub-sub + repository coexisting

## Key Tradeoffs
- Repository: Consistency vs scalability; integration simplicity vs schema rigidity
- Blackboard: Flexibility and adaptiveness vs complexity and unpredictability
- Combining styles: Preserve strengths of each if done carefully; introduce new tradeoffs
- Must understand boundaries when composing styles, or risk evolving into "big ball of mud"
- Architecture styles are reference models, even when systems only partially conform
