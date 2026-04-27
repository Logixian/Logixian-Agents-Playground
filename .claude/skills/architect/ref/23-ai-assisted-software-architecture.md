# Lecture 23: AI-Assisted Software Architecture

> Schmerl & Garlan, 8 April 2026.

## Objectives
- How AI can assist software architecture activities.
- Strengths and limits of AI assistance for architecture work.
- How architectural artifacts can guide and constrain AI coding assistants.
- Practical examples of architecture-aware rules and guardrails.

## Scope
**About**: using AI to assist in software architecture.
**Not about**: architecting systems that contain AI (that is L21/L22). Field is early — this lecture summarizes emerging research and experience.

## Where AI Is Most Useful
- Transforming messy inputs into candidate architecture information.
- Generating alternatives.
- Critiquing artifacts against explicit criteria.
- Drafting structured artifacts (ADRs, documentation).
- Recovering structure from code and documentation.
- Assisting traceability and conformance checking.

## Where AI Is Weaker
- Final tradeoff judgment.
- Rationale without review.
- Tacit organizational context.
- Unconstrained autonomous design.
- Decisions depending on hidden assumptions or politics.

## Workflows vs Agents
- **Workflow**: predefined steps + checks. Easier to predict, validate, repeat. Like the studio meta-model — activities combined into workflows.
- **Agent**: dynamic planning + tool use. More flexible, needs stronger guardrails.

**Advice**: prefer workflows before agents, especially in early architecture work. Canonical pipeline:
> Retrieve context → structure input → generate candidate → critique/check → **human review and approval**

## Discovering Architecture Signals and Candidate ASRs
AI is good at extracting/clustering messy interview notes into candidate ASRs (Architecturally Significant Requirements).

**Example workflow** (Notable Music Reading App, see `slides/L23 - AI4SoftwareArchitecture.pdf` p.8–11):
1. Normalize stakeholder signals (function / quality / constraint / assumption / follow-up).
2. Consolidate — dedupe.
3. Identify candidate ASRs.
4. Split into quality ASRs (QASs), influential FRs, clarified constraints.
5. Classify ASRs by ADD category.

Each output is a **candidate**, not an architectural truth. Humans disambiguate and prune. Good workflow mirrors what an architect would do by hand, but makes messy input explicit, structured, reviewable.

## Generating Candidate Alternatives
AI broadens the design space, suggests styles/tactics fast, connects drivers to known patterns, supplements domain knowledge. Alternative use: have it review and embellish your own alternatives. Still need human tradeoff analysis.

## Evaluation and Critique
AI is strongest at critique when:
- ASRs are explicit.
- Artifacts are available.
- Review criteria are developed.

It can generate review questions and identify risks, omissions, and weak rationale.

## Generating Views
- **Direct image generation**: fast visual output, often inaccurate; weak editability.
- **Diagram-code generation (PlantUML/Mermaid)** (Schmerl 2024 experiments): easier to review/fix/regenerate/version, but frustrating to get good diagrams.

## Recovering Architecture from Code
AI can summarize recurring patterns and hotspots in large noisy codebases, helping recover candidate module and C&C structures. Useful for brownfield systems and drift detection. Recovered architecture is a **hypothesis**, not ground truth.

### Example: Rainbow recovery
Schmerl prompted Codex with a Rainbow codebase (2014 Java, custom comms, self-adaptive framework) asking for runtime-oriented C&C recovery — components, connectors, evidence. Codex recovered: Rainbow Master/Oracle (process, central control plane), ModelsManager (publish/subscribe), AdaptationManager (watches model/typecheck changes), plus Master→Delegate connectors (pub-sub async, async messaging). Did reasonably well on components + connector types, but also invented a "management system" not actually represented. See `slides/L23 - AI4SoftwareArchitecture.pdf` p.17–22.

### ArchView experiment (Sathvika/Dhar/Vaidhyanathan, ICSA 2026)
- 340 repos, 4137 generated views.
- Compared prompting, general-purpose code agent, custom architecture-aware agent.
- Custom architecture-aware agent performed best; prompting helped modestly; general-purpose agent worst.
- **Main limitation**: outputs stay too close to code — weak at true architectural abstraction.
- **Takeaway**: treat as assistive tool producing candidate views that need human review.

## ADRs and Design Rationale
Recent work successfully generates candidate ADRs, but they need human review. **Advice from Schmerl**: have AI **review** your ADRs rather than write them. It can:
- Identify missing / irrelevant context.
- Identify consequences you might not have seen.
- Reword into correct format.
- (Potentially) identify conflicting or incompatible ADRs.

## Giving AI Coding Agents Architectural Context
Coding assistants take the shortest path — often many local changes are architecturally misaligned. Architecture must be made explicit enough for the agent:
- Architectural rules.
- Boundaries (keep each activity in its own service; keep external integration behind boundaries).
- Connector assumptions (e.g., "workflow maintained in OrderService; synchronous call-return between workflow and services").
- Workflow constraints.
- Critical-path constraints.

### Example: CR System (A3)
A rules file encoding the A3 architectural intent that the agent consults before proposing changes.

### Turning rules into guardrails
AI derives candidate checks from rules → evaluate options before implementation → check conformance after → add to PR review agents. Makes architecture-preserving changes easier, **but**:
- Rules may be incomplete; architectural intent may be undocumented.
- AI can overfit to superficial patterns.
- Passing tests is not the same as preserving architecture.
- Still requires human judgment.

## Final Takeaways
- AI is strongest where architecture work is **explicit, structured, reviewable**.
- Good human processes for architecting are good guides for AI.
- Good architecture artifacts make AI assistance better.
- Coding assistants can be guided by architecture rules; some can be recovered from brownfield systems, but level-setting requires human scrutiny.
- Treat all outputs as **candidates**; review and update with humans.
- Some of the strongest future value is in making implicit architecture activities explicit enough for both agents and humans.

## Key Tradeoffs
- Workflow (predictable, less flexible) vs agent (flexible, needs guardrails).
- AI-generated ADRs (fast but shallow) vs AI-reviewed ADRs (catch gaps, require human draft).
- Recovered architecture (fast, approximate) vs hand-maintained architecture (slow, authoritative).
- Architecture rules in code (enforceable) vs architecture docs (richer but checkable only by humans).
