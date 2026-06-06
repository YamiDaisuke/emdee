---
description: Execute or assign an atomic spec task — Developer implements and iterates through review; Scrum Master finds and assigns the next todo task one at a time.
---

# task-runner

**Used by:** Developer, Scrum Master

**Input:** A spec file with at least one task at status `To Do` in tasklin.

## Git Workflow

Branch naming, PR targeting, and stacking rules are defined in `.ym/STACKED_PR_WORKFLOW.md` and take precedence over any example in this file.

## Process (Developer — executing a task)

1. Create the branch as instructed by the Scrum Master — see `.ym/STACKED_PR_WORKFLOW.md` for naming and stacking rules.
2. Read the full spec file end to end.
3. Read `docs/ARCHITECTURE.md` for conventions.
4. Run `tasklin move <id> "In Progress"` (look up the tasklin ID in the spec's Ticket Tracker table).
5. Implement only what the task's acceptance criteria require.
6. Ask the Code Reviewer for approval.
   - If approved → run `tasklin move <id> "Done"`, commit using semantic prefix, open a PR, notify Scrum Master.
   - If feedback → address each comment, then ask for approval again. Repeat until approved.

## Process (Scrum Master — assigning a task)

1. Find the next task with status `To Do` by running `next-task.sh` or checking `tasklin`.
2. Read `.ym/STACKED_PR_WORKFLOW.md`; derive (a) the exact branch name to create and (b) the exact PR target branch (previous task branch for task/NN > 01, or `main` for task/01).
3. Assign it to the Developer: provide the spec file path, task ID, branch name, and PR target branch.
4. Do not assign another task until the current one reaches `done`.

## Output

- Developer: committed implementation on a named branch + PR opened + task marked `Done` in tasklin.
- Scrum Master: Developer notified with spec path and task ID.
