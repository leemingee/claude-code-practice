---
description: Pattern extraction from raw notes. Captures and analyzes scattered thoughts.
---

# Brain Dump

## Context Loading

LOAD:
- CLAUDE.md: Bugs section, Mission
- NOW.md: Active Patterns table, Current MIT
- brain-dumps/: Recent analysis files (last 3)

DO NOT LOAD:
- Full CLAUDE.md
- Journals
- Metrics
- Briefs

## Flow

### 1. Receive Input

Accept raw input from user. This could be:
- Voice transcription
- Stream of consciousness text
- Meeting notes
- Random thoughts
- Ideas and possibilities
- Frustrations and blockers

Say: "Go ahead. Dump it all."

Wait for their input. Don't interrupt.

### 2. Acknowledge

Brief acknowledgment:
- "Got it."
- "Processing."

Don't summarize yet — let them add more if needed.

Ask: "Anything else, or should I process this?"

### 3. Extract Patterns

Analyze the dump for:

**Themes:**
- What topics came up multiple times?
- What's the emotional undertone?
- What's urgent vs important?

**Action Items:**
- Explicit tasks mentioned
- Implicit tasks (complaints often hide tasks)
- Decisions needed

**Patterns:**
- Does anything match existing Active Patterns?
- Is there a new pattern emerging?
- Connections to known Bugs?

**Insights:**
- Non-obvious connections
- Contradictions worth noting
- Quotes worth saving

### 4. Cross-Reference

Check against:
- **Current MIT:** Does anything relate to today's focus?
- **Active Patterns:** Does this reinforce or contradict patterns?
- **Mission:** Does this move toward or away from goals?
- **Bugs:** Is a known bug showing up?

### 5. Create Analysis

Create `brain-dumps/analysis/YYYY-MM-DD-analysis.md`:

```markdown
# Brain Dump Analysis: YYYY-MM-DD

## Raw Input Summary
[2-3 sentence summary of what they dumped]

## Themes Extracted

### Theme 1: [Name]
- Evidence: [quotes/references from dump]
- Significance: [why this matters]

### Theme 2: [Name]
...

## Action Items Found

| Item | Priority | Relates To |
|------|----------|------------|
| [Task] | High/Med/Low | [MIT/Pattern/Mission] |

## Pattern Connections

| Pattern | Connection | Evidence |
|---------|------------|----------|
| [Existing pattern] | [How dump relates] | [Quote] |

## New Patterns Detected
- [Potential new pattern]: [Evidence from dump]

## Quotes Worth Saving
- *"[exact words]"* — [why significant]

## Insights
- [Non-obvious observation 1]
- [Non-obvious observation 2]

## Recommended Actions
1. [Most important action]
2. [Second action]
3. [Third action]

---

*Processed: [timestamp]*
*Input length: [word count]*
```

### 6. Save Raw (Optional)

If user wants to keep the raw dump:
Create `brain-dumps/YYYY-MM-DD-raw.md` with original input.

### 7. Update NOW.md (if significant)

If analysis reveals:
- New pattern → Add to Active Patterns table (Status: Watching)
- Pattern match → Increment count on existing pattern
- Important quote → Add to Recent Observations

### 8. Present Results

Output to user:

```
Processed your dump.

Themes:
1. [Theme 1]
2. [Theme 2]
3. [Theme 3]

Top Actions:
- [Most important action]
- [Second action]

Pattern Alert: [If any pattern triggered]

Full analysis: brain-dumps/analysis/YYYY-MM-DD-analysis.md

What do you want to do with this?
```

### 9. Follow-up Options

Offer:
- "Want me to add [action] to your MIT?"
- "Should I update the pattern count for [pattern]?"
- "Want to go deeper on [theme]?"

## Close

"Dump processed. Back to work, or more to add?"
