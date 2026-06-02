# Lecture 05: Introduction to Architectural Styles

## Objectives
- Review views and styles concepts
- Examine the layer style in detail
- Understand style-oriented tradeoffs (domain-specific vs general)
- Understand how frameworks may constrain style choice

## Key Concepts

### Software Architectural Style
A style defines:
1. **Element and relationship types** (e.g., clients and servers, pipes and filters)
2. **Constraints** on arrangement (e.g., no cycles in a pipeline, UI tier can't talk directly to data tier)
3. **Behavioral rules (semantics)** for how elements connect, interact, and transform

*Some books refer to a style as a "pattern".*

### Why Focus on Styles?
- Leverage experience from previous designs
- Provide starting points for new designs
- Establish common vocabulary
- Support "built-in" quality properties
- Constrain downstream elaboration/implementation
- Enable reuse of code and analyses

### Layers (Module View Style)
**Rules:**
1. Each code module must be assigned to some layer
2. Code in one layer may only access the layer immediately below it (and optionally same-layer modules)

**Layers vs Tiers:**
- **Layers** = static, code-oriented structures (packages, modules, libraries); relation is "depends on" / "can use"; often disappear at runtime
- **Tiers** = dynamic, runtime structures (processes/threads); visible at execution time

Example: OSI 7-layer model (Application, Presentation, Session, Transport, Network, Data Link, Physical)

### C&C Style Taxonomy
| Family | Styles |
|---|---|
| **Dataflow** | Batch sequential, pipes & filters, workflow |
| **Call-return** | Main-subroutine, OO, component-based, P2P, SOA, N-tiered |
| **Event-based** | Async messaging, pub-sub, implicit invocation, data-triggered |
| **Data-centered** | Repository, blackboard, shared variables |

### Style Specialization Spectrum
Styles exist on a spectrum from generic to highly specialized:
- **Generic Styles** → **Generic Style Specializations** → **Generic Component Integration Platforms** → **Domain-Specific Platforms** → **Product Lines**
- More specialization = more constraints + more reuse + more assurance
- See `slides/L05 - Intro Arch Styles.pdf` p.22 for the spectrum diagram

## Examples
- OSI Reference Model as a layered style
- 3-tiered systems: application code → common services → OS abstraction (static) compiled into UI → Broker → Data Tier (dynamic)
- Hierarchy of styles diagram — see `slides/L05 - Intro Arch Styles.pdf` p.23

## Key Tradeoffs
- Course focuses mostly on C&C styles because they are crucial for reasoning about QAs (performance, availability, security)
- Other styles exist beyond the taxonomy (virtual machine, interpreter, broker, MVC)
- Frameworks may constrain which style you can use
- No single standard list of styles or generally accepted categorization
