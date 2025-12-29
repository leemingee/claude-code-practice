# /workflows:status

Display current workflow state for a task.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier

Example: `/workflows:status TEST-001`

## Instructions

### 1. Parse Arguments

Extract ISSUE-ID from $ARGUMENTS.

If no ISSUE-ID provided:
- List all directories in `features/`
- Ask user which task to check

### 2. Verify Task Exists

Check if `features/{ISSUE-ID}/workflow-state.md` exists.

If not exists:
- Report: "No workflow found for {ISSUE-ID}"
- Suggest: "Run /workflows:start {ISSUE-ID} to initialize"
- Exit

### 3. Read Workflow State

Read and parse `features/{ISSUE-ID}/workflow-state.md`

Extract:
- Current checkpoint
- Current subtask
- Current status
- Active blockers (if any)
- Recent jumps (last 3)
- Subtask progress summary

### 4. Calculate Progress

If to-do.md exists:
- Count total subtasks
- Count completed subtasks
- Calculate percentage: (completed / total) * 100

### 5. Display Status Report

Output formatted status:

```
=== Workflow Status: {ISSUE-ID} ===

Current Position
----------------
Checkpoint:  {CHECKPOINT_NAME}
Subtask:     {subtask-id or "N/A"}
Status:      {status}

Progress
--------
Subtasks:    {completed}/{total} ({percentage}%)
[████████░░░░░░░░░░░░]

Checkpoint History
------------------
✓ REQUIREMENTS  (entered: 1, exited: 1)
✓ PLAN          (entered: 1, exited: 1)
→ IMPLEMENTATION (entered: 1, exited: 0)  ← CURRENT
○ REVIEW        (not reached)
○ COMPLETE      (not reached)

{IF blockers exist}
Active Blockers
---------------
! {blocker description}

{IF recent jumps exist}
Recent Jumps
------------
{timestamp}: {from} → {to}
  Reason: {reason}

Next Actions
------------
{Contextual suggestion based on current state}
```

### 6. Suggest Next Action

Based on current state, suggest appropriate command:

| State | Suggestion |
|-------|------------|
| CHECKPOINT_REQUIREMENTS, in_progress | "Continue requirements gathering with /workflows:start {ISSUE-ID}" |
| CHECKPOINT_PLAN, in_progress | "Create implementation plan with /workflows:implement {ISSUE-ID}" |
| CHECKPOINT_IMPLEMENTATION, in_progress | "Continue implementation with /workflows:implement {ISSUE-ID} {subtask}" |
| CHECKPOINT_IMPLEMENTATION, waiting_review | "Complete review and run /workflows:implement {ISSUE-ID} {subtask}" |
| Any checkpoint, blocked | "Resolve blocker: {blocker description}" |
| CHECKPOINT_REVIEW | "Final review in progress" |
| CHECKPOINT_COMPLETE | "Workflow complete!" |

## Quick Status (Optional)

If $ARGUMENTS contains `--brief` or `-b`:

Output single line:
```
{ISSUE-ID}: {CHECKPOINT} | {subtask} | {completed}/{total} subtasks | {status}
```
