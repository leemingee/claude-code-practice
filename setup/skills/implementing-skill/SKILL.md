---
name: implementing-skill
description: Creates concise Claude Code skills from source documents, existing source code, or descriptions. Extracts only project-specific patterns. Target 50-100 lines.
---

# Implementing Skills

Creates focused skills containing only project-specific patterns, conventions, and gotchas.

## When to Use

- User wants to create a skill from documentation, code examples, or description
- Codifying project-specific patterns into reusable skill
- Repeated failures indicate a pattern needs to be documented

## Core Philosophy

**Assume Claude is an expert programmer.** Only include what's unique to this project:

**Include:**
- Project-specific naming/structure conventions
- Unique file locations and organization
- Critical gotchas and edge cases
- Project-specific validation commands
- Non-obvious patterns from codebase

**Exclude:**
- Standard language/framework knowledge
- Generic programming patterns
- Verbose explanations of common concepts
- Information in referenced example files

**Target: 50-100 lines** (150 max)

## Instructions

### 1. Analyze Input

Identify what the skill should capture:
- What operation does it describe?
- What patterns are project-specific?
- What mistakes should be avoided?

### 2. Check for Conflicts

Before creating:
- Search `.claude/skills/*/SKILL.md` for similar skills
- If overlap exists: suggest merging or differentiating
- Verify skill is the right solution (vs CLAUDE.md update or slash command)

### 3. Generate Skill Name

Format: `{domain}-{action}-{object}`

Examples:
- `backend-implementing-repository`
- `ios-creating-viewmodel`
- `infra-deploying-lambda`

Rules:
- Lowercase with hyphens
- Gerund form (-ing) for action
- Max 64 characters

### 4. Create SKILL.md

Structure:

```markdown
---
name: {skill-name}
description: {What + when, max 164 chars}
---

# {Title}

{One sentence: what it creates/does}

## When to Use

- {Trigger scenario 1}
- {Trigger scenario 2}

## Instructions

### 1. {First Step}

{Brief instructions}

### 2. {Main Action}

**{Component Type}:** `{path/pattern}`
- {Project-specific pattern}

**Reference:** `{path/to/example}`

### 3. Validate

\```bash
{project-specific validation command}
\```
```

### 5. Create config.json (Optional)

If skill should be suggested based on keywords:

```json
{
  "keywords": ["keyword1", "keyword2"],
  "hint": "{Brief hint when to use this skill}"
}
```

### 6. Validate

1. Check line count (target 50-100, max 150)
2. Remove any generic content
3. Verify all paths and references exist
4. Test skill invocation

## Naming Conventions

| Domain | Pattern | Example |
|--------|---------|---------|
| Backend | `backend-{action}-{object}` | `backend-implementing-repository` |
| iOS | `ios-{action}-{object}` | `ios-creating-viewmodel` |
| Android | `android-{action}-{object}` | `android-implementing-composable` |
| Infrastructure | `infra-{action}-{object}` | `infra-creating-terraform-module` |
| General | `{action}-{object}` | `implementing-skill` |
