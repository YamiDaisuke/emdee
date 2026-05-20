---
description: Run acceptance testing on a completed spec — verifies all task criteria and applicable requirements, produces ACCEPTED or a BUG REPORT for the Scrum Master.
---

# qa-check

**Used by:** QA

**Inputs:**
- The completed spec file (all tasks `done`)
- `docs/REQUIREMENTS.md`
- The codebase

## Process

1. List all acceptance criteria across every task in the spec.
2. List all functional requirements from `docs/REQUIREMENTS.md` that apply to this feature.
3. For each acceptance criterion: test it. Mark PASS, FAIL, or PARTIAL with notes.
4. For each applicable functional requirement: verify it. Mark PASS, FAIL, or PARTIAL with notes.
5. Check edge cases and error states.
6. Check applicable non-functional requirements (performance, accessibility, security).
7. Produce a verdict.

## Output

**ACCEPTED**
Notify Scrum Master to mark spec `done`.

**BUG REPORT**
One task stub per failure, sent to Scrum Master for formatting, ticket creation, and assignment:

    ### TASK-XX: {short title}
    **Description:** What failed and why.
    **Acceptance Criteria:**
    - [ ] {the specific criterion that failed}
    **Ref:** {spec task ID or REQUIREMENTS.md item}
    **Status:** todo
