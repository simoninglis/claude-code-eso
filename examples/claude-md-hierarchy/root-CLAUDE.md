# Project Root CLAUDE.md

This file loads for all work in this project.

## Overview

Personal and business management system using CLI tools.

## Quick Commands

```bash
# Get current date (always check first)
date +%Y-%m-%d

# Tasks due today
task due:today list

# Email inbox count
notmuch count folder:INBOX
```

## Tool Stack

| Tool | Purpose |
|------|---------|
| Taskwarrior | Task management |
| notmuch | Email search |
| khal | Calendar |
| Obsidian | Notes (vault/) |

## Subdirectories

Each subdirectory can have its own CLAUDE.md with domain-specific context:

- `work/` - Work client projects
- `finance/` - Financial tracking
- `personal/` - Personal projects

## Rules

- Always use `date` command for current date
- Check task dependencies before marking complete
- File emails immediately after processing
