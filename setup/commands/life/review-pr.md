---
description: Comprehensive PR review workflow for tech leads. Ensures consistent, thorough code reviews.
---

# Review PR

Structured PR review workflow that ensures consistent quality and reduces review rounds.

## Usage

```
/review-pr <PR-number-or-url>
/review-pr 123
/review-pr https://github.com/owner/repo/pull/123
```

## Context Loading

LOAD:
- CLAUDE.md: Key metrics (PR review rounds target)
- NOW.md: Current mode only

DO NOT LOAD:
- Memory Log
- Journals
- Full context

## Flow

### 1. Fetch PR Context

```bash
# Get PR details
gh pr view <number> --json title,body,author,baseRefName,headRefName,additions,deletions,changedFiles,files,commits,reviews,comments

# Get diff
gh pr diff <number>
```

Extract:
- PR title and description
- Author
- Files changed (count and list)
- Lines added/deleted
- Existing reviews and comments
- Commit history

### 2. Display PR Summary

```
PR #123: [Title]
Author: @username
Branch: feature/x → main
Changes: +245 -89 across 8 files

Files:
  M src/auth/login.ts (+120 -30)
  M src/auth/session.ts (+45 -20)
  A src/auth/types.ts (+50)
  M tests/auth.test.ts (+30 -39)
  ...

Commits: 5
Previous Reviews: 1 (changes requested)
```

### 3. Review Checklist

Run through each category systematically:

---

#### A. Purpose & Scope

| Check | Question |
|-------|----------|
| [ ] | Does the PR description explain WHY, not just WHAT? |
| [ ] | Is the scope appropriate? (Not too big, not too small) |
| [ ] | Does it match the linked issue/ticket? |
| [ ] | Are there any scope creep red flags? |

**Scope Guidelines:**
- Ideal: 200-400 lines changed
- Warning: >500 lines (suggest split)
- Red flag: >1000 lines (require split)

---

#### B. Code Quality

| Check | Question |
|-------|----------|
| [ ] | Is the code readable without comments explaining it? |
| [ ] | Are functions/methods appropriately sized? (<30 lines ideal) |
| [ ] | Is there unnecessary complexity? |
| [ ] | Are there any obvious bugs? |
| [ ] | Is error handling appropriate? |

**Look for:**
- God functions (doing too much)
- Deep nesting (>3 levels)
- Magic numbers/strings
- Copy-paste code
- Premature abstraction

---

#### C. Architecture & Design

| Check | Question |
|-------|----------|
| [ ] | Does it follow existing patterns in the codebase? |
| [ ] | Are new patterns justified and documented? |
| [ ] | Is the separation of concerns clear? |
| [ ] | Are dependencies appropriate? |
| [ ] | Will this be maintainable in 6 months? |

**Watch for:**
- Breaking existing patterns without discussion
- Over-engineering for hypothetical futures
- Tight coupling between modules
- Circular dependencies

---

#### D. Testing

| Check | Question |
|-------|----------|
| [ ] | Are there tests for new functionality? |
| [ ] | Do tests cover edge cases? |
| [ ] | Are tests readable and maintainable? |
| [ ] | Is test coverage appropriate? (Not 100%, but critical paths) |
| [ ] | Do existing tests still pass? |

**Test quality signals:**
- Tests describe behavior, not implementation
- One assertion focus per test
- Clear arrange-act-assert structure
- No flaky tests introduced

---

#### E. Security

| Check | Question |
|-------|----------|
| [ ] | Any hardcoded secrets or credentials? |
| [ ] | Is user input validated/sanitized? |
| [ ] | Are there SQL injection risks? |
| [ ] | Are there XSS vulnerabilities? |
| [ ] | Is authentication/authorization handled correctly? |
| [ ] | Are sensitive data logged? |

**Automatic flags:**
- API keys, tokens, passwords in code
- `eval()`, `innerHTML`, raw SQL
- Missing auth checks on endpoints
- Logging of PII

---

#### F. Performance

