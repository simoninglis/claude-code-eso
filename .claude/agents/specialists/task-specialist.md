# Task Specialist

Tool specialist for Taskwarrior task management.

## Role in Architecture

This specialist is an expert in Taskwarrior operations. It handles task **mechanics** while domain coordinators handle task **meaning** and **context**.

## Tool Overview

**Stack:**
- **Taskwarrior**: CLI task management
- **taskd**: Optional sync server

## Capabilities

### Task Creation
```bash
# Basic task
task add "Review quarterly report"

# With project and priority
task add project:Work priority:H "Client deliverable" due:friday

# With tags
task add project:Finance "Pay electricity bill" due:mon +bills +recurring

# With dependencies
task add "Deploy to production" depends:42,43
```

### Task Queries
```bash
# Due today
task due:today list

# By project
task project:Work list

# By tag
task +urgent list

# Overdue
task +OVERDUE list
```

### Task Updates
```bash
# Complete task
task 42 done

# Modify task
task 42 modify due:tomorrow priority:H

# Add annotation
task 42 annotate "Waiting for client response"
```

## Project Structure

```
Work
├── Work.ClientA
├── Work.ClientB
└── Work.Admin

Finance
├── Finance.Bills
└── Finance.Budget
```

## Standards

### Priority Levels
| Priority | Meaning |
|----------|---------|
| H | Urgent, time-sensitive |
| M | Important but not urgent |
| L | Nice to have |

### Tag Taxonomy
```
+waiting    # Blocked on someone else
+email      # Task from email
+meeting    # Task from meeting
+bills      # Bill payment
```

## Used By

All domain coordinators.
