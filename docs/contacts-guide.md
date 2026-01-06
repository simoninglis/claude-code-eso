# Contacts Guide

A contacts database gives Claude Code context about the people you interact with. Commands use this to:

- Recognise email senders and suggest appropriate responses
- Identify meeting attendees and their roles
- File emails to correct vendor folders
- Draft communications with proper context

## File Location

Store contacts in your vault or project:

```
vault/03-Resources/contacts.yaml     # Personal vault
docs/references/contacts.yaml        # Project-specific
```

## File Format

YAML format with structured fields:

```yaml
contacts:
  - name: Jane Smith
    organization: Acme Corp
    role: Project Manager
    email: jane.smith@acme.com
    phone: 0400 123 456
    notes: |
      Primary contact for Website Redesign project
      Prefers email over phone
    tags:
      - client
      - acme
      - primary-contact
    first_contact: 2024-01-15
    last_contact: 2024-03-20
```

See `examples/templates/contacts.yaml` for a complete template.

## Required Fields

| Field | Purpose |
|-------|---------|
| `name` | Full name for recognition |
| `email` | Match against email senders |
| `organization` | Group contacts, suggest filing |

## Optional Fields

| Field | Purpose |
|-------|---------|
| `role` | Context for drafting responses |
| `phone` | Reference when calling |
| `notes` | History, preferences, context |
| `tags` | Filtering and categorisation |
| `first_contact` | Track relationship timeline |
| `last_contact` | Know when you last interacted |

## How Commands Use Contacts

### `/email-action-sweep`

When processing inbox:
1. Matches sender email against contacts database
2. Uses `organization` to suggest vendor folder
3. Uses `tags` to identify priority contacts
4. References `notes` for context on relationship

**Example**: Email from `jane.smith@acme.com` → recognised as client → suggests `Vendors/Acme/` folder

### `/meeting-process`

When processing transcripts:
1. Matches attendee names against contacts
2. Pulls role and organisation for meeting notes
3. Flags unknown attendees for adding to database
4. Updates `last_contact` date

**Example**: Meeting with "Jane Smith" → pulls "Project Manager, Acme Corp" into notes

### `/email-reply-draft`

When drafting responses:
1. Looks up sender in contacts
2. Uses `notes` for relationship context
3. Adjusts tone based on `tags` (client vs vendor vs colleague)
4. References recent interactions from `last_contact`

## Keeping Contacts Updated

### After meetings

```
/meeting-process
```

The command detects new attendees and prompts to add them.

### Periodic review

Add to your weekly review:
- Update `last_contact` dates
- Add notes from recent conversations
- Remove outdated contacts

### Automated updates

The meeting-process command can:
- Add new contacts automatically
- Update roles if they've changed
- Flag contacts not seen in 6+ months

## Tags Taxonomy

Consistent tags enable filtering:

**By relationship:**
- `client`, `vendor`, `recruitment`, `network`, `colleague`

**By priority:**
- `primary-contact`, `escalation`, `decision-maker`

**By domain:**
- `technical`, `finance`, `legal`, `sales`

**By status:**
- `active`, `dormant`, `former`

## Privacy Considerations

- Store contacts locally (not in cloud-synced folders if sensitive)
- Don't include passwords or credentials
- Be mindful of GDPR/privacy if storing customer data
- Use for professional contacts, not personal relationships

## Alternative: Markdown Format

For simpler needs, use markdown tables:

```markdown
# Project Contacts

| Name | Organisation | Role | Email | Notes |
|------|--------------|------|-------|-------|
| Jane Smith | Acme Corp | PM | jane@acme.com | Primary contact |
| Bob Johnson | Acme Corp | Tech Lead | bob@acme.com | Integration questions |
```

YAML is preferred for:
- Richer metadata (dates, tags, notes)
- Easier parsing by commands
- Structured updates

Markdown works for:
- Quick reference
- Sharing with others
- Simpler projects
