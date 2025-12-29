#!/bin/bash

# Intelligent Workflow System - Uninstallation Script
# Removes workflow commands, skills, and optionally workflow data

set -e

CLAUDE_DIR="$HOME/.claude"

echo "=============================================="
echo "  Intelligent Workflow System - Uninstaller"
echo "=============================================="
echo ""

# Check if anything is installed
if [ ! -d "$CLAUDE_DIR/commands/workflows" ] && [ ! -d "$CLAUDE_DIR/skills/workflow-state-management" ]; then
    echo "Nothing to uninstall. Workflow system is not installed."
    exit 0
fi

# Confirm uninstall
echo "This will remove:"
echo "  - ~/.claude/commands/workflows/ (workflow commands)"
echo "  - ~/.claude/skills/workflow-state-management/"
echo "  - ~/.claude/skills/workflow-registry/"
echo "  - ~/.claude/skills/implementing-skill/"
echo ""
echo "Optionally, you can also remove workflow data:"
echo "  - ~/.claude/workflows/ (registry, sessions, analytics)"
echo ""

read -p "Remove workflow commands and skills? (y/N) " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled."
    exit 0
fi

# Remove commands
echo ""
echo "[1/3] Removing workflow commands..."
if [ -d "$CLAUDE_DIR/commands/workflows" ]; then
    rm -rf "$CLAUDE_DIR/commands/workflows"
    echo "  Removed: commands/workflows/"
else
    echo "  Skipped: commands/workflows/ (not found)"
fi

# Remove skills
echo ""
echo "[2/3] Removing workflow skills..."
for skill in workflow-state-management workflow-registry implementing-skill; do
    if [ -d "$CLAUDE_DIR/skills/$skill" ]; then
        rm -rf "$CLAUDE_DIR/skills/$skill"
        echo "  Removed: skills/$skill/"
    else
        echo "  Skipped: skills/$skill/ (not found)"
    fi
done

# Ask about workflow data
echo ""
read -p "Also remove workflow data (registry, sessions, analytics)? (y/N) " remove_data
if [[ "$remove_data" =~ ^[Yy]$ ]]; then
    echo ""
    echo "[3/3] Removing workflow data..."
    if [ -d "$CLAUDE_DIR/workflows" ]; then
        # Backup first
        backup_dir="$HOME/workflow-backup-$(date +%Y%m%d%H%M%S)"
        echo "  Creating backup at: $backup_dir"
        cp -r "$CLAUDE_DIR/workflows" "$backup_dir"
        rm -rf "$CLAUDE_DIR/workflows"
        echo "  Removed: workflows/"
        echo "  Backup saved to: $backup_dir"
    else
        echo "  Skipped: workflows/ (not found)"
    fi
else
    echo ""
    echo "[3/3] Keeping workflow data..."
    echo "  Your workflow history is preserved at ~/.claude/workflows/"
fi

echo ""
echo "=============================================="
echo "  Uninstallation Complete!"
echo "=============================================="
echo ""
echo "To reinstall, run: ./install.sh"
echo ""
