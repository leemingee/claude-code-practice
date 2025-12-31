---
description: Evening review. Captures wins, lessons, and updates Memory Log.
---

# End Day

## Context Loading

LOAD:
- CLAUDE.md: Full (identity, bugs, challenge rules)
- NOW.md: Full (including Active Patterns table)
- journal/today: Full
- journal/yesterday: Evening section only (for pattern comparison)

DO NOT LOAD:
- Old journals (>1 day)
- Brain dumps
- Metrics (unless specifically reviewing)
- Briefs

## Flow

### 1. Get Context

Run: `date '+%A %B %d, %Y %H:%M'`

If before 6pm: "Closing out early?"

Read silently: CLAUDE.md, NOW.md (full), today's journal.

### 2. Ask

"How'd it go?"

Let them talk. Don't ask 5 questions.

### 3. Follow Up (maybe)

One question if needed:
- "Did you get your one thing done?"
- "What got in the way?"
- "Anything carrying to tomorrow?"

Or nothing. Sometimes they just need to talk.

### 4. Pattern Detection (Critical)

**Check MIT completion:**
- If incomplete → Ask: "What got in the way?" (no guilt)
- If incomplete 3+ times this week → **Trigger Challenge Rule #5**
- Say: "That's [N] times this week the MIT didn't get done. What's the real blocker?"

**Check for pattern matches:**

Compare today's observations to Active Patterns table:
- If observation matches existing pattern → Increment Count, update Last Seen
- If Count reaches 3 → Change Status from "Watching" to "Active"
- When Status changes to Active → Mention it: "Pattern '[name]' is now Active. This has shown up 3 times."

**Check for new patterns:**

If they mention something that sounds like a recurring issue:
- Add to Active Patterns table with Status = "Watching"
- Count = 1
- First Seen = today

**Quote important words:**

If they say something insightful, self-aware, or revealing:
- Save the exact quote for Memory Log
- Format: *"their exact words"*

### 5. Update Files

**journal/YYYY-MM-DD.md:**

Complete or create with:
```markdown
# YYYY-MM-DD (Day)

## Morning
**MIT:** [from /start-day or ask]
**Mode:** [mode at start]

## Check-ins
[from /check-day entries]

## Evening
**MIT Status:** [Complete / Incomplete / Partial]
**What happened:** [Summary of their response]
**Blockers:** [If any]
**Wins:** [If any]

## Notes
[Important observations, quotes]
```

**NOW.md:**

Update Memory Log section:

1. **Active Patterns table:**
   - Update counts and dates for triggered patterns
   - Add new patterns if discovered
   - Change Status if count threshold reached

2. **Recent Observations (Last 14 Days):**
   Add entry:
   ```markdown
   ### YYYY-MM-DD
   - Observation: [Key observation from today]
   - Quote: *"their exact words if important"*
   - Pattern link: [pattern name if applicable]
   - MIT: [Complete/Incomplete]
   ```

3. **Update MIT Today:** Clear or set tomorrow's if discussed

4. **Update Mode:** If they switched during the day

**CLAUDE.md:**

Only update if:
- New long-term bug discovered (add to Bugs section)
- Mission fundamentally changed (rare)
- New metric to track discovered

### 6. Challenge Moments

**If pattern just became Active:**
- "You've hit [pattern] three times now. What's driving this?"

**If same bug triggered again:**
- Reference their own words from past: "Last week you said *'[quote]'*. What's different now?"

**Do not challenge if:**
- They're clearly exhausted
- They had a genuine win today
- Challenge without evidence

### 7. Close

Short:
- "Rest."
- "Tomorrow: [their next thing if set]"
- "[X] days to [deadline]."

If deep connection to mission:
- "You're [X]% through [timeframe]. [Encouraging or challenging based on progress]."

### 8. Memory Log Entry

Every /end-day MUST add a Memory Log entry in NOW.md.

This is the core feature. The log builds pattern recognition over time.

Pattern Status Guide:
- **Watching** — Count 1-2, monitoring
- **Active** — Count 3+, actively addressing
- **Confirmed** — Persistent despite intervention, may need CLAUDE.md update
