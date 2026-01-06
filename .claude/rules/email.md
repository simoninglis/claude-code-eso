# Email Rules

Rules for the **email-specialist** agent. These rules define how to use notmuch and Maildir.

**Coordinators**: Delegate email operations to email-specialist. Do not call notmuch directly.

## Filing Strategy

Decision tree:
1. **Action required?** → `Action/` + create task
2. **Waiting for response?** → `Waiting-For/` + create task +waiting
3. **Interesting FYI?** → `Bacon/` (no task)
4. **Vendor email?** → `Vendors/[CompanyName]/`
5. **Records/receipts?** → `Filing/[Type]/`
6. **Old/no future value?** → `Archive/`

## Folder Naming

Maildir vendor folders use **PascalCase without spaces**:
- Correct: `Vendors/AcmeWidgets`
- Wrong: `Vendors/Acme Widgets`

## Common Queries

```bash
# Search by sender
notmuch search from:sender@company.com date:this-month

# Search by folder
notmuch search folder:INBOX

# Count before filing
notmuch count 'from:@company.com and folder:INBOX'

# Important: Options BEFORE query
notmuch search --limit=20 --sort=newest-first folder:INBOX
# NOT: notmuch search folder:INBOX --limit=20 (fails silently)
```

## Tag Operations

```bash
# Add tag
notmuch tag +action -inbox -- id:<message-id>

# Tag batch by sender
notmuch tag +vendors/acmewidgets -inbox -- from:@acmewidgets.com
```

**Note**: `notmuch tag` updates metadata only — does NOT move files!

## Physical File Move (Required!)

**Critical**: Must physically move files for Maildir folder changes:

```bash
# Get file path
notmuch search --output=files id:<message-id>

# Move to destination
mv /path/to/file ~/Maildir/Vendors/AcmeWidgets/cur/

# Reindex after moves
notmuch new
```

For mbsync compatibility, strip UIDs when moving between folders:

```bash
# Strip UID and move
for f in $(notmuch search --output=files 'folder:INBOX and from:company.com'); do
  basename=$(basename "$f" | sed 's/,U=[0-9]*//g')
  mv "$f" ~/Maildir/Vendors/CompanyName/new/"$basename"
done
notmuch new
```

**Why strip UIDs?** Files moved between folders retain embedded UIDs that are invalid for the destination folder.

**Why new/ not cur/?** Files in `new/` trigger upload; mbsync assigns fresh UIDs and moves to `cur/`.

## GTD Folder Structure

```
Maildir/
├── INBOX/              # Unprocessed
├── Action/             # Needs my action (has task)
├── Waiting-For/        # Blocked on someone (has task +waiting)
├── Bacon/              # Interesting FYI
├── Vendors/
│   └── [CompanyName]/  # Vendor-specific reference
├── Filing/
│   ├── Receipts/
│   ├── Contracts/
│   └── Records/
└── Archive/            # Long-term storage
```

## Tag Taxonomy

```
+inbox          # In inbox (default)
+unread         # Unread
+action         # Needs action
+waiting        # Waiting for response
+vendors/name   # Vendor reference
+filing/type    # Filing category
+archive        # Archived
+deleted        # Marked for deletion
```
