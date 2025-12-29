# Claude Code Practice

My practice repository for the Intelligent Workflow System - a checkpoint-based workflow system for AI-assisted development with natural language support and confidence-based gating.

## Installation

### New Machine Setup

```bash
# 1. Clone this repo
git clone https://github.com/leemingee/claude-code-practice.git
cd claude-code-practice

# 2. Run the installer
./install.sh
```

This installs:
- Workflow commands to `~/.claude/commands/workflows/`
- Skills to `~/.claude/skills/`
- Workflow infrastructure to `~/.claude/workflows/`

### Uninstall

```bash
./uninstall.sh
```

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
├── install.sh              # Run this on new machines
├── uninstall.sh            # Remove the system
├── .claude/
│   ├── CLAUDE.md           # Workflow system instructions
│   └── agents/             # Domain-specific code reviewers
├── setup/                  # Global components (installed by install.sh)
│   ├── commands/workflows/ # Workflow slash commands
│   ├── skills/             # Workflow skills
│   └── workflows/          # Registry templates
├── docs/                   # Documentation
├── examples/TEST-001/      # Working workflow example
├── templates/              # Document templates
└── features/               # Active workflow documents
```

## After Installation

Once installed, these are available globally:

```
~/.claude/
├── commands/workflows/     # /workflows:* commands
├── skills/                 # Autonomous skills
└── workflows/              # Registry & analytics
    ├── registry.md         # Your workflow history
    ├── PLAYBOOK.md         # User guide
    ├── projects/           # Project stats
    └── sessions/           # Session logs
```

## License

MIT
