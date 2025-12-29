# /workflows:implement

Main implementation workflow with checkpoint awareness, confidence-based gating, and failure handling.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier (required)
- SUBTASK-ID: Specific subtask to work on (optional)
- Or: Natural language continuation (e.g., "proceed", "continue", "go ahead")

Examples:
- `/workflows:implement TEST-001` - Continue from current state
- `/workflows:implement TEST-001 D-1` - Work on specific subtask
- `/workflows:implement proceed` - Continue most recent workflow
- Just say "proceed" or "continue" after a plan is presented

## Confidence-Based Gating

This workflow adapts its formality based on task complexity and confidence:

| Confidence | Planning | Review Gates | User Interaction |
|------------|----------|--------------|------------------|
| **High** | Inline (no separate doc) | Code review only | Show result, request approval |
| **Medium** | Brief plan | Code + quick user check | "Here's my approach, OK?" |
| **Low** | Full formal plan + to-do | All gates | Explicit approval at each step |

### Confidence Assessment Factors

| Factor | High Confidence | Low Confidence |
|--------|-----------------|----------------|
| Pattern match | Seen this exact pattern | New pattern |
| Files affected | 1-3 files | 4+ files |
| Scope | Single component | Cross-cutting |
| Ambiguity | Requirements crystal clear | Open questions remain |
| Risk | Low impact if wrong | High impact |

## Instructions

### Phase 0: State Recovery

#### 0.1 Parse Arguments

Extract ISSUE-ID and optional SUBTASK-ID from $ARGUMENTS.

#### 0.2 Verify Workflow Exists

Check `features/{ISSUE-ID}/workflow-state.md` exists.

If not exists:
- Report: "No workflow found for {ISSUE-ID}"
- Suggest: "Run /workflows:start {ISSUE-ID} first"
- Exit

#### 0.3 Read Current State

Read workflow-state.md and determine:
- Current checkpoint
- Current subtask (if any)
- Current status

If status is "blocked":
- Report active blockers
- Ask user to resolve or use /workflows:jump
- Exit unless user provides resolution

#### 0.4 Route to Appropriate Phase

Based on current checkpoint:
- CHECKPOINT_REQUIREMENTS → Suggest /workflows:start to complete requirements
- CHECKPOINT_PLAN → Go to Phase 1 (Planning)
- CHECKPOINT_IMPLEMENTATION → Go to Phase 2 (Implementation)
- CHECKPOINT_REVIEW → Go to Phase 3 (Final Review)
- CHECKPOINT_COMPLETE → Report "Workflow already complete"

---

### Phase 1: Planning (CHECKPOINT_PLAN)

#### 1.0 Check Confidence Level

Read complexity assessment from workflow-state.md (set during /workflows:start).

**If High Confidence (skip formal planning):**
```
Skip to Phase 1.5 (Lightweight Planning):
- Mentally plan approach (don't create separate doc)
- Present brief summary to user
- If user says "proceed" or similar → go directly to Phase 2
- Create implementation-plan.md only if user requests detail
```

**If Medium Confidence:**
```
Create brief implementation-plan.md:
- Overview (2-3 sentences)
- Files to change (list)
- Approach (bullet points)
Skip formal to-do breakdown unless multi-day effort
Present for quick confirmation
```

**If Low Confidence:**
```
Full formal planning (sections 1.1-1.9)
```

#### 1.1 Gather Context

Read in order:
1. `features/{ISSUE-ID}/requirements.md`
2. Project CLAUDE.md files (root and relevant subdirectories)
3. Relevant documentation in project `docs/` directories

#### 1.2 Study Codebase

Based on requirements:
- Identify affected modules/packages
- Read existing related implementations
- Note patterns and conventions used

#### 1.3 Reassess Confidence

After studying codebase, update confidence if needed:
- Found similar implementation? → Confidence UP
- Discovered complexity not in requirements? → Confidence DOWN
- Unclear patterns? → Confidence DOWN

Update workflow-state.md if confidence changed.
If confidence increased to High, consider switching to lightweight path.

#### 1.4 Create Implementation Plan

**For High Confidence (lightweight):**
```markdown
## Quick Plan: {ISSUE-ID}

**Approach:** {1-2 sentences}

**Changes:**
- {file1}: {what}
- {file2}: {what}

**Following pattern from:** {reference file}
```

