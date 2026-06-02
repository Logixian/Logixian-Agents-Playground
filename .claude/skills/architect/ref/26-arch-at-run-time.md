# Lecture 26: Architectures at Run Time

> Garlan & Schmerl & Fairbanks, 20 April 2026.
> Two slide decks: main self-adaptation lecture (Rainbow, MAPE-K, security application) + supplementary ML self-adaptation (Maria Casimiro, SSSG 2023).

## Objectives
- Why modern systems need self-adaptation.
- How architectures can be used at run time.
- MAPE-K architecture.
- How formal models can automate the self-adaptation process.
- How self-adaptation relates to AI-based systems.

## The Problem
Modern systems must maintain high availability and optimal performance despite: environment changes, faults, attacks, changes in user needs/context.

### Why this matters economically
- Black Friday 2006: Amazon disruption from Xbox 360 launch the day before; "Scheduled Maintenance" on the busiest shopping day.
- BestBuy Black Friday 2014: mobile traffic spike → full site shutdown.
- Apple March 2015: ~$25M lost in a 12-hour outage.
- Facebook March 2019: 14-hour outage, ~$90M.
- Delta August 2016: ~$150M in 5 hours.
- Average cost of downtime: $9000/min ($540K/hr); large companies closer to $5M/hr.
- Industry-specific: auto $3M/hr, media $90K/hr, healthcare $636K/hr, retail $1.1M/hr, telecom $2M/hr, energy $2.48M/hr.

## How Adaptation Is Addressed Today — and Why It's Inadequate

### Technique 1: Resilience in application code
Exceptions, timeouts, low-level mechanisms. Fails at: locating causes, detecting soft anomalies, anticipating future problems, maintainability (hard to add/change policies), changing objectives, retrofitting legacy.

### Technique 2: Human oversight
Operators, sys-admins, users. Costly, error-prone, slow.
- 1/3–1/2 of IT budget goes to preventing/recovering from crashes.
- $1 to buy storage vs. $9 to manage it (Nick Tabellion).
- 60–75% of DB TCO is admin cost.
- 40% of system outages attributable to operator error.
- *Washington Post, Oct 2014*: "Stop worrying about mastermind hackers. Start worrying about the IT guy" — the weakest link is human fallibility in configuration and patching.

### The new approach: open-loop → closed-loop
```
        Control Mechanisms
      ↓ Affect     ↑ Sense
         Executing System
```

## Examples of Closed-Loop Architectures
- **Google File System** (Ghemawat, Gobioff, Leung, SOSP 2003): master monitors chunkservers, handles replication, failure recovery.
- **Kubernetes**: desired-state control plane reconciles runtime state.

## IBM MAPE-K (Kephart & Chess, *Autonomic Computing*, 2003)
**M**onitor → **A**nalyze → **P**lan → **E**xecute, all around shared **K**nowledge.

```
     Plan
Analyze  Execute
  \     |     /
      Knowledge
  /     |     \
Monitor       Effectors
  ↓             ↑
      Managed System
      Environment
```

**Related disciplines**: control systems, fault tolerance, biology/immune system, AI, software architecture.

## Rainbow Framework (Garlan et al., IEEE Computer 37(10), 2004)
A framework for adding a control layer over existing systems. Uses architecture models to detect problems and reason about repair. Tailored to specific domains via extension points (probes, actuators, models, fault detection, repair policies).

### Rainbow structure (see `slides/L26 - Arch at Run Time.pdf` p.20–24)
```
                 Architecture Layer
  Strategy        Architecture    Adaptation
  Executor   ←    Evaluator   ↔   Manager
      ↑                              ↑
     [Model Manager ← shared arch model]
      ↑              ↓
     [Gauges]   [Translation Infrastructure]
      ↑              ↓
  Probes         Effectors
      ↑              ↓
           Target System
```

| Rainbow part | Responsibility |
|---|---|
| Model Manager | Holds architecture + environment model |
| Gauges | Aggregate system info up into model terms |
| Architecture Evaluator | Detects problems in the model |
| Adaptation Manager | Decides best adaptation |
| Strategy Executor | Carries out the adaptation |
| Effectors | Change state in target system |
| Probes | Extract system info |

## Running Example: Znn.com
An n-tiered news site with: clients → load balancer → server pool → backend DB.

**Adaptation condition**: client request-response latency within threshold.

**Possible tactics**:
- On load balancer: `restartLB`.
- On server pool: `enlistServers`, `dischargeServers`, `restartWebServer`, `lowerFidelity` (text vs multimedia), `raiseFidelity`.

**Monitored properties**: `ClientT.reqRespLatency`, `HttpConnT.bandwidth`, `ServerT.load`, `ServerT.fidelity`, `ServerT.cost`.

