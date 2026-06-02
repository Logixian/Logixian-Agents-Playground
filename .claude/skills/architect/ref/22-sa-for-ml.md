# Lecture 22: Software Architecture for ML-Enabled Systems

> Guest: Grace A. Lewis, CMU SEI. Spring 2026.

## Objectives
- Why ML creates software architecture challenges.
- SA practices that address those challenges.
- Whether practices change for foundation models and agentic AI (short answer: no).
- Opportunities for advancing SA-for-ML.

## Terminology
An **ML-Enabled System** is a software system that relies on one or more ML-based components. An **ML Component** = the **Data Pipeline** (transforms production data into model inputs) + the **Trained Model** (or pre-trained model) + optional **Post-Processing** (translate model outputs to downstream APIs/formats).

Technology trend: prediction → generative → interactive (chatbots) → autonomous (agents). All still relevant for appropriate use cases; engineering rigor matters more as power grows.

## Five Challenges That Break Traditional SA Practices

### 1. Data-Dependent Behavior
Trained models learn behavior from training data; model development is iterative and experimental. Runtime behavior depends on how similar production data is to training data.

### 2. Drift Over Time
- **Concept/problem drift**: what counts as a "car" or "truck" changes.
- **Data drift**: the overall features of cars/trucks change.
Performance silently declines, hurting inference quality, user trust, and business goals. Requires components to capture logs, metrics, user feedback, ground truth; analysis components to decide how to adapt.

### 3. Timely Capture of Logs / Metrics / Labeled Data
- What data matters for retraining? Is it already labeled? Does labeling need user input? Is there delay between inference and labeling?
- Are logs surfacing model failures or data problems?
- What drift-detection metrics are appropriate? What action when drift is detected?

### 4. "Non-Traditional" Quality Attributes
| Traditional, but different concerns | Non-traditional |
|---|---|
| Monitorability, observability, fault tolerance | Explainability |
| Security, privacy | Fairness |
| Scalability, performance | Ethics |
| Evolvability | Trust / trustworthiness |

Some are model attributes with architectural consequences; others become architectural concerns once they must be observed over time.

### 5. Different Workflows, Teams, Backgrounds
Three separate workflows — model development, model integration/testing, model operation — run by three teams — data science / ML engineering, software engineering, operations — often with **no system context**. This mismatch between perspectives is the root of many ML-system failures.

## Central Role of SA in ML Development

### Co-Architecting: Two Architectures in Sync
Most ML systems have two architectures:
1. The architecture of the system that **produces** the ML component (the ML / data-science pipeline).
2. The architecture of the ML-enabled system that **uses** the ML component.

**Co-architecting** means developing both in sync and aligning them with the monitoring infrastructure so design decisions are driven by both system and model requirements. How tightly coupled they are depends on how automated the training/retraining cycle must be.

### SA-Driven Testing of ML Capabilities
System-level decomposition during architecture identifies which components will be ML; ML requirements derive from system requirements. Results of ML test & evaluation inform system-level activities (QAS-based test generation, see Brower-Sinning et al. SAML 2024).

### Quality Model for ML Components
Lewis et al. CAIN 2026 define a hierarchical quality model specific to ML components (arxiv.org/abs/2602.05043). See `slides/L22 - SA for ML.pdf` p.16.

## Monitorability as the Driving QA
Biggest difference from traditional systems. Open questions:
- How to monitor for drift? What metrics and thresholds?
- What are the proper actions when drift is detected?
- When to trigger retraining? Periodic, drift-based, "enough data"?
- Is monitoring part of an MLOps pipeline for automated retraining? What input does it need?

## Do Practices Change for Foundation Models?
No. FM-enabled systems still:
- Have non-deterministic models (moreso — hallucinations).
- Need evaluation for fitness for use.
- Need integration into ML-enabled systems (prompt engineering ≈ programmatic prompt construction).

What's new architecturally:
- **RAG**: integration of trusted/internal data sources is an architectural concern.
- **Responsible AI + Monitorability** become central QAs; hype drives blind trust of outputs; guardrails around inputs and outputs are architectural, not app-level.

## Agentic AI
No change to SA practices. Agentic systems inherit challenges of autonomous systems + LLM-enabled systems. Extra sources of non-determinism: non-deterministic workflows plus non-deterministic LLM-enabled tasks. Typically multi-layer: perception, cognition, action, communication.

## Opportunities for the Field
- **Adapt and grow SA BoK** for ML/FM/agentic systems — new tactics and patterns for co-architecting, evaluation, MLOps pipelines.
- **Bring SA discipline to model development** — modeling languages and analysis tools for data quality, model accuracy; Jupyter annotations that carry architecture-relevant info.
- **Position SA as a unifying activity** across data science, SE, and ops — addresses the mismatch problem.
- **System-level patterns and tactics** — most existing tactics are model-centric; we need system-centric ones. Indykov et al. 2025 identifies 18 tactics mapped to QAs, but collaboration between academia and industry is needed to find enough systems to study.

## Tools (from SEI)
- MLTE (ML Test and Evaluation): https://github.com/mlte-team/mlte
- TEC (ML Mismatch Analysis): https://github.com/cmu-sei/TEC
- UnitML (unit testing for ML components): https://github.com/cmu-sei/UnitML
- Train-test leakage detection: https://github.com/malusamayo/leakage-analysis

## Key Tradeoffs
- Tighter coupling between ML pipeline arch and system arch → better automation of retraining, but higher co-development cost.
- Heavier monitoring → faster drift detection, but more observability infrastructure.
- Guardrails on FM outputs → safer, but can constrain useful responses.

## Takeaway
SA practices don't change for ML/FM/agentic systems, but **what matters most changes**: monitorability becomes driving QA, co-architecting becomes essential, and the architect must bridge data-science / SE / ops workflows that traditionally don't share system context.
