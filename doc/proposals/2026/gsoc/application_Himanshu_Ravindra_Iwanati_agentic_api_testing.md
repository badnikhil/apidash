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

- - **Request history and diffing:** API Dash lacks a persistent request history that lets
  users compare responses across multiple executions of the same endpoint. A lightweight
  diff view between two historical responses would be valuable for spotting unintended
  API behaviour changes during development.

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

## Project Details

### 1. Project Title

**Agentic API Testing for API Dash: An Autonomous, Self-Healing Test Generation Framework**

---

### 2. Abstract

Modern API development faces a critical bottleneck: manual test creation consumes 30–50% of developer time while producing brittle, unmaintainable test suites that fracture under the slightest schema evolution. Traditional approaches require developers to manually translate API specifications into executable tests, maintain hardcoded assertions, and continuously repair broken tests when APIs change — a process that scales linearly with API complexity and becomes unsustainable for microservices architectures with hundreds of interdependent endpoints

This proposal introduces **Agentic API Testing**, a comprehensive AI-powered testing framework natively integrated into API Dash. The system leverages large language models (LLMs) with structured tool-calling capabilities to autonomously parse API specifications (OpenAPI 3.x, Postman Collections, GraphQL schemas), generate intelligent test strategies covering happy paths, edge cases, and security scenarios, execute multi-step workflows with dynamic context propagation, and **self-heal** when APIs evolve — automatically detecting schema drift and updating assertions without human intervention. The framework is further enhanced by **MCP Apps integration**, which provides rich bidirectional UI components (interactive test approval tables, visual diff reviewers) at critical human-in-the-loop decision points inside API Dash's existing DashBot interface.

---

### 3. Detailed Description

#### 3.1 Problem Statement

#### 3.1.1 Schema Drift in Production APIs

**Scenario**: E-commerce platform "ShopFlow" releases API v2.3, changing `order.total` from `number` to `object` with `currency` and `amount` fields. Existing integration tests assert `typeof response.total === 'number'`, causing **100% test suite failure** despite API correctness. Developers spend **8 hours** diagnosing the intentional change. Meanwhile, production monitoring lacks coverage for the new structure, causing **$47K in incorrect international charges** before detection.

**Agentic Prevention**: The self-healing engine detects the type migration during canary deployment, generates updated assertions for the new structure, flags the semantic change in `currency` default for human review, and maintains **continuous coverage** without CI breakage.

#### 3.1.2 Broken Authentication Flows in Multi-Step Workflows

**Scenario**: Fintech "PaySecure" implements OAuth 2.0 with PKCE for mobile clients. A **manual test suite** validates each step independently but never exercises the **full chain**: refresh → immediate API call with new token → verify no 401. When the token endpoint begins returning `expires_in` as string `"3600"` rather than number `3600`, the mobile client's parsing fails. **Production users experience random logouts**; **2-star app rating crash** costs an estimated **$200K in acquisition spend waste**.

**Agentic Prevention**: The workflow executor maintains **execution context** across steps, validating that `access_token` successfully authenticates subsequent requests. Schema validation on the token response catches the type discrepancy.

#### 3.1.3 Undetected Rate Limiting Edge Cases

**Scenario**: SaaS "DataStream" implements tiered rate limits: 100 req/min for free, 1000 req/min for pro. Manual tests verify limits at **steady-state** but miss **burst behavior**: the pro tier's 1000 req/min is enforced as a **100 req/6sec sliding window**, causing **unexpected 429 responses** for legitimate burst patterns. Support spends **40 hours** reproducing before engineering identifies the window implementation. **3 enterprise trials churn** due to reliability concerns.

**Agentic Prevention**: The test strategy planner generates **edge case scenarios** including burst patterns, sliding window verification, and backoff behavior.

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

##### 3.2.2 System Architecture Overview

![Workflow](images/hihry_workflow.png)

The Agentic API Testing system transforms **static API specifications into dynamic, intelligent test suites** through a multi-stage pipeline. Upon specification ingestion, the **SpecParser** normalizes diverse formats into a unified **AgentTask graph**—a directed acyclic graph representing API operations, their dependencies, and data flows.

