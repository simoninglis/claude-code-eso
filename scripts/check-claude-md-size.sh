#!/bin/bash

# CLAUDE.md Size Monitor
# Checks token usage and alerts when limits exceeded

set -euo pipefail

# Color codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Token limits (approximate: 1 word ≈ 1.3 tokens)
GLOBAL_LIMIT=200
PROJECT_LIMIT=200
MODULE_LIMIT=150

# Function to estimate tokens from word count
estimate_tokens() {
    local words=$1
    echo $(( words * 13 / 10 ))  # 1.3 tokens per word
}

# Function to check file size
check_file() {
    local file=$1
    local limit=$2
    local type=$3

    if [[ ! -f "$file" ]]; then
        echo -e "${YELLOW}⚠️  $type CLAUDE.md not found: $file${NC}"
        return
    fi

    local words=$(wc -w < "$file")
    local tokens=$(estimate_tokens "$words")

    if [[ $words -gt $limit ]]; then
        echo -e "${RED}🔴 $type CLAUDE.md EXCEEDS LIMIT${NC}"
        echo "   File: $file"
        echo "   Words: $words (limit: $limit)"
        echo "   Est. tokens: $tokens"
        echo ""
    else
        echo -e "${GREEN}✅ $type CLAUDE.md within limits${NC}"
        echo "   Words: $words/$limit"
    fi
}

echo "=== CLAUDE.md Size Monitor ==="
echo "Date: $(date)"
echo ""

# Check global CLAUDE.md
check_file "$HOME/.claude/CLAUDE.md" $GLOBAL_LIMIT "Global"

# Check project CLAUDE.md
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
check_file "$PROJECT_ROOT/CLAUDE.md" $PROJECT_LIMIT "Project"

# Check for subdirectory CLAUDE.md files
echo ""
echo "=== Checking for module CLAUDE.md files ==="
find "$PROJECT_ROOT" -name "CLAUDE.md" -not -path "$PROJECT_ROOT/CLAUDE.md" | while read -r module_file; do
    rel_path=${module_file#$PROJECT_ROOT/}
    check_file "$module_file" $MODULE_LIMIT "Module ($rel_path)"
done

# Summary
echo ""
echo "=== Summary ==="
total_words=0
for file in "$HOME/.claude/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md" $(find "$PROJECT_ROOT" -name "CLAUDE.md" -not -path "$PROJECT_ROOT/CLAUDE.md"); do
    if [[ -f "$file" ]]; then
        words=$(wc -w < "$file")
        total_words=$((total_words + words))
    fi
done

total_tokens=$(estimate_tokens "$total_words")
echo "Total words across all CLAUDE.md files: $total_words"
echo "Estimated total tokens: $total_tokens"

if [[ $total_tokens -gt 600 ]]; then
    echo -e "${RED}⚠️  CRITICAL: Total token usage exceeds recommended limit of 600${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Total token usage within acceptable range${NC}"
fi
