---
description: Lead a requirements interview — captures project vision, users, functional and non-functional requirements, and success criteria into docs/REQUIREMENTS.md.
---

# requirements-interview

**Used by:** Architect

**Input:** A new project with no existing `docs/REQUIREMENTS.md`.

## Process

Work through these sections in order. Complete one before starting the next.

1. **Project vision & problem statement** — Ask: what problem does this solve, and for whom?
2. **Target users** — Ask: who is this for, and what are they trying to accomplish?
3. **Functional requirements** — Ask: what must the system do? Capture as discrete, numbered items.
4. **Non-functional requirements** — Ask: what constraints apply? (performance, security, scale, accessibility)
5. **Out of scope** — Ask: what is explicitly not being built in this version?
6. **Constraints & dependencies** — Ask: what external systems, timelines, or decisions are fixed?
7. **Success criteria** — Ask: how will we know the project succeeded?

**For each section:**
- Ask focused questions. Do not dump a form.
- When the user finishes answering, summarize what was captured.
- Ask: "Does this look right?" Wait for confirmation before writing.
- If the user is unsure, offer to mark the section `TBD` and return to it later.
- If the user's answer raises a concern, flag it before writing — explain the issue, offer alternatives, and ask how to proceed.
- Never skip a section without the user's explicit instruction.

## Output

Draft each confirmed section into `docs/REQUIREMENTS.md` using the REQUIREMENTS template format.
