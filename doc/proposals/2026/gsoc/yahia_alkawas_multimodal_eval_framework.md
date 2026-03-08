# GSoC 2026 Proposal: Multimodal AI and Agent API Eval Framework

* **Candidate:** Yahia (Yaya) Alkawas 
* **Project:** #2 - Multimodal AI and Agent API Eval Framework
* **Mentor:** animator

## Abstract
This project aims to develop an end-to-end evaluation framework within API Dash to benchmark Text, Image, and Voice AI models and Agents. The architecture focuses on a "dependency-lite" approach, ensuring the framework is easy to install for end-users while providing a professional, real-time benchmarking experience.

## Proposed Architecture
* **Frontend (React/TypeScript):** A dynamic UI for configuring request parameters and visualizing multimodal results.
* **Backend (Python):** A robust bridge to tools like `lm-harness` and `lighteval`.
* **Execution:** Utilizing Python's `subprocess` for background tasks and **Server-Sent Events (SSE)** for real-time log streaming to minimize user dependencies.

## Implementation Milestones (350 Hours)
* **Phase 1 (Weeks 1-4):** Designing unified TypeScript interfaces for multimodal data contracts and setting up the core Python benchmarking wrapper.
* **Phase 2 (Weeks 5-8):** Building the UI configuration suite for Voice and Image request parameters.
* **Phase 3 (Weeks 9-12):** Implementing AI Agent session-state tracking and final reporting exports.

## Experience
As a CS student at Cairo University and a security researcher at HackerOne, I have extensive experience building scalable, secure Full-Stack applications using Node.js, React, and Python.
