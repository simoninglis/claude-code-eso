# Start of Day Planning

Comprehensive day planning integrating Taskwarrior, Obsidian, calendar, and email management.

## Usage
```
/start-of-day
```

## Steps

### 1. Get Current Date and Day of Week

```bash
date +%Y-%m-%d
date +%A
```

Store these for use throughout the workflow.

### 2. Query Today's Commitments

**Tasks (Today + High Priority):**
```bash
# Query tasks due today or high priority
task '(due:today or priority:H) and status:pending' list
```

**Yesterday's Incomplete Tasks:**
```bash
# Get yesterday's date
date -d "yesterday" +%Y-%m-%d

# Find incomplete tasks due yesterday
task 'due:yesterday and status:pending' list
```

**Upcoming Deadlines This Week:**
```bash
# Tasks due this week (excluding today to avoid double-listing)
task 'due.after:today and due.before:eow and status:pending' list
```

**Project Distribution:**
```bash
# Count tasks by project for balance analysis
task project:Work status:pending count
task project:Finance status:pending count
task project:Home status:pending count
task project:Personal status:pending count
```

**Calendar Check:**
```bash
# Today's calendar events
khal list today today

# This week's events
khal list today 7d
```

**Inbox Status:**
```bash
# Email count for situational awareness
notmuch count folder:INBOX
notmuch count folder:INBOX and tag:unread
```

### 3. Check for Existing Daily Note

```bash
date +%Y-%m-%d  # Get current date for filename
```

Look for: `obsidian-vault/00-Daily Notes/YYYY-MM-DD.md`

If exists:
- Read existing note and preserve any content
- Update sections with fresh data
- Don't overwrite user's existing notes

If not exists:
- Create new daily note from template (see Step 4)

### 4. Create/Update Daily Note

Create or update file: `obsidian-vault/00-Daily Notes/{YYYY-MM-DD}.md`

**Template:**

```markdown
---
created: {YYYY-MM-DD}
modified: {YYYY-MM-DD}
tags: [daily-note, {YYYY-MM}]
type: daily-note
status: active
day_of_week: {Monday/Tuesday/etc}
---

# {Day of Week}, {YYYY-MM-DD}

## Daily Checklist

- [ ] Check email inbox (INBOX → Action/Waiting/Filing)
- [ ] Review Taskwarrior tasks
- [ ] Check calendar for meetings
- [ ] Update daily note at EOD

## Today's Focus

*(Top 3 priorities - ask user to identify)*

1.
2.
3.

## Calendar

{Insert khal output}

## Tasks

### High Priority

{Tasks with priority:H}

### Due Today

{Tasks with due:today}

### Carried Over from Yesterday

{Yesterday's incomplete tasks}

### Upcoming This Week

{Deadlines due.before:eow - context only}

## Email Inbox

**Total:** {count from notmuch}
**Unread:** {unread count}

{If >50 unread: ⚠️ Consider running /email-action-sweep}

## Meetings

{Space for meeting notes and links}

## Work

{Space for work tasks}

## Notes

{Space for notes throughout the day}

## End of Day Reflection

- What went well:
- Key accomplishments:
- What could improve:
- Tomorrow's priority:
```

### 5. Analyze and Present

**Time Analysis:**
- Estimate task time requirements
- Calculate total committed time
- Flag if overcommitted

**Priority Recommendations:**
- Urgent & Important (do first)
- Important but not urgent (schedule)
- Urgent but not important (delegate/minimize)
- Neither (defer)

**Project Balance:**
- Show distribution of tasks by project
- Highlight if one project has >50% of tasks (potential imbalance)
- Note projects with zero tasks (potential neglect)
- Suggest rebalancing if needed

**Example output:**
```
Project Task Distribution:
- Work: 8 total, 3 today (38%)
- Finance: 5 total, 2 today (25%)
- Home: 3 total, 2 today (25%)
- Personal: 2 total, 1 today (12%)

⚠️ Work is dominating today's focus (38%) - ensure other areas aren't neglected
```

**Email Pressure:**
- Note inbox count
- If >50 unread: Suggest /email-action-sweep
- If >20 in Action folder: Prioritize email responses

### 6. Interactive Planning

Ask user:

1. "What are your top 3 priorities for today?"
2. "Any tasks from yesterday you want to defer or delegate?"
3. "How's your energy/focus today? (High/Medium/Low)"
4. "Any meetings or hard deadlines today?"
5. "Are you overcommitted? Should we move anything?"

**Energy-based task matching:**
- High energy → Complex problem-solving, creative work, important meetings
- Medium energy → Routine admin, email responses, standard tasks
- Low energy → Filing, organizing, simple follow-ups

### 7. Finalize Daily Note

- Update with user's responses
- Add specific time estimates for priority tasks
- Create new Taskwarrior entries if needed
- Save daily note to Obsidian vault

### 8. Summary Output

Provide concise summary:
- Total tasks: X (across Y projects)
- High priority: Z tasks
- Overdue: A tasks
- Meetings: B scheduled
- Inbox status: C unread {⚠️ if >50}
- Energy level: High/Medium/Low
- Estimated workload: X hours

**Location:** `obsidian-vault/00-Daily Notes/{date}.md`

## Special Conditions

**Monday:**
- Suggest weekly review
- Check weekend carryover tasks
- Plan week's priorities

**Friday:**
- Suggest weekly review
- Plan for next week's priorities
- Clear any pending admin

**First day of month:**
- Review monthly goals
- Financial admin reminders
- Check recurring tasks

**Days with >50 unread emails:**
- Strongly suggest /email-action-sweep before other work
- Email pressure can derail the day

## Success Criteria

- Daily note created/updated with all sections populated
- User has identified top 3 priorities
- Realistic time estimates assigned
- Yesterday's carryover tasks addressed
- User feels clear and focused for the day
- Email pressure assessed and managed

## Notes

- Always use `date` command for current date (never cache)
- Check if Obsidian vault path exists before writing
- If task commands fail, continue with available data
- Keep interactive questions concise (user is starting their day)
- Focus on actionable planning, not lengthy analysis

## Related Commands
- `/email-action-sweep` - Process inbox
- `/audit-vault` - Check Obsidian filing compliance
