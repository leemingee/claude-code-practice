# Intelligent Workflow System - Complete Summary

This document summarizes the workflow system we built together, including architecture, file organization, and guidance for maintaining your own practice repository.

---

## What We Built

### Core Innovation: Deep Cyclic Workflows

Traditional workflows are DAGs (directed acyclic graphs) - they flow one direction. We built something different: **a behavior tree with deep backtracking**.

```
Traditional:  PLAN → IMPLEMENT → REVIEW → DONE
                ↓         ↓
              (retry)   (retry)

Our System:   REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
                   ↑___________|_________|
                        (deep jumps)
```

**Key insight**: Human decision-making has loops. When implementation reveals that requirements were wrong, you don't just retry - you jump back to fundamentally rethink. Our system does this.

### Confidence-Based Gating

The system adapts formality based on task complexity:

| Confidence | Behavior |
|------------|----------|
| **High** | Proceed → Show result → Ask approval |
| **Medium** | Show brief plan → Wait for OK → Proceed |
| **Low** | Full formal planning → Your approval → Then proceed |

Factors: pattern familiarity, file scope, requirement clarity, risk level.

### Failure Classification

Three levels of failure, each with different recovery:

| Level | Meaning | Action |
|-------|---------|--------|
| `EXECUTION_FAILURE` | Bug in code, plan is fine | Fix and retry |
| `PLAN_FAILURE` | Approach doesn't work | Jump to PLAN |
| `REQUIREMENTS_FAILURE` | Misunderstood what to build | Jump to REQUIREMENTS |

### Natural Language Input

Instead of requiring issue IDs, accept natural descriptions:

```
/workflows:start Fix the login token refresh bug in AuthManager.swift
/workflows:start #42                    (GitHub issue)
/workflows:start Add dark mode support  (natural language → LOCAL-20241228-dark-mode)
```

### Global Registry

Track workflows across all projects in one place (`~/.claude/workflows/`), enabling:
- Cross-project visibility
- Session logging for retrospective
- Project statistics and patterns
- Workflow history preservation

---

## Architecture Overview

### Two-Tier Storage

```
~/.claude/                          # GLOBAL (works from any repo)
├── commands/workflows/             # Workflow slash commands
├── skills/                         # Reusable skills
└── workflows/                      # Registry & analytics

{repo}/                             # LOCAL (context with code)
├── .claude/
│   ├── CLAUDE.md                   # Repo-specific config
│   └── agents/                     # Domain-specific code reviewers
└── features/{ID}/                  # Per-workflow documents
```

### Why This Split?

| Global | Local |
|--------|-------|
| Commands (same behavior everywhere) | Agents (repo-specific review criteria) |
| Skills (reusable patterns) | CLAUDE.md (repo-specific instructions) |
| Registry (cross-project tracking) | Features (workflow documents with code) |

---

## File Inventory

### Global Files (~/.claude/)

#### Commands (`~/.claude/commands/workflows/`)

| File | Purpose |
|------|---------|
| `start.md` | Initialize workflows (natural language, GitHub, formal IDs) |
| `status.md` | Display current workflow state |
| `implement.md` | Main implementation with checkpoint awareness |
| `jump.md` | Explicitly jump to earlier checkpoint |
| `fast.md` | Streamlined workflow for simple tasks |
| `list.md` | Show all active workflows across projects |
| `projects.md` | Show tracked projects and statistics |
| `retrospective.md` | Generate insights from workflow history |
| `review/solution.md` | Review implementation plan |
| `review/todo.md` | Review to-do document |

#### Skills (`~/.claude/skills/`)

| File | Purpose |
|------|---------|
| `workflow-state-management/SKILL.md` | Manage workflow-state.md files |
| `workflow-registry/SKILL.md` | Manage global registry operations |
| `implementing-skill/SKILL.md` | Meta-skill for creating other skills |

#### Workflow Data (`~/.claude/workflows/`)

| File | Purpose |
|------|---------|
| `README.md` | Quick reference for the registry |
| `PLAYBOOK.md` | Comprehensive user guide |
| `registry.md` | Master index of all workflows |
| `projects/*.md` | Per-project profiles and statistics |
| `sessions/*.md` | Session logs for retrospective |
| `analytics/` | Generated insights (weekly/monthly) |

### Local Files (claude-code-guide repo)

#### Core Documentation

| File | Purpose |
|------|---------|
| `VISION.md` | Goals, North Star, Value Proposition |
| `IMPLEMENTATION_PLAN.md` | 5-phase implementation roadmap |
| `SYSTEM_SUMMARY.md` | This document |
| `.claude/CLAUDE.md` | Repo-specific workflow instructions |

#### Agents (`.claude/agents/`)

| File | Purpose |
|------|---------|
| `failure-classifier.md` | Diagnose failure level |
| `ios/code-reviewer.md` | iOS code review checklist |
| `android/code-reviewer.md` | Android code review checklist |
| `backend/code-reviewer.md` | Backend code review checklist |
| `infra/security-reviewer.md` | Infrastructure security review |

#### Test Example (`features/TEST-001/`)

Complete workflow example demonstrating all checkpoints:
- `workflow-state.md` - State tracking
- `requirements.md` - Requirements doc
- `implementation-plan.md` - Plan doc
- `to-do.md` - Task tracking
- `D-*-implementation-overview.md` - Subtask overviews