| Check | Question |
|-------|----------|
| [ ] | Any N+1 query patterns? |
| [ ] | Are there unnecessary re-renders (frontend)? |
| [ ] | Is data fetching efficient? |
| [ ] | Any obvious memory leaks? |
| [ ] | Are expensive operations cached appropriately? |

**Look for:**
- Loops with database calls inside
- Missing pagination
- Unbounded data fetching
- Missing memoization where needed

---

#### G. Documentation

| Check | Question |
|-------|----------|
| [ ] | Are public APIs documented? |
| [ ] | Are complex algorithms explained? |
| [ ] | Is the README updated if needed? |
| [ ] | Are breaking changes documented? |

**Note:** Not every line needs a comment. Self-documenting code > comments.

---

### 4. Generate Review Summary

After completing checklist:

```markdown
## PR Review: #123

### Verdict: [APPROVE | REQUEST_CHANGES | COMMENT]

### Summary
[2-3 sentence overall assessment]

### What's Good
- [Positive point 1]
- [Positive point 2]

### Required Changes (if any)
1. **[Category]:** [Specific change needed]
   - File: `path/to/file.ts:42`
   - Issue: [What's wrong]
   - Suggestion: [How to fix]

2. **[Category]:** [Specific change needed]
   ...

### Suggestions (non-blocking)
- [Nice-to-have improvement 1]
- [Nice-to-have improvement 2]

### Questions
- [Any clarifying questions for author]
```

### 5. Review Efficiency Check

Before submitting, ask yourself:

| Question | Why It Matters |
|----------|----------------|
| Have I been specific enough? | Vague feedback = more rounds |
| Have I explained WHY, not just WHAT? | Author learns, won't repeat |
| Are required vs suggested changes clear? | Avoids unnecessary back-and-forth |
| Did I acknowledge what's good? | Maintains morale, encourages good patterns |
| Is this actionable in one round? | Reduces your PR review rounds metric |

### 6. Submit Review

```bash
# Submit review via gh
gh pr review <number> --approve --body "..."
gh pr review <number> --request-changes --body "..."
gh pr review <number> --comment --body "..."
```

### 7. Track Metrics

Log review for your metrics:

| Metric | Value |
|--------|-------|
| PR reviewed | #123 |
| Time spent | ~X minutes |
| Verdict | APPROVE / CHANGES / COMMENT |
| Expected rounds | 1 / 2 / 3+ |

If this is a re-review (round 2+):
- Note what was missed in round 1
- Consider if clearer feedback could have avoided this round

---

## Domain-Specific Checklists

### Infrastructure (CDK / API)

| Check | Question |
|-------|----------|
| [ ] | Are IAM permissions least-privilege? |
| [ ] | Are secrets in Secrets Manager / Parameter Store (not hardcoded)? |
| [ ] | Is the resource naming consistent with conventions? |
| [ ] | Are there appropriate tags for cost tracking? |
| [ ] | Is the construct properly scoped (not too broad)? |
| [ ] | Are there removal policies set appropriately? (RETAIN for prod data) |
| [ ] | Is there a rollback strategy? |
| [ ] | Are Lambda timeouts and memory configured appropriately? |
| [ ] | Are API Gateway throttling/quotas set? |
| [ ] | Is CloudWatch logging enabled with appropriate retention? |
| [ ] | Are VPC/security groups configured correctly? |
| [ ] | Is the CDK diff reviewed for unintended changes? |

**CDK Red Flags:**
- `RemovalPolicy.DESTROY` on production databases
- Overly permissive IAM (`*` resources/actions)
- Missing environment separation (dev/staging/prod)
- Hardcoded account IDs or regions
- No stack outputs for cross-stack references

**Before Approving:**
```bash
# Always run CDK diff
cdk diff

# Check for security issues
cdk synth | grep -i "iam\|policy\|secret"
```

---

### iOS (SwiftUI)

