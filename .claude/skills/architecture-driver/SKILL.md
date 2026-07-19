---
name: architecture-driver
description: >
  Produces a versioned architecture driver (requirement_vN.md) in artifact/architecture-driver/
  by either synthesizing a single client meeting's decisions into the existing baseline (update
  mode, default) or performing a full identification pass across all project materials (full mode).
  Use whenever the user says "identify architecture drivers", "update architecture driver",
  "new requirement version", "start architecture analysis", "what are our architecture drivers",
  "prioritize quality attributes", or wants any fresh or incremental architecture driver document.
  Triggers on both full identification requests and post-meeting update requests — always invoke
  this skill any time architecture drivers need to be identified, updated, or re-evaluated.
user-invocable: true
argument-hint: "[--from-scratch] [--meeting <YYYY-MM-DD>] [--add <path>]"
---

# architecture-driver

Produce the next versioned architecture driver (`requirement_vN.md`) by either updating the
existing baseline with a single client meeting's decisions, or performing a complete identification
pass across all project materials. The goal is always to capture only architecturally significant
decisions — new functional behavior, changed quality constraints, or binding technical/business
constraints.

## Arguments

| Argument | Default | Effect |
|---|---|---|
| `--from-scratch` | off | Ignore existing baseline; do a full identification pass across all project materials and produce a fresh document |
| `--meeting <YYYY-MM-DD>` | most recent | Restrict meeting input to this folder under `client-meeting/` |
| `--add <path>` | none | Read any additional file as a source (repeatable) |

## Mode Selection

Determine the operating mode before doing anything else:

- **Full mode**: `--from-scratch` is set, OR no `artifact/architecture-driver/requirement_v*.md` exists yet
- **Update mode** (default): a baseline exists and `--from-scratch` is not set

The mode controls which sources are loaded and which steps are required.

---

## Step 1 — Identify Resources

**Determine output version:**
- Glob `artifact/architecture-driver/requirement_v*.md`
- Pick the highest N → output will be `requirement_v{N+1}.md`
- If no files exist → output is `requirement_v1.md` (and mode is automatically Full)
- If `--from-scratch` is passed → still pick v{N+1} for the filename; treat as no baseline

**Always read (load before analysis):**
- `knowledge/architecture/architecture-driver.md` — QA scenario format (6-part: Stimulus, Source, Environment, Artifact, Response, Response Measure)
- `knowledge/architecture/architecture-guideline.md` — Utility Tree and prioritization methodology
- `knowledge/refine-requirement-guideline.md` — Filter: what rises to architecture-driver level?

**Read in Full mode only:**
- `knowledge/architecture/architecture-tactic.md` — Tactic reference for tradeoff analysis
- `knowledge/architecture/architecture-style.md` — Style trade-offs reference
- `docs/project-description.md` — Scope and goals
- `docs/state-market-brief.md` — Per-state compliance rules and constraints

**Conditionally read:**
- If NOT `--from-scratch` and baseline exists: read `artifact/architecture-driver/requirement_v{N}.md`
- Meeting folder:
  - In Update mode (no `--meeting`): use the most recently dated folder under `client-meeting/`
  - With `--meeting <date>`: use `client-meeting/<date>/`
  - Read `*.md` files; skim `*.vtt` for decisions not captured in the notes
- If `--add <path>`: read each additional file

---

## Step 2 — Extract Architecturally Significant Items

Use `knowledge/refine-requirement-guideline.md` to judge every candidate item — if it doesn't
constrain architecture choices or quality, leave it out.

### In Update mode

Extract only items that are new, modified, or clarified relative to the baseline:
- **New functional requirements** — new actors, services, behaviors, or interactions
- **Updated QA scenarios** — revised stimulus / response / measure
- **New or changed constraints** — technical stack decisions, business rules, legal requirements
- **Clarifications** — corrections to existing items that change their meaning

Skip implementation details, UI preferences, or anything already in the baseline and unchanged.

### In Full mode

Extract all architecturally significant items across all loaded materials. Classify into three buckets:

**Functional Requirements (FR)**
- Identify actors (system users, external systems, operators)
- Group behaviors into subsystems (e.g., Jurisdiction Intelligence Engine, Eligibility Service)
- Each FR must describe observable system behavior, not implementation details

