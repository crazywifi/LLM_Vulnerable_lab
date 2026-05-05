# AI Red Team Training Platform

An interactive LLM security training lab for students, developers, security engineers, and AI product teams. The platform demonstrates common LLM application risks through hands-on simulations, including conversational prompt attacks, RAG attacks, insecure output handling, API/middleware flaws, agent/tool abuse, and AI threat modeling exercises.

This project is intentionally built as a lightweight HTML + FastAPI lab so it can run locally in a classroom, workshop, or developer laptop without a complex cloud environment.

> Educational use only. Do not deploy this lab to a public server.

## Important Model Selection Note

Not every LLM will behave the same way in this lab. Strongly aligned commercial models, such as GPT, Claude, Gemini, or other heavily guarded models, may refuse many attack prompts even when the lab is running in `Vulnerable` mode. This does not mean the lab is broken. It means the selected model has its own built-in safety guardrails that may block the demonstration before the lab prompt can show the vulnerable behavior.

For the clearest classroom demonstrations, use a local or research model that is less aggressively guarded. Examples that are often useful for red-team training, when available through LM Studio, Ollama, OpenRouter, or similar providers, include:

- `meta-llama-3.1-8b-instruct-abliterated`
- `cognitivecomputations/dolphin-mistral-24b-venice-edition`
- `dolphin-llama3`
- `dolphin-mixtral`
- `nous-hermes`
- Other local "abliterated", "uncensored", or security-research-oriented instruct models

Model availability changes across providers, and names may differ depending on where you run them. Always choose models responsibly and only for authorized security education.

Also note that prompt payloads are not guaranteed to work every time. A payload that succeeded earlier may fail later because:

- LLM outputs are probabilistic and can vary between runs.
- The model may become more cautious after earlier messages in the same chat.
- Conversation history can change how the model interprets the next prompt.
- Provider-side safety filters or model versions may change over time.
- Temperature, context length, and system prompt ordering can affect behavior.

If a payload stops working, first click `Clear Chat` and try again from a fresh conversation. This resets the local conversation history and often makes demonstrations more consistent.

## What This Lab Teaches

This lab helps learners understand:

- How LLM systems can be attacked through prompts, documents, tools, APIs, and rendered output.
- Why system prompts and guardrail text are not complete security boundaries.
- How vulnerable behavior differs from defended behavior.
- How RAG pipelines can be poisoned by untrusted retrieved content.
- How agentic workflows can fail when tools have too much privilege.
- How insecure middleware can turn LLM features into web, API, or infrastructure risks.
- How to threat model AI systems using attack surfaces, actors, techniques, and controls.

## Main Features

- Single-page browser UI for interactive labs.
- FastAPI backend for mock API and middleware attack simulations.
- Support for local and cloud LLM providers:
  - Ollama
  - LM Studio
  - OpenRouter
- Vulnerable and defended modes for comparing unsafe and safer behavior.
- Chat-based labs for conversational attacks.
- API-based labs with editable JSON request bodies and headers.
- ATLAS-style threat modeling and secure design exercises.

## Repository Files

| File | Purpose |
| --- | --- |
| `llm_vuln_lab_UI.html` | Main browser UI and lab definitions |
| `lab_backend_server.py` | FastAPI backend, LLM proxy, and mock vulnerable endpoints |
| `requirements.txt` | Python dependencies |
| `start.bat` | Windows launcher |
| `start.sh` | macOS/Linux launcher |
| `llm_vuln_lab_UI1.html` | Older/reference UI copy |

## Vulnerable vs Defended Mode

The platform has two modes for each lab.

### Vulnerable Mode

Vulnerable mode intentionally uses unsafe prompts, weak assumptions, or insecure mock middleware. It is designed to show how an attack can succeed.

Examples:

- A chatbot may reveal secrets from its system prompt.
- A RAG assistant may follow instructions hidden inside retrieved documents.
- A middleware endpoint may trust `role: "admin"` from user-controlled JSON.
- An output renderer may allow unsafe HTML.
- An agent may follow malicious instructions from tool output.

### Defended Mode

Defended mode shows safer behavior by applying controls such as:

- Refusing prompt override attempts.
- Treating retrieved documents and tool output as untrusted data.
- Avoiding system prompt or secret disclosure.
- Validating API inputs.
- Ignoring client-supplied authorization fields.
- Restricting model versions to an approved allowlist.
- Blocking dangerous command, SQL, HTML, and tool-use patterns.
- Enforcing least privilege for agents.

Defended mode is not a guarantee of perfect security. It is a teaching comparison that shows what better design patterns look like.

## Test Case Coverage

The lab covers the following categories.

### Prompt Injection

- Direct Prompt Injection
- Indirect Prompt Injection
- Multi-Turn Prompt Injection
- Instruction Smuggling / Encoded Payloads
- Token/encoding style smuggling examples
- RAG-based Prompt Injection

### Jailbreaks and System Prompt Leakage

- Roleplay / DAN-style Jailbreak
- Fictional Context Jailbreak
- Jailbreak via Translation
- Many-Shot Jailbreaking
- Crescendo Attack
- System Prompt Extraction
- Prompt Leakage through unsafe prompt design

### RAG Pipeline Attacks

- RAG Poisoning / Retrieval Hijack
- Context Window Stuffing
- Cross-Document Injection
- Data Poisoning via RAG concepts

### Guardrail and Safety Bypass

- Keyword Filter Evasion
- Output Filter Bypass
- Moderation Evasion through fragmented intent
- System Prompt Override attempts
- Alignment Bypass via False Authority

### Data Leakage and Privacy

- PII Exfiltration
- PHI Exposure
- API Key / Secret Leakage
- Business Logic Disclosure
- Training Data Reconstruction
- Membership Inference
- Attribute Inference

### Insecure Output Handling

- XSS via LLM Output
- SQL Injection via LLM
- Command Injection via LLM
- SSRF via LLM-style URL fetching

### Plugin, Tooling, and Agent Exploitation

- Tool Abuse
- Agent Chaining Vulnerability
- Excessive Agency
- Prompt Injection in Tool Output
- TOCTOU in Agentic Flows

### API and Middleware-Level Attacks

- API Abuse / Rate Limit Bypass
- Request Manipulation
- Auth Bypass
- Model Version Confusion
- Prompt Injection through HTTP Headers

### Supply Chain and Model Manipulation Concepts

- Backdoor Injection simulation
- Supply Chain / Model Tampering simulation
- Data Poisoning / Fine-tuning mock behavior
- Third-party Plugin Risk concepts through agent/tool labs

### Threat Modeling and Secure Design

- Attack Surface Enumeration
- Threat Actor Profiling
- ATLAS-style Technique Mapping
- Input Validation and Sanitization
- Output Filtering
- Prompt Hardening
- Semantic Similarity Guardrails
- Monitoring and Anomaly Detection
- Least Privilege for Agents

## How To Run

### 1. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 2. Start an LLM Provider

You can use one of the following options.

#### Option A: Ollama

Install Ollama, then run:

```bash
ollama pull llama3.2
ollama serve
```

If your browser or local setup needs CORS enabled:

```bash
OLLAMA_ORIGINS=* ollama serve
```

#### Option B: LM Studio

1. Install LM Studio.
2. Download or load a chat model.
3. Open the Local Server tab.
4. Start the server.
5. Enable CORS if required.

#### Option C: OpenRouter

1. Create an API key from OpenRouter.
2. Add it in the UI settings modal, or set it as an environment variable:

```bash
export OPENROUTER_API_KEY="sk-or-v1-your-key"
```

On Windows PowerShell:

```powershell
$env:OPENROUTER_API_KEY="sk-or-v1-your-key"
```

### 3. Start the Lab Backend

```bash
python lab_backend_server.py
```

Or use the launcher:

```bash
# Windows
start.bat

# macOS/Linux
bash start.sh
```

### 4. Open the UI

Open:

```text
http://localhost:8000
```

The UI is served by the FastAPI backend. This is the recommended way to run the lab because the API/middleware simulations require backend endpoints.

## Basic Usage

1. Choose a lab from the sidebar.
2. Select `Vulnerable` mode.
3. Try one of the hint prompts or write your own attack.
4. Observe how the model or mock endpoint behaves.
5. Switch to `Defended` mode.
6. Run the same test again.
7. Compare what changed and discuss which control reduced the risk.

For API labs, the UI will show:

- The endpoint path.
- Editable request headers.
- Editable JSON body.
- A button to run the simulation.
- The returned mock security result.

For ATLAS/design labs, the UI shows:

- Scenario.
- Attack surfaces.
- Threat actors.
- Technique mapping.
- Defensive controls.

## Example Classroom Flow

1. Start with Direct Prompt Injection to show why secrets do not belong in prompts.
2. Move to Indirect Prompt Injection to show untrusted document risk.
3. Run RAG Poisoning and Cross-Document Injection to explain RAG trust boundaries.
4. Demonstrate XSS, SQL Injection, Command Injection, and SSRF to connect LLM risks to classic AppSec.
5. Use Tool Abuse, Tool Output Injection, and TOCTOU labs to teach agent security.
6. Finish with ATLAS Threat Modeling and Secure AI Design Controls.

## What This Tool Helps Teams Understand

This tool helps teams build intuition for:

- How LLM vulnerabilities appear in real applications.
- Why AI security is both model security and application security.
- How attackers chain prompt, data, API, and tool weaknesses.
- Why defense must be layered around the model.
- How to convert AI risk taxonomy into test cases.
- How to discuss LLM security with developers using concrete examples.
- How to design safer AI features before production deployment.

## Out Of Scope

Some items from the full LLM security taxonomy are not implemented as true technical simulations because they require model internals, real training infrastructure, vector databases, or supply-chain systems that are outside a lightweight HTML/FastAPI app.

| Out-of-scope item | Small reason |
| --- | --- |
| Malicious Model Weights | Requires loading, inspecting, and validating actual model weight files. |
| True Embedding Backdoors | Requires a real embedding model, trigger evaluation, and vector search index. |
| Full Dataset Poisoning | Requires a real training or ingestion pipeline with measurable model behavior changes. |
| Real Malicious Fine-tuning | Requires fine-tuning infrastructure, datasets, checkpoints, and evaluation. |
| Label Flipping | Requires supervised ML datasets and model retraining. |
| Model Inversion | Requires mathematical privacy attacks and access to model confidence/logit behavior. |
| Model Extraction | Requires high-volume querying and training a substitute model. |
| True Transfer Attacks | Requires multiple real models and comparative attack evaluation. |
| Gradient or Tensor Perturbation Attacks | Requires access to tensors, gradients, logits, or model internals. |
| Real Embedding Manipulation | Requires direct embedding vectors and nearest-neighbor retrieval behavior. |
| Large-scale Retrieval Poisoning | Requires a production-like vector database and ranking pipeline. |
| Dependency Confusion | Requires package registries, build pipelines, and dependency resolution simulation. |
| Physical Supply Chain Compromise | Requires real artifact provenance, signing, deployment, or hardware/software distribution flows. |
| Raw Model Weight Tampering | Requires model files and runtime validation beyond this demo app. |

Where possible, the lab still includes safe conceptual simulations for these topics, such as supply-chain backdoor behavior, mock fine-tuning poisoning, and RAG poisoning.

## Security Warning

This repository intentionally contains vulnerable prompts and mock vulnerable endpoints. Keep it local.

Do not:

- Deploy this backend publicly.
- Put real secrets in system prompts.
- Connect the mock endpoints to production systems.
- Use real customer, patient, employee, or credential data.
- Give agent/tool labs access to real filesystem, email, cloud, or database resources.

## Troubleshooting

### Backend does not start

```bash
pip install -r requirements.txt
python lab_backend_server.py
```

### Port 8000 is already in use

```bash
python -m uvicorn lab_backend_server:app --host 0.0.0.0 --port 8001
```

Then open:

```text
http://localhost:8001
```

### Ollama is not detected

- Make sure Ollama is running.
- Pull a model with `ollama pull llama3.2`.
- If needed, start Ollama with CORS enabled.

### LM Studio is not detected

- Start the LM Studio local server.
- Confirm a model is loaded.
- Enable CORS in LM Studio server settings.

### API labs do not work

Open the UI through the backend:

```text
http://localhost:8000
```

Do not open the HTML file directly if you want API/middleware simulations.

## License and Use

This lab is intended for authorized education, security training, and internal AI red team workshops. Use responsibly and only in environments where you have permission to test.