**For Medium/Low Confidence (full):**

If `features/{ISSUE-ID}/implementation-plan.md` does not exist:

Create with structure:
```markdown
# Implementation Plan: {ISSUE-ID}

## Overview
{High-level description of the implementation approach}

## Affected Components
- {component}: {what changes}
...

## Technical Decisions
### Decision 1: {title}
- Options considered: {options}
- Chosen approach: {approach}
- Rationale: {why}

## Dependencies
- {dependency}: {how it's used}

## Risks and Mitigations
- Risk: {risk}
  Mitigation: {mitigation}

## Open Questions for User
{Any decisions that need user input}
```

#### 1.4 User Review of Plan

Present implementation plan summary to user.

If user has feedback:
- Update plan based on feedback
- Re-present for review
- Loop until approved

#### 1.5 Run Solution Review

Execute review logic:
- Does plan follow project patterns?
- Are all requirements addressed?
- Are there architectural concerns?

If issues found:
- Present issues to user
- Update plan
- Loop until clean

#### 1.6 Create To-Do Document

If `features/{ISSUE-ID}/to-do.md` does not exist:

Create with structure:
```markdown
# To-Do: {ISSUE-ID}

## Subtasks

### D-1. {First subtask title}

- [ ] {step 1}
- [ ] {step 2}
...
- [ ] Run code review
- [ ] Wait for user review
- [ ] Commit

### D-2. {Second subtask title}
...
```

Guidelines for subtask creation:
- Each subtask = one meaningful commit
- Order to minimize dependencies
- Include test steps within subtasks
- Always end with: code review, user review, commit

#### 1.7 Run To-Do Review

Execute review logic:
- Are all requirements covered by subtasks?
- Is ordering optimal?
- Are subtasks appropriately sized?

If issues found:
- Present issues to user
- Update to-do
- Loop until clean

#### 1.8 User Approval of To-Do

Present to-do document to user.

If user has feedback:
- Update based on feedback
- Re-present for review
- Loop until approved

#### 1.9 Initialize Subtask Tracking

For each subtask in to-do.md:
- Add row to Subtask Progress table in workflow-state.md
- Status: pending
- Attempts: 0

#### 1.10 Transition to Implementation

Update workflow-state.md:
- Checkpoint: CHECKPOINT_IMPLEMENTATION
- Subtask: First subtask ID (e.g., D-1)
- Status: in_progress
- Record checkpoint transition

Inform user:
```
Planning complete. Ready to implement.

First subtask: {subtask-id} - {subtask-title}

Continue with /workflows:implement {ISSUE-ID} or specify subtask.
```

---

### Phase 2: Implementation (CHECKPOINT_IMPLEMENTATION)

#### 2.1 Determine Target Subtask

If SUBTASK-ID provided in arguments:
- Verify subtask exists in to-do.md
- Use specified subtask

Else:
- Read current subtask from workflow-state.md
- If null, find first non-complete subtask

#### 2.2 Validate Subtask Prerequisites

Check if previous subtasks are complete:
- If dependencies exist and are incomplete, warn user
- Allow override if user confirms

#### 2.3 Gather Subtask Context

Read in order:
1. `features/{ISSUE-ID}/requirements.md`
2. `features/{ISSUE-ID}/implementation-plan.md`
3. `features/{ISSUE-ID}/to-do.md` (current subtask section)
4. Previous subtask implementation overviews: `features/{ISSUE-ID}/{prev-subtask}-implementation-overview.md`
5. Relevant CLAUDE.md files
6. Related source code

#### 2.4 Create Subtask Implementation Plan

Create `features/{ISSUE-ID}/{SUBTASK-ID}-implementation-plan.md`:

```markdown
# Subtask Plan: {SUBTASK-ID}

## Objective
{What this subtask accomplishes}

## Context Gathered
- Requirements: {relevant requirements}
- Previous work: {what was built in earlier subtasks}

## Implementation Steps

### Step 1: {description}
- File: {path}
- Action: {create/modify}
- Details: {specifics}

### Step 2: {description}
...

## Skills to Use
- {skill-name}: for {purpose}

## Test Scenarios
- {scenario 1}
- {scenario 2}

## Questions (if any)
{Questions for user}
```

