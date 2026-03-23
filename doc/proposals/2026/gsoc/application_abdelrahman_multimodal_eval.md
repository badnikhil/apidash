### About

1. Full Name: Abdelrahman Alkerdawy
2. Contact info (public email): [to be added before submission]
3. Discord handle in our server (mandatory): [to be added before submission]
4. Home page (if any): N/A
5. Blog (if any): N/A
6. GitHub profile link: https://github.com/KERDAWY-2
7. Twitter, LinkedIn, other socials: N/A
8. Time zone: Africa/Cairo (UTC+2, EET)
9. Link to a resume (PDF, publicly accessible via link and not behind any login-wall): [to be added before submission]

### University Info

1. University name: [Egyptian University - to be added before submission]
2. Program you are enrolled in: B.Sc. in Communication and Information Engineering
3. Year: 3rd year
4. Expected graduation date: 2027

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**
   I have been building open-source projects on GitHub (https://github.com/KERDAWY-2). I have recently started contributing to API Dash by exploring the codebase and engaging with the community on Issues and Discussions.

2. **What is your one project/achievement that you are most proud of? Why?**
   My graduation project: an infrastructure defect detection system using CNNs and YOLO object detection models, with a Flutter frontend and a Python/FastAPI backend. I am proud of it because it combines my skills in ML, mobile development, and backend engineering into a real-world application that solves an engineering problem.

3. **What kind of problems or challenges motivate you the most to solve them?**
   I am most motivated by problems that sit at the intersection of AI and developer tooling — where building the right abstraction or interface can dramatically improve how engineers work. Evaluation and observability of AI systems is especially interesting to me because it is a hard, unsolved problem with real impact.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**
   I will be a 4th-year university student during the GSoC period. I will be attending university alongside GSoC but I plan to dedicate a substantial portion of my time (30+ hours/week) to the project. I do not have other full-time commitments during the summer semester.

5. **Do you mind regularly syncing up with the project mentors?**
   Not at all. I welcome regular syncs and am comfortable communicating via Discord, GitHub, or video calls.

6. **What interests you the most about API Dash?**
   API Dash is uniquely positioned as a cross-platform developer tool that is embracing AI and agentic workflows early. The combination of Flutter for the client and Python/Node for AI backends means I can contribute meaningfully using my existing skill set. The focus on AI API evaluation is particularly relevant to my background in ML.

7. **Can you mention some areas where the project can be improved?**
   - The Multimodal AI eval framework is largely missing and would significantly increase API Dash's value for AI developers.
   - Better support for evaluating structured outputs and agent tool-call responses.
   - A dataset management interface for managing test inputs for AI API evaluations.

8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**
   - Commented on Issue #1269 (Revamp Model Selector dialog): https://github.com/foss42/apidash/issues/1269
   - Posted introductory comment on Discussion #1048 (GSoC Application Guide): https://github.com/foss42/apidash/discussions/1048
   - Commented on Discussion #1054 (GSoC List of Ideas): https://github.com/foss42/apidash/discussions/1054

### Project Proposal Information

1. **Proposal Title:** Multimodal AI and Agent API Eval Framework

2. **Abstract:**
   API Dash currently lacks a structured way to evaluate AI API responses beyond viewing raw output. This project will build an end-to-end evaluation framework inside API Dash that allows developers to configure AI API requests with custom datasets, send queries to various AI services (text, image, voice, agent APIs), and view evaluation results through an intuitive UI. The framework will support standard benchmarks (e.g., lm-harness, lighteval) and be extensible to support AI agent evaluation via tool-call inspection.

3. **Detailed Description:**

   **Problem Statement:**
   Developers building AI-powered applications need to evaluate their AI APIs against ground truth datasets, across multiple models, and across different modalities (text, image, voice). Today, this requires stitching together external tools with no unified interface. API Dash is the right place to solve this.

   **Proposed Solution:**

   The framework will consist of the following components:

   **a) Dataset Manager**
   - Upload or import test datasets (CSV, JSON, JSONL) with input/expected-output pairs.
   - Manage datasets within the API Dash workspace.

   **b) Eval Request Configuration UI**
   - Extend the existing AI request UI to allow users to select a dataset and map fields to API request parameters.
   - Support text, image (base64/URL), and audio inputs for multimodal models.
   - Configure multiple AI providers (OpenAI, Gemini, Anthropic, Ollama, etc.) for side-by-side comparison.

   **c) Eval Runner**
   - A Python-based eval runner (compatible with lm-harness / lighteval interfaces) that executes the dataset against the configured API.
   - Runs as a local background service accessible from the Flutter client.
   - Supports concurrent execution with progress streaming.

   **d) Results & Metrics UI**
   - Display evaluation results per example (input, expected output, actual output, pass/fail).
   - Aggregate metrics: accuracy, BLEU, ROUGE, exact match, or custom metric scripts.
   - Support exporting results as CSV/JSON.

   **e) Agent Eval Support**
   - For agent APIs: inspect tool-call chains, validate intermediate steps, and check final outputs.
   - Support MCP tool call evaluation.

   **Tech Stack:**
   - Flutter/Dart for the UI components
   - Python (FastAPI) for the eval runner service
   - Integration with lm-harness / lighteval for standard benchmarks

4. **Weekly Timeline:**

   **Week 1-2 (Community Bonding):**
   - Deep dive into the API Dash codebase, especially the AI request flow and existing DashBot logic.
   - Study lm-harness and lighteval APIs.
   - Finalize architecture with mentors.
   - Set up local dev environment and run all existing tests.

   **Week 3-4:**
   - Implement the Dataset Manager: data models, import logic (CSV/JSON/JSONL), and basic Dart UI for dataset listing and upload.

   **Week 5-6:**
   - Build the Eval Request Configuration UI: extend the AI request panel to support dataset binding and field mapping.
   - Support text and image input types.

   **Week 7-8:**
   - Implement the Python eval runner service (FastAPI).
   - Integrate with OpenAI-compatible APIs for batch evaluation.
   - Stream progress updates to the Flutter client.

   **Week 9-10:**
   - Build the Results & Metrics UI: per-example results table, aggregate metrics display.
   - Implement export functionality (CSV/JSON).

   **Week 11-12:**
   - Add support for voice/audio input evaluation.
   - Begin agent eval support: tool-call chain inspection.

   **Week 13 (Buffer/Polish):**
   - Bug fixes, UI polish, documentation.
   - Write tests for critical paths.
   - Prepare final submission and report.

   **Week 14 (Final Evaluation):**
   - Code freeze, final PR review, submit to GSoC portal.
