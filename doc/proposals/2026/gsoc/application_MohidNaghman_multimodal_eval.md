# API Dash: Multimodal AI and Agent API Evaluation Framework

## GSoC 2026 Proposal

---

## Contact Information

| Field              | Details                                    |
| ------------------ | ------------------------------------------ |
| **Applicant Name** | Mohid Naghman                              |
| **Email**          | mohid.naghman@email.com                    |
| **GitHub**         | https://github.com/MohidNaghman1           |
| **LinkedIn**       | https://www.linkedin.com/in/mohid-naghman/ |
| **Location**       | Lahore, Pakistan                           |
| **Time Zone**      | PKT (UTC+5)                                |
| **Organization**   | API Dash                                   |
| **Project Size**   | 175 hours (GSoC Medium)                    |
| **Difficulty**     | Medium-High                                |
| **Primary Mentor** | @animator (API Dash Lead)                  |

---

## 1. Executive Summary

Developers and ML teams struggle with a fragmented evaluation landscape: comparing LLM outputs across providers requires custom scripts, benchmarking image/voice models lacks a unified interface, and no tool provides real-time insights into multi-modal AI performance without heavy DevOps overhead.

**API Dash Multimodal Evaluation Framework** solves this by providing an **intuitive, integrated platform** where developers can:

- Configure AI benchmark evaluations through an intuitive UI (no code required)
- Test text, image, and voice models simultaneously across multiple providers
- Stream real-time evaluation progress with Server-Sent Events (SSE)
- Compare model performance with production-grade metrics (BLEU, ROUGE, custom plugins)
- Export findings as reports (JSON, CSV, PDF)

By integrating existing benchmark frameworks (lm-harness, lighteval) through a streamlined API layer, this project **democratizes AI evaluation for teams lacking ML infrastructure expertise**.

**Target Timeline**: 13 weeks, 175 hours
**Architecture**: FastAPI (async Python backend) + React/TypeScript (frontend) + ChromaDB (benchmark indexing)

---

## 2. Problem Statement

### Current Landscape Issues

**Problem 1: Fragmented Evaluation Tooling**

- Researchers use `lm-harness` directly (CLI-heavy, not user-friendly)
- Product teams write custom Python scripts for each API provider
- No unified interface for text → image → voice evaluation pipeline
- Result: **Duplicate effort, 20+ hours per evaluation cycle per team**

**Problem 2: Multimodal Evaluation Complexity**

- Text benchmarks (BLEU, ROUGE) are standardized
- Image evaluation (captioning, VQA) requires different task formats
- Voice models need separate ingestion pipelines
- No framework handles all three seamlessly
- Result: **ML teams default to text-only testing, missing critical modalities**

**Problem 3: Real-time Observability Gap**

- Benchmark runs on 1,000+ prompts = 10+ minute waits
- No progress feedback (black box execution)
- If infrastructure fails mid-run, entire evaluation lost
- Result: **Poor developer experience, low iteration velocity**

**Problem 4: Multi-provider Fragmentation**

- OpenAI API ≠ Together.ai ≠ Groq ≠ Local models (different request/response formats)
- Teams maintain provider-specific wrappers
- Switching providers requires code changes, not config changes
- Result: **Lock-in to single provider, inability to compare costs/latency/quality**

### Why This Matters for API Dash

API Dash already powers REST/GraphQL/gRPC testing. **Evaluation is the natural next step**: developers test APIs → now evaluate AI performance on those APIs.

By solving this, API Dash becomes the **all-in-one platform for API-to-AI workflow testing**.

---

## 3. Solution Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    API Dash Platform                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        React/TypeScript Frontend (SSR)              │  │
│  │  ┌──────────────┬──────────────┬──────────────┐     │  │
│  │  │  Benchmark   │  Dataset     │  Model       │     │  │
│  │  │  Selector    │  Uploader    │  Configurator│     │  │
│  │  └──────────────┴──────────────┴──────────────┘     │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │   Real-time Execution Monitor (SSE)         │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │   Results Dashboard (Leaderboard, Charts)    │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕ (SSE + REST)                     │
│  ┌──────────────────────────────────────────────────────┐  │
│  │       FastAPI Backend (Async Python)                │  │
│  │  ┌──────────────┬──────────────┬──────────────┐     │  │
│  │  │ Benchmark    │  Multimodal  │  Metrics     │     │  │
│  │  │ Runner       │  Adapter     │  Compute     │     │  │
│  │  └──────────────┴──────────────┴──────────────┘     │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  Provider Orchestrator (OpenAI/Groq/etc)    │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  │  ┌──────────────────────────────────────────────┐   │  │
│  │  │  Plugin System (Custom Metrics)              │   │  │
│  │  └──────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕ (File I/O)                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Data Layer (SQLite + Local File Storage)           │  │
│  │  ├─ Evaluation History                             │  │
│  │  ├─ Cached Datasets                                │  │
│  │  └─ Results Archive                                │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕ (Wrapper)                        │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Benchmark Frameworks (Read-only Integration)       │  │
│  │  ├─ lm-harness (subprocess orchestration)          │  │
│  │  └─ lighteval (library integration)                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Core Components

