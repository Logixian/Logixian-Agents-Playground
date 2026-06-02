# Lecture 08: Call-Return Styles

## Objectives
- Understand call-return as a family of styles, not a single mechanism
- Explain how control-driven coordination differs from dataflow and event-based
- Analyze how connector semantics affect architectural reasoning
- Recognize when semantic changes within call-return are architectural changes

## Key Concepts

### Call-Return Systems
System processing built around a model of **requests for services**:
- **Components**: Service requesters/providers
- **Connectors**: Primarily binary call-return
- Thread of control follows service invocations
- Callers know the services they are calling
- Correctness of caller usually depends on correctness of service

### What Drives Computation (Style Comparison)
| Style | Driver |
|---|---|
| Dataflow | Data availability |
| Call-return | Explicit control transfer |
| Event-based | Event occurrence |
| Data-centered | Shared state |

### Call-Return History
1950s: Callable units → 1960s: Separate compilation → 1970s: ADTs, layers → 1980s: Objects → 1990s: Distributed components, middleware → 2000s: SOA → 2010s: Microservices → 2020s: Serverless, agents

### Problems with Program-Level Call-Return as Architecture
- Managing many objects/calls (vast sea of interactions)
- Single interface can be limiting
- Distributed responsibility for behavior (hard to understand)
- Capturing families of related designs
- Solution: Use tiers & middleware to factor out common code

## Styles/Tactics/Patterns

### Client-Server
- **Types**: Client and server components; asymmetric call-return connectors
- **Constraints**: Clients initiate all actions; clients must know server identity; servers don't know clients in advance
- **Properties**: Sync/async connectors, dynamic clients/servers, sessions, middleware
- **Qualities**: Modifiability (service changes), scalability/availability (replication), dependability, security, performance
- **Specialization**: N-tier (servers can be clients of other servers)

### Service-Oriented Architecture (SOA)
- Collection of distributed services that can be combined, often owned by different companies
- **Types**: Service providers, consumers, registry, orchestration; ESB connectors
- **Constraints**: Intermediaries between consumers/providers; SOAP/REST standards
- **Qualities**: Interoperability, legacy integration, dynamic reconfiguration through indirection
- **Differentiator from client-server**: Separate control component, ESB mediation, multi-company ownership, registry for late binding

### Peer-to-Peer
- **Types**: Peer components (both client and server); symmetric call-return
- **Constraints**: Components are both clients and servers; may impose visibility restrictions
- **Qualities**: Enhanced availability and scalability, high distribution
- **Challenges**: Distributed control complicates reasoning; failure propagation; trust/correctness hard to verify; NAT traversal; protocol design dominates

### Connector Semantics
Call-return connectors are more complex than simple lines. Key dimensions:

| Dimension | Options |
|---|---|
| **Mode** | Synchronous (caller blocks) vs Asynchronous (caller continues; callbacks/promises/futures) |
| **Symmetry** | Asymmetric (client/server) vs Symmetric (either party calls) |
| **Location** | Local (co-located) vs Remote (RMI, REST, HTTP) |
| **Tactics** | Security (encrypted, authenticated), Availability (retries, redundancy), Logging, Brokering |

**Key point**: Connectors own control, failure, and data semantics. "Data flow" via parameters is NOT the same as a dataflow connector (pipe).

### Call-Return Perspectives
- **Static**: "uses" or "depends-on" relations between code structures (modules, layers, classes)
- **Dynamic**: Call-return as runtime service calls between components
- Sometimes close correspondence; sometimes not (e.g., one module → multiple runtime components)

## Examples
- Ride-hailing system: Mobile apps → REST → Trip Management → gRPC → internal services
- Health system SOA: Patient services, clinician UI, pharmacy orders, billing via ESB + registry
- Multiplayer game P2P: Symmetric roles, state/action/tick-step calls; matchmaking via separate service
- ROS Services: ROS 1 synchronous (short operations); ROS 2 asynchronous (promises) — same style, changed connector semantics, forces client restructuring
- ROS Actions: Complex call-return for long-running operations (navigation, manipulation); support progress, cancellation, feedback

## Key Tradeoffs
- **Use call-return when**: Components require responses; features have distinct steps; decomposition with explicit control ordering; parallels common programming languages
- **Avoid call-return when**: Large information exchange (use dataflow); high flexibility needed (events may be better); lots of nondeterministic initiation
- Changing call-return connector semantics (sync→async) can force architectural change even when style stays the same
- Call-return is a design space: same style, different semantics → different reasoning models → different QA tradeoffs
