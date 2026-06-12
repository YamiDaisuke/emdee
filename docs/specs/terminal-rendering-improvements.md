# Spec: Terminal Rendering Improvements

Status: draft
Version: v1

## Overview

Extends the ANSI terminal renderer from full-spec markdown coverage and improved visual differentiation. Headings gain distinct per-level treatments including full-line backgrounds for H1/H2; the renderer becomes viewport-width-aware (full-width backgrounds, thematic breaks, table sizing, paragraph wrapping); and missing CommonMark/GFM elements are added: links, images, autolinks, strikethrough, task lists, nested lists and blockquotes, block content in list items, code block language labels and line numbers, and raw HTML passthrough. A style-context stack replaces raw ANSI resets so nested inline styles no longer break outer styling. `docs/sample.md` serves as the end-to-end verification fixture.

## Functional Requirements

- FR-01: Render a single markdown file in the terminal with proper font styles (bold, italic, headers, code blocks), and tables.

## Technical Requirements

- TR-01: 256-colour terminal support is the baseline assumption — no 8-colour fallback required.
- TR-02: Rendering logic stays in `Sources/Core/` — no TUI or terminal-specific imports in the renderer itself. Viewport width is passed in as a parameter.
- TR-03: ANSI escape codes are used for terminal styling; escape sequences must not count toward width calculations.
- TR-04: Uses `swift-markdown` (Apple) for parsing — no new dependencies.

## Tasks

### TASK-01: Viewport width plumbing

**Description:** Add a `width` parameter to `ANSIRenderer.render` and thread the actual viewport width through from `TUIRenderer`. When width is unavailable (e.g. piped output), fall back to 80. As the first consumer, make thematic breaks span the full width instead of the hard-coded 40 characters.

**Acceptance Criteria:**
- [ ] `ANSIRenderer.render` accepts a width parameter; callers without a known width get a default of 80.
- [ ] `TUIRenderer` passes the real viewport width of the rendering area.
- [ ] A thematic break renders as a `─` line spanning exactly the viewport width.
- [ ] Existing rendering output is otherwise unchanged.

**Status:** todo

---

### TASK-02: Style-stack refactor (nested-reset bug fix)

**Description:** Replace raw `ANSI.reset` emissions with a style-context stack so that when an inline style ends inside a styled container (e.g. `**bold**` inside a heading, inline code inside a blockquote), the renderer restores the enclosing style instead of resetting all attributes.

**Acceptance Criteria:**
- [ ] A heading containing `**bold**`, `*italic*`, or `` `code` `` retains the heading's own styling after the inline span ends.
- [ ] Nested emphasis (`**bold with *italic* inside**`, `***bold-italic***`) renders both styles correctly through the full span.
- [ ] No raw `ANSI.reset` is emitted mid-container; a single reset terminates each top-level block.
- [ ] All existing renderer tests pass (updated where output legitimately changes).

**Status:** todo

---

### TASK-03: Heading treatment H1–H6

**Description:** Give each heading level a visually distinct treatment. H1 and H2 get a full-line background colour padded to the viewport width; H3–H6 use foreground styling only. Setext headings (parsed by swift-markdown as `Heading` levels 1–2) get identical treatment.

**Acceptance Criteria:**
- [ ] H1 renders bold yellow text on a dark magenta background spanning the full viewport width.
- [ ] H2 renders bold white text on a dark blue background spanning the full viewport width.
- [ ] H3 renders bold cyan; H4 bold green; H5 dim italic; H6 dim.
- [ ] Background colour does not bleed past the line or into following content.
- [ ] Setext H1/H2 render identically to ATX H1/H2.
- [ ] Inline styles inside headings render correctly (depends on TASK-02).

**Status:** todo

---

### TASK-04: Code block enhancements

**Description:** Render code blocks with a background colour across the full block (padded to viewport width), a language label when the fence has an info string, and line numbers. Indented code blocks render identically to fenced ones (swift-markdown parses both as `CodeBlock`).

**Acceptance Criteria:**
- [ ] Code block lines render with a uniform background colour padded to the viewport width.
- [ ] A fenced block with an info string shows the language as a label.
- [ ] Each code line is prefixed with a right-aligned line number in a muted style.
- [ ] Whitespace and special characters inside the block are preserved exactly.
- [ ] Indented (4-space) code blocks render with the same treatment as fenced blocks.
- [ ] An empty code block renders without crashing.

**Status:** todo

---

### TASK-05: Blockquote enhancements

**Description:** Support nested blockquotes with stacked `│` bars, and ensure block content inside quotes (headings, lists, code blocks, tables) is correctly prefixed on every line.

**Acceptance Criteria:**
- [ ] A blockquote nested N levels deep renders N stacked `│ ` prefixes per line.
- [ ] Headings, lists, code blocks, and tables inside a blockquote carry the quote prefix on every rendered line.
- [ ] Multi-paragraph blockquotes keep the prefix on blank separator lines.
- [ ] An empty blockquote renders without crashing.

