# Claude Refactor Command

Analyse the current project's CLAUDE.md file and refactor it to follow best practices:
- Move detailed information into appropriate docs/ subdirectories
- Use `.claude/rules/` directory for path-specific or modular rules
- Keep CLAUDE.md focused on actionable guidance and pointers
- Ensure proper information architecture and findability

## Analysis Instructions

Analyse the current project's CLAUDE.md file and perform the following refactoring:

### 1. Content Classification

Review the CLAUDE.md and classify content using the **"Keep vs Move"** principle:

**Keep in CLAUDE.md** (Actionable guidance):
- Repository etiquette (branch naming, merge vs rebase)
- Developer environment setup commands
- Project-specific commands and workflows
- Quick reference for frequent tasks
- Code style guidelines (concise)
- Testing procedures (how to run)
- Build/deployment commands

**Move to docs/** (Detailed information):
- Detailed explanations and background
- Architecture decisions and constraints
- Comprehensive troubleshooting guides
- Standards documentation
- API specifications
- System design descriptions

### 2. Consider the Rules Directory

**Use `.claude/rules/` for modular, path-specific instructions:**

The rules directory is ideal for:
- **Path-specific rules**: Rules that apply only to certain file types or directories
- **Modular organisation**: Breaking up large CLAUDE.md into focused topic files
- **Team-shared standards**: Rules that should apply consistently

**Rules file format with path scoping:**
```markdown
---
paths: src/api/**/*.ts
---

# API Development Rules
- All endpoints must include input validation
- Use standard error response format
```

**Rules without `paths:` frontmatter** apply globally (like CLAUDE.md content).

**When to use rules/ vs docs/:**
- `rules/` → Active instructions Claude should follow (coding standards, workflows)
- `docs/` → Reference documentation (architecture explanations, troubleshooting guides)

### 3. Analyse Existing Documentation Structure

**Respect the current project's documentation organisation:**

First, analyse the existing documentation structure:
- Check if `docs/`, `documentation/`, `wiki/`, or other doc directories exist
- Check if `.claude/rules/` already exists
- Identify current organisation patterns (by feature, by type, etc.)
- Look for existing standards files, ADRs, or style guides

**Work with what exists:**
- Use existing directory structure where logical
- Respect established naming conventions
- Leverage current organisation patterns
- Only suggest new directories if clearly beneficial

### 4. Streamline CLAUDE.md

**Primary goal: Keep CLAUDE.md concise and actionable (under 500 lines)**

Transform CLAUDE.md to focus on:
- **Immediate developer needs**: Commands, workflows, quick references
- **Context for Claude Code**: Essential project-specific guidance
- **Navigation pointers**: Clear links to detailed documentation

**CLAUDE.md should become a "launch pad":**
```markdown
# Project Name

## Quick Start
- Setup: `make install`
- Run tests: `npm test`
- Build: `npm run build`

## Development Workflow
- Branch naming: `feature/description`
- See detailed process: [Development Guide](docs/development.md)

## Code Style
- Use TypeScript strict mode
- Detailed guidelines: [Coding Standards](docs/standards/typescript.md)

## Architecture
- System overview: [Architecture](docs/architecture/overview.md)
- Key decisions: [ADRs](docs/adr/)
```

### 5. Maintain Information Integrity

**Ensure nothing is lost during refactoring:**
- Verify all information is preserved and findable
- Create clear navigation between CLAUDE.md and detailed docs
- Test that workflows still work after refactoring
- Maintain any existing cross-references and links

## Decision Guide: docs/ vs rules/

| Content Type | Location | Reason |
|-------------|----------|--------|
| Coding standards to enforce | `.claude/rules/` | Active instructions |
| Architecture explanations | `docs/` | Reference material |
| Workflow commands | `CLAUDE.md` | Quick reference |
| Troubleshooting guides | `docs/` | Detailed reference |
| Path-specific patterns | `.claude/rules/` with `paths:` | Scoped enforcement |
| API documentation | `docs/` | Reference material |

Proceed with analysing and refactoring the current project's CLAUDE.md file.

$ARGUMENTS
