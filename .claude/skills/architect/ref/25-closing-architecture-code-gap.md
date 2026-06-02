# Lecture 25: Closing the Architecture–Code Gap

> Schmerl & Garlan & Fairbanks, 7 April 2025 / Spring 2026.

## Objectives
Why the architecture-code gap matters and four practical strategies for closing it.

## Why the Gap Matters
Architecture makes critical structure visible (responsibility allocation, quality attributes). Code makes computation executable. The mapping between them is often weak, incomplete, or lost — which hurts comprehension, maintenance, evaluation, and evolution.

## Four Practical Strategies
| Approach | What it is |
|---|---|
| **1. Architecturally-evident coding** | Reveal architecture in code through naming and structure |
| **2. Architecture hoisting** | Embed architectural concerns in shared mechanisms |
| **3. Model-based development** | Generate code from architecture |
| **4. Architecture recovery** | Recover/check architecture from code and run-time artifacts |

## Approach 1: Architecturally-Evident Coding Style
Use code structure and naming to expose architectural intent. Readers can infer components, connectors, constraints without reverse-engineering.

### Visible component types (pipe-and-filter example)
```java
package infrastructure.pipeAndFilterStyle;
abstract public class Filter extends Component implements Runnable {
  public void run() { try { this.work(); } catch (Exception e) { System.exit(1); } }
  abstract protected void work() throws InterruptedException;
}
```
- Abstract `Filter` class differentiates components from other classes.
- Standardizes startup with `run()`/`work()` template.
- IDE class-hierarchy lets you browse all subclasses of `Filter` or `Component`.

### Visible connector types
A `final class Pipe<T> extends Connector` using a `BlockingQueue` — no subclasses (sealed connector), hoists concurrency concerns into the pipe, searchable in IDE.

### Easy mapping to C&C view
Centralized `createPipes()`, `createFilters()`, `startFilters()` startup rather than scattered creation/assembly → aids comprehension and analysis. Alternative: a config file that declares the same topology declaratively.

### What this buys you
- Less reverse-engineering during maintenance.
- Easier new-developer ramp-up.
- Architecture visible in the IDE.

### What it does *not* buy you
**Visibility helps comprehension, not enforcement.** Critical quality concerns can still be implemented ad hoc across the codebase.

## Approach 2: Architecture Hoisting
Move a concern out of repeated application logic into a shared architectural mechanism that enforces or strongly influences behavior.

**Convention → mechanism**: "developers should use log4j everywhere" → a framework/connector/platform element handles logging systematically.