The **TestStrategyPlanner** then operates on this graph as a planning problem. Using an LLM with tool-calling capabilities, it generates **test strategies** for each operation considering: happy path validation, boundary value analysis, equivalence class partitioning, error injection, security testing, and performance baseline establishment.

Each strategy is instantiated into **concrete test cases** with generated test data, expected response assertions, and dependency specifications. The result is a **comprehensive, prioritized test suite** that maximizes coverage within execution time constraints.

##### 3.2.2 Data Flow Directionality

Data flows **unidirectionally** from specification to report, with **feedbackloops** for healing and user interaction:

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

#### 3.3 Core Component Specifications

#### 3.3.1 AgentCore: Orchestration and Workflow Decomposition

The `AgentCore` serves as the **central nervous system**, coordinating all other components. Its responsibilities include:

- **Session management**: Maintaining user context across multiple test generation and execution requests
- **Workflow decomposition**: Breaking complex natural language objectives into discrete, ordered tasks with dependency analysis
- **State machine enforcement**: Ensuring valid transitions between IDLE, PARSING, PLANNING, EXECUTING, VALIDATING, REPORTING, and HEALING states
- **Resource scheduling**: Prioritizing test execution based on risk, coverage gaps, and user-specified urgency
- **Error aggregation**: Collecting and categorizing failures across components for unified reporting

The core implements `event-driven architecture` using Dart’s Stream API, enabling reactive UI updates and parallel processing without blocking.

```dart
// lib/agents/agent_core.dart

/// Central orchestrator for the agentic testing system.
///
/// Manages component lifecycle, state transitions, and session state.
/// Emits events for UI consumption via [stateStream].
class AgentCore {
  /// Creates a new [AgentCore] with injected dependencies.
  AgentCore({
    required SpecParser specParser,
    required TestStrategyPlanner strategyPlanner,
    required WorkflowExecutor workflowExecutor,
    required SelfHealingEngine healingEngine,
    required ReportGenerator reportGenerator,
    required Logger logger,
  })  : _specParser = specParser,
        _strategyPlanner = strategyPlanner,
        _workflowExecutor = workflowExecutor,
        _healingEngine = healingEngine,
        _reportGenerator = reportGenerator,
        _logger = logger,
        _stateController = BehaviorSubject.seeded(AgentState.idle);

  final SpecParser _specParser;
  final TestStrategyPlanner _strategyPlanner;
  final WorkflowExecutor _workflowExecutor;
  final SelfHealingEngine _healingEngine;
  final ReportGenerator _reportGenerator;
  final Logger _logger;
  final BehaviorSubject<AgentState> _stateController;

  // Error aggregation — collects failures across all nodes for unified reporting
  final List<String> _errors = [];

  /// Stream of state changes for reactive UI updates.
  Stream<AgentState> get stateStream => _stateController.stream;

  /// Current agent state.
  AgentState get currentState => _stateController.value;

  /// Initiates test generation from a specification source.
  ///
  /// [source] contains the raw spec content and format hint.
  /// [intent] provides optional natural language guidance.
  ///
  /// Returns a [TestSuite] that can be executed or refined.
  Future<TestSuite> generateTests({
    required SpecSource source,
    UserIntent? intent,
  }) async {
    try {
      _transitionTo(AgentState.parsing);
      final taskGraph = await _specParser.parse(source);

      _transitionTo(AgentState.planning);
      final strategies = await _strategyPlanner.generateStrategies(
        taskGraph: taskGraph,
        intent: intent,
      );

      return TestSuite(
        source: source,
        strategies: strategies,
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      _errors.add('generateTests failed: $e');
      _logger.error(e.toString());
      _transitionTo(AgentState.idle);
      rethrow;
    }
  }

  /// Executes a generated test suite with optional healing.
  Future<TestReport> executeSuite(
    TestSuite suite, {
    bool enableHealing = true,
    void Function(ExecutionProgress)? onProgress,
  }) async {
    // Typed explicitly — prevents silent type errors downstream
    final List<TestResult> results = [];

    try {
      _transitionTo(AgentState.executing);

      // Single context instance persisted across all batches —
      // ensures {{step1.response.body.id}} variables carry forward correctly
      final context = ExecutionContext.initial();

      for (final batch in suite.batchedStrategies) {
        final batchResults = await _workflowExecutor.executeBatch(
          batch,
          context: context,
          onProgress: onProgress,
        );
        results.addAll(batchResults);

        if (enableHealing) {
          final healable = batchResults.where((r) => r.canHeal).toList();
          if (healable.isNotEmpty) {
            _transitionTo(AgentState.healing);
            final patches = await _healingEngine.generatePatches(
              healable,
              context: context,
            );
            await _workflowExecutor.applyPatches(patches);
            _transitionTo(AgentState.executing);
          }
        }
      }

      _transitionTo(AgentState.validating);
      // TODO: validate results against spec contracts

      _transitionTo(AgentState.reporting);
      final report = await _reportGenerator.generate(results);
      _transitionTo(AgentState.idle);
      return report;
    } catch (e) {
      // Partial failure resilience — emit whatever results we collected so far
      _errors.add('executeSuite failed: $e');
      _logger.error(e.toString());
      _transitionTo(AgentState.idle);
      return _reportGenerator.generatePartial(results, errors: _errors);
    }
  }

  /// Enforces valid state transitions and broadcasts to UI via Stream.
  /// Throws in debug mode if an invalid transition is attempted.
  void _transitionTo(AgentState newState) {
    assert(
      _validTransitions[currentState]?.contains(newState) ?? false,
      'Invalid state transition: $currentState → $newState',
    );
    _logger.debug('State transition: $currentState → $newState');
    _stateController.add(newState);
  }

  /// Defines the only permitted state transitions — any other
  /// transition will throw an assertion error in debug mode.
  static const _validTransitions = <AgentState, Set<AgentState>>{
    AgentState.idle:       {AgentState.parsing, AgentState.executing},
    AgentState.parsing:    {AgentState.planning, AgentState.idle},
    AgentState.planning:   {AgentState.executing, AgentState.idle},
    AgentState.executing:  {AgentState.validating, AgentState.healing, AgentState.idle},
    AgentState.validating: {AgentState.reporting, AgentState.idle},
    AgentState.healing:    {AgentState.executing, AgentState.idle},
    AgentState.reporting:  {AgentState.idle},
  };

  void dispose() => _stateController.close();
}
```

