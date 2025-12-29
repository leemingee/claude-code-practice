#!/bin/bash

# Intelligent Workflow System - Installation Script
# Run this after cloning the repo on a new machine

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "=============================================="
echo "  Intelligent Workflow System - Installer"
echo "=============================================="
echo ""

# Check if Claude Code directory exists
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating ~/.claude directory..."
    mkdir -p "$CLAUDE_DIR"
fi

# Function to backup existing files
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        echo "  Backing up existing: $target -> $backup"
        mv "$target" "$backup"
    fi
}

# Install commands
echo ""
echo "[1/4] Installing workflow commands..."
mkdir -p "$CLAUDE_DIR/commands/workflows/review"

for file in "$SCRIPT_DIR/setup/commands/workflows"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        target="$CLAUDE_DIR/commands/workflows/$filename"
        backup_if_exists "$target"
        cp "$file" "$target"
        echo "  Installed: $filename"
    fi
done

for file in "$SCRIPT_DIR/setup/commands/workflows/review"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        target="$CLAUDE_DIR/commands/workflows/review/$filename"
        backup_if_exists "$target"
        cp "$file" "$target"
        echo "  Installed: review/$filename"
    fi
done

# Install skills
echo ""
echo "[2/4] Installing workflow skills..."
for skill_dir in "$SCRIPT_DIR/setup/skills"/*/; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        target_dir="$CLAUDE_DIR/skills/$skill_name"
        mkdir -p "$target_dir"

        for file in "$skill_dir"*.md; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                target="$target_dir/$filename"
                backup_if_exists "$target"
                cp "$file" "$target"
                echo "  Installed: $skill_name/$filename"
            fi
        done
    fi
done

# Install workflow infrastructure
echo ""
echo "[3/4] Setting up workflow infrastructure..."
mkdir -p "$CLAUDE_DIR/workflows/projects"
mkdir -p "$CLAUDE_DIR/workflows/sessions"
mkdir -p "$CLAUDE_DIR/workflows/analytics/weekly"
mkdir -p "$CLAUDE_DIR/workflows/analytics/monthly"

# Copy workflow docs (don't overwrite registry if it exists with data)
for file in README.md PLAYBOOK.md; do
    if [ -f "$SCRIPT_DIR/setup/workflows/$file" ]; then
        target="$CLAUDE_DIR/workflows/$file"
        backup_if_exists "$target"
        cp "$SCRIPT_DIR/setup/workflows/$file" "$target"
        echo "  Installed: workflows/$file"
    fi
done

# Only create registry if it doesn't exist
if [ ! -f "$CLAUDE_DIR/workflows/registry.md" ]; then
    cp "$SCRIPT_DIR/setup/workflows/registry.md" "$CLAUDE_DIR/workflows/registry.md"
    echo "  Created: workflows/registry.md (fresh)"
else
    echo "  Skipped: workflows/registry.md (already exists)"
fi

# Verify installation
echo ""
echo "[4/4] Verifying installation..."

verify_file() {
    if [ -f "$1" ]; then
        echo "  ✓ $2"
        return 0
    else
        echo "  ✗ $2 (missing)"
        return 1
    fi
}

errors=0
verify_file "$CLAUDE_DIR/commands/workflows/start.md" "commands/workflows/start.md" || ((errors++))
verify_file "$CLAUDE_DIR/commands/workflows/implement.md" "commands/workflows/implement.md" || ((errors++))
verify_file "$CLAUDE_DIR/commands/workflows/status.md" "commands/workflows/status.md" || ((errors++))
verify_file "$CLAUDE_DIR/skills/workflow-state-management/SKILL.md" "skills/workflow-state-management" || ((errors++))
verify_file "$CLAUDE_DIR/skills/workflow-registry/SKILL.md" "skills/workflow-registry" || ((errors++))
verify_file "$CLAUDE_DIR/workflows/registry.md" "workflows/registry.md" || ((errors++))
verify_file "$CLAUDE_DIR/workflows/PLAYBOOK.md" "workflows/PLAYBOOK.md" || ((errors++))

echo ""
if [ $errors -eq 0 ]; then
    echo "=============================================="
    echo "  Installation Complete!"
    echo "=============================================="
    echo ""
    echo "You can now use workflow commands from any directory:"
    echo ""
    echo "  /workflows:start <description>   - Start a new workflow"
    echo "  /workflows:status                - Check current status"
    echo "  /workflows:list                  - List all workflows"
    echo "  /workflows:implement <ID>        - Continue a workflow"
    echo ""
    echo "For full documentation, see:"
    echo "  ~/.claude/workflows/PLAYBOOK.md"
    echo ""
else
    echo "=============================================="
    echo "  Installation completed with $errors error(s)"
    echo "=============================================="
    echo ""
    echo "Some files may be missing. Check the output above."
    exit 1
fi
