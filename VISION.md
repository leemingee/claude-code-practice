# Intelligent Workflow System: Vision Document

## What We Learned

### From the Claude Code Guide

The existing guide establishes a solid foundation for AI-assisted development:

1. **Building Blocks** - CLAUDE.md files, subagents, MCP servers, skills, and slash commands form the toolkit
2. **Context is King** - Minimal, project-specific context outperforms verbose generic prompts
3. **Two Workflow Types** - Fast (simple tasks) and Full (complex features) with human gates
4. **Feature Directories** - `/features/{ISSUE-ID}/` as persistent external memory
5. **Implementation Overviews** - Bridge knowledge between context-cleared sessions
6. **Parallel Execution** - Git worktrees or separate repos enable concurrent work

### Key Insight: Shallow vs. Deep Cycles

The guide's workflows contain **shallow cycles** - loops within a single phase:
- Review → Fix → Review (within implementation)
- Question → Search → Question (within requirements)

What's missing are **deep cycles** - the ability to jump back to earlier phases:
- Implementation reveals plan was wrong → Jump to Planning
- Planning reveals requirements were misunderstood → Jump to Requirements

### The Human Decision-Making Model

Humans don't follow DAGs. We:
1. Try an approach
2. Evaluate results
3. Diagnose failure level (execution? plan? understanding?)
4. Jump to the appropriate phase
5. Loop until goal achieved

This is a **goal-directed agent with backtracking**, not a linear workflow.

---

## Our Goal

Build an **intelligent, cyclic workflow system** that:

1. **Supports deep backtracking** - Can jump from any phase to any earlier phase when fundamental issues are discovered
2. **Persists state across sessions** - Workflow progress survives `/clear` and context resets
3. **Classifies failures intelligently** - Diagnoses whether a failure is execution-level, plan-level, or requirements-level
4. **Maintains full human oversight** - Every change goes through review, no exceptions
5. **Works across all domains** - iOS, Android, Backend, Infrastructure, and Open-Source contributions
6. **Enables individual-independent work** - Anyone can pick up a task at any checkpoint

---

## Our North Star

> **A self-correcting development workflow that autonomously navigates complexity while keeping humans in control of decisions that matter.**

Characteristics of the North Star state:

| Aspect | Current State | North Star State |
|--------|---------------|------------------|
| **Failure Handling** | Manual diagnosis, restart | Auto-diagnose, jump to correct phase |
| **State Persistence** | Implementation overviews only | Full checkpoint state with history |
| **Cross-Phase Awareness** | Each phase isolated | Phases aware of upstream/downstream |
| **Parallelization** | Manual coordination | Workflow-aware parallel execution |
| **Learning** | Ad-hoc skill creation | Systematic failure → skill pipeline |

---

## Our Value Proposition

### For the Individual Developer (You)

1. **Reduced Cognitive Load**
   - The workflow tracks state, not you
   - Jump decisions are systematic, not intuitive
   - Failures are classified, not mysteries

2. **Consistent Quality Across Domains**
   - Same workflow structure for iOS, Backend, Infra
   - Domain-specific skills plug into universal workflow
   - Review gates ensure nothing slips through

3. **Resilience to Interruption**
   - State persisted in `workflow-state.md`
   - Can resume any task at any checkpoint
   - Context can be `/clear`ed without losing progress

4. **Parallel Work Without Chaos**
   - Each feature directory is self-contained
   - Workflow state prevents conflicts
   - Clear checkpoint model enables handoffs

### For the Codebase

1. **Systematic Knowledge Capture**
   - Every failure that triggers a jump gets documented
   - Patterns emerge → skills get created
   - Codebase documentation grows organically

2. **Audit Trail**
   - `workflow-state.md` records all jumps and reasons
   - Decisions are traceable
   - Post-mortems have data

### For Future Collaborators

1. **Individual-Independent Processes**
   - Workflow is documented, not tribal knowledge
   - New contributors follow the same system
   - Skills encode patterns explicitly

---

## Core Principles

### 1. Always Full Review

No "commit without review" paths. Every change, no matter how small, passes through:
- Code review subagent
- Human review gate

Rationale: The cost of review is small; the cost of unreviewed bugs is large.

### 2. Explicit Checkpoints

Five canonical checkpoints:
```
REQUIREMENTS → PLAN → IMPLEMENTATION → REVIEW → COMPLETE
```

Every workflow action knows which checkpoint it's in and which it's moving toward.

### 3. Failure Classification

When something fails, classify it:

| Failure Level | Symptom | Action |
|---------------|---------|--------|
| **Execution** | Code doesn't work, but plan is sound | Fix and retry within phase |
| **Plan** | Code works but doesn't solve the problem | Jump to PLAN checkpoint |
| **Requirements** | Plan was correct for wrong requirements | Jump to REQUIREMENTS checkpoint |

### 4. State Over Memory

Don't rely on Claude's context memory. Persist everything:
- Current checkpoint
- Current subtask
- Attempt counts
- Blocker history
- Jump history

### 5. Minimal Context, Maximum Precision

Each document serves one purpose:
- `requirements.md` - What we're building
- `implementation-plan.md` - How we're building it
- `to-do.md` - Step-by-step execution plan
- `workflow-state.md` - Where we are in the process
- `{subtask}-implementation-overview.md` - What was built

---

## Success Metrics

How we'll know this is working:

1. **Rework Reduction** - Fewer "start over from scratch" moments
2. **Jump Accuracy** - When we jump phases, we jump to the right one
3. **Resumption Speed** - Time to resume a paused task decreases
4. **Parallel Throughput** - Can sustain 3+ parallel tasks without confusion
5. **Skill Growth** - New skills created from systematic failure analysis

---

## What We're Not Building

To maintain focus:

1. **Not a full automation pipeline** - Human gates remain; we're not removing them
2. **Not a project management tool** - We integrate with task trackers, not replace them
3. **Not a team collaboration platform** - This is optimized for solo/small team use
4. **Not an AI agent framework** - We're using Claude Code's existing primitives

---

## Next Steps

See `IMPLEMENTATION_PLAN.md` for the working document that defines how we build this system.
