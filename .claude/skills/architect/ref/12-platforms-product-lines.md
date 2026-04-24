# Lecture 12: Platforms, Frameworks, and Product Lines

## Objectives
- Examine style specializations for component integration and domain-specific frameworks
- Understand component integration platforms and their architectural commitments
- Understand product lines and their economics

## Key Concepts

### Style → Platform → Product Line Spectrum
- A **style** defines structural vocabulary and constraints
- A **platform** operationalizes and hardens those constraints
- A **product line** institutionalizes reuse on top of a platform

### The Integration Problem
Making components from different organizations work together is hard. Successful compilation is not enough — must also align: invocation orders, control locus assumptions, data representations, synchronization, discovery/naming, failure handling.

### Component Integration Standards
- Rules about component interfaces (structure, content, capabilities)
- Rules and infrastructure for connectors (legal interactions, API for communication)
- Naming/discovery conventions (name registry)
- Base of reusable assets and system generation tools

### Politics of Standards
- **De facto**: Imposed by vendor (COM, .NET)
- **Cooperative**: Defined by consortium/standards body (OMG/DCE, UML, HLA)

## Styles/Tactics/Patterns

### Call-Return Middleware Pattern
Client → IDL Compiler → Client-side glue | Server-side glue → Server
- Interface defined in neutral Interface Definition Language (IDL)
- Middleware handles communication protocol over TCP/IP

### Product Lines
Most products are similar to others built before/after. Companies achieve economies by:
1. Define common shared aspects
2. Provide reusable infrastructure for common aspects
3. Define how to instantiate the framework for a particular product

**Economics**: Higher initial cost, but cumulative cost drops below individual development after a few products. See `slides/L12 - Platforms _ Product Lines.pdf` p.33 for economics graph.

## Examples

### Case Study: HLA (High Level Architecture for Distributed Simulation)
- **Problem**: Combining different simulations into joint exercises; many vendors, different syntactic/semantic models
- **Architecture**: Event-based interaction; federates communicate via Runtime Infrastructure (RTI); SimInterface defines obligations
- **Result**: Became US DoD standard, then IEEE standard (1516-2010) and NATO standard (STANAG 4603)
- See `slides/L12 - Platforms _ Product Lines.pdf` p.16 for federation architecture

### Case Study: JavaPhone
- Specification for a layer enabling third-party telecom app integration
- Isolates applications from specific telecom platform details
- Defines APIs: Telephony (JTAPI), Power Monitor/Management, Network Datagram, SSL, Address Book, Calendar, User Profile, Install
- Different profiles (Wireless, Screenphone) require different API subsets
- See `slides/L12 - Platforms _ Product Lines.pdf` p.27 for architecture diagram

### Case Study: Tektronix Oscilloscopes
- **Problem**: Separate divisions, little sharing, build-from-scratch, 4-5 year time-to-market
- **Iterations**: OO decomposition (hundreds of classes, no structure) → Layered (unrealistic boundaries) → Pipe-filter (good model, unclear user input) → Parameterized pipe-filter with colored pipes (elegant AND implementable)
- **Result**: Framework cut time-to-market substantially, improved reliability, extensible UI, led to new frameworks beyond oscilloscopes

## Key Tradeoffs
- Platforms yield ecosystems whether designed explicitly or not
- Connectors are often the most important part of a framework — they determine the "glue"
- APIs are key but not sufficient — must also understand timing, protocols, coordination, error handling
- Conformance testing is a challenge for both component developers and infrastructure providers
- Product line frameworks: significant upfront investment pays off with scale (Cummins: 250 person-months → few person-months)
- Getting product-line architectures right is not trivial — requires iteration, domain expertise, willingness to abandon old patterns
