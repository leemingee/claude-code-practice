---
description: Monthly context management. Archives observations and resets rolling window.
---

# Monthly Review

## Purpose

This command prevents context window overflow by:
1. Summarizing the month's patterns and observations
2. Archiving detailed observations to monthly file
3. Resetting the 14-day rolling window
4. Promoting persistent patterns

**Run this on the last day of each month or first day of new month.**

## Context Loading

LOAD:
- CLAUDE.md: Full
- NOW.md: Full (especially Memory Log)
- journal/: All entries from current month
- metrics/: All weekly reports from current month

DO NOT LOAD:
- Previous months' archives (unless comparing)
- Brain dumps (unless specifically relevant)
- Briefs

## Flow

### 1. Get Context

Run: `date '+%B %Y'`

Identify:
- Month being reviewed
- Number of days tracked
- Number of journal entries

### 2. Analyze Month

**Pattern Summary:**

Review Active Patterns table:
- Which patterns increased in count?
- Which patterns became Active (hit 3x)?
- Which patterns stayed stable?
- Any patterns that should be Confirmed (persistent despite intervention)?

**MIT Performance:**

From journals:
- Total MITs set
- Total MITs completed
- Completion rate
- Most common blockers

**Mode Distribution:**

- How many days in each mode?
- Any mode stagnation?
- Mode switching patterns

**Significant Events:**

From observations:
- Key quotes saved
- Major wins
- Major blockers
- Turning points

### 3. Create Monthly Archive

Create `metrics/monthly-archive-YYYY-MM.md`:

```markdown
# Monthly Archive: [Month Year]

## Overview
- **Days Tracked:** X
- **Journal Entries:** X
- **MIT Completion Rate:** X%
- **Primary Mode:** [Most common mode]

## Pattern Evolution

| Pattern | Start Count | End Count | Status Change | Notes |
|---------|-------------|-----------|---------------|-------|
| [pattern] | X | Y | [Watching→Active] | [note] |

### Patterns Promoted to Active
- **[Pattern]:** Hit 3x on [date]. Evidence: [summary]

### Patterns Confirmed
- **[Pattern]:** Persistent despite [interventions]. Consider CLAUDE.md update.

## Mode Distribution

| Mode | Days | Percentage |
|------|------|------------|
| BUILD | X | X% |
| PLAN | X | X% |
| RESEARCH | X | X% |
| HUMAN | X | X% |

## MIT Analysis

### Completion by Week
| Week | Set | Complete | Rate |
|------|-----|----------|------|
| Week 1 | X | Y | Z% |
| Week 2 | X | Y | Z% |
| Week 3 | X | Y | Z% |
| Week 4 | X | Y | Z% |

### Common Blockers
1. [Blocker] — [X times]
2. [Blocker] — [X times]

## Key Quotes

### Insights
- *"[quote]"* — [date], [context]

### Warnings
- *"[quote]"* — [date], [what it revealed]

## Wins
1. [Major win]
2. [Major win]
3. [Major win]

## Lessons Learned
1. [Lesson]
2. [Lesson]

## Recommendations for Next Month
1. [Focus area]
2. [Pattern to watch]
3. [Behavior to change]

---

*Archived: [timestamp]*
```

### 4. Update NOW.md

**Reset Recent Observations:**

Move all observations older than 14 days to archive reference:
```markdown
## Recent Observations (Last 14 Days)

[Keep only last 14 days of observations]

### Archived
See `metrics/monthly-archive-YYYY-MM.md` for [Month] observations.
```

**Update Monthly Archive section:**

```markdown
## Monthly Archive

### [Current Month Year]
- [Compressed 2-3 line summary]
- Key patterns: [list]
- MIT rate: X%
- See: `metrics/monthly-archive-YYYY-MM.md`

### [Previous months...]
```

**Update Active Patterns:**

- Patterns with Count >= 5 and no improvement → Status: Confirmed
- Consider suggesting CLAUDE.md update for Confirmed patterns

### 5. CLAUDE.md Check

Review if any Confirmed patterns should be added to CLAUDE.md Bugs section:

If pattern is:
- Observed 5+ times
- Persisted across multiple weeks
- Significantly impacting productivity

Suggest:
"Pattern '[name]' has been Confirmed for [X] weeks. Should I add it to your Bugs in CLAUDE.md?"

If yes, update CLAUDE.md Bugs section.

### 6. Challenge Moment

Based on monthly data:

**If MIT rate < 60%:**
"You completed [X]% of your MITs this month. That's below sustainable. What's the real blocker?"

**If same pattern dominated:**
"[Pattern] showed up [X] times this month. You've known about it. What's actually going to change?"

**If mode never changed:**
"You stayed in [MODE] the entire month. Is that serving you, or are you avoiding something?"

### 7. Set Next Month Focus

Based on analysis:
1. Suggest 1-2 focus areas
2. Suggest 1 pattern to actively address
3. Suggest 1 metric to improve

Ask: "Does this focus feel right for [next month]?"

### 8. Close

```
Monthly Review Complete: [Month Year]

Summary:
- MIT Rate: X%
- Patterns Promoted: [count]
- Top Pattern: [name] (X occurrences)

Archived to: metrics/monthly-archive-YYYY-MM.md
NOW.md observations reset.

Focus for [Next Month]:
1. [Focus 1]
2. [Focus 2]

Ready for a fresh start.
```
