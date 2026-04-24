# Lecture 19: Architecture Modeling and Analysis

> Garlan & Schmerl & Fairbanks, 25 March 2026

## Objectives

- Understand how formalism supports: precise specification of software architectures, definition of architectural styles, analyses of architectural designs
- Appreciate that "a little formalism can go a long way" -- deep mathematics not required

## Key Concepts

### Notation Spectrum

| Level | Example | Strengths | Weaknesses |
|-------|---------|-----------|------------|
| **Informal** | Boxes and lines | Accessible, flexible | No analytic capability, no enforcement |
| **Semi-formal** | UML | General-purpose, widely known | Needs careful tailoring to architecture context |
| **Formal** | Alloy, Acme (ADLs) | Analytic leverage, insight, tool support | Learning curve, investment |

An **Architecture Description Language (ADL)** is a formal notation specialized for architecture (e.g., Acme, Wright).

### Issues Addressed by Architectural Design

- Decomposition into interacting components
- Types of communication between components
- Emergent system properties and quality attributes
- Rationale and assignment of function to components
- Envelope of allowed change

### The Challenge

Establish intellectual control by:
- Expressing architectural descriptions precisely and intuitively
- Providing configuration correctness criteria and tools
- Analyzing designs for performance, reliability, etc.
- Exploiting patterns and styles
- Guaranteeing conformance between architecture and implementation

## Structural Modeling in Acme

Acme models C&C views using five core constructs:

| Construct | Role |
|-----------|------|
| **System** | Top-level container |
| **Component** | Computational element (client, server, filter) |
| **Connector** | Interaction mechanism (RPC, pipe) |
| **Port** | Component interface point |
| **Role** | Connector interface point |
| **Attachment** | Binds a port to a role |

### Example: Simple Client-Server

```
System simple-cs = {
  Component client = { port call-rpc; };
  Component server = { port rpc-request; };
  Connector rpc = { role client-side; role server-side; };
  Attachments = {
    client.call-rpc to rpc.client-side;
    server.rpc-request to rpc.server-side;
  }
}
```

### Properties

Structure is annotated with **properties** for quality attributes, behavior, interface details:
- `Property sync-requests : boolean = true;`
- `Property max-transactions-per-sec : int = 5;`
- `Property protocol : string = "aix-rpc";`

Properties enable tool-based analysis: schedulability, performance, security simulation.

## Behavioral Modeling (Wright)

Wright uses **CSP** (Communicating Sequential Processes) to specify behavior as protocols.

### Primitives

| Construct | Meaning |
|-----------|---------|
| `e -> P` | Sequence: event `e` then process `P` |
| `P ; Q` | Sequential composition |
| `P ⊓ Q` | Internal (non-deterministic) choice |
| `P [] Q` | External (deterministic) choice |
| `P \|\| Q` | Parallel composition |
| `§` | Successfully terminated process |

### Connector Protocols

Each connector defines:
- **Role** protocols (one per endpoint): what each participant may do
- **Glue**: how roles are coordinated

#### Example: Pipe Connector

```
Connector Pipe
  Role Writer = (write!x -> Writer) ⊓ (close -> §)
  Role Reader = Read ⊓ Exit
    where Read = (read?x -> Reader) [] (eof -> Exit)
          Exit = close -> §
  Glue = Writer.write?x -> Glue []
         Reader.read!y -> Glue []
         Writer.close -> ReadOnly []
         Reader.close -> WriteOnly
    where WriteOnly = Writer.write?x -> WriteOnly [] Writer.close -> §
      and ReadOnly  = Reader.read!y -> ReadOnly
                      [] Reader.eof -> Reader.close -> §
                      [] Reader.close -> §
```

#### Example: Client-Server Connector

```
Connector ClientServer
  Role Client = open -> Operate ⊓ §
    where Operate = request -> result?x -> Operate ⊓ close -> §
  Role Server = open -> Operate [] §
    where Operate = request -> result!x -> Operate [] close -> §
  Glue = Client.open -> Server.open -> Glue
         [] Client.close -> Server.close -> Glue
         [] Client.request -> Server.request -> Glue
         [] Server.result?x -> Client.result!x -> Glue
         [] §
```

### Component Specifications

Components define **port** protocols and an overall **Computation**:

```
Component ReadOneFilter =
  Port ReadOne = (read -> close -> §) ⊓ (close -> §)
  Port WriteOne = write -> close -> §
  Computation = ...
```

