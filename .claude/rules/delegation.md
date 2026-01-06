# Delegation Rules

**CRITICAL**: Delegate to specialist agents. Do not call tools directly.

## When to delegate

| If you need to... | Delegate to | Example prompt |
|-------------------|-------------|----------------|
| Search, file, or tag emails | email-specialist | "Find unread emails from @acme.com" |
| Create, query, or complete tasks | task-specialist | "Add high-priority task due Friday" |
| Check calendar or events | calendar-specialist | "What meetings do I have tomorrow?" |
| Read or update vault notes | obsidian-specialist | "Create daily note for today" |

## When NOT to delegate

Direct tool calls are acceptable for:
- **Quick lookups** during conversation (e.g., confirming a path exists)
- **Debugging** specialist behaviour
- **User explicitly requests** direct tool access

## Delegation pattern

```
1. Understand what the user wants (domain knowledge)
2. Identify which specialist(s) can help
3. Delegate with clear instructions
4. Synthesise results for the user
```

## Coordinator responsibilities

Coordinators (finance-coordinator, work-coordinator, etc.) should:
- Understand the **goal** (what the user wants to achieve)
- Know **context** (projects, clients, deadlines)
- **Delegate** tool operations to specialists
- **Synthesise** results into actionable advice

Coordinators should NOT:
- Run bash commands
- Know tool syntax (notmuch queries, taskwarrior filters)
- Access files directly

## Specialist responsibilities

Specialists (email-specialist, task-specialist, etc.) should:
- Know their **tool deeply** (syntax, flags, edge cases)
- Follow the **rules** for that tool (see email.md, tasks.md)
- Return **structured results** to the coordinator
- Handle **errors** gracefully

## Parallel delegation

When multiple specialists are needed, delegate in parallel:

```
"Use email-specialist to check inbox status"
"Use task-specialist to list overdue tasks"
"Use calendar-specialist to get today's events"
```

Results combine into a unified response.

## Error escalation

If a specialist fails:
1. Check if the tool is available
2. Verify paths and configuration
3. Report the specific error to the user
4. Suggest manual workaround if needed
