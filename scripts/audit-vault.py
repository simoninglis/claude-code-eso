#!/usr/bin/env python3
"""
Obsidian Vault Compliance Auditor (Simplified)

Validates Obsidian vault against PARA structure:
- Folder structure compliance
- File naming conventions
- Basic frontmatter validation

Usage:
    python scripts/audit-vault.py [--vault PATH] [--level error|warning|info]

Examples:
    python scripts/audit-vault.py                          # Run audit
    python scripts/audit-vault.py --level error            # Show only errors
    python scripts/audit-vault.py --vault ~/my-vault       # Custom vault path
"""

import argparse
import os
import re
import sys
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path
from typing import List, Optional


@dataclass
class Violation:
    """Represents a compliance violation"""
    level: str  # error, warning, info
    category: str  # structure, naming, frontmatter, filing
    file_path: str
    message: str


class VaultAuditor:
    """Audits Obsidian vault for PARA compliance"""

    # PARA folder structure
    REQUIRED_FOLDERS = [
        "00-Daily-Notes",
        "01-Projects",
        "02-Areas",
        "03-Resources",
        "04-Archives",
        "09-Templates"
    ]

    def __init__(self, vault_path: str):
        self.vault_path = Path(vault_path)
        self.violations: List[Violation] = []
        self.total_files = 0

    def audit(self):
        """Run complete vault audit"""
        print(f"Auditing vault: {self.vault_path}")

        # Count markdown files
        self.total_files = len(list(self.vault_path.rglob("*.md")))
        print(f"Found {self.total_files} markdown files")

        # Run audit checks
        self.check_structure()
        self.check_naming_conventions()
        self.check_frontmatter()
        self.check_filing()

        return self.violations

    def check_structure(self):
        """Check PARA folder structure compliance"""
        print("\n[1/4] Checking folder structure...")

        actual_folders = [f.name for f in self.vault_path.iterdir()
                         if f.is_dir() and not f.name.startswith('.')]

        # Check for missing folders
        for required in self.REQUIRED_FOLDERS:
            if required not in actual_folders:
                self.violations.append(Violation(
                    level="warning",
                    category="structure",
                    file_path=str(self.vault_path),
                    message=f"Missing PARA folder '{required}'"
                ))

        # Check for loose files at root
        for item in self.vault_path.iterdir():
            if item.is_file() and item.suffix == ".md":
                self.violations.append(Violation(
                    level="error",
                    category="structure",
                    file_path=str(item.name),
                    message="Loose file at vault root (should be in a PARA folder)"
                ))

    def check_naming_conventions(self):
        """Check file naming conventions"""
        print("[2/4] Checking naming conventions...")

        # Check daily notes: YYYY-MM-DD.md
        daily_path = self.vault_path / "00-Daily-Notes"
        if daily_path.exists():
            log_pattern = re.compile(r'^\d{4}-\d{2}-\d{2}\.md$')
            for log_file in daily_path.glob("*.md"):
                if not log_pattern.match(log_file.name):
                    self.violations.append(Violation(
                        level="warning",
                        category="naming",
                        file_path=f"00-Daily-Notes/{log_file.name}",
                        message="Daily note doesn't follow 'YYYY-MM-DD.md' format"
                    ))

    def check_frontmatter(self):
        """Check basic frontmatter presence"""
        print("[3/4] Checking frontmatter...")

        # Folders where frontmatter is expected
        frontmatter_paths = ["01-Projects", "02-Areas"]

        for folder_name in frontmatter_paths:
            folder_path = self.vault_path / folder_name
            if not folder_path.exists():
                continue

            for md_file in folder_path.rglob("*.md"):
                if not self._has_frontmatter(md_file):
                    rel_path = md_file.relative_to(self.vault_path)
                    self.violations.append(Violation(
                        level="info",
                        category="frontmatter",
                        file_path=str(rel_path),
                        message="Missing frontmatter (recommended in Projects/Areas)"
                    ))

    def check_filing(self):
        """Check filing compliance"""
        print("[4/4] Checking filing compliance...")

        # Check for old daily notes (>30 days in root of daily notes)
        daily_path = self.vault_path / "00-Daily-Notes"
        if daily_path.exists():
            thirty_days_ago = datetime.now() - timedelta(days=30)

            for note_file in daily_path.glob("*.md"):
                match = re.match(r'^(\d{4}-\d{2}-\d{2})\.md$', note_file.name)
                if match:
                    try:
                        note_date = datetime.strptime(match.group(1), '%Y-%m-%d')
                        if note_date < thirty_days_ago:
                            self.violations.append(Violation(
                                level="info",
                                category="filing",
                                file_path=f"00-Daily-Notes/{note_file.name}",
                                message="Daily note older than 30 days (consider archiving by month)"
                            ))
                    except ValueError:
                        pass

    def _has_frontmatter(self, file_path: Path) -> bool:
        """Check if file has YAML frontmatter"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                first_line = f.readline().strip()
                return first_line == '---'
        except (PermissionError, UnicodeDecodeError):
            return True  # Assume OK if can't read

    def print_report(self, min_level: str = "warning"):
        """Print human-readable audit report"""
        print("\n" + "="*60)
        print("OBSIDIAN VAULT AUDIT REPORT")
        print(f"Vault: {self.vault_path}")
        print(f"Total files: {self.total_files}")
        print("="*60)

        # Determine which levels to show
        level_order = {"error": 0, "warning": 1, "info": 2}
        min_order = level_order.get(min_level, 1)

        # Count by level
        counts = {"error": 0, "warning": 0, "info": 0}
        for v in self.violations:
            counts[v.level] += 1

        # Print violations by level
        for level in ["error", "warning", "info"]:
            if level_order[level] > min_order:
                continue

            violations = [v for v in self.violations if v.level == level]
            if not violations:
                continue

            print(f"\n{level.upper()}: {len(violations)} violations")
            print("-" * 60)

            for v in violations[:10]:
                print(f"  [{v.category}] {v.file_path}")
                print(f"    {v.message}")

            if len(violations) > 10:
                print(f"  ... and {len(violations) - 10} more")

        # Summary
        print("\n" + "="*60)
        print("SUMMARY")
        print(f"  Errors: {counts['error']}")
        print(f"  Warnings: {counts['warning']}")
        print(f"  Info: {counts['info']}")
        print("="*60)


def main():
    parser = argparse.ArgumentParser(
        description="Audit Obsidian vault for PARA compliance"
    )

    parser.add_argument(
        "--vault",
        default=os.environ.get("OBSIDIAN_VAULT_PATH", "./vault"),
        help="Path to Obsidian vault"
    )
    parser.add_argument(
        "--level",
        choices=["error", "warning", "info"],
        default="warning",
        help="Minimum violation level to display"
    )

    args = parser.parse_args()

    # Create auditor and run
    auditor = VaultAuditor(vault_path=args.vault)
    auditor.audit()
    auditor.print_report(min_level=args.level)

    # Exit code based on violations
    errors = len([v for v in auditor.violations if v.level == "error"])
    sys.exit(1 if errors > 0 else 0)


if __name__ == "__main__":
    main()