#### A. Backend: FastAPI Evaluation Engine

**Purpose**: Orchestrate benchmark runs, stream progress, compute metrics

```python
# Pseudo-architecture
FastAPI App
├── /api/benchmarks
│   └── GET - List available benchmarks (lm-harness tasks, custom)
├── /api/evaluations
│   ├── POST - Create new evaluation run
│   ├── GET /{id} - Fetch evaluation status/metadata
│   └── SSE /stream/{id} - Stream real-time progress + logs
├── /api/results/{id}
│   ├── GET - Fetch computed metrics (BLEU, ROUGE, latency, cost)
│   └── GET /export - Export as JSON/CSV
├── /api/datasets
│   ├── POST /upload - Accept text/image/audio files
│   └── GET - List cached datasets
└── /api/models
    ├── GET - Available model providers (OpenAI, Groq, Together.ai, local)
    └── POST /configure - Store API keys securely

# Worker Processes (asyncio + concurrent.futures)
├── BenchmarkRunner
│   ├── Wraps lm-harness CLI via subprocess
│   └── Wraps lighteval library directly
├── MultimodalAdapter
│   ├── TextEvaluator (BLEU, ROUGE, Exact Match)
│   ├── ImageEvaluator (VQA, Captioning tasks)
│   └── VoiceAdapter (foundation for future phases)
├── ProviderOrchestrator
│   ├── OpenAI provider handler
│   ├── Groq provider handler
│   ├── Together.ai provider handler
│   └── LocalModel provider handler
└── MetricsEngine
    ├── Standard metrics compute
    ├── Plugin loader for custom metrics
    └── Confidence scoring + aggregation
```

**Key Features**:

- Async + Concurrent: Evaluate 10 models in parallel (not sequentially)
- SSE Streaming: Real-time benchmark progress (no blocking waits)
- Job Persistence: SQLite stores evaluation history + recovery
- Provider Abstraction: Swap providers without changing benchmark logic
- Extensible Metrics: Plugin system allows custom scoring functions

#### B. Frontend: React/TypeScript Dashboard

**Tab 1: Benchmark Configuration**

```
┌─────────────────────────────────────────┐
│  Benchmark Selector (Dropdown)          │
│  └─ Standard Benchmarks (GLUE, SQuAD)   │
│  └─ Custom Uploads (user-defined)       │
│                                         │
│  Dataset Uploader (Drag-drop)           │
│  ├─ Accept: .csv, .json, .txt           │
│  ├─ Preview: First 5 rows               │
│  └─ Format validation ✓                 │
│                                         │
│  Model Configurator (Multi-select)      │
│  ├─ OpenAI GPT-4, GPT-3.5              │
│  ├─ Groq Llama-3-70B                   │
│  ├─ Together.ai API                    │
│  └─ Local Models (Ollama)              │
│                                         │
│  Parameters (Collapsible)               │
│  ├─ Temperature: [0.0 - 2.0]           │
│  ├─ Max Tokens: [1 - 4096]             │
│  └─ Top-p: [0.0 - 1.0]                 │
│                                         │
│  [START EVALUATION] Button              │
└─────────────────────────────────────────┘
```

**Tab 2: Real-time Execution Monitor**

```
┌─────────────────────────────────────────────┐
│  Progress: [████████░░] 80% (800/1000)     │
│  Elapsed: 5m 30s | ETA: 1m 30s            │
│                                            │
│  Live Logs (Scrollable, Auto-tail):        │
│  ───────────────────────────────────       │
│  [12:45:32] Starting evaluation...        │
│  [12:45:35] Loaded 1000 samples           │
│  [12:45:40] Running Model 1 (GPT-4)...    │
│  [12:46:15] Model 1 complete: BLEU=87.3   │
│  [12:46:20] Running Model 2 (Llama-3)...  │
│  ───────────────────────────────────       │
│                                            │
│  [PAUSE] [STOP] [EXPORT LOGS]             │
└─────────────────────────────────────────────┘
```

**Tab 3: Results Analysis Dashboard**