#### 3.3.2 SpecParser: Multi-Format Schema Ingestion

The SpecParser abstracts **format heterogeneity** behind a unified interface, supporting:

| Format | Version | Features | Complexity |
|---|---|---|---|
| OpenAPI | 3.0.x, 3.1.x | Full schema, links, callbacks, webhooks | High |
|  Collection folders | v2.1 | Variables, scripts, auth, folders | Medium |
| GraphQL | Introspection | Queries, mutations, subscriptions, fragments | High |
| API Blueprint | 1A | Legacy support for migration scenarios | Low |

Parsing proceeds in three stages:

1. **Syntactic validation** — checks the spec against its format schema (OpenAPI / Postman / GraphQL)
2. **Semantic normalisation** — converts the validated spec into an `AgentTask` graph
3. **Relationship enrichment** — infers dependencies between endpoints (e.g. `POST /users` creates a resource later fetched by `GET /users/{id}`); LLM-assisted for complex cases

```dart
// lib/agents/nodes/spec_parser.dart

/// Abstract interface for API specification parsers.
/// Each format (OpenAPI, Postman, GraphQL) implements this contract.
abstract class SpecParser {
  /// Attempts to parse [source] into a normalized [AgentTaskGraph].
  ///
  /// Throws [ParseException] if the source is malformed or unsupported.
  Future<AgentTaskGraph> parse(SpecSource source);

  /// Returns a confidence score (0.0–1.0) that this parser can handle [source].
  ///
  /// Used for format auto-detection when not explicitly specified.
  double canParse(SpecSource source);
}

/// Selects the correct parser via confidence scoring — no manual format hint needed.
/// Falls back to rule-based heuristics if no parser scores above [_threshold].
class SpecParserResolver {
  SpecParserResolver({
    List<SpecParser>? parsers,
    this.threshold = 0.7,
  }) : _parsers = parsers ?? [
          OpenApiParser(validator: JsonSchemaValidator()),
          PostmanParser(),
          GraphQlParser(),
        ];

  final List<SpecParser> _parsers;
  final double threshold;

  Future<AgentTaskGraph> resolve(SpecSource source) {
    final best = _parsers
        .map((p) => (parser: p, score: p.canParse(source)))
        .where((e) => e.score >= threshold)
        .reduce((a, b) => a.score >= b.score ? a : b);

    return best.parser.parse(source);
  }
}

// -----------------------------------------------------------------------------

/// Parser for OpenAPI 3.x specifications (JSON / YAML).
class OpenApiParser implements SpecParser {
  const OpenApiParser({required this.validator});

  final JsonSchemaValidator validator;

  @override
  double canParse(SpecSource source) {
    // Heuristic: presence of 'openapi' key with version string
    return source.content.contains('openapi:') ||
            source.content.contains('"openapi"')
        ? 0.95
        : 0.0;
  }

  @override
  Future<AgentTaskGraph> parse(SpecSource source) async {
    final doc = await _loadYaml(source.content);

    // Version guard — only 3.x supported
    final version = _extractVersion(doc);
    if (!version.startsWith('3.')) {
      throw UnsupportedVersionException('OpenAPI $version not supported');
    }

    // Validate against JSON Schema before extracting tasks
    final errors = await validator.validate(doc);
    if (errors.isNotEmpty) throw ParseException(errors.join(', '));

    final paths = doc['paths'] as Map;
    final components = doc['components'] as Map?;
    final List<AgentTask> tasks = [];

    for (final pathEntry in paths.entries) {
      for (final methodEntry in (pathEntry.value as Map).entries) {
        tasks.add(_parseOperation(
          path: pathEntry.key,
          method: HttpMethod.fromString(methodEntry.key),
          spec: methodEntry.value as Map,
          components: components,
        ));
      }
    }

    return AgentTaskGraph(
      tasks: tasks,
      securitySchemes: _parseSecuritySchemes(doc['security']),
      servers: _parseServers(doc['servers']),
    );
  }

  AgentTask _parseOperation({
    required String path,
    required HttpMethod method,
    required Map spec,
    Map? components,
  }) {
    // TODO: resolve $ref pointers from components before extracting params
    return AgentTask(
      id: '${method.name}:$path',
      method: method,
      path: path,
      parameters: spec['parameters'] ?? [],
      requestBody: spec['requestBody'],
      responses: spec['responses'] ?? {},
    );
  }

  Map<String, dynamic> _parseSecuritySchemes(dynamic security) => {};
  List<String> _parseServers(dynamic servers) => [];
  Future<Map> _loadYaml(String content) async => {};
  String _extractVersion(Map doc) => doc['openapi']?.toString() ?? '';
}

// -----------------------------------------------------------------------------

/// Parser for Postman Collection v2.1.
/// Handles collection variables, auth schemes, folder nesting, and pre-request scripts.
class PostmanParser implements SpecParser {
  @override
  double canParse(SpecSource source) {
    return source.content.contains('collection') &&
            source.content.contains('info') &&
            source.content.contains('schema')
        ? 0.90
        : 0.0;
  }

  @override
  Future<AgentTaskGraph> parse(SpecSource source) async {
    // TODO: extract items (folders + requests), resolve {{variables}},
    // map auth schemes to AgentTask.securityRequirements
    throw UnimplementedError();
  }
}

// -----------------------------------------------------------------------------

/// Parser for GraphQL introspection schemas.
/// Extracts queries, mutations, subscriptions, and type system for test generation.
class GraphQlParser implements SpecParser {
  @override
  double canParse(SpecSource source) {
    return source.content.contains('__schema') ||
            source.content.contains('type Query')
        ? 0.90
        : 0.0;
  }

  @override
  Future<AgentTaskGraph> parse(SpecSource source) async {
    // TODO: parse type system, extract operation definitions,
    // infer field-level dependencies for multi-step test generation
    throw UnimplementedError();
  }
}
```

