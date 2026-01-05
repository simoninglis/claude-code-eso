# End of Day Review

Close out the day: review accomplishments, update daily note, ensure timesheet is current, and capture anything for tomorrow.

## Usage
```
/end-of-day
```

## Steps

### 1. Get Current Date

```bash
date +%Y-%m-%d
date +%A
```

### 2. Review Today's Tasks

**Completed today:**
```bash
task end:today completed
```

**Still pending (carried forward):**
```bash
task due:today status:pending list
```

**Overdue:**
```bash
task +OVERDUE list
```

### 3. Check Timesheet Status

```bash
# If using lime-timesheets
cd ~/work/lime-timesheets && poetry run lts timesheet status
```

Flag if timesheet needs updating before end of day.

### 4. Check Email Status

```bash
notmuch count folder:INBOX
notmuch count folder:Action
```

Note any urgent items that need attention tomorrow.

### 5. Update Daily Note

Open today's daily note: `vault/00-Daily-Notes/{YYYY-MM-DD}.md`

Update the "End of Day Reflection" section:

```markdown
## End of Day Reflection

**Completed:**
- {List tasks completed today}

**Carried forward:**
- {Tasks not finished, moving to tomorrow}

**What went well:**
- {User input}

**What could improve:**
- {User input}

**Tomorrow's priority:**
- {Top 1-3 items for tomorrow}

**Timesheet:** [x] Updated
```

### 6. Create Tomorrow's Tasks

For any carried-forward items:
```bash
task {id} modify due:tomorrow
```

For new items identified:
```bash
task add project:Work due:tomorrow "Task description"
```

### 7. Summary

Present:
```
END OF DAY SUMMARY
==================
Date: {today}

Completed: X tasks
Carried forward: Y tasks
Overdue: Z tasks

Timesheet: {status}
Inbox: {count} ({action count} need action)

Tomorrow's focus:
1. {priority 1}
2. {priority 2}
3. {priority 3}

Daily note updated: vault/00-Daily-Notes/{date}.md
```

## Interactive Questions

1. "What went well today?"
2. "What didn't get done that should move to tomorrow?"
3. "Anything you want to capture before closing out?"
4. "Is your timesheet updated?"

## Special Conditions

**Friday:**
- Ensure timesheet is submitted (not just updated)
- Review week's accomplishments
- Clear inbox to <20 if possible

**Before leave/holiday:**
- Document handover items
- Set out-of-office reminders
- Clear urgent items

## Success Criteria

- Daily note has reflection filled in
- Timesheet is current
- Carried-forward tasks have new due dates
- Tomorrow's priorities are clear
- User feels closure on the day
