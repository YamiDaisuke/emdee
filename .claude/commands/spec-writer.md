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
3. Present the task list to the User for confirmation before writing anything.
4. For each confirmed task, write:
   - A short description
   - Explicit, testable acceptance criteria
   - Initial status: `todo`
5. Write the spec file to `docs/specs/<feature-slug>.md` using the SPEC template.
6. Create a ticket in the ticket tracking system for each task. Update the Ticket Tracker table in the spec with the resulting IDs.

## Output

`docs/specs/<feature-slug>.md` populated from `.bootstrap/templates/SPEC.md`.
All tasks have status `todo`. Spec-level status is `draft`. Ticket Tracker table is fully populated.
