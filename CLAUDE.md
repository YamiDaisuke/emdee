# CLAUDE.md

Behavioral guidelines for emdee.

<!-- Replace emdee with the project name. Fill in sections 5–7 after bootstrapping. -->

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

-----

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing files:

- Don't "improve" adjacent content, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated issues, mention them — don't fix them silently.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

For multi-step tasks, state a brief plan before starting:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Wait for confirmation on the plan before writing any file.

-----

## 5. Project Context

`emdee` is a terminal-based markdown visualizer written in Swift. It renders markdown files in a full TUI (sidebar file tree + rendering area) or via a local web server with browser-based rendering. Target users are developers and technical writers on markdown-heavy projects (e.g., SDD docs). Key constraints: macOS and Linux only, single binary distribution, minimal third-party dependencies.

## 6. Roles & Documents

### Roles active in this repo
- Architect: see .bootstrap/agents/architect.md
- Scrum Master: see .bootstrap/agents/scrum-master.md
- Developer: see .bootstrap/agents/developer.md
- Code Reviewer: see .bootstrap/agents/code-reviewer.md
- QA: see .bootstrap/agents/qa.md

### Key documents
- Requirements: docs/REQUIREMENTS.md
- Architecture: docs/ARCHITECTURE.md
- Specs: docs/specs/*.md

### Current phase
<!-- Update this as the project progresses -->
[x] Requirements
[x] Architecture
[ ] Spec writing
[ ] Development
[ ] QA

## 7. Conventions

- Language: Swift, SPM build system
- Naming: camelCase for variables/functions, PascalCase for types
- Error handling: `throws` / `try` — no `Result` wrapping unless async context requires it
- Logging: internal logger with CLI-settable log level; logs visible only in web server mode or TUI debug panel
- Formatting: SwiftLint enforced — violations fail CI
- Dependencies: `swift-tui` (TUI), `swift-markdown` (parsing), Foundation (web server) — no others without strong justification

## 8. Definition of Done

A task is done when:

- It satisfies all acceptance criteria in the spec
- It could be handed to a Code Reviewer with no additional explanation
- It contains no TODOs or incomplete implementations

-----

**This system is working if:** a Claude Code agent reading only CLAUDE.md and one agent file
knows exactly what to do, what not to do, and where to find everything else.
