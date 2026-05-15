# Spec 01 — Single File TUI

## Phase
Phase 1 (PoC)

## Context
The core use case: `emdee file.md` opens a Markdown file, renders it with formatting, and displays it in a scrollable terminal viewer. Also supports piped input (`cat file.md | emdee`). The file auto-refreshes when it changes on disk.

---

## Dependencies

| Library | Purpose |
|---|---|
| `github.com/spf13/cobra` | CLI framework |
| `github.com/yuin/goldmark` | CommonMark parser |
| `github.com/yuin/goldmark-emoji` | Emoji extension |
| `github.com/charmbracelet/glamour` | Markdown → ANSI renderer |
| `github.com/charmbracelet/bubbletea` | TUI event loop |
| `github.com/charmbracelet/bubbles/viewport` | Scrollable content pane |
| `github.com/charmbracelet/lipgloss` | Layout and styling |
| `github.com/fsnotify/fsnotify` | File system watcher |

---

## Package Layout

```
cmd/emdee/
  main.go               entry point, wires cobra commands

internal/
  parser/
    parser.go           goldmark setup with GFM extensions
    parser_test.go

  renderer/
    terminal/
      renderer.go       glamour-based ANSI renderer
      renderer_test.go

  tui/
    viewer/
      model.go          bubbletea model: viewport + keybindings
      keys.go           key map definitions

  watcher/
    watcher.go          fsnotify wrapper; emits events on a channel
```

---

## Tasks

---

### Task 1 — Project scaffolding and CLI skeleton

**Goal:** Establish `go.mod`, the `cobra` root command, and the two global flags. No rendering yet — the command just prints a placeholder.

**Files:**
- `go.mod`, `go.sum`
- `cmd/emdee/main.go`

**Steps:**
1. `go mod init github.com/<owner>/emdee`
2. Add cobra, run `go mod tidy`
3. Create `cmd/emdee/main.go` with a root command that accepts an optional positional `[file]` argument
4. Add `--version` flag (print version string and exit)
5. Wire cobra's built-in `--help`

**Acceptance criteria:**
- `emdee --help` prints usage including the `[file]` argument description
- `emdee --version` prints a version string and exits 0
- `emdee nonexistent.md` exits non-zero with a "file not found" message
- `go vet ./...` passes

---

### Task 2 — Markdown parser package

**Goal:** A thin wrapper around goldmark that enables all GFM extensions needed for Phase 1.

**Files:**
- `internal/parser/parser.go`
- `internal/parser/parser_test.go`

**Steps:**
1. Configure goldmark with extensions: `extension.GFM` (tables, strikethrough, task lists, autolinks), `extension.Typographer`
2. Export `func Parse(src []byte) ([]byte, error)` that returns the rendered HTML bytes (goldmark will be used server-side in Phase 3 too; keeping HTML as intermediate is cleaner)
3. Write table-driven unit tests covering: headings H1–H6, bold/italic/strikethrough, inline code, fenced code block, ordered list, unordered list, nested list, blockquote, horizontal rule, table, task list

**Acceptance criteria:**
- All test cases produce non-empty output without error
- A fenced code block preserves its content verbatim
- A GFM table produces output containing the cell text
- `go test ./internal/parser/...` passes

---

### Task 3 — Terminal renderer

**Goal:** Convert Markdown source to an ANSI-styled string ready to print, using glamour. Respects a caller-supplied width.

**Files:**
- `internal/renderer/terminal/renderer.go`
- `internal/renderer/terminal/renderer_test.go`

**Steps:**
1. Wrap `glamour.NewTermRenderer` with `glamour.WithAutoStyle()` and `glamour.WithWordWrap(width)`
2. Export `func Render(src []byte, width int) (string, error)`
3. If `width <= 0`, fall back to 80
4. Write tests asserting that bold markers (`**text**`) produce output containing ANSI escape sequences, and that a fenced code block's content appears in the output

**Acceptance criteria:**
- `Render([]byte("# Hello"), 80)` returns a non-empty string without error
- Output for `**bold**` contains at least one ANSI escape sequence
- `Render` does not panic on empty input
- `go test ./internal/renderer/terminal/...` passes

