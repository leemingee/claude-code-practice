# Intelligent Workflow System Playbook

A practical guide to using the AI-assisted workflow system for software development.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Core Concepts](#core-concepts)
3. [Commands Reference](#commands-reference)
4. [Common Workflows](#common-workflows)
5. [Working with Multiple Projects](#working-with-multiple-projects)
6. [Confidence-Based Interaction](#confidence-based-interaction)
7. [Handling Failures](#handling-failures)
8. [Session Management](#session-management)
9. [Retrospective Analysis](#retrospective-analysis)
10. [Best Practices](#best-practices)
11. [Troubleshooting](#troubleshooting)

---

## Quick Start

### Starting Your First Workflow

You can start a workflow in three ways:

```bash
# Option 1: Natural language (recommended)
/workflows:start Fix the login token refresh bug in AuthManager.swift

# Option 2: GitHub issue
/workflows:start #42

# Option 3: Formal ID from your task tracker
/workflows:start PROJ-123
```

### The Simplest Path

For most tasks, just describe what you need:

```
You: "I need to add a logout button to the settings screen.
      See SettingsViewController.swift for the existing layout."

Claude: [Reads file, assesses complexity]
        "I understand. This is straightforward - I'll add a logout button
        following the existing button patterns. I'll show you the result
        for review. Proceeding..."

        [Implements, then shows result]

        "Done. Here's what I changed:
        - Added logoutButton to SettingsViewController
        - Connected to AuthManager.logout()
        - Added confirmation alert

        Please review. Approve to commit?"
```

---

## Core Concepts

### Checkpoints

Every workflow moves through 5 checkpoints:

```
REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
     ↑______________|_______|
         (can jump backward)
```

| Checkpoint | What Happens |
|------------|--------------|
| **REQUIREMENTS** | Understand what to build |
| **PLAN** | Design how to build it |
| **IMPLEMENTATION** | Build it (subtask by subtask) |
| **REVIEW** | Final validation |
| **COMPLETE** | Done, archived for reference |

### State Persistence

Your progress is saved in two places:

1. **Local** (in the repo): `features/{ID}/workflow-state.md`
2. **Global** (your home): `~/.claude/workflows/registry.md`

This means:
- You can `/clear` context without losing progress
- You can switch between projects freely
- You can resume any workflow from any conversation

### Confidence-Based Gating

The system adapts based on task complexity:

| Confidence | What You Experience |
|------------|---------------------|
| **High** | Claude proceeds, shows result, asks for approval |
| **Medium** | Claude shows brief plan, waits for "OK", then proceeds |
| **Low** | Full formal planning with your approval at each step |

---

## Commands Reference

### Starting Workflows

| Command | When to Use |
|---------|-------------|
| `/workflows:start {description}` | Start with natural language |
| `/workflows:start #{number}` | Start from GitHub issue |
| `/workflows:start {PROJ-123}` | Start from task tracker ID |
| `/workflows:fast {description}` | Quick workflow for simple tasks |

**Examples:**
```bash
/workflows:start Fix the memory leak in ImageCache.swift
/workflows:start #156
/workflows:start Add unit tests for UserService, see existing tests in tests/
/workflows:fast Fix typo in README
```

### Checking Status

| Command | What It Shows |
|---------|---------------|
| `/workflows:status` | Current workflow in this repo |
| `/workflows:status {ID}` | Specific workflow status |
| `/workflows:list` | All active workflows across all projects |
| `/workflows:list --all` | Include completed and abandoned |

**Examples:**
```bash
/workflows:status
/workflows:status GH-123
/workflows:list
/workflows:list --project ios-app
```

### Continuing Work

| Command | When to Use |
|---------|-------------|
| `/workflows:implement {ID}` | Continue a workflow |
| `/workflows:implement {ID} {subtask}` | Jump to specific subtask |
| `proceed` / `continue` / `go ahead` | After Claude shows a plan |

**Examples:**
```bash
/workflows:implement LOCAL-auth-fix
/workflows:implement GH-123 D-2
proceed
```

### Handling Problems

| Command | When to Use |
|---------|-------------|
| `/workflows:jump {ID} PLAN "reason"` | Plan was wrong, need to revise |
| `/workflows:jump {ID} REQUIREMENTS "reason"` | Requirements were misunderstood |

**Examples:**
```bash
/workflows:jump GH-123 PLAN "Architecture doesn't support real-time updates"
/workflows:jump LOCAL-auth REQUIREMENTS "Need OAuth, not basic auth"
```

### Project & Analysis

| Command | What It Does |
|---------|--------------|
| `/workflows:projects` | List all tracked projects |
| `/workflows:projects {name}` | Details for specific project |
| `/workflows:retrospective` | This week's insights |
| `/workflows:retrospective --month` | This month's insights |

---

## Common Workflows

### Workflow 1: Simple Bug Fix

```
You: "Fix the crash when user taps logout twice quickly.
      See AuthManager.swift line 142."

Claude: [Reads file, identifies issue]
        "Found it - the logout method doesn't guard against
        re-entry. I'll add a flag to prevent double-tap.

        Confidence: High. Proceeding..."

        [Makes fix, runs tests]

        "Fixed. Added `isLoggingOut` guard. Tests pass.
        Review and approve?"

You: "Approved"

Claude: [Commits, updates registry]
        "Committed: abc123. Workflow complete."
```

### Workflow 2: New Feature (Medium Complexity)

```
You: "Add dark mode support to the app. See ThemeManager
      for existing theme infrastructure."

Claude: [Reads ThemeManager, analyzes scope]
        "This touches multiple files. Here's my approach:

        1. Extend ThemeManager with dark color palette
        2. Update 12 view controllers to use theme colors
        3. Add toggle in Settings
        4. Persist preference in UserDefaults

        Confidence: Medium. OK to proceed?"

You: "Yes, but also add system automatic option"

Claude: "Got it - three options: Light, Dark, System.
        Proceeding..."

        [Implements in subtasks, shows progress]
```

### Workflow 3: Complex Feature (Low Confidence)

```
You: "Implement end-to-end encryption for messages.
      This is security-critical."

Claude: "This is a complex, security-critical feature.
        I'll need to do full formal planning.

        Let me analyze the codebase and create a
        detailed implementation plan for your review..."

        [Creates requirements.md, implementation-plan.md, to-do.md]

        "Plan ready for review:
        - features/LOCAL-e2e-encryption/implementation-plan.md

        Key decisions I need your input on:
        1. Key exchange protocol (Signal vs custom)?
        2. Where to store keys (Keychain vs secure enclave)?

        Please review and let me know."
```

### Workflow 4: Cross-Project Task

```
You: "Add push notifications to Android.
      Mirror the iOS implementation in ~/src/ios-app/NotificationManager.swift"

Claude: [Reads iOS implementation, analyzes Android codebase]
        "I see the iOS pattern. For Android, I'll:

        1. Create NotificationManager in com.app.notifications
        2. Implement FCM integration (vs APNs on iOS)
        3. Match the same notification categories
        4. Use existing DeepLinkHandler for routing

        Confidence: High (clear pattern to follow).
        Proceeding..."
```

---

## Working with Multiple Projects

### Switching Between Projects

```
# See all active work
/workflows:list

# Output:
# Active workflows:
#   - GH-123 (ios-app): IMPLEMENTATION D-2
#   - LOCAL-auth (backend): PLAN
#   - GH-456 (terraform): REQUIREMENTS
#
# Which would you like to continue?

# Option 1: Say which one
"Continue the backend auth fix"

# Option 2: Use the command
/workflows:implement LOCAL-auth
```

### Cross-Repo References

You can reference files in other repos:

```
"Implement the same caching strategy we use in
~/src/backend/cache/RedisCache.py for the new service"
```

Claude will:
1. Read the referenced file
2. Apply the pattern to current repo
3. Note the cross-repo dependency in the workflow state

### Project-Level View

```
/workflows:projects

# Output:
# ┌──────────────────┬──────────────┬────────────┬─────────┐
# │ Project          │ Type         │ Workflows  │ Success │
# ├──────────────────┼──────────────┼────────────┼─────────┤
# │ ios-app          │ iOS          │ 12         │ 92%     │
# │ backend          │ Backend      │ 8          │ 88%     │
# │ terraform        │ Infra        │ 5          │ 100%    │
# └──────────────────┴──────────────┴────────────┴─────────┘
```

---

## Confidence-Based Interaction

### How Confidence Is Determined

| Factor | High Confidence | Low Confidence |
|--------|-----------------|----------------|
| Pattern | Seen exact pattern before | New pattern |
| Scope | 1-3 files | Many files |
| Clarity | Requirements crystal clear | Ambiguities exist |
| Risk | Low impact if wrong | High impact |
| Domain | Familiar (e.g., CRUD) | Unfamiliar (e.g., crypto) |

### Overriding Confidence

You can request more or less formality:

```
# Request more formality
"Plan this carefully before implementing"
"I want to review the approach first"
"Let's be thorough on this one"

# Request less formality
"Just do it, I'll review the result"
"This is simple, proceed"
"Skip the planning, implement directly"
```

### When Claude Asks Questions

If Claude isn't confident, it will ask:

```
Claude: "I have a few questions before proceeding:

        1. Should the cache expire after 1 hour or 24 hours?
        2. Should we invalidate on logout or keep cached?

        Or I can proceed with sensible defaults (1h, invalidate)."

You: "Use your defaults"
# or
You: "24 hours, keep on logout"
```

---

## Handling Failures

### When Things Go Wrong

If implementation fails, Claude diagnoses the level:

| Level | Symptom | Action |
|-------|---------|--------|
| **Execution** | Code bug, typo, missing import | Fix and retry |
| **Plan** | Approach doesn't work | Jump to PLAN |
| **Requirements** | Misunderstood what to build | Jump to REQUIREMENTS |

### Automatic Jump

```
Claude: "I've hit an issue. The API doesn't support
        batch operations as I assumed.

        Diagnosis: PLAN_FAILURE
        - Plan assumed batch API exists
        - Need to revise for individual calls

        Jumping to PLAN checkpoint to revise approach..."
```

### Manual Jump

If you spot a problem:

```
You: "Wait - this isn't right. We need OAuth, not API keys."

/workflows:jump LOCAL-auth REQUIREMENTS "Need OAuth flow, not API key auth"

Claude: "Jumping to REQUIREMENTS. I'll re-gather requirements
        with OAuth as the authentication method..."
```

---

## Session Management

### Session Logs

Every work session is logged at:
`~/.claude/workflows/sessions/YYYY-MM-DD-N.md`

Contains:
- Workflows touched
- Accomplishments
- Key decisions made
- Insights and learnings

### Starting a New Session

Sessions are created automatically when you start working.

### Reviewing Past Sessions

```
# Read a session log directly
cat ~/.claude/workflows/sessions/2024-12-28-1.md

# Or ask Claude
"What did we accomplish last session?"
```

---

## Retrospective Analysis

### Weekly Review

```
/workflows:retrospective

# Output:
# === Workflow Retrospective: This Week ===
#
# ## Summary
# You worked on 5 workflows across 3 projects.
# Completed 4 (80% success rate).
#
# ## Highlights
# - Completed push notifications (ios-app)
# - Fixed auth token refresh (backend)
#
# ## Patterns Observed
# - Most time spent in IMPLEMENTATION phase
# - Zero jumps to REQUIREMENTS (good requirement clarity)
#
# ## Recommendations
# - Consider creating a skill for notification patterns
# - Backend tests taking long; consider parallelization
```

### Monthly Review

```
/workflows:retrospective --month

# Includes:
# - Total workflows and outcomes
# - Project distribution
# - Completion trends over weeks
# - Most active projects
# - Skill/pattern suggestions
```

### Per-Project Analysis

```
/workflows:projects ios-app

# Shows:
# - All workflows for that project
# - Success rate
# - Common patterns
# - Recent activity
```

---

## Best Practices

### 1. Be Specific About Files

```
# Good
"Fix the bug in src/auth/TokenManager.swift, line 142"

# Less good
"Fix the auth bug"
```

### 2. Reference Existing Patterns

```
# Good
"Add a new endpoint like the existing /users endpoint in UserController"

# Less good
"Add an endpoint for orders"
```

### 3. Let Claude Assess Confidence

Don't micromanage. If Claude says "High confidence, proceeding...", let it proceed. Review the result.

### 4. Use Jumps Appropriately

- Don't jump for small fixes (let Claude retry)
- Do jump when fundamental approach is wrong
- Always provide a reason for the jump

### 5. Review, Don't Re-implement

When Claude shows results:
- Review the logic
- Check edge cases
- Request changes if needed
- Don't rewrite yourself unless necessary

### 6. Keep Session Logs Useful

Add notes to session logs:
```
# Open the session file and add:
## Personal Notes
- Need to revisit the caching strategy next week
- Consider refactoring AuthManager
```

---

## Troubleshooting

### "No workflow found"

```
Error: No workflow found for GH-123

Solutions:
1. Check if workflow was started: /workflows:list --all
2. Start it: /workflows:start GH-123
3. Check you're in the right directory
```

### "Workflow already complete"

```
Error: Workflow GH-123 is already complete

Solutions:
1. Start a new workflow for follow-up work
2. Check completed workflows: /workflows:list --completed
```

### Stuck in a Loop

If Claude keeps trying the same thing:

```
You: "Stop. Let's step back."
/workflows:jump {ID} PLAN "Current approach isn't working"
```

### Lost Context After /clear

The workflow state persists. Just resume:

```
/workflows:status {ID}
# or
/workflows:implement {ID}
```

### Cross-Project File Not Found

```
Error: Cannot read ~/src/other-project/File.swift

Solutions:
1. Check the path is correct
2. Make sure you have read permissions
3. Provide the file content directly
```

### Registry Corrupted

If `~/.claude/workflows/registry.md` has issues:

```
1. Check the file manually
2. Fix table formatting if needed
3. Or delete and let system recreate
```

---

## File Locations Reference

### Global (always accessible from any repo)

```
~/.claude/
├── commands/workflows/      # Workflow commands (global)
│   ├── start.md
│   ├── status.md
│   ├── implement.md
│   ├── jump.md
│   ├── fast.md
│   ├── list.md
│   ├── projects.md
│   ├── retrospective.md
│   └── review/
│       ├── solution.md
│       └── todo.md
├── skills/                  # Global skills
│   ├── workflow-state-management/
│   ├── workflow-registry/
│   └── implementing-skill/
└── workflows/               # Workflow data
    ├── PLAYBOOK.md          # This file
    ├── README.md            # Quick reference
    ├── registry.md          # Master workflow index
    ├── projects/            # Per-project profiles
    ├── sessions/            # Session logs
    └── analytics/           # Generated insights
```

### Per-Repo (context with code)

```
{repo}/
├── .claude/
│   ├── CLAUDE.md        # Repo-specific config
│   └── agents/          # Code reviewers (repo-specific)
└── features/
    └── {ID}/            # Workflow documents
        ├── workflow-state.md
        ├── requirements.md
        ├── implementation-plan.md
        ├── to-do.md
        └── *-implementation-overview.md
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                    WORKFLOW QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────────┤
│ START                                                           │
│   /workflows:start {description}     Natural language           │
│   /workflows:start #42               GitHub issue               │
│   /workflows:fast {description}      Simple tasks               │
├─────────────────────────────────────────────────────────────────┤
│ STATUS                                                          │
│   /workflows:status                  Current workflow           │
│   /workflows:list                    All active workflows       │
│   /workflows:projects                All projects               │
├─────────────────────────────────────────────────────────────────┤
│ CONTINUE                                                        │
│   /workflows:implement {ID}          Resume workflow            │
│   proceed / continue / go ahead      After plan shown           │
├─────────────────────────────────────────────────────────────────┤
│ FIX PROBLEMS                                                    │
│   /workflows:jump {ID} PLAN "why"    Wrong approach             │
│   /workflows:jump {ID} REQ "why"     Wrong requirements         │
├─────────────────────────────────────────────────────────────────┤
│ ANALYZE                                                         │
│   /workflows:retrospective           Weekly insights            │
│   /workflows:retrospective --month   Monthly insights           │
├─────────────────────────────────────────────────────────────────┤
│ CHECKPOINTS                                                     │
│   REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE      │
│        ↑_______________|______|  (can jump backward)            │
└─────────────────────────────────────────────────────────────────┘
```

---

*Last updated: 2024-12-28*
