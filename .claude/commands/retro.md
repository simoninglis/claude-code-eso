# Retrospective: Update CLAUDE.md with Lessons Learned

## Overview
Analyse the recent work session and update the relevant CLAUDE.md files with discoveries, patterns, or lessons learned that would help future Claude instances work more effectively with this codebase.

## Analysis Scope
Review for:
1. **New Tools/Commands**: Tools or commands discovered that aren't documented
2. **Gotchas/Pitfalls**: Issues encountered and their solutions
3. **Patterns**: Successful approaches or workflows used
4. **Integration Points**: How different parts of the system interact
5. **Best Practices**: What worked well and should be repeated
6. **Reusable Components**: Session-specific solutions that could become generic utilities
7. **Script Opportunities**: Repetitive workflows that could be automated
8. **Cross-Project Patterns**: Solutions that might benefit other repositories

## CLAUDE.md Updates
Check and potentially update:
- Project root CLAUDE.md (project-wide patterns)
- Subdirectory CLAUDE.md files (module-specific patterns)
- **Note**: Do NOT update the global ~/.claude/CLAUDE.md — it should only contain universal preferences

## Documentation Approach
For each finding:
1. Determine the appropriate CLAUDE.md file to update
2. Check if the information already exists
3. Add new sections or update existing ones
4. Reference external documentation where available
5. Keep updates concise and actionable
6. Focus on "how Claude should work" rather than general project documentation

## Tool Generalisation
For reusable components identified:
1. Assess generalisation potential
2. Suggest naming patterns (noun-verb for tool suites, verb-noun for standalone)
3. Identify target locations (scripts/, bin/, or project-specific)
4. Document implementation notes for future development
5. Cross-reference existing tools to avoid duplication

## Session Review
Analysing what was done in this session and identifying key learnings...

$ARGUMENTS