## Formal Analysis

### Three Key Properties

| Property | What It Checks | How |
|----------|---------------|-----|
| **Consistency** | Connector is deadlock-free; roles don't conflict with glue; component ports are projections of computation | Model checking (FDR) |
| **Compatibility** | Port satisfies the requirements of the role it attaches to (port refines role); instance obeys style constraints | Refinement checking |
| **Completeness** | Every port that requires a connection is attached | Structural check |

### Consistency Example: SharedData Deadlock

```
Connector SharedData
  Role User1 = (set -> User1) ⊓ (get -> User1) ⊓ §
  Role User2 = (set -> User2) ⊓ (get -> User2) ⊓ §
  Glue = User1.set -> Continue [] User2.set -> Continue [] §
    where Continue = User1.set -> Continue [] User2.set -> Continue
                     [] User1.get -> Continue [] User2.get -> Continue [] §
```

Deadlock occurs when both users internally choose `get` initially -- glue only offers `set` events first.

### Compatibility Example

- **Compatible**: `Port P = (push -> P) ⊓ §` with `Role R = (push -> R) ⊓ (pop -> R) ⊓ §` -- port only uses a subset of role's events
- **Incompatible**: same port with `Role R = init -> R'` -- role requires `init` first, which port never provides

## Styles as Families

Acme's **Family** construct defines architectural styles as type systems:

```
Family PipeFilterFam = {
  Component Type filterT = { Ports {In, Out}; ... };
  Connector Type pipeT = {
    Role Reader = { Property datatype = ...; };
    Role Writer = { Property datatype = ...; };
    Invariant self.Reader.datatype = self.Writer.datatype;
  ...}
}
System myPF-System : PipeFilterFam = { ... }
```

Families provide:
- Component and connector **types** (vocabulary)
- **Properties** of interest and shared analyses
- **Invariants/constraints** as first-order predicates over structure and properties
- Style conformance checking

## Case Studies

### NASA MDS (Mission Data System)

- Architectural framework for NASA space systems
- 8 component types (sensor, actuator, estimator...), 12 connector types
- 10 rules from MDS designers encoded as **38 checkable Acme predicates**
- AcmeStudio (Eclipse-based) for graphical editing and constraint checking
- Example rule: "For any Sensor, #MeasurementNotification ports == #MeasurementQuery ports"

> See `slides/L18 - Modeling and Analysis.pdf` p.33-42

### HLA Distributed Simulation

- Multi-billion dollar DoD industry; ~250-page standard defining API for federate interoperability
- Architecture: Federates with SimInterfaces communicating via Runtime Infrastructure (RTI)
- Wright/FDR analysis found **87 issues**: 28 ambiguities, 12 inadequate pre/post-conditions, 20 missing info, 5 race conditions, 11 errors, 11 misc
- Example race condition: Pause-on-Join scenario where late-joining federate creates scheduling conflict

> See `slides/L18 - Modeling and Analysis.pdf` p.46-51

### Android App Extraction

- Reverse-architecting Android apps into Acme component/connector models
- Automated extraction of architectural structure from code

> See `slides/L18 - Modeling and Analysis.pdf` p.42-43

### Cyber-Physical Building Control

- Thermal dynamics + distributed cyber system
- Simulink/Stateflow model translated to FSP/LTSA for behavioral analysis
- Thermostat hysteresis (hot/cold states) to reduce chattering

> See `slides/L18 - Modeling and Analysis.pdf` p.52-57

### Other Examples

- **F-prime**: NASA framework for small space missions; modeled in Acme, compiles implementations from architectural spec
- **Data analytics pipelines**: Mismatch repair using Alloy + Acme
- **ROS**: Reverse architecting and behavioral analysis tools

## Key Tradeoffs

| Tradeoff | Discussion |
|----------|-----------|
| Formality vs. accessibility | Formal notations enable analysis but require investment; informal notations are accessible but lack analytic power |
| Precision vs. cost | A little formalism goes a long way; full formalization is rarely needed |
| Style constraints vs. flexibility | Families enforce design rules but constrain what architects can express |
| Behavioral specification vs. effort | Wright protocols catch real bugs (87 in HLA) but require CSP expertise |

## Session Summary

Formal modeling and analysis of software architectures can effectively:
1. **Clarify design intent** -- precise representation of structure and properties
2. **Support analysis** -- behavior, extra-functional properties, design rule satisfaction, mismatch repair
3. **Support code generation** -- within specific domains
