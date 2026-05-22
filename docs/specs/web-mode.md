# Spec: Web Mode

Status: draft
Version: v1

## Overview

Implements the `--web` mode: a local HTTP server (Foundation-based) that serves a browser UI for navigating and reading markdown files. The server exposes a JSON API for the file tree and file content, pushes live-reload events via SSE, and serves an embedded HTML/JS/CSS frontend. All assets are compiled into the binary via SPM `embedInCode`. Mermaid diagrams are rendered client-side in the browser.

## Functional Requirements

- FR-04: Support a `--web` mode that starts a local web server and serves markdown files in a browser.
- FR-05: In web mode, render Mermaid diagrams.
- FR-06: File changes are reflected automatically in the browser (via SSE).

## Technical Requirements

- TR-01: HTTP server uses Foundation's built-in networking — no third-party server dependency.
- TR-02: Server binds to `127.0.0.1` only.
- TR-03: Frontend assets (HTML, CSS, JS) are embedded in the binary via SPM `embedInCode`.
- TR-04: Live reload uses SSE (Server-Sent Events), not WebSocket.
- TR-05: All web logic lives in `Sources/WebRenderer/`.

## Tasks

### TASK-01: Implement Foundation HTTP server

**Description:** In `Sources/WebRenderer/`, implement a basic HTTP server using Foundation that listens on `127.0.0.1` with a configurable port (default: 7777). The server must handle concurrent requests and route them to registered handlers.

**Acceptance Criteria:**
- [ ] Server starts and listens on `127.0.0.1:7777` by default.
- [ ] Port is configurable via a CLI flag (e.g., `--port`).
- [ ] Server handles at least 5 concurrent connections without deadlocking.
- [ ] Server shuts down cleanly when the process receives SIGINT (Ctrl+C).

**Status:** todo

---

### TASK-02: GET /api/tree — file tree JSON endpoint

**Description:** Implement a `GET /api/tree` handler that returns the `FileNode` tree for the watched folder as JSON.

**Acceptance Criteria:**
- [ ] `GET /api/tree` returns a JSON response with `Content-Type: application/json`.
- [ ] The JSON structure reflects the `FileNode` tree (name, path, type, children).
- [ ] Response schema: `{ "name": string, "path": string, "type": "file"|"directory", "children": [...] }`.
- [ ] An empty folder returns a valid JSON response with an empty children array.

**Status:** todo

---

### TASK-03: GET /api/file — file content JSON endpoint

**Description:** Implement a `GET /api/file?path=...` handler that returns the raw markdown content of the specified file as JSON.

**Acceptance Criteria:**
- [ ] `GET /api/file?path=relative/path.md` returns `{ "path": string, "content": string }`.
- [ ] Path is relative to the root folder being served.
- [ ] Requesting a path outside the root folder returns a 403 response.
- [ ] Requesting a non-existent file returns a 404 response.
- [ ] Contract tests verify the JSON schema matches what the frontend expects.

**Status:** todo

---

### TASK-04: GET /events — SSE endpoint for live reload

**Description:** Implement a `GET /events` SSE endpoint. When the `FileWatcher` fires a change event, the server sends an event to all connected SSE clients identifying the changed file.

**Acceptance Criteria:**
- [ ] `GET /events` responds with `Content-Type: text/event-stream`.
- [ ] When a watched `.md` file changes, a `file-changed` event is sent to all connected clients with the file path as data.
- [ ] When a file is added or removed, a `tree-changed` event is sent.
- [ ] Clients that disconnect are cleaned up (no memory leak from dead connections).

**Status:** todo

---

### TASK-05: Build HTML/JS/CSS frontend

**Description:** Build a static frontend (single HTML file + JS + CSS) that renders the sidebar file tree and markdown content area. The frontend fetches the file tree from `/api/tree`, renders selected file content from `/api/file`, connects to `/events` for live reload, and renders Mermaid diagrams client-side using the Mermaid JS library (loaded from the embedded assets).

**Acceptance Criteria:**
- [ ] On load, the sidebar displays the file tree fetched from `/api/tree`.
- [ ] Clicking a file in the sidebar fetches its content from `/api/file` and renders it as markdown.
- [ ] Markdown is rendered with headers, bold, italic, code blocks, tables styled correctly.
- [ ] Mermaid diagrams in markdown are rendered as SVG in the browser.
- [ ] When a `file-changed` SSE event arrives for the open file, the content area reloads automatically.
- [ ] When a `tree-changed` SSE event arrives, the sidebar reloads the tree.

**Status:** todo

---

### TASK-06: Embed frontend assets in binary

**Description:** Configure SPM to embed the HTML, CSS, and JS frontend files into the binary using the `embedInCode` resource rule. The server must serve these assets from memory at runtime — no external files required.

**Acceptance Criteria:**
- [ ] `swift build` embeds the frontend assets into the binary.
- [ ] The server serves the HTML shell, CSS, and JS from embedded data (not the filesystem).
- [ ] A freshly copied binary (with no accompanying files) serves the frontend correctly.

**Status:** todo

---

### TASK-07: Wire web mode to CLI

**Description:** Update the CLI entry point so that `emdee path/to/folder --web` starts the web server, prints the local URL to stdout, and keeps the process running until interrupted.

**Acceptance Criteria:**
- [ ] `emdee path/to/folder --web` starts the server and prints `Serving at http://127.0.0.1:7777` (or configured port).
- [ ] Opening the printed URL in a browser shows the frontend with the file tree.
- [ ] Ctrl+C shuts down the server cleanly.
- [ ] Providing a single file path with `--web` uses the file's parent directory as the root.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |
| TASK-03 | N/A       |
| TASK-04 | N/A       |
| TASK-05 | N/A       |
| TASK-06 | N/A       |
| TASK-07 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
