# Lecture 14: Case Studies — ROS and Duolingo

## Objectives
- Read real systems architecturally
- Identify QA effects on architecture
- See tradeoffs and consequences

## Key Concepts

### Discipline for Reading Architecture
For each system, identify:
1. Primary Quality Attribute Drivers
2. Dominant Styles
3. Key Tactics
4. Architectural Consequences
5. Tradeoffs

## Case Study 1: ROS (Robot Operating System)

### Drivers
**Constraints:**
- Development by different research groups
- Write once, use on any robot
- Multi-processing and multiprocessor support
- Distribute between compute-impoverished robots and powerful hardware
- C++ and Python support; commodity hardware on Linux

**Quality Attributes:**
- Extensibility: New processing, hardware, research
- Plugability/Reuse: Use others' components without code changes
- Performance: Real-time sensing-to-actuation loop
- Reliability: Critical nodes running continuously
- Simulatability: Same code in simulation and on robot
- Buildability: Easily built on different machines

### Architecture
**Dominant Style**: Event-based (Publish-Subscribe)
- Enhances extensibility, plugability, reuse
- Components developed separately with agreed-upon messages

**Structural Elements**: Nodes (independent processes), Topics (named message channels), Publishers/Subscribers, ROS Master (discovery/coordination)

### Tactics Applied
**Reliability (Availability):**
- ROS Master monitors/restarts nodes
- Detection via exception handling (process crash)
- Recovery via rollback (restart) — works because transient errors dominate research software

**Performance:**
- Buffer events for subscribers (manage event rate)
- **Nodelets**: Multiple nodelets in single NodeletManager process; in-memory pass-by-reference for large data (e.g., video at 60/120Hz)
  - Consequence: Co-location constraints, shared memory tradeoffs, API complexity

**Other tactics:**
- Simulatability: Centralize time/date into ROS
- Buildability: Standardize build around catkin
- Performance: Separate service connector for short call-response
- Configurability: ROS Master stores/serves parameters dynamically

### ROS 1 → ROS 2 Evolution
New pressures: Security/privacy, large-scale multi-robotics, industrial deployment
- No centralized ROS Master
- DDS-based event system with built-in authentication, authorization, reliability, liveness detection

### ROS Architecture Lessons
1. Drivers determine style
2. Tactics reshape structure
3. Performance optimizations introduce coupling
4. Frameworks encode policy
5. When drivers change, architecture must change

## Case Study 2: Duolingo Superbowl Ad

### Problem
Send 4 million push notifications within 5 seconds of a Superbowl ad airing (normal rate: 10,000/sec → need 800,000/sec = 80x faster).

### Constraints
- Live event, exact timing unknown
- One chance
- Must use iOS/Google Play notification systems
- App calls back into servers when notified (potential self-DDoS)
- Normal Duolingo service must continue working

### Quality Attributes
- **Scale/Throughput**: 4M notifications in 5 seconds
- **Timeliness**: Resources available in time but not idle
- **Testability**: Must be testable before Superbowl
- **Isolation**: Failure containment from core system

### Architecture: "Superb Owl" Service
Event-based architecture layered with explicit scaling and containment tactics:

1. **Create campaign**: Engineer creates campaign with user IDs → fetch device data from DynamoDB → upload to S3
2. **Prepare send**: Scale up ASG and ECS workers → workers fetch data from S3 into memory → log "complete"
3. **Go!**: API server dispatches to FIFO SQS → 20x Interim Workers dispatch 10k+ SQS messages → 5000x Notification Workers send to APNS/FCM

### Tactics
- **Tiered scaling**: Staged fanout via SQS message queues
- **Caching**: Pre-load userId→deviceId mappings in worker memory
- **Pre-provisioning**: Scale up infrastructure before event
- **Isolation**: Separate service from core Duolingo

### Testability
Tested at increasing scales: Halloween (100K) → Thanksgiving (1M) → New Year (4M) → Superbowl (4M)

### Duolingo Lessons
1. Not all scalability is the same
2. Isolate extreme scenarios from core system
3. Structure the spike — don't just absorb it
4. Tactics introduce operational complexity
5. Architecture reflected existing event-based notification style

## Key Tradeoffs
- ROS: Long-lived evolving platform; extensibility and real-time performance are primary drivers; pub/sub as primary style; nodelets trade API simplicity for performance
- Duolingo: Time-bounded extreme event; burst scalability and isolation are primary; queue-based staged fanout; tactics reshape operations (scaling, caching, worker tiers)
- Architecture is: a response to forces, a set of constrained tradeoffs, a commitment to a structure
