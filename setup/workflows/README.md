# Workflow Registry

This is your central hub for tracking all AI-assisted development work across all projects.

**Note:** Workflow commands are now global and work from any repository. Commands live in `~/.claude/commands/workflows/`.

## Directory Structure

```
~/.claude/workflows/
├── README.md                 # This file
├── registry.md               # Master index of all workflows
├── projects/                 # Project profiles
│   ├── {project-slug}.md     # Per-project summary and stats
│   └── ...
├── sessions/                 # Session logs for retrospective
│   ├── YYYY-MM-DD-N.md       # Individual session records
│   └── ...
└── analytics/                # Aggregated insights
    ├── weekly/               # Weekly summaries
    └── monthly/              # Monthly summaries
```

## Quick Commands

| Command | Purpose |
|---------|---------|
| `/workflows:list` | Show all active workflows across projects |
| `/workflows:list --all` | Include completed workflows |
| `/workflows:projects` | Show project summaries |
| `/workflows:retrospective` | Generate insights from history |

## How It Works

1. **When you start a workflow:**
   - Entry added to `registry.md`
   - Project file created/updated in `projects/`
   - Session log started in `sessions/`

2. **When you complete/abandon a workflow:**
   - Registry entry updated with outcome
   - Project stats updated
   - Session log finalized

3. **For retrospective:**
   - Query registry for patterns
   - Generate analytics summaries
   - Review session logs

## Files You Might Edit

- `projects/{name}.md` - Add notes about a project
- `sessions/*.md` - Add personal reflections

## Files Managed Automatically

- `registry.md` - Don't edit manually
- `analytics/*` - Generated from data