---

### Task 4 — Scrollable viewport TUI model

**Goal:** A bubbletea `Model` that wraps `bubbles/viewport`, displays pre-rendered ANSI content, and handles keyboard navigation.

**Files:**
- `internal/tui/viewer/model.go`
- `internal/tui/viewer/keys.go`

**Steps:**
1. Define `Model` struct holding a `viewport.Model`, the rendered content string, and the source file path
2. Implement `Init`, `Update`, `View` per the bubbletea interface
3. On `tea.WindowSizeMsg`, resize the viewport to full terminal width and height (minus a one-line status bar)
4. Key map (`keys.go`): scroll down `j`/`↓`/`PgDn`, scroll up `k`/`↑`/`PgUp`, top `g`, bottom `G`, quit `q`/`Ctrl+C`
5. Status bar shows filename and scroll percentage
6. Export `func New(content, filePath string) Model`

**Acceptance criteria:**
- Launching the model with arbitrary ANSI content fills the terminal
- `j`/`k` scroll content; `g`/`G` jump to top/bottom
- `q` exits the program cleanly (returns `tea.Quit`)
- Resizing the terminal reflows the viewport without crashing
- Status bar always shows the filename and a scroll percentage

---

### Task 5 — Wire file-path argument to viewer

**Goal:** Connect the CLI argument → read file → render → display in viewer.

**Files:**
- `cmd/emdee/main.go`

**Steps:**
1. In cobra's `RunE`, check that the `[file]` argument exists and is a regular file (not a directory — directory handling is Spec 02)
2. Read file bytes
3. Detect terminal width via `golang.org/x/term` or `os.Stdout`
4. Call `renderer/terminal.Render`
5. Create and start `tui/viewer.Model` with `tea.NewProgram(..., tea.WithAltScreen())`

**Acceptance criteria:**
- `emdee docs/requirements.md` renders the file in the TUI with correct formatting
- All Phase 1 Markdown elements (headings, lists, code blocks, tables, task lists) render visually distinct from body text
- `emdee` with no argument and no piped stdin prints usage and exits 0

---

### Task 6 — Stdin support

**Goal:** `cat file.md | emdee` works identically to `emdee file.md`, using "stdin" as the display name.

**Files:**
- `cmd/emdee/main.go`

**Steps:**
1. In `RunE`, if no positional argument is given, check whether stdin is a pipe (`!term.IsTerminal(int(os.Stdin.Fd()))`)
2. If it is a pipe, read all bytes from `os.Stdin`
3. Render and open viewer with filename label `"<stdin>"`
4. If neither a file argument nor piped stdin is detected, print usage and exit 0

**Acceptance criteria:**
- `cat docs/requirements.md | emdee` renders the file correctly
- The status bar shows `<stdin>`
- `emdee` with a TTY and no args prints help and exits 0
- `echo "# Hello" | emdee` renders a single H1

---

### Task 7 — File watcher and auto-refresh

**Goal:** When a file is open in the viewer, edits to that file on disk are reflected in the TUI within one second without user action.

**Files:**
- `internal/watcher/watcher.go`
- `cmd/emdee/main.go` (wire watcher into TUI)
- `internal/tui/viewer/model.go` (handle reload message)

**Steps:**
1. `watcher.go`: wrap `fsnotify.NewWatcher`, watch a single file path, debounce `Write`/`Create` events with a 200 ms timer, emit on a `chan struct{}`
2. In `viewer.Model`, add a `fileChangedMsg` type and handle it in `Update`: re-read the file, re-render, set new content on the viewport, preserve scroll position if the file grew
3. Use `tea.ExecCommand` or a `tea.Cmd` that listens on the watcher channel via a goroutine + `program.Send`
4. Close the watcher cleanly when the program exits
5. Stdin mode skips the watcher entirely

**Acceptance criteria:**
- Saving a change to the open file updates the TUI within ~1 s
- Scroll position is preserved when content above the viewport is unchanged
- Deleting the watched file shows an inline error ("file deleted") rather than crashing
- Stdin mode launches without errors and the watcher is not started