```
┌──────────────────────────────────────────────────┐
│                                                  │
│  METRIC LEADERBOARD                              │
│  ┌──────────────────────────────────────────┐   │
│  │ Model          BLEU  ROUGE  Latency Cost  │   │
│  │ GPT-4          92.1  85.5  120ms   $0.03  │   │
│  │ Llama-3-70B    88.7  82.1  45ms    $0.001 │   │
│  │ GPT-3.5-Turbo  85.4  78.9  60ms    $0.001 │   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  COMPARISON CHARTS (Side-by-side)                │
│  ┌─────────────┐  ┌─────────────┐               │
│  │  Quality    │  │  Speed      │               │
│  │   ╱╲╱╲      │  │   ╲╱╲╱      │               │
│  │ ╱   ╲      │  │  ╱       ╲   │               │
│  └─────────────┘  └─────────────┘               │
│                                                  │
│  SAMPLE OUTPUTS (Comparison)                     │
│  ┌──────────────────────────────────────────┐   │
│  │ Input: "What is photosynthesis?"         │   │
│  │                                          │   │
│  │ GPT-4: [Output preview + citation info]  │   │
│  │ Llama-3: [Output preview + citation info]│   │
│  │ GPT-3.5: [Output preview + citation info]│   │
│  └──────────────────────────────────────────┘   │
│                                                  │
│  [EXPORT TO PDF] [EXPORT TO JSON]               │
└──────────────────────────────────────────────────┘
```

**State Management**: Zustand (lightweight, intuitive)

```javascript
// stores/evaluationStore.ts
- activeTab: "configure" | "execute" | "analyze"
- selectedBenchmark: Benchmark
- selectedModels: Model[]
- evaluationProgress: number (0-100)
- results: EvaluationResult
- isStreaming: boolean
```

#### C. Data Flow: SSE Streaming

```
User clicks "START EVALUATION"
    ↓
React sends POST /api/evaluations
    ↓
FastAPI creates job, returns job_id
    ↓
React opens SSE connection: /api/evaluations/{id}/stream
    ↓
Backend spawns async task
    ↓
Each benchmark iteration sends event:
{
  "type": "progress",
  "model": "GPT-4",
  "current": "Testing prompt 450/1000",
  "progress": 45,
  "metrics": {"BLEU": 87.3, "latency_ms": 125},
  "timestamp": "2026-03-26T12:45:32Z"
}
    ↓
Frontend updates progress bar + logs in real-time
    ↓
When complete, backend sends:
{
  "type": "complete",
  "summary": {...},
  "results_url": "/api/results/{id}"
}
    ↓
Frontend closes SSE connection, loads results tab
```

#### D. Data Schema

```python
# Benchmark dataset - unified schema
class DatasetItem(BaseModel):
    id: str                    # unique identifier
    modality: Literal["text", "image", "voice"]
    input_data: Union[str, bytes]  # text string or file path
    input_url: Optional[str]   # remote URL for images
    expected_output: Optional[str]  # gold standard (for eval)
    metadata: Dict             # task-specific metadata

# Evaluation configuration
class EvaluationConfig(BaseModel):
    benchmark_id: str
    dataset_id: str
    models: List[ModelConfig]
    metrics: List[str]         # ["BLEU", "ROUGE", "custom_metric"]
    max_concurrent: int = 4    # parallel model runs
    timeout_per_task: int = 60 # seconds

# Results
class EvaluationResult(BaseModel):
    id: str
    benchmark_id: str
    models: Dict[str, ModelResult]
    aggregate_metrics: Dict[str, float]
    completed_at: datetime
    leaderboard: List[LeaderboardEntry]
```

---

## 4. Phase-by-Phase Implementation Plan

### Phase 1: Foundation & Backend Setup (Weeks 1-3, 52 hours)

**Goals**: Core backend infrastructure, evaluation runner, SSE streaming

**Tasks**:

- [ ] FastAPI project scaffold + async architecture
- [ ] SQLite schema design (evaluations, results, cache)
- [ ] lm-harness CLI wrapper (subprocess orchestration)
- [ ] lighteval library integration (direct API calls)
- [ ] Benchmark discovery system (list available tasks)
- [ ] SSE streaming setup + event serialization
- [ ] Docker setup + local development environment

**Deliverables**:

- Working FastAPI backend at `/api/benchmarks` endpoint
- Manual CLI test: `python -m backend.runner --benchmark glue-qa --dataset sample.json`
- SSE streaming verified: Real-time progress events to console
- Docker image builds locally without errors

**Testing**: 80% unit test coverage (benchmark runner, parsing logic)

**Estimated Hours**: 52h

- API scaffolding: 8h
- lm-harness integration: 16h
- SSE + streaming: 12h
- Docker + dev setup: 8h
- Testing: 8h

---

### Phase 2: Text Evaluation & Multi-Provider Support (Weeks 4-6, 48 hours)

**Goals**: Production text evaluation with standard metrics, multi-provider LLM integration

**Tasks**:

- [ ] Standard metrics implementation (BLEU, ROUGE, Exact Match)
- [ ] OpenAI provider handler (gpt-4, gpt-3.5-turbo)
- [ ] Groq provider handler (Llama 3 with API rate limiting)
- [ ] Together.ai provider handler
- [ ] Local model support (Ollama integration)
- [ ] Provider abstraction layer (unified request/response format)
- [ ] Concurrent model execution (asyncio + thread pool)
- [ ] Request deduplication + caching
- [ ] Cost calculation per API call

