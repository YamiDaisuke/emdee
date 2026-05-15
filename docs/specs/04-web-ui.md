# Spec 04 — Web UI

## Phase
Phase 3

## Context
`emdee --web file.md` (or `emdee --web ./docs`) spawns a local HTTP server, opens the system browser, and serves a fully formatted HTML view of the Markdown. All assets — HTML templates, CSS, client-side JS — are embedded in the binary at build time via `go:embed`. No CDN calls, no network requests at runtime. The server renders Markdown to HTML server-side (goldmark) and pushes live updates to the browser via Server-Sent Events (SSE).

This spec covers everything except diagram rendering (covered in Spec 05).

---

## Dependencies

| Library | Purpose |
|---|---|
| `github.com/yuin/goldmark` | Markdown → HTML (same parser from Spec 01) |
| `github.com/yuin/goldmark-highlighting/v2` | Syntax highlighting via chroma (server-side) |
| `github.com/pkg/browser` | Cross-platform browser open |
| `github.com/fsnotify/fsnotify` | File and directory watching (reuse Spec 01 watcher) |
| `net/http` (stdlib) | HTTP server |
| `embed` (stdlib) | Asset embedding |

No frontend framework. The client is plain HTML + CSS + vanilla JS.

---

## Package Layout

```
internal/
  renderer/
    html/
      renderer.go       goldmark HTML renderer with GFM + highlighting
      renderer_test.go

  server/
    server.go           HTTP server: routes, SSE broker, lifecycle
    handlers.go         per-route handler functions
    sse.go              SSE broker (fan-out file/dir change events to clients)

web/
  static/
    style.css           base styles (typography, code blocks, tables, task lists)
    app.js              SSE client, DOM refresh, sidebar tree behavior
  templates/
    base.html           shell: <head>, sidebar slot, content slot
    file.html           single-file page (extends base)
    browser.html        folder-browser page (extends base)
```

All files under `web/` are embedded via a single `//go:embed web` directive in `server/server.go`.

---

## Tasks

---

### Task 1 — HTML renderer package

**Goal:** Render Markdown source to a safe HTML string using goldmark with GFM extensions and server-side syntax highlighting.

**Files:**
- `internal/renderer/html/renderer.go`
- `internal/renderer/html/renderer_test.go`

**Steps:**
1. Configure goldmark with: `extension.GFM`, `extension.Typographer`, `highlighting.NewHighlighting(highlighting.WithStyle("github"))` (chroma style; choose a style that looks good on both light and dark backgrounds, or make it configurable later)
2. Enable `html.WithUnsafe(false)` (default) — raw HTML in Markdown is stripped; this is safe for untrusted files
3. Export `func Render(src []byte) ([]byte, error)` returning rendered HTML bytes
4. Unit tests: H1 → `<h1>`, fenced Go block → output contains `<code class=` with chroma classes, GFM table → `<table>`, task list item → `<input type="checkbox"`, link → `<a href=`

**Acceptance criteria:**
- `Render([]byte("# Hello"))` returns bytes containing `<h1`
- A fenced Go code block produces HTML with chroma syntax classes
- A GFM table produces a `<table>` element
- `Render` does not return an error for any valid Markdown input
- `go test ./internal/renderer/html/...` passes

---

### Task 2 — Embedded static assets and HTML templates

**Goal:** Create the base HTML shell, CSS, and minimal JS stub. Embed them all in the binary.

**Files:**
- `web/templates/base.html`
- `web/templates/file.html`
- `web/templates/browser.html`
- `web/static/style.css`
- `web/static/app.js` (stub — full SSE wiring in Task 5)
- `internal/server/server.go` (embed directive only, no server logic yet)

**Steps:**
1. `base.html`: standard HTML5 shell, `<link>` to `style.css`, `<script>` to `app.js`, a `{{block "sidebar" .}}` slot and a `{{block "content" .}}` slot, using Go `html/template` syntax
2. `file.html`: extends base; content slot renders `{{.Content}}` (pre-rendered HTML); sidebar slot is empty
3. `browser.html`: extends base; sidebar slot renders a `<ul>` tree from `{{.Tree}}`; content slot renders the selected file or a "select a file" placeholder
4. `style.css`: clean readable typography (system font stack), distinct styles for headings/code/blockquotes/tables/task-list checkboxes, responsive width (max ~800 px for content)
5. `app.js`: empty module stub with a `// TODO: SSE` comment
6. In `server.go`, add `//go:embed web` and declare `var webFS embed.FS`; write a test that calls `webFS.Open("web/templates/base.html")` and asserts no error

**Acceptance criteria:**
- `go build ./...` succeeds with the embed directive
- `webFS.Open("web/templates/base.html")` returns no error in tests
- `webFS.Open("web/static/style.css")` returns no error in tests
- The HTML templates are valid (parseable by `html/template.ParseFS`)
- `go test ./internal/server/...` passes

---

### Task 3 — HTTP server: single-file mode

**Goal:** `GET /` serves the rendered Markdown HTML for the file provided at startup.

**Files:**
- `internal/server/server.go`
- `internal/server/handlers.go`