#### 3.3.3 TestStrategyPlanner: LLM-Powered Test Strategy Generation

The `TestStrategyPlanner` transforms a parsed spec into a test suite through three steps:

1. **Coverage analysis** — identifies untested paths, parameter combinations, and undocumented response codes
2. **Risk prioritisation** — weights tests by business criticality, security sensitivity, and historical failure rate
3. **Strategy selection** — picks the appropriate test type per endpoint (happy path, boundary value, security probe, etc.)

| Test Type | Trigger | LLM Prompt Focus |
|---|---|---|
| Happy path | All endpoints | Verify nominal behavior with valid inputs |
| Boundary value | Numeric/string parameters | Test min, max, and edge values |
| Error injection | Error-prone operations | Verify graceful failure handling |
| Security probe | Auth-required endpoints | Test authentication bypass, injection, traversal |
| Rate limit | Documented limits | Verify throttling behavior and headers |
| Schema validation | All responses | Validate against specification with strictness tiers |

Planner output is generated via **structured tool-calling APIs**, producing type-safe, parseable
`APITestCase` definitions — no fragile regex extraction.

```dart
// lib/agents/nodes/strategy_planner.dart

/// Generates test strategies using LLM reasoning with structured tool-calling output.
/// Falls back to rule-based generation if LLM output fails validation.
class TestStrategyPlanner {
  TestStrategyPlanner({
    required LlmClient llmClient,
    required PromptTemplateLibrary templates,
    required OutputValidator validator,
    required Logger logger,
  });

  /// Generates prioritised test strategies for all tasks in [taskGraph].
  /// Low temperature (0.2) keeps LLM output deterministic and parseable.
  Future<List<TestStrategy>> generateStrategies({
    required AgentTaskGraph taskGraph,
    UserIntent? intent,
  }) async {
    final List<TestStrategy> strategies = [];

    for (final task in taskGraph.tasks) {
      final prompt = _templates.forTask(task: task, intent: intent);

      // LLM call via tool-calling API → structured JSON, no regex extraction
      final response = await _llmClient.complete(
        prompt: prompt,
        tools: [_testStrategyTool],
        temperature: 0.2,
      );

      final structured =
          response.toolCalls?.first.arguments ?? _fallbackParse(response.text);

      // Validate output against task spec — retry or rule-generate on failure
      final validation = _validator.validate(structured, against: task);
      if (!validation.isValid) {
        _logger.warning('LLM output invalid: ${validation.errors}');
        // TODO: retry with stricter prompt; fall back to rule-based on second failure
        continue;
      }

      strategies.add(TestStrategy.fromJson(structured));
    }

    // Risk prioritisation: business criticality + security sensitivity + failure rate
    return _prioritizeAndDeduplicate(strategies);
  }

  /// Structured tool schema passed to the LLM — enforces type-safe output.
  /// Each test case carries: name, type, parameters, assertions, and dependencies.
  /// Each assertion carries: JSON path target, operator, expected value, severity.
  /// Risk assessment scores: business_criticality, security_sensitivity, failure_rate.
  static final _testStrategyTool = LlmTool(
    name: 'generate_test_strategy',
    // ... full JSON schema definition
  );

  List<TestStrategy> _prioritizeAndDeduplicate(List<TestStrategy> strategies) {
    // TODO: weight by risk_assessment scores, remove duplicate coverage
    return strategies;
  }

  Map<String, dynamic>? _fallbackParse(String? text) {
    // TODO: rule-based extraction as last resort before skipping task
    return null;
  }
}
```

