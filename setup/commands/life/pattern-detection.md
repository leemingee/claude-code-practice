---
description: Skill for detecting patterns in text and matching against Active Patterns.
---

# Pattern Detection

Internal skill for analyzing text and detecting pattern matches. Implements the 3x rule and cross-system pattern correlation.

## Purpose

- Analyze user input for pattern matches
- Check text against known Active Patterns
- Detect avoidance phrases (Challenge Rule #3)
- Identify potential new patterns
- Correlate workflow data with life patterns

## Operations

### detect_patterns(text)

Analyze text for pattern matches.

**Input:**
```json
{
  "text": "User input text to analyze",
  "context": "end_day | check_day | brain_dump | workflow"
}
```

**Process:**
1. Load Active Patterns from NOW.md
2. Load Bugs from CLAUDE.md
3. For each known pattern/bug:
   - Check for semantic match in text
   - Check for exact phrase matches
   - Check for related keywords
4. Check for avoidance phrases
5. Identify potential new patterns

**Output:**
```json
{
  "matches": [
    {
      "pattern": "AI tool round-trips",
      "confidence": "high",
      "evidence": "mentioned 'Gemini review loop' and 'multiple rounds'",
      "current_count": 2,
      "action": "increment"
    }
  ],
  "avoidance_phrases": [
    {
      "phrase": "I'll do it later",
      "context": "when discussing the PR",
      "trigger_challenge": true
    }
  ],
  "potential_patterns": [
    {
      "name": "context switching",
      "evidence": "mentioned jumping between 3 projects",
      "recommendation": "monitor"
    }
  ]
}
```

---

### check_avoidance(text)

Specifically check for avoidance phrases (Challenge Rule #3).

**Input:** `text` (string)

**Avoidance Phrases:**
- "I'll do it later"
- "not ready yet"
- "just one more"
- "almost done"
- "after I finish this"
- "need to think about it more"
- "waiting for..."
- "once I..."

**Output:**
```json
{
  "detected": true,
  "phrases": [
    {
      "phrase": "just one more",
      "position": 45,
      "context": "just one more feature before shipping"
    }
  ],
  "trigger_challenge": true,
  "challenge_question": "What are you avoiding?"
}
```

---

### correlate_workflow(workflow_data)

Correlate workflow events with life patterns.

**Input:**
```json
{
  "event": "blocker | jump | completion | start",
  "workflow_id": "LOCAL-20251229-life-logger",
  "details": {
    "checkpoint": "IMPLEMENTATION",
    "blocker_reason": "unclear requirements",
    "days_blocked": 3
  }
}
```

**Process:**
1. Load Active Patterns
2. Check if workflow event matches known patterns:
   - Blocker → Check for "avoidance", "over-engineering", "scope creep"
   - Jump → Check for "planning struggles", "perfectionism"
   - Completion → Check for pattern of "shipping when deadline pressure"
3. Return correlation analysis

**Output:**
```json
{
  "correlations": [
    {
      "pattern": "over-engineering",
      "confidence": "medium",
      "evidence": "blocked 3 days on implementation, similar to past blocks",
      "recommendation": "Check if simplifying scope would help"
    }
  ],
  "new_observation": "Workflow blocked while in BUILD mode for 5 days",
  "add_to_memory_log": true
}
```

---

### apply_3x_rule(patterns)

Check if any patterns should be promoted based on 3x rule.

**Input:** Array of pattern updates or null (will read from NOW.md)

**Process:**
1. Load Active Patterns table
2. For each pattern:
   - If Count >= 3 AND Status == "Watching" → Promote to "Active"
   - If Count >= 5 AND Status == "Active" AND no improvement → Promote to "Confirmed"
3. Return promotion recommendations

**Output:**
```json
{
  "promotions": [
    {
      "pattern": "AI tool round-trips",
      "from_status": "Watching",
      "to_status": "Active",
      "count": 3,
      "message": "Pattern 'AI tool round-trips' has been observed 3 times. Now Active."
    }
  ],
  "confirmations": [],
  "trigger_challenges": true
}
```

---

### extract_quotes(text)

Extract quotable phrases from user input.

**Input:** `text` (string)

**Process:**
1. Look for:
   - Self-aware statements ("I realized...", "I noticed...")
   - Emotional expressions
   - Commitment statements
   - Contradiction statements
   - Insight moments
2. Score by significance
3. Return top quotes

**Output:**
```json
{
  "quotes": [
    {
      "text": "I've never thought about it before. Maybe that is a bug?",
      "type": "self_awareness",
      "significance": "high",
      "save_to_memory_log": true
    }
  ]
}
```

---

## Pattern Matching Keywords

For each known bug, maintain keyword associations:

| Bug | Keywords | Phrases |
|-----|----------|---------|
| AI tool round-trips | gemini, review, rounds, loop, cycles, redo | "back and forth", "multiple reviews" |
| Lack of self-reflection | patterns, habits, aware, notice, realize | "never thought about", "didn't notice" |
| Over-engineering | complex, future, scalable, abstraction | "might need later", "proper architecture" |
| Scope creep | feature, also, and then, while I'm at it | "just add", "might as well" |

---

## Usage Examples

```markdown
# In /check-day:
User says: "I'll finish the PR later, just one more thing to clean up"

detect_patterns() returns:
- avoidance_phrases: ["I'll finish... later", "just one more"]
- trigger_challenge: true
- challenge_question: "What are you avoiding?"

# In /end-day:
User says: "Spent all day going back and forth with Gemini on that PR"

detect_patterns() returns:
- matches: [{ pattern: "AI tool round-trips", confidence: "high" }]
- action: increment pattern count

apply_3x_rule() returns:
- promotions: [{ pattern: "AI tool round-trips", to_status: "Active" }]

# In workflow integration:
Workflow blocked for 3 days on same task

correlate_workflow() returns:
- correlations: [{ pattern: "over-engineering", confidence: "medium" }]
- recommendation: "Check if simplifying scope would help"
```

---

## Error Handling

| Error | Response |
|-------|----------|
| NOW.md missing | Use empty pattern list, return warning |
| CLAUDE.md missing | Use default bug keywords |
| No patterns detected | Return empty matches (valid result) |
| Ambiguous match | Return with confidence: "low" |
