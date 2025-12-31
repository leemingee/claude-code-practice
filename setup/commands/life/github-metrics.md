---
description: GitHub metrics integration. Auto-populate engineering metrics from gh CLI.
---

# GitHub Metrics

## Purpose

Automatically populate engineering metrics in NOW.md by querying GitHub via `gh` CLI. Tracks commits, PRs, review rounds, and issues.

## Prerequisites

- `gh` CLI installed and authenticated
- Repository has GitHub remote

## Context Loading

LOAD:
- NOW.md: Metrics section only

DO NOT LOAD:
- CLAUDE.md
- Journals
- Memory Log

## Flow

### 1. Check Prerequisites

```bash
# Verify gh is installed and authenticated
gh auth status
```

If not authenticated:
```
GitHub CLI not authenticated. Run: gh auth login
```

### 2. Detect Repository

```bash
# Get current repo info
gh repo view --json owner,name,url
```

If no repo:
```
Not in a GitHub repository. Navigate to a repo first.
```

### 3. Gather Metrics

#### Commits This Week

```bash
# Get commits from last 7 days by current user
gh api graphql -f query='
query {
  viewer {
    contributionsCollection(from: "YYYY-MM-DDT00:00:00Z") {
      totalCommitContributions
      commitContributionsByRepository {
        repository { name }
        contributions { totalCount }
      }
    }
  }
}'
```

Or simpler with git:
```bash
git log --oneline --author="$(git config user.email)" --since="7 days ago" | wc -l
```

#### PRs Merged

```bash
# PRs merged this week
gh pr list --state merged --author @me --json number,title,mergedAt,additions,deletions --limit 50
```

Filter by date in processing.

#### PR Review Rounds

For each merged PR, calculate review rounds:
```bash
# Get PR reviews
gh pr view <number> --json reviews,reviewRequests
```

Count:
- Number of "CHANGES_REQUESTED" reviews
- Number of subsequent commits after first review
- Review rounds = max(changes_requested_count, commit_rounds)

#### Issues Closed

```bash
gh issue list --state closed --assignee @me --json number,title,closedAt --limit 50
```

Filter by date range.

### 4. Calculate Metrics

```javascript
// Pseudocode for metric calculation
metrics = {
  commits: count_commits_this_week(),
  prs_merged: count_merged_prs_this_week(),
  pr_review_rounds_avg: calculate_avg_review_rounds(merged_prs),
  issues_closed: count_closed_issues_this_week(),
  features_shipped: count_prs_with_label("feature"),

  // Trends vs last week
  commits_trend: compare_to_last_week(commits, last_week_commits),
  prs_trend: compare_to_last_week(prs, last_week_prs)
}
```

### 5. Update NOW.md

Update the Metrics section:

```markdown
## Youmigo Development

| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Commits | 23 | 18 | +28% |
| PRs Merged | 4 | 3 | +33% |
| PR Review Rounds (avg) | 2.3 | 3.1 | -26% (better) |
| Issues Closed | 7 | 5 | +40% |
| Features Shipped | 2 | 1 | +100% |

## Engineering Excellence

| Metric | This Week | Target |
|--------|-----------|--------|
| PR Review Rounds | 2.3 | <3 |
| Time to Merge | 0.8 days | <1 day |
| Code Quality Score | - | - |
```

### 6. Analyze for Patterns

Check if metrics reveal patterns:

**High PR Review Rounds:**
- If avg > 3: Check if "AI tool round-trips" pattern is related
- Suggest: "Your review rounds are high. Is the Claude→Gemini loop contributing?"

**Low Commit Activity:**
- If commits < last week by 50%+: Check mode and blockers
- Suggest: "Commits down significantly. What's blocking shipping?"

**Feature Velocity:**
- Track features_shipped over time
- Correlate with mode (BUILD should have higher velocity)

### 7. Output

```
GitHub Metrics Updated

This Week:
- Commits: 23 (+28%)
- PRs Merged: 4
- Avg Review Rounds: 2.3 (target: <3) ✓
- Issues Closed: 7

Insights:
- Review rounds improved! Down from 3.1 to 2.3
- Feature velocity: 2 shipped (on track)

NOW.md metrics section updated.
```

---

## Commands

### /github-sync

Quick sync of GitHub metrics:
```
/github-sync
```

Updates NOW.md metrics without full analysis.

### /github-report

Full GitHub activity report:
```
/github-report [timeframe]
```

Options:
- `week` (default)
- `month`
- `quarter`

Generates detailed report in `metrics/github-report-YYYY-MM-DD.md`.

---

## Metric Definitions

| Metric | Definition | Target |
|--------|------------|--------|
| Commits | Total commits to any branch | - |
| PRs Merged | PRs merged to main/master | - |
| PR Review Rounds | (Commits after first review) + (Changes requested) | <3 |
| Time to Merge | Days from PR open to merge | <1 day |
| Issues Closed | Issues closed and assigned to you | - |
| Features Shipped | PRs with "feature" label merged | - |

---

## Integration with Weekly Check-in

The `/weekly-checkin` command calls GitHub metrics automatically:

```markdown
# In /weekly-checkin flow:

1. Run github-metrics to get fresh data
2. Include in weekly report
3. Compare to previous week
4. Highlight significant changes
5. Check for pattern correlations
```

---

## Error Handling

| Error | Response |
|-------|----------|
| gh not installed | "Install GitHub CLI: brew install gh" |
| gh not authenticated | "Authenticate: gh auth login" |
| Not in git repo | "Navigate to a repository first" |
| No remote | "Add GitHub remote: git remote add origin ..." |
| API rate limit | "GitHub API rate limited. Try again in X minutes." |
| Network error | "Can't reach GitHub. Check connection." |

---

## Privacy Note

All queries are scoped to:
- Your commits only (`--author @me`)
- Your PRs only (`--author @me`)
- Your issues only (`--assignee @me`)

No other user data is accessed.