#### 3.3.4 WorkflowExecutor: Multi-Step API Call Chain Execution

The `WorkflowExecutorhandles` the runtime complexity of API testing:

- **Context management**: Maintaining `ExecutionContext` with token storage, variable substitution, and cross-step data extraction
- **Dynamic substitution**: Supporting template expressions (`{{step1.response.body.id}}`, `{{env.BASE_URL}}`, `{{random.email}}`)
- **Parallel execution**: Using Dart isolates for CPU-bound operations while maintaining async I/O for network requests
- **Resilience patterns**: Exponential backoff, circuit breaking, and timeout handling with configurable policies

#### 3.3.5 SelfHealingEngine: Schema Drift Detection and Auto-Remediation

The `SelfHealingEngine` implements continuous specification alignment through three detection mechanisms:

- **Structural diff** — compares actual response schemas against expected schemas from the spec or historical snapshots
- **Semantic drift** — identifies changes in field meanings (e.g. `status: "active"` → `status: 1`) through value distribution analysis
- **Behavioral change** — detects modified error codes, header additions, or performance degradation


| Drift Severity | Automated Action | Human Notification |
|---|---|---|
| Cosmetic (whitespace, ordering) | Silent acceptance | None |
| Compatible (new optional fields) | Test update | Summary digest |
| Breaking (required changes) | Proposed patch | Immediate alert with diff |
| Architectural (endpoint removal) | Suite restructuring | Blocking review required |