#### 2.5 User Review of Subtask Plan

Present subtask plan to user.
WAIT for explicit approval before proceeding.

If user has feedback:
- Update subtask plan
- Re-present for review
- Loop until approved

#### 2.6 Implement

Update workflow-state.md:
- Subtask status: in_progress
- Increment attempts

Execute implementation:
- Follow steps in subtask plan
- Use relevant skills
- Write code following project patterns
- Create/update tests as specified

#### 2.7 Run Code Review

Determine domain and invoke appropriate code review subagent:
- iOS code → ios/code-reviewer
- Android code → android/code-reviewer
- Backend code → backend/code-reviewer
- Infrastructure → infra/security-reviewer

If review has issues:
- Fix issues
- Re-run review
- Track fix iterations
- Loop until passed

#### 2.8 User Review Gate

Present changes to user for review.
ALWAYS wait for explicit approval. No bypassing.

If user has feedback:
- Incorporate feedback
- Return to step 2.7 (re-run code review)
- Loop until approved

#### 2.9 Failure Evaluation

At any point during implementation, if a fundamental issue is discovered:

1. Pause implementation
2. Invoke failure-classifier subagent with:
   - Description of failure
   - Current context

3. Based on classification:
   - EXECUTION_FAILURE: Fix and continue (stay in current phase)
   - PLAN_FAILURE:
     - Save current progress
     - Report to user: "Plan issue discovered: {reason}"
     - Execute /workflows:jump {ISSUE-ID} PLAN "{reason}"
   - REQUIREMENTS_FAILURE:
     - Save current progress
     - Report to user: "Requirements issue discovered: {reason}"
     - Execute /workflows:jump {ISSUE-ID} REQUIREMENTS "{reason}"

#### 2.10 Commit Changes

After approval:
- Create commit with appropriate message format
- Reference issue ID in commit message

Use domain-specific commit skill if available.

#### 2.11 Create Implementation Overview

Create `features/{ISSUE-ID}/{SUBTASK-ID}-implementation-overview.md`:

```markdown
# Implementation Overview: {SUBTASK-ID}

## Summary
{What was implemented}

## Files Changed
- `{path}`: {description of changes}
...

## Key Decisions
- {decision}: {rationale}

## Tests Added
- {test file}: {what it tests}

## Documentation Referenced
- {doc path}: {how it was used}

## Notes for Next Subtasks
{Anything subsequent subtasks should know}
```

#### 2.12 Update State

Update workflow-state.md:
- Mark current subtask complete
- Set next subtask as current (if any)
- Record any blockers encountered

Update to-do.md:
- Check off completed items in current subtask

Commit state changes.

#### 2.13 Continue or Complete

If more subtasks remain:
- Report progress: "{completed}/{total} subtasks complete"
- Ask: "Continue to next subtask ({next-subtask-id})?"
- If yes: Loop to step 2.1 with next subtask
- If no: Save state for later resume

If all subtasks complete:
- Transition to CHECKPOINT_REVIEW
- Continue to Phase 3

---

### Phase 3: Final Review (CHECKPOINT_REVIEW)

#### 3.1 Full Implementation Review

Review all changes made during this workflow:
- Read all implementation overviews
- Check for consistency across subtasks
- Verify all requirements are met

#### 3.2 Integration Validation

If applicable:
- Run full test suite
- Verify components work together
- Check for regressions

#### 3.3 Final User Approval

Present complete implementation summary:
- List of all files changed
- Summary of each subtask
- Verification that all acceptance criteria are met

WAIT for explicit approval.

If issues found:
- Classify failure level
- Jump to appropriate checkpoint
- Resume workflow from there

#### 3.4 Completion

Update workflow-state.md:
- Checkpoint: CHECKPOINT_COMPLETE
- Status: complete

Report:
```
Workflow Complete: {ISSUE-ID}

Summary:
- Subtasks completed: {total}
- Total commits: {count}
- Files changed: {count}

All acceptance criteria verified.
```

---

## Error Handling

- If any file read fails: Report error, suggest recovery steps
- If user cancels: Save current state, allow resume
- If external tool fails: Report error, attempt alternative approach
- If stuck in loop (>5 iterations): Pause, ask user for guidance
