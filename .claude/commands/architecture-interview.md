---
description: Lead an architecture session — captures tech stack, data model, API patterns, auth, testing strategy, deployment, and conventions into docs/ARCHITECTURE.md.
---

# architecture-interview

**Used by:** Architect

**Input:** Confirmed `docs/REQUIREMENTS.md`.

## Process

Work through these sections in order. Complete one before starting the next.

1. **Tech stack** — language, framework, runtime, infrastructure
2. **Repository & code organization** — monorepo vs. multi-repo, directory structure, module boundaries
3. **Data model overview** — key entities, relationships, storage technology
4. **API / integration patterns** — REST/GraphQL/event-driven, external integrations, contracts
5. **Auth & security approach** — authentication method, authorization model, secrets management
6. **Testing strategy** — unit/integration/e2e split, coverage expectations, tooling
7. **Deployment & environments** — environments (dev/staging/prod), CI/CD pipeline, release process
8. **Conventions & style rules** — naming, error handling, logging, code formatting

**For each section:**
- Ask focused questions. Do not dump a form.
- When the user finishes answering, summarize what was captured.
- Ask: "Does this look right?" Wait for confirmation before writing.
- If the user is unsure, offer to mark the section `TBD` and return to it later.
- If the user's answer raises a concern, flag it before writing — explain the issue, offer alternatives, and ask how to proceed.
- Never skip a section without the user's explicit instruction.

## Output

Draft each confirmed section into `docs/ARCHITECTURE.md` using the ARCHITECTURE template format.
