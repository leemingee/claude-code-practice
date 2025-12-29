# Claude Code Practice

My practice repository for the Intelligent Workflow System - a checkpoint-based workflow system for AI-assisted development with natural language support and confidence-based gating.

## Quick Start

```bash
# Start a workflow with natural language
/workflows:start Fix the login token refresh bug in AuthManager.swift

# Start from GitHub issue
/workflows:start #42

# Check status
/workflows:status

# Continue work
/workflows:implement <ID>

# Simple tasks
/workflows:fast Fix typo in README
```

## How It Works

### Checkpoints with Deep Backtracking

```
REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
     ↑______________|_________|
         (can jump backward)
```

Unlike traditional DAG workflows, this system supports deep cycles - you can jump from IMPLEMENTATION back to REQUIREMENTS if you discover the problem was misunderstood.

### Confidence-Based Gating

| Confidence | What Happens |
|------------|--------------|
| **High** | Proceed → Show result → Request approval |
| **Medium** | Show brief plan → Wait for OK → Proceed |
| **Low** | Full planning → Your approval → Then proceed |

### Failure Classification

| Level | Meaning | Action |
|-------|---------|--------|
| Execution | Bug in code | Fix and retry |
| Plan | Wrong approach | Jump to PLAN |
| Requirements | Misunderstood need | Jump to REQUIREMENTS |

## Commands

| Command | Purpose |
|---------|---------|
| `/workflows:start {description}` | Start with natural language or issue ID |
| `/workflows:status {ID}` | Check current state |
| `/workflows:implement {ID}` | Continue implementation |
| `/workflows:jump {ID} {TARGET} "{REASON}"` | Jump to earlier checkpoint |
| `/workflows:fast {description}` | Streamlined for simple tasks |
| `/workflows:list` | Show all active workflows |
| `/workflows:projects` | Show tracked projects |
| `/workflows:retrospective` | Generate insights |

## Documentation

- [System Overview](docs/SYSTEM_SUMMARY.md) - Complete architecture and design
- [Playbook](docs/PLAYBOOK.md) - Comprehensive user guide
- [Bootstrap Guide](docs/BOOTSTRAP.md) - Setup instructions

## Structure

```
claude-code-practice/
├── .claude/
│   ├── CLAUDE.md           # Workflow system instructions
│   └── agents/             # Domain-specific code reviewers
│       ├── failure-classifier.md
│       ├── ios/code-reviewer.md
│       ├── android/code-reviewer.md
│       ├── backend/code-reviewer.md
│       └── infra/security-reviewer.md
├── docs/                   # Documentation
├── examples/TEST-001/      # Working workflow example
├── templates/              # Document templates
└── features/               # Active workflow documents
```

## Global Components

This repo works with global commands at `~/.claude/commands/workflows/`. See [Bootstrap Guide](docs/BOOTSTRAP.md) for setup.

## License

MIT
