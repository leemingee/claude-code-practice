# /workflows:review:solution

Review an implementation plan for pattern compliance and requirements coverage.

## Arguments

$ARGUMENTS should contain:
- ISSUE-ID: The task identifier

Example: `/workflows:review:solution TEST-001`

## Instructions

### 1. Gather Context

Read in order:
1. `features/{ISSUE-ID}/requirements.md`
2. `features/{ISSUE-ID}/implementation-plan.md`
3. Any UML diagrams or additional docs in the feature directory
4. Relevant CLAUDE.md files for affected components
5. Project documentation in `docs/` directories

### 2. Review for Pattern Compliance

Check the implementation plan against project patterns:

#### Architecture Patterns
- Does the solution follow the project's architectural style?
- Are component boundaries respected?
- Is the separation of concerns appropriate?

#### Naming Conventions
- Do proposed class/method names follow project conventions?
- Are file locations consistent with project structure?

#### Design Principles
- Does the solution apply appropriate design patterns?
- Are there any anti-patterns being introduced?
- Is the solution appropriately simple (not over-engineered)?

### 3. Review for Requirements Coverage

For each requirement in requirements.md:
- Is it addressed by the implementation plan?
- Is the approach sufficient to meet the requirement?
- Are acceptance criteria achievable with this plan?

Create a traceability matrix:

| Requirement | Covered By | Status |
|-------------|------------|--------|
| FR-1 | {plan section} | COVERED / PARTIAL / MISSING |
| FR-2 | {plan section} | COVERED / PARTIAL / MISSING |
| NFR-1 | {plan section} | COVERED / PARTIAL / MISSING |

### 4. Review for Completeness

Check that the plan addresses:
- [ ] Happy path implementation
- [ ] Error handling strategy
- [ ] Edge cases mentioned in requirements
- [ ] Testing approach
- [ ] Performance considerations (if applicable)
- [ ] Security considerations (if applicable)

### 5. Review for Feasibility

Assess:
- Are there any technical blockers not addressed?
- Does the plan rely on assumptions that need validation?
- Are external dependencies correctly understood?

### 6. Generate Review Report

Output:

```markdown
## Solution Review: {ISSUE-ID}

### Summary
{APPROVED / NEEDS REVISION}

### Pattern Compliance
✓ {pattern followed}
✗ {pattern violated}: {explanation}

### Requirements Coverage
| Requirement | Status | Notes |
|-------------|--------|-------|
| FR-1 | ✓ COVERED | |
| FR-2 | ⚠ PARTIAL | Missing {x} |
| NFR-1 | ✗ MISSING | Not addressed |

### Completeness Check
- [x] Happy path
- [ ] Error handling (needs: {details})
- [x] Edge cases
- [ ] Testing approach (needs: {details})

### Feasibility Concerns
{Any technical concerns or blocking issues}

### Recommendations
1. {recommendation}
2. {recommendation}

### Verdict
{Clear statement of what needs to change, or confirmation of approval}
```

### 7. Update Implementation Plan

If issues were found:
- Add "## Review Notes" section to implementation-plan.md
- List issues that need addressing
- Do NOT modify the original plan content (user should revise)

If approved:
- Add approval note with timestamp to implementation-plan.md
