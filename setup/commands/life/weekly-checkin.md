---
description: Weekly metrics review. Track engineering excellence and patterns.
---

# Weekly Check-in

## Context Loading

LOAD:
- CLAUDE.md: Full (identity, bugs, metrics definitions)
- NOW.md: Full (metrics, patterns, observations)
- journal/: All entries from past 7 days
- metrics/: Previous weekly report (if exists)

DO NOT LOAD:
- Brain dumps
- Briefs
- Old journals (>7 days)

## Flow

### 1. Get Context

Run: `date '+%A %B %d, %Y'`

Calculate week range: [Monday] to [Sunday]

### 2. Gather Data

**From Journals:**
- Count MIT completions vs incomplete
- Extract blockers mentioned
- Note wins and accomplishments
- Collect quotes worth remembering

**From NOW.md:**
- Current pattern counts
- Mode changes during week
- Any patterns that hit 3x threshold

**From GitHub (if Phase 3 active):**
Run:
```bash
# Commits this week
gh api graphql -f query='...' # or use gh CLI

# PRs merged
gh pr list --state merged --author @me --json number,title,mergedAt

# Review rounds (if trackable)
```

### 3. Calculate Metrics

**Engineering Excellence:**

| Metric | This Week | Last Week | Target | Status |
|--------|-----------|-----------|--------|--------|
| MIT Completion Rate | X/7 | Y/7 | 5/7 | [On/Off Track] |
| PR Review Rounds (avg) | X | Y | <3 | [On/Off Track] |
| Commits | X | Y | - | [Trend] |
| PRs Merged | X | Y | - | [Trend] |
| Features Shipped | X | Y | - | [Trend] |

**Pattern Activity:**

| Pattern | Count Start | Count End | Status Change |
|---------|-------------|-----------|---------------|
| [pattern] | X | Y | [Watching/Active/Confirmed] |

### 4. Generate Dashboard

Create ASCII visualization:

```
MIT Completion
[████████░░] 80% (4/5 days tracked)

PR Review Rounds
Week Avg: 2.3 [████████░░░░░░░] Target: <3 ✓

Commits
Mon ██████
Tue ████████████
Wed ████
Thu ██████████
Fri ████████
     0    5    10   15

Pattern Watch
┌─────────────────────────────┐
│ AI Round-trips: ██░ (2/3)   │
│ Self-reflection: █░░ (1/3)  │
└─────────────────────────────┘
```

### 5. Create Report

Create `metrics/weekly-report-YYYY-MM-DD.md`:

```markdown
# Weekly Report: [Week Range]

## Summary
[2-3 sentence overview of the week]

## Metrics Dashboard

[ASCII visualizations from step 4]

## Wins
- [Win 1]
- [Win 2]
- [Win 3]

## Blockers Encountered
- [Blocker 1]: [How resolved or still active]

## Pattern Analysis

### Patterns Triggered
- [Pattern]: [Count] times — [Analysis]

### New Patterns Observed
- [New pattern if any]

## Quotes of the Week
- *"[Quote 1]"* — [Context]
- *"[Quote 2]"* — [Context]

## Next Week Focus
Based on this week's patterns:
1. [Focus area 1]
2. [Focus area 2]

---

*Generated: [timestamp]*
```

### 6. Update NOW.md

Update metrics section with this week's data:
- Fill in "This Week" column
- Move previous "This Week" to "Last Week"
- Calculate trends

### 7. Challenge Check

Apply Challenge Rules based on weekly data:

**Rule #5 Check:** MIT incomplete 3+ times this week?
- If yes: "You missed your MIT [X] times this week. What's the pattern?"

**Pattern Threshold:** Any pattern hit 3x this week?
- If yes: Promote to Active, mention it

**Mode Stagnation:** Same mode all week?
- If yes and 5+ days: "You've been in [MODE] all week. Intentional?"

### 8. Close

Present summary:
```
Weekly Report: metrics/weekly-report-YYYY-MM-DD.md

MIT: X/7 [trend emoji]
Commits: X [trend emoji]
Pattern Watch: [most significant pattern]

[One actionable insight for next week]
```
