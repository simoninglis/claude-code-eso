# Claude ESO: Executive Support Officer

A framework for using Claude Code as a personal Executive Support Officer — managing email, tasks, calendar, and knowledge through CLI tools.

## The philosophy

**Text-first. CLI-native. Local-first.**

Instead of browser automation or complex MCP servers, this approach keeps everything as text that Claude Code can read directly:

- **Email** → Maildir + notmuch (local sync, fast search, tag-based filing)
- **Tasks** → Taskwarrior (CLI task management with projects and priorities)
- **Calendar** → khal + vdirsyncer (local CalDAV sync)
- **Contacts** → khard + vdirsyncer (local CardDAV sync)
- **Knowledge** → Obsidian vault (Markdown files with YAML frontmatter)

Claude Code reads, searches, and manipulates these directly. No browser DOM fighting. No token-heavy screenshots. Just text.

## The architecture

I use a two-tier agent system that separates **what** needs to happen from **how** to use specific tools.

```
┌─────────────────────────────────────────────────────────────┐
│                    Domain coordinators                       │
│  (Understand goals, orchestrate specialists)                 │
├─────────────────────────────────────────────────────────────┤
│  finance-coordinator  │  work-coordinator  │  home-coordinator│
│  health-coordinator   │  travel-coordinator│  ...             │
└───────────────┬───────────────────────────────┬─────────────┘
                │                               │
                ▼                               ▼
┌─────────────────────────────────────────────────────────────┐
│                    Tool specialists                          │
│  (Expert in specific tools, reused by all coordinators)      │
├─────────────────────────────────────────────────────────────┤
│  email-specialist  │  task-specialist  │  calendar-specialist │
│  obsidian-specialist │  krisp-specialist │  ...               │
└─────────────────────────────────────────────────────────────┘
```

**Why this works:**
- Swap tools without rewriting domain logic. Change email client → only update email-specialist.
- Each agent gets only the context it needs. I call this "surgical context".
- Specialists can run concurrently.

## What's included

```
claude-eso-master/
├── .claude/
│   ├── commands/                    # Slash commands
│   │   ├── email-action-sweep.md    # GTD-based email processing
│   │   └── start-of-day.md          # Morning planning workflow
│   ├── agents/
│   │   ├── README.md                # Architecture explanation
│   │   ├── coordinators/            # Domain coordinator examples
│   │   │   └── finance-coordinator.md
│   │   └── specialists/             # Tool specialist examples
│   │       ├── email-specialist.md
│   │       └── task-specialist.md
│   └── rules/                       # Path-scoped rules
│       ├── email.md
│       └── tasks.md
├── examples/
│   └── configs/                     # Sample tool configurations
│       ├── mbsyncrc.sample          # IMAP sync
│       ├── notmuch-config.sample    # Email indexing
│       ├── taskrc.sample            # Task management
│       ├── vdirsyncer-config.sample # Calendar/contact sync
│       ├── khal-config.sample       # CLI calendar
│       └── khard-config.sample      # CLI contacts
└── docs/                            # More documentation coming
```

## Quick start

### 1. Set up the tool stack

**Email (Maildir + notmuch):**
```bash
# Install
sudo apt install isync notmuch  # or brew install isync notmuch

# Configure (see examples/configs/)
cp examples/configs/mbsyncrc.sample ~/.mbsyncrc
cp examples/configs/notmuch-config.sample ~/.notmuch-config

# Initial sync
mbsync -a
notmuch new
```

**Tasks (Taskwarrior):**
```bash
sudo apt install taskwarrior  # or brew install task
cp examples/configs/taskrc.sample ~/.taskrc
```

**Calendar and contacts (khal + khard + vdirsyncer):**
```bash
pip install khal khard vdirsyncer
# Configure (see examples/configs/)
vdirsyncer discover
vdirsyncer sync
```

### 2. Copy Claude Code files

```bash
# Clone this repo
git clone https://github.com/simoninglis/claude-eso.git

# Copy to your project
cp -r claude-eso/.claude your-project/
```

### 3. Start using

```bash
cd your-project
claude

# Morning planning
/start-of-day

# Process email inbox
/email-action-sweep 30
```

## Key commands

### `/start-of-day`

