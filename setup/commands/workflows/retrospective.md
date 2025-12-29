# /workflows:retrospective

Generate insights from workflow history for reflection and analysis.

## Arguments

$ARGUMENTS can contain:
- `--week` or `-w`: This week's summary (default)
- `--month` or `-m`: This month's summary
- `--project {name}`: Focus on specific project
- `--all`: All-time analysis

Examples:
- `/workflows:retrospective` - This week
- `/workflows:retrospective --month` - This month
- `/workflows:retrospective --project ios-app` - Project focus

## Instructions

### 1. Gather Data

Read from `~/.claude/workflows/`:
- `registry.md` - All workflow records
- `projects/*.md` - Project details
- `sessions/*.md` - Session logs for the period

### 2. Calculate Metrics

#### Workflow Metrics

```
Workflows Started: {count}
Workflows Completed: {count}
Workflows Abandoned: {count}
Completion Rate: {percentage}

Average Duration: {time}
Fastest: {workflow} ({time})
Longest: {workflow} ({time})
```

#### Project Distribution

```
Project Activity:
  ios-app:      ████████████ 45%
  backend:      ████████     30%
  terraform:    ████         15%
  oss-contrib:  ███          10%
```

#### Checkpoint Analysis

```
Time Spent by Phase:
  REQUIREMENTS:     15%
  PLAN:             25%
  IMPLEMENTATION:   50%
  REVIEW:           10%

Most Jumps To: PLAN (indicates planning gaps)
```

### 3. Identify Patterns

#### Success Patterns

Look for:
- What types of tasks completed quickly?
- Which projects have highest success rate?
- What confidence levels correlated with success?

#### Improvement Opportunities

Look for:
- Repeated jump reasons (same issue occurring)
- Abandoned workflow patterns (why?)
- Long-duration workflows (complexity or blockers?)

### 4. Generate Insights

Format output as:

```
=== Workflow Retrospective: {period} ===

## Summary
{period} you worked on {N} workflows across {M} projects.
Completed {X} ({Y}% success rate).

## Highlights
- Completed {workflow}: {brief achievement}
- Completed {workflow}: {brief achievement}

## Time Distribution
{project distribution chart}

## Patterns Observed

### What Worked Well
- {pattern 1}
- {pattern 2}

### Improvement Opportunities
- {opportunity 1}: Consider {suggestion}
- {opportunity 2}: Consider {suggestion}

## Workflow Details

| Workflow | Project | Outcome | Duration | Notes |
|----------|---------|---------|----------|-------|
| GH-123 | ios-app | SUCCESS | 2 days | Push notifications |
| LOCAL-auth | backend | SUCCESS | 1 day | Auth refactor |

## Recommendations

Based on this period's work:
1. {actionable recommendation}
2. {actionable recommendation}
```

### 5. Save Analysis

Save generated retrospective to:
`~/.claude/workflows/analytics/weekly/YYYY-WNN.md` or
`~/.claude/workflows/analytics/monthly/YYYY-MM.md`

### 6. Compare to Previous Period

If previous period exists:
```
## Compared to Last {period}

- Workflows: {N} → {M} ({change}%)
- Completion Rate: {X}% → {Y}%
- Avg Duration: {A} → {B}

Trend: {improving/stable/declining}
```

## Session-Based Insights

From session logs, extract:
- Total active hours
- Most productive days
- Common blockers mentioned
- Key decisions made
- Skills/patterns created

## Error Handling

- If no data for period: Report "No workflow data found for {period}"
- If partial data: Generate what's available, note gaps
- If analytics directory missing: Create it