Healing generates **confidence scores** based on change type, test coverage, and historical accuracy,
routing low-confidence cases to human review regardless of severity.

```dart

/// Detects schema drift from test failures and generates healing patches.
/// Patches are auto-applied, flagged for review, or escalated based on confidence score.
class SelfHealingEngine {
  SelfHealingEngine({
    required SchemaDiffer schemaDiffer,
    required PatchGenerator patchGenerator,
    required ConfidenceScorer confidenceScorer,
    required LlmClient llmClient,
  });

  // Confidence thresholds — tune based on acceptable automation risk
  static const _autoApplyThreshold = 0.85;
  static const _reviewThreshold = 0.60;

  /// Analyses failures, generates patches, and classifies each by confidence score.
  Future<List<HealingPatch>> generatePatches(
    List<TestResult> failures, {
    required ExecutionContext context,
  }) async {
    final List<HealingPatch> patches = [];

    for (final failure in failures) {
      if (!failure.isSchemaMismatch) continue;

      // Diff expected schema vs actual response schema → classifies drift severity
      final drift = await _schemaDiffer.analyze(
        expected: failure.expectedSchema,
        actual: failure.actualResponse.schema,
      );

      final patch = await _patchGenerator.generate(
        drift: drift,
        originalTest: failure.testCase,
      );

      final confidence = _confidenceScorer.score(patch);

      if (confidence >= _autoApplyThreshold) {
        patches.add(patch.copyWith(autoApply: true));
      } else if (confidence >= _reviewThreshold) {
        // Surfaces in healing-diff MCP App for human approve / reject / edit
        patches.add(patch.copyWith(requiresReview: true));
      }
      // Below reviewThreshold → escalate to human, no patch emitted
    }

    return patches;
  }
}
```

#### 3.3.6 ReportGenerator: Multi-Format Output

- **JSON**: Machine-parseable for CI/CD integration, with detailed execution traces and timing
- **HTML**: Rich visualization with collapsible request/response details, coverage heatmaps, and trend comparison
- **Markdown**: Repository-friendly for documentation, PR descriptions, and issue comments

```dart
// lib/agents/nodes/report_generator.dart

enum ReportFormat { json, html, markdown }

/// Generates test reports in multiple output formats.
/// JSON for CI/CD pipelines, HTML for visual review, Markdown for documentation.
class ReportGenerator {
  ReportGenerator({
    required JsonFormatter jsonFormatter,
    required HtmlFormatter htmlFormatter,
    required MarkdownFormatter markdownFormatter,
  });

  Future<String> generate(
    List<TestResult> results, {
    required ReportFormat format,
    ReportOptions? options,
    List<String> errors = const [],
  }) async {
    final report = TestReport.fromResults(results, errors: errors);

    return switch (format) {
      ReportFormat.json     => _jsonFormatter.format(report, options),
      ReportFormat.html     => _htmlFormatter.format(report, options),
      ReportFormat.markdown => _markdownFormatter.format(report, options),
    };
  }

  /// Partial report — emitted when executeSuite fails mid-run.
  /// Preserves all results collected before the failure for debugging.
  Future<String> generatePartial(
    List<TestResult> results, {
    List<String> errors = const [],
  }) =>
      generate(results, format: ReportFormat.json, errors: errors);
}
```