### Hoisting mechanisms
| Mechanism | Example |
|---|---|
| Application frameworks | Template solutions (Spring, Rails) |
| Language runtime | GC, strong typing (e.g., `TrustedSQLString` to interact with DB) |
| DSLs | Limit expressiveness to avoid unsafe constructs |
| Virtual machines | Limit OS/low-level access (browsers can't touch files) |
| Libraries, runtime services | APIs ensure correct use |
| **API gateways, service meshes, sidecars** | AuthN/Z, rate limiting, retries |
| **Workflow engines** | Orchestration |

Common hoisted concerns today: authN/Z, retries/backoff/circuit-breaking, rate limiting, observability, audit logging.

### Hoisting = tactics packaged into reusable infrastructure
Hoisting moves tactics from local code into architectural mechanisms, improving consistency, analyzability, and reuse.

### Case study: Netflix thundering herds (Anand, QCon SF 2011)
**Setup**: microservices (recommendations, up-next, popular shows); each service can call up to 20 others; autoscaling at every level.

**Failure cycle**:
1. Services X and Y call A.
2. Y overwhelms A.
3. X and Y see timeouts.
4. A autoscales up.
5. New requests + retries cause request storms.
6. More timeouts → cycle repeats (unless A can outgrow the load).

**Solution: hoist inter-service calls into two libraries (connectors)**:
- **NIWS library (client side)**: retry logic with exponential backoff, fair retry (Max Number Requests / Sample Interval), failover, fast failure, thundering-herd prevention.
- **BaseServer library (server side)**: MNCR (max concurrent requests); excess traffic gets 503.
- **Graceful degradation required**: any throttled client must degrade — show popular movies not personalized, honor expired device lease if no new one can be generated.

**Social enforcement**: Netflix also introduced chaos-monkey-style random failures in production to force developers to confront failure — otherwise developers wouldn't use the libraries. This built a socio-technical environment that incentivized correct connector use. Later became the Simian Army.

### Lessons
- Enforces company-wide consistency on failure handling.
- Burden of graceful-degradation logic shifts to developers.
- Connector becomes the standard approach across the org.
- Downside: developers may not use the libraries, or may set bad config parameters.

See `slides/L25 - Closing Architecture and Code Gap.pdf` p.16–30 for the full progression of diagrams.

## Approach 3: Model-Based (Model-Driven) Engineering
Use an architectural model as input to implementation — generate code, configuration, glue code, or framework artifacts. Strengthens consistency between intended and implemented structure.

| Benefits | Costs |
|---|---|
| Stronger consistency arch↔impl | Modeling discipline required |
| Less hand-written boilerplate/wiring | Limited by modeling language + generator |
| Easier generation of framework-constrained structures | Generator / toolchain lock-in |
| Possible analysis before impl | Hand-written code can drift around the generated core |

### Where it works best
- Framework-constrained systems (SpringBoot).
- C&C platforms (F'/F'').
- Deployment/config-heavy systems.
- Product lines / systems with repeated architectural structure.
- Cases where generated glue code is repetitive and error-prone.

### Example: F' / F''
- **F'**: open-source embedded systems framework from NASA JPL. Used for small-scale projects (Mars Helicopter, CubeSats).
- **F''**: ADL very similar to Acme — defines active/passive/queued component types (threading model), strong typing of ports.
- F'' model compiles to a partially-implemented F' deployment, which compiles to C++/flight software.

```
active component Manager {
  async input port action: Fw.Cmd
  output port worker: Request
  async input port result: Reply
}
instance manager: Manager
instance workerA: Worker
connections c1 { manager.worker -> workerA.request }
connections c2 { workerA.reply -> manager.result }
```

## Approach 4: Architecture Recovery (and Conformance Checking)
Infer architecture from code or runtime artifacts. Useful for legacy understanding, onboarding, review, and drift detection. Often paired with conformance checking.

### Why recovery is hard
Many implementations realize the same architecture. Code mixes architectural intent with low-level detail. Architectural boundaries may be implicit. Recovery gets easier when frameworks, configuration, and naming conventions carry architectural meaning.

### Artifacts that help
Module/package dependency structure, DI + startup config, API definitions/gateways/service contracts, event topics + subscriptions + deployment manifests, runtime topology + telemetry + CI architecture rules.

### Case study: ROSDiscover (Schmerl & Garlan)
Three observations about ROS:
1. ROS API calls have well-understood architectural semantics (publish/advertise/subscribe).
2. Composition is done via a launch file.
3. Heavy reuse of a small core library with most of the complexity.

Approach:
- **Component model recovery**: flow-sensitive static analysis over architecture-defining API calls (needed to resolve function arguments and `getParam` lookups into concrete topic names).
- **System architecture composition**: recursively traverse launch files (which define nodes, connections, parameter remaps, conditional instantiation) to compose the C&C architecture from the recovered component models.
- **Run-time architecture**: multiple component-model instances make up the runtime architecture.

For realistic systems, static recovery is never complete — developers provide hand-written models for dynamic core components.

**Results**: 29 misconfiguration bugs found across 5 real-world ROS systems; can check design vs. implementation.
**Limits**: plugins / dynamically loaded code excluded; relies on strict conventions and API uses; may still be too low-level.

See `slides/L25 - Closing Architecture and Code Gap.pdf` p.41–48 for the ROSDiscover pipeline and Autorally extracted architecture.

## Complementary, Not Mutually Exclusive
Architects in practice should:
- Make major responsibilities and connector types visible in code.
- Centralize composition and wiring where possible.
- Hoist repeated quality-sensitive concerns into shared mechanisms.
- Choose frameworks/platforms whose APIs expose architectural roles — but don't shirk responsibility; hoisting is still needed.
- Add recovery or conformance checks where architectural drift is costly.

## Key Tradeoffs
- **Evident coding** helps comprehension, not enforcement.
- **Hoisting** gives consistency but pushes new burden (e.g., graceful degradation) onto developers and requires incentives to adopt.
- **Model-based** gives strong arch↔impl alignment but binds you to the modeling language + generator.
- **Recovery** helps brownfield systems but is always partial, especially with dynamic code.
