---
description: Morning news curation. Personalized brief on AI, robotics, and tech.
---

# Daily Brief

## Context Loading

LOAD:
- CLAUDE.md: Identity section only (name, role, project)
- NOW.md: Current Mode only

DO NOT LOAD:
- Full CLAUDE.md
- Memory Log
- Journals
- Metrics

## Topics

Search for news and updates on:
1. **Generative AI** — New models, techniques, tools, research papers
2. **Robotics** — Hardware advances, control systems, applications
3. **Embodied AI** — Agents in physical world, simulation-to-real, multimodal systems
4. **Developer Tools** — Relevant to current stack (React Native, mobile dev, AI-assisted coding)

## Sources to Prioritize

- arXiv (AI/ML papers)
- Hacker News (tech discussions)
- TechCrunch, The Verge (industry news)
- GitHub Trending (relevant repos)
- Twitter/X AI accounts (if accessible)

## Flow

### 1. Get Date

Run: `date '+%A %B %d, %Y'`

### 2. Search

Use web search to find:
- Top 3-5 AI/ML news from past 24-48 hours
- Any significant robotics announcements
- Embodied AI research or product updates
- Developer tool releases relevant to stack

### 3. Filter

For each item, assess:
- **Relevance:** Does this matter for Youmigo, Nexale, or personal learning?
- **Actionability:** Is there something to do with this info?
- **Signal vs Noise:** Is this genuinely important or just hype?

Keep only high-signal items.

### 4. Create Brief

Create `briefs/YYYY-MM-DD-brief.md`:

```markdown
# Daily Brief: YYYY-MM-DD (Day)

## Top Stories

### 1. [Headline]
**Source:** [publication]
**Summary:** [2-3 sentences]
**Why it matters:** [1 sentence relevance to you]
**Link:** [url]

### 2. [Headline]
...

## Quick Hits
- [One-liner news item]
- [One-liner news item]
- [One-liner news item]

## Papers Worth Reading
- **[Paper Title]** — [One sentence summary] ([arXiv link])

## Repos to Watch
- **[repo-name]** — [What it does] ([GitHub link])

---

*Generated: [timestamp]*
```

### 5. Summarize

Output to user:
```
Daily Brief ready: briefs/YYYY-MM-DD-brief.md

Headlines:
1. [First headline]
2. [Second headline]
3. [Third headline]

[One sentence on most actionable item]
```

### 6. Connect (if relevant)

If any news item connects to:
- Current MIT → mention it
- Active Pattern → note the connection
- Youmigo/Nexale → highlight opportunity

## Close

"That's your brief. Anything to dive deeper on?"
