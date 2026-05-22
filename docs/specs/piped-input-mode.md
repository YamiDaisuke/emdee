# Spec: Piped Input Mode

Status: draft
Version: v1

## Overview

Implements support for piped stdin: when `emdee` receives markdown content via a Unix pipe (e.g., `cat file.md | emdee`), it detects the pipe, reads stdin, renders the markdown, and prints the result to stdout — no TUI, no sidebar. Depends on Core: Markdown Parsing for rendering.

## Functional Requirements

- FR-07: Accept piped input and render the content directly — no sidebar or file tree in this mode.

## Technical Requirements

- TR-01: Stdin detection and rendering live in `Sources/emdee/` (CLI entry point).
- TR-02: Reuses `MarkdownDocument` and the terminal renderer from `Sources/Core/`.
- TR-03: Output goes to stdout — no TUI is launched.

## Tasks

### TASK-01: Detect piped stdin at startup

**Description:** At startup in `Sources/emdee/`, check whether stdin is connected to a pipe or redirect (i.e., not a TTY). If a pipe is detected, enter piped input mode instead of TUI mode.

**Acceptance Criteria:**
- [ ] `cat file.md | emdee` enters piped input mode (does not launch TUI).
- [ ] `emdee path/to/file.md` (no pipe) continues to launch TUI mode normally.
- [ ] `emdee` with no arguments and no pipe prints a usage message and exits with a non-zero code.

**Status:** todo

---

### TASK-02: Read stdin, render, and print to stdout

**Description:** In piped input mode, read all content from stdin, parse it as a `MarkdownDocument`, render it using the terminal renderer from Core, and print the result to stdout.

**Acceptance Criteria:**
- [ ] `cat file.md | emdee` outputs ANSI-rendered markdown to stdout.
- [ ] Headers, bold, italic, code blocks, and tables are rendered correctly.
- [ ] Empty stdin produces no output and exits cleanly with code 0.
- [ ] Output can be piped further (e.g., `cat file.md | emdee | less`) without errors.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
