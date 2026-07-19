---
name: architecture-diagram
description: >
  Produces the next versioned architecture diagram file(s) by reflecting requirement
  changes from the latest architecture driver baseline into updated Mermaid diagrams.
  Use whenever the user says "update architecture diagram", "run IRA-79", "reflect
  requirement changes in diagrams", "update context diagram", "update sequence diagram",
  "update deployment diagram", or after any update to the architecture driver baseline
  (requirement_vN.md) that introduces new actors, services, flows, containers, or
  deployment changes. Reads the latest requirement baseline and the latest versioned
  diagram file(s), identifies structural changes, and produces new versioned files with
  changelog tables requiring human review before acceptance.
user-invocable: true
argument-hint: "[--type context|sequence|deployment|all] [--from-requirement <vN>]"
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash(ls:*)
---

# architecture-diagram

Produce the next versioned architecture diagram file(s) by reflecting requirement
changes from the architecture driver baseline into updated Mermaid diagrams. The goal
is to keep diagrams structurally consistent with the latest requirements — adding,
modifying, or deprecating actors, flows, containers, and use cases as the system evolves.

## Arguments

| Argument | Default | Effect |
|---|---|---|
| `--type <type>` | `all` | Which diagram(s) to update: `context`, `sequence`, `deployment`, or `all` |
| `--from-requirement <vN>` | latest | Requirement version to use as source of truth (e.g. `v6`) |

## Step 1 — Identify Resources

1. **Requirement baseline:** If `--from-requirement <vN>` is given, read
   `artifact/architecture-driver/requirement_<vN>.md`. Otherwise, Glob
   `artifact/architecture-driver/requirement_v*.md`, pick the highest N, and read
   `artifact/architecture-driver/requirement_v{N}.md`. If N > 1, also read
   `requirement_v{N-1}.md` to understand what changed between versions.

2. **Diagram version(s):** For each type in scope, Glob the directory and pick the
   highest version M — the output will be `_v{M+1}`.

   | Type | Directory | File pattern |
   |---|---|---|
   | `context` | `artifact/archittecture-diagram/00-context-diagram/` | `context-diagram_v*.md` |
   | `sequence` | `artifact/archittecture-diagram/01-sequence-diagram/` | `sequence-diagram_v*.md` |
   | `deployment` | `artifact/archittecture-diagram/02-deployment-daigram/` | `deployment-diagram_v*.md` |

3. **Always read:**
   - Each current diagram file (`*_v{M}.md`) for the selected type(s)
   - `knowledge/architecture/architecture-style.md`
   - `knowledge/architecture/architecture-guideline.md`

## Step 2 — Extract Diagram-Impacting Changes

Compare the requirement baseline against what is currently represented in the diagram.
Extract only changes that alter system structure — not implementation details, UI
preferences, or constraint wording that doesn't change which components exist or how
they communicate.

**Filter rule:** "Does this change alter WHO communicates with WHAT, HOW they
communicate, or WHAT infrastructure hosts the system?" If no → leave it out.

**Context diagram (C4 Level 1) — look for:**
- New or removed external actors (human or system)
- New or removed system boundary elements (services, databases)
- New, removed, or relabelled interface flows
- Changed protocol labels or trigger annotations

**Sequence diagram — look for:**
- New use cases required by new functional requirements
- New or removed participants in existing use cases
- Changed message ordering, branching conditions, or loop logic
- Changed API endpoint names or response codes cited in steps
- Deprecated UCs where the underlying FR is marked `*(deprecated)*`

**Deployment diagram (C4 Level 2) — look for:**
- New or removed containers or internal modules
- Changed database tables that represent new bounded contexts
- Changed scaling, replication, or scheduling configuration
- New or removed AWS infrastructure components

## Step 3 — Write Versioned Diagram File(s)

Write each new versioned file at the paths below. Do NOT modify the previous version.

| Type | Output path |
|---|---|
| `context` | `artifact/archittecture-diagram/00-context-diagram/context-diagram_v{M+1}.md` |
| `sequence` | `artifact/archittecture-diagram/01-sequence-diagram/sequence-diagram_v{M+1}.md` |
| `deployment` | `artifact/archittecture-diagram/02-deployment-daigram/deployment-diagram_v{M+1}.md` |

Each file must preserve the exact section ordering from the previous version and end with:

```
---
## Changelog (v{M} → v{M+1})
| Change | Section | Source | Rationale |
|--------|---------|--------|-----------|
...

> [HUMAN REVIEW REQUIRED] — Verify all Mermaid diagrams render correctly and that
> changes align with the current architecture driver baseline before accepting this
> as the new version.

## References
- [Architecture Driver](../../architecture-driver/requirement_v{N}.md)
```

**Changelog rules (same as `update-architecture-driver`):**
- Every row must cite the source file and a one-sentence rationale.
- Prefix additions with **Added**, modifications with **Updated**, removals with **Deprecated**.
- Never delete actors, flows, UCs, or containers — mark them `*(deprecated)*` in tables
  and show with a dashed Mermaid style (`stroke-dasharray`).
- Keep all existing items unless explicitly superseded.

**Stability rules:**
- Mermaid node IDs must remain stable across versions — never rename a node ID, even
  if its label changes.
- UC numbers are never renumbered — a deprecated UC stays in the file.
- Interface numbers (①②③) in the Interface Summary are never reused.

## Step 4 — Human Review Gate

After writing all files in scope, print a summary:

```
Wrote:
  [context]    artifact/archittecture-diagram/00-context-diagram/context-diagram_v{M+1}.md
               Actors: X total (Y added, Z deprecated) | Flows: X total (Y added, Z deprecated)
  [sequence]   artifact/archittecture-diagram/01-sequence-diagram/sequence-diagram_v{M+1}.md
               Use cases: X total (Y added, Z updated, W deprecated)
  [deployment] artifact/archittecture-diagram/02-deployment-daigram/deployment-diagram_v{M+1}.md
               Containers/modules: X total (Y added, Z updated, W deprecated)
  Requirement baseline: artifact/architecture-driver/requirement_v{N}.md
```

Then ask: *"Please review the file(s) above. Open each in a Mermaid preview to confirm
diagrams render correctly. Type `approve` to accept as the new diagram version(s), or
give feedback to revise."*

On approval → done. On feedback → revise the affected file(s) and re-present the summary.
