# Lecture 15: Case Studies — EweToob and Kubernetes

## Objectives
- Identify architecturally significant requirements in a new system
- Use architectural styles to structure a design
- Recognize tactics for scalability and performance
- Understand how platform architecture (Kubernetes) supports quality attributes

## Case Study: EweToob (Video Streaming Platform)

### Requirements
**Video Streaming by Users:**
- Start quickly, minimize buffering
- Adapt to changing network conditions
- Support many concurrent users (100s millions daily)

**Upload by Content Providers:**
- Complete reliability (no data loss)
- Scale to millions of daily uploads
- 2.5-3 million uploads daily; billions of stored videos

### Constraints
- Many device types
- Network bandwidth varies significantly
- Videos are large media files

### Quality Attributes
- **Performance**: Fast startup, minimal buffering
- **Scalability**: Millions of concurrent viewers
- **Durability**: Uploaded videos must not be lost
- **Throughput**: Millions of uploads per day
- **Adaptability**: Changing network conditions
- **Availability**: Videos always playable

### Architecture

**Upload Pipeline (Dataflow style):**
Content Provider → Authenticated HTTP Post → Upload Service → Message Queue → Transcoding (720p, 480p, 1080p, 4K) → DB Write → Video Database

**Tactics for partial failures in upload pipeline:**
- **Intermediate persistence (checkpointing)**: Persist intermediate artifacts between stages; failed stages restart without repeating earlier work
- **Independent processing pipelines**: Subtitles, translations, moderation, transcode, chapters, thumbnails run independently

**Streaming (3-Tiered Client-Server):**
Viewer UI → HTTP Get → View Video Service → DB Read → Video Database

**Tactics for streaming performance:**
- **CDN (Content Distribution Network)**: Cache videos at points of presence (PoP) closer to viewers
- **Video segmenting**: Divide video into ~4-second segments
- **DASH protocol**: Client monitors bandwidth and switches segment resolution adaptively — limits pixelation, enables fast startup

### Deployment View
See `slides/L15 - Case Studies_EweToob_Kubernetes.pdf` p.16 for the full adaptability architecture with DASH client, CDN, and multi-resolution segments

## Kubernetes as Platform Architecture

### What Kubernetes Provides
Architectural support for: deployment, scheduling workloads, restarting failed components, recovery

### Component Architecture
- **API Server**: Central interface — all configuration changes go through it
- **etcd**: Distributed key-value store holding desired configuration state
- **Scheduler**: Decides where workloads run
- **Controller Manager**: Compares desired state to actual state; starts nodes to achieve desired state
- **Nodes**: Run Kubelet agent + application Pods

See `slides/L15 - Case Studies_EweToob_Kubernetes.pdf` p.20 for Kubernetes component diagram

### Mapping to EweToob
| EweToob Need | Kubernetes Support |
|---|---|
| Many transcoders | Replica management |
| Partial failures | Restart after fail |
| Parallel pipelines | Scheduler + Pods |
| Scale | Horizontal scaling |

### Platform and Tactics
Kubernetes realizes several tactics:
- **Performance**: Maintain multiple copies of computation, increase resources, schedule resources
- **Availability**: Restart failed components, maintain service continuity

### Application vs Platform Architecture
- **Application architecture**: Functional decomposition, connectors, data flow, application-specific QAs
- **Platform architecture**: Pods on K8s nodes, managed by control plane

Separating these concerns simplifies reasoning and prevents platform details from obscuring system structure. **Multiple views in architecture are essential.**

## Key Tradeoffs
- Reasoning chain: Drivers → Styles → Tradeoffs → Tactics → Platform Support
- Dataflow for upload: Good throughput via parallelism, stages scale independently; but pipeline bottlenecks and partial failure coordination
- 3-tiered for streaming: Separation of concerns, scalable app tier; but high bandwidth demands, network latency sensitivity
- CDN: Improves latency and availability; but cache invalidation and storage costs
- DASH: Adapts to network conditions; but adds client complexity
- Platform choice may force tactical choices on you
- **Don't start with technologies** — start with drivers
