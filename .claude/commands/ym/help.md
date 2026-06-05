---
description: Explain the ym workflow — phases, agents, how to resume after stopping, and how to start a new feature cycle.
---

# ym:help

**Purpose:** Orient any user (or Claude instance) to the ym workflow. Use this when you're unsure where you are, how to start, or how to add a new feature to an existing project.

## The 5 Phases

| Phase | Agent | Output | Done When |
|---|---|---|---|
| 1. Requirements | Architect | `docs/REQUIREMENTS.md` | User confirms all sections |
| 2. Architecture | Architect | `docs/ARCHITECTURE.md` | User confirms all sections |
| 3. Spec Writing | Scrum Master + Architect | `docs/specs/*.md` | All features have a spec |
| 4. Development | Developer + Code Reviewer | Code commits | All tasks in all specs = `done` |
| 5. QA | QA | QA report | All specs accepted |

## How to Check Where You Are

1. Open `CLAUDE.md` — the `### Current phase` checklist shows what's been marked complete.
2. Check whether `docs/REQUIREMENTS.md` exists and contains confirmed content (not an empty template).
3. Check whether `docs/ARCHITECTURE.md` exists and contains confirmed content.
4. Check `docs/specs/` — are there spec files? What is each spec's status?
5. Within any spec, scan task statuses: `todo`, `in-progress`, `done`.

## How to Resume After Stopping

Tell Claude which agent to use and what state you're in. The agent will read existing documents to orient itself — you do not need to re-explain the project.

| Stopped at | What to say |
|---|---|
| Mid-requirements | "Resume as Architect — requirements session is incomplete." |
| Mid-architecture | "Resume as Architect — REQUIREMENTS.md is confirmed, architecture session is incomplete." |
| Mid-spec writing | "Resume as Scrum Master — ARCHITECTURE.md is confirmed, continue spec writing." |
| Mid-development | "Resume as Scrum Master — find the next task across all specs." |
| Mid-QA | "Resume as QA — run acceptance testing on `docs/specs/<feature>.md`." |

## How to Add a New Feature

Once Requirements and Architecture are confirmed, use this sequence for any new feature:

1. **Describe the feature to the Architect.**
   The Architect will assess whether `docs/ARCHITECTURE.md` needs amending before spec work begins. If it does, the Architect uses `/ym:spec-amend` to record the change first.

2. **Hand off to the Scrum Master once architecture impact is resolved.**
   The Scrum Master will write a new spec in `docs/specs/` using `/ym:spec-writer`.

3. **Development and QA follow the standard cycle.**
   Developer → Code Reviewer → QA, same as any other spec.

**Entry point:** "As Architect, I want to add a new feature: [description]."

## Quick Reference

| What you want | What to say |
|---|---|
| Start a new project | "Start as Architect — begin requirements session." |
| Resume requirements | "Resume as Architect — requirements session incomplete." |
| Resume architecture | "Resume as Architect — REQUIREMENTS.md is confirmed, continue architecture." |
| Resume spec writing | "Resume as Scrum Master — continue spec writing." |
| Add a new feature | "As Architect, assess this new feature: [description]." |
| Resume development | "Resume as Scrum Master — find the next task." |
| Run QA | "As QA, run acceptance testing on docs/specs/<feature>.md." |
| Update skeleton safely | Run `/ym:bootstrap-update` |

## How to Update the Bootstrap Skeleton

When a new version of `ym` is released, running `ym bootstrap` updates `.ym/` scripts and templates and adds any new agent or skill files — but it will not overwrite files you may have customized.

To adopt updates to existing agent definitions, skill commands, or CLAUDE.md sections 1–4, use the update skill instead:

```
/ym:bootstrap-update
```

What it does:
- Updates `.ym/` scripts and templates silently (these are never customized)
- Diffs CLAUDE.md section by section — shows only skeleton-controlled sections (1–4, 8); asks for approval before changing any; never touches your project-specific sections (5–7)
- Diffs each agent and skill file — shows what changed, asks to replace / keep / skip per file; copies new files automatically
- Runs migration scripts
- Prints a summary of every decision and suggests `git diff .claude/ CLAUDE.md` to review
