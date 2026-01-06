# Claude Code ESO (Executive Support Officer)

I use Claude Code to manage my email, tasks, calendar, and knowledge through CLI tools.

## Contents

I keep the setup in `.claude/`. Copy it into your project for:
- Slash commands for email processing and daily planning
- Coordinators and specialists (a two-tier agent structure)
- Path-scoped rules for email and tasks
- Sample configs for mbsync, notmuch, Taskwarrior, vdirsyncer, khal, and khard

## Who this is for

Use this if you:
- Use Claude Code regularly
- Prefer CLI tools over web interfaces
- Want email, calendar, and task management stored locally
- Are comfortable editing config files and running sync tools

This is not for you if you:
- Need GUI applications
- Prefer cloud-only services
- Want zero configuration
- Rely heavily on browser-based workflows

## How it works

I keep everything as text that Claude Code can read directly:

- **Email** → Maildir + notmuch (local sync, search, tag-based filing)
- **Tasks** → Taskwarrior (CLI task management with projects and priorities)
- **Calendar** → khal + vdirsyncer (local CalDAV sync)
- **Contacts** → khard + vdirsyncer (local CardDAV sync)
- **Knowledge** → Obsidian vault (Markdown files with YAML front matter)

## Coordinators and specialists

I separate **what** needs to happen from **how** to use specific tools.

```
┌──────────────────────────────────────────────────┐
│              Domain coordinators                  │
│  (Understand goals, delegate to specialists)      │
├──────────────────────────────────────────────────┤
│  finance-coordinator  │  (add your own)          │
└───────────────┬──────────────────────────────────┘
                │
                ▼
┌──────────────────────────────────────────────────┐
│              Tool specialists                     │
│  (Know specific tools, reused by coordinators)   │
├──────────────────────────────────────────────────┤
│  email-specialist  │  task-specialist            │
└──────────────────────────────────────────────────┘
```

**Why I do it this way:**
- I can swap tools without rewriting domain logic. Change email client → only update email-specialist.
- Each agent gets only the context it needs.
- Specialists can run in parallel.

## What's included

```
.claude/
├── commands/
│   ├── start-of-day.md          # Morning planning, creates daily note
│   ├── end-of-day.md            # Evening review, updates daily note
│   ├── email-action-sweep.md    # Email processing (GTD workflow)
│   ├── meeting-process.md       # Meeting transcript → notes + tasks
│   ├── retro.md                 # Session retrospective, update CLAUDE.md
│   ├── updatedocs.md            # Update project documentation
│   └── claude-refactor.md       # Refactor CLAUDE.md to best practices
├── agents/
│   ├── coordinators/
│   │   ├── finance-coordinator.md
│   │   └── work-coordinator.md
│   └── specialists/
│       ├── email-specialist.md
│       └── task-specialist.md
└── rules/
    ├── delegation.md            # When to use specialists vs direct calls
    ├── email.md                 # Email filing rules (for email-specialist)
    └── tasks.md                 # Task management rules (for task-specialist)

scripts/
├── check-claude-md-size.sh      # Monitor CLAUDE.md token usage
├── md2clip.sh                   # Copy markdown to clipboard (WSL)
├── md2clip.ps1                  # PowerShell clipboard helper
├── audit-vault.py               # PARA structure compliance checker
└── email-file.sh                # Email filing template

examples/
├── configs/
│   ├── mbsyncrc.sample          # IMAP sync
│   ├── notmuch-config.sample    # Email indexing
│   ├── taskrc.sample            # Task management
│   ├── vdirsyncer-config.sample # Calendar/contact sync
│   ├── khal-config.sample       # CLI calendar
│   └── khard-config.sample      # CLI contacts
├── templates/
│   └── daily-note.md            # Daily note template
└── claude-md-hierarchy/
    ├── root-CLAUDE.md           # Project root example
    ├── work-CLAUDE.md           # Work subdirectory example
    └── finance-CLAUDE.md        # Finance subdirectory example
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

### Option 3: Add calendar and contacts

```bash
# Install pipx first if needed: sudo apt install pipx
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

