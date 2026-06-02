# Lecture 13: Architectural Mismatch and Ecosystems

## Objectives
- Part 1: Understand architectural mismatch — detection and repair
- Part 2: Understand software ecosystems and their relationship to architecture

## Key Concepts

### Architectural Mismatch
Occurs when provides/requires assumptions that components make about one another are **different, incorrect, or unknown**. Can be functional or quality-attribute oriented.

### Categories of Mismatch
1. **Interface mismatch**: Data/representation format incompatibility
2. **Protocol mismatch**: Interaction semantics, error handling differences
3. **Control mismatch**: Ownership of control thread / lifecycle conflicts
4. **Style/platform mismatch**: Different architectural assumptions

### Mismatch Risks
- Component developers make behavioral and QA assumptions you don't know about
- Behavior of component ensembles is often unpredictable (works in lab, fails in production)
- Component evolution is out of your control; vendors may stop support

## Styles/Tactics/Patterns

### Avoiding Mismatch
- Disciplined approach to specifying provides/requires assumptions (beyond just APIs)
- Clearly define QA assumptions (provides: how fast/secure/available; requires: what it expects of others)
- Adhere to established standards (though standards are often silent about QA assumptions)
- Pick components designed for a particular style or platform

### Detecting Mismatch (Component Qualification)
- Discover all "requires" assumptions of the component
- Ensure each "requires" is satisfied by some "provides"
- Validate that component works as advertised
- Often includes prototyping to validate claims and uncover defects

### Repairing Mismatch

**Wrappers**: Encapsulate a component within an alternative interface
- Interface translation: translate, hide, mask parameters with defaults
- Elements requiring services can only access through wrapper interface

**Bridges**: Translate specific requires→provides assumptions between components
- Independent of any particular component
- Must be explicitly invoked by some external agent
- Focus on narrower range than wrappers

**Mediators**: Combine properties of bridges and wrappers with a planning function
- Determine translation at run time
- More sophisticated than incidental repair
- Can select among multiple bridge strategies based on current data

See `slides/L13 - Ecosystems_Mismatch.pdf` p.22-33 for diagrams of wrappers, bridges, mediators

### Socio-Technical Ecosystems (STEs)
Software systems operate within context: technical, organizational, economic, social, legal.

An STE embodies:
- Roles and relationships
- Markets and incentives
- Legal/regulatory constraints
- Technical architecture

**Architectures enable ecosystems** (Windows, iPhone, .NET, Eclipse, ROS) and **introduce new roles** (governance bodies, platform developers, stores, payment structures).

### Types of Modern STEs
| STE Type | Architecture |
|---|---|
| Single product | Traditional single system |
| Product line | Proprietary framework with extension points |
| Service-oriented | SOA, microservices |
| Mobile platform + apps | Platform with app extension points (iOS, Android) |
| Social networks | Web-based, user-centric extensions |
| e-Science communities | Usually dataflow |

## Examples
- JavaPhone: Great app platform but no app store/governance → ecosystem failure
- Napster: Great document-sharing architecture that violated copyright law → ecosystem failure
- NASA: Great product line architecture but no organizational structures to maintain it
- Mainframe industry (50s-60s) → PC industry restructuring (horizontal layers replacing vertical integration)
- ICU monitoring system: ML-based component mismatch — see `slides/L13 - Ecosystems_Mismatch.pdf` p.35-36

## Key Tradeoffs
- Wrappers, bridges, mediators each have different QA tradeoffs and economic/schedule impacts
- True strategic reuse is not free or easy, but can pay off many times the investment
- Failing to understand ecosystem context and its interaction with architecture can lead to disastrous results
- Ecosystems change over time as technology changes — STEs may become obsolete
- Key ecosystem questions: Who governs? How are participants incentivized? How is infrastructure maintained?
