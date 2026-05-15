# Spec 03 — TUI Diagrams (GoAT)

## Phase
Phase 2

## Context
Phase 2 adds diagram support to the terminal viewer. The only diagram format supported in the TUI is **GoAT** (Go ASCII Tool): fenced code blocks tagged `` ```goat `` are rendered as ASCII art inline with the rest of the document. `mermaid` blocks are not rendered in the TUI — they display as a styled code block with a notice directing the user to use `--web` mode.

This spec modifies the rendering pipeline established in Spec 01. No changes are needed to the TUI models themselves.

---

## Dependencies

| Library | Purpose |
|---|---|
| `github.com/bep/goat` | GoAT ASCII diagram renderer (pure Go) |

All other dependencies are inherited from Spec 01.

---

## Package Layout

```
internal/
  renderer/
    terminal/
      renderer.go       extended to pre-process goat/mermaid blocks
      renderer_test.go
    goat/
      goat.go           thin wrapper: GoAT source → ASCII string
      goat_test.go
```

The strategy is a **pre-processing pass** on the raw Markdown source before it is handed to glamour. GoAT fenced blocks are extracted, rendered to ASCII, and re-injected as plain indented code blocks (which glamour renders with its code block style). This keeps glamour's rendering pipeline unchanged.

---

## Tasks

---

### Task 1 — GoAT renderer wrapper

**Goal:** A package that accepts GoAT diagram source and returns a rendered ASCII string.

**Files:**
- `internal/renderer/goat/goat.go`
- `internal/renderer/goat/goat_test.go`

**Steps:**
1. Import `github.com/bep/goat`
2. Export `func Render(src string) (string, error)`: pass `src` to `goat.New(strings.NewReader(src)).BuildSVG()` — wait, GoAT's primary output is SVG. For terminal we need ASCII. Check: `goat` actually renders SVG not ASCII. The ASCII art is the *input* format; GoAT converts it to SVG. So for the terminal, the right approach is to render the GoAT source as-is (it is already readable ASCII art) with a light border/label, not to call GoAT at all. GoAT is used in Spec 05 (web) to produce SVG output. Update this task accordingly:
   - Export `func FormatForTerminal(src string) string`: trim trailing whitespace from each line, ensure the block is non-empty, return as-is (the ASCII art is the rendered form)
   - Export `func RenderSVG(src string) (string, error)`: used by Spec 05 — calls `goat.New(strings.NewReader(src)).BuildSVG()` and returns the SVG string
3. Unit tests for `FormatForTerminal`: blank input returns empty string; a simple box diagram is returned trimmed and unchanged; multi-line input preserves line structure

**Acceptance criteria:**
- `FormatForTerminal` on a simple ASCII box returns the same diagram with trimmed lines
- `RenderSVG` on the same input returns a non-empty string containing `<svg`
- Neither function panics on empty input
- `go test ./internal/renderer/goat/...` passes

---

### Task 2 — Markdown pre-processor: GoAT block substitution

**Goal:** Before passing Markdown to glamour, replace `` ```goat `` fenced blocks with their terminal-formatted ASCII art, wrapped in a regular indented code block so glamour styles them consistently.

**Files:**
- `internal/renderer/terminal/preprocessor.go`
- `internal/renderer/terminal/preprocessor_test.go`

**Steps:**
1. Export `func Preprocess(src []byte) []byte`
2. Use a regex or simple state-machine parser to locate fenced blocks with info string `goat` (case-insensitive, handles optional trailing spaces)
3. For each match: call `goat.FormatForTerminal(content)`, re-emit as a fenced code block with info string `text` (plain, no highlighting) prefixed with a comment line `// diagram (goat)`  — this preserves glamour styling without glamour trying to syntax-highlight it
4. Blocks that fail (empty content after trim) are replaced with a fenced block containing `(empty diagram)`
5. Unit tests: document with no goat blocks is unchanged; single goat block is replaced; multiple goat blocks are all replaced; a goat block adjacent to other fenced blocks does not corrupt them

**Acceptance criteria:**
- A document containing only a `goat` block produces output with no `` ```goat `` fence remaining
- The replaced block renders visibly in the TUI as formatted code (not raw Markdown syntax)
- A document with no `goat` blocks passes through byte-identical
- Nested fences (content containing triple backticks) do not corrupt parsing
- `go test ./internal/renderer/terminal/... -run TestPreprocess` passes

---

### Task 3 — Markdown pre-processor: Mermaid fallback

**Goal:** Replace `` ```mermaid `` blocks with a styled notice telling the user to use `--web` mode, so they do not see raw Markdown syntax.

**Files:**
- `internal/renderer/terminal/preprocessor.go` (extend Task 2)
- `internal/renderer/terminal/preprocessor_test.go`

**Steps:**
1. In `Preprocess`, after handling `goat` blocks, handle `mermaid` blocks (same detection logic)
2. Replace each `mermaid` block with a fenced block containing:
   ```
   ℹ Mermaid diagram — use --web to render
   ```
   followed by the original source indented, so the user can still read the raw diagram definition
3. Unit tests: mermaid block is replaced with notice; both goat and mermaid blocks in the same document are each handled correctly

**Acceptance criteria:**
- A `mermaid` block in the TUI shows the notice text, not raw Markdown fences
- The original mermaid source is visible below the notice (the user can read the definition)
- `go test ./internal/renderer/terminal/... -run TestPreprocess` passes with mermaid cases

---

### Task 4 — Wire pre-processor into terminal renderer

**Goal:** `renderer/terminal.Render` calls `Preprocess` before passing source to glamour. No changes to callers.

**Files:**
- `internal/renderer/terminal/renderer.go`

**Steps:**
1. At the top of `Render(src []byte, width int)`, call `src = Preprocess(src)`
2. Pass the pre-processed bytes to glamour as before
3. No other changes

**Acceptance criteria:**
- `emdee` on a file containing a `goat` block renders the ASCII art inline in the TUI
- `emdee` on a file containing a `mermaid` block renders the notice and raw source
- All existing Spec 01 and 02 acceptance criteria continue to pass
- `go test ./internal/renderer/terminal/...` passes

---

### Task 5 — Syntax highlighting for code blocks

**Goal:** Fenced code blocks with a language tag are rendered with syntax highlighting in the terminal.

**Files:**
- `internal/renderer/terminal/renderer.go`

**Steps:**
1. glamour supports syntax highlighting out of the box via its built-in chroma integration — verify it is enabled in the `glamour.NewTermRenderer` options (it is on by default for the `auto` style)
2. Confirm that the glamour style in use enables code highlighting: add `glamour.WithStyles(glamour.AutoStyle)` if not already set
3. Manually test (or write a test) with a fenced Go block and a fenced Python block to confirm colorized output on a color-capable terminal
4. No changes needed if glamour is already configured correctly — this task is primarily verification with a targeted test

**Acceptance criteria:**
- A fenced Go block (` ```go `) produces ANSI-colored output on a color terminal
- A fenced block with an unknown language tag renders without error (falls back to plain)
- A fenced block with no language tag renders without error
- `go test ./internal/renderer/terminal/...` passes
