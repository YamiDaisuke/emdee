# Spec 02 — Folder TUI

## Phase
Phase 1 (PoC)

## Context
When `emdee` is given a directory path it switches to a two-pane layout: a collapsible sidebar on the left showing a tree of `.md` files, and the viewer pane on the right. The user navigates the tree with the keyboard and opens files into the viewer. The tree refreshes automatically when the directory changes.

This spec builds on top of Spec 01. The viewer model (`internal/tui/viewer`) is reused as-is inside the new layout model.

---

## Dependencies

All dependencies from Spec 01, plus:

| Library | Purpose |
|---|---|
| `github.com/charmbracelet/bubbles/list` | Keyboard-navigable list (used for flat file selection inside a tree node) |
| `github.com/fsnotify/fsnotify` | Directory watching (same watcher package from Spec 01, extended) |

No third-party tree-view library — implement a minimal tree model directly with bubbletea to stay in control of styling and avoid heavy transitive deps.

---

## Package Layout

```
internal/
  filetree/
    tree.go             build and update an in-memory tree from a directory
    tree_test.go
    node.go             Node type (dir or file, collapsed/expanded state)

  tui/
    browser/
      model.go          root bubbletea model: manages sidebar + viewer pane
      sidebar.go        sidebar bubbletea model: tree nav and rendering
      layout.go         lipgloss split-pane layout helpers
      keys.go           global and pane-specific key maps

  watcher/
    watcher.go          extended to support watching a directory tree (Spec 01 base)
```

---

## Tasks

---

### Task 1 — In-memory file tree

**Goal:** Build a data structure that represents a directory tree containing only `.md` files, with expand/collapse state per node.

**Files:**
- `internal/filetree/node.go`
- `internal/filetree/tree.go`
- `internal/filetree/tree_test.go`

**Steps:**
1. `Node` struct: `Name string`, `Path string`, `IsDir bool`, `Expanded bool`, `Children []*Node`
2. `func Build(root string) (*Node, error)`: walk the directory with `filepath.WalkDir`, skip hidden files/directories (names starting with `.`), include only `.md` files and the directories that contain them
3. `func (n *Node) Flatten(indent int) []FlatNode`: return a depth-first slice of visible nodes (respecting `Expanded`) for rendering in a list; each `FlatNode` carries indent depth, icon, display name, and the underlying `*Node`
4. Unit tests: empty directory, flat directory with mixed file types (only `.md` appear), nested directories, a directory with no `.md` files anywhere (returns root node with no visible children)

**Acceptance criteria:**
- `Build` on a directory with `.go` and `.md` files returns only `.md` entries
- Hidden directories (`.git`) are not traversed
- `Flatten` on a fully expanded tree returns nodes in depth-first order
- `Flatten` on a tree with a collapsed directory omits its children
- `go test ./internal/filetree/...` passes

---

### Task 2 — Sidebar model

**Goal:** A bubbletea `Model` that renders the file tree as a scrollable, keyboard-navigable list in the sidebar pane.

**Files:**
- `internal/tui/browser/sidebar.go`
- `internal/tui/browser/keys.go` (sidebar section)

**Steps:**
1. `Sidebar` struct holds a `*filetree.Node` (root), a `[]FlatNode` (current visible list), and a cursor index
2. Key bindings (active when sidebar is focused): `↑`/`k` move cursor up, `↓`/`j` move cursor down, `Space`/`→` toggle expand/collapse on a directory node, `Enter` emit a `fileSelectedMsg{path}` for a file node
3. `View()` renders each `FlatNode` with indentation; the selected line is highlighted with lipgloss; directory nodes show `▶` (collapsed) or `▼` (expanded) prefixes; file nodes show a neutral icon
4. Export `func NewSidebar(root *filetree.Node) Sidebar`
5. Export `func (s *Sidebar) SetTree(root *filetree.Node)` to replace tree on refresh

**Acceptance criteria:**
- Cursor wraps at top and bottom of the visible list
- Pressing `Space` on a directory toggles its children in the rendered list
- Pressing `Enter` on a file emits `fileSelectedMsg` with the correct absolute path
- Pressing `Enter` or `Space` on a file node does not crash
- Visual indentation increases by 2 spaces per depth level

---

### Task 3 — Split-pane layout

