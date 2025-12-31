---
description: Skill for passing context between Life and Workflow systems.
---

# Context Bridge

Internal skill for bidirectional state passing between the Life OS and Workflow system. Enables cross-system awareness without tight coupling.

## Purpose

- Load life context into workflow commands
- Pass workflow outcomes back to life system
- Enable cross-system triggers
- Graceful degradation if either system unavailable

## Core Principle

Each system must work independently. The bridge:
- Never requires the other system to exist
- Returns empty/null when system unavailable
- Does not block operations if bridge fails
- Logs missed integrations for later sync

---

## Operations

### load_life_context()

Load life state for use in workflow operations.

**Input:** None (discovers paths automatically)

**Process:**
1. Check for NOW.md in repo root
2. Check for CLAUDE.md in repo root
3. If found, extract relevant state
4. If not found, return empty context

**Output:**
```json
{
  "available": true,
  "context": {
    "mode": "BUILD",
    "mit": "Ship login flow",
    "active_patterns": [
      { "name": "over-engineering", "count": 2, "status": "Watching" }
    ],
    "recent_observations": 3,
    "days_in_mode": 4,
    "bugs": ["AI tool round-trips", "scope creep"],
    "challenge_rules_active": true
  }
}
```

**Graceful Degradation:**
```json
{
  "available": false,
  "context": null,
  "reason": "NOW.md not found",
  "recommendation": "Run /setup-life to initialize"
}
```

---

### load_workflow_context()

Load workflow state for use in life operations.

**Input:** None (discovers paths automatically)

**Process:**
1. Check for `features/*/workflow-state.md` in repo
2. Check for `~/.claude/workflows/registry.md`
3. If found, extract relevant state
4. If not found, return empty context

**Output:**
```json
{
  "available": true,
  "context": {
    "active_workflows": [
      {
        "id": "LOCAL-20251229-life-logger",
        "checkpoint": "IMPLEMENTATION",
        "subtask": "D-7",
        "days_active": 1,
        "blockers": []
      }
    ],
    "completed_today": 2,
    "blocked_count": 0,
    "jump_count_this_week": 0
  }
}
```

**Graceful Degradation:**
```json
{
  "available": false,
  "context": null,
  "reason": "No workflow state found",
  "recommendation": "Use /workflows:start to begin a workflow"
}
```

---

### pass_to_life(event)

Pass workflow event to life system for logging.

**Input:**
```json
{
  "event_type": "workflow_started | workflow_completed | workflow_blocked | workflow_jumped",
  "workflow_id": "LOCAL-20251229-life-logger",
  "details": {
    "checkpoint": "IMPLEMENTATION",
    "outcome": "success",
    "duration_days": 1
  }
}
```

**Process:**
1. Check if life system available (NOW.md exists)
2. If available:
   - Add observation to Memory Log
   - Check for pattern correlations
   - Update metrics if relevant
3. If not available:
   - Log missed event for later sync

**Output:**
```json
{
  "processed": true,
  "actions_taken": [
    "Added observation to Memory Log",
    "Incremented 'shipping wins' metric"
  ],
  "pattern_correlations": []
}
```

---

### pass_to_workflow(event)

Pass life event to workflow system for context.

**Input:**
```json
{
  "event_type": "mit_set | mode_changed | pattern_promoted | challenge_triggered",
  "details": {
    "mit": "Ship login flow",
    "mode": "BUILD",
    "pattern": null
  }
}
```

**Process:**
1. Check if workflow system available
2. If available:
   - Annotate active workflows with life context
   - Adjust confidence based on mode/patterns
   - Flag workflows that may be affected
3. If not available:
   - Continue without workflow integration

**Output:**
```json
{
  "processed": true,
  "workflow_impacts": [
    {
      "workflow_id": "LOCAL-20251229-life-logger",
      "adjustment": "MIT aligns with workflow goal - confidence boost"
    }
  ]
}
```

---

### check_cross_triggers()

Check if any cross-system triggers should fire.

**Input:** None (reads both systems)

**Process:**
1. Load life context
2. Load workflow context
3. Check trigger conditions:

| Trigger | Condition | Action |
|---------|-----------|--------|
| Workflow blocked 3+ days | `workflow.days_blocked >= 3` | Add life observation |
| Same workflow jumped 2+ times | `workflow.jump_count >= 2` | Create "planning struggles" pattern |
| MIT incomplete + workflow stuck | Both conditions true | Suggest correlation |
| Mode stuck + many workflow switches | Both conditions true | Suggest mode change |
| Pattern Active + related workflow blocked | Pattern relates to blocker | Annotate workflow |

**Output:**
```json
{
  "triggers": [
    {
      "type": "workflow_blocked_life_pattern",
      "evidence": "Workflow blocked 3 days while 'over-engineering' pattern at count 2",
      "recommendation": "Check if simplifying approach would unblock",
      "actions": [
        "Add observation to life Memory Log",
        "Annotate workflow with pattern warning"
      ]
    }
  ]
}
```

---

### sync_state()

Synchronize state between systems after missed events.

**Input:** None

**Process:**
1. Check for any missed life→workflow events
2. Check for any missed workflow→life events
3. Process missed events in order
4. Update both systems

**Output:**
```json
{
  "synced": true,
  "missed_events_processed": 2,
  "updates": [
    "Added 2 workflow completions to life metrics",
    "Updated workflow confidence based on current mode"
  ]
}
```

---

## Trigger Definitions

### Workflow → Life Triggers

| Event | Condition | Life Action |
|-------|-----------|-------------|
| `workflow_started` | Always | Log observation |
| `workflow_completed` | Always | Log win, update metrics |
| `workflow_blocked` | 3+ days | Check pattern correlation, add observation |
| `workflow_jumped` | To earlier checkpoint | Check "planning struggles" pattern |

### Life → Workflow Triggers

| Event | Condition | Workflow Action |
|-------|-----------|-----------------|
| `mit_set` | MIT relates to active workflow | Boost confidence |
| `mode_changed` | To HUMAN or RESEARCH | Reduce workflow urgency |
| `pattern_promoted` | Pattern Active | Annotate related workflows |
| `challenge_triggered` | Any challenge | Note in workflow context |

---

## Configuration

Bridge can be configured via environment or CLAUDE.md:

```markdown
## Context Bridge Settings

- **auto_sync:** true | false (default: true)
- **trigger_on_events:** [list of events] (default: all)
- **log_missed_events:** true | false (default: true)
- **graceful_mode:** silent | warn | error (default: warn)
```

---

## Usage Examples

```markdown
# When starting /start-day:
life_ctx = load_life_context()
workflow_ctx = load_workflow_context()

if workflow_ctx.available and workflow_ctx.blocked_count > 0:
  "Note: You have blocked workflows. Does today's MIT address them?"

# When workflow completes:
pass_to_life({
  event_type: "workflow_completed",
  workflow_id: "LOCAL-20251229-life-logger",
  details: { outcome: "success", duration_days: 1 }
})

# Result: Observation added to Memory Log, metrics updated

# When pattern becomes Active:
pass_to_workflow({
  event_type: "pattern_promoted",
  details: { pattern: "over-engineering", count: 3 }
})

# Result: Any workflow with architecture/design tasks flagged for review
```

---

## Error Handling

| Error | Response |
|-------|----------|
| Life system unavailable | Continue without life context, return `available: false` |
| Workflow system unavailable | Continue without workflow context, return `available: false` |
| Both unavailable | Return empty contexts, operations continue independently |
| Event processing failed | Log for retry, don't block main operation |
| Path resolution failed | Use default paths, warn if still not found |
