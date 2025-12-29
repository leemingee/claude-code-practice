# Intelligent Workflow System

This project uses a cyclic, checkpoint-based workflow system for AI-assisted development with natural language support and confidence-based gating.

## Quick Start

```
# With natural language (preferred)
/workflows:start Fix the login token refresh bug in AuthManager.swift

# With a GitHub issue
/workflows:start #42

# With a formal ID
/workflows:start PROJ-123

# Or just describe what you need
"I need to add push notifications to the Android app, similar to iOS"
```

## How It Works

### Natural Language Flow

1. **You describe** what you need (with optional file references)
2. **I clarify** my understanding and diagnose the task
3. **Based on confidence:**
   - High confidence → I proceed and show you results
   - Medium confidence → Quick plan, then proceed with your OK
   - Low confidence → Full plan review before implementation
4. **You review** the result (always - this is non-negotiable)

### Confidence-Based Gating

| My Confidence | What Happens |
|---------------|--------------|
| **High** | Proceed → Show result → Request approval |
| **Medium** | "Here's my approach..." → Your OK → Proceed |
| **Low** | Full plan + to-do → Your approval → Then proceed |

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

## Checkpoints

```
REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
     ↑______________|_________|
         (can jump backward)
```

## ID Formats

| Source | Generated ID | Example |
|--------|--------------|---------|
| GitHub Issue | `GH-{number}` | `GH-123` |
| Jira/Tracker | Use as-is | `PROJ-456` |
| Natural description | `LOCAL-{date}-{desc}` | `LOCAL-20241228-login-fix` |

## Directory Structure

### Global (commands work from any repo)
```
~/.claude/
├── commands/workflows/     # Workflow commands
├── skills/                 # Global skills
└── workflows/              # Registry & analytics
```

### Per-Repo (context stays with code)
```
{repo}/
├── .claude/
│   ├── CLAUDE.md           # This file
│   └── agents/             # Code reviewers
└── features/{ID}/          # Per-task documents
```

## Code Review by Domain

- Swift/SwiftUI → `ios/code-reviewer`
- Kotlin/Compose → `android/code-reviewer`
- Backend code → `backend/code-reviewer`
- Terraform/K8s/Docker → `infra/security-reviewer`

## Failure Handling

| Level | Meaning | Action |
|-------|---------|--------|
| Execution | Bug in code | Fix and retry |
| Plan | Wrong approach | Jump to PLAN |
| Requirements | Misunderstood need | Jump to REQUIREMENTS |

## Related Documentation

- `docs/SYSTEM_SUMMARY.md` - Complete architecture
- `docs/PLAYBOOK.md` - Comprehensive user guide
- `docs/BOOTSTRAP.md` - Setup instructions
- `examples/TEST-001/` - Working example
