#!/bin/bash
#
# Email Filing Script Template
# Files emails based on notmuch tags to appropriate folders
#
# This is a template showing the pattern. Customise the filing rules
# at the bottom for your own email categories.
#

set -euo pipefail

# Configuration - adjust for your setup
MAILDIR="${MAILDIR:-$HOME/Maildir}"
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run)
            DRY_RUN=true
            ;;
        -h|--help)
            echo "Usage: $0 [-d|--dry-run]"
            echo ""
            echo "Files emails based on notmuch tags to appropriate folders."
            echo ""
            echo "Options:"
            echo "  -d, --dry-run  Show what would be done without moving files"
            echo "  -h, --help     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

# Function to create Maildir folder if needed
ensure_folder() {
    local folder="$1"
    if [ ! -d "${MAILDIR}/${folder}/cur" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "Would create folder: $folder"
        else
            mkdir -p "${MAILDIR}/${folder}"/{cur,new,tmp}
            echo "Created folder: $folder"
        fi
    fi
}

# Function to move emails matching a notmuch query
move_emails() {
    local tag="$1"
    local folder="$2"

    # Ensure target folder exists
    ensure_folder "$folder"

    # Count matching emails
    local count
    count=$(notmuch count "tag:$tag and tag:inbox" 2>/dev/null || echo 0)
    if [ "$count" -eq 0 ]; then
        return
    fi

    echo "Moving $count emails tagged '$tag' to $folder..."

    # Get file paths and move them
    notmuch search --output=files "tag:$tag and tag:inbox" 2>/dev/null | while read -r file; do
        if [ -f "$file" ]; then
            basename=$(basename "$file")
            target="${MAILDIR}/${folder}/cur/${basename}"

            if [ "$DRY_RUN" = true ]; then
                echo "  Would move: $basename"
            else
                mv "$file" "$target" 2>/dev/null || echo "  Failed to move: $basename"
            fi
        fi
    done

    # Update tags
    if [ "$DRY_RUN" != true ]; then
        notmuch tag -inbox -- "tag:$tag and tag:inbox" 2>/dev/null || true
    fi
}

echo "Starting email filing..."
echo ""

# ============================================================
# FILING RULES - Customise these for your setup
# ============================================================

# Example: File monitoring alerts
# move_emails "monitoring" "Admin/Monitoring"

# Example: File social notifications
# move_emails "social" "Social/Notifications"

# Example: File newsletters
# move_emails "newsletter" "Reading/Newsletters"

# Example: File receipts
# move_emails "receipt" "Filing/Receipts"

# Example: File by sender domain
# notmuch search --output=files from:@example.com and tag:inbox | while read -r file; do
#     ...
# done

# ============================================================

# Update notmuch database
if [ "$DRY_RUN" != true ]; then
    echo ""
    echo "Updating notmuch database..."
    notmuch new 2>/dev/null || true
fi

echo ""
echo "Filing complete!"

# Show summary
echo ""
echo "Inbox status:"
echo "  Emails remaining: $(find "${MAILDIR}/INBOX/cur" -type f 2>/dev/null | wc -l)"
