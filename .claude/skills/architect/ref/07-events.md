# Lecture 07: Event-based Styles

## Objectives
- Examine event-based architecture styles: what they are, pros/cons, examples, issues

## Key Concepts

### Event-based Systems
Loosely coupled components with asynchronous communication:
- Components run as independent entities, communicate through events
- An event may have zero, one, or multiple receivers
- Components do not depend on others for correctness (but may depend on receiving appropriate events)
- Similar to pipe-and-filter, but different from call-return

### Event-based Elements
- **Components**: Independent entities (processes, threads, or objects) with two port types:
  - **Publish ports**: outgoing events
  - **Subscribe ports**: incoming events to receive
- **Connectors**: Publish-subscribe coordination — guarantees all subscribers receive announced events; delivery order among multiple subscribers is unspecified

### Event-based vs Dataflow
| Aspect | Dataflow | Event-based |
|---|---|---|
| Communication | Binary | Many-to-many |
| Trigger | Data arrival → transformation | Event arrival → arbitrary computation |
| End-to-end | Functional (deterministic) | Nondeterministic |
| Coupling | Loose | Loose |
| Concurrency | Allowed | Allowed |

### Two Main Subclasses
1. **Pure event systems**: Events simply forwarded to receivers; each receiver decides what to do; typically maintain local queues
2. **Implicit invocation systems**: Subscribers register procedures invoked when a certain event type is announced (like callbacks)

### Implicit vs Explicit Invocation
- **Explicit invocation**: Direct dependencies between objects (call-return)
- **Implicit invocation**: Components register with event space; good modifiability (easy to add new objects) but harder control and potential performance bottleneck

### Server-Sent Events (SSE)
- Server initiates one-way stream of updates to client over HTTP
- Unlike WebSockets (full-duplex), SSE is one-way: server sends, client receives
- Suited for: live news feeds, stock prices, sports scores, real-time dashboards

## Examples
- MVC (Smalltalk-80): Model announces "Changed" event → Views register "Update" procedures
- Programming environments: Editor → Finished event → Compiler → Compile event → Debugger
- Data-triggered environments: Database change events trigger daemon procedures
- Cyclic tasks polling shared data variables
- Ozone Widget Framework (OWF): Cross-domain widget communication via pub-sub channels
- ROS (Robot Operating System): Events organized by "topic"; components publish/subscribe to topics
- Mars Pathfinder: Each subsystem has a queue of incoming events/messages

## Key Tradeoffs
**Reasons to choose event-based:**
- Components are more independent (better modifiability)
- Dynamic reconfiguration relatively easy
- Reuse by simply subscribing to events
- Parallel handling possible (performance)

**Reasons NOT to choose event-based:**
- No control over delivery sequencing → nondeterminism
- Hard to test and debug; can lead to event "spaghetti"
- Needs central management for events, registrations, delivery policies
- Message bus overhead; no real-time guarantees
- Inefficient for large data between components

**QAs that may be difficult:**
- **Security/Privacy**: Controlling who sees events, who can announce
- **Timing**: Hard to control, important for real-time (e.g., robotics)
- **Resources**: Event queues may require large storage
- **Availability**: Monitoring easy, but recovery difficult without central control
