# Task Management Rules

Rules for the **task-specialist** agent. These rules define how to use Taskwarrior.

**Coordinators**: Delegate task operations to task-specialist. Do not call `task` directly.

## Project Structure

Organize tasks by life domain:

```
Work
├── Work.ClientA
├── Work.ClientB
└── Work.Admin

Finance
├── Finance.Bills
├── Finance.Budget
└── Finance.Tax

Home
├── Home.Maintenance
├── Home.Cleaning
└── Home.Projects

Personal
├── Personal.Health
├── Personal.Learning
└── Personal.Growth
```

## Creating Tasks

```bash
# Basic task
task add "Review quarterly report"

# With project and due date
task add project:Work.ClientA due:friday "Send proposal"

# With priority
task add project:Finance.Bills priority:H due:monday "Pay electricity"

# With tags
task add project:Home.Maintenance "Fix leaky tap" +home +weekend

# From email (annotate for reference)
task add project:Work.ClientA "Respond to proposal request" +email
task [id] annotate "From: client@example.com, Subject: Proposal, Date: 2024-01-15"
```

## Task vs Calendar vs Habits

3-Question Framework:
1. **Specific time?** → Calendar (khal)
2. **Recurring behavior/streak?** → Habit tracker
3. **Clear "done" state?** → Taskwarrior

Quick rules:
- Meeting at 2pm → Calendar
- "Exercise daily" → Habit tracker
- "Write report" → Taskwarrior

## Priority Levels

| Priority | Meaning | Use When |
|----------|---------|----------|
| H | Urgent, time-sensitive | Due today/tomorrow, blocking others |
| M | Important, not urgent | Due this week |
| L | Nice to have | No hard deadline |
| (none) | Normal | Standard tasks |

## Common Queries

```bash
# Today's tasks
task due:today list

# High priority
task priority:H list

# By project
task project:Work list

# Overdue
task +OVERDUE list

# This week
task due.before:eow list

# Combined filters
task project:Finance due.before:eow priority:H list
```

## Task Operations

```bash
# Complete task
task [id] done

# Modify due date
task [id] modify due:tomorrow

# Change priority
task [id] modify priority:H

# Add annotation
task [id] annotate "Waiting for client response"

# Add tag
task [id] modify +waiting

# Delete task
task [id] delete
```

## Tag Taxonomy

```
+email      # Task from email
+meeting    # Task from meeting
+waiting    # Blocked on someone
+urgent     # Needs immediate attention
+client     # Client-related
+recurring  # Repeating task
+weekend    # Weekend task
```

## Due Date Shortcuts

```
due:today       # Today
due:tomorrow    # Tomorrow
due:monday      # Next Monday
due:eow         # End of week (Friday)
due:eom         # End of month
due:2024-01-15  # Specific date
```
