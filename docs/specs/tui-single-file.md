# Spec: TUI Mode: Single File

Status: draft
Version: v1

## Overview

Implements the swift-tui application shell and basic single-file display mode. When `emdee` is given a path to a single `.md` file, it launches a full-screen TUI that loads and displays the file's raw content with scrolling support. Markdown rendering is added in the Core: Markdown Parsing spec — this spec establishes the TUI foundation.

## Functional Requirements

- FR-01: Render a single markdown file in the terminal.

## Technical Requirements

- TR-01: Uses `swift-tui` for the TUI application shell.
- TR-02: Launched from `Sources/emdee/` when the CLI receives a single file path without `--web`.
- TR-03: No markdown rendering in this spec — raw file content only.

## Tasks

### TASK-01: Initialize swift-tui application shell

**Description:** In `Sources/TUIRenderer/`, create a `TUIApp` entry point using swift-tui. Wire the CLI in `Sources/emdee/` so that when a single `.md` file path is provided (without `--web`), it launches the TUI app. The app may show a placeholder view at this stage.

**Acceptance Criteria:**
- [ ] Running `emdee path/to/file.md` launches a full-screen TUI application.
- [ ] The TUI exits cleanly when `q` is pressed.
- [ ] The TUI does not crash on launch.

**Status:** todo

---

### TASK-02: Load and display raw file content

**Description:** Read the target `.md` file from disk and display its raw text content in the main view area of the TUI. Content that exceeds the terminal height should be scrollable.

**Acceptance Criteria:**
- [ ] The file's raw text content is visible in the TUI on launch.
- [ ] Long files (more than one screen height) can be scrolled.
- [ ] A file that does not exist shows an error message in the view area instead of crashing.

**Status:** todo

---

### TASK-03: Keyboard controls

**Description:** Implement keyboard navigation for the single-file view: scroll up/down and quit.

**Acceptance Criteria:**
- [ ] `q` quits the application and returns to the shell.
- [ ] Up arrow and `k` scroll content up.
- [ ] Down arrow and `j` scroll content down.
- [ ] Scrolling does not go past the beginning or end of the content.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |
| TASK-03 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