## Stitch: Language for Self-Adaptation Strategies
Models adaptation as a decision tree (see `slides/L26 - Arch at Run Time.pdf` p.26).
- **Control-system model**: next action depends on observed effects of previous action.
- **Uncertainty**: branch probabilities capture non-determinism.
- **Asynchrony**: explicit timing delays to see impact.
- **Value system**: utility-based selection of best strategy under current context.

### Znn.com utility profile
```
Objectives: timely response uR, high-quality content uF, low cost uC.
uR utility:  0: 1.00, 500: 0.90, 1500: 0.50, 4000: 0.00
weights:     uR: 0.3, uF: 0.4, uC: 0.2, uSF: 0.1
```
Tactics annotated with `[Δlatency, Δfidelity, Δcost, ...]` cost-benefit vectors; strategies combine tactics.

### Strategy selection algorithm
Given quality dimensions & weights, a strategy tree, branch probabilities, and tactic cost-benefit attributes:
1. Propagate cost-benefit vectors up the tree reduced by branch probabilities: `AggAV(x) = cbav(x) + Σc prob(x,c) AggAV(c)`.
2. Merge expected vector with current conditions.
3. Evaluate quality attributes against utility functions.
4. Compute weighted sum → utility score.
5. Pick strategy with highest score.

### Experimental results
With adaptation enabled, latency stayed at ~2s target under load; without adaptation, latency climbed to ~100s. Adaptation approach improves overall system performance.

### Sys-admin evaluation
Interviewed admins with priming + interview + compose-Stitch-from-scenarios methodology. Stitch concepts fit naturally: core commands as operators, coarser-grained sequences (step) with conditions of applicability and intended effects, strategies as adaptations with intermediate condition-actions and observations. Analysis of CMU sys-admin Netbwe example showed Rainbow captured adaptation concerns and Stitch hoisted policies previously buried in Perl code.

## Application to Security: Self-Protection Against Application-Layer DoS
Znn.com-like n-tier model; quality objectives include:

| QA | Description |
|---|---|
| Performance | Request-response time for legitimate users |
| Cost | Number of active servers |
| Maliciousness | % of malicious clients |
| Annoyance | Disruptive side-effects of tactics |

**Tactics**:
- `Add capacity` (activate more servers).
- `Blackhole` (blacklist, drop requests).
- `Reduce service` (lower fidelity — text vs images).
- `Throttle` (limit request rate).
- `Captcha` (verify requester is human).
- `Reauthenticate` (force clients to re-authenticate).

**Strategies**:
- `Outgun/Absorb` = Add capacity + Reduce service.
- `Eliminate` = Blackhole + Throttle.
- `Challenge` = Captcha + Reauthenticate.

Formal model uses **PRISM probabilistic model checker** on a utility profile encoding functions + preferences as reward structures.

**Result**: different preferences → different optimal strategies. Minimize-malicious-clients → `Challenge`. Optimize-good-client-experience → `Eliminate` or `Outgun`. Supports formal reasoning + model checking; allows combinations; extensible (add new tactics later).

See Schmerl et al., *Architecture-Based Self-Protection: Composing and Reasoning about DoS Mitigations*, HotSoS 2014.

## Self-Adaptive System Challenges
1. Self-securing systems.
2. Adaptive ML-based systems (L26 supplement).
3. Fault diagnosis and localization.
4. Human-in-the-loop adaptation.
5. Combining reactive and deliberative adaptation.
6. Proactive and latency-aware adaptation.
7. Architecting for adaptability.
8. Systems of systems.

---

# Supplement: Self-Adaptation for Machine-Learning-Based Systems

> Guest: Maria Casimiro, CMU. Based on SSSG Spring 2023 + ACSOS extension work.

## Motivation
ML is ubiquitous (self-driving, fraud detection, medical diagnosis, robotics). **Non-static environments** lead to model mispredictions → affect system-level utility. Adaptation can enhance predictive quality at runtime. Research questions:
1. What can we do to improve the ML model at run time? What adaptation tactics exist?
2. If the model is misbehaving, should we adapt? Do expected benefits outweigh costs?

## Causes of ML Misprediction
- **Dataset shift**: input distribution diverges from training distribution.
- **Incorrect labels**: mislabeled samples; or tampered test data.

## Adaptation Tactics for ML Models

| Tactic | Description |
|---|---|
| **Component replacement** | Replace under-performing component with one better matched to current environment |
| **Human-based labeling** | Rely on a human to classify incoming samples or correct labels |
| **Transfer learning** | Reuse knowledge from prior tasks to accelerate learning |
| **Unlearning** | Remove no-longer-representative samples from training set and model |
| **Retrain** | Retrain with new data, possibly choosing new hyperparameters |

