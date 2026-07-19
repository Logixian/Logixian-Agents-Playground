# Implementation Design Notes

This document captures implementation-specific design decisions that describe *how* the system achieves its requirements, extracted from `requirement_v4.md` to maintain a clean what-vs-how separation in the main requirements file. Each section references its originating requirement number.

---

## FR-I07 — LLM-Based Regulatory Data Extraction

**Originating Requirement:** FR-I07 (removed from functional requirements in v4)

The system shall utilize an LLM (via AWS Bedrock, Anthropic models) to parse and extract regulatory data exclusively from officially designated state portals and FAQs (e.g., `employer.calsavers.com`), bypassing raw legal text, into the predefined unified rule model schema (see [FR-I09 Schema Details](requirement-schema-details.md#fr-i09)).

**Design rationale:**

- Data model specifies state portals (e.g., CalSavers FAQs) as the designated scraping target; raw law complexity is intentionally bypassed.
- AWS Bedrock provides the IRALOGIX-approved LLM access layer; Anthropic models (e.g., Opus) are recommended for the POC.
- Low-confidence extractions must trigger the human review gate (FR-I08) before publishing to the knowledge database.
- LLM output must match the predefined schema with no hallucinated fields (see quality attribute A6).
