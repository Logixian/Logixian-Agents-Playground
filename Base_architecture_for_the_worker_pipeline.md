# Base architecture for the worker pipeline.

The Whitelisted URLs database satisfies FR-1. Note that the whitelisted URLs database's input are not specified, the input method is assumed to be out of scope for the pipeline's design.

Only the bundle processor is able to write into the databases. The rationale for this is the reliability constraint and FR-8: we don't want anything to be written into append-only databases which cannot be rolled back. FR-2 and FR-3 motivate the writing that this module does, allowing snapshot saving and rules bundle production. In particular, the websites metadata database allows exposing a S3 URI along the canonical URL, while also storing time of fetching and other relevant metadata that might exist. In particular, FR-2's required display is achieved by fetching the canonical URL obtained in the audit trail and augmenting it with the information in the websites metadata database.

FR-4 and FR-11 motivate the existence of the trigger component that creates instances of the pipeline. The pipeline creation should take as few parameters as possible, so that maintainance ease is not compromised. Ideally, only the name of the state should be passed to the pipeline. Instead, "parameters" should be passed through the whitelisted URLs database, or similar solutions. This would also enable non-technical members of IRALOGIX's team to modify the pipeline's behavior without messing around with the component's interfaces.

The process listener is there to satisfy FR-9 and FR-10, as well as the observability quality attribute. The system health listener ensures that no process fails silently (asserting that the pipeline is still running, even if a catastrophic crash caused the system to fail without notice), and the LLM logger helps satisfy FR-5 and FR-10.

It is important to notice that the LLM logger acts as an intermediary between Claude Code (the interface+tool usage) and the provider (Bedrock). This is on purpose, so that every call can be logged appropriately and transparently. In practice, this is achieved by a prebuilt solution, such as Datadog's Agent Observability. Both this logger and the system logger require a sidecar, that works independently from the main process. This sidecar can either be a proper sidecar or enclose the pipeline (i.e. the pipeline is a virtual machine _inside_ the logger machine.)

The Accuracy quality attribute and FR-5 cannot be achieved through architectural means, so they will depend on the verification functionality of the system (out of scope for this component.) In particular, that component shouldn't allow agent activity for reviewing.

The comparison with previous sources is there for Cost Efficiency, short-circuiting updates if no new rules are likely to be inferred. However, if the user is confident that new rules can be fetched, there should be a trigger parameter that skips this. FR-1 in this schema is done by an LLM, and the crawling should be done "smartly", using their capabilities, to avoid lengthy processes and potential DDoSing our sources.

