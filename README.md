# Claude Code ESO

I use Claude Code as my personal Executive Support Officer — managing email, tasks, calendar, and knowledge through CLI tools.

## What's in this repo

I keep the setup in `.claude/`. Copy it into your project for:
- Slash commands for email processing and daily planning
- Two-tier agent structure (coordinators + specialists)
- Path-scoped rules for email and tasks
- Sample configs for all the tools

## Who this is for

This works well if you:
- Use Claude Code regularly
- Prefer CLI tools over web interfaces
- Want local-first email, calendar, and task management
- Are comfortable editing config files and running local sync tools

This probably isn't for you if you:
- Need GUI applications
- Prefer cloud-only services
- Want something that works out of the box without configuration
- Rely heavily on browser-based workflows

## The philosophy

I keep everything text-based, CLI-driven, and local.

Instead of browser automation or complex MCP servers, I keep everything as text that Claude Code can read directly:

- **Email** → Maildir + notmuch (local sync, fast search, tag-based filing)
- **Tasks** → Taskwarrior (CLI task management with projects and priorities)
- **Calendar** → khal + vdirsyncer (local CalDAV sync)
- **Contacts** → khard + vdirsyncer (local CardDAV sync)
- **Knowledge** → Obsidian vault (Markdown files with YAML frontmatter)

No browser DOM fighting. No token-heavy screenshots. Just text.

## The two-tier agent structure

I separate **what** needs to happen from **how** to use specific tools.

```
┌─────────────────────────────────────────────────────────────┐
│                    Domain coordinators                       │
│  (Understand goals, delegate to specialists)                 │
├─────────────────────────────────────────────────────────────┤
│  finance-coordinator  │  work-coordinator  │  home-coordinator│
└───────────────┬───────────────────────────────┬─────────────┘
                │                               │
                ▼                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Tool specialists                          │
│  (Expert in specific tools, reused by all coordinators)      │
├─────────────────────────────────────────────────────────────┤
│  email-specialist  │  task-specialist  │  calendar-specialist │
└─────────────────────────────────────────────────────────────┘
```

**Why I do it this way:**
- I can swap tools without rewriting domain logic. Change email client → only update email-specialist.
- Each agent gets only the context it needs.
- Specialists can run in parallel.

## What's included

```
.claude/
├── commands/
│   ├── email-action-sweep.md    # GTD-based email processing
│   └── start-of-day.md          # Morning planning workflow
├── agents/
│   ├── coordinators/            # Domain coordinator examples
│   └── specialists/             # Tool specialist examples
└── rules/
    ├── email.md                 # Email filing rules
    └── tasks.md                 # Task management rules

examples/configs/
├── mbsyncrc.sample              # IMAP sync
├── notmuch-config.sample        # Email indexing
├── taskrc.sample                # Task management
├── vdirsyncer-config.sample     # Calendar/contact sync
├── khal-config.sample           # CLI calendar
└── khard-config.sample          # CLI contacts
```

## Quick start

### Option 1: Tasks only (minimal)

If you just want task management:

```bash
# Install Taskwarrior
sudo apt install taskwarrior  # or brew install task

# Copy the Claude Code files
git clone https://github.com/simoninglis/claude-code-eso.git
cp -r claude-code-eso/.claude your-project/

# Start using
cd your-project && claude
/start-of-day
```

### Option 2: Tasks + Email

Add email processing:

```bash
# Install
sudo apt install isync notmuch taskwarrior

# Configure (edit these with your details)
cp examples/configs/mbsyncrc.sample ~/.mbsyncrc
cp examples/configs/notmuch-config.sample ~/.notmuch-config
cp examples/configs/taskrc.sample ~/.taskrc

# Initial sync
mbsync -a
notmuch new
```

### Option 3: Full stack

Add calendar and contacts:

```bash
# Install (use pipx to avoid system Python issues)
pipx install khal
pipx install khard
pipx install vdirsyncer

# Configure
mkdir -p ~/.config/vdirsyncer ~/.config/khal ~/.config/khard
cp examples/configs/vdirsyncer-config.sample ~/.config/vdirsyncer/config
cp examples/configs/khal-config.sample ~/.config/khal/config
cp examples/configs/khard-config.sample ~/.config/khard/khard.conf

# Sync
vdirsyncer discover
vdirsyncer sync
```

