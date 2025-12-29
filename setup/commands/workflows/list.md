# /workflows:list

Show all workflows across all projects.

## Arguments

$ARGUMENTS can contain:
- `--all` or `-a`: Include completed and abandoned workflows
- `--project {name}`: Filter by project
- `--active`: Only active workflows (default)
- `--completed`: Only completed workflows
- `--abandoned`: Only abandoned workflows

Examples:
- `/workflows:list` - Show active workflows
- `/workflows:list --all` - Show everything
- `/workflows:list --project ios-app` - Filter by project

## Instructions

### 1. Read Registry

Read `~/.claude/workflows/registry.md`

Parse the tables:
- Active Workflows
- Completed Workflows (if --all or --completed)
- Abandoned Workflows (if --all or --abandoned)

### 2. Apply Filters

If `--project` specified:
- Filter to only matching project slug

### 3. Format Output

#### Active Workflows

```
=== Active Workflows ===

┌─────────────┬──────────────────┬─────────────────────┬─────────┐
│ ID          │ Project          │ Checkpoint          │ Updated │
├─────────────┼──────────────────┼─────────────────────┼─────────┤
│ GH-123      │ ios-app          │ IMPLEMENTATION D-2  │ 2h ago  │
│ LOCAL-auth  │ backend          │ PLAN                │ 1d ago  │
│ GH-456      │ terraform        │ REQUIREMENTS        │ 3d ago  │
└─────────────┴──────────────────┴─────────────────────┴─────────┘

3 active workflows across 3 projects
```

If no active workflows:
```
No active workflows.

Start one with:
  /workflows:start Fix the bug in AuthManager.swift
  /workflows:start #42
```

#### With --all Flag

```
=== Active Workflows ===
{table as above}

=== Recently Completed ===
┌─────────────┬──────────────────┬─────────┬────────────┐
│ ID          │ Project          │ Outcome │ Completed  │
├─────────────┼──────────────────┼─────────┼────────────┤
│ LOCAL-login │ ios-app          │ SUCCESS │ 2024-12-26 │
│ GH-100      │ backend          │ SUCCESS │ 2024-12-25 │
└─────────────┴──────────────────┴─────────┴────────────┘

=== Abandoned ===
(none)

=== Statistics ===
Total: 5 workflows
Completed: 2 (100% success rate)
Active: 3
Abandoned: 0
```

### 4. Offer Actions

After listing, offer contextual actions:

```
Actions:
  [1] Continue GH-123 (ios-app, IMPLEMENTATION D-2)
  [2] Continue LOCAL-auth (backend, PLAN)
  [3] Start new workflow

Enter number or describe new task:
```

If user enters a number, switch to that workflow.
If user describes a task, start new workflow.

### 5. Cross-Project Context

When switching to a workflow in a different repo:

```
Switching to GH-123 in ~/src/ios-app

Context loaded:
- Checkpoint: IMPLEMENTATION
- Subtask: D-2 (Implement notification handler)
- Last worked: 2 hours ago

Continue? (yes/no)
```

## Quick Mode

If only one active workflow exists:

```
You have 1 active workflow:

GH-123 (ios-app): IMPLEMENTATION D-2
  "Implement push notification support"
  Last updated: 2 hours ago

Continue this workflow? (yes/no/new)
```

## Error Handling

If registry doesn't exist:
```
No workflow registry found.

This is your first time using the workflow system!
Start with: /workflows:start {description or issue ID}
```

If registry is corrupted:
- Attempt to parse what's readable
- Report specific parsing errors
- Suggest manual inspection of ~/.claude/workflows/registry.md
