---
name: workflow-state-management
description: Manages workflow-state.md files for checkpoint tracking, jump history, and subtask progress. Used by all workflow commands.
---

# Workflow State Management

Manages the persistent state file that tracks workflow progress across sessions.

## When to Use

- Creating a new workflow state for a task
- Reading current checkpoint and subtask
- Recording checkpoint transitions
- Recording jumps between phases
- Updating subtask progress
- Adding/resolving blockers

## State File Location

`features/{ISSUE-ID}/workflow-state.md`

## State File Schema

```markdown
# Workflow State: {ISSUE-ID}

## Current Position
- **Checkpoint:** CHECKPOINT_REQUIREMENTS | CHECKPOINT_PLAN | CHECKPOINT_IMPLEMENTATION | CHECKPOINT_REVIEW | CHECKPOINT_COMPLETE
- **Subtask:** {subtask-id} or null
- **Status:** in_progress | blocked | waiting_review | complete

## Checkpoint History
| Checkpoint | Entries | Exits | Last Entry |
|------------|---------|-------|------------|
| REQUIREMENTS | 0 | 0 | - |
| PLAN | 0 | 0 | - |
| IMPLEMENTATION | 0 | 0 | - |
| REVIEW | 0 | 0 | - |
| COMPLETE | 0 | 0 | - |

## Jump History
| From | To | Reason | Timestamp |
|------|-----|--------|-----------|

## Active Blockers
(none)

## Resolved Blockers
(none)

## Subtask Progress
| Subtask | Status | Attempts | Notes |
|---------|--------|----------|-------|
```

## Operations

### Initialize State

Create new workflow-state.md with:
- Checkpoint: CHECKPOINT_REQUIREMENTS
- Status: in_progress
- All histories empty
- Timestamp: current date/time

### Read Current State

Parse workflow-state.md and extract:
- Current checkpoint
- Current subtask (if any)
- Current status
- Active blockers

### Transition Checkpoint

When moving to next checkpoint:
1. Increment "Exits" for current checkpoint
2. Increment "Entries" for new checkpoint
3. Update "Last Entry" timestamp
4. Update Current Position section
5. Clear subtask if moving backward

### Record Jump

When jumping between phases:
1. Add row to Jump History with:
   - From: `{checkpoint}:{subtask}` or just `{checkpoint}`
   - To: target checkpoint
   - Reason: provided reason
   - Timestamp: current date/time
2. Execute Transition Checkpoint logic

### Update Subtask Progress

When subtask status changes:
1. Find subtask row in Subtask Progress table
2. Update Status column
3. Increment Attempts if retrying
4. Add notes if provided
5. Update Current Position subtask field

### Add Blocker

1. Add item to Active Blockers section
2. Update Status to "blocked"

### Resolve Blocker

1. Move item from Active Blockers to Resolved Blockers
2. Add resolution note
3. Update Status to "in_progress"

## Validation Rules

- Checkpoint must be one of the five valid values
- Cannot transition forward by skipping checkpoints (except via explicit approval)
- Cannot jump forward (only backward)
- Subtask must exist in to-do.md if specified
- Attempts must be >= 1

## Example Usage

Creating initial state:
```markdown
# Workflow State: TEST-001

## Current Position
- **Checkpoint:** CHECKPOINT_REQUIREMENTS
- **Subtask:** null
- **Status:** in_progress

## Checkpoint History
| Checkpoint | Entries | Exits | Last Entry |
|------------|---------|-------|------------|
| REQUIREMENTS | 1 | 0 | 2024-01-15 10:00 |
| PLAN | 0 | 0 | - |
| IMPLEMENTATION | 0 | 0 | - |
| REVIEW | 0 | 0 | - |
| COMPLETE | 0 | 0 | - |

## Jump History
| From | To | Reason | Timestamp |
|------|-----|--------|-----------|

## Active Blockers
(none)

## Resolved Blockers
(none)

## Subtask Progress
| Subtask | Status | Attempts | Notes |
|---------|--------|----------|-------|
```