**Steps:**
1. `server.go`: define `Config` struct (`FilePath string`, `DirPath string`, `Port int`)
2. `func New(cfg Config) *http.ServeMux`: register routes, return mux (not started)
3. `func Run(ctx context.Context, cfg Config) error`: create mux, start `http.Server` on `127.0.0.1:<port>`, return when `ctx` is cancelled (use `server.Shutdown`)
4. `handlers.go`: `fileHandler` reads the file at `cfg.FilePath`, calls `html.Render`, executes `file.html` template with `struct{ Content template.HTML }`
5. Route `GET /static/` serves embedded static files from `web/static/` via `http.FileServerFS`
6. Port default: 4242; if the port is already in use, increment by 1 up to 10 times and log the chosen port

**Acceptance criteria:**
- `GET /` returns HTTP 200 with `Content-Type: text/html`
- The response body contains the rendered Markdown (e.g., `<h1>` for a top-level heading)
- `GET /static/style.css` returns the embedded CSS with `Content-Type: text/css`
- If the Markdown file does not exist, `GET /` returns HTTP 500 with a plain error message (not a panic)
- `go test ./internal/server/... -run TestFileHandler` passes

---

### Task 4 — HTTP server: folder-browser mode

**Goal:** When started in directory mode, the sidebar shows the `.md` file tree and `GET /file?path=...` loads a selected file's content into the main pane without a full page reload.

**Files:**
- `internal/server/handlers.go`
- `web/templates/browser.html`
- `web/static/app.js`

**Steps:**
1. On startup in directory mode, call `filetree.Build(cfg.DirPath)` to build the initial tree
2. `GET /` serves `browser.html` with the tree serialised to a `[]TreeNode` template variable; the sidebar renders it as a nested `<ul>` with `<a href="#" data-path="...">` links for files and toggle buttons for directories
3. `GET /file?path=<abs-path>`: validate that the requested path is under `cfg.DirPath` (path traversal guard), render the file, return the HTML fragment (no full page template — just the article content)
4. `app.js`: intercept sidebar link clicks, `fetch("/file?path=...")`, replace the content `<article>` innerHTML with the response, update the browser URL via `history.pushState`
5. Directory toggle clicks expand/collapse `<ul>` children (pure DOM, no server round-trip)

**Acceptance criteria:**
- `GET /` in directory mode returns HTTP 200 with a sidebar containing `.md` filenames
- `GET /file?path=/abs/path/to/file.md` returns an HTML fragment (not a full page) for a valid path
- `GET /file?path=../../etc/passwd` returns HTTP 400 (path traversal blocked)
- `GET /file?path=...` for a `.go` file (outside allowed types) returns HTTP 400
- Clicking a file in the browser sidebar loads its content without a full page reload (manual browser test)

---

### Task 5 — SSE live reload

**Goal:** When the watched file or directory changes, the browser updates without a manual refresh.

**Files:**
- `internal/server/sse.go`
- `internal/server/handlers.go`
- `web/static/app.js`

**Steps:**
1. `sse.go`: `Broker` struct with a `clients` map (channel per connected client), `Subscribe() <-chan string`, `Unsubscribe(ch)`, `Publish(event string)`; goroutine-safe via a mutex or a dispatch goroutine
2. `GET /events`: SSE endpoint; writes `data: <event>\n\n` to the response; flushes after each write; removes client from broker on disconnect
3. Wire the fsnotify watcher (reuse Spec 01 watcher) to call `broker.Publish("reload")` on file change, `broker.Publish("tree")` on directory change
4. `app.js`: `new EventSource("/events")`; on `reload` event, `fetch` the current file and replace article content; on `tree` event, `fetch("/")` and replace sidebar innerHTML
5. SSE response sets `Cache-Control: no-cache` and `Connection: keep-alive`

**Acceptance criteria:**
- Editing the open file updates the browser content within ~1 s without a manual refresh
- Adding or removing a `.md` file from the watched directory updates the sidebar within ~1 s
- Closing the browser tab does not leave a leaked goroutine (verified by test with `goleak` or manual check)
- If no browser is connected, `Publish` does not block or panic
- `go test ./internal/server/... -run TestSSE` passes

---

### Task 6 — `--web` flag and browser launch

**Goal:** Wire the `--web` flag in the CLI, start the server, open the browser, and shut down cleanly on Ctrl+C.

**Files:**
- `cmd/emdee/main.go`

**Steps:**
1. Add `--web` boolean flag to the cobra root command; add `--port` int flag (default 4242)
2. In `RunE`: if `--web` is set, build `server.Config` from the resolved path (file or directory) and port, call `server.Run` in a goroutine
3. After the server starts (add a small ready-check: attempt a `GET /` with a 2 s timeout in a loop), call `browser.OpenURL(fmt.Sprintf("http://127.0.0.1:%d", port))`
4. Block on `os.Signal` (SIGINT, SIGTERM); cancel the server context on signal; wait for `Run` to return before exiting
5. Log the listening address to stderr before opening the browser so users can open it manually if the auto-open fails

**Acceptance criteria:**
- `emdee --web file.md` starts the server, opens the browser (or logs the URL if opening fails), and exits cleanly on Ctrl+C
- `emdee --web --port 9090 file.md` listens on port 9090
- If the port is in use, the server picks the next available port and logs it
- `emdee --web ./docs` starts in folder-browser mode
- Ctrl+C exits with code 0 within 2 s (graceful shutdown)