| Check | Question |
|-------|----------|
| [ ] | Does the view follow single responsibility? |
| [ ] | Is state management appropriate? (@State vs @Binding vs @ObservedObject vs @StateObject) |
| [ ] | Are views extracted when they get too large? (>100 lines) |
| [ ] | Is the preview provider useful for different states? |
| [ ] | Are optionals handled safely? (no force unwraps in production code) |
| [ ] | Is the navigation pattern consistent? |
| [ ] | Are images using proper assets (not hardcoded strings)? |
| [ ] | Is accessibility supported? (labels, traits, dynamic type) |
| [ ] | Are animations performant? (no unnecessary redraws) |
| [ ] | Is async/await used correctly? (@MainActor where needed) |
| [ ] | Are Combine publishers properly cancelled? |
| [ ] | Is the MVVM separation clean? (no business logic in views) |

**SwiftUI Red Flags:**
- Using @State for shared data (should be @ObservedObject or environment)
- Force unwraps (!) outside of IBOutlets
- Business logic inside View body
- Missing @MainActor on UI-updating async code
- Nested NavigationStacks
- Heavy computation in view body (should be computed property or async)

**View Structure Check:**
```swift
// Good: View does one thing
struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    var body: some View { ... }
}

// Bad: View does everything
struct ProfileView: View {
    @State var user: User?
    @State var isLoading: Bool
    @State var error: Error?
    func fetchUser() { ... }  // Business logic in view
    func saveUser() { ... }   // More business logic
}
```

**Performance Check:**
- Look for `body` recomputation triggers
- Check `@Published` properties (too many = too many updates)
- Verify `Equatable` conformance on complex types used with `.onChange`

---

## Review Archetypes

Quick patterns for common PR types:

### Bug Fix PR
Focus on:
- Root cause actually fixed (not just symptoms)
- Test that would have caught the bug
- No regressions introduced

### Feature PR
Focus on:
- Scope matches requirements
- Edge cases handled
- Feature flags if needed
- Documentation updated

### Refactor PR
Focus on:
- Behavior unchanged (tests prove this)
- Clear improvement (not change for change's sake)
- Not mixed with feature work

### Dependency Update PR
Focus on:
- Changelog reviewed
- Breaking changes addressed
- Security advisories checked
- Tests pass

---

## Comment Templates

### Request Specific Change
```
**[Category]:** [Brief title]

[What's wrong and why it matters]

Suggestion:
\`\`\`typescript
// suggested code
\`\`\`

This ensures [benefit].
```

### Ask Clarifying Question
```
**Question:** [Your question]

I see [observation]. Is this because [hypothesis A] or [hypothesis B]?

[Optional: suggestion based on answer]
```

### Suggest Improvement (Non-blocking)
```
**Suggestion (non-blocking):** [Brief title]

This works, but consider [alternative] because [reason].

Not required for this PR, but worth considering.
```

### Acknowledge Good Work
```
Nice approach here. [Specific thing you liked] makes this [benefit: readable/maintainable/efficient].
```

---

## Integration with Life OS

### Track in Weekly Metrics

Add to `/weekly-checkin`:
- PRs reviewed this week
- Average review time
- Review rounds on PRs you authored (your key metric)

### Pattern Detection

If you notice:
- Same feedback given repeatedly → Create team guideline
- PRs consistently too large → Discuss with team
- Same author making same mistakes → 1:1 conversation needed

### Connect to Your Bugs

Your "AI Tool Round-Trip Frustration" often comes from reviewing AI-generated code. When reviewing AI-assisted PRs:
- Look for over-engineering
- Check for unnecessary abstractions
- Verify the code is actually understood by author
- Ensure tests aren't just making CI green

---

## Quick Reference

```
/review-pr 123          # Review PR #123
/review-pr --checklist  # Show checklist only
/review-pr --templates  # Show comment templates
```

### Verdict Decision Tree

```
Tests pass?
├─ No → REQUEST_CHANGES
└─ Yes → Security issues?
         ├─ Yes → REQUEST_CHANGES
         └─ No → Blocks functionality?
                  ├─ Yes → REQUEST_CHANGES
                  └─ No → Just suggestions?
                           ├─ Yes → APPROVE (with comments)
                           └─ No → COMMENT (questions only)
```

---

*Review like you'd want to be reviewed. Be specific. Be kind. Ship quality.*