Morning planning workflow:
- Query tasks due today and high priority
- Check calendar events
- Review email inbox status
- Create or update Obsidian daily note
- Interactive priority setting

### `/email-action-sweep [count]`

GTD-based email processing:
- Fetch recent inbox emails
- Categorise by action required
- Create Taskwarrior tasks
- File to GTD folders (Action, Waiting-For, Reference, Archive)
- Track progress in session notes

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

The real challenge is **surgical context** — right information at the right time, nothing more.

**Strategies I use:**

1. **CLAUDE.md hierarchy** — Drop CLAUDE.md files in subdirectories to scope context to specific domains.

2. **Two-tier agents** — Coordinators load domain context, specialists load tool context. Never both at once.

3. **Path-scoped rules** — Load rules only when working in relevant directories.

4. **Text-based tools** — Everything is grep-able, searchable, fast.

## Parallel work pattern

I run multiple Claude Code windows via tmux:

```bash
# Window 1: Processing meeting transcript
# Window 2: Drafting email responses
# Window 3: Financial reconciliation
```

Mental model: **I'm managing a small team, not using a tool.** Each window is a worker on a task. Some finish quickly, some need guidance. But I'm getting 3-4 things done in the time I'd normally do one.

## Why not browser automation?

Browser automation (Playwright, Chrome DevTools MCP) is:
- **Slow** — 3x slower than doing it yourself
- **Token-heavy** — Screenshots burn context
- **Fragile** — DOM changes break workflows
- **Unreliable** — Timing issues, popups, auth challenges

Text-based tools are:
- **Fast** — Direct file and database access
- **Token-efficient** — Just text, no images
- **Stable** — APIs don't change like UIs
- **Scriptable** — Chain with unix pipes

## Extending with MCP servers

The text-first approach handles most workflows. Some tools need MCP integration:

| Tool | MCP server | Use case |
|------|-----------|----------|
| **Krisp** | krisp-mcp | Meeting transcripts → action items, meeting notes |
| **Atlassian JIRA** | jira-mcp | Issue tracking, sprint management |
| **Outlook** | outlook-mcp | When Maildir isn't an option (corporate environments) |

**Pattern**: Create a specialist agent for each MCP tool. The specialist handles the MCP complexity; coordinators just delegate.

```
work-coordinator: "Extract action items from yesterday's standup"
  → krisp-specialist: Uses krisp-mcp to fetch transcript
  → task-specialist: Creates Taskwarrior tasks
  → obsidian-specialist: Updates meeting notes
```

**Why subagents for MCP?** MCP tool calls generate verbose context — schema definitions, multiple API calls. Running them in subagents keeps that context isolated from your main work.

## Requirements

- Claude Code CLI
- Unix-like environment (Linux, macOS, WSL)
- The tool stack (see Quick start)

## Limitations

This works well for:
- Text-heavy workflows
- CLI-friendly tools
- Local-first setups

It's not great for:
- GUI-only applications
- Cloud-only services without APIs
- Workflows that genuinely need browser interaction

If you need heavy browser automation, this probably isn't the right approach.

## Contributing

PRs welcome. Particularly interested in:
- Additional coordinator and specialist examples
- More tool integrations
- Documentation improvements
- Real-world workflow patterns

## Licence

MIT

## Background

This framework evolved from daily use managing:
- Multiple client engagements
- Email-heavy communication workflows
- Timesheet compliance
- Knowledge management across work, personal, and business domains

The patterns here are battle-tested.

## What I've built using this approach

The ESO workflow isn't just for managing existing work — it's also good for building new things:

- **[TriFold PDF](https://trifoldpdf.com)** — Markdown to printable tri-fold reference cards. I built the entire MVP (FastAPI backend, frontend, AWS deployment) using Claude Code with this agent structure. The two-tier architecture meant I could work on business logic while delegating infrastructure tasks to specialists.

- **Audit tools** — Python scripts that scan my Maildir filing and flag gaps. Claude Code calls these to help catch up on email admin debt.

- **Custom CLI wrappers** — Small tools that wrap complex APIs into simple commands Claude Code can call directly.

The parallel work pattern is particularly useful for building: one window handles code, another runs tests, a third manages deployment.

---

*Built with Claude Code. Managed by Claude Code.*