**Deliverables**:

- End-to-end text evaluation working via API
- Deploy test: Eval 3 models on 100-sample benchmark, export metrics
- Cost tracking: "Total cost: $1.23 (OpenAI) + $0.02 (Groq)"
- Performance benchmark: 1000 prompts across 3 models in <20 minutes

**Testing**: 85% unit test coverage (provider handlers, metrics)

**Estimated Hours**: 48h

- Metrics implementation: 12h
- Provider handlers (4): 20h
- Concurrent execution: 8h
- Testing + cost tracking: 8h

---

### Phase 3: Multimodal Support (Image) (Weeks 7-9, 48 hours)

**Goals**: Image evaluation tasks (VQA, captioning), unified dataset handling

**Tasks**:

- [ ] Image dataset schema + validation
- [ ] Image upload/storage (local + S3 URL support)
- [ ] VQA benchmark integration (Visual Question Answering)
- [ ] Image captioning task support
- [ ] Image preprocessing (resizing, format conversion)
- [ ] Multimodal metric adapters (METEOR, CIDEr for captions)
- [ ] React UI: Image dataset uploader with preview
- [ ] React UI: Image-specific evaluation dashboard
- [ ] Voice API layer foundation (models + schema, no runner yet)

**Deliverables**:

- Image evaluation working end-to-end (upload images → get VQA outputs → metrics)
- Deploy test: VQA benchmark with 50 images across 2 models
- React dashboard extended: supports text + image tabs
- Documentation: How to upload image datasets

**Testing**: 85% coverage (image adapters, preprocessing)

**Estimated Hours**: 48h

- Image handling + storage: 12h
- VQA/captioning integration: 14h
- Multimodal metrics: 8h
- React UI extensions: 10h
- Documentation: 4h

---

### Phase 4: Plugin System & Production Hardening (Weeks 10-13, 27 hours)

**Goals**: Custom metrics, production deployment, documentation

**Tasks**:

- [ ] Plugin system for custom metrics (extensible scoring functions)
- [ ] Plugin loader + validation
- [ ] 99% unit test coverage (targeting Phase 1-3)
- [ ] Integration tests (end-to-end flows)
- [ ] API documentation (OpenAPI/Swagger)
- [ ] User guide (how to run evaluations)
- [ ] Deployment guide (Docker + GitHub Actions)
- [ ] Performance optimization (caching, batch processing)
- [ ] Error handling + retry logic
- [ ] Production GitHub Actions CI/CD pipeline
- [ ] Live deployment (Render or similar)

**Deliverables**:

- System achieves 99%+ test coverage
- OpenAPI docs published at `/docs`
- Live instance running at `api-dash-eval.render.com`
- Community can write custom metrics without modifying core
- Deployment reproducible via single `docker compose up`

**Testing**: 99% coverage across all phases

**Estimated Hours**: 27h

- Plugin system: 8h
- Testing + coverage gap closure: 8h
- Documentation: 6h
- Deployment + optimization: 5h

---

## 5. Technology Stack

### Backend

| Component           | Technology                    | Why                                                       |
| ------------------- | ----------------------------- | --------------------------------------------------------- |
| **Framework**       | FastAPI                       | Async-native, SSE support, auto-OpenAPI docs              |
| **Runtime**         | Python 3.11+                  | ML ecosystem, benchmark tool compatibility                |
| **Async**           | asyncio + concurrent.futures  | Parallel model evaluation                                 |
| **Database**        | SQLite                        | Zero-config, no external services, sufficient for history |
| **Streaming**       | Server-Sent Events (SSE)      | Simpler than WebSocket, unidirectional (perfect for logs) |
| **Benchmark Tools** | lm-harness, lighteval         | Industry-standard, actively maintained                    |
| **Provider SDKs**   | openai, together, groq        | Official libraries for API calls                          |
| **Metrics**         | nltk, rouge_score, bert-score | Standard NLP metric libraries                             |
| **Storage**         | Local filesystem              | Images/voice files stored locally or S3 URL references    |

### Frontend

| Component         | Technology                     | Why                                     |
| ----------------- | ------------------------------ | --------------------------------------- |
| **Framework**     | React 18+                      | Component-based, performance, ecosystem |
| **Language**      | TypeScript                     | Type safety, better DX                  |
| **State Mgmt**    | Zustand                        | Lightweight, intuitive, no boilerplate  |
| **UI Components** | shadcn/ui + Tailwind CSS       | Production-ready, accessible, themable  |
| **Charts/Graphs** | Recharts                       | React-friendly, responsive              |
| **HTTP Client**   | axios + SSE client             | Promise-based, event stream support     |
| **Build Tool**    | Vite                           | Fast HMR, small bundle size             |
| **Testing**       | Vitest + React Testing Library | Fast, React-focused                     |

### Infrastructure

