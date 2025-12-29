# /workflows:projects

Show all tracked projects and their workflow statistics.

## Arguments

$ARGUMENTS can contain:
- `{project-name}`: Show details for specific project
- `--stats`: Focus on statistics
- `--add {path}`: Register a new project manually

Examples:
- `/workflows:projects` - List all projects
- `/workflows:projects ios-app` - Details for ios-app
- `/workflows:projects --add ~/src/new-project` - Register new project

## Instructions

### 1. List All Projects (default)

Read all files in `~/.claude/workflows/projects/`

Format output:

```
=== Tracked Projects ===

┌──────────────────┬──────────────┬────────────┬─────────┬──────────┐
│ Project          │ Type         │ Workflows  │ Success │ Last     │
├──────────────────┼──────────────┼────────────┼─────────┼──────────┤
│ ios-app          │ iOS          │ 12         │ 92%     │ 2h ago   │
│ backend          │ Backend      │ 8          │ 88%     │ 1d ago   │
│ terraform        │ Infra        │ 5          │ 100%    │ 3d ago   │
│ claude-code-guide│ Tooling      │ 1          │ 100%    │ today    │
└──────────────────┴──────────────┴────────────┴─────────┴──────────┘

4 projects tracked | 26 total workflows | 93% overall success rate
```

### 2. Project Details

When specific project requested:

Read `~/.claude/workflows/projects/{project-slug}.md`

Format output:

```
=== Project: ios-app ===

Overview:
  Path: ~/src/ios-app
  Type: iOS
  First Tracked: 2024-10-15

Description:
  Main iOS application for the product. SwiftUI-based with MVVM architecture.

Domains: iOS, Mobile

Statistics:
  Total Workflows: 12
  Completed: 11 (92%)
  Abandoned: 1
  Avg Duration: 1.5 days

Recent Workflows:
┌─────────────┬──────────┬─────────┬────────────┐
│ ID          │ Type     │ Outcome │ Date       │
├─────────────┼──────────┼─────────┼────────────┤
│ GH-156      │ Feature  │ SUCCESS │ 2024-12-27 │
│ GH-152      │ Bug      │ SUCCESS │ 2024-12-25 │
│ LOCAL-auth  │ Refactor │ ABANDON │ 2024-12-20 │
└─────────────┴──────────┴─────────┴────────────┘

Active Workflows:
  - GH-158: IMPLEMENTATION D-2 (push notifications)

Notes:
  {any user-added notes from the project file}
```

### 3. Add New Project

When `--add {path}` specified:

1. Validate path exists
2. Generate project slug from directory name
3. Determine project type (ask user or infer from files)
4. Create project file from template
5. Report success

```
Project registered: new-project
Path: ~/src/new-project
Type: (detected as Backend based on package.json)

You can now start workflows in this project.
```

### 4. Edit Project

Offer to edit project details:

```
Would you like to update this project?
[1] Change description
[2] Update domains
[3] Add notes
[4] View full history
```

### 5. Cross-Project Analysis

Compare projects:

```
=== Project Comparison ===

Completion Rate:
  terraform:     ██████████ 100%
  ios-app:       █████████░  92%
  backend:       ████████░░  88%

Avg Workflow Duration:
  backend:       ████████████ 2.1 days
  ios-app:       ████████     1.5 days
  terraform:     ████         0.8 days

Most Active (last 30 days):
  ios-app:       ████████████ 8 workflows
  backend:       ██████       4 workflows
  terraform:     ███          2 workflows
```

## Project Type Detection

Infer project type from files:
- `Package.swift`, `*.xcodeproj` → iOS
- `build.gradle.kts`, `AndroidManifest.xml` → Android
- `package.json` + server indicators → Backend (Node)
- `requirements.txt`, `pyproject.toml` → Backend (Python)
- `*.tf` files → Infrastructure
- `Cargo.toml` → Rust
- `go.mod` → Go

## Error Handling

- Project not found: Suggest similar names or list all
- Invalid path for --add: Report error with suggestion
- No projects tracked: Guide to first workflow
