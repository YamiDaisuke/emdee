---
description: Write a spec file for a feature — breaks confirmed requirements into atomic tasks with acceptance criteria and writes docs/specs/<feature-slug>.md.
---

# spec-writer

**Used by:** Scrum Master

**Input:** Confirmed `docs/REQUIREMENTS.md`, confirmed `docs/ARCHITECTURE.md`, and a feature to spec out.

## Process

1. Identify the feature scope from `docs/REQUIREMENTS.md`.
2. Draft a task list. Tasks must be:
   - Atomic: completable in one sitting, reviewable independently.
   - Concrete: each has a clear implementation target.
   - Sized to 1-2 hours of human dev work. Prefer more short tasks over fewer large ones.
   - Titled with a semantic prefix: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `style`, or `ci`.
     Format: `TASK-01: feat: Add user auth endpoint`. The prefix drives the branch name and commit message.
3. Present the task list to the User for confirmation before writing anything.
4. For each confirmed task, write:
   - A short description
   - Explicit, testable acceptance criteria
   - Initial status: `todo`
5. Write the spec file to `docs/specs/<feature-slug>.md` using the SPEC template.
6. For each confirmed task, run `tasklin add '<task-title>'`. The output is `#<hex-id> <title>` — record the hex ID in the Ticket Tracker table for that task.

## Output

`docs/specs/<feature-slug>.md` populated from `.ym/templates/SPEC.md`.
All tasks are at status `To Do` in tasklin. Spec-level status is `draft`. Ticket Tracker table is fully populated with tasklin IDs.
