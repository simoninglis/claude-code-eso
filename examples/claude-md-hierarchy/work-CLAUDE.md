# Work Domain CLAUDE.md

Place this in your `work/` subdirectory. It loads when working in that directory.

## Context

Work-related projects and client engagements.

## Task Project

```bash
# All work tasks
task project:Work list

# Add work task
task add project:Work.ClientA due:friday "Deliverable name"
```

## Clients

| Client | Project Code | Contact |
|--------|--------------|---------|
| ClientA | Work.ClientA | name@client.com |
| ClientB | Work.ClientB | name@clientb.com |

## Email Filing

Work emails go to:
- `Clients/ClientA/` - Client-specific
- `Work/Admin/` - Internal admin

## Timesheet

```bash
# Check timesheet status (if using lime-timesheets)
cd ~/work/lime-timesheets && poetry run lts timesheet status
```

## Notes

Work notes location: `vault/01-Projects/Work/`
