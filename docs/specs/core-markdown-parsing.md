# Spec: Core: Markdown Parsing

Status: draft
Version: v1

## Overview

Implements the `MarkdownDocument` model and a terminal renderer that converts parsed markdown into ANSI-styled terminal output. This spec delivers full markdown rendering (headers, emphasis, code, tables) and integrates it into the TUI single-file view established in the TUI Mode: Single File spec.

## Functional Requirements

- FR-01: Render a single markdown file with proper font styles (bold, italic, headers, code blocks) and tables.

## Technical Requirements

- TR-01: Uses `swift-markdown` (Apple) for parsing.
- TR-02: Rendering logic lives in `Sources/Core/` — no TUI or terminal-specific imports in the renderer itself.
- TR-03: ANSI escape codes are used for terminal styling.

## Tasks

### TASK-01: Define MarkdownDocument model

**Description:** In `Sources/Core/`, define a `MarkdownDocument` struct that wraps the output of `swift-markdown`'s parser. It should hold the parsed document and expose the source file path.

**Acceptance Criteria:**
- [ ] `MarkdownDocument` can be initialized from a file path and parses the file using `swift-markdown`.
- [ ] `MarkdownDocument` can be initialized from a raw string (for piped input support).
- [ ] Invalid or unreadable files throw an error.

**Status:** done

---

### TASK-02: Implement terminal renderer for inline styles and blocks

**Description:** In `Sources/Core/`, implement a renderer that walks `swift-markdown` document nodes and produces an ANSI-styled string. Must handle: headings (H1–H4), bold, italic, inline code, fenced code blocks, blockquotes, and unordered/ordered lists.

**Acceptance Criteria:**
- [ ] H1 renders visually distinct from H2, H3, H4 (e.g., via ANSI bold and/or sizing cues).
- [ ] Bold text renders with ANSI bold.
- [ ] Italic text renders with ANSI italic.
- [ ] Inline code renders with a distinct style (e.g., highlighted background or color).
- [ ] Fenced code blocks render with a distinct style and preserve whitespace.
- [ ] Blockquotes render with a leading `│` or equivalent indicator.
- [ ] Unordered and ordered lists render with correct indentation and markers.

**Status:** done

---

### TASK-03: Implement table rendering

**Description:** Extend the terminal renderer to handle markdown tables. Columns should be aligned and the output should be readable at typical terminal widths.

**Acceptance Criteria:**
- [ ] A markdown table renders with column separators and aligned content.
- [ ] Tables with varying column widths align correctly.
- [ ] A table wider than the terminal width does not crash — it truncates or wraps gracefully.

**Status:** done

---

### TASK-04: Integrate renderer into TUI single-file view

**Description:** Replace the raw text display in the TUI single-file view with the ANSI-rendered output from the markdown renderer. The `MarkdownDocument` model and renderer (from TASK-01/02/03) are wired into `TUIRenderer`.

**Acceptance Criteria:**
- [ ] Running `emdee path/to/file.md` displays rendered markdown (not raw text).
- [ ] Headers, bold, italic, code blocks, and tables are visually styled.
- [ ] Scrolling still works correctly over rendered content.

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
