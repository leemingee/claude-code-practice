# Bootstrap Guide: Setting Up the Workflow System

This guide helps you set up the Intelligent Workflow System on a new machine or share it with others.

---

## Quick Setup

### 1. Global Components (One-Time Setup)

Run these commands to set up the global workflow infrastructure:

```bash
# Create directory structure
mkdir -p ~/.claude/commands/workflows/review
mkdir -p ~/.claude/skills/{workflow-state-management,workflow-registry,implementing-skill}
mkdir -p ~/.claude/workflows/{projects,sessions,analytics/weekly,analytics/monthly}
```

### 2. Copy Global Files

From your source location, copy:

```bash
# Commands (enables /workflows:* commands globally)
cp -r <source>/.claude/commands/workflows/* ~/.claude/commands/workflows/

# Skills (enables autonomous skill invocation)
cp -r <source>/.claude/skills/workflow-state-management ~/.claude/skills/
cp -r <source>/.claude/skills/workflow-registry ~/.claude/skills/
cp -r <source>/.claude/skills/implementing-skill ~/.claude/skills/

# Workflow docs (playbook and readme)
cp <source>/PLAYBOOK.md ~/.claude/workflows/
cp <source>/README.md ~/.claude/workflows/
```

### 3. Initialize Registry

Create `~/.claude/workflows/registry.md`:

```markdown
# Workflow Registry

Master index of all workflows across all projects.

## Active Workflows

| ID | Project | Repo | Checkpoint | Subtask | Started | Updated |
|----|---------|------|------------|---------|---------|---------|

## Completed Workflows

| ID | Project | Repo | Outcome | Started | Completed | Duration |
|----|---------|------|---------|---------|-----------|----------|

## Statistics

- Total Workflows: 0
- Completed: 0
- Abandoned: 0
- Success Rate: N/A
```

---

## Setting Up a Practice Repository

### 1. Create the Repository

```bash
mkdir claude-code-practice
cd claude-code-practice
git init
```

### 2. Create Directory Structure

```bash
mkdir -p .claude/agents/{ios,android,backend,infra}
mkdir -p docs
mkdir -p examples/TEST-001
mkdir -p templates
mkdir -p features
```

### 3. Create Core Files

#### README.md

```markdown
# Claude Code Practice

My practice repository for the Intelligent Workflow System.

## Quick Start

```bash
# Start a workflow
/workflows:start <description or issue>

# Check status
/workflows:status

# Continue work
/workflows:implement <ID>
```

## Documentation

- [System Overview](docs/system-overview.md)
- [Command Reference](docs/command-reference.md)
- [Playbook](docs/playbook.md)

## Structure

- `.claude/` - Configuration and agents
- `docs/` - Documentation
- `examples/` - Working examples
- `features/` - Active workflow documents
- `templates/` - Document templates
```

#### .claude/CLAUDE.md

```markdown
# Intelligent Workflow System

This repository uses a checkpoint-based workflow system with deep backtracking.

## Commands

| Command | Purpose |
|---------|---------|
| `/workflows:start {desc}` | Start new workflow |
| `/workflows:status` | Check current state |
| `/workflows:implement {ID}` | Continue work |
| `/workflows:jump {ID} {TARGET}` | Jump to earlier checkpoint |
| `/workflows:list` | All active workflows |

## Checkpoints

```
REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
     ↑______________|_________|
         (can jump backward)
```

## Confidence-Based Gating

- **High confidence**: Proceed and show result
- **Medium confidence**: Show plan, wait for OK
- **Low confidence**: Full planning with approval
```

### 4. Copy Agent Templates

Copy from claude-code-guide to your practice repo:

```bash
cp <claude-code-guide>/.claude/agents/failure-classifier.md .claude/agents/
cp <claude-code-guide>/.claude/agents/ios/code-reviewer.md .claude/agents/ios/
cp <claude-code-guide>/.claude/agents/android/code-reviewer.md .claude/agents/android/
cp <claude-code-guide>/.claude/agents/backend/code-reviewer.md .claude/agents/backend/
cp <claude-code-guide>/.claude/agents/infra/security-reviewer.md .claude/agents/infra/
```

### 5. Create Document Templates

#### templates/workflow-state.md

```markdown
# Workflow State: {ID}

## Current Position
- **Checkpoint**: REQUIREMENTS
- **Subtask**: -
- **Status**: active

## Checkpoint History

| Checkpoint | Status | Entered | Notes |
|------------|--------|---------|-------|
| REQUIREMENTS | active | {date} | Starting |

## Jump History

| From | To | Reason | Date |
|------|----|--------|------|

## Blockers

### Active
(none)

### Resolved
(none)

## Subtask Progress

| ID | Description | Status | Started | Completed |
|----|-------------|--------|---------|-----------|
```

#### templates/requirements.md

```markdown
# Requirements: {ID}

## Summary
{One-line description}

## User Story
As a {role}, I want {feature} so that {benefit}.

## Acceptance Criteria
- [ ] {criterion 1}
- [ ] {criterion 2}
- [ ] {criterion 3}

## Technical Context
- Relevant files: {list}
- Dependencies: {list}
- Constraints: {list}

## Out of Scope
- {item 1}
- {item 2}
```

---

## Verification

After setup, verify everything works:

```bash
# From any directory
cd ~/some-other-project

# Should show available workflows
/workflows:list

# Should work
/workflows:start Test the setup
```

---

## Sharing with Others

To share this system:

1. **Give them the global files**: Commands, skills, workflow docs
2. **Give them a practice repo template**: Or let them fork yours
3. **Point them to PLAYBOOK.md**: Comprehensive user guide

What stays personal:
- `~/.claude/workflows/registry.md` (their workflow history)
- `~/.claude/workflows/sessions/` (their session logs)
- `~/.claude/workflows/projects/` (their project stats)

---

## Troubleshooting

### Commands not found

Check that files exist at `~/.claude/commands/workflows/`:
```bash
ls ~/.claude/commands/workflows/
```

### Workflows not persisting

Check that `features/{ID}/workflow-state.md` exists in the repo.

### Cross-repo not working

Commands should be at `~/.claude/commands/`, not in the repo's `.claude/commands/`.

---

*Last updated: 2024-12-29*
