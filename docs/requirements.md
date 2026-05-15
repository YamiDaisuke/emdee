# Requirements

## Overview

**emdee** is a CLI tool written in Go and distributed as a single self-contained binary. It opens Markdown files, formats them, and displays the result directly in the terminal. An optional flag switches to a web-based visualizer instead.

---

## Constraints (all phases)

- Single self-contained binary — no runtime dependencies, no external renderer processes
- No CGO
- Written in Go; targets Go 1.21+
- Passes `go vet` and `go fmt` without warnings

---

## Phase 1 — PoC

### File mode

- [ ] Accept a single Markdown file path as a CLI argument
- [ ] Read Markdown from stdin when no file argument is given
- [ ] Format and render the file in the terminal

### Rendering (terminal)

- [ ] Headings (all six levels) with distinct visual weight
- [ ] Paragraphs with word wrapping to terminal width
- [ ] Bold, italic, and strikethrough inline text
- [ ] Inline code
- [ ] Fenced code blocks (rendered as-is, no syntax highlighting)
- [ ] Ordered and unordered lists, including nested lists
- [ ] Blockquotes
- [ ] Horizontal rules
- [ ] Links (display URL or link text + URL)
- [ ] Tables (GFM)
- [ ] Task lists (GFM checkbox syntax)

### Folder mode

- [ ] When given a directory path, display a collapsible sidebar with a tree view
- [ ] Tree shows only `.md` files (no other file types)
- [ ] User can navigate the tree and select a file to open it in the main pane
- [ ] Sidebar is collapsible / expandable
- [ ] Tree refreshes automatically when the directory contents change, with a fallback manual refresh action

### File refresh

- [ ] When a file is open, it refreshes automatically when the file changes on disk
- [ ] A manual refresh action is also available

### CLI

- [ ] `--help` flag with usage information
- [ ] `--version` flag
- [ ] Non-zero exit code on error

---

## Phase 2 — Enhanced Rendering

### Syntax highlighting

- [ ] Fenced code blocks rendered with syntax highlighting for common languages
- [ ] Language auto-detected from the fence info string

### Mermaid diagrams

- [ ] Fenced code blocks tagged `mermaid` are rendered as diagrams
- [ ] Diagram rendering must stay within the single-binary constraint (no external process or network call required at runtime)
- [ ] Define fallback behavior when a diagram cannot be rendered (e.g., show raw source)

---

## Web Mode (phase TBD)

- [ ] A `--web` flag (or subcommand) spawns a local HTTP server and opens the visualizer in the default browser
- [ ] All rendering features available in terminal mode are also available in web mode
- [ ] Folder tree sidebar works identically to terminal mode
- [ ] File and tree auto-refresh behave the same as terminal mode (e.g., via WebSocket or SSE push)
- [ ] Server binds to localhost only; port is configurable, with a sensible default
- [ ] Server shuts down when the process is terminated

---

## Out of Scope (v1)

- Editing Markdown in-tool
- Markdown extensions beyond CommonMark + GFM
- Authentication or multi-user access for the web server
- Exporting to PDF or other formats
