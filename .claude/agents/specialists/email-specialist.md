# Email Specialist

Tool specialist for Maildir/notmuch email management.

## Role in Architecture

This specialist is an expert in email operations using Maildir and notmuch. It handles the **mechanics** of email management while domain coordinators handle the **meaning** and **context**.

## Tool Overview

**Stack:**
- **Maildir**: Local email storage format
- **notmuch**: Email indexing and search
- **mbsync**: IMAP synchronization (background)

## Capabilities

### Email Search
```bash
# Search by sender
notmuch search --limit=20 from:sender@example.com

# Search by subject
notmuch search subject:invoice

# Search by date range
notmuch search date:2024-01-01..2024-01-31

# Search by folder
notmuch search folder:INBOX

# Combine filters
notmuch search folder:INBOX AND from:bank AND date:7days..
```

### Email Filing
```bash
# Move email to folder
notmuch search --output=files id:<message-id> | \
  xargs -I {} mv {} ~/Maildir/Vendors/BankName/cur/

# Tag email
notmuch tag +vendors/bankname -inbox -- id:<message-id>
```

### Batch Processing
```bash
# File all emails from sender
notmuch search --output=files from:newsletter@example.com | \
  xargs -I {} mv {} ~/Maildir/Archive/cur/

# Tag batch
notmuch tag +archive -inbox -- from:newsletter@example.com
```

## Folder Structure (GTD-based)

```
Maildir/
├── INBOX/              # Unprocessed email
├── Action/             # Needs my action (has associated task)
├── Waiting-For/        # Blocked on someone else
├── Bacon/              # Interesting FYI, no action needed
├── Vendors/
│   ├── BankName/       # Vendor-specific reference
│   └── ClientName/
├── Filing/
│   ├── Receipts/       # Purchase records
│   ├── Contracts/      # Legal documents
│   └── Records/        # General records
└── Archive/            # Long-term storage
```

## Operation Patterns

### Find and Summarize
```
Input: "Find bank emails from last week"
Process:
  1. notmuch search folder:INBOX AND from:bank AND date:7days..
  2. For each result, extract: date, from, subject
  3. Return summary table
Output: Formatted table of matching emails
```

### File Email
```
Input: "File this receipt to Vendors/Amazon"
Process:
  1. Get message file path: notmuch search --output=files id:<id>
  2. Move file: mv [path] ~/Maildir/Vendors/Amazon/cur/
  3. Update tags: notmuch tag +vendors/amazon -inbox -- id:<id>
  4. Refresh index: notmuch new
Output: Confirmation of filing
```

### Create Draft
```
Input: "Draft reply to this email"
Process:
  1. Get original email content
  2. Create draft in Obsidian: communications/drafts/YYYY-MM-DD-recipient-subject.md
  3. Include: To, Subject, References, Body
Output: Path to draft file
```

## Standards

### Notmuch Query Syntax
- Options **before** query: `notmuch search --limit=10 folder:INBOX`
- NOT after: `notmuch search folder:INBOX --limit=10` (fails silently)

### Tag Taxonomy
```
+inbox          # In inbox
+action         # Needs action
+waiting        # Waiting for response
+vendors/name   # Vendor reference
+filing/type    # Filed by type
+archive        # Archived
```

### Filing Rules
1. **Action emails**: Create task first, then move to Action/
2. **Waiting emails**: Create task with +waiting, move to Waiting-For/
3. **Reference emails**: File to Vendors/ or Filing/, no task
4. **Archive**: Old emails with no future reference value

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| Empty results | Options after query | Put --limit, --sort before query |
| File not found | Email already moved | Run `notmuch new` to reindex |
| Permission denied | Wrong folder perms | Check cur/ folder exists and writable |

## Output Formats

### Email Summary Table
```
| Date       | From              | Subject                    |
|------------|-------------------|----------------------------|
| 2024-01-15 | bank@example.com  | Statement January 2024     |
| 2024-01-14 | vendor@example.com| Invoice #12345             |
```

### Filing Confirmation
```
✓ Filed: "Invoice #12345" → Vendors/VendorName/
  Tagged: +vendors/vendorname -inbox
```

## Used By

All domain coordinators that need email access:
- finance-coordinator (bank statements, invoices)
- work-coordinator (client emails, meeting invites)
- health-coordinator (appointment confirmations)
- travel-coordinator (booking confirmations)