| Component            | Technology     | Why                                                    |
| -------------------- | -------------- | ------------------------------------------------------ |
| **Containerization** | Docker         | Reproducible deployment                                |
| **CI/CD**            | GitHub Actions | Native GitHub integration, free                        |
| **Deployment**       | Render/Railway | Easy Flask-like deployment, free tier                  |
| **Monitoring**       | Simple logging | File-based logs for MVP, can extend with Datadog later |

### Why NO Redis/Celery?

- **Scope constraint**: 175 hours, MVP focus
- **SQLite sufficient**: Job history + status tracking
- **Async FastAPI**: Built-in concurrency without Celery
- **Can extend later**: Redis/Celery added post-GSoC if needed

---

## 6. Why I'm Suited to Build This

### Technical Expertise

**Generative AI & LLM Systems** ✅

- 4 production AI systems (RAG pipelines, multi-agent workflows, LLM evaluation)
- Deep experience: LangChain, LangGraph, Groq API, prompt engineering
- Built evaluation pipelines for accuracy, latency, cost metrics

**Backend Architecture** ✅

- FastAPI expert: async endpoints, SSE streaming, WebSockets
- Designed scalable systems handling concurrent API calls
- Database design: PostgreSQL, vector stores, cache layers
- Production deployment: Docker, GitHub Actions, cloud platforms

**Full-Stack Development** ✅

- React/TypeScript for production dashboards
- Built 4+ full-stack systems (backend → frontend → deployment)
- Accessibility standards (WCAG 2.1 AA)
- Performance optimization: 90%+ test coverage, load testing

**Testing & Quality** ✅

- Maintained 90%+ unit test coverage in production systems
- Integration testing, CI/CD pipeline setup
- Knows how to scope MVP vs nice-to-have features

**Proven GSoC Experience** ✅

- Just completed GA4GH-RegBot GSoC proposal (175 hours, shipped)
- Understands GSoC timebox constraints and delivery expectations
- Knows how to break work into weekly milestones

### Why This Project Fits My Goals

1. **Depth**: Multimodal evaluation framework exercises all my skills (AI + backend + frontend + DevOps)
2. **Impact**: 1000s of ML teams will use this → meaningful contribution to open source
3. **Learning**: Exposure to benchmark frameworks (lm-harness, lighteval) extends ML infrastructure knowledge
4. **Scope**: 175 hours aligns perfectly (not too small, not scope-creep)

---

## 7. Post-GSoC Commitment

**Maintenance Window**: 6 months (post-GSoC)

- Bug fixes for submitted code
- Security updates
- Community support (GitHub issues, Discord)
- Mentoring incoming contributors

**Long-term Contributions**:

- Voice evaluation implementation (Phase 4 future work)
- Distributed evaluation (Redis Celery for massive benchmarks)
- Agent evaluation workflows (separate project, but compatible)
- Community blog posts: "Building Production-Grade Evaluation Frameworks"

**Knowledge Transfer**:

- Architecture documentation: Design decisions + alternatives considered
- Video tutorial: "Getting Started with API Dash Evaluation"
- Weekly sync with team to ensure smooth handoff

---

## 8. Detailed 13-Week Timeline

### Week 1: Planning & Setup

- [ ] Set up FastAPI project skeleton
- [ ] Design SQLite schema
- [ ] Explore lm-harness CLI (manual runs)
- [ ] Explore lighteval library (API exploration)
- **Deliverable**: Development environment ready, benchmark tools understood
- **CheckPoint**: FastAPI server runs on http://localhost:8000

### Week 2: Benchmark Integration

- [ ] Implement lm-harness subprocess wrapper
- [ ] Implement lighteval library integration
- [ ] Create benchmark discovery system
- [ ] First benchmark running via Python API
- **Deliverable**: Two benchmark sources (lm-harness + lighteval) working
- **CheckPoint**: Can list and execute a benchmark from Python code

### Week 3: SSE Streaming & Foundation

- [ ] Implement SSE endpoint in FastAPI
- [ ] Design evaluation job schema + SQLite
- [ ] Create job manager (create, retrieve, stream)
- [ ] Test SSE with manual client
- **Deliverable**: Real-time streaming working end-to-end
- **CheckPoint**: "python client.py" receives live progress events

### Week 4: Text Metrics Implementation

- [ ] Implement BLEU scoring
- [ ] Implement ROUGE scoring
- [ ] Implement Exact Match
- [ ] Create metrics aggregator
- **Deliverable**: Standard metrics calculated correctly
- **CheckPoint**: Metrics match reference implementations

### Week 5: Multi-Provider Backend

- [ ] OpenAI provider handler (gpt-4, gpt-3.5)
- [ ] Groq provider handler (Llama 3)
- [ ] Provider abstraction layer (unified request/response)
- [ ] Start concurrent execution
- **Deliverable**: Two providers working
- **CheckPoint**: Can send same prompt to OpenAI and Groq, get results

### Week 6: Completion of Phase 2

