# Meeting Process

Process a meeting transcript - extract action items, create tasks, and save meeting notes.

## Usage
```
/meeting-process [meeting_name]
```

Parameters:
- `meeting_name` (optional): Search term to find specific meeting

## Steps

### 1. Get Current Date
```bash
date "+%Y-%m-%d"
```

### 2. Find Meeting

If using Krisp MCP:
```
mcp__krisp-mcp__list_meetings with limit=10
mcp__krisp-mcp__find_meeting with query=[meeting_name]
```

Or provide transcript directly from:
- Krisp export
- Otter.ai
- Meeting recording transcription
- Manual notes

### 3. Analyse Transcript

Extract:

**Action Items**:
- Phrases: "action item", "follow up", "TODO", "by [date]", "need to", "will"
- Owner: "I'll", "you'll", "[name] will"
- Deadlines

**Decisions**:
- Phrases: "decided", "agreed", "confirmed", "approved"

**Key Topics**:
- Main discussion points
- Questions raised
- Blockers mentioned

### 4. Create Meeting Note

Save to: `vault/01-Projects/Meetings/YYYY-MM-DD-meeting-name.md`

```markdown
---
date: YYYY-MM-DD
meeting: Meeting Name
participants: [List]
duration: Duration
tags: [meeting, topic]
---

# Meeting Name - Date

## Overview
- **Date**:
- **Duration**:
- **Participants**:
- **Context**:

## Key Discussion Points

### Topic 1
Summary of discussion.

**Key Points**:
- Point 1
- Point 2

## Decisions Made

1. **Decision** - Context/rationale

## Action Items

### High Priority
- [ ] **Action** - Owner: Name - Due: Date
  - Context: Why this matters

### Follow-up Required
- [ ] Schedule follow-up about topic
- [ ] Send info to person

## Questions & Blockers

**Open Questions**:
- Question 1

**Blockers**:
- Blocker - affects what

## Next Meeting
- **Date**: If scheduled
- **Agenda**: Topics

## Notes

Additional context or quotes.
```

### 5. Create Tasks

For each action item:
```bash
task add project:Work due:friday "Follow up on proposal" +meeting
task add project:Work due:next-week "Research options discussed" +meeting
```

**Task naming**:
- Start with action verb
- Include context from meeting
- Add +meeting tag

### 6. Summary

```
MEETING PROCESSED: Meeting Name
================================
Date: Meeting date
Participants: Count

EXTRACTED:
✓ Action Items: X
✓ Decisions: Y
✓ Tasks Created: Z

SAVED TO:
vault/01-Projects/Meetings/YYYY-MM-DD-meeting-name.md

TASKS CREATED:
1. #142 - Follow up on proposal (Due: Friday)
2. #143 - Research options (Due: Next week)
```

## Action Item Patterns

| Pattern | Meaning |
|---------|---------|
| "I'll [action] by [date]" | Task for you |
| "Can you [action]?" | Task for you |
| "[Name] will [action]" | Note only (not your task) |
| "We need to [action]" | Clarify owner first |

## Priority Assignment

- **High**: Client deliverables, time-sensitive, blocking others
- **Medium**: Important but flexible, internal work
- **Low**: Nice-to-have, can be batched

## Related Commands

- `/start-of-day` - Morning review includes recent meetings
- `/end-of-day` - Capture any meeting follow-ups