Morning planning that creates a daily note and populates it:
- Create daily note (`YYYY-MM-DD.md`) from template
- Query tasks due today and high priority
- Check calendar events
- Review email inbox status
- Link relevant items into the daily note

### `/end-of-day`

Evening review that updates the daily note:
- Review completed tasks
- Capture carried-forward items
- Update timesheet status
- Fill in reflection section
- Set tomorrow's priorities

### `/email-action-sweep [batch_size]`

Email processing using the Getting Things Done (GTD) workflow:
- Fetch recent inbox emails
- Categorise by action required
- Create Taskwarrior tasks
- File to GTD folders (Action, Waiting-For, Reference, Archive)

### `/meeting-process [name]`

Process meeting transcripts (from Krisp, Otter.ai, or manual notes):
- Extract action items and decisions
- Create structured meeting note in vault
- Generate Taskwarrior tasks for follow-ups

### `/retro`

Session retrospective that updates CLAUDE.md with learnings:
- Review new tools or commands discovered
- Capture gotchas and their solutions
- Document successful patterns
- Identify reusable components or script opportunities

### `/updatedocs`

Update project documentation after a work session:
- Capture new technical information
- Document troubleshooting knowledge
- Update setup or configuration guides
- Add best practices discovered

### `/claude-refactor`

Refactor a project's CLAUDE.md to follow best practices:
- Move detailed content to docs/ subdirectories
- Extract rules to `.claude/rules/` for path-scoping
- Keep CLAUDE.md under 500 lines as a "launch pad"
- Maintain information integrity during migration

## Scripts

Helper scripts for common operations. These show the patterns I use — customise for your setup.

### `check-claude-md-size.sh`

Monitor CLAUDE.md token usage across your project:

```bash
./scripts/check-claude-md-size.sh
```

Checks global, project, and subdirectory CLAUDE.md files against recommended limits. Helps prevent context bloat.

### `md2clip.sh` + `md2clip.ps1`

Copy markdown to Windows clipboard with formatting preserved (for WSL users):

```bash
./scripts/md2clip.sh path/to/email-draft.md
# Paste into Outlook with Ctrl+V
```

Converts markdown to RTF via pandoc, then copies to clipboard. Headings, bold, and lists survive the paste.

### `audit-vault.py`

Check Obsidian vault for PARA compliance:

```bash
python scripts/audit-vault.py --vault ~/my-vault
python scripts/audit-vault.py --level error  # Show only errors
```

Validates folder structure, naming conventions, and frontmatter. Simplified version — extend for your own rules.

### `email-file.sh`

Template for batch email filing based on notmuch tags:

```bash
./scripts/email-file.sh --dry-run  # Preview what would be filed
./scripts/email-file.sh            # Actually file emails
```

Edit the filing rules at the bottom to match your email categories.

### Other scripts I use

These aren't included but show what else is possible:

- **Finance import** — Parse OFX files, categorise transactions, reconcile against Taskwarrior tasks
- **Habitify sync** — Export habit data to Obsidian for weekly reviews
- **Maildir audit** — Check for emails stuck in wrong folders, detect filing inconsistencies
- **Calendar prep** — Generate meeting agendas from Obsidian notes and email threads

## Email filing (GTD-based)

GTD = Getting Things Done, David Allen's productivity method. The core idea: decide what each email requires, then file it.

```
INBOX
  │
  ├─→ Action/          # Needs my action → create task
  ├─→ Waiting-For/     # Blocked on someone → create task +waiting
  ├─→ Interesting/     # FYI, worth reading later → no task
  ├─→ Vendors/[Name]/  # Reference material → no task
  ├─→ Filing/[Type]/   # Records → no task
  └─→ Archive/         # Old stuff → no task
```

