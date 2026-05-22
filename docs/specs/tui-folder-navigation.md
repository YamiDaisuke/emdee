# Spec: TUI Mode: Folder Navigation

Status: draft
Version: v1

## Overview

Extends the TUI application to support folder mode: a sidebar showing the `FileNode` tree alongside the markdown rendering area. The user can navigate the file tree with the keyboard and open files, replacing the content in the rendering area. Depends on Core: File Discovery & Tree and Core: Markdown Parsing.

## Functional Requirements

- FR-03: Display a navigable file tree in a sidebar alongside the rendering area using a full TUI; selecting a file replaces the rendered content.

## Technical Requirements

- TR-01: Uses `swift-tui` for layout — sidebar and content panels are rendered as split views.
- TR-02: Consumes `FileNode` from `Sources/Core/`.
- TR-03: Launched from `Sources/emdee/` when the CLI receives a folder path without `--web`.

## Tasks

### TASK-01: Add sidebar panel to TUI layout

**Description:** Update the `TUIApp` layout to split the screen into a fixed-width sidebar (left) and a content area (right). The sidebar and content area must resize correctly when the terminal is resized.

**Acceptance Criteria:**
- [ ] The TUI displays a sidebar panel on the left and a content area on the right.
- [ ] The sidebar has a fixed width (e.g., 30% of terminal width, minimum 20 columns).
- [ ] Resizing the terminal reflows both panels without crashing.

**Status:** todo

---

### TASK-02: Render FileNode tree in sidebar

**Description:** Display the `FileNode` tree in the sidebar. Directories are shown with their name; files are shown with their name. Directories can be expanded or collapsed. The currently selected node is visually highlighted.

**Acceptance Criteria:**
- [ ] All `.md` files and their parent directories appear in the sidebar tree.
- [ ] Directories can be expanded (showing children) and collapsed (hiding children) with a keystroke.
- [ ] The selected node is visually highlighted.
- [ ] Directory nodes are visually distinct from file nodes (e.g., a folder icon or different indent marker).

**Status:** todo

---

### TASK-03: Keyboard navigation in sidebar

**Description:** Implement keyboard controls for the sidebar: move selection up/down, expand/collapse directories, and open a file into the content area.

**Acceptance Criteria:**
- [ ] Up arrow and `k` move selection up in the tree.
- [ ] Down arrow and `j` move selection down in the tree.
- [ ] Right arrow or `l` expands a collapsed directory; left arrow or `h` collapses an expanded directory.
- [ ] Enter opens the selected file and renders it in the content area.
- [ ] Pressing Enter on a directory expands/collapses it instead of opening it.
- [ ] `q` quits the application.
- [ ] Focus can be switched between sidebar and content area (e.g., `Tab`).

**Status:** todo

---

### TASK-04: Wire folder mode to CLI

**Description:** Update the CLI entry point so that when the path argument is a directory (without `--web`), it launches the sidebar+content TUI using the folder's `FileNode` tree. Opening the first `.md` file in the tree automatically.

**Acceptance Criteria:**
- [ ] `emdee path/to/folder` launches the sidebar+content TUI.
- [ ] The first `.md` file in the tree is opened and rendered in the content area on launch.
- [ ] An empty folder (no `.md` files) shows an empty sidebar with an appropriate message in the content area.
- [ ] A folder path that does not exist exits with an error message.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |
| TASK-03 | N/A       |
| TASK-04 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