## Key commands

### `/start-of-day`

Morning planning:
- Query tasks due today and high priority
- Check calendar events
- Review email inbox status
- Create or update Obsidian daily note

### `/email-action-sweep [count]`

GTD-based email processing:
- Fetch recent inbox emails
- Categorise by action required
- Create Taskwarrior tasks
- File to GTD folders (Action, Waiting-For, Reference, Archive)

## The GTD email workflow

```
INBOX
  │
  ├─→ Action/          # Needs my action → create task
  ├─→ Waiting-For/     # Blocked on someone → create task +waiting
  ├─→ Bacon/           # Interesting FYI → no task
  ├─→ Vendors/[Name]/  # Reference material → no task
  ├─→ Filing/[Type]/   # Records → no task
  └─→ Archive/         # Old stuff → no task
```

## Context management

The challenge is loading the right information at the right time, nothing more.

**Strategies I use:**

1. **CLAUDE.md hierarchy** — Drop CLAUDE.md files in subdirectories to scope context to specific domains.

2. **Two-tier agents** — Coordinators load domain context, specialists load tool context. Never both at once.

3. **Path-scoped rules** — Load rules only when working in relevant directories.

4. **Text-based tools** — Everything is searchable and fast.

## Parallel work pattern

I run multiple Claude Code windows via tmux:

```bash
# Window 1: Processing meeting transcript
# Window 2: Drafting email responses
# Window 3: Financial reconciliation
```

Mental model: **I'm managing a small team, not using a tool.** Each window is a worker on a task. Some finish quickly, some need guidance. But I'm getting 3-4 things done in the time I'd normally do one.

## Why not browser automation?

Browser automation (Playwright, Chrome DevTools MCP) has been slow and unreliable in my experience. Screenshots burn context. DOM changes break workflows. Timing issues and popups cause failures.

Text-based tools are faster, more stable, and scriptable. Your mileage may vary.

## Extending with MCP servers

The text-first approach handles most workflows. Some tools need MCP integration:

| Tool | MCP server | Use case |
|------|-----------|----------|
| **Krisp** | krisp-mcp | Meeting transcripts → action items |
| **Atlassian JIRA** | jira-mcp | Issue tracking |
| **Outlook** | outlook-mcp | Corporate environments where Maildir isn't an option |

**How I handle MCP**: I create a specialist agent for each MCP tool. The specialist handles the MCP complexity; coordinators just delegate.

**Why subagents for MCP?** MCP tool calls generate verbose context — schema definitions, multiple API calls. Running them in subagents keeps that context isolated from your main work.

## Privacy and security

This setup processes your email, calendar, and tasks locally. Some things to consider:

- **Credentials**: Store IMAP/CalDAV passwords in a password manager, not plain text configs. The sample configs show how to use `pass` or similar.
- **Obsidian vault**: Don't paste sensitive information into notes that Claude Code will read.
- **Email content**: Claude Code will read email bodies during `/email-action-sweep`. Be aware of what's in your inbox.

## Limitations

This works well for text-heavy workflows with CLI-friendly tools. It's not great for GUI-only applications or workflows that genuinely need browser interaction.

## Requirements

- Claude Code CLI
- Unix-like environment (Linux, macOS, WSL)
- The tools you want to use (see Quick start)

## Contributing

PRs welcome — I'm keen on:
- Additional coordinator and specialist examples
- More tool integrations
- Documentation improvements

## Licence

MIT

## Background

This evolved from daily use managing multiple client engagements, email workflows, and knowledge across work and personal domains.

## Projects built with this approach

- **Audit tools** — Python scripts that scan Maildir filing and flag gaps. Claude Code calls these to catch up on email admin.

- **CLI wrappers** — Small tools that wrap APIs into commands Claude Code can call.

- TriFold PDF (trifoldpdf.com) — A side project for printing Markdown as reference cards. I mention it because it's where I tested the coordinator/specialist split for a real product.