#### 3.7 Error Handling and Graceful Degradation

When LLM output is invalid or the provider is unavailable, the system does not fail
entirely — instead it applies a **confidence-gated hybrid fallback** strategy:

- **Partial output salvage** — valid test cases from a partial LLM response are preserved;
  rule-based generation fills only the missing or unparseable cases, avoiding a full
  regeneration cycle.
- **Rule-based baseline** — covers required field presence, type-based boundary values,
  status code enumeration, and security scheme validation, ensuring minimum test coverage
  is always produced regardless of LLM availability.

LLM failures follow a provider fallback chain — **Primary → Secondary → Local Ollama** —
with a configurable retry threshold (default: 3 attempts) and exponential backoff between
retries. Ollama ensures the pipeline remains functional even in fully offline environments.

Caching is applied at the **per-endpoint level** using a SHA index over individual
operation signatures — so a single endpoint change invalidates only that endpoint's
cached output rather than the entire spec, keeping redundant API calls minimal.

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

### 7.3 MCP Apps Protocol Integration in Flutter (API Dash as MCP Host)

API Dash is a Flutter application. The MCP Apps specification defines the **host-side responsibilities**: rendering the sandboxed iframe, mediating the JSON-RPC bridge, and injecting `hostContext` CSS variables. To implement this in Flutter:

#### 7.3.1 Flutter WebView as MCP App Host

API Dash will embed `webview_flutter` to render MCP App HTML resources. The WebView acts as the sandboxed iframe equivalent, with all external network access controlled via the `_meta.ui.csp` declaration on each registered resource.

### 7.4 DashBot Integration

API Dash's existing **DashBot** AI assistant is the natural host for the `AgentCore` natural language interface described in Section 3.4.2. The MCP Apps layer enhances DashBot's existing capabilities by adding structured visual output at key decision points, without replacing its conversational interface.

| DashBot Existing Capability | Agentic Testing Extension | MCP App Enhancement |
|---|---|---|
| Natural language API queries | Natural language test generation requests | `test-review` MCP App for approval |
| Response explanation | Test failure explanation | `healing-diff` MCP App for patch review |
| Collection browsing | Spec ingestion from collections | `execution-monitor` MCP App for live progress |
| Environment variable hints | Dynamic variable substitution in `WorkflowExecutor` | None (handled internally) |

---

## Weekly Timeline

> **Total commitment:** 175 hours | **Rate:** ~14 hrs/week across 12 coding weeks  
> **Coding period:** May 29 – Aug 29, 2026

---

### Community Bonding — May 1 – May 28 (~10 hrs, unbilled)

- Deep-dive into `foss42/apidash` codebase — focus on `DashBot`, collection importer, and HTTP client layers
- Align architecture decisions with mentors — finalise node interfaces and data models
- Set up development environment, CI, and test harness
- Document API contracts between all six nodes before writing any implementation code

---

