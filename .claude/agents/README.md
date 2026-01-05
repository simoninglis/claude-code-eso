# Claude ESO Agent System

This directory contains Claude Code agents organized using a two-tier architecture with domain coordinators and tool specialists.

## Architecture Overview

**Two-Layer Design:**
- **Domain Coordinators**: Goal-oriented agents that understand life/work domains and orchestrate tool specialists
- **Tool Specialists**: Execution-focused agents that handle specific tools/systems

This separation means you can swap tools without rewriting domain logic.

```
User: "Run my weekly financial review"
  ↓
finance-coordinator:
  → email-specialist: "Find bank statements from past 7 days"
  → task-specialist: "Check finance tasks due next 7 days"
  → obsidian-specialist: "Update Dashboard.md with budget status"
  → Synthesizes results into weekly summary
```

## Domain Coordinators

Domain coordinators handle high-level life areas and delegate to tool specialists for execution.

### Example Coordinators

| Coordinator | Focus | Delegates To |
|-------------|-------|--------------|
| finance-coordinator | Budgets, bills, transactions, reconciliations | email, obsidian, task |
| work-coordinator | Projects, meetings, deliverables, clients | email, obsidian, task, krisp, calendar |
| health-coordinator | Medical appointments, medications, fitness | email, obsidian, task, calendar |
| home-coordinator | Household maintenance, cleaning, repairs | obsidian, task |
| travel-coordinator | Bookings, itineraries, packing lists | email, obsidian, task, calendar |

### Coordinator Responsibilities

Each coordinator:
- Understands the **domain context** (what needs to happen)
- Knows **when to delegate** to specialists
- **Synthesizes results** from multiple specialists
- Maintains **domain-specific knowledge** (e.g., finance-coordinator knows reconciliation workflows)

## Tool Specialists

Tool specialists are experts in specific tools/systems and are reused by all domain coordinators.

### Available Specialists

| Specialist | Tool | Capabilities |
|------------|------|--------------|
| email-specialist | Maildir/notmuch | Search, filing, draft creation, batch processing |
| obsidian-specialist | Obsidian vault | Note creation, dashboard updates, YAML frontmatter |
| task-specialist | Taskwarrior | Task creation, dependencies, priorities, reporting |
| calendar-specialist | khal/vdirsyncer | Event creation, availability, scheduling |
| krisp-specialist | Krisp MCP | Meeting transcripts, action item extraction |

### Specialist Responsibilities

Each specialist:
- Is an **expert in one tool** (deep knowledge)
- Follows **tool-specific standards** (naming conventions, folder structures)
- Provides **consistent interfaces** for coordinators
- Handles **error cases** for that tool

## Usage Patterns

### Invoking Domain Coordinators

Domain coordinators are invoked naturally by life domain:

```
"Help me organize finances this month"     → finance-coordinator
"Prep for my client meeting tomorrow"      → work-coordinator
"Schedule my medical appointments"         → health-coordinator
"Plan my trip to Melbourne"                → travel-coordinator
"Create weekly cleaning schedule"          → home-coordinator
```

### Direct Tool Specialist Usage

For simple tool-specific tasks, invoke specialists directly:

```
"Search for emails from the bank"          → email-specialist
"Create meeting note for today's standup"  → obsidian-specialist
"Show tasks due this week"                 → task-specialist
"What's on my calendar Friday?"            → calendar-specialist
"Get transcript from Monday's meeting"     → krisp-specialist
```

## Delegation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    User Request                              │
│         "Review my finances for this week"                   │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              finance-coordinator                             │
│  Understands: budgets, bills, reconciliation workflows       │
│  Decides: need bank emails, task status, update dashboard    │
└─────────────────────────┬───────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│   email-    │   │   task-     │   │  obsidian-  │
│  specialist │   │  specialist │   │  specialist │
├─────────────┤   ├─────────────┤   ├─────────────┤
│ Search for  │   │ List tasks  │   │ Update      │
│ bank emails │   │ tagged      │   │ Dashboard   │
│ last 7 days │   │ +finance    │   │ with status │
└──────┬──────┘   └──────┬──────┘   └──────┬──────┘
       │                 │                 │
       └────────────────┬┴─────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              finance-coordinator                             │
│  Synthesizes: combines results into weekly summary           │
│  Returns: formatted report to user                           │
└─────────────────────────────────────────────────────────────┘
```

## Adding New Agents

### Adding a Domain Coordinator

1. Create `.claude/agents/coordinators/[domain]-coordinator.md`
2. Define:
   - Domain overview and goals
   - Core workflows (with orchestration examples)
   - Delegation patterns (when to use which specialists)
   - Integration with other coordinators
3. Update this README

### Adding a Tool Specialist

1. Create `.claude/agents/specialists/[tool]-specialist.md`
2. Define:
   - Tool overview and capabilities
   - Operation patterns and examples
   - Standards and conventions
   - Error handling
3. Update domain coordinators that should use this specialist
4. Update this README

## Coordination Between Domains

Domain coordinators often need to work together:

**Finance ↔ Work**:
- Work tracks income/invoices → Finance budgets for household

**Health ↔ Calendar**:
- Health schedules appointments → Calendar-specialist blocks time

**Travel ↔ Finance**:
- Travel plans trip → Finance tracks travel budget

## Why This Architecture?

**Benefits:**
1. **Separation of concerns** — Domain logic separate from tool mechanics
2. **Reusability** — Tool specialists used by multiple coordinators
3. **Swappable tools** — Change email client without rewriting finance logic
4. **Focused context** — Each agent only loads what it needs (surgical context)
5. **Parallel execution** — Specialists can run concurrently

**Trade-offs:**
- More files to maintain
- Initial setup complexity
- Need to keep specialists in sync

---

*See `coordinators/` and `specialists/` directories for implementation examples.*