## Knowledge filing (PARA-based)

I use a PARA structure for notes and documents. PARA = Projects, Areas, Resources, Archives (Tiago Forte's method).

```
vault/
├── 00-Daily-Notes/      # Daily working notes (YYYY-MM-DD.md)
├── 01-Projects/         # Active work with deadlines
├── 02-Areas/            # Ongoing responsibilities (no end date)
├── 03-Resources/        # Reference material
├── 04-Archives/         # Completed or inactive items
└── 09-Templates/        # Note templates
```

**Filing rules:**
- Has a deadline or deliverable → Projects
- Ongoing responsibility (health, finance, client relationship) → Areas
- Reference material I might need later → Resources
- Done or no longer relevant → Archives

**Daily notes** tie everything together. The `/start-of-day` command creates one each day (`YYYY-MM-DD.md`) and links to tasks, calendar events, and project notes.

This structure works with Obsidian, Logseq, or any folder of Markdown files.

## Context management

I load only what's needed for each task:

1. **CLAUDE.md hierarchy** — I put CLAUDE.md files in subdirectories to scope context to specific domains.

2. **Coordinators and specialists** — Coordinators load domain context, specialists load tool context. Never both at once.

3. **Path-scoped rules** — Rules load only when working in relevant directories.

4. **Text-based tools** — Everything is searchable.

## Running multiple windows

I run multiple Claude Code windows via tmux:

```bash
# Window 1: Processing meeting transcript
# Window 2: Drafting email responses
# Window 3: Financial reconciliation
```

Each window handles one task. I check in on them, give guidance when needed, and move on.

## Browser automation

I tried browser automation (Playwright, Chrome DevTools MCP) and found it unreliable. Screenshots use up context tokens quickly. DOM changes break workflows. Timing issues cause failures.

Text-based tools have worked better for me. They're scriptable and don't require visual parsing.

## MCP servers

MCP (Model Context Protocol) lets Claude Code call external tools. Krisp, Jira, and Outlook require MCP:

| Tool | MCP server | Use case |
|------|-----------|----------|
| Krisp | krisp-mcp | Meeting transcripts → action items |
| Jira | jira-mcp | Issue tracking |
| Outlook | outlook-mcp | Corporate environments where Maildir isn't an option |

I create a specialist agent for each MCP tool. The specialist handles the MCP complexity; coordinators just delegate.

MCP tool calls generate verbose context — schema definitions, multiple API calls. Running them in subagents keeps that context isolated from your main work.

## Privacy and security

This setup processes your email, calendar, and tasks locally.

- **Credentials**: Store IMAP/CalDAV passwords in a password manager, not plain text configs. The sample configs show how to use `pass`.
- **Obsidian vault**: Don't paste sensitive information into notes that Claude Code will read.
- **Email content**: Claude Code reads email bodies during `/email-action-sweep`. Be aware of what's in your inbox.

## Limitations

This setup is for text-heavy workflows with CLI tools. It doesn't help with GUI-only applications or workflows that require browser interaction.

## Requirements

- Claude Code CLI
- Unix-like environment (Linux, macOS, WSL)
- The tools you want to use (see Quick start)

## Contributing

Pull requests welcome. I'm interested in:
- Additional coordinator and specialist examples
- More tool integrations
- Documentation improvements

## Licence

MIT

## Future direction

I'm investigating replacing subagents with Claude Code skills. Skills may be more token-efficient and offer better context management since they run inline rather than spawning separate agents. The coordinator/specialist pattern would stay the same - just the implementation mechanism would change.

## Background

This setup evolved from daily use managing email, tasks, and knowledge across work and personal domains. The coordinator/specialist split came from wanting to swap tools without rewriting everything.

I also use this approach for audit scripts that scan Maildir filing, CLI wrappers that turn APIs into commands, and a side project for printing Markdown as reference cards.
