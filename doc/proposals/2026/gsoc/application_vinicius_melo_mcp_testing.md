### About

1. **Full Name:** Vinícius Melo Almeida
2. **Contact:** vinimelo@riseup.net
3. **Discord:** vinimlo
4. **Home page:** —
5. **Blog:** —
6. **GitHub:** https://github.com/vinimlo
7. **LinkedIn:** https://www.linkedin.com/in/vinimlo/
8. **Time zone:** BRT (UTC-3)
9. **Resume:** [PDF](https://drive.google.com/file/d/1z9fIGaFpxUeHaWfBtjNt2oPVPaDUeJkb/view?usp=sharing)

### University Info

1. **University:** Universidade Federal da Bahia (UFBA)
2. **Program:** Bachelor's in Information Systems (Sistemas de Informação)
3. **Year:** 4th year
4. **Expected graduation:** December 2029

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes. I contributed to [Wokwi](https://github.com/wokwi/wokwi-docs/pull/116) (documentation PR merged — added `Serial.begin` to the ESP32 WiFi guide) and [Noosfero](https://gitlab.com/noosfero/noosfero/-/merge_requests/1387) (submitted MRs for [audio playback](https://gitlab.com/noosfero/noosfero/-/merge_requests/1387) and [podcasting](https://gitlab.com/noosfero/noosfero/-/merge_requests/1306) functionality on GitLab).

I also maintain open source projects: [**galaxy-profile**](https://github.com/vinimlo/galaxy-profile) (458+ stars, GPL-3.0 — GitHub profile reimagined as a galaxy with auto-generated SVG cards) and [**tabAla**](https://github.com/vinimlo/tabAla) (Chrome extension for tab organization, Apache 2.0).

Beyond code, I coordinated the [**Festival Latino-Americano de Instalação de Software Livre (FLISOL)**](https://flisolssa.gitlab.io/) in Salvador 2018 — the largest free software event in Latin America — organizing workshops, talks, and install fests to promote free software adoption.

**2. What is your one project/achievement that you are most proud of? Why?**

My published paper at [Computer on the Beach 2023](https://periodicos.univali.br/index.php/acotb/article/view/19528) — *"IRIS: Extração, Organização e Classificação de Conteúdos do Projeto Pedagógico de Curso do Técnico em Automação Industrial"* (DOI: [10.14210/cotb.v14.p544-549](https://doi.org/10.14210/cotb.v14.p544-549)).

It taught me to take a real-world problem (students struggling to navigate course content), design a solution (automated extraction and classification using web scraping and NLP), implement it, and defend it through peer review. The discipline of academic rigor — formulating hypotheses, testing systematically, documenting results — directly shapes how I approach engineering today.

**3. What kind of problems or challenges motivate you the most?**

Problems at the intersection of developer tooling and emerging protocols. When a new technology like MCP emerges but the ecosystem tooling hasn't caught up, developers waste time on manual processes that could be automated. I'm motivated by closing that gap — building the testing, validation, and debugging tools that let developers focus on building, not fighting their tools.

This is why I co-founded [Seu AgenteIA](https://github.com/vinimlo) — to bring AI agent systems to production. And it's why MCP Testing resonates: I've experienced firsthand what it's like to build MCP-based systems without proper testing infrastructure.

**4. Will you be working on GSoC full-time?**

Part-time (~20h/week). I'll be working at my company [Rumo Tecnologias](https://rumotech.com.br) alongside GSoC. The 175-hour project scope requires ~14.6h/week over 12 weeks, which is comfortably within my availability. My professional work with AI systems and API integrations is complementary to this project — it keeps me close to the real-world pain points that MCP Testing addresses.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — I actively prefer it. Regular check-ins help catch misalignments early and keep the project on track. I'm available for weekly syncs and responsive on Discord throughout the week.

**6. What interests you the most about API Dash?**

API Dash occupies a strategic position: it's already the tool developers use for API testing, and MCP is becoming the API layer of the AI world. Adding MCP testing capability means API Dash becomes the natural home for a developer's entire API workflow — REST, GraphQL, and now AI agent protocols.

I'm also impressed by the codebase quality: the monorepo structure with Melos, Riverpod for state management, the `genai` package abstracting multiple AI providers, and the Freezed-based immutable models. These are patterns I use in my own production systems, and it shows mature engineering.

**7. Can you mention some areas where the project can be improved?**

- **MCP support** is the most significant gap. As AI agents become mainstream, developers need first-class tooling for testing MCP servers alongside traditional APIs.
- **CI/CD integration** could be stronger — providing exportable test results in standard formats (JUnit XML, TAP) would make API Dash relevant in enterprise and automated workflows.
- **Automated regression testing** — beyond one-off API calls, developers need to save test scenarios and replay them to catch regressions after server changes.

**8. Have you interacted with and helped API Dash community?**

Yes — I joined the [Discord](https://discord.com/invite/bBeSdtJ6Ue) (#gsoc-foss-apidash channel), posted my introduction, submitted [PR #1476](https://github.com/foss42/apidash/pull/1476) with my MCP Testing idea document, and [commented on Discussion #1054](https://github.com/foss42/apidash/discussions/1054#discussioncomment-16318842) expressing interest in Idea #1.

---

### Project Proposal Information

**1. Proposal Title**

MCP Testing — Protocol-First Test Harness for MCP Servers and Clients

**2. Abstract**

The Model Context Protocol (MCP) ecosystem lacks standardized testing tooling. Developers building MCP integrations must manually craft JSON-RPC requests, cannot validate schema conformance automatically, and have no mock infrastructure for deterministic client-side testing.

This project builds a **protocol-first** testing system designed for automation from day one. The core is a conformance engine that runs headless (CLI, CI pipelines) or interactive (web UI), delivered as **three standalone packages**:

1. **`mcp-conformance`** — Schema validator, assertion framework, conformance test suite, network recording, and CLI with JUnit XML / TAP / JSON output
2. **`mcp-mock`** — Configurable mock MCP server with replay mode and failure injection
3. **MCP Testing UI** — React web interface for interactive exploration, test execution, and recording inspection

This architecture ensures every test can be automated in CI before it's ever run manually — and that the project delivers value even if the UI is the last piece to ship.

**3. Detailed Description**

## Problem

Developers building MCP integrations face four pain points:

- **No schema validation tooling.** There's no way to automatically verify that an MCP server's tool definitions conform to the spec — missing required fields, malformed JSON Schema for parameters, or invalid transport configurations go undetected until runtime.
- **Manual testing workflows.** Developers manually craft JSON-RPC requests, inspect responses by hand, and mentally track whether the server handles edge cases (malformed input, missing parameters, timeouts).
- **No conformance testing.** There's no standard suite to verify that a server correctly implements the MCP protocol lifecycle: `initialize` handshake with capability negotiation, `tools/list` discovery, `tools/call` execution, proper JSON-RPC 2.0 error codes, and transport negotiation.
- **No client-side testing support.** Applications consuming MCP servers have no mock infrastructure for deterministic testing without depending on live server availability.

## Architecture: Protocol-First, Automation-First

The key architectural decision is: **the engine is the product, the UI is a viewer.**

Every test runs headless first. The CLI is the primary interface. The web UI is an interactive explorer layered on top of the same engine. This means:

- CI integration works from Week 4 (not an afterthought)
- The project delivers value even if UI work extends
- Each package is standalone and reusable beyond API Dash

### Package 1: `mcp-conformance` (TypeScript / Node.js)

The core testing engine, published as an npm package.

**Transport Adapters:**
Abstraction layer supporting stdio and Streamable HTTP. Each adapter implements a common interface: `connect()`, `send()`, `receive()`, `disconnect()`. This isolates transport concerns from testing logic.

```
┌─────────────────────────────────────────────────┐
│              TransportAdapter                    │
│  ┌───────────────┐  ┌────────────────────────┐  │
│  │ StdioAdapter  │  │ StreamableHTTPAdapter  │  │
│  │ (subprocess   │  │ (HTTP POST + SSE       │  │
│  │  + readline)  │  │  response stream)      │  │
│  └───────────────┘  └────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

**Schema Validator:**
Parses MCP server tool definitions and validates against the spec:
- Tool names, descriptions, and `inputSchema` conformance
- JSON Schema types for parameters are valid and complete
- Required vs. optional parameters are properly declared
- Capability declarations match actual server behavior

Returns structured validation results with error messages and fix suggestions, consumable both programmatically and via CLI output.

**Assertion Framework:**
Composable, protocol-based assertions inspired by testing framework patterns:

- **Protocol assertions:** Verify JSON-RPC 2.0 compliance, correct error codes (-32700, -32600, -32601, -32602), proper capability negotiation
- **Schema assertions:** Validate tool definitions, input schemas, response structures
- **Response assertions:** Content matching (contains, not_contains, regex), response timing
- **Tool call assertions:** Verify specific tools are called with expected parameters and return expected result shapes

Each assertion is a standalone function that takes traces/responses and returns pass/fail with detailed error context. This makes assertions testable, composable, and extensible without modifying the runner.

**Conformance Test Suite:**
30+ pre-built test cases organized by category:

| Category | Tests | What they verify |
|----------|-------|-----------------|
| Transport | 5+ | stdio lifecycle, HTTP connection, graceful shutdown |
| Protocol | 8+ | `initialize` handshake, capability negotiation, version matching |
| Discovery | 5+ | `tools/list` response structure, schema completeness |
| Execution | 8+ | `tools/call` with valid/invalid params, error handling |
| Edge cases | 6+ | malformed JSON, unknown tools, oversized payloads, concurrent requests |

**Network Recording:**
Captures real MCP traffic (JSON-RPC messages) and serializes to fixture files:

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  Client  │ ──► │  Recording   │ ──► │  Server  │
│          │ ◄── │  Proxy       │ ◄── │          │
└──────────┘     └──────┬───────┘     └──────────┘
                        │
                        ▼
                 ┌──────────────┐
                 │ fixtures/    │
                 │  session.jsonl│
                 └──────────────┘
```

Each recorded session captures: request/response pairs with timestamps, transport metadata, and sequence ordering. These fixtures feed directly into `mcp-mock` for replay.

**CLI Interface:**

```bash
# Run conformance suite against a server
npx mcp-conformance run --server "node my-server.js"

# Run against HTTP server
npx mcp-conformance run --url http://localhost:3000/mcp

# Validate schema only (no execution)
npx mcp-conformance validate --server "node my-server.js"

# Record traffic for replay
npx mcp-conformance record --server "node my-server.js" --output fixtures/

# Output formats
npx mcp-conformance run --server "..." --format junit   # JUnit XML
npx mcp-conformance run --server "..." --format tap     # TAP
npx mcp-conformance run --server "..." --format json    # JSON
```

### Package 2: `mcp-mock` (TypeScript / Node.js)

A configurable mock MCP server for client-side testing.

**Configuration-driven:**

```yaml
# mock.yaml
tools:
  - name: get_weather
    description: Get current weather for a city
    inputSchema:
      type: object
      properties:
        city: { type: string }
      required: [city]
    response:
      content:
        - type: text
          text: "72°F, sunny"

  - name: search_db
    description: Search the database
    inputSchema:
      type: object
      properties:
        query: { type: string }
    response:
      content:
        - type: text
          text: '{"results": [{"id": 1}]}'
```

**Replay mode:**
Serve recorded fixtures from `mcp-conformance record`:

```bash
npx mcp-mock --replay fixtures/session.jsonl
```

**Failure injection:**
Configurable failure modes for resilience testing:

```yaml
chaos:
  latency: 2000        # Add 2s latency to all responses
  error_rate: 0.1       # 10% of requests return errors
  timeout_tools:        # Specific tools that timeout
    - slow_search
  malformed_responses:  # Return invalid JSON-RPC
    - invalid_tool
```

**Transport support:** stdio and Streamable HTTP, matching the conformance engine.

### Package 3: MCP Testing UI (React / TypeScript)

Interactive web interface built on top of the same engine.

**Server Connection Panel:**
- Connect to any MCP server (stdio command or HTTP URL)
- Auto-discover tools, resources, and prompts
- Display server capabilities and protocol version

**Tool Explorer:**
- Browse discovered tools with schemas rendered in readable format
- Auto-generate input forms from `inputSchema`
- Execute tool calls with custom parameters
- Inspect structured responses with syntax highlighting

**Test Runner:**
- Run full conformance suite or selected test categories
- Live pass/fail streaming during execution
- Conformance scorecard showing coverage by category
- Export results as JUnit XML, JSON, or HTML report

**Recording Viewer:**
- Inspect captured network traffic (request/response pairs)
- Timeline view with sequence ordering
- Replay controls: step through recorded sessions
- Diff view: compare two recordings side by side

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                  MCP Testing UI                      │
│  ┌────────────┐ ┌──────────┐ ┌───────────────────┐  │
│  │   Tool     │ │   Test   │ │    Recording      │  │
│  │  Explorer  │ │  Runner  │ │    Viewer         │  │
│  └─────┬──────┘ └────┬─────┘ └────────┬──────────┘  │
│        │              │                │              │
│        ▼              ▼                ▼              │
│  ┌──────────────────────────────────────────────┐    │
│  │            mcp-conformance (engine)           │    │
│  │  transport │ schema   │ assertions │ recorder │    │
│  │  adapters  │ validator│ framework  │          │    │
│  └──────────────────────┬───────────────────────┘    │
└─────────────────────────┼────────────────────────────┘
                          │
            ┌─────────────┼─────────────┐
            ▼             ▼             ▼
     ┌──────────┐  ┌──────────┐  ┌──────────┐
     │ Real MCP │  │ mcp-mock │  │ Fixture  │
     │ Server   │  │ (mock)   │  │ Files    │
     └──────────┘  └──────────┘  └──────────┘
```

## Why This Architecture

1. **Standalone packages.** `mcp-conformance` and `mcp-mock` are usable without the UI — in CI pipelines, as libraries, or from the command line. This aligns with API Dash's pattern of extracting reusable packages (like `better_networking`, `curl_parser`, `genai`).

2. **De-risked timeline.** The engine delivers value from Week 4. If UI work takes longer, the core deliverables are already shipping and usable.

3. **12 incremental PRs.** Each week produces a focused, reviewable, mergeable PR — following API Dash's preference for precise, incremental contributions over monolithic changes.

4. **Recording connects everything.** `mcp-conformance` records traffic, `mcp-mock` replays it, the UI visualizes it. One concept ties all three packages together.

5. **CI-native from day one.** JUnit XML output means any CI system can consume results immediately. Not an afterthought — it's Week 4.

## Why Me

I bring production experience that goes beyond academic knowledge:

- **AI agent systems in production:** As co-founder of Seu AgenteIA and CTO of Rumo Tecnologias, I've built and shipped AI-powered systems using the Anthropic API with tool calling, multi-agent architectures, and API integrations for enterprise clients.
- **API integration at scale:** At Bloxs (fintech), I designed data infrastructure on AWS and built API integrations handling real-world concerns: auth flows, rate limiting, error handling, and schema validation.
- **Testing framework architecture:** I've designed and built behavior testing frameworks for AI agents — protocol-based assertion systems, trace collection models, and multi-turn test state threading — which directly inform the conformance engine design.
- **Published researcher:** My paper at Computer on the Beach 2023 demonstrates the ability to systematically design, implement, and validate a technical solution through peer review.
- **Full-stack TypeScript/Python:** The exact stack required for this project matches my daily working stack.

## Future Extensions (post-GSoC)

- **Security profiling:** Extend schema validator to flag destructive operations, detect tool poisoning patterns, and check for injection vulnerabilities — building on the validation infrastructure already in place.
- **MCP Apps testing:** Add support for validating MCP Apps (interactive UI components) including `ui/initialize` handshake verification, `hostContext` CSS injection, and iframe sandbox compliance.
- **Additional transports:** SSE legacy support for older MCP servers.

**4. Weekly Timeline**

| Week | Phase | Deliverable | PR |
|------|-------|-------------|-----|
| CB | Community Bonding | Dev setup, MCP spec deep dive, API Dash codebase study, architecture discussion with mentors | — |
| 1 | Engine Core | Transport adapters (stdio + Streamable HTTP) + JSON-RPC client. Connect to any MCP server, send `initialize`, discover tools. | #1 |
| 2 | Engine Core | Schema validator + composable assertion framework. Validate tool definitions against spec, run assertions on responses. | #2 |
| 3 | Engine Core | Conformance test suite: 30+ pre-built tests covering `initialize`, `tools/list`, `tools/call`, error codes, edge cases. | #3 |
| 4 | Engine Core | CLI interface + output formats (JUnit XML, TAP, JSON, rich terminal). `npx mcp-conformance run` works end-to-end. | #4 |
| — | **Midterm** | **Engine runs headless against any MCP server, outputs conformance report. CI-ready.** | — |
| 5 | Mock + Recording | Mock MCP server core: configurable tools with deterministic responses. `npx mcp-mock --config mock.yaml` serves responses. | #5 |
| 6 | Mock + Recording | Network recording in conformance engine + replay mode in mock. Record real traffic → replay as fixtures. | #6 |
| 7 | Mock + Recording | Failure injection: latency, error responses, partial results, connection drops. Chaos testing for resilience. | #7 |
| 8 | Web UI | UI scaffold + server connection panel + tool explorer. Connect to server, browse tools/schemas, execute calls. | #8 |
| 9 | Web UI | Test runner panel + conformance scorecard. Run suite from UI, view pass/fail results by category. | #9 |
| 10 | Web UI | Recording viewer + replay controls. Inspect captured traffic, step through sessions, compare recordings. | #10 |
| 11 | Web UI | Polish, responsive design, user guide with examples and screenshots. | #11 |
| 12 | Final | Integration tests against 3+ real MCP servers, GitHub Actions CI workflow example, documentation, GSoC final report. | #12 |
