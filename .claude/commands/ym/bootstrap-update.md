---
description: Safely update bootstrap files — merge skeleton changes without overwriting project-specific content in CLAUDE.md or customized agent/skill files.
---

# ym:bootstrap-update

**Purpose:** Update skeleton files interactively. Use this instead of `ym bootstrap` (update mode) when your project has custom content in `CLAUDE.md` (sections 5–7) or locally edited agent/skill files that must not be silently replaced.

## Inputs

- `CLAUDE.md` — current project file (sections 5–7 are project-specific; sections 1–4 and 8 come from the skeleton)
- `.claude/agents/*.md` — current agent definitions (may have local edits)
- `.claude/commands/ym/*.md` — current skill commands (may have local edits)
- Latest skeleton — cloned fresh from the ym toolbelt repo

## Process

1. **Clone the latest skeleton:**
   ```bash
   TEMP=$(mktemp -d)
   git clone --depth=1 --quiet https://github.com/YamiDaisuke/yamidaisuke-ai-toolbelt "$TEMP/repo"
   SRC="$TEMP/repo/.ym"
   ```

2. **Update scripts, templates, and workflow files** (never user-customized — overwrite silently):
   ```bash
   cp "$SRC/scripts/"*.sh .ym/scripts/ && chmod +x .ym/scripts/*.sh
   cp "$SRC/templates/SPEC.md" .ym/templates/
   cp "$SRC/STACKED_PR_WORKFLOW.md" .ym/
   cp "$SRC/templates/PULL_REQUEST_TEMPLATE.md" .github/
   mkdir -p .github/workflows
   cp "$TEMP/repo/.github/workflows/restack.yml" .github/workflows/
   ```

3. **Review CLAUDE.md:**
   - Read the current `CLAUDE.md` and `$SRC/CLAUDE.md`
   - Split each into skeleton-controlled sections (1–4, 8) and project-specific sections (5–7)
   - Diff the skeleton sections only. If they are identical, skip.
   - If they differ:
     - Show the diff clearly (what changed in the skeleton)
     - Check whether the changed text references or contradicts anything in sections 5–7 (e.g., a renamed convention, a removed role reference, a guideline that conflicts with a project rule) — flag any such conflict explicitly before asking
     - Ask: **"Skeleton section N changed. Adopt this update? (yes / no)"**
   - Apply only approved changes. Never read, modify, or rewrite sections 5–7.

4. **Review each agent file** in `.claude/agents/`:
   - For each `$SRC/agents/<name>.md`:
     - Diff against the current `.claude/agents/<name>.md`
     - If identical: skip silently
     - If different: show the unified diff and ask: **"Agent `<name>.md` has incoming changes. Replace with skeleton version / keep your version / skip?"**
   - For agent files that exist in the skeleton but not in the project: copy without asking (these are new additions)

5. **Review each skill command** in `.claude/commands/ym/`:
   - Same process as agent files above

6. **Run migrations:**
   ```bash
   for script in .ym/scripts/migrate-*.sh; do
     [ -f "$script" ] && bash "$script"
   done
   ```

7. **Summarize** every decision: which files were updated, kept, and skipped. Then suggest:
   ```
   git diff .claude/ CLAUDE.md
   ```

## Output

- `.ym/` scripts, templates, and `STACKED_PR_WORKFLOW.md`: always updated to latest skeleton
- `.github/workflows/restack.yml`: always updated to latest skeleton
- `CLAUDE.md` sections 1–4 and 8: updated only with explicit per-section approval; sections 5–7 untouched
- `.claude/agents/` and `.claude/commands/ym/`: updated per user decision for each changed file; new files added automatically
- Console summary of every file and the decision applied to it
