# Muggle Workflows

An adaptive multi-agent development workflow for [Claude Code](https://claude.ai/code) and [Cursor](https://cursor.com). Orchestrates specialist AI agents through a rigorous design-review-implement-learn pipeline that gets smarter with every project.

---

## What This Is

A drop-in workflow system that turns your AI coding assistant into a coordinated team:

- **Orchestrator** decides what to build, how to build it, and in what order
- **Engineer agents** (frontend, backend, general) implement code with TDD
- **Expert panel** reviews every design before a single line is written
- **Reviewer agent** catches bugs, security issues, and compliance gaps before code is pushed
- **Learning system** graduates insights into permanent rules so the next project is faster and better

Works with **Claude Code** and **Cursor** out of the box. Same workflow, same quality, your choice of tool.

---

## Table of Contents

- [Quick Start](#quick-start)
- [How It Works](#how-it-works)
- [The 8-Step Workflow](#the-8-step-workflow)
- [The Expert Panel](#the-expert-panel)
- [Agents](#agents)
- [Installation](#installation)
- [Customization](#customization)
- [File Structure](#file-structure)
- [Keeping Files in Sync](#keeping-files-in-sync)
- [Contributing](#contributing)
- [License](#license)

---

## Quick Start

### One command (from your project directory)

```bash
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash
```

That's it. Then:
- **Claude Code**: type `/workflow` to start
- **Cursor**: reference `@agent-workflow.mdc` in your prompt

### Options

```bash
# Install only Claude Code files
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash -s -- --claude-only

# Install only Cursor files
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash -s -- --cursor-only
```

---

## How It Works

```
You describe what you want
        |
        v
Step 1: Design & Plan -----> Expert Panel scrutinizes the design
        |                     (Architecture, Security, Stress Test,
        |                      Blind Spot + domain specialists)
        v
Step 2: Route -----------> Which agents? Frontend, Backend, or both?
Step 3: Decide ----------> Parallel or sequential?
        |
        v
Step 4: Execute ----------> Engineers write code with TDD
        |                    Quality gates: typecheck + lint + test
        |                    Scope check: verify agent stayed in bounds
        |                    You test on localhost
        v
Step 5: Verify -----------> All gates pass across all repos
Step 6: Review -----------> Reviewer agent: 3-pass code review
        |
        v
Step 7: Push & PR --------> Push to remote, wait for CI, open PR
Step 8: Learn ------------> Graduate insights into permanent rules
```

---

## The 8-Step Workflow

### Step 1: Design & Plan

A single document with two sections — design (what & why) and implementation plan (how). Includes:

- **Research**: Explore codebase, search industry practices, pull library docs
- **Requirements**: Clarify with user, map impact, identify dependencies and risks
- **Design**: Architecture, visual mockups, 2-3 approaches with trade-offs
- **Panel Review**: Expert panel scrutinizes the design (see below)
- **User Approval**: You review the panel-scrutinized design before any code is written
- **Implementation Plan**: Committable slices with TDD steps and localhost test instructions

### Step 2: Route the Requirement

The orchestrator matches your requirement to the right agent:

| Requirement | Agent |
|------------|-------|
| UI, components, styling, hooks, state | Frontend Engineer |
| API, controllers, services, DB, queues | Backend Engineer |
| Other repos/directories | General Engineer |
| API contract change | Both Frontend + Backend |

### Step 3: Parallel vs Sequential

A 9-item checklist decides automatically:
- New endpoint or new types? **Sequential** (backend first)
- Contract already defined? **Parallel**
- Single repo? **That repo's engineer only**

### Step 4: Execute Per Slice

Each slice follows TDD: write failing test, implement, pass, refactor. After each slice:
1. Quality gates run (typecheck, lint + secret scanning, test)
2. Scope check verifies the agent only touched declared files
3. You test on localhost
4. Commit locally (not pushed yet)

### Step 5: Verify Before Completing

After all slices: run all quality gates across every repo, verify no sensitive data in commits, confirm everything passes with actual output.

### Step 6: Code Review

Three-pass review on the full diff: code quality, compliance, contract consistency. Findings are verified before implementing — no blind acceptance.

### Step 7: Push & Finish

Push all commits to remote (first time code reaches remote). Wait for CI. Open PR.

### Step 8: Learn & Graduate

Capture run log (panelist performance, agent performance, cost). Graduate reusable learnings into CLAUDE.md or agent definitions. Compress rules when they accumulate. The system gets smarter with every run.

---

## The Expert Panel

Every design goes through a two-round expert panel before implementation begins.

### Round 1: Core + Domain (parallel)

**Core panelists** (always run):

| Panelist | What it catches |
|----------|----------------|
| Architecture Expert | Scalability, patterns, over-engineering, system boundaries |
| Security Reviewer | Auth flows, injection, OWASP top 10, data exposure |
| Stress Test Reviewer | Unhappy paths, edge cases, race conditions, abuse scenarios |
| Blind Spot Reviewer | What the design is MISSING — researches online, recommends Round 2 specialists |

**Domain panelists** (auto-selected based on what the design touches):
Frontend Architect, Backend Architect, UI/UX/UE Expert, Mobile/Responsive Expert, Database/Data Expert

### Round 2: Gap Specialists (only if gaps found)

The Blind Spot Reviewer identifies what the design doesn't mention and recommends specialists:
SEO/GEO/AEO, Analytics/Growth, Web Performance, Accessibility, i18n, Privacy/Compliance, DevOps/Infrastructure

Any Round 1 panelist can also recommend gap specialists.

---

## Agents

| Agent | Role | Model |
|-------|------|-------|
| **Frontend Engineer** | Implements UI slices with TDD | Sonnet (configurable) |
| **Backend Engineer** | Implements API/service slices with TDD | Sonnet (configurable) |
| **General Engineer** | Handles directories without a specialist | Sonnet (configurable) |
| **Reviewer** | Three-pass code review per PR | Sonnet (configurable) |
| **UX Reviewer** | Six-pass UX review for frontend slices | Sonnet (configurable) |

All agents return structured summaries. Engineers run quality gates before returning. The Reviewer and UX Reviewer are read-only — they never modify code.

---

## Installation

### Recommended: one-line install

From your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash
```

This installs both Claude Code and Cursor files + the sync script.

### Manual install

If you prefer to clone and copy manually:

```bash
git clone https://github.com/bendtyo/muggle-workflows.git /tmp/muggle-workflows
cd <your-project>
/tmp/muggle-workflows/install.sh
```

### Claude Code only

```bash
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash -s -- --claude-only
```

### Cursor only

```bash
curl -fsSL https://raw.githubusercontent.com/bendtyo/muggle-workflows/main/install.sh | bash -s -- --cursor-only
```

---

## Customization

### Agent scope

Edit the agent definitions to match your project structure:

```markdown
# In claude-code/agents/frontend-engineer.md:
- **Work in**: `src/client/` only    # <-- change to your frontend dir
```

### Agent model

Change the `model` field in each agent's YAML frontmatter:
```yaml
model: opus    # or: sonnet, haiku
```

### Quality gate commands

Update the shell commands in each agent's Quality Gates section:
```bash
cd <your-dir> && npm run typecheck && npm run lint && npm test
```

### Stack rules

The agents reference `.mdc` stack rule files (e.g., `react.mdc`, `typescript.mdc`). These are your project's coding standards — create them as needed, or remove the references if not applicable.

### Panelist roster

Add or remove panelists from the Panel Review section in the workflow file. The roster is not hardcoded — it's a menu the orchestrator selects from based on your design.

---

## File Structure

```
muggle-workflows/
  claude-code/
    agents/
      frontend-engineer.md    # Frontend specialist
      backend-engineer.md     # Backend specialist
      general-engineer.md     # General purpose
      reviewer.md             # Code reviewer (3-pass)
      ux-reviewer.md          # UX reviewer (6-pass)
    commands/
      workflow.md             # /workflow orchestration command
  cursor/
    frontend-engineer.mdc     # Cursor equivalent
    backend-engineer.mdc      # Cursor equivalent
    general-engineer.mdc      # Cursor equivalent
    reviewer.mdc              # Cursor equivalent
    ux-reviewer.mdc           # Cursor equivalent
    agent-workflow.mdc        # Cursor equivalent
  scripts/
    sync-agents.sh            # Verify Claude Code + Cursor files stay in sync
  install.sh                  # One-command installer
  README.md
```

Claude Code files use YAML frontmatter (`name`, `description`, `model`).
Cursor files use Cursor frontmatter (`description`, `alwaysApply`).
The markdown body is identical between paired files.

---

## Keeping Files in Sync

If you use both Claude Code and Cursor, run the sync script after editing any agent or workflow file:

```bash
./scripts/sync-agents.sh
```

It strips frontmatter from both files and diffs the markdown body. If they've diverged, it tells you which pairs need updating.

**Source of truth**: `claude-code/` files are canonical. When making changes, edit the Claude Code version first, then update the Cursor version to match.

---

## Contributing

We welcome contributions! Here's how:

1. Fork the repo
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Make your changes
4. Run `./scripts/sync-agents.sh` to verify sync
5. Open a PR with a clear description of what changed and why

### What to contribute

- New panelist definitions (e.g., "GraphQL Expert", "Real-time Systems Expert")
- Improvements to agent output formats
- Better escalation/error recovery patterns
- Stack-specific agent variants (Python/Django, Go, Rust, etc.)
- Documentation improvements

### What NOT to contribute

- Project-specific customizations (keep those in your own repo)
- Changes that break the sync between Claude Code and Cursor files

---

## License

This project is licensed under the [BSD 3-Clause License](LICENSE).

The workflow definitions and agent prompts are freely available for use in any project, commercial or otherwise.