**Goal:** Combine the sidebar and the viewer pane into a single bubbletea `Model` with a resizable split layout.

**Files:**
- `internal/tui/browser/model.go`
- `internal/tui/browser/layout.go`

**Steps:**
1. `BrowserModel` struct holds a `Sidebar`, a `viewer.Model`, a `focusedPane` enum (`panesidebar` / `paneViewer`), and the terminal dimensions
2. On `tea.WindowSizeMsg`, compute sidebar width as `max(24, termWidth/4)` and viewer width as the remainder; propagate sizes to both sub-models
3. `Tab` (or `Ctrl+→`/`Ctrl+←`) switches focus between panes; only the focused pane receives keyboard events
4. `layout.go`: helper `func SplitHorizontal(left, right string, leftWidth, totalWidth int) string` using lipgloss to join the two rendered strings with a single-character divider
5. Focused pane's border/header is visually distinct (different color or bold label)

**Acceptance criteria:**
- Both panes are visible simultaneously with no overlapping text
- `Tab` moves focus; only the active pane responds to `j`/`k` scroll or tree navigation
- Resizing the terminal redistributes widths without corrupting layout
- Sidebar minimum width is 24 columns; viewer minimum width is 40 columns — if terminal is too narrow, hide the sidebar entirely

---

### Task 4 — Wire directory argument to browser

**Goal:** Detect a directory argument in the CLI and launch `BrowserModel` instead of `viewer.Model`.

**Files:**
- `cmd/emdee/main.go`

**Steps:**
1. In cobra `RunE`, after verifying the argument exists, use `os.Stat` to distinguish file vs directory
2. If directory: call `filetree.Build`, construct `BrowserModel`, start `tea.NewProgram` with `tea.WithAltScreen()`
3. If file: existing Spec 01 flow unchanged
4. If the directory contains zero `.md` files, show an inline notice in the sidebar rather than crashing

**Acceptance criteria:**
- `emdee .` opens the browser on the current working directory
- `emdee /path/to/dir` opens that directory's tree
- An empty directory (no `.md` files) displays a "no Markdown files found" message in the sidebar
- The file viewer flow from Spec 01 is unaffected

---

### Task 5 — Open file from tree into viewer

**Goal:** Selecting a file in the sidebar loads and renders it in the viewer pane, with auto-refresh.

**Files:**
- `internal/tui/browser/model.go`
- `internal/watcher/watcher.go` (extend to support swapping watched path)

**Steps:**
1. `BrowserModel.Update` handles `fileSelectedMsg`: read the file, render it, call `viewer.Model.SetContent(rendered, path)` (add this method to viewer)
2. Stop the previous file watcher (if any) and start a new one for the newly opened path
3. Focus switches to the viewer pane automatically after opening a file
4. `viewer.Model.SetContent` preserves the viewport at the top (new file, fresh scroll position)

**Acceptance criteria:**
- Selecting a file renders its contents in the viewer pane
- Focus moves to the viewer pane; pressing `Tab` returns to the sidebar
- Opening a second file stops watching the first
- A file that fails to read shows an error message in the viewer pane, not a crash

---

### Task 6 — Directory watcher and tree auto-refresh

**Goal:** When files are added to or removed from the watched directory, the sidebar tree updates automatically (within ~1 s). A manual refresh keybinding is also provided.

**Files:**
- `internal/watcher/watcher.go` (directory mode)
- `internal/tui/browser/model.go`

**Steps:**
1. Extend `watcher.go` to accept a directory path: use fsnotify's recursive watch or re-walk on events, debounce with 300 ms timer, emit on `chan struct{}`
2. `BrowserModel` listens for the watcher event, calls `filetree.Build` again, calls `sidebar.SetTree`, preserves cursor position if the previously selected node still exists (match by path)
3. Add keybinding `r` in the sidebar pane for manual refresh (same rebuild path)
4. Watcher is started in `BrowserModel.Init` and closed on program exit

**Acceptance criteria:**
- Creating a new `.md` file in the watched directory adds it to the tree within ~1 s
- Deleting a `.md` file removes it from the tree within ~1 s; if that file was open in the viewer, the viewer shows a "file deleted" notice
- Pressing `r` in the sidebar immediately rebuilds the tree
- Creating non-`.md` files does not trigger a tree rebuild
