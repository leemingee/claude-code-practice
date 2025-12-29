# /workflows:start

Initialize a new task with workflow state tracking. Supports both formal issue IDs and natural language descriptions.

## Arguments

$ARGUMENTS can be any of:

1. **GitHub Issue:** `#123` or `owner/repo#123`
2. **Formal ID:** `PROJ-123`, `BUG-456`, `FEAT-789`
3. **Natural Description:** Free-form text describing the task
4. **Mixed:** `#123 with additional context` or just a description

Examples:
- `/workflows:start #42` - GitHub issue
- `/workflows:start PROJ-123` - Formal ID from task tracker
- `/workflows:start Fix the login token refresh bug in AuthManager.swift`
- `/workflows:start Add dark mode support, see SettingsScreen for reference`

## Instructions

### 1. Parse Arguments and Determine ID

#### 1.1 Detect Input Type

Analyze $ARGUMENTS to determine the input type:

| Pattern | Type | Generated ID |
|---------|------|--------------|
| `#\d+` or `owner/repo#\d+` | GitHub Issue | `GH-{number}` |
| `[A-Z]+-\d+` (e.g., PROJ-123) | Formal ID | Use as-is |
| Natural language | Description | `LOCAL-{YYYYMMDD}-{seq}` |

#### 1.2 Generate ID for Natural Descriptions

If natural language:
1. Extract key terms (e.g., "fix login token" → "login-token")
2. Generate: `LOCAL-{YYYYMMDD}-{short-desc}`
3. Example: `LOCAL-20241228-login-token`

Check `features/` for existing LOCAL IDs today to avoid collision.

#### 1.3 Extract Context from Description

From natural language, identify:
- **Files mentioned:** Any paths like `AuthManager.swift`, `src/auth/`
- **References:** "see X", "like Y", "similar to Z"
- **Action type:** fix, add, refactor, update, implement
- **Scope hints:** component names, feature areas

Store these as `input_context` for later use.

### 2. Fetch External Issue (if applicable)

#### 2.1 GitHub Issues

If ID starts with `GH-` or input was `#number`:

```
Check for GitHub MCP tools:
- gh_get_issue
- github_get_issue

If available:
- Fetch issue title, body, comments, labels
- Extract requirements from issue body
- Note any linked PRs or issues

If not available:
- Ask user to paste issue content
- Or provide issue URL for WebFetch
```

#### 2.2 Other Task Trackers

If formal ID matches known patterns:
- YouTrack: `get_issue` MCP
- Jira: `jira_get_issue` MCP

### 3. Create Feature Directory

Create directory: `features/{ISSUE-ID}/`

If directory already exists:
- Read existing workflow-state.md
- Inform user of current state
- Options:
  1. Resume existing workflow
  2. Reset and start fresh
  3. Create parallel track (append `-v2`)

### 4. Initialize Workflow State

Create `features/{ISSUE-ID}/workflow-state.md`:

```markdown
# Workflow State: {ISSUE-ID}

## Source
- **Type:** GitHub | TaskTracker | Natural Description
- **Original Input:** {what user provided}
- **Created:** {timestamp}

## Current Position
- **Checkpoint:** CHECKPOINT_REQUIREMENTS
- **Subtask:** null
- **Status:** in_progress

## Checkpoint History
| Checkpoint | Entries | Exits | Last Entry |
|------------|---------|-------|------------|
| REQUIREMENTS | 1 | 0 | {timestamp} |
| PLAN | 0 | 0 | - |
| IMPLEMENTATION | 0 | 0 | - |
| REVIEW | 0 | 0 | - |
| COMPLETE | 0 | 0 | - |

## Input Context
- **Files Referenced:** {list from input_context}
- **References:** {list from input_context}
- **Action Type:** {from input_context}

## Jump History
| From | To | Reason | Timestamp |
|------|-----|--------|-----------|

## Active Blockers
(none)

## Resolved Blockers
(none)

## Subtask Progress
| Subtask | Status | Attempts | Notes |
|---------|--------|----------|-------|
```

### 5. Gather Requirements

#### 5.1 Read Referenced Files

If `input_context` contains file references:
- Read each referenced file
- Understand current implementation
- Note patterns and conventions

#### 5.2 Build Requirements Document

Create `features/{ISSUE-ID}/requirements.md`:

For **GitHub/Tracker issues:**
- Extract requirements from issue body
- Include acceptance criteria from issue
- Note any discussion from comments