- [ ] Together.ai provider
- [ ] Local model (Ollama) provider
- [ ] Full concurrent execution (4 models in parallel)
- [ ] Cost calculation + tracking
- [ ] Integration testing
- **Deliverable**: Full text evaluation pipeline
- **CheckPoint**: Demo: 100-sample evaluation across 3 providers, <5 minutes

### Week 7: React Frontend - Configuration Tab

- [ ] Project scaffold (Vite + React + TypeScript)
- [ ] Benchmark selector UI
- [ ] Dataset uploader (text files, drag-drop)
- [ ] Model selector (multi-select)
- [ ] Parameter configurator (temperature, etc.)
- **Deliverable**: Beautiful configuration UI
- **CheckPoint**: Can fill out evaluation config form

### Week 8: React Frontend - Execution Monitor

- [ ] SSE client setup (connect to backend stream)
- [ ] Real-time progress bar
- [ ] Live log viewer (auto-scroll)
- [ ] ETA calculation
- [ ] Pause/Stop buttons
- **Deliverable**: Real-time monitoring UI
- **CheckPoint**: See live progress while backend evaluates

### Week 9: React Frontend - Results Dashboard

- [ ] Leaderboard table (models ranked by metrics)
- [ ] Comparison charts (Recharts)
- [ ] Sample output viewer (side-by-side model responses)
- [ ] Export buttons (JSON, CSV)
- [ ] Navigation between tabs
- **Deliverable**: Complete results analysis interface
- **CheckPoint**: Full end-to-end flow works (config → execute → analyze)

### Week 10: Image Evaluation Foundation

- [ ] Image dataset schema + validation
- [ ] Image uploader (React + backend)
- [ ] VQA benchmark foundational support
- [ ] Image storage (local filesystem)
- **Deliverable**: Can upload and store images
- **CheckPoint**: Images persist and can be retrieved

### Week 11: Image Evaluation Completion

- [ ] VQA metric adapters (METEOR, CIDEr)
- [ ] Image-specific evaluation flow
- [ ] React UI: Image evaluation tab
- [ ] End-to-end image eval test
- **Deliverable**: Text + Image evaluation both working
- **CheckPoint**: Demo image evaluation on public image dataset

### Week 12: Plugin System & Testing

- [ ] Custom metric plugin architecture
- [ ] Plugin loader + validation
- [ ] Comprehensive test suite (90%+ coverage)
- [ ] Integration tests (end-to-end flows)
- [ ] Documentation writing begins
- **Deliverable**: Plugin system extensible
- **CheckPoint**: Community member can write custom metric in <30 min

### Week 13: Production & Deployment

- [ ] Production hardening (error handling, retries)
- [ ] OpenAPI documentation generation
- [ ] GitHub Actions CI/CD pipeline
- [ ] Docker image creation + testing
- [ ] Deploy to Render (live instance)
- [ ] User guide + API docs
- **Deliverable**: Production-ready system
- **CheckPoint**: System live at public URL, all docs published

---

## 9. Key Features & Deliverables

### Core Features Shipped

**Benchmark Orchestration**

- Integrates lm-harness + lighteval
- Discovery of 50+ standard benchmarks
- Custom benchmark upload support

**Multi-Provider LLM Support**

- OpenAI, Groq, Together.ai, local models
- Unified request/response abstraction
- Concurrent evaluation (4 models in parallel)

**Text Evaluation**

- Standard metrics: BLEU, ROUGE, Exact Match
- Custom metric plugins
- Cost + latency tracking

**Multimodal Foundation (Text + Image)**

- Text evaluation (Phase 2)
- Image evaluation (VQA, captioning) (Phase 3)
- Voice API layer (foundation for Phase 4)

**Real-time Monitoring**

- SSE streaming progress
- Live log viewer
- ETA estimation

**Results Dashboard**

- Model leaderboard
- Interactive comparison charts
- Export (JSON, CSV, PDF)

**Developer Experience**

- OpenAPI documentation
- Deployment guide (Docker + CI/CD)
- Community-friendly plugin system
- Full test coverage (99%+)

### Metrics of Success

| Metric               | Target                              | Evidence                        |
| -------------------- | ----------------------------------- | ------------------------------- |
| **Eval Speed**       | 1000 prompts / 3 models in <20min   | Load test results               |
| **Test Coverage**    | 99%+ pass rate                      | pytest output + codecov badge   |
| **Documentation**    | Every endpoint + feature documented | OpenAPI + user guide            |
| **Production Ready** | Deploy in <5 minutes                | Docker compose up + verify live |
| **Community Ready**  | Beginner can write custom metric    | Blog post + video tutorial      |

---

## 10. Risk Mitigation

