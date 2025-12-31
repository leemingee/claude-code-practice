---
description: Skill for safely reading and writing NOW.md state.
---

# Life State Management

Internal skill for managing NOW.md state. Used by other commands and workflow integration.

## Purpose

Provides safe, validated operations on NOW.md to:
- Prevent corruption
- Ensure consistent format
- Emit events for cross-system triggers
- Support graceful degradation

## Operations

### read_state()

Read current life state from NOW.md.

**Input:** None

**Process:**
1. Check if NOW.md exists at repo root
2. If not exists, return `{ exists: false, state: null }`
3. Parse NOW.md sections
4. Return structured state object

**Output:**
```json
{
  "exists": true,
  "state": {
    "mode": "BUILD",
    "mit": "Set up Life OS foundation",
    "patterns": [
      { "name": "AI tool round-trips", "count": 2, "status": "Watching" }
    ],
    "observations_count": 5,
    "last_updated": "2025-12-29"
  }
}
```

**Graceful Degradation:**
- If NOW.md missing → return empty state, don't error
- If NOW.md malformed → return partial state + warning

---

### write_mit(mit_text)

Update the MIT Today field.

**Input:** `mit_text` (string)

**Process:**
1. Read current NOW.md
2. Find `**MIT Today:**` line
3. Replace value with new MIT
4. Update `Last Updated` date
5. Write file

**Validation:**
- MIT must be non-empty
- MIT should be < 100 characters (warn if longer)

**Output:**
```json
{
  "success": true,
  "previous_mit": "Old MIT text",
  "new_mit": "New MIT text",
  "event": "mit_changed"
}
```

---

### update_mode(new_mode)

Change current mode.

**Input:** `new_mode` (string: BUILD | PLAN | RESEARCH | HUMAN)

**Process:**
1. Validate mode is valid option
2. Read current NOW.md
3. Update `## Current: [MODE]` line
4. Update mode table highlighting
5. Write file

**Event Emitted:** `mode_changed`

**Output:**
```json
{
  "success": true,
  "previous_mode": "BUILD",
  "new_mode": "PLAN",
  "days_in_previous": 3,
  "event": "mode_changed"
}
```

---

### add_observation(observation)

Add entry to Recent Observations section.

**Input:**
```json
{
  "text": "Observation text",
  "quote": "Optional exact quote",
  "pattern_link": "Optional pattern name",
  "mit_status": "Complete | Incomplete | null"
}
```

**Process:**
1. Read NOW.md
2. Parse Recent Observations section
3. Add new entry with today's date
4. If observations > 14 days old, archive them
5. Write file

**Output:**
```json
{
  "success": true,
  "observation_count": 6,
  "archived_count": 0,
  "event": "observation_added"
}
```

---

### update_pattern(pattern_name, increment)

Update pattern count in Active Patterns table.

**Input:**
- `pattern_name` (string)
- `increment` (boolean, default true)

**Process:**
1. Find pattern in Active Patterns table
2. If found:
   - Increment count (or set specific value)
   - Update Last Seen date
   - Check if count >= 3 and status is Watching → change to Active
3. If not found:
   - Add new row with Count: 1, Status: Watching
4. Write file

**Events:**
- `pattern_incremented` — count increased
- `pattern_promoted` — status changed to Active
- `pattern_created` — new pattern added

**Output:**
```json
{
  "success": true,
  "pattern": "AI tool round-trips",
  "count": 3,
  "status": "Active",
  "event": "pattern_promoted",
  "trigger_challenge": true
}
```

---

### check_challenge_triggers()

Check all Challenge Rules and return any that should fire.

**Input:** None (reads current state)

**Process:**
Check each rule:
1. **Repeated MIT** — Compare today's MIT to yesterday's from journal
2. **Pattern Threshold** — Any pattern with count >= 3 and status Watching?
3. **Avoidance Phrases** — N/A (requires user input)
4. **Stale Mode** — Days in current mode >= 5?
5. **Incomplete MIT Streak** — Count incomplete MITs this week from journals

**Output:**
```json
{
  "triggers": [
    {
      "rule": 1,
      "name": "Repeated MIT",
      "evidence": "Same MIT 'Ship login flow' for 2 days",
      "challenge_question": "What's actually blocking this?"
    },
    {
      "rule": 4,
      "name": "Stale Mode",
      "evidence": "BUILD mode for 7 days",
      "challenge_question": "Is staying in BUILD intentional, or avoiding something?"
    }
  ],
  "total_triggers": 2
}
```

---

## Usage Examples

```markdown
# In /start-day command:
1. Call read_state() to get current MIT
2. Compare with yesterday's MIT
3. If same, trigger Challenge Rule #1
4. Call write_mit(new_mit) after user sets MIT

# In /end-day command:
1. Call add_observation() with day's summary
2. Call update_pattern() for any patterns observed
3. Call check_challenge_triggers() to see if challenges needed

# In workflow integration:
1. Call read_state() to get mode and patterns
2. Pass to workflow confidence assessment
3. If workflow blocked, call update_pattern("workflow blockers")
```

---

## Error Handling

| Error | Response |
|-------|----------|
| NOW.md doesn't exist | Return empty state, suggest /setup-life |
| NOW.md parse error | Return partial state + warning |
| Write permission denied | Return error, don't fail silently |
| Invalid mode | Return error with valid options |

## Events Reference

Events emitted for cross-system integration:

| Event | Payload | Use |
|-------|---------|-----|
| `mit_changed` | old, new MIT | Workflow can check if MIT relates to task |
| `mode_changed` | old, new mode, days | Workflow adjusts formality |
| `observation_added` | observation text | Can correlate with workflow completions |
| `pattern_incremented` | pattern, count | Watch for threshold |
| `pattern_promoted` | pattern name | Major trigger, may annotate workflows |
| `challenge_triggered` | rule, evidence | Log for analytics |
