# Lecture 10: Tactics for Availability and Performance

## Objectives
- Discuss the role of tactics in architecture design
- Explore tactics for availability and performance
- Introduce the refinement pipeline: QAS → Failure → Fault Model → Tactics → Architectural Refinement

## Key Concepts

### Tactics
A **tactic** is a design decision that refines an architecture (within a style) and is influential in controlling a quality attribute response. Tactics complement and refine styles.

Picking a style alone doesn't solve all QA problems. Achievement of QAs requires detailed design choices **within** the style.

### The Refinement Pipeline
**QAS → Failure → Fault Model → Tactics → Architectural Refinement**
1. QAS specifies the quality attribute requirement
2. Failure indicates how the requirement might not be satisfied
3. Fault model determines possible causes of that failure
4. Tactics address the faults
5. Architecture is refined by applying the tactics

## Availability Tactics

### Terminology
- **Fault:** A defect in software or hardware (may or may not be executed)
- **Error:** Execution of a fault resulting in incorrect output (may or may not cause failure)
- **Failure:** Deviation of system from specified behavior
- Chain: Fault → Error → Failure

### Fault Models
- **Bottom-up (FMEA):** What happens if a fault occurs? Enumerate faults, explore consequences forward.
- **Top-down (FTA):** What could cause a failure? Start from failures, work backward to faults.

### Availability Tactic Categories

**Fault Detection:**
- **Ping/echo:** Issue ping, expect echo within predefined time
- **Heartbeat:** Periodic message from monitored component
- **Exception:** Detect fault when service is actually needed

**Fault Recovery (Preparation & Repair):**
- **Voting:** Redundant processes compute in parallel; voter selects result
- **Active redundancy:** Redundant elements respond to events in parallel
- **Passive redundancy:** Primary responds; informs standby of state updates
- **Spare:** Standby platform configured to replace failed components

**Fault Recovery (Reintroduction):**
- **Shadow operation:** Run previously-failed element in shadow mode before returning to service
- **State re-synchronization:** Save state periodically; use to re-sync failed elements
- **Checkpoint/rollback:** Record consistent state periodically or on specific events

**Fault Prevention:**
- **Removal from service:** Take element offline for preventive maintenance
- **Process monitor:** Monitor critical elements; remove and re-instantiate on failure
- **Transactions:** Bundle sequential steps so entire bundle can be undone atomically

## Performance Tactics

### Performance Dimensions
- **Latency:** Delay between input and desired result
- **Throughput:** Tasks executed per unit time
- **Predictability (jitter):** Variation between executions
- **Resource utilization:** Effective use of network, CPU, memory, power

### Performance Tactic Categories

**Control Resource Demand:**
- Increase computational efficiency
- Reduce computational overhead
- Manage event rate
- Control frequency of sampling

**Manage Resources:**
- Introduce concurrency
- Maintain multiple copies of computation/data
- Increase available resources
- Schedule resources (scheduling policy)

## Additional Tactics (Introduced)

### Modifiability Tactics
- **Localize changes:** semantic coherence, anticipate changes, generalize modules
- **Prevent ripple effects:** information hiding, maintain interfaces, restrict communication, use intermediaries
- **Defer binding time:** runtime registration, config files, polymorphism, component replacement

### Security Tactics
- **Resist attacks:** authenticate, authorize, maintain confidentiality/integrity, limit exposure/access
- **Detect attacks:** intrusion detection
- **Recover from attacks:** audit trail + availability tactics for restoration

## Modern Cloud-Native Equivalents
| Classic Term | Modern Term |
|---|---|
| Active redundancy | Active-active replication |
| Passive redundancy | Active-passive failover |
| Ping/echo | Health check |
| Heartbeat | Liveness probe |
| Process monitor | Supervisor / sidecar |
| Removal from service | Rolling update / draining |
| Voting | Quorum / consensus (Paxos/Raft) |
| Transactions | Saga pattern |
| Maintain multiple copies | Replication / caching |
| Increase resources | Autoscaling |

## Key Tradeoffs
- Different tactics accomplish the same effect but with different tradeoffs
- Choosing between detection tactics: ping/echo (active polling) vs heartbeat (passive listening) vs exception (lazy)
- Active vs passive redundancy: cost of maintaining state vs recovery time
- Performance vs other QAs: caching improves performance but complicates consistency