| Risk                                  | Probability | Impact | Mitigation                                                |
| ------------------------------------- | ----------- | ------ | --------------------------------------------------------- |
| **lm-harness API breaks during GSoC** | Medium      | High   | Keep subprocess wrapper, build abstraction layer early    |
| **Scope creep on multimodal**         | High        | Medium | Define MVP (text + image), defer voice to Phase 4         |
| **SSE streaming complexity**          | Medium      | Medium | Prototype Week 3, use battle-tested libraries             |
| **Provider rate limits**              | Medium      | Low    | Implement backoff + request queuing                       |
| **React TypeScript learning curve**   | Low         | Low    | Use component library (shadcn), proven patterns           |
| **GSoC timeline pressure**            | Medium      | High   | Weekly check-ins with mentor, aggressive scope management |

---

## 11. Competitive Differentiation

### What Competitors Miss

| Competitor              | Approach                       | Gap                                          | Our Solution                               |
| ----------------------- | ------------------------------ | -------------------------------------------- | ------------------------------------------ |
| **Spark960 (PR #1136)** | Tauri + React + SSE            | Tauri adds complexity; no async concurrency  | Native FastAPI + concurrent evaluation     |
| **Armaan Saxena**       | "Python + React split" (vague) | No architecture                              | Detailed phases + proven patterns          |
| **James-ezechinyere**   | Flutter-native UI              | Locks to API Dash codebase                   | Standalone MVP, API Dash integration later |
| **Abdul (KERDAWY-2)**   | Flutter + FastAPI + SSE        | Flutter required learning; less web-friendly | React/TypeScript (web-first design)        |

### Our Competitive Edges

1. **Async Concurrency**: Evaluate 4 models in parallel → faster insights
2. **Plugin System**: Custom metrics from day 1 → extensible from launch
3. **Production Quality**: 99%+ test coverage → reliable foundation
4. **Full-stack Expertise**: Backend + frontend + DevOps → cohesive product
5. **Clear Scoping**: 175h fit → focused, shippable, not scope-creep

---

## 12. Engagement with Community

### Weekly Synchronization

- Attend API Dash weekly connect calls (Thursdays)
- Post weekly progress updates on #1226 discussion thread
- Respond to open questions within 24 hours

### Mentorship

- Communicate primarily with @animator (lead)
- Escalate technical blockers to full mentor team (Ankit, Ashita, Ragul, Manas)
- Monthly 1:1 sync to discuss learnings + future direction

### Community Collaboration

- Reference existing work (Spark960's diagrams, others' questions)
- Build on lm-harness/lighteval docs (not re-inventing)
- Contribute upstream fixes (if benchmarks have bugs discovered)

---

## 13. How Success Looks

### End of Week 13

```
Production System
   ├─ API at api-dash-eval.render.com
   ├─ React dashboard deployed
   ├─ 1000s of benchmarks available
   ├─ 50+ community tests passing
   └─ OpenAPI docs published

Code Quality
   ├─ 99%+ test coverage
   ├─ All type hints accurate
   ├─ No TODO comments
   └─ Architecture docs complete

Community Ready
   ├─ First 5 plugin submissions working
   ├─ Beginner guide published
   ├─ Video tutorial live
   └─ Discord/GitHub issues responsive

Future-Proof
   ├─ Voice phase foundation (API schema ready)
   ├─ Agent eval compatible (future project)
   ├─ Distributable (Redis layer) ready for scale
   └─ Maintainable (clean code + docs)
```

---

## Appendix A: Code Structure

```
api-dash-eval/
├── backend/
│   ├── app.py                          # FastAPI app
│   ├── config.py                       # Settings + env vars
│   ├── api/
│   │   ├── benchmarks.py               # GET /api/benchmarks
│   │   ├── evaluations.py              # POST/GET /api/evaluations
│   │   ├── results.py                  # GET /api/results
│   │   ├── datasets.py                 # POST/GET /api/datasets
│   │   └── models.py                   # GET /api/models
│   ├── core/
│   │   ├── benchmark_runner.py         # lm-harness wrapper
│   │   ├── lighteval_adapter.py        # lighteval integration
│   │   ├── provider_factory.py         # Multi-provider orchestration
│   │   ├── metrics_engine.py           # BLEU, ROUGE, custom metrics
│   │   └── plugin_loader.py            # Plugin system
│   ├── models/
│   │   ├── database.py                 # SQLite schema
│   │   └── schemas.py                  # Pydantic models
│   ├── workers/
│   │   ├── evaluation_worker.py        # Async job executor
│   │   └── sse_broadcaster.py          # SSE event streaming
│   └── tests/
│       ├── test_benchmarks.py
│       ├── test_providers.py
│       ├── test_metrics.py
│       └── test_integration.py
├── frontend/
│   ├── src/
│   │   ├── main.tsx                    # Entry point
│   │   ├── App.tsx                     # Root component
│   │   ├── pages/
│   │   │   ├── Configure.tsx           # Benchmark config
│   │   │   ├── Execute.tsx             # Real-time monitor
│   │   │   └── Analyze.tsx             # Results dashboard
│   │   ├── components/
│   │   │   ├── BenchmarkSelector.tsx
│   │   │   ├── DatasetUploader.tsx
│   │   │   ├── ModelConfigurator.tsx
│   │   │   ├── ExecutionMonitor.tsx
│   │   │   ├── ResultsLeaderboard.tsx
│   │   │   └── ComparisonChart.tsx
│   │   ├── hooks/
│   │   │   ├── useEvaluation.ts        # Data fetching
│   │   │   └── useSSE.ts              # SSE subscription
│   │   ├── stores/
│   │   │   └── evaluationStore.ts      # Zustand store
│   │   ├── types/
│   │   │   └── evaluation.ts           # TypeScript interfaces
│   │   └── utils/
│   │       ├── api.ts                  # API client
│   │       └── formatters.ts           # Display formatting
│   ├── tests/
│   │   └── components/
│   │       ├── BenchmarkSelector.test.tsx
│   │       ├── ResultsLeaderboard.test.tsx
│   │       └── integration.test.tsx
│   └── vite.config.ts
├── docker/
│   ├── Dockerfile                      # Backend image
│   └── docker-compose.yml              # Full stack
├── .github/
│   └── workflows/
│       └── ci.yml                      # GitHub Actions
├── README.md                           # Getting started
├── CONTRIBUTING.md                     # Developer guide
├── ARCHITECTURE.md                     # Design decisions
└── requirements.txt                    # Python deps
```

---

## Appendix B: Example Workflows

### Workflow 1: Text Evaluation (End-to-End)

```bash
# User: "Test GPT-4 vs Llama 3 on SQuAD?"

# Backend: Set up
POST /api/evaluations
{
  "benchmark_id": "squad-v2",
  "dataset_id": "default",
  "models": [
    {"provider": "openai", "model": "gpt-4", "temperature": 0},
    {"provider": "groq", "model": "llama-3-70b", "temperature": 0}
  ],
  "metrics": ["BLEU", "ROUGE", "Exact Match"]
}

// Returns: {"evaluation_id": "eval_12345", "status": "queued"}

# Frontend: Monitor via SSE
GET /api/evaluations/eval_12345/stream

// Receives events:
{
  "type": "progress",
  "model": "gpt-4",
  "current": 45,
  "total": 100,
  "metrics": {"latency_ms": 1200, "cost_usd": 0.045}
}

# Frontend: Get results
GET /api/results/eval_12345

// Returns:
{
  "leaderboard": [
    {
      "model": "gpt-4",
      "BLEU": 92.1,
      "ROUGE": 85.5,
      "Exact Match": 78.0,
      "avg_latency_ms": 1200,
      "total_cost": "$1.23"
    },
    {
      "model": "llama-3-70b",
      "BLEU": 88.7,
      "ROUGE": 82.1,
      "Exact Match": 74.0,
      "avg_latency_ms": 450,
      "total_cost": "$0.02"
    }
  ]
}

# Result: User sees leaderboard, chooses Llama 3 for production (faster, cheaper)
```

### Workflow 2: Image Evaluation (VQA)

```bash
# User: "Test image captioning models on 50 images"

# Frontend: Upload images
POST /api/datasets
- Select 50 PNG files
- System auto-detects: {"modality": "image", "task": "captioning"}

# Backend: Store + create schema
- Store images in ./data/images/
- Create SQLite entries with image paths

# Frontend: Select models
- Select: [OpenAI Vision, Llama 3.2 Vision (via Groq), Claude 3]

# Backend: Run VQA evaluation
- Load images
- For each image, send to model: "Describe this image in one sentence"
- Compute METEOR/CIDEr scores vs ground truth captions

# Result: Leaderboard shows which model generates best image captions
```

---

## Appendix C: References & Inspiration

- **lm-harness**: https://github.com/EleutherAI/lm-evaluation-harness
- **lighteval**: https://github.com/huggingface/lighteval
- **Spark960's PR**: https://github.com/API-Dash/API-Dash/pull/1136
- **API Dash Repo**: https://github.com/API-Dash/API-Dash
- **Groq API Docs**: https://console.groq.com/docs
- **FastAPI SSE**: https://fastapi.tiangolo.com/advanced/server-sent-events/

---

## Summary

**Project**: Multimodal AI and Agent API Evaluation Framework for API Dash
**Duration**: 13 weeks, 175 hours
**Status**: Ready for GSoC 2026 submission
**Applicant**: Mohid Naghman
**GitHub**: https://github.com/MohidNaghman1
**LinkedIn**: https://www.linkedin.com/in/mohid-naghman/

This proposal outlines a production-ready evaluation framework that integrates industry-standard benchmarking tools (lm-harness, lighteval) with an intuitive React dashboard and powerful FastAPI backend. By end of GSoC, API Dash will empower 1000s of ML teams to benchmark text, image, and voice models effortlessly.
