# Stacked PR Workflow

### Context

This repo uses spec-driven development with stacked PRs. A human provides
specs and assigns tasks. Agents implement tasks sequentially, but do not wait
for PR review before starting the next task. Tasks are dependent on one another
and must be implemented in order. No agent ever pushes directly to main.

### Branch naming convention

Task branches follow the pattern: `spec-slug-task/NN-slug` where NN is a zero-padded number, and spec-slug matches the slug of an existing spec (e.g. `login-flow-task/01-data-model`, `login-flow-task/02-api-layer`).

### PR title format

```
<prefix>(<spec-slug>): <imperative summary> [task/NN]
```

- `prefix` — semantic type matching the task title: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `style`, `ci`
- `spec-slug` — slug of the spec file (e.g. `login-flow`)
- `imperative summary` — what the task does, in present tense (≤ 60 chars)
- `[task/NN]` — zero-padded task number

**Examples:**
```
feat(login-flow): add user data model [task/01]
feat(login-flow): implement REST API layer [task/02]
fix(billing): correct proration rounding [task/03]
```

PR titles must be unique within a spec. Do not reuse the same summary for two tasks.

### PR body

Use `.ym/templates/PULL_REQUEST_TEMPLATE.md`. Fill in every section — leave no placeholder comment
in the final body. The **Stack** section must specify the exact target branch and, for mid-stack
PRs, link the upstream PR by number.

### What agents must never do

- Push directly to main
- Open a PR targeting main unless it is task/01 or the previous branch
  was already merged
- Implement scope from a future task spec
- Merge their own PR
- Rebase or force-push a branch that is not their own current task branch

-----

### Agent responsibilities

#### Architect

- Ensure task decomposition produces sequentially dependent tasks: each task
  should build cleanly on the previous one and be independently reviewable.
- Does not interact with branches or PRs. Hand off to Scrum Master after spec
  structure is confirmed.

#### Scrum Master

- When assigning a task, provide: the exact branch name to create and the PR
  target branch (previous task branch for task/NN>01, or `main` for task/01).
- May assign the next task as soon as the Developer opens the PR for the
  current task — does not wait for review or merge.
- If the restack bot posts a conflict comment on a PR, pause task assignment
  for that spec and ask the Developer to resolve the conflict before continuing.

#### Developer

- task/01: branch from `main`.
- task/NN (N > 1): branch from the previous task branch (`spec-slug-task/NN-1-slug`).
- PR target: the branch you branched from.
- After opening a PR, immediately start the next assigned task — do not wait
  for review or merge.
- If the restack bot posts a rebase notification on your PR, your remote branch
  has been updated. Run `git fetch origin && git reset --hard origin/<branch>`
  before pushing any further changes to that branch.

#### Code Reviewer

- Reviews PRs targeting task branches (not necessarily main).
- If a rebase notification comment has appeared on a PR since you last reviewed
  it, re-fetch the branch and review the updated diff before posting feedback.
- Does not merge PRs. Outputs PASS or FEEDBACK only.

#### QA

- Runs QA only after the full task stack for a spec has merged to main.
  Does not QA individual task branches.
- If any task branch PR is still open or in a conflict state, block QA and
  notify the Scrum Master to resolve it first.
