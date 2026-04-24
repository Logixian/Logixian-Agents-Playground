# Lecture 11: Modifiability and Usability Tactics

## Objectives
- Distinguish architectural modifiability/usability from general maintainability and UI practice
- Use QAS to identify architecturally significant change
- Analyze architectural tactics for controlling change
- Reason about cost of change and when it's worth investing architecturally

## Key Concepts

### Modifiability — Software is Never Done
Architectural modifiability covers: portability, internationalization, extensibility, configurability, regulatory/API policy changes.

**General Maintainability vs Architectural Modifiability:**
| General Maintainability | Architectural Modifiability |
|---|---|
| Clean code, unit tests, local refactoring | Structure isolates likely change |
| Routine changes | Explicit change scenarios (QAS) |
| — | Enforced dependency direction / module boundaries |

### Cost of Change
Two types of cost:
1. **Cost to prepare** for change (upfront architectural investment)
2. **Cost to execute** change

If a change is likely, pay costs up front in design to be more responsive later (e.g., define stable plugin API now).

### When Do Changes Occur?
Implementation → Compilation → Build → Installation → Execution

The later the binding, the more flexible the system — but the more complex the structure required.

## Styles/Tactics/Patterns

### Modifiability Tactics

**1. Localize Changes (Localize Volatility):**
- Maintain semantic coherence — gather things likely to change into few locations
- Reduce module size (split module)
- Increase cohesion (Single Responsibility Principle — cohesion around what changes)
- Generalize modules so extensions are specializations

**2. Prevent Ripple Effects (Control Coupling):**
- **Encapsulation** (hide information)
- **Intermediaries** (brokers, event bus, gateway)
- **Restrict dependencies** (dependency rules, clean architecture, facades/wrappers)
- **Stable interfaces/contracts** (versioned APIs)
- **Centralize cross-cutting services** behind stable API (auth, logging, schema registry)

Coupling types: Direct dependencies + indirect dependencies (A→B→C). Dependencies can be syntactic (caught by compiler) or semantic (cannot be caught — e.g., Fahrenheit vs Celsius).

**3. Defer Binding Time:**
| Bind Time | Who | Mechanisms | Tradeoff |
|---|---|---|---|
| Compile/Build | Developers | Build profiles, DI, component replacement | Low runtime overhead, requires rebuild |
| Deploy/Init | DevOps | Config files, env vars, feature flags at startup | No recompile, requires redeploy |
| Run Time | System/User | Plugins, service discovery, hot config reload | Highest flexibility, highest complexity |

### Usability — When Is It Architecture?

**Not architectural**: Page layout, color, simple navigation
**Architectural**: Structure constrains user interaction, state management, timing guarantees, recovery mechanisms

### Usability Tactics

**Support for User Initiative:**
- Cancelable operations, undo/redo, flexible navigation
- Requires: state capture, command history, reversible operations, encapsulated actions, controlled side effects

**Support for System Initiative:**
- Workflow engines/state machines, rule-based validation, context-aware prompts, event-driven notifications

**Support for User Feedback:**
- Immediate acknowledgment, progress reporting, notification of updates
- Requires async processing, state monitoring

**Separation of Interaction and App Logic:**
- Enables independent evolution of UI and business logic, multiple UIs over same core
- Common approaches: MVC, layered architecture, ports and adapters

### Handling New "X-Ability" QAs
When encountering an unfamiliar quality attribute:
1. Decompose into concrete sub-concerns
2. Identify stakeholders and contexts
3. Write QASs (even if measure is imperfect)
4. Hypothesize architectural levers
5. Make tradeoffs explicit
6. Instrument and iterate

## Examples
- Payment provider modifiability QAS: "Add new payment provider within 2 days, no changes to order processing" — this is architectural because it requires structure to isolate change
- Undo support: Requires state capture, command history, reversible operations — more than adding a UI button
- AI form assistant: System initiative (prompts for missing info), feedback (status), separation of inference/interaction/validation logic
- Explainability as emerging QA: Requires traceable decision rationale, separation of decision logic from explanation logic

## Key Tradeoffs
- Modifiability = Align structure with volatility + Control dependency direction + Choose binding time intentionally
- Undo: Requires history/transaction → storage cost, async complexity, consistency issues
- Feedback: Requires events/polling → system load, more moving parts
- A quality attribute is architectural when it requires structural decisions, affects component boundaries, influences dependencies, or is cross-cutting