---

## Creating Your Practice Repository

### Recommended Structure

```
claude-code-practice/
├── README.md                       # Overview and quick start
├── VISION.md                       # Your goals (copy from claude-code-guide)
├── CLAUDE.md                       # Root instructions
├── .claude/
│   ├── CLAUDE.md                   # Workflow system instructions
│   └── agents/                     # Your domain-specific reviewers
│       ├── ios/code-reviewer.md
│       ├── android/code-reviewer.md
│       ├── backend/code-reviewer.md
│       └── infra/security-reviewer.md
├── docs/
│   ├── system-overview.md          # How the system works
│   ├── command-reference.md        # Command documentation
│   └── playbook.md                 # Copy of PLAYBOOK.md
├── examples/
│   └── TEST-001/                   # Working example workflow
└── templates/
    ├── workflow-state.md           # Template for new workflows
    ├── requirements.md
    ├── implementation-plan.md
    └── to-do.md
```

### Files to INCLUDE from claude-code-guide

**Definitely include:**
```
VISION.md                           # Your vision document
IMPLEMENTATION_PLAN.md              # Roadmap (if still relevant)
.claude/CLAUDE.md                   # Core workflow instructions
.claude/agents/                     # All code reviewers
examples/                           # Working code examples
```

**Include as templates:**
```
features/TEST-001/                  # Copy as examples/ or templates/
```

### Files to EXCLUDE

**Don't include (they're global now):**
```
.claude/commands/workflows/         # Already at ~/.claude/commands/
.claude/skills/                     # Already at ~/.claude/skills/
```

**Don't include (session-specific):**
```
~/.claude/workflows/sessions/       # Your personal session logs
~/.claude/workflows/projects/       # Your personal project stats
~/.claude/workflows/registry.md     # Your personal workflow history
```

### What Stays Global vs What Goes in Repo

| Goes in ~/.claude/ (Global) | Goes in Repo |
|-----------------------------|--------------|
| Commands (workflows/*.md) | CLAUDE.md (repo instructions) |
| Skills (*.SKILL.md) | Agents (code reviewers) |
| Registry (registry.md) | Feature docs (requirements, plans) |
| Session logs | Examples and templates |
| PLAYBOOK.md | VISION.md |

---

## Setting Up a New Machine

### Step 1: Install Global Components

Copy these to `~/.claude/`:

```bash
# Commands
mkdir -p ~/.claude/commands/workflows/review
# Copy all command files to ~/.claude/commands/workflows/

# Skills
mkdir -p ~/.claude/skills/{workflow-state-management,workflow-registry,implementing-skill}
# Copy all SKILL.md files

# Workflows
mkdir -p ~/.claude/workflows/{projects,sessions,analytics/weekly,analytics/monthly}
# Copy PLAYBOOK.md and README.md
```

### Step 2: Clone Your Practice Repo

```bash
git clone your-practice-repo
cd your-practice-repo
```

### Step 3: Start Using

```bash
# From any repo
/workflows:start Fix the bug in login flow
```

---

## Command Quick Reference

```
┌─────────────────────────────────────────────────────────────────┐
│                    WORKFLOW QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────────┤
│ START                                                           │
│   /workflows:start {description}     Natural language           │
│   /workflows:start #42               GitHub issue               │
│   /workflows:fast {description}      Simple tasks               │
├─────────────────────────────────────────────────────────────────┤
│ STATUS                                                          │
│   /workflows:status                  Current workflow           │
│   /workflows:list                    All active workflows       │
│   /workflows:projects                All projects               │
├─────────────────────────────────────────────────────────────────┤
│ CONTINUE                                                        │
│   /workflows:implement {ID}          Resume workflow            │
│   proceed / continue / go ahead      After plan shown           │
├─────────────────────────────────────────────────────────────────┤
│ FIX PROBLEMS                                                    │
│   /workflows:jump {ID} PLAN "why"    Wrong approach             │
│   /workflows:jump {ID} REQ "why"     Wrong requirements         │
├─────────────────────────────────────────────────────────────────┤
│ ANALYZE                                                         │
│   /workflows:retrospective           Weekly insights            │
│   /workflows:retrospective --month   Monthly insights           │
├─────────────────────────────────────────────────────────────────┤
│ CHECKPOINTS                                                     │
│   REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE      │
│        ↑_______________|______|  (can jump backward)            │
└─────────────────────────────────────────────────────────────────┘
```

---

## Key Principles to Remember

1. **Always Review**: Every change gets your review - non-negotiable
2. **State Persists**: workflow-state.md survives /clear
3. **Adaptive Formality**: More structure for complex tasks, less for simple
4. **Deep Backtracking**: Jump from implementation back to requirements if needed
5. **Global Commands**: Work from any repo
6. **Local Context**: Feature docs stay with the code

---

## Evolution Ideas

Future enhancements to consider:

1. **Skill Library**: Build more domain-specific skills
2. **Pattern Recognition**: Auto-detect similar past workflows
3. **Team Features**: Share workflows across team members
4. **IDE Integration**: VS Code extension for workflow status
5. **Metrics Dashboard**: Visual analytics for retrospectives

---

*Last updated: 2024-12-29*