For **Natural descriptions:**
- Parse the description for requirements
- Identify implicit requirements from file analysis
- Ask clarifying questions if needed

Structure:
```markdown
# Requirements: {ISSUE-ID}

## Source
{Link to GitHub issue or "Natural description"}

## Summary
{One paragraph summary}

## Context
- Files analyzed: {list}
- Existing patterns observed: {list}

## Functional Requirements
- FR-1: {requirement}
...

## Non-Functional Requirements
- NFR-1: {requirement}
...

## Acceptance Criteria
- [ ] AC-1: {criterion}
...

## Open Questions
{Any ambiguities}

## Assumptions
{Assumptions made}
```

### 6. Requirements Clarification

#### 6.1 Analyze for Gaps

Review requirements for:
- Ambiguous language
- Missing edge cases
- Unclear scope boundaries
- Technical unknowns

#### 6.2 Search Before Asking

For each gap:
1. Search project docs and code
2. Check similar implementations
3. Only ask user if truly unknown

#### 6.3 Clarify with User

If questions remain:
- Present concise questions
- Offer reasonable defaults where possible
- Update requirements with answers

### 7. Assess Complexity and Confidence

Before transitioning, assess:

| Factor | Low Complexity | High Complexity |
|--------|----------------|-----------------|
| Files affected | 1-3 | 4+ |
| New patterns | None | Yes |
| Cross-cutting | No | Yes |
| Uncertainty | None | Some |

Record assessment in workflow-state.md:
```markdown
## Complexity Assessment
- **Level:** Low | Medium | High
- **Confidence:** High | Medium | Low
- **Reasoning:** {brief explanation}
```

### 8. Transition Based on Complexity

#### Low Complexity + High Confidence
- Transition directly to CHECKPOINT_IMPLEMENTATION
- Skip formal planning (plan inline)
- Inform user: "This is straightforward. I'll implement and show you the result."

#### Medium Complexity or Medium Confidence
- Transition to CHECKPOINT_PLAN
- Create brief implementation plan
- Quick confirmation: "Here's my approach. Good to proceed?"

#### High Complexity or Low Confidence
- Transition to CHECKPOINT_PLAN
- Full implementation plan and to-do
- Require explicit approval before implementation

### 9. Report and Continue

Output based on transition:

**Direct to Implementation:**
```
Workflow: {ISSUE-ID}
Complexity: Low | Confidence: High

I understand you want to: {summary}

I'll implement this now and show you the result for review.
Files I'll modify: {list}

Proceeding...
```

**To Planning:**
```
Workflow: {ISSUE-ID}
Complexity: {level} | Confidence: {level}

Requirements captured. Next step: Create implementation plan.

Continue with /workflows:implement {ISSUE-ID}
Or I can continue automatically - just say "proceed"
```

## Registry Integration

### 10. Register Workflow Globally

After creating local workflow state, register globally:

#### 10.1 Update Registry

Add entry to `~/.claude/workflows/registry.md` Active Workflows table:

```markdown
| {ISSUE-ID} | {project-slug} | {repo-path} | CHECKPOINT_REQUIREMENTS | - | {today} | {today} |
```

Where:
- `project-slug`: Derived from repo directory name (lowercase, hyphenated)
- `repo-path`: Full path to current working directory

#### 10.2 Update Project File

Create or update `~/.claude/workflows/projects/{project-slug}.md`:

If new project:
- Create file from template (see workflow-registry skill)
- Set First Tracked date

If existing project:
- Add workflow to Workflow History table
- Update statistics

#### 10.3 Update Session Log

Find or create today's session file: `~/.claude/workflows/sessions/{date}-{N}.md`

Add entry to "Workflows Worked On" section:
```markdown
### {ISSUE-ID} ({project-slug})
- **Status:** Started
- **Type:** {inferred from description: Feature/Bug/Refactor/etc}
- **Summary:** {brief summary from requirements}
```

#### 10.4 Detect Cross-Repo References

If input_context references files in a different repo:
- Note the cross-repo dependency in workflow-state.md
- Add reference to session log

Example:
```
Input: "Add push notifications to Android, see iOS implementation in ~/src/ios-app/"
Action: Note that this Android workflow references ios-app codebase
```

## Error Handling

- If file references don't exist: Ask user to clarify paths
- If GitHub issue not found: Ask for issue content or URL
- If description too vague: Ask for more context
- If user cancels: Save state for later resume
- If registry doesn't exist: Create it (first-time setup)
- If project file doesn't exist: Create it
