---
name: workflow-registry
description: Manages the global workflow registry at ~/.claude/workflows/. Tracks all workflows across projects, maintains session logs, and enables retrospective analysis.
---

# Workflow Registry Management

Manages the centralized workflow registry for cross-project tracking and retrospective analysis.

## When to Use

- Starting a new workflow (register it)
- Completing/abandoning a workflow (update status)
- Listing workflows across projects
- Generating retrospective insights
- Starting/ending a session

## Registry Location

All registry files are in: `~/.claude/workflows/`

```
~/.claude/workflows/
├── registry.md               # Master index
├── projects/{slug}.md        # Per-project profiles
├── sessions/YYYY-MM-DD-N.md  # Session logs
└── analytics/                # Generated insights
```

## Operations

### Register New Workflow

When a workflow starts, add to registry.md Active Workflows table:

```markdown
| {ID} | {project} | {repo-path} | CHECKPOINT_REQUIREMENTS | - | {date} | {date} |
```

Also:
1. Create/update project file in `projects/{project-slug}.md`
2. Add entry to current session log

### Update Workflow Status

When checkpoint changes:
1. Update the Checkpoint and Subtask columns in registry.md
2. Update the Updated date

### Complete Workflow

When workflow reaches CHECKPOINT_COMPLETE:
1. Move row from "Active Workflows" to "Completed Workflows"
2. Set Outcome to SUCCESS
3. Calculate Duration
4. Update project file statistics
5. Update session log

### Abandon Workflow

When user explicitly abandons:
1. Move row from "Active Workflows" to "Abandoned Workflows"
2. Record Reason
3. Update project file statistics
4. Update session log

### Start Session

At the beginning of a conversation:
1. Check for existing session file for today
2. If none, create new: `sessions/YYYY-MM-DD-N.md`
3. Initialize with template

Session template:
```markdown
# Session: {date} #{N}

## Overview
- **Date:** {date}
- **Duration:** (ongoing)
- **Projects Touched:** (to be filled)

## Workflows Worked On
(to be filled as work progresses)

## Accomplishments
(to be filled)

## Key Decisions
(to be filled)

## Insights
(to be filled)

## Next Steps
(to be filled)
```

### End Session

At end of conversation (or when user says they're done):
1. Update session file with accomplishments
2. List all workflows touched
3. Calculate duration
4. Note any insights or decisions

### Generate Project Slug

From repo path or project name:
1. Take last component of path: `~/src/my-ios-app` → `my-ios-app`
2. Lowercase, replace spaces with hyphens
3. Remove special characters

### Find Workflow by ID

To locate a workflow:
1. Read `registry.md`
2. Search Active, Completed, and Abandoned tables for ID
3. Return repo path and current status

### List Active Workflows

Parse registry.md Active Workflows table:
```
For each row:
  - ID
  - Project name
  - Current checkpoint
  - Current subtask
  - Last updated
```

## Project File Template

```markdown
# Project: {name}

## Overview
- **Name:** {display name}
- **Path:** {repo path}
- **Type:** {iOS | Android | Backend | Infra | OSS | Other}
- **First Tracked:** {date}

## Description
{Brief description of the project}

## Domains
- [ ] iOS
- [ ] Android
- [ ] Backend
- [ ] Infrastructure
- [ ] Documentation
- [ ] Other

## Workflow History
| ID | Type | Outcome | Date | Notes |
|----|------|---------|------|-------|

## Statistics
- **Total Workflows:** 0
- **Completed:** 0
- **Success Rate:** N/A
- **Avg Duration:** N/A

## Notes
{User's notes about the project}
```

## Analytics Generation

### Weekly Summary

Generate `analytics/weekly/YYYY-WNN.md`:
- Workflows completed this week
- Time spent per project
- Success/failure ratio
- Key accomplishments
- Patterns observed

### Monthly Summary

Generate `analytics/monthly/YYYY-MM.md`:
- Total workflows
- Project distribution
- Completion trends
- Most active projects
- Retrospective insights

## Registry Schema

### Active Workflows Table

| Column | Description |
|--------|-------------|
| ID | Workflow identifier (GH-*, LOCAL-*, etc.) |
| Project | Project slug |
| Repo | Full path to repository |
| Checkpoint | Current checkpoint |
| Subtask | Current subtask or - |
| Started | Start date |
| Updated | Last update date |

### Completed Workflows Table

| Column | Description |
|--------|-------------|
| ID | Workflow identifier |
| Project | Project slug |
| Repo | Full path to repository |
| Outcome | SUCCESS, PARTIAL, or BLOCKED |
| Started | Start date |
| Completed | Completion date |
| Duration | Human-readable duration |

### Abandoned Workflows Table

| Column | Description |
|--------|-------------|
| ID | Workflow identifier |
| Project | Project slug |
| Repo | Full path to repository |
| Reason | Why abandoned |
| Started | Start date |
| Abandoned | Abandonment date |
