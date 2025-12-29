# /workflows:jump

Explicitly jump to a different checkpoint when a fundamental issue is discovered.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier (required)
- TARGET: Target checkpoint (required) - REQUIREMENTS or PLAN
- REASON: Reason for the jump (required, can be quoted string)

Examples:
- `/workflows:jump TEST-001 REQUIREMENTS "Discovered missing SSO requirement"`
- `/workflows:jump TEST-001 PLAN "Architecture doesn't support real-time updates"`

## Instructions

### 1. Parse Arguments

Extract from $ARGUMENTS:
- ISSUE-ID
- TARGET checkpoint (must be REQUIREMENTS or PLAN)
- REASON (everything after TARGET, or quoted string)

### 2. Validate Jump

#### 2.1 Verify Workflow Exists

Check `features/{ISSUE-ID}/workflow-state.md` exists.
If not: Report error and exit.

#### 2.2 Verify Target is Valid

Valid targets: REQUIREMENTS, PLAN

Invalid targets:
- IMPLEMENTATION: Cannot jump forward to implementation
- REVIEW: Cannot jump forward to review
- COMPLETE: Cannot jump to complete

#### 2.3 Verify Jump is Backward

Read current checkpoint from workflow-state.md.

Checkpoint order: REQUIREMENTS < PLAN < IMPLEMENTATION < REVIEW < COMPLETE

Jump must go backward (current > target).

If attempting forward jump:
- Report: "Cannot jump forward. Use /workflows:implement to progress."
- Exit

### 3. Preserve Current Work

Before jumping, document what was accomplished:

#### 3.1 If jumping from IMPLEMENTATION

- List completed subtasks
- Save any in-progress work as `{SUBTASK-ID}-partial-work.md`:
  ```markdown
  # Partial Work: {SUBTASK-ID}

  ## Status at Jump
  Checkpoint items completed: {list}
  Checkpoint items remaining: {list}

  ## Files Changed (uncommitted)
  - {file}: {description}

  ## Reason for Jump
  {REASON}

  ## Potential Reusability
  {What might be salvageable after revision}
  ```

#### 3.2 If jumping from PLAN

- Note that implementation-plan.md and to-do.md will need revision
- Do not delete them (they serve as reference)

### 4. Update Workflow State

Update workflow-state.md:

#### 4.1 Record Jump in History

Add row to Jump History table:
- From: `{current-checkpoint}:{current-subtask}` or `{current-checkpoint}`
- To: `{TARGET}`
- Reason: `{REASON}`
- Timestamp: current date/time

#### 4.2 Update Current Position

- Checkpoint: `CHECKPOINT_{TARGET}`
- Subtask: null (clear subtask when jumping backward)
- Status: in_progress

#### 4.3 Update Checkpoint History

- Increment Exits for source checkpoint (if not already exited)
- Increment Entries for target checkpoint
- Update Last Entry timestamp

### 5. Add Context to Target Documents

#### 5.1 If jumping to REQUIREMENTS

Add note to `requirements.md`:

```markdown
---
## Revision Note ({timestamp})

**Trigger:** Jump from {source-checkpoint}
**Reason:** {REASON}

### Areas to Review
- {specific areas based on reason}
---
```

#### 5.2 If jumping to PLAN

Add note to `implementation-plan.md`:

```markdown
---
## Revision Note ({timestamp})

**Trigger:** Jump from {source-checkpoint}
**Reason:** {REASON}

### Areas to Revise
- {specific areas based on reason}

### Completed Subtasks (before jump)
- {list of completed subtasks that may be affected}
---
```

### 6. Determine Impact on Completed Work

Analyze the jump reason to determine if completed subtasks need revision:

If REASON indicates architectural change:
- All subtasks may need revision
- Mark affected subtasks as "needs-review" in Subtask Progress table

If REASON indicates localized issue:
- Identify specific subtasks affected
- Only mark those as "needs-review"

### 7. Report Jump

Output:

```
=== Workflow Jump: {ISSUE-ID} ===

From: {source-checkpoint} {subtask if any}
To:   CHECKPOINT_{TARGET}

Reason: {REASON}

Work Preserved:
- Completed subtasks: {count} ({list if small})
- Partial work saved: {yes/no}

Impact Assessment:
- Subtasks needing review: {count}
- Estimated rework: {low/medium/high}

Next Steps:
1. Review the jump reason in {target-document}
2. Update {document} to address the issue
3. Run /workflows:implement {ISSUE-ID} to continue

Jump recorded in workflow-state.md
```

### 8. Cleanup

If there are uncommitted changes in the working directory:
- Ask user: "There are uncommitted changes. Options:"
  1. Stash changes (can recover later)
  2. Keep changes (will need manual handling)
  3. Discard changes (cannot recover)
- Execute user's choice

## Error Handling

- Missing REASON: Ask user to provide reason (required for audit trail)
- Conflicting jump: If another jump is in progress, report and exit
- File write failure: Report error, attempt recovery
