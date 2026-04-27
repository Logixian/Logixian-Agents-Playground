# Studio Critique — Preparation and Gap Analysis

*Working document. Crit date: 2026-05-01, 9:00 a.m. - 12:30 p.m., MSE classroom 265.*
*Team slot: 65 minutes (35 presentation, 30 panel Q&A). External assessors, no prior team context.*

---

## Scoring math (do not lose sight of)

| Rubric criterion | Weight | Our target | Exemplary threshold |
|---|---|---|---|
| Viability of Project and Risk Management | 15% | Exemplary | Plan, risks, roles all viable |
| Soundness of Software System | 25% | Exemplary | Clearly specified + appropriate + sufficient + prioritized + tradeoffs explicit |
| SE System: Decision Quality | 25% | Exemplary | All 4 of: clear decisions, evidence-backed justification, tradeoffs explained, consistent reasoning |
| SE System: Elements | 25% | Exemplary | Processes + artifacts + measurements + resources all identified, defined, completed, documented |
| Crit Performance | 10% | Exemplary | Effective comm + deep reflection + active feedback engagement + balanced participation |

**50% is SE System.** Every prep decision routes through this.

---

## Proposed 35-minute flow and ownership

| # | Segment | Minutes | Lead(s) | Primary artifact to navigate live |
|---|---|---|---|---|
| 1 | Project Context | 5 |  | `docs/project-description.md`, state-market-brief if time |
| 2 | Management | 7 |  | Jira board, Weekly Digest 2026-04-19, Risk Register |
| 3 | Requirements | 6 |  | OpenAPI YAML, 2.2 Data Model page, 2. Requirements page |
| 4 | Architecture | 6 |  | 3. Architecture page (§4, §5, §7), Structurizr diagrams |
| 5 | SE System | 9 |  | Software Engineering System page (when published), information-flow diagram, live skill invocation |
| 6 | Reflection | 2 |  | Two-lesson card |

**Every team member speaks for at least one segment.** Crit Performance scores balanced participation.

---

## Segment-by-segment readiness

### 1. Project Context — READY

**What we have**: `docs/project-description.md`, state-market-brief, clear client context via Brad.

**Gaps**: none on content. Pure rehearsal.

**Todos**:
- [ ] Decide narrator
- [ ] Rehearse 5-minute open

---

### 2. Management — PARTIAL

**What we have**:
- Jira project live with sprints and tickets
- Weekly Digest cadence (most recent 2026-04-19) via `/pm` skill
- Risk Register page exists (Confluence 89325569) — last referenced in 2026-04-12 digest
- Sprint retros documented (most recent 2026-04-16)
- WBS in the M2 milestone table

**Gaps**:
- [ ] **Measurement Plan** — not documented. Coach 4/21 requested. Blocks Exemplary on PM.
- [ ] **Team roles one-pager** — informal. Assessors will ask.
- [ ] **Risk Register refresh** — only 2 risks logged (R-001 state expansion, R-002 data sources emerging). Add LLM-specific risks from Scott's framework (skill atrophy, review fatigue, hallucination, IP).
- [ ] **Project plan to year-end** — WBS exists but summer-to-December is thin. Need a milestone-level view.

**Todos**:
- [ ] Draft team roles page (1 page, table)
- [ ] Refresh risk register to 5-7 risks with owner and mitigation
- [ ] Consolidate summer-to-December plan into one Confluence page
- [ ] Measurement plan (engineering process metrics; product QA separate)

**Risk if not closed**: Scoring drops from Exemplary (3 pts) to Strong (2.7) or Developing (2.2). Loss of 0.3 to 0.8 points.

---

### 3. Requirements — MOSTLY READY

**What we have**:
- 2. Requirements page in Confluence with QAS (drivers, scenarios, scores)
- 2.1 System Boundaries & Assumptions page (M1 deliverable)
- 2.2 Data Model & Integration Strategy page (current as of 2026-03+)
- OpenAPI v0.3.0 (IRA-89) — external contract drafted
- State-market-brief with 5-state comparison

**Gaps**:
- [ ] **Tradeoff narrative** — scattered across Confluence pages. No single "requirements decisions" table. Soundness-of-SW-System rubric explicitly names this.
- [ ] **Scope priorities** — 5 states first, then 20, but the "why 5" rationale is tribal knowledge.
- [ ] **Requirements traceability** — do we have a table mapping QAS to architecture decisions? (Yes, partially, in 3. Architecture §7.)

**Todos**:
- [ ] Add a short "Requirements Decisions" section to the 2. Requirements page or a sibling page. 5 or 6 rows: decision, alternative, why chosen, implication.
- [ ] Rehearse the 5-states-first rationale as a 30-second answer.

**Risk if not closed**: Drops Soundness from Exemplary (5) to Strong (4.5). Loss of 0.5 points.

---

### 4. Architecture — READY, pending diagrams