**Quality Attributes (QA)**
- Write one 6-part scenario per QA item using the format in `architecture-driver.md`:
  `Stimulus | Source | Environment | Artifact | Response | Response Measure`
- Cover categories: Accuracy, Timeliness, Auditability, Security, Performance, Reliability, Extensibility, Compatibility (add/remove as relevant)

**Constraints**
- Technical: stack decisions, platform mandates, integration protocols
- Business: deadlines, cost limits, regulatory compliance, geographic scope

---

## Step 3 — Prioritize & Identify Tradeoffs

This step is required in both modes. Even in Update mode, re-evaluate the full driver set after
incorporating new items — priorities and tradeoffs may shift.

**Build the Utility Tree** (per `architecture-guideline.md`):
- Score each QA by: Business Importance (H/M/L) × Architectural Difficulty (H/M/L)
- Rank and identify the top 3–5 architecture drivers
- Present as a prioritized list with scores

**Identify ≥1 architecture tradeoff:**
- Pick two competing QAs or constraints (e.g., Accuracy vs. Performance)
- Explain what architectural choice favors one at the cost of the other

---

## Step 4 — Write requirement_v{N+1}.md

Output `artifact/architecture-driver/requirement_v{N+1}.md` with this exact structure:

```
# Requirements

## 1. Functional Requirements
### Actor
<List of actors>

### 1.1 <Subsystem Name>
- **FR-I01** <requirement description>
- **FR-I02** ...
...

## 2. Quality Attributes
### Quality Attribute Refinements

#### Accuracy
| ID | Stimulus | Source | Environment | Artifact | Response | Response Measure |
|----|----------|--------|-------------|----------|----------|------------------|
| A1 | ...      | ...    | ...         | ...      | ...      | ...              |

#### <Category>
...

### Utility Tree (Priority)
| Rank | QA | Business Importance | Architectural Difficulty | Driver Score |
|------|----|--------------------|--------------------------|--------------|
| 1    | Accuracy | H | H | HH |
...

### Key Architecture Tradeoff
**<QA-A> vs <QA-B>:** <one-paragraph explanation of the tradeoff and the chosen direction>

## 3. Constraints
### Technical Constraints
- ...

### Business Constraints
- ...

---
## Changelog (<source> → v{N+1})
| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
...

> [HUMAN REVIEW REQUIRED] — Review changelog before accepting this as the new baseline.
```

**ID assignment rules:**
- Functional Requirements: `FR-I<nn>` (sequential, two-digit, e.g. `FR-I01`)
- Quality Attribute rows: `A<n>`, `T<n>`, `R<n>`, `S<n>`, `P<n>`, `Rel<n>`, `E<n>`, `C<n>` (per existing scheme)
- If a baseline exists: continue numbering from the highest existing ID in each series
- Add new items with the next sequential ID
- Mark modified items `*(updated)*` next to their ID
- Mark deprecated items `*(deprecated)*` with a rationale row in the changelog
- Never delete items from a baseline — deprecate instead

**Changelog source label:**
- Update mode: `v{N} → v{N+1}` (e.g. `v2 → v3`)
- Full mode (first run): `identification session → v1`
- Full mode (`--from-scratch` re-run): `full re-identification → v{N+1}`

**Every changelog row must:**
- Cite the source file (e.g., `docs/project-description.md`, `client-meeting/2026-03-11/Client Meeting.md`)
- Include a one-sentence rationale explaining why it rises to architecture-driver level

---

## Step 5 — Human Review Gate

After writing the file, print a summary:

```
Wrote: artifact/architecture-driver/requirement_v{N+1}.md
Mode: [Update | Full]
  - Functional Requirements: X items (Y new, Z carried over)
  - Quality Attribute scenarios: X items
  - Constraints: X items
  - Utility Tree top drivers: <list top 3>
  - Tradeoffs identified: X
```

Then ask:

> *"Please review `artifact/architecture-driver/requirement_v{N+1}.md`.
> Type `approve` to accept as the new baseline, or give feedback to revise."*

On `approve` → done.
On feedback → revise the file and re-present the summary.
