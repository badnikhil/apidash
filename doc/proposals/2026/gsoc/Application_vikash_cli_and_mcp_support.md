# Application: CLI & MCP Server

### About

1. **Full Name:** Vikash
2. **Contact info:** heyvkr@gmail.com
3. **Discord handle:** vortex_71
4. **Home page:** [Insert link, or remove if N/A]
5. **GitHub profile link:** [Insert your GitHub profile link]
6. **Twitter, LinkedIn, other socials:** [Insert your LinkedIn profile link]
7. **Time zone:** India Standard Time (IST), UTC+5:30
8. **Link to a resume:** [Insert PDF link, ensure it is publicly accessible]

### University Info

1. **University name:** SRM Institute of Science and Technology
2. **Program you are enrolled in:** Bachelor of Technology in Computer Science & Engineering (Specialization in AI & ML)
3. **Year:** 3rd Year
4. **Expected graduation date:** MAY 2027

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**
Yes, I am highly passionate about the open-source ecosystem and have
actively contributed to multiple FOSS projects.

I have contributed to **Tolgee**, an open-source localization platform,
where I submitted a pull request addressing a UI/UX issue in the platform
([PR #3362](https://github.com/tolgee/tolgee-platform/pull/3362)).
I have also contributed to **EvalAI**, a cloud-based AI evaluation platform
by Cloud-CV, through both a merged pull request
([PR #4845](https://github.com/Cloud-CV/EvalAI/pull/4845)) and a bug report
that helped improve platform reliability
([Issue #4846](https://github.com/Cloud-CV/EvalAI/issues/4846)).

Beyond these, I have been an active early contributor to **API Dash** itself.
I engaged with
[Issue #845](https://github.com/foss42/apidash/issues/845#event-22868404252)
— *"Add support for working with MCP for LLMs to access APIs"* — which was
subsequently **marked as completed** by the maintainers. Notably, a majority
of the GSoC 2026 idea list for API Dash revolves around MCP — covering areas
such as MCP server testing, CLI and MCP support, and AI-powered API
interactions — which highlights how central this area is to the project's
roadmap. My early involvement with this issue gave me deep context into the
architectural decisions around MCP integration in the codebase, and directly
informed the PoC I built for this proposal.

**2. What is your one project/achievement that you are most proud of? Why?**
I am incredibly proud of taking the initiative to teach Artificial Intelligence concepts to government school students during my summer holidays, culminating in a comprehensive report and presentation. Technically, my proudest achievement was architecting the backend for the HeatBeasts eSports and gaming community platform during my internship. It required building scalable infrastructure, which taught me how to handle real-world user data and platform stability. 

**3. What kind of problems or challenges motivate you the most to solve them?**
I am motivated by architectural decoupling and bridging human-centric developer tools with AI workflows. I thrive on challenges that require taking tightly coupled systems (like a GUI application) and extracting the core logic to make it headless, programmable, and accessible to autonomous agents. Removing repetitive developer friction is my primary drive.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**
Yes, I will be dedicating my time full-time to GSoC. I will easily be able to commit the required 25-30 hours per week during the coding period.

**5. Do you mind regularly syncing up with the project mentors?**
Not at all. I highly value mentor feedback and believe regular syncs are crucial for course-correcting early, discussing architectural edge cases, and ensuring alignment with the project's broader vision.

**6. What interests you the most about API Dash?**
API Dash's evolution from a standard API client into an AI-native tool is fascinating. Reading through the GSoC 2025 reports by Manas and Udhay, I was highly impressed by the implementation of the `genai` package, the SDUI component generation, and Dashbot. API Dash is perfectly positioned to be the leading open-source tool for the AI engineering era, and I want to help build the infrastructure that pushes that vision forward.

**7. Can you mention some areas where the project can be improved?**
Currently, API Dash requires developers to break their workflow and context-switch to the Flutter GUI to execute or debug requests. It lacks a headless execution environment. By adding a CLI, we can enable CI/CD integrations. By adding an MCP server, we can allow IDE agents (like Cursor or Cline) to securely interact with the user's API Dash workspaces, generating tool calls or parsing responses without leaving the code editor.

---

### Project Proposal Information

**1. Proposal Title**
API Dash Headless Execution Engine: CLI & MCP Server Integration

**2. Abstract**
Currently, API Dash forces the developer to use the GUI to test the API. This project will allow a headless mode to be implemented by creating a new `apidash_cli` package in the Melos monorepo. This will allow a powerful Dart CLI to execute saved requests from the terminal itself, along with the implementation of a Model Context Protocol server using standard I/O. This will allow the existing `better_networking` package to be used to resolve the paths to access the local storage using the OS itself, allowing the AI agent to test the API autonomously using the existing API Dash workspaces.

**3. Detailed Description**

*Note: I have already built a working Proof of Concept (PoC) demonstrating a shared Dart execution engine running as both a CLI and an MCP server to validate this architecture.*

**System Architecture & Flow**
**System Architecture and Flow**
My architectural approach relies on the foundation laid during GSoC 2025 and prioritizes reuse over duplication.

* **Monorepo Integration:** I will add a new package at `packages/apidash_cli` and wire it into existing Melos workflows. This package will depend directly on `better_networking` to ensure consistency in request execution behavior.
* **Shared Runtime Layer:** Instead of duplicating business logic in both CLI and MCP handlers, I will create a shared headless runtime layer responsible for workspace resolution, request and environment loading, variable substitution, request execution handoff to `better_networking`, and response normalization.
* **Workspace Resolution Strategy:** In pure Dart (without Flutter's `path_provider`), workspace resolution will follow a deterministic order: explicit CLI flag, environment variable, saved workspace path from settings, then OS-specific fallback paths resolved using `dart:io`.
* **CLI Layer:** Built using `package:args`, exposing commands such as `apidash list`, `apidash run <request_id_or_name>`, and `apidash run-url` for ad-hoc requests.
* **MCP Server Layer:** Using `mcp_dart` over `stdio` transport, exposing tools such as `list_requests`, `get_request`, `execute_api_request`, and `list_environments`.

This architecture ensures one execution path across GUI, CLI, and MCP, reducing maintenance overhead and preventing behavior drift
<img width="1001" height="381" alt="Untitled Diagram drawio (2)" src="https://github.com/user-attachments/assets/cf5bdde0-4f28-4ebc-b822-73e986c3f9a9" />

**Proof of Concept (PoC) Implementation**
To validate the technical feasibility of this proposal, I have already built a fully functional Proof of Concept. 
* **Video Demo:** [Video](https://youtu.be/wIyiYdfZkH4?si=xTE112CmdBIRNHKb)

**What the PoC Demonstrates:**
1. **Headless Execution:** A pure Dart script that executes HTTP requests and parses responses without relying on the Flutter framework.
2. **Dual-Interface Capable:** The codebase successfully shares a core execution engine between a terminal CLI (using `package:args`) and an AI-facing server.
3. **Live MCP Integration:** Using `package:mcp_dart`, the PoC successfully registers an `execute_api_request` tool over `stdio`. In the linked demo, an AI agent (Cline) successfully discovers the tool, autonomously formats the JSON arguments, executes a live API call, and parses the response to answer a user's prompt without any manual intervention. 

<img width="863" height="214" alt="Screenshot 2026-03-22 135414" src="https://github.com/user-attachments/assets/0ddfbf63-88fd-4589-98b4-e60e901d3d57" />
<img width="370" height="753" alt="Screenshot 2026-03-22 144515" src="https://github.com/user-attachments/assets/6f2060d6-eba5-4dbb-9433-99944b529775" />

**Challenges & Solutions**

* **State Management and Hive Access without Flutter:** Since pure Dart CLI applications cannot rely on Flutter-only path helpers, the runtime will use deterministic workspace discovery:
  * Explicit CLI flag
  * Environment variable
  * Stored user settings path
  * OS fallback heuristics
  
  *This keeps the implementation reliable across desktop environments.*

* **Standardizing `stdio` for MCP:** Large API responses over `stdio` can create memory pressure and degrade responsiveness. 
  * **Mitigation:**
    * Response size limits
    * Truncation metadata
    * Output-to-file option for very large payloads
    * Structured error responses with stable codes

* **Security and Secret Hygiene:** CLI and MCP outputs will avoid accidental secret leakage by masking sensitive headers and tokens in logs and error traces.

**4. Weekly Timeline**

* **Community Bonding Period (May 8 - June 1)**
  Deep dive into the `better_networking` package and Hive models. Finalize the exact JSON schema for the MCP tools with mentors.

* **Week 1-2 (June 2 - June 15)**
  * Scaffold the `packages/apidash_cli` inside the Melos workspace. 
  * Implement the OS-level path resolution logic to successfully open and read the existing API Dash Hive boxes in a pure Dart environment.
  * **Deliverable:** A Dart script capable of printing a user's saved API Dash requests to the terminal.

* **Week 3-4 (June 16 - June 29)**
  * Develop the core CLI commands (`run`, `list`) using `package:args`. 
  * Connect the CLI to the `better_networking` layer to execute HTTP/GraphQL requests headlessly. 
  * **Deliverable:** A fully functioning CLI that can execute saved API Dash requests and print formatted responses.

* **Week 5-6 (June 30 - July 13)**
  * Polish the CLI output formatting (colors, tables). 
  * Ensure proper error handling, timeout configurations, and console logging. 
  * Write comprehensive unit tests for CLI parsing.
  * **Deliverable:** Production-ready CLI interface prepared for Mid-term evaluations.

* **Week 7-8 (July 14 - July 27)**
  * Implement the MCP server over `stdio` using `package:mcp_dart`. 
  * Define the `ToolInputSchema` for core capabilities like fetching workspace collections and executing specific API requests.
  * **Deliverable:** A standalone MCP server capable of receiving JSON RPC commands.

* **Week 9-10 (July 28 - August 10)**
  * Connect the MCP tools to the core CLI execution engine. 
  * Conduct integration testing by connecting the local API Dash MCP server to AI clients like Cursor, Cline, and Google Antigravity to verify autonomous execution.
  * **Deliverable:** End-to-end AI agent integration where an LLM can test an API via API Dash.

* **Week 11 (August 11 - August 17)**
  * Edge-case handling (e.g., bypassing basic WAFs via headers, handling massive JSON payloads over stdio).
  * Optimizing cold-start times for the CLI execution.

* **Week 12 (August 18 - August 24)**
  * Finalize documentation. Write a comprehensive guide on how developers can hook API Dash into their IDEs via MCP. 
  * Code cleanup and preparation of the final GSoC report.

---

### About Me & Past Projects

I am Vikash, a developer focused on full-stack systems and AI-integrated tooling. I strongly believe in learning by building and I actively seek projects that demand architecture-level problem solving. 

**Relevant Projects:**
* **HeatBeasts:** Developed the core infrastructure for an eSports and gaming community platform during my tech internship, managing complex real-time data states.
* **AI Video Summarization and Quiz Generation:** Developed an AI-powered pipeline capable of parsing video content to automatically generate structured summaries and interactive quizzes, giving me hands-on experience with LLM context windows and automated data extraction.
* **Crowd Management System:** Built an AI-driven crowd management and monitoring tool, demonstrating my ability to handle real-time data streams and deploy machine learning models for practical, high-impact use cases.
