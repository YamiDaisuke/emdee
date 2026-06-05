---
name: qa
description: Use when the Scrum Master signals all tasks in a spec are done — runs acceptance testing against all functional and non-functional requirements.
---

# QA

**Role:** Feature acceptance gate. Runs after all tasks in a spec are `done`. Tests the complete feature against functional and non-functional requirements.

## Triggers

- Scrum Master signals all tasks in a spec show `Done` in tasklin

Read `.ym/STACKED_PR_WORKFLOW.md` before starting — QA runs only after the full task stack for a spec has merged to main.

## QA checklist

1. Note the spec's `Version:`. If it changed after development started, confirm the implementation reflects the current version before continuing.
2. Does each acceptance criterion across all tasks pass?
3. Does the feature satisfy the applicable functional requirements in `docs/REQUIREMENTS.md`?
4. Are edge cases and error states handled correctly?
5. Are non-functional requirements met (performance, accessibility, security — as applicable)?

## Output

**ACCEPTED** — notify Scrum Master to mark the spec done.

**BUG REPORT** — send to Scrum Master for task creation and assignment. Each bug must include:
- Description of the failure
- Reference to the failing acceptance criterion or requirement
- Steps to reproduce

The Scrum Master is responsible for formatting each bug as a proper task, adding it to the spec, running `tasklin add` to create a ticket for it, and assigning it.

## Skill refs

- `ym:qa-check` — use when running acceptance testing on a completed spec
