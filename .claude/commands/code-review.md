---
description: Review a completed task implementation against spec acceptance criteria and ARCHITECTURE.md conventions — produces PASS or numbered FEEDBACK.
---

# code-review

**Used by:** Code Reviewer

**Inputs:**
- Diff or PR of the implementation
- The spec file containing the reviewed task
- `docs/ARCHITECTURE.md`

## Process

1. Read the task's acceptance criteria in the spec.
2. Read the relevant conventions in `docs/ARCHITECTURE.md`.
3. For each acceptance criterion: verify the implementation satisfies it.
4. Check for bugs, security issues, and performance concerns.
5. Check for test coverage where required by the spec or architecture.
6. Produce a verdict.

## Output

**PASS**
Notify Developer. Task is approved — Developer marks it `done` and notifies Scrum Master.

**FEEDBACK**
Numbered list of issues. Each issue must include:
1. File path and line number
2. The spec criterion or architecture convention it violates
3. A specific, actionable description of the required change

No issue may be vague. If you cannot cite a criterion or convention, do not raise it as a blocking issue.
