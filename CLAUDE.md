# Claude ESO Master

Reference implementation for Claude Code as Executive Support Officer.

## Overview

This repo shows a two-tier agent architecture for personal and business management using CLI tools.

## Structure

```
.claude/
├── commands/         # Slash commands for workflows
├── agents/           # Two-tier agent system
│   ├── coordinators/ # Domain-focused (what to do)
│   └── specialists/  # Tool-focused (how to do it)
└── rules/            # Path-scoped rules

examples/
└── configs/          # Sample tool configurations
```

## Key patterns

### Two-tier architecture

- **Coordinators** understand domains (finance, work, health)
- **Specialists** understand tools (email, tasks, calendar)
- Coordinators delegate to specialists

### Text-first approach

All tools store data as text:
- Email → Maildir (one file per message)
- Tasks → Taskwarrior (~/.task/)
- Calendar → .ics files
- Contacts → .vcf files
- Notes → Markdown in Obsidian

### Surgical context

Load only what's needed:
- CLAUDE.md hierarchy for domain scoping
- Agents get focused context
- Rules load by path

## Commands

- `/start-of-day` — Morning planning workflow
- `/email-action-sweep` — GTD email processing

## Tool stack

| Tool | Purpose | Config |
|------|---------|--------|
| mbsync | IMAP → Maildir sync | ~/.mbsyncrc |
| notmuch | Email indexing and search | ~/.notmuch-config |
| taskwarrior | Task management | ~/.taskrc |
| vdirsyncer | CalDAV/CardDAV sync | ~/.config/vdirsyncer/config |
| khal | CLI calendar | ~/.config/khal/config |
| khard | CLI contacts | ~/.config/khard/khard.conf |

## Usage

This is a reference implementation. Copy what you need:

```bash
# Copy commands
cp .claude/commands/*.md your-project/.claude/commands/

# Copy agent structure
cp -r .claude/agents your-project/.claude/

# Adapt configs
cp examples/configs/*.sample ~/.config/
```

## Adapting for your use

1. **Projects** — Change project names in commands (Work, Finance, etc.)
2. **Paths** — Update Maildir and Obsidian vault paths
3. **Coordinators** — Add or modify for your life domains
4. **Specialists** — Add for your tools (JIRA, Notion, etc.)
