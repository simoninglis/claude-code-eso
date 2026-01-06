#!/bin/bash
# Copy markdown file to Windows clipboard with formatting preserved
# Usage: ./scripts/md2clip.sh <markdown-file>

set -e

# Check arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <markdown-file>"
    echo "Example: $0 obsidian-vault/path/to/email_draft.md"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found"
    exit 1
fi

# Check dependencies
if ! command -v pandoc &> /dev/null; then
    echo "Error: pandoc is not installed"
    exit 1
fi

if ! command -v pwsh &> /dev/null; then
    echo "Error: PowerShell (pwsh) is not installed"
    exit 1
fi

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Convert markdown to RTF and copy to clipboard
echo "Converting $1 to clipboard..."
pandoc "$1" -t rtf | pwsh -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT_DIR/md2clip.ps1"

if [ $? -eq 0 ]; then
    echo "✓ Successfully copied to clipboard with formatting"
    echo "  You can now paste into Outlook with Ctrl+V"
else
    echo "✗ Failed to copy to clipboard"
    exit 1
fi
