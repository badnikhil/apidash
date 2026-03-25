![GSOC 2026](images/gsoc_api.png)

# GSoC 2026 — API Dash Application

---

## About

1. **Full Name:** Himanshu Ravindra Iwanati
2. **Contact Info (public email):** work.himanshu.r.v@gmail.com +91 8329614201
3. **Discord Handle:** hihry
4. **GitHub Profile:** https://github.com/hihry
5. **LinkedIn / Other Socials:** https://www.linkedin.com/in/himanshu-iwanati-87459b282/
6. **Time Zone:** IST (UTC+5:30)
7. **Resume:** https://drive.google.com/file/d/1dMRQg-MAmrrDbJS8tTwCQR0SbrujODSG/view?usp=sharing

---

## University Info

1. **University Name:** Indian Institute of Technology, Kharagpur
2. **Program:** B.Tech, Department of Electrical Engineering
3. **Year:** 3rd Year
4. **Expected Graduation Date:** May 2027

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

- Yes. I have contributed to multiple open-source projects:

  Yes. My open-source contributions span bug fixes, feature implementations, test coverage, and feature proposals — primarily within the **API Dash** repository (`foss42/apidash`) over the past month, alongside prior work on **MoveIt2**.

- **MoveIt2** ([moveit/moveit2](https://github.com/moveit/moveit2)) — Contributed [PR #3543](https://github.com/moveit/moveit2/pull/3543): improved Doxygen documentation for `composeMultiArrayMessage` in the `moveit_servo` module (`common.cpp` and its header), clarifying parameters, return value, and usage for controllers that accept `std_msgs::msg::Float64MultiArray` messages. Reviewed and approved by two maintainers (`@sea-bass`, `@nbbrooks`) and merged into `main` on November 27, 2025.

**2. What is your one project/achievement that you are most proud of? Why?**

- Built a multi-agent system using **LangGraph** and **Pinecone** that routes user queries
  to the appropriate API, retrieves relevant context via vector search (RAG), and grades
  the retrieved documents using a `binary_score` node. If the score falls below a set
  threshold, the system automatically falls back to **Tavily** for live web search —
  keeping responses grounded and reducing hallucination risk. The pipeline is served via
  **FastAPI**. The key engineering insight was that cost and accuracy in agentic systems
  are best managed through explicit verification steps in the graph, not just prompt tuning.

**3. What kind of problems or challenges motivate you the most to solve them?**

- I am just curious how the world would look like after 5 years of AI, becuase in the last two years itself there is massive growth in the AI itself, solving many complex problems but creates a major issue of security and threat for the users using AI. The problems that AI causes like hallucination, reducings costs and the one of the major issue that is security, are the major problems that motivates me a lot and I thrive on problems that require creative and efficient solutions.

**4. Will you be working on GSoC full-time? If not, what else will you be studying or working on?**

 - Yes, I will be working full-time on GSoC. Occasionally, I may have exams, course projects, or job/internship responsibilities, but they will not impact my commitment to GSoC.

**5. Do you mind regularly syncing up with the project mentors?**

- Not at all — I actively welcome it, can attend calls and dicuss the idea and implementation furthur.

**6. What interests you the most about API Dash?**

- API dash has clean UI, very modular repository structure and The codebase is remarkably easy to navigate. We as developers can actually trace a request from the UI layer to the network layer without getting lost in a forest of nested folders.

**7. Can you mention some areas where the project can be improved?**

- **Agentic / AI Testing Layer:** No existing API client — open or commercial — offers a self-healing, spec-driven agentic testing framework natively. This is the central gap this proposal targets.
  **CI/CD Integration:** Structured JSON and JUnit-compatible report output would enable API Dash test suites to plug into standard CI pipelines, broadening adoption beyond interactive desktop use.

**8. Have you interacted with and helped the API Dash community?**

- Yes. My engagement includes:
  Active participation in the API Dash GitHub repository through issue discussions and code review commentary.

**API Dash — Bug Fixes & Code Quality (Merged / Approved)**

| PR | Description | Status |
|---|---|---|
| [#1146](https://github.com/foss42/apidash/pull/1146) | Fix typo: `occured` → `occurred` in `intro_message.dart` | ✅ Approved |
| [#1160](https://github.com/foss42/apidash/pull/1160) | Add tooltip labels to all four navigation rail `IconButton`s | ✅ Approved |


**API Dash — Feature PRs (Technical, Under Review)**

| PR | Description | Significance |
|---|---|---|
| [#1356](https://github.com/foss42/apidash/pull/1356) | Extend Postman Collection models with auth, urlencoded body, and collection variables — fixing silent data loss in the v2.1 importer | 
| [#1171](https://github.com/foss42/apidash/pull/1171) | `test: Add unit tests for import/export IO parsers` (Postman, cURL, HAR, Insomnia) | Addresses a gap in test coverage for the importer subsystem |
| [#1134](https://github.com/foss42/apidash/pull/1134) / [#1130](https://github.com/foss42/apidash/pull/1130) | `feat: Auto-generate meaningful names for imported cURL and HAR requests` | UX improvement for the import workflow |

**API Dash — Feature Issues (Proposals)**

Beyond code, I have actively proposed improvements that align with the project's roadmap:

| Issue | Proposal |
|---|---|
| [#1330](https://github.com/foss42/apidash/issues/1330) | `[FEATURE]: Enhance Postman Collection Importer` — broader follow-up to PR #1356 |
| [#1202](https://github.com/foss42/apidash/issues/1202) | `[Feature]: Enable Streaming Responses in DashBot` — SSE/chunked transfer support for the AI assistant |
| [#1180](https://github.com/foss42/apidash/issues/1180) | `[Feat]: AI-powered smart request suggestions based on URL pattern` |
| [#1170](https://github.com/foss42/apidash/issues/1170) | `test: Add unit tests for import/export IO parsers` — issue tracking test gap before submitting PR #1171 |
| [#1135](https://github.com/foss42/apidash/issues/1135) | `feat: Multi-select requests with bulk delete` (labelled `priority: low`) |
| [#1129](https://github.com/foss42/apidash/issues/1129) | `[Feature]: Auto-generate meaningful names for imported requests (cURL & HAR)` |

---

## Project Proposal Information

### 1. Proposal Title

**Agentic API Testing for API Dash: An Autonomous, Self-Healing Test Generation Framework**

---

### 2. Abstract

Modern API development faces a critical bottleneck: manual test creation consumes 30–50% of developer time while producing brittle, unmaintainable test suites that fracture under the slightest schema evolution. Traditional approaches require developers to manually translate API specifications into executable tests, maintain hardcoded assertions, and continuously repair broken tests when APIs change — a process that scales linearly with API complexity and becomes unsustainable for microservices architectures with hundreds of interdependent endpoints

This proposal introduces **Agentic API Testing**, a comprehensive AI-powered testing framework natively integrated into API Dash. The system leverages large language models (LLMs) with structured tool-calling capabilities to autonomously parse API specifications (OpenAPI 3.x, Postman Collections, GraphQL schemas), generate intelligent test strategies covering happy paths, edge cases, and security scenarios, execute multi-step workflows with dynamic context propagation, and **self-heal** when APIs evolve — automatically detecting schema drift and updating assertions without human intervention. The framework is further enhanced by **MCP Apps integration**, which provides rich bidirectional UI components (interactive test approval tables, visual diff reviewers) at critical human-in-the-loop decision points inside API Dash's existing DashBot interface.

---

### 3. Detailed Description

#### 3.1 Problem Statement

##### 3.1.1 Schema Drift in Production APIs

When an API changes — for example, an `order.total` field migrating from a `number` to an object with `currency` and `amount` sub-fields — existing integration tests that assert `typeof response.total === 'number'` cause 100% test suite failure despite the API itself being correct. Developers spend hours diagnosing intentional changes, and production monitoring lacks coverage for the new structure during the diagnosis window.

##### 3.1.2 Broken Authentication Flows in Multi-Step Workflows

Manual test suites frequently validate each step of an OAuth 2.0 flow independently but never exercise the full chain (e.g., refresh → immediate API call with new token → verify no 401). When a token endpoint begins returning `expires_in` as a string `"3600"` rather than a number `3600`, the type discrepancy goes undetected until production users experience random session logouts.

##### 3.1.3 Undetected Rate Limiting Edge Cases

Tiered rate limits are commonly tested at steady-state but miss burst behavior. A pro tier's 1000 req/min enforced as a 100 req/6sec sliding window produces unexpected 429 responses for legitimate burst patterns — a class of failure that purely manual test design rarely anticipates.

---

#### 3.2 Proposed Solution

##### 3.2.1 High-Level System Architecture

The system is composed of six coordinated components:

| Component | Responsibility |
|---|---|
| `AgentCore` | Central orchestrator; session management, state machine enforcement, workflow decomposition |
| `SpecParser` | Normalises OpenAPI 3.x, Postman v2.1, GraphQL, and API Blueprint into a unified `AgentTask` graph |
| `TestStrategyPlanner` | LLM-powered planner generating test strategies across happy path, boundary value, security, and rate-limit scenarios |
| `WorkflowExecutor` | Multi-step API call chain executor with context persistence, dynamic variable substitution, and parallel execution via Dart isolates |
| `SelfHealingEngine` | Detects schema drift, classifies severity, auto-patches compatible changes, and escalates breaking changes for human review |
| `ReportGenerator` | Produces JSON, HTML, and Markdown reports for CI/CD and documentation integration |

##### 3.2.2 Data Flow

| Flow | Data | Purpose |
|---|---|---|
| Input → SpecParser | Raw JSON/YAML spec files | Normalisation and validation |
| SpecParser → AgentCore | `AgentTask` graph | Structured workflow representation |
| AgentCore → TestStrategyPlanner | Task metadata + user intent | Test strategy generation |
| TestStrategyPlanner → WorkflowExecutor | `APITestCase` instances | Executable test definitions |
| WorkflowExecutor → SelfHealingEngine | Response snapshots + failures | Drift detection input |
| SelfHealingEngine → WorkflowExecutor | Updated assertions + paths | Remediation output |
| WorkflowExecutor → ReportGenerator | Execution traces + results | Structured reporting |
| AgentCore ↔ UI | State updates + user commands | Interactive control |

---

#### 3.3 Agent Workflow State Machine

The `AgentCore` enforces a well-defined state machine to ensure valid transitions and predictable recovery:

| Transition | Condition | Action |
|---|---|---|
| IDLE → PARSING | User submits specification | Initialise parser, validate format hint |
| PARSING → PLANNING | Parser returns valid `AgentTaskGraph` | Load templates, initialise LLM client |
| PARSING → FAILED | `ParseException` or timeout | Log error, notify user with diagnostics |
| PLANNING → EXECUTING | Non-empty strategy generated | Initialise execution context, queue tests |
| EXECUTING → HEALING | Schema mismatch detected | Pause execution, invoke healing analysis |
| HEALING → EXECUTING | Patch validated with confidence ≥ threshold | Apply patch, resume from failed test |
| HEALING → FAILED | Max iterations (default: 3) exceeded | Escalate to human with full context |
| Any → FAILED | Unhandled exception or cancellation | Cleanup resources, preserve partial state |

---

#### 3.4 SpecParser: Multi-Format Ingestion

| Format | Version | Features |
|---|---|---|
| OpenAPI | 3.0.x, 3.1.x | Full schema, links, callbacks, webhooks |
| Postman Collection | v2.1 | Variables, scripts, auth, folders |
| GraphQL | Introspection | Queries, mutations, subscriptions, fragments |
| API Blueprint | 1A | Legacy support |

---

#### 3.5 TestStrategyPlanner: LLM-Powered Strategy Generation

| Test Type | Trigger | LLM Prompt Focus |
|---|---|---|
| Happy path | All endpoints | Verify nominal behaviour with valid inputs |
| Boundary value | Numeric/string parameters | Test min, max, and edge values |
| Error injection | Error-prone operations | Verify graceful failure handling |
| Security probe | Auth-required endpoints | Test authentication bypass, injection, traversal |
| Rate limit | Documented limits | Verify throttling behaviour and headers |
| Schema validation | All responses | Validate against specification with strictness tiers |

---

#### 3.6 SelfHealingEngine: Drift Classification and Auto-Remediation

| Drift Severity | Automated Action | Human Notification |
|---|---|---|
| Cosmetic (whitespace, ordering) | Silent acceptance | None |
| Compatible (new optional fields) | Test update | Summary digest |
| Breaking (required field changes) | Proposed patch | Immediate alert with diff |
| Architectural (endpoint removal) | Suite restructuring | Blocking review required |

---

#### 3.7 Error Handling and Graceful Degradation

When LLM output is invalid or the LLM provider is unavailable, the system degrades gracefully to rule-based test generation:

| Rule Category | Coverage |
|---|---|
| Required field presence | Generate tests with all required fields, then omit each one |
| Type-based boundaries | Min/max for numbers, length limits for strings |
| Status code enumeration | Test all documented success and error codes |
| Security scheme application | Apply each security scheme, then test without authentication |

LLM failure handling follows a provider fallback chain (Primary → Secondary → Local Ollama) with exponential backoff and a SHA-indexed generation cache for unchanged specs.

---

#### 3.8 MCP Apps Integration: Bidirectional UI Layer for Agentic Workflows

##### 3.8.1 Why Plain Text Output Fails at Two Critical Pipeline Nodes

The agentic pipeline described above produces two categories of output that are fundamentally ill-suited to plain text rendering inside a chat interface:

**Category 1 — Structured Decision Points**
After `TestStrategyPlanner` generates a test suite of 20–50 test cases, the developer must selectively approve, reject, or reprioritise individual tests before execution begins. Presenting this as a numbered list in the Agent Chat Interface forces the user to type case-by-case exclusions in natural language — a fragile, error-prone interaction pattern that reintroduces exactly the kind of manual effort the framework is designed to eliminate.

**Category 2 — Structured Diff Review**
When `SelfHealingEngine` proposes a patch to a broken assertion, the developer must compare the old and new assertion to make an informed approve/reject decision. A text description of the diff is semantically lossy and cognitively demanding; it fails to surface the spatial relationship between what changed and why.

Both cases share the same root problem: **the information the agent produces is inherently visual and interactive, but the only available output channel is linear text.** The Model Context Protocol (MCP) Apps extension directly addresses this gap.

---

##### 3.8.2 What MCP Apps Provide

MCP Apps extend the open-source Model Context Protocol with a standardised mechanism for MCP servers to deliver **rich, bidirectional UI components** — HTML rendered as sandboxed iframes natively inside AI hosts — without requiring external web apps, custom authentication, or broken conversational context. Concretely, this means:

- An MCP server tool call can return not just text, but a registered HTML resource to be rendered inline.
- The rendered iframe communicates back to the agent's context via a defined JSON-RPC bridge (`ui/update-model-context`, `ui/message`), completing the bidirectional loop.
- The host (API Dash) injects `hostContext` CSS variables into the iframe, ensuring visual consistency with the surrounding application theme.
- All external network access from inside the iframe is governed by the `_meta.ui.csp` declaration on each registered resource, enforcing sandboxing.

---

##### 3.8.3 Node 1 — `TestStrategyPlanner`: Interactive Test Review & Approval (`test-review` MCP App)

**Problem without MCP Apps:**
The `TestStrategyPlanner` outputs a list of `APITestCase` objects. Displaying these as raw text in the Agent Chat Interface gives the developer no ergonomic way to selectively approve tests without manually typing exclusions. Mistyped or ambiguous natural language exclusions risk silently including unwanted tests in execution.

**Solution with MCP Apps:**
When the `plan_tests` tool fires, the host renders the `test-review` MCP App — a sandboxed HTML table where each generated test case is a toggleable row. The developer interacts with the table and confirms their selection; the iframe then sends the filtered list back into the agent's context via `ui/update-model-context` as structured JSON. `AgentCore` receives this payload and transitions to `EXECUTING` only with the approved test cases.

**MCP App: `test-review`**

| UI Element | Data Source | Interaction |
|---|---|---|
| Test name | `APITestCase.name` | Read-only label |
| Type badge | `APITestCase.type` (happy path, security, boundary…) | Color-coded badge |
| Priority indicator | Planner-assigned risk score | Star/dot indicator |
| Toggle switch | Default: ON | User can disable individual tests |
| Endpoint tag | `APITestCase.method` + `APITestCase.path` | Read-only `GET /users/{id}` |
| Confirm button | Selected subset | Sends `ui/update-model-context` with approved list |
| Select All / None | Bulk action | Shortcut toggles for the entire suite |

---

##### 3.8.4 Node 2 — `SelfHealingEngine`: Visual Diff Review & Patch Approval (`healing-diff` MCP App)

**Problem without MCP Apps:**
When the `SelfHealingEngine` generates a patch for a drifted assertion, the state machine requires human review for `BREAKING` and `ARCHITECTURAL` severity drifts. Presenting the proposed patch as text forces the developer to mentally reconstruct the before/after relationship — a cognitively expensive task, especially for nested JSON schema changes.

**Solution with MCP Apps:**
When `patchRequiresReview` is triggered, the `SelfHealingEngine` invokes the `review_patch` tool. The host renders the `healing-diff` MCP App — a side-by-side diff viewer with color-coded removals (red) and additions (green), structured by assertion path. The developer reviews and makes one of three decisions: **Approve** (patch applied, execution resumes), **Reject** (escalate to FAILED), or **Edit** (open in Test Wizard for manual correction). The decision is sent back to the agent via `ui/message`.

**MCP App: `healing-diff`**

| UI Element | Data Source | Interaction |
|---|---|---|
| Diff header | Endpoint path + HTTP method | Read-only |
| Severity badge | `DriftSeverity` enum | Yellow (compatible) / Red (breaking) |
| Left panel (Before) | Original assertion JSON | Syntax-highlighted, read-only |
| Right panel (After) | Proposed patched assertion | Syntax-highlighted, read-only |
| Changed fields | Diff delta lines | Highlighted in red (removed) / green (added) |
| Confidence score | `SelfHealingEngine.confidenceScore` | Displayed as `87% confidence` indicator |
| Approve button | — | Sends `ui/message` with `{ decision: "approve" }` |
| Reject button | — | Sends `ui/message` with `{ decision: "reject" }` |
| Edit button | — | Opens patched assertion in Test Wizard for manual correction |
| Context note | LLM explanation of why the drift occurred | Collapsible text block |

---

##### 3.8.5 Flutter WebView as MCP App Host

API Dash is a Flutter application. The MCP Apps specification defines the **host-side responsibilities**: rendering the sandboxed iframe, mediating the JSON-RPC bridge, and injecting `hostContext` CSS variables. To implement this in Flutter:

- API Dash will embed `webview_flutter` to render MCP App HTML resources.
- The WebView acts as the sandboxed iframe equivalent, with all external network access controlled via the `_meta.ui.csp` declaration on each registered resource.
- A bidirectional JavaScript channel is established at WebView initialisation to relay `ui/update-model-context` and `ui/message` payloads back into the Dart layer, where `AgentCore` consumes them to drive state transitions.

---

#### 3.9 DashBot Integration

| DashBot Existing Capability | Agentic Testing Extension | MCP App Enhancement |
|---|---|---|
| Natural language API queries | Natural language test generation requests | `test-review` MCP App for approval |
| Response explanation | Test failure explanation | `healing-diff` MCP App for patch review |
| Collection browsing | Spec ingestion from collections | `execution-monitor` MCP App for live progress |
| Environment variable hints | Dynamic variable substitution in `WorkflowExecutor` | Handled internally |

---

#### 3.10 Risks & Mitigation

| Risk | Mitigation |
|---|---|
| LLM hallucination in test generation | JSON Schema validation of output; cross-reference with parsed spec; multi-shot retry with error feedback; confidence thresholding for human review |
| API specification ambiguity | Conservative defaults (skip unspecified behaviours); explicit uncertainty flags in generated tests; interactive clarification prompts for high-impact ambiguity |
| LLM provider instability | Unified `LlmClient` abstraction; provider health monitoring; fallback chain (Primary → Secondary → Local Ollama); SHA-indexed generation cache |

---

### 4. Weekly Timeline

| Week | Dates | Deliverables |
|---|---|---|
| **Community Bonding** | May 1 – 28 | Deep-dive into API Dash codebase; finalise architecture with mentors; set up development environment; document design decisions |
| **Week 1** | May 29 – Jun 4 | Implement `SpecParser` core: OpenAPI 3.0/3.1 ingestion and `AgentTask` graph construction |
| **Week 2** | Jun 5 – Jun 11 | Extend `SpecParser` to Postman v2.1 and GraphQL introspection; write unit tests for all parsers |
| **Week 3** | Jun 12 – Jun 18 | Implement `AgentCore` state machine (IDLE → PARSING → PLANNING → EXECUTING → FAILED transitions); session management |
| **Week 4** | Jun 19 – Jun 25 | Implement `TestStrategyPlanner`: LLM client abstraction, prompt templates for happy path and boundary value strategies |
| **Week 5** | Jun 26 – Jul 2 | Extend `TestStrategyPlanner` with security probe and rate-limit strategy generation; add JSON Schema validation and retry logic for LLM output |
| **Week 6** | Jul 3 – Jul 9 | Implement `WorkflowExecutor`: sequential execution, `ExecutionContext` persistence, dynamic variable substitution |
| **Week 7** | Jul 10 – Jul 16 | Extend `WorkflowExecutor`: parallel execution via Dart isolates; resilience patterns (backoff, circuit breaking, timeouts) |
| **Midterm Evaluation** | Jul 14 – Jul 18 | Demo: spec import → strategy generation → multi-step execution with context propagation |
| **Week 8** | Jul 17 – Jul 23 | Implement `SelfHealingEngine`: schema drift detection and cosmetic/compatible auto-patching |
| **Week 9** | Jul 24 – Jul 30 | Extend `SelfHealingEngine`: breaking/architectural severity classification, patch generation, and HEALING → FAILED escalation |
| **Week 10** | Jul 31 – Aug 6 | Implement `ReportGenerator`: JSON and Markdown output formats; CI/CD integration documentation |
| **Week 11** | Aug 7 – Aug 13 | Implement `test-review` MCP App: Flutter WebView host, HTML table UI, `ui/update-model-context` JSON bridge |
| **Week 12** | Aug 14 – Aug 20 | Implement `healing-diff` MCP App: side-by-side diff viewer, approve/reject/edit decision bridge via `ui/message` |
| **Week 13** | Aug 21 – Aug 27 | Flutter UI integration: Agent panel, natural language chat interface, real-time execution progress display |
| **Week 14** | Aug 28 – Sep 1 | End-to-end integration testing; bug fixes; HTML report generation; final documentation and contributor guide |
| **Final Evaluation** | Sep 1 – Sep 8 | Submit final work product; mentor review; public demo |
