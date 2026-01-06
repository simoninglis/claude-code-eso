# Frontmatter Guide

YAML frontmatter at the top of markdown files enables search, filtering, and compliance checking.

## Required Fields

These fields should appear in all notes (except templates):

| Field | Format | Purpose |
|-------|--------|---------|
| `created` | YYYY-MM-DD | When the note was created |
| `modified` | YYYY-MM-DD | Last significant update |
| `tags` | [tag1, tag2] | Categorisation for search |
| `status` | string | Current state of the item |

## Status Values

| Status | Use When |
|--------|----------|
| `active` | Currently relevant and in use |
| `draft` | Work in progress |
| `completed` | Done, kept for reference |
| `archived` | No longer active, moved to Archives |
| `scheduled` | Planned for future |
| `on-hold` | Paused, waiting on something |
| `cancelled` | Won't proceed |

## Optional Fields

Add these based on note type:

| Field | Format | Use For |
|-------|--------|---------|
| `type` | string | Note category (daily-note, project, meeting, area) |
| `project` | string | Link to parent project |
| `due` | YYYY-MM-DD | Deadline (for projects) |
| `attendees` | [name1, name2] | Meeting participants |
| `client` | string | Client or stakeholder name |

## Examples by Note Type

### Daily Note

```yaml
---
created: 2024-01-15
modified: 2024-01-15
tags: [daily-note, 2024-01]
type: daily-note
status: active
---
```

### Project Note

```yaml
---
created: 2024-01-10
modified: 2024-01-15
tags: [project, client-acme, website]
type: project
status: active
project: ClientA-Website-Redesign
due: 2024-03-01
client: Acme Corp
---
```

### Meeting Note

```yaml
---
created: 2024-01-15
modified: 2024-01-15
tags: [meeting, client-acme, kickoff]
type: meeting
status: completed
project: ClientA-Website-Redesign
attendees: [Jane Smith, John Doe]
---
```

### Area Note

```yaml
---
created: 2024-01-01
modified: 2024-01-15
tags: [area, finance, tax]
type: area
status: active
---
```

## Tag Taxonomy

Use consistent tags for effective filtering:

**By domain:**
- `finance`, `health`, `work`, `home`, `personal`

**By type:**
- `daily-note`, `project`, `meeting`, `area`, `reference`

**By time:**
- `2024-01` (year-month for date-based filtering)

**By client/project:**
- `client-acme`, `project-website`

## Audit Compliance

The `audit-vault.py` script checks:

1. **Structure** — PARA folders exist (00-Daily-Notes, 01-Projects, etc.)
2. **Naming** — Daily notes follow YYYY-MM-DD.md format
3. **Frontmatter** — Notes in Projects/Areas have frontmatter
4. **Filing** — Old daily notes flagged for archiving

Run the audit:

```bash
python scripts/audit-vault.py --vault ~/my-vault
python scripts/audit-vault.py --level info  # Show all findings
```

## Tips

1. **Use templates** — Create notes from templates to ensure consistent frontmatter
2. **Update modified date** — When making significant changes, update the date
3. **Tag early** — Add tags when creating, easier than retroactive tagging
4. **Keep status current** — Update status as items progress