**Status:** todo

---

### TASK-06: Nested list indentation

**Description:** Render nested lists with progressive indentation and per-level markers (e.g. `•`, `◦`, `▪` for unordered; re-numbered for ordered). Honour the ordered-list start number and support mixed ordered/unordered nesting.

**Acceptance Criteria:**
- [ ] Each nesting level indents further than its parent.
- [ ] Unordered levels cycle distinct markers (e.g. `•`, `◦`, `▪`).
- [ ] An ordered list starting at an arbitrary number (e.g. `42.`) numbers from that value.
- [ ] Double-digit ordered indices align correctly.
- [ ] Ordered lists nested under unordered lists (and vice versa) render correctly.
- [ ] Deeply nested lists (6+ levels) render without crashing.

**Status:** todo

---

### TASK-07: Block content inside list items

**Description:** Render block-level content inside list items (additional paragraphs, code blocks, blockquotes) with correct continuation indentation aligned under the item's text (loose lists).

**Acceptance Criteria:**
- [ ] A second paragraph in a list item renders indented to align with the item's first-line text.
- [ ] A code block inside a list item renders indented under the item.
- [ ] A blockquote inside a list item renders indented under the item with its `│` prefix.
- [ ] Tight lists (no block content) render unchanged.

**Status:** todo

---

### TASK-08: Width-aware tables with column alignment

**Description:** Replace the hard-coded 80-character table truncation with the actual viewport width, and honour GFM column alignment markers (`:---`, `:---:`, `---:`) when padding cells.

**Acceptance Criteria:**
- [ ] Table truncation respects the viewport width passed to the renderer, not a fixed 80.
- [ ] Left-aligned, center-aligned, and right-aligned columns pad cell content accordingly.
- [ ] Columns without an alignment marker default to left alignment.
- [ ] Tables narrower than the viewport are unaffected by truncation logic.
- [ ] A header-only table (no body rows) renders without crashing.

**Status:** todo

---

### TASK-09: Paragraph word-wrap

**Description:** Wrap paragraph text at the viewport width on word boundaries instead of relying on terminal hard-wrap. Width calculation must exclude ANSI escape sequences.

**Acceptance Criteria:**
- [ ] Paragraphs longer than the viewport width wrap at word boundaries.
- [ ] ANSI escape sequences do not count toward line width.
- [ ] Inline styles spanning a wrap point continue correctly on the next line.
- [ ] Words longer than the viewport width do not crash the renderer.
- [ ] Hard line breaks (trailing two spaces or backslash) are preserved.

**Status:** todo

---

### TASK-10: Links, autolinks & images

**Description:** Render links with distinctly styled text (e.g. underlined blue) followed by the URL; autolinks get the same link styling. Images render alt text with a marker and the URL.

**Acceptance Criteria:**
- [ ] An inline link renders its text in a distinct link style with the destination URL visible.
- [ ] Reference links (full, collapsed, shortcut) render identically to inline links.
- [ ] Autolinks (`<https://…>`, bare URLs, email) render in the link style.
- [ ] Images render alt text with a visual marker and the source URL.
- [ ] Inline styles inside link text (bold/italic/code) render correctly.

**Status:** todo

---

### TASK-11: Strikethrough & task lists

**Description:** Render GFM strikethrough using ANSI strikethrough (SGR 9) and task-list items with checkbox glyphs.

**Acceptance Criteria:**
- [ ] `~~text~~` renders with ANSI strikethrough.
- [ ] Strikethrough combines correctly with bold and italic.
- [ ] `- [ ]` renders an unchecked glyph (☐); `- [x]` / `- [X]` render a checked glyph (☑).
- [ ] Task-list items respect list indentation rules from TASK-06.

**Status:** todo

---

### TASK-12: Remaining elements & full-sample verification

**Description:** Render inline and block raw HTML dim as-is; verify parser-handled constructs (character references, backslash escapes, hard breaks, reference link resolution) render correctly. Use `docs/sample.md` as the end-to-end fixture.

**Acceptance Criteria:**
- [ ] Block-level raw HTML (including comments) renders dim, content unmodified.
- [ ] Inline raw HTML renders dim within its paragraph.
- [ ] Character references (named, decimal, hex) render as their resolved characters.
- [ ] Backslash-escaped punctuation renders literally.
- [ ] Rendering `docs/sample.md` end-to-end produces no dropped elements, no unstyled supported elements, and no crash.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | 032b72b8  |
| TASK-02 | 98d1680c  |
| TASK-03 | f0e4544e  |
| TASK-04 | 2a741a4f  |
| TASK-05 | 243afb9e  |
| TASK-06 | 0356ab78  |
| TASK-07 | 25bde6d6  |
| TASK-08 | bfae778e  |
| TASK-09 | 5f0c1e80  |
| TASK-10 | 889c1b26  |
| TASK-11 | 60a34f51  |
| TASK-12 | 67043bb5  |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-06-11 | Initial spec |