## MAPE-K Challenges for ML Adaptation
- **Monitor**: feedback (ground truth) takes too long to become available.
- **Analyze**: uncertainty propagation across components.
- **Plan**: predict benefits of retraining.
- **Execute**: enhance predictability of tactic execution (retrain latency).
- **Knowledge**: keep track of outcomes of past adaptations.

## Open Challenges
- How to detect when supervised ML systems are performing poorly?
- How to quantify impact of mispredictions on system utility?
- How to choose the right tactic?
- What are costs and benefits of each tactic?

## Formal Framework (initial focus: retrain tactic)
Goals: understand if retraining improves system utility; understand in which scenarios it's worth retraining.

### What to model
- **Environment** — conditions under which system operates; environment changes as events.
- **Adaptation Manager** — trades off cost/benefit of tactics.
- **ML Component** — confusion matrix (error characterization), knowledge (old + new data), interface (`query`, `update_knowledge`, `retrain`).
- **Repair tactics** — ⟨latency, cost⟩ pairs with pre-conditions and effects on target components.

### ML component state evolution
- `update_knowledge(⟨input, prediction[, real output]⟩)` → add instances to knowledge.
- `retrain()` → update confusion matrix, mark samples used for retrain as "old data".

### Result: adaptation is context-dependent
With retrain latency = 1, adaptation always pays off. With latency = 5 or 10, benefits shrink or disappear — whether adaptation is worth it depends on the latency/cost ratio and the impact of mispredictions on system utility.

## Adaptation Impact Predictors (AIPs)
Predict expected impact of a retrain action using features:
- **Basic**: amount of new data, current accuracy.
- **Output characteristics**: output distribution of the model.
- **Input characteristics**: input distribution of the model.

Build predictors for TPR/TNR under `retrain` and `nop`. Train by evaluating all previously-retrained models at each time instant.

## PRISM Reasoning (should we retrain?)
Use PRISM probabilistic model checker to reason over: predicted TPR/TNR, SLAs, costs, latencies → decide whether to retrain such that benefits > costs.

## Running Example: Fraud Detection
```
Clients → Transaction → Bank → Verify transaction → [ML model score + rule-based model] → Decision
```
- **System utility**: minimize SLA-violation cost + retrain cost + FPR-threshold violations + recall-threshold violations.
- **Impact varies**: per-client (different SLAs), over time (Black Friday).

**Baselines**: no retrain, periodic (every 10h), reactive (on SLA violation), random, oracle (optimal). Framework must beat the non-oracle baselines across execution contexts.

Experimental results show framework improves system utility vs. baselines, with retrain latency as the dominant context variable.

## Current & Next Work
- **ACSOS extension**: new dataset-shift detection, drop label assumption via near-real-time monitoring.
- **Machine translation use-case**: extend approach to non-classification problems.
- **ML retrain in practice**: how do practitioners actually retrain models?

## Takeaway
Self-adaptation integrates cleanly with ML systems through MAPE-K, but **predicting tactic impact** (benefits vs costs) is the hard part — AIPs + formal reasoning (PRISM) make it tractable for retrain-like tactics.

---

## Key Tradeoffs (Whole Lecture)
- **Reactive (code-level) adaptation** vs **architecture-based self-adaptation**: reactive is simpler but lacks global view, policy evolvability, and legacy retrofit.
- **Rainbow/Stitch strategy trees**: expressive + utility-based, but require modeling effort and good probability estimates.
- **Formal reasoning (PRISM)**: gives provable guarantees but needs well-formed stochastic models.
- **ML self-adaptation**: retrain and related tactics work, but only when benefit prediction is reliable and retrain latency is acceptable.

## References
- Garlan, Cheng, Schmerl. *Increasing System Dependability through Architecture-based Self-repair*. Architecting Dependable Systems, 2003.
- Garlan et al. *Rainbow: Architecture-Based Self-Adaptation with Reusable Infrastructure*. IEEE Computer 37(10), 2004.
- Cheng & Garlan. *Stitch: A Language for Architecture-Based Self-Adaptation*. JSS 85(12), 2012.
- Schmerl et al. *Architecture-Based Self-Protection: Composing and Reasoning about DoS Mitigations*. HotSoS 2014.
- Cámara, Moreno, Garlan, Schmerl. *Analyzing Latency-aware Self-adaptation using Stochastic Games and Simulations*. ACM TAAS 2015.
- Cámara, Garlan, Schmerl, Pandey. *Optimal Planning for Architecture-Based Self-Adaptation via Model Checking of Stochastic Games*. SAC DADS 2015.
- Casimiro et al. *ACSOS 2022 / 2023*.
