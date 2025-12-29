# /workflows:review:todo

Review a to-do document for requirements coverage and optimal task ordering.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier

Example: `/workflows:review:todo TEST-001`

## Instructions

### 1. Gather Context

Read in order:
1. `features/{ISSUE-ID}/requirements.md`
2. `features/{ISSUE-ID}/implementation-plan.md`
3. `features/{ISSUE-ID}/to-do.md`

### 2. Extract All Subtasks

Parse to-do.md to identify:
- All subtask IDs (D-1, D-2, D-1.1, etc.)
- All checklist items within each subtask
- Any dependencies implied by ordering

### 3. Requirements Traceability

For each requirement and acceptance criterion:
- Identify which subtask(s) address it
- Verify it's fully covered (not just partially)

Create traceability:

```markdown
### Requirements → Subtasks Mapping

| Requirement | Covered By | Completeness |
|-------------|------------|--------------|
| FR-1 | D-1, D-2 | COMPLETE |
| FR-2 | D-3 | COMPLETE |
| AC-1 | D-2.1 | PARTIAL - missing {x} |
| AC-2 | (none) | MISSING |
```

### 4. Verify Subtask Ordering

Check that dependencies are respected:
- Database migrations before code using new schema
- Backend APIs before frontend consuming them
- Shared components before dependent features
- Unit tests with or after implementation (not before)

Flag any ordering issues:
```
⚠ D-3 (frontend) depends on D-2 (API) but D-2 comes after D-3
```

### 5. Assess Subtask Sizing

For each subtask, estimate:
- Is it completable in a single context window?
- Is it a single meaningful commit?
- Does it have clear start and end points?

Flag issues:
```
⚠ D-1 appears too large (15 items) - consider splitting
⚠ D-4 appears too small (1 item) - consider merging with D-3
```

### 6. Check Mandatory Elements

Each subtask should end with:
- [ ] Code review step (or indication of which review)
- [ ] User review step ("Wait for review")
- [ ] Commit step

Flag missing elements:
```
⚠ D-2 missing "Wait for review" step
```

### 7. Generate Review Report

Output:

```markdown
## To-Do Review: {ISSUE-ID}

### Summary
{APPROVED / NEEDS REVISION}

### Requirements Coverage

#### Fully Covered
✓ FR-1: Covered by D-1, D-2
✓ FR-2: Covered by D-3

#### Partially Covered
⚠ AC-1: D-2.1 addresses this but missing {x}

#### Not Covered
✗ AC-2: No subtask addresses this requirement

### Task Ordering
{OPTIMAL / NEEDS ADJUSTMENT}

Issues:
- {ordering issue if any}

### Task Sizing
{APPROPRIATE / NEEDS ADJUSTMENT}

Issues:
- {sizing issue if any}

### Mandatory Elements Check
| Subtask | Code Review | User Review | Commit |
|---------|-------------|-------------|--------|
| D-1 | ✓ | ✓ | ✓ |
| D-2 | ✓ | ✗ | ✓ |

### Recommendations
1. {specific recommendation}
2. {specific recommendation}

### Verdict
{Clear statement of what needs to change, or confirmation of approval}
```

### 8. Update To-Do Document

If issues were found:
- Add "## Review Notes" section to to-do.md
- List specific items that need addressing

If approved:
- Add approval note with timestamp to to-do.md

```markdown
---
**Review Status:** APPROVED
**Reviewed:** {timestamp}
**Requirements Coverage:** Complete
**Task Order:** Optimal
---
```