**What we have**:
- 3. Architecture page (consolidated 2026-04-22, version 13)
- 3.1 API Server (refreshed)
- 3.2 Pipeline Worker (new)
- ADRs 001–005
- Structurizr DSL with 5 views
- Decision rationale table (§7) with 9 driver-to-decision rows

**Gaps**:
- [ ] **Diagram PNG regen** — DSL updated, images not yet exported.
- [ ] **Diagram embeds** — Confluence placeholders on 3., 3.1, 3.2.
- [ ] **ADR rationale tightening** — coach 4/17 flagged ADRs as LLM-long and missing explicit trade-off justification. At minimum show one ADR that has been revised in this style.
- [ ] **Stale IRA-90 pages** — 107839489 and 117506050 still describe superseded callback SQS. Add "superseded by 3. Architecture" banner.

**Todos**:
- [ ] Run Structurizr CLI to export PNGs
- [ ] Upload PNGs to Confluence and wire embeds (you said you'd do this manually)
- [ ] Revise at least ADR-003 (coach-flagged) to model the new rationale pattern
- [ ] Add superseded banner to 107839489 and 117506050

**Risk if not closed**: Diagram embeds are essential for the visual flow of the presentation. Without them we would have to share DSL text, which is worse.

---

### 5. Software Engineering System — PARTIAL, highest leverage

**What we have**:
- Draft SE System page at `docs/software-engineering-system.md` (local, 8 sections)
- Custom skill repo: `/architect`, `/pm`, `/commit`, `/pr`, `/branch`, `/prompt-coach`
- CLAUDE.md hierarchy (global, project, skill-local)
- Memory store at `~/.claude/projects/.../memory/`
- Weekly digest loop (evidence of meeting-to-action chain)
- Sprint retro policies (human-review gate on AI output)

**Gaps**:
- [ ] **Information-flow diagram** — the hero artifact for this segment. Not drawn.
- [x] **Course knowledge ingested into `/architect`** — done 2026-04-24. Full CMU 17-633 mirror in `architect/ref/`.
- [ ] **Live skill demo** — not practiced. What exact invocation do we show? Candidates: `/architect` adding or revising an ADR live, `/pm` generating a digest draft.
- [ ] **Measurement Layer evidence** — none collected yet. Must be honest: "planned, not yet operational." Assessor will notice.
- [ ] **Evidence stories (§6)** — three cases drafted. Need rehearsed 30-second versions.
- [ ] **Publish SE System page to Confluence** — currently local only.

**Todos**:
- [ ] Draw the information-flow diagram (Mermaid). 3 loops overlaid on shared stores.
- [ ] Decide on and rehearse the live demo invocation. Test it on a throwaway page first.
- [x] Ingest full CMU 17-633 course mirror into `/architect` ref folder. Snapshot dated 2026-04-24 in SKILL.md.
- [ ] Publish SE System page as `Software Engineering System` child of space root (done — id 157450241).
- [ ] Rehearse three evidence stories (coach ADR feedback, digest catching unassigned tickets, IRA-90 drift catch).

**Risk if not closed**: 50% of the score depends on this segment. Skipping the demo or showing no measurements drops Elements from Exemplary (5) to Strong (4.5). Weak evidence drops Decision Quality similarly. Together a loss of 1+ point.

---

### 6. Reflection — NOT STARTED

**What we have**: nothing drafted.

**Gaps**:
- [ ] Two lessons. One must be about AI.
- [ ] Closer chosen.

**Todos**:
- [ ] Draft two lessons with the whole team (1 meeting).
- [ ] Candidates:
  - AI lesson: "AI produces plausible-looking drafts that pass the sniff test but miss project-specific trade-offs. Coach flagged our LLM-generated ADRs as too long and missing explicit rationale. We now treat AI output as a first draft requiring human-added reasoning, not a finished artifact."
  - General lesson: "Versioning architecture diagrams (Structurizr DSL + PNG + Confluence) alongside the prose kept the design and the document in sync. Without that, we would have a 30-page Confluence stack that lies."

**Risk if not closed**: Part of Crit Performance (10%). Weak reflection drops the score from Exemplary (2) to Strong (1.5).

---

## Rubric → evidence map

| Rubric criterion | What we show (with what artifact) | Gap |
|---|---|---|
| PM Viability: plans | Summer-to-December milestone plan on Confluence | Plan not yet consolidated |
| PM Viability: risks | Risk Register page | Needs refresh to 5-7 risks |
| PM Viability: tracking | Jira board + weekly digest | — |
| PM Viability: roles | Team roster one-pager | Not written |
| PM Viability: measurement | Measurement plan doc | Not written |
| SW System: specified | Confluence 2.x + OpenAPI + 3. Architecture | — |
| SW System: appropriate | Scope decisions in 2. Requirements | Rationale implicit |
| SW System: sufficient | 3. Architecture + 3.1 + 3.2 | — |
| SW System: prioritized | 5 states → 20 in state brief | Explicit priority doc missing |
| SW System: tradeoffs | 3. Architecture §7 decision table | — |
| SE: clear decisions | ADRs 001-005 | — |
| SE: justification | ADR context sections + decision table | ADR-003 called out as weak |
| SE: tradeoffs | ADR consequences | Per-ADR trade-off line needs adding |
| SE: consistent reasoning | Driver-to-decision traceability | — |
| SE: processes | SE System doc §3 (four loops in ETVX — Meeting, Planning, Architecture, Implementation) | Publish to Confluence |
| SE: artifacts | SE System doc §2 | — |
| SE: measurements | SE System doc §5 | Metrics not yet collected |
| SE: resources | SE System doc §4 (skills + tools + roles) | Live demo not practiced |
| Crit Performance | Live presentation | — |

**Count of gaps per criterion** (rough priority order):
- SE Elements: 3 gaps
- PM Viability: 3 gaps
- SE Decision Quality: 2 gaps
- SW System: 2 gaps
- Crit Performance: 1 gap (reflection)

---

## Cross-cutting preparation

### Anticipated assessor questions

**PM / Management**
- "Show me a risk that materialized and how you handled it."
- "What's your velocity? How do you know you'll finish?"
- "Who handles blockers when Kuan is unavailable?"

**Requirements**
- "Why 5 states first? What happens if client wants a 6th during summer?"
- "How do you handle conflicting regulations across states?"
- "What's your source of truth for a state's rules?"

**Architecture**
- "Why SQS + KEDA instead of a simple worker Deployment?"
- "What if a state regulation changes mid-calculation?"
- "Walk me through how you'd add a new state."
- "How do you test architecture decisions? ATAM? ARID? Reviews?"

**SE System (Christian-style)**
- "How do you know your agents produce correct output?"
- "What happens if `/architect` drafts a bad ADR? How do you catch it?"
- "What's your prompt versioning story? How do you roll back a bad skill change?"
- "How do you prevent skill atrophy on teammates who don't invoke it often?"
- "How do you measure the impact of AI on team velocity?"
- "What's your human-review-fatigue mitigation?"
- "When is AI the wrong tool for a step?"

**Reflection**
- "What surprised you?"
- "What would you do differently if you restarted?"
- "What feedback hit hardest?"

### Artifact tour practice

The assignment explicitly says **no slides summarizing artifacts; show the real thing**. Practice:
- Navigating Confluence to specific pages without fumbling
- Opening Structurizr diagrams (Lite local? PNGs? decide)
- Opening the GitHub repo to show the `.claude/skills/` tree
- Running a live `/architect` or `/pm` invocation (if we include a demo)

Each lead should rehearse their navigation path at least twice before 5/1.

### Equipment and logistics
- [ ] Confirm room display monitor compatibility (HDMI? USB-C? dongle needed?)
- [ ] Confirm wifi access for live Confluence and Jira nav
- [ ] Print or have offline copies of key diagrams in case of network failure
- [ ] Decide if live agent demo uses cloud or local runtime (latency risk)

---

## Risks and mitigations for the crit itself

| Risk | Impact | Mitigation |
|---|---|---|
| Live agent demo fails mid-presentation | Embarrassing, loses time | Pre-record a 30s screen capture as fallback |
| Someone dominates speaking time | Crit Performance criterion hits | Assign segment owners in advance, enforce timebox |
| Assessor asks about LLM-2 accuracy in SE System segment | Category confusion on our end | Have the SE/SW-QA distinction rehearsed as a one-liner |
| ADR-003 gets picked apart for weak rationale | Decision Quality score drops | Revise ADR-003 before 5/1 to demonstrate the new pattern |
| Presentation runs long, reflection gets cut | Crit Performance drops | Hard-stop each segment, closer gets 2 minutes guaranteed |
| No demo works in the room | Loses the SE segment's differentiator | Navigate to pre-prepared transcript of a demo instead |

---

## Working timeline to 2026-05-01

Nine days from today. Rough schedule:

| Date | Focus |
|---|---|
| 2026-04-23 (today) | Finalize SE System doc, finalize this prep doc, share with team |
| 2026-04-24–25 | Information-flow diagram; ~~ingest course knowledge into `/architect`~~ (done 2026-04-24); risk register refresh |
| 2026-04-26 | Christian's session (leverage to critique SE System draft) |
| 2026-04-27 | Incorporate Christian feedback; draft reflection lessons |
| 2026-04-28 | Measurement plan; team roster; requirements decisions table |
| 2026-04-29 | ADR-003 revision; PNG regen; Confluence embeds; IRA-90 superseded banners |
| 2026-04-30 | Full team rehearsal. Time each segment. Practice Q&A. |
| 2026-05-01 | Crit day. |

---

## Open items for the team

Decide together at next sync:

- Segment narrators (especially Project Context, Reflection closer)
- Live demo scope: show a skill invocation in real time, or pre-recorded?
- Should we also practice one "pivot question" per segment where we redirect an off-topic assessor question gracefully?
- Who sits where in the room? (Speaker on center, rest strategically)
