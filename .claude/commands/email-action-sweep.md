# Email Action Sweep

Process inbox to identify action-required emails, create tasks, and file or archive emails. Interactive workflow using GTD principles.

## Usage
```
/email-action-sweep [batch_size]
```

Parameters:
- `batch_size` (optional): Number of emails to process (default: 30)

## Instructions

### Prerequisites
1. Get current date: `date`
2. Check inbox count: `notmuch count folder:INBOX`
3. Ensure notmuch is indexed: `notmuch new` (only if needed)
4. Load contacts database: Read `vault/03-Resources/contacts.yaml` or `docs/references/contacts.yaml`

### Step 1: Fetch Recent Emails
Search recent inbox emails:
```bash
notmuch search --limit=[batch_size] --sort=newest-first folder:INBOX
```

Display summary table showing:
- Date
- From (name/email)
- Subject (truncated to 60 chars)

### Step 2: Match Against Contacts

For each email, check sender against contacts database:

**Contact Match Found**:
- Use `organization` to suggest filing folder (`Vendors/[org]/`)
- Use `tags` to determine priority (client → high, vendor → medium)
- Use `notes` for context on relationship
- Use `role` to understand who you're dealing with

**No Contact Match**:
- Flag as potential new contact
- Suggest adding after processing if recurring sender

### Step 3: Identify Action Items
Analyse each email for action indicators:

**High Priority Indicators**:
- Subject contains: "action required", "urgent", "asap", "deadline"
- From known clients (check contacts with `client` tag)
- From contacts tagged `primary-contact` or `decision-maker`
- Subject contains: "invoice", "payment", "contract", "proposal"
- Meeting requests or calendar items

**Medium Priority**:
- Questions requiring response
- Follow-up requests
- Time-sensitive notifications

**Low Priority / Filing**:
- Newsletters
- Automated notifications
- Marketing emails
- System notifications

### Step 4: Present Action Items
Show categorized summary:
```
ACTION REQUIRED EMAILS (X found in batch of Y)
==============================================

HIGH PRIORITY (Due Today/This Week):
# | From                | Subject                           | Action Type
--|---------------------|-----------------------------------|-------------
1 | Client ABC          | Contract approval needed          | Review & Sign
2 | Vendor XYZ          | Invoice due                       | Pay/Process

MEDIUM PRIORITY (This Week):
3 | Partner Co          | Meeting availability              | Schedule
4 | Supplier            | Quote follow-up                   | Respond

CAN BE FILED:
5-15 | [Various newsletters and notifications]
```

### Step 5: Create Tasks for Action Items
For high and medium priority emails, suggest task creation:

```bash
# High priority contract
task add project:Work.Clients priority:H due:friday "Review and sign ABC contract" +client +contract

# Invoice processing
task add project:Finance.Bills priority:H due:today "Process XYZ invoice" +invoice
```

Ask user to confirm task creation or modify.

### Step 6: Email Filing Recommendations

**GTD Folder Structure**:
```
WORKFLOW FOLDERS (Active Processing):
├── Action/              # Needs my action (create task)
├── Waiting-For/         # Blocked on someone (create task +waiting)
└── Bacon/               # Interesting FYI (no task)

REFERENCE FOLDERS (Filed Material):
├── Vendors/[Name]/      # Vendor-specific reference
├── Filing/
│   ├── Receipts/        # Purchase records
│   ├── Contracts/       # Legal documents
│   └── Records/         # General records
└── Archive/             # Long-term storage
```

**Present filing suggestions**:
```
FILING RECOMMENDATIONS
======================
HIGH PRIORITY ACTIONS (create task → Action/):
1-3: Client requests, invoices, contracts

WAITING (create task +waiting → Waiting-For/):
4: Sent proposal, waiting for decision

INTERESTING FYI (no task → Bacon/):
5-8: Industry newsletters, announcements

VENDOR REFERENCE (no task → Vendors/):
9-12: Receipts → Vendors/VendorName/

ARCHIVE (no task → Archive/):
13-20: Old marketing emails
```

### Step 7: Execute Filing

Confirm before executing:
```
Process these emails? [Y/n/select]
```

**For ACTION emails**:
```bash
# 1. Create Taskwarrior task
task add project:[category] "[action description]" due:[date] priority:[H/M/L] +email

# 2. Annotate with email details
task [id] annotate "From: sender@example.com, Subject: [subject], Date: YYYY-MM-DD"

# 3. Move to Action/ folder
notmuch search --output=files id:[message-id] | \
  xargs -I {} mv {} ~/Maildir/Action/cur/

# 4. Tag appropriately
notmuch tag +action -inbox -- id:[message-id]
```

**For WAITING emails**:
```bash
# 1. Create task with +waiting tag
task add project:[category] "Waiting for [person] to [action]" due:[date] +waiting +email

# 2. Move to Waiting-For/ folder
notmuch search --output=files id:[message-id] | \
  xargs -I {} mv {} ~/Maildir/Waiting-For/cur/

# 3. Tag
notmuch tag +waiting -inbox -- id:[message-id]
```

**For REFERENCE emails**:
```bash
# Move to Vendors/ or Filing/ or Archive/
notmuch search --output=files id:[message-id] | \
  xargs -I {} mv {} ~/Maildir/Vendors/[VendorName]/cur/
notmuch tag +vendors/[vendorname] -inbox -- id:[message-id]
```

### Step 8: Provide Summary
```
EMAIL ACTION SWEEP COMPLETE
===========================
✓ Processed: 30 emails
✓ Tasks created: 5
✓ Emails filed: 20
✓ Remaining in inbox: 217 emails

URGENT ACTIONS (Due Today):
1. Process XYZ invoice - task #42
2. Review ABC contract - task #43

NEXT STEPS:
→ Run: task due:today list
→ Process urgent tasks first
→ Run another sweep: /email-action-sweep 30
```

## Examples

### Example 1: Quick Morning Sweep
```
/email-action-sweep 30
```
Process 30 most recent emails, identify action items, create tasks, file the rest.

### Example 2: Large Backlog
```
/email-action-sweep 50
```
Process 50 emails when inbox is overflowing, focus on urgent items first.

## Safety Guidelines

**Always Confirm Before:**
- Moving emails out of inbox
- Creating multiple tasks (>5 at once)
- Filing to new folders not yet created

**Never:**
- Delete emails without explicit confirmation
- File client emails without reviewing content
- Create tasks for spam/newsletters

## Task Completion Workflow

When you complete a task, move the email from Action/ to reference:

```bash
# 1. Complete the task
task [id] done

# 2. Move email to appropriate reference folder
notmuch search --output=files id:[message-id] | \
  xargs -I {} mv {} ~/Maildir/Vendors/[VendorName]/cur/
notmuch tag +vendors/[vendorname] -action -- id:[message-id]
```

**Rule**: Emails stay in Action/ while you work. When done, file to reference.

## Quick Reference

```bash
# Check inbox count
notmuch count folder:INBOX

# Search by sender
notmuch search folder:INBOX and from:client@example.com

# Search by subject
notmuch search folder:INBOX and subject:invoice

# File email to folder
notmuch search --output=files id:[message-id] | \
  xargs -I {} mv {} ~/Maildir/[folder]/cur/
```

## Related Commands
- `/start-of-day` - Morning review including inbox check
- `/meeting-process-last` - Process meeting transcripts
