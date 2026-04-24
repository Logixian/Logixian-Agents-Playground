# Lecture 06: Dataflow Styles

## Objectives
- Examine dataflow architecture styles: what they're good/bad for, examples, implementation issues

## Key Concepts

### Dataflow Systems
A dataflow system is one in which:
- Structure is determined by movement of data between elements
- Data availability controls computation
- Pattern of data flow is explicit
- Data flow is the **only** form of communication between components

### Dataflow Elements
- **Components**: Data transformers with input/output ports; read data → compute → write data
- **Connectors**: Data transmission — binary, unidirectional, data order-preserving

### What Dataflow is NOT
- Function calls passing parameters (that's call-return)
- Shared data repository access
- Explicit control over sequencing — control is implicit in data availability

### Variations
Distinguished by: component shape (port restrictions), data nature (format, type, terminating), concurrency degree, incremental computation degree, topological restrictions (cycles allowed?)

## Styles/Tactics/Patterns

### Batch Sequential
- **Semantics**: Input data transformed sequentially and completely at each step; no concurrency; process starts when input available, stops when processing complete
- **Components**: Independent transformational units
- **Connectors**: Data files (historically magnetic tape)
- **Promotes**: Simplicity, reuse (component correctness independent of others), modifiability (easy reconfiguration via "plumbing")
- **Inhibits**: Performance (high latency), interactivity, error handling

### Pipe-and-Filter
- **Semantics**: Incremental transformation of streams; filters are independent, share no state; concurrent execution possible when sufficient data available
- **Components (Filters)**: Stream-to-stream transformations (enrich, refine, transform); no state between instantiations; no knowledge of upstream/downstream
- **Connectors (Pipes)**: One-way, order-preserving, data-preserving
- **Promotes**: Simplicity, filter reuse, modifiability (late binding of connectors), compositional semantics (`output = h(g(f(input)))`)
- **Inhibits**: Performance, interactivity, error handling
- **Implementation variations**: How pipes implemented (OS vs library)? Sources/sinks active or passive? Cycles permitted? Concurrency model? Pipeline setup and teardown?

### Batch Sequential vs Pipe-and-Filter
| Aspect | Batch Sequential | Pipe-and-Filter |
|---|---|---|
| Granularity | Coarse | Fine |
| Latency | High | Low |
| Concurrency | None | Possible |
| Interactivity | Non-interactive | Non-interactive |
| Data processing | Entire at each step | Incremental |
| Control | Explicit orchestration | Data availability |

### Workflow and AI Pipelines
- Dataflow systems optimized for large-scale computing services/infrastructure
- Components organized in a graph; inputs are data stores/streams, outputs are displays/reports
- Often supported by ecosystem of component developers and reusable component repositories
- **Workflow = dataflow + orchestration + ecosystem**
- **Map-reduce**: Specializes workflow to fork and join (Hadoop, Spark)
- **AI pipelines**: Training and inference pipelines follow dataflow patterns

## Examples
- Classical data processing (payroll, tax returns)
- Early compilers (Text → Lex → Syn → Sem → Opt → Code)
- Telemetry data collection systems
- Apache web server (pipe-and-filter internally)
- Unix pipes (`cat /etc/passwd | grep "joe" | sort > junk`)
- Fraud detection pipeline
- Yahoo!Pipes (specialized for news feeds)
- eScience composition environments (LabView, Taverna, Loni Pipeline)
- GPT-3 / ChatGPT architecture

## Key Tradeoffs
- **Use dataflow when**: Application naturally decomposes into incremental transformations; need to process large data; frameworks support it; want easy reconfiguration; have reusable component library
- **Avoid dataflow when**: Highly interactive application needed; careful error handling required; resource constraints on buffering; frameworks don't support it
- **Tactics needed for**: Backpressure, partial failure, pipeline saturation
- Key QAs for workflow: end-to-end latency, cost/resources, repeatability/provenance, reliability