| Week | Dates | Hours | Deliverables |
|---|---|---|---|
| **Week 1** | May 29 – Jun 4 | 14 hrs | `SpecParser` foundation: YAML/JSON loading, syntactic validation via `JsonSchemaValidator`, `ParseException` hierarchy |
| **Week 2** | Jun 5 – Jun 11 | 14 hrs | `SpecParser` semantic layer: normalise validated doc → `AgentTaskGraph`; `$ref` resolution; Postman v2.1 and GraphQL parser stubs; unit tests for all three parsers |
| **Week 3** | Jun 12 – Jun 18 | 14 hrs | `AgentCore` state machine with `_validTransitions` guard + `BehaviorSubject` stream; basic `WorkflowExecutor` stub (enough to drive EXECUTING state and test all transitions end-to-end) |
| **Week 4** | Jun 19 – Jun 25 | 14 hrs | `TestStrategyPlanner`: `LlmClient` abstraction, `PromptTemplateLibrary`, structured tool-calling output schema, happy path + boundary value strategy generation |
| **Week 5** | Jun 26 – Jul 2 | 14 hrs | Extend `TestStrategyPlanner`: security probe + rate-limit strategies; `OutputValidator` with JSON Schema checks; retry logic + rule-based fallback on LLM failure; per-endpoint SHA cache |
| **Week 6** | Jul 3 – Jul 9 | 14 hrs | `WorkflowExecutor` full implementation: sequential execution, `ExecutionContext` persistence across batches, `{{variable}}` template resolution; basic Flutter Agent panel scaffold (needed to test MCP rendering in Weeks 11–12) |
| **Week 7** | Jul 10 – Jul 16 | 14 hrs | Extend `WorkflowExecutor`: parallel execution via Dart isolates; resilience patterns (exponential backoff, circuit breaking, configurable timeouts) |
| **Midterm Evaluation** | Jul 14 – Jul 18 | — | ✅ Demo: spec import → strategy generation → multi-step execution with context propagation |
| **Week 8** | Jul 17 – Jul 23 | 14 hrs | `SelfHealingEngine`: structural diff, semantic drift detection, cosmetic/compatible auto-patching; `ConfidenceScorer` with auto-apply vs review thresholds |
| **Week 9** | Jul 24 – Jul 30 | 14 hrs | Extend `SelfHealingEngine`: breaking/architectural severity classification, patch generation, `HEALING → FAILED` escalation; `ReportGenerator` — JSON + Markdown output formats |
| **Week 10** | Jul 31 – Aug 6 | 14 hrs | `ReportGenerator` HTML output with coverage heatmap; `generatePartial()` for mid-run failures; CI/CD integration documentation; end-to-end pipeline integration test across all nodes |
| **Week 11** | Aug 7 – Aug 13 | 14 hrs | `test-review` MCP App: Flutter `webview_flutter` host, sandboxed HTML table UI, `ui/update-model-context` JSON bridge back to `AgentCore` |
| **Week 12** | Aug 14 – Aug 20 | 14 hrs | `healing-diff` MCP App: side-by-side diff viewer, severity badge, confidence score display, approve/reject/edit decision bridge via `ui/message` |
| **Week 13** | Aug 21 – Aug 27 | 14 hrs | Flutter UI completion: natural language chat interface in Agent panel, real-time execution progress display via `stateStream`; DashBot integration |
| **Week 14 (Buffer)** | Aug 28 – Sep 1 | 9 hrs | Integration testing across full pipeline; edge case fixes; performance profiling; final documentation and contributor guide |
| **Final Evaluation** | Sep 1 – Sep 8 | — | Submit final work product; mentor review; public demo |

---

### Hour Breakdown by Component

| Component | Estimated Hours |
|---|---|
| `SpecParser` (all formats + tests) | 28 hrs |
| `AgentCore` + state machine | 14 hrs |
| `TestStrategyPlanner` + LLM layer | 28 hrs |
| `WorkflowExecutor` + context | 28 hrs |
| `SelfHealingEngine` + drift detection | 28 hrs |
| `ReportGenerator` (all formats) | 14 hrs |
| MCP Apps (`test-review` + `healing-diff`) | 28 hrs |
| Flutter UI + DashBot integration | 14 hrs |
| Integration testing + documentation | 9 hrs (buffer) |
| **Total** | **175 hrs** |

---

### Key Dependencies & Risks

| Risk | Affected Weeks | Mitigation |
|---|---|---|
| `$ref` resolution complexity in OpenAPI parser | Week 1–2 | Scoped to community bonding research; stub with TODO if it overruns |
| LLM provider instability | Week 4–5 | Local Ollama fallback in place before LLM-dependent weeks begin |
| `healing-diff` MCP App depends on stable `SelfHealingEngine` | Week 12 | Engine completed by end of Week 9 — 2 week buffer before MCP App work |
| Flutter UI left too late | Week 13 | Basic Agent panel scaffold built in Week 6 alongside `WorkflowExecutor` |
| No buffer in original plan | Week 14 | Explicit buffer week added — integration testing and docs separated from feature work |