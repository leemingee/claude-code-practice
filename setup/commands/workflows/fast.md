# /workflows:fast

Streamlined workflow for simple, well-understood tasks that still require full review.

## When to Use

- Simple bug fixes with clear reproduction steps
- Adding a field to an existing entity (following established patterns)
- Implementing a feature nearly identical to existing ones
- Small refactoring with limited scope

**Note:** Even for fast workflow, all changes go through code review and user review. "Fast" refers to reduced planning overhead, not reduced quality gates.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier
- Optional: Additional context or hints

Examples:
- `/workflows:fast BUG-123`
- `/workflows:fast FEAT-456 Similar to the settings page implementation`

## Instructions

### 1. Parse Arguments

Extract ISSUE-ID and any additional context from $ARGUMENTS.

### 2. Create Minimal Feature Directory

Create `features/{ISSUE-ID}/` with:
- `workflow-state.md` (initialized to CHECKPOINT_IMPLEMENTATION)
- Skip separate requirements.md and implementation-plan.md (use issue directly)

Initialize workflow-state.md:
- Checkpoint: CHECKPOINT_IMPLEMENTATION
- Subtask: FAST-1
- Status: in_progress

### 3. Gather Context

#### From Task Tracker
If MCP tool available:
- Fetch issue details (description, comments, attachments)
- Extract requirements directly from issue

If no MCP:
- Ask user to provide issue details

#### From Codebase
- Read relevant CLAUDE.md files
- Study related existing implementations
- Identify patterns to follow

### 4. Clarification Loop

REPEAT:
1. Identify any ambiguities in the task
2. Search docs and code for answers
3. If not found: Ask user via AskUserTool
UNTIL: Task is fully understood

### 5. Prepare Quick Implementation Plan

Present to user (in terminal, not saved to file):

```
=== Fast Workflow Plan: {ISSUE-ID} ===

Understanding:
{Brief summary of what needs to be done}

Approach:
1. {step 1}
2. {step 2}
...

Files to Change:
- {file}: {what changes}

Following Pattern From:
- {existing file being used as reference}

Questions:
{Any remaining questions, or "None"}

Ready to proceed? (yes/no/modify)
```

Wait for explicit approval.

If user has modifications:
- Update understanding
- Re-present plan
- Loop until approved

### 6. Implement

Execute the plan:
- Follow established patterns
- Use relevant skills
- Write/update tests as appropriate

### 7. Code Review

Determine domain and invoke appropriate reviewer:
- ios/code-reviewer
- android/code-reviewer
- backend/code-reviewer
- infra/security-reviewer

If issues found:
- Fix issues
- Re-run review
- Loop until passed

### 8. User Review (ALWAYS)

Present changes:

```
=== Changes for Review: {ISSUE-ID} ===

Summary:
{What was changed}

Files Modified:
- {file}: {description}

Tests:
- {test status}

Please review the changes and confirm:
(approve/request changes/reject)
```

Wait for explicit approval.

If changes requested:
- Incorporate feedback
- Return to code review
- Loop until approved

### 9. Commit

Create commit with message:
```
{type}: {brief description}

{ISSUE-ID}

{Longer description if needed}
```

### 10. Update State

Update workflow-state.md:
- Checkpoint: CHECKPOINT_COMPLETE
- Status: complete

### 11. Report Completion

```
=== Fast Workflow Complete: {ISSUE-ID} ===

Changes committed: {commit hash}
Files changed: {count}
Tests: {passed/added}

Task complete.
```

## Error Handling

If at any point the task proves more complex than expected:
- Inform user: "This task is more complex than expected for fast workflow"
- Suggest: "Consider using /workflows:start {ISSUE-ID} for full workflow"
- Allow user to choose: continue fast or switch to full

## Comparison to Full Workflow

| Aspect | Fast | Full |
|--------|------|------|
| Requirements doc | No (use issue) | Yes |
| Implementation plan | Verbal | Written |
| To-do breakdown | No | Yes |
| Subtask structure | Single FAST-1 | D-1, D-2, etc. |
| Code review | Yes | Yes |
| User review | Yes | Yes |
| State tracking | Minimal | Full |
