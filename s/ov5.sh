#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"
exec > ~/ov5.txt 2>&1
mkdir -p ~/ovdocs
cat > ~/ovdocs/briefing.md <<'MDEOF'
# BRIEFING - read this first (one page; every agent starts here)

Owner: Leif (William B. Gold / VietUGC). Business: US-focused social commerce, Amazon KDP publishing, affiliate marketing, content; also Vietnamese TikTok. He speaks English only; prefers plain prose, short answers, no repeats.

## What this is
An always-on AI workforce on one Linux server (Contabo). Goal: several autonomous agents with their own jobs, cheap/free to run, controllable from a phone, watchable and overridable by the owner. The Windows laptop is only a screen.

## The stack (4 tools + 2 helpers) - full reasons in docs/STACK.md
- Hermes Agent: the worker (chat, tools, commands, browsing). Phone control via Discord.
- Paperclip: the company/org chart that manages the agents. UI and API at 127.0.0.1:3100. Company: "VietUGC HQ".
- Alibaba OpenSandbox: sealed disposable containers for any risky code. API 127.0.0.1:8080 (key in ~/.osb-key).
- OpenViking: shared long-term memory. 127.0.0.1:1933. Context is stored as short summaries first (L0 abstract, L1 overview) and full detail (L2) only on demand.
- Helpers: Docker (OpenSandbox's engine), Ollama (free local models for OpenViking).

## Rules
1. 100% free stack unless the owner says otherwise.
2. Nothing is installed without a recorded reason in docs/STACK.md; tell the owner about anything he did not ask for.
3. One change at a time; test it; log it in docs/INSTALL-LOG.md; update STATUS.md.
4. Everything stays on 127.0.0.1 unless the owner approves.
5. Do not re-read history: use this page, then STATUS.md (where we are), then docs/ only if needed.
6. Always say which machine a step is on (Windows laptop vs Linux server).

## Where things are
Repo: github.com/vietugc-hub/Linux-HQ (private). Logins: docs/ACCOUNTS.md. Status: STATUS.md. Services (systemd user): hermes-gateway, paperclipai, opensandbox, openviking, ollama.

MDEOF
cat > ~/ovdocs/stack.md <<'MDEOF'
# The initial stack: what each tool is and why we use it

## The goal
Run an AI-powered business entirely on the Linux server (the Contabo cloud server), so it keeps working while the owner's Windows laptop is off. The owner wants several autonomous AI agents, each with its own skills and job, instead of everything going through one chat AI. The agents must be always on, cheap to run, controllable from a phone, and the owner must be able to watch them work and take over at any time. The Windows laptop is not part of this stack; it is only a screen into the server.

Example agent jobs the owner named: logging into Kalodata for data analysis, and browsing TikTok web to find product listings.

The stack is built one tool at a time. Each tool is tested before the next is added, and every step is recorded in this repository so a new work session never has to rebuild the context.

## 1. Hermes Agent (by Nous Research)
Source: https://github.com/NousResearch/hermes-agent
Role: the AI agent runtime. This is the worker that actually does things: it chats, uses tools, runs commands, browses, and takes voice and text instructions.
Why we use it: it is already working on the server, it can run on free models, and it is reachable from the owner's phone through a private Discord bot (named "Hermes Agent UGC"), which covers the need to control agents when the laptop is off.
Status: running.

## 2. Paperclip
Source: https://github.com/paperclipai/paperclip
Role: the company and AI workforce control plane. It is where the agents are organised like employees of a company: who exists, what role each has, what tasks and goals they are working on, and how they report back.
Why we use it: the owner wants multiple separate agents, each with its own role and skills. Something has to manage them as a team rather than as isolated chat windows. Paperclip is that management layer, and Hermes Agent is the first employee it will manage.
Status: running as a background service on the server (private to the server for now). The company and first employee are not set up yet.

## 3. Alibaba OpenSandbox
Source: https://github.com/alibaba/OpenSandbox
Role: isolated execution infrastructure. It gives agents a sealed, disposable place to run commands and code.
Why we use it: always-on autonomous agents will run code and commands that nobody reviews first. A sandbox keeps a mistake or a bad instruction from damaging the server, the other tools or the owner's data. It is the safety boundary for the whole stack.
Status: running as a background service (127.0.0.1:8080). First test passed: it ran a command inside a disposable container and cleaned up.

## 4. OpenViking
Source: https://github.com/volcengine/OpenViking
Role: the memory and context layer for the agents.
Why we use it: agents that forget everything between sessions have to be re-briefed constantly, which is exactly the problem the owner has run into with long chats. OpenViking gives agents shared, lasting memory so work carries over from one session to the next.
Requirement: it needs an embedding model and a vision-language model. We use free local ones through Ollama (see Supporting pieces).
Status: running as a background service (127.0.0.1:1933). Its own check passed. Connected to Hermes Agent as its long-term memory provider (Personal Agent mode).

## Supporting pieces (not part of the four; each exists only because a tool needs it)
**Docker** - the container engine. Why: Alibaba OpenSandbox runs every sandbox as a Docker container. Nothing else uses it.
**Ollama** - runs free AI models on the server itself. Why: OpenViking needs an embedding model and a vision-language model, and the owner's rule is that the stack stays 100% free. Ollama lets those run locally at no cost and with no account. Models: qwen3-embedding:0.6b (embedding), qwen3.5:4b (vision-language), guoxuter/ov_intent_analysis_sft:v7_q8 (OpenViking's query planner). Source for the choice: OpenViking's own setup tool (`openviking-server init`) offers "Recommended local setup (all-Ollama, sized to your RAM)" and picked these models for the server's 7 GB of RAM; its documentation lists Ollama as a supported provider. Trade-off: slower than a paid cloud model. It can be swapped for a cloud model later by editing ~/.openviking/ov.conf.

## How they fit together
Paperclip manages the team. Hermes Agent is the worker. Alibaba OpenSandbox is the safe room where risky work runs (Docker is its engine). OpenViking is the shared memory (Ollama supplies its free models). The owner talks to the team from a phone through Discord and can watch or take over on the server desktop.

## Ground rules
See docs/RULES.md. In short: one change at a time, test each before the next, never commit secrets, keep services private to the server unless approved, and do not add other projects without the owner's approval.

MDEOF
cat > ~/ovdocs/rules.md <<'MDEOF'
# Rules

1. Work incrementally; verify each component before the next.
2. Record version, config location, dependencies, test result and open issues in `docs/INSTALL-LOG.md`.
3. Stop if a test fails; log it; do not stack fixes.
4. Never commit secrets. Keys live only in files on the server outside this repo (for example `~/.hermes/.env`).
5. Services bind to loopback unless explicitly approved.
6. Do not install unrelated projects or optional frameworks without approval.
7. Docker/system packages need the `agent` sudo password, which only the owner types.

- Nothing gets installed without a recorded reason. Every tool or supporting piece must appear in docs/STACK.md with what it is, why it is here, and which tool needs it. The stack stays 100% free unless the owner says otherwise.

MDEOF
echo "== ov help"; ov --help 2>&1 | head -30 | cut -c1-120
echo "== add"; ov add-resource ~/ovdocs --to viking://resources/linux-hq --wait 2>&1 | tail -8 | cut -c1-200
echo OV5_DONE
