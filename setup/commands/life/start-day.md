---
description: Morning kickoff. Sets MIT for the day.
---

# Start Day

## Context Loading

LOAD:
- CLAUDE.md: Full (identity, bugs, challenge rules)
- NOW.md: Mode + Active Patterns table + last MIT
- journal/yesterday: Morning + Evening sections only (if exists)

DO NOT LOAD:
- Old journals (>1 day)
- Brain dumps
- Metrics
- Briefs

## Flow

### 1. Get Context

Run: `date '+%A %B %d, %Y %H:%M'`

Read silently: CLAUDE.md, NOW.md (Mode + Patterns + MIT), yesterday's journal.

### 2. Challenge Check (BEFORE asking MIT)

Check if yesterday's MIT was same as what they'll likely set today:
- If same MIT 2+ days → **Trigger Challenge Rule #1**
- Say: "You set [MIT] yesterday too. What's actually blocking this?"
- Wait for response before continuing.

Check Active Patterns table:
- If any pattern has Count >= 3 and Status = "Watching" → Change to "Active"
- Mention: "Pattern '[name]' just hit 3 occurrences. Worth addressing."

### 3. Ask

"What's your one thing today?"

That's it. Wait for their answer.

### 4. After They Answer

**Update NOW.md:**
- Set MIT Today to their answer
- Update Last Updated date

**Create/update journal:**

Create `journal/YYYY-MM-DD.md`:
```markdown
# YYYY-MM-DD (Day)

## Morning
**MIT:** [their one thing]
**Mode:** [current mode from NOW.md]

## Check-ins
(none yet)

## Evening
(pending)
```

**Check patterns:**
- If their MIT relates to an Active Pattern → mention it
- Example: "This touches on your '[pattern name]' pattern. Stay aware."

### 5. Connect (if appropriate)

If CLAUDE.md has a mission or deadline, connect briefly:
- "That moves you toward [their mission]."
- "[X] days to [deadline]."

### 6. Close

Short:
- "Go."
- "One thing. Get it done."
- "[X] days left. Back to it."

### 7. Observe (don't output)

Notice for later:
- Energy in their words
- Hesitation
- Same MIT as yesterday?
- Avoiding something?

If observation is notable, add to your mental notes for /end-day.
