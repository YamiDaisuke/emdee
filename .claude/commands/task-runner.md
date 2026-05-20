---
description: Execute or assign an atomic spec task — Developer implements and iterates through review; Scrum Master finds and assigns the next todo task one at a time.
---

# task-runner

**Used by:** Developer, Scrum Master

**Input:** A spec file with at least one task at status `todo`.

## Process (Developer — executing a task)

1. Read the full spec file end to end.
2. Read `docs/ARCHITECTURE.md` for conventions.
3. Update the task status to `in-progress` in the spec file.
4. Implement only what the task's acceptance criteria require.
5. Ask the Code Reviewer for approval.
   - If approved → mark task `done`, commit, notify Scrum Master.
   - If feedback → address each comment, then ask for approval again. Repeat until approved.

## Process (Scrum Master — assigning a task)

1. Find the next task with status `todo` in the active spec.
2. Assign it to the Developer: provide the spec file path and task ID.
3. Do not assign another task until the current one reaches `done`.

## Output

- Developer: committed implementation + spec file with task status `done`.
- Scrum Master: Developer notified with spec path and task ID.
