# Architecture Drivers Summary

This document outlines the requirements that constrain and shape architectural decisions in software systems. These requirements, known as **Architecture Drivers**, serve as the first step in creating a path of traceability from initial requirements to final design.

---

## 1. Categories of Architecture Drivers

Architecture drivers are divided into three primary categories:

- **Functional Requirements:** Descriptions of what services a system must perform and its core functions from a user's perspective.
- **Constraints:** Business and design decisions already made that are outside the architect's control and cannot be easily changed.
- **Quality Attributes (QAs):** Characteristics the system must possess in addition to its functionality, such as performance or security.

---

## 2. Constraints

Constraints represent the "direct" and "indirect" factors that limit the design space.

### Category Examples

- **Technical:** Mandated technologies, integration with legacy systems, specific APIs, and protocols.
- **Business:** Time-to-market, budget, available workforce expertise, and the projected lifetime of the system.

> **Note:** In practice, constraints may need negotiation if they are arbitrary, inherited without thought, or impose too many restrictions.

---

## 3. Quality Attributes (QAs)

Quality attributes define the system's "non-functional" properties. They must be designed into the system early; they cannot be added later at low cost.

### Key Quality Attributes

- **Availability:** Focuses on system failure, its consequences, and recovery time.
- **Modifiability:** Concerns the ease and cost of accommodating changes to the software.
- **Performance:** Focuses on timing and how long it takes a system to respond to an event.
- **Security:** Measures the system's ability to resist unauthorized use while maintaining access for legitimate users.

### Architectural Tradeoffs

Architectural choices determine system structure. A change that improves one quality attribute often inhibits another—for example, increasing security might decrease performance (response time).

---

## 4. Quality Attribute Scenarios

Because quality attributes can be vague (e.g., "the system shall be modifiable"), architects use **Quality Attribute Scenarios** to specify requirements clearly. A scenario is a short story describing a system's response to a specific stimulus.

### The Six Parts of a Scenario

1. **Stimulus:** A condition affecting the system.  
2. **Source of Stimulus:** The entity generating the stimulus.  
3. **Environment:** The context/conditions under which the stimulus occurs (e.g., peak load).  
4. **Artifact Stimulated:** The specific part of the system affected.  
5. **Response:** The activity resulting from the stimulus.  
6. **Response Measure:** The criteria used to evaluate the response (e.g., latency within 0.5 seconds).

---

## Summary of Key Themes

- **Structure Matters:** Systems are structured specifically to achieve quality attributes alongside functionality.
- **Traceability:** Drivers preserve the "chain of intentionality" from business goals to technical design.
- **Measurability:** Using scenarios allows architects to measure the success, completion, and conformance of the design.