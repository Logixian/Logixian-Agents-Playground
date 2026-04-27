# Lecture 21: Tactics for AI-Enabled Systems

> Garlan & Schmerl & Fairbanks, 16 April 2025 / Spring 2026

## Objectives
- Why LLM-enabled systems raise new architectural concerns.
- Relate tactics to quality attributes and tradeoffs.
- Compare grounding, guardrails, tools, fine-tuning, orchestration, evals, caching.
- Know when each tactic is appropriate.

## Why LLMs Are Architectural, Not Just API Integration
LLM-enabled systems have **probabilistic behavior**, external dependencies, rapid evolution (models/APIs/cost change fast), weak grounding, security risks, and cost/latency driven by context size and call chains. That makes quality-attribute design a first-class architectural concern, not just a prompt-engineering task.

## Key Quality Attributes
| Category | QAs |
|---|---|
| Output & behavior | Groundedness/correctness, reliability/consistency, safety/policy compliance, trustworthiness |
| System & operational | Latency/throughput, cost efficiency, privacy/security, evolvability/adaptability |

## Tactic Families
| Family | Purpose | Concrete tactics |
|---|---|---|
| **Grounding** | Connect outputs to relevant external context | RAG (index + retrieve), query rewriting, reranking, summarization |
| **Control** | Constrain behavior, enforce policies | Guardrails on input / output / tool-use; schema constraints; human approvals |
| **Capability Extension** | Use external tools/services | Tool calls, MCP, tool discovery + deferred loading |
| **Specialization** | Adapt behavior to a domain/task | Fine-tuning |
| **Coordination** | Structure multi-step / multi-agent work | Orchestration (fixed, rule-based, or planned), agentic workflows |
| **Assurance** | Evaluate and monitor behavior | Evals (release + operational), regression checks, monitoring |
| **Operations** | Manage cost, latency, failure | Model routing, fallbacks, caching |

## Grounding: RAG
Two phases:
1. **Build index** — select sources, chunk, embed + metadata, index. Source / chunking / indexing choices drive groundedness, freshness, retrieval quality.
2. **Retrieve on query** — encode query, retrieve relevant chunks, splice into prompt template, generate.

**Limitations → mitigations**: poor retrieval (better embeddings, hybrid retrieval), ambiguous queries (rewriting, decomposition), irrelevant chunks (reranking, filtering), stale sources (refresh, provenance), misleading retrieved context (guardrails, citation requirements), too much context (selection, compression).

RAG is a grounding tactic, **not a complete architecture**. Real AI-enabled systems compose RAG + guardrails + tools + evals + fallbacks.

## Control: Guardrails
Apply at three points:
- **Input**: validate, sanitize, block disallowed.
- **Output**: filter, enforce structure, require constraints.
- **Action/Tools**: verify permissions, require confirmation, enforce safe tool use.

## Capability Extension: Tools + MCP
Some tasks need live data, computation, or external action → delegate to tools rather than rely on model alone. **Model Context Protocol (MCP)** is the emerging standard: discovery + invocation protocol that makes APIs self-describing and agent-callable (JSON-Schema tools, runtime registration, transport-agnostic).

**Tool discovery problem**: All of Claude's tool descriptions consume ~60K tokens. Large tool surfaces inflate context and complicate selection. Tactic: **deferred loading** — two phases: `search()` for relevant tools, then `execute()` on the loaded subset (e.g., CloudFlare Code Mode MCP).

## Operations: Routing + Fallbacks
One model is rarely best for every request. Route by cost, latency, risk, complexity. Fallbacks improve resilience when preferred option fails.

## Specialization: Fine-Tuning
When default model can't be made good enough for a recurring task, train a specialized model. **Consequence**: architecture must now support training data, versioning, evaluation, rollback — operations, not just prompt edits. Adds lifecycle complexity in exchange for specialization.

## Coordination: Agentic Workflows
For multi-step tasks, structure work as orchestrated workflow instead of one prompt. Orchestration can be fixed, rule-based, or planned by an agent. Architecture questions: where does the plan come from, how are tasks decomposed/recombined, what context is shared across steps, how are failures/loops/disagreements handled.

## Assurance: Evals
Structured judgment-based criteria (not pass/fail) over final answers, retrieval quality, tool choice, policy compliance. **Release evals** support comparison and regression detection. **Operational evals** score sampled real-world traces at system and component level, compared to a baseline over time → detect degradation in retrieval, tools, controls; inform rollback and adaptation.

Eval pattern: user question + system answer + reference + rubric → judged by LLM / human / authoritative source.

## Frameworks ≠ Tactics
LangChain/LangGraph, LlamaIndex, Semantic Kernel, Haystack support retrieval, tool use, orchestration, evaluation. They are **implementations**, not tactics. Architectural choice comes first; framework is one way to realize it.

## Familiar vs Novel
| Familiar, adapted | Novel / newly central |
|---|---|
| Validation and policy enforcement | Probabilistic behavior |
| Indexing and retrieval | Context as an architectural structure |
| Failover and routing | Tool-using model execution |
| Workflow/orchestration | Evolving model/provider dependency |
| Monitoring and feedback loops | Deferred tool discovery/loading |

## Worked Example: Financial Chatbot (Troutans 2025)
Structured market data (local DB), company profiles, third-party news. Must give general info only — no personalized advice. Initial architecture composes:
- **Grounding / context augmentation** (retrieval + relevance ranking).
- **I/O validation** on incoming requests and outputs.
- **Control orchestration** — plan what to retrieve based on prompt.
- Additional needs: freshness/time awareness, entity resolution (map "Apple" → ticker), source attribution.

See `slides/L21 - Tactics for AI-Enabled Systems.pdf` p.27–31 for the architecture diagrams.

## Key Tradeoffs
- **Grounding** improves correctness but adds retrieval subsystem + latency + index maintenance.
- **Guardrails** improve safety but can over-constrain and hurt usefulness.
- **Tools / MCP** extend capability but widen attack surface (prompt injection, unsafe tool use).
- **Fine-tuning** improves consistency but adds a full model lifecycle.
- **Agentic coordination** handles complex tasks but adds failure modes (loops, disagreement, cascading errors).
- **Evals** catch regressions but require reference / rubric curation.

## Takeaway
The main design challenge is **not choosing one tactic**, but composing several coherently while managing tradeoffs in quality, cost, complexity, and evolvability.

## References
- Subramaniam & Fowler, *Emerging Patterns for Building GenAI Products* (martinfowler.com/articles/gen-ai-patterns/).
- Yan, *Pattern for Building LLM-based Systems & Products* (eugeneyan.com/writing/llm-patterns/).
