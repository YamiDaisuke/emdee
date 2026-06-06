# Spec: Core: File Watching

Status: draft
Version: v1

## Overview

Implements automatic detection of file and directory changes. When a watched file is modified, the TUI content area refreshes. When files are added or removed from a watched directory, the sidebar tree updates. Provides a platform-specific implementation for macOS (FSEvents via DispatchSource) and Linux (inotify via DispatchSource), behind a shared `FileWatcher` protocol.

## Functional Requirements

- FR-06: Watch for file and directory changes automatically; refresh open file content on change; update file tree on add/remove.

## Technical Requirements

- TR-01: File watching logic lives in `Sources/Core/` — no TUI or rendering dependencies.
- TR-02: macOS uses `DispatchSource` with `DISPATCH_SOURCE_TYPE_VNODE` or FSEvents.
- TR-03: Linux uses `inotify` via `DispatchSource`.
- TR-04: Platform implementations are hidden behind a `FileWatcher` protocol.

## Tasks

### TASK-01: Define FileWatcher protocol

**Description:** In `Sources/Core/`, define a `FileWatcher` protocol with callbacks for three events: file content changed, file added, file removed. The protocol should be initializable with a path to watch and support starting and stopping the watcher.

**Acceptance Criteria:**
- [ ] `FileWatcher` protocol defines `start()`, `stop()`, and callback properties for `onFileChanged`, `onFileAdded`, `onFileRemoved`.
- [ ] The protocol is platform-agnostic — no platform-specific types in the protocol definition.

**Status:** todo

---

### TASK-02: Implement file watcher for macOS

**Description:** Implement `FileWatcher` for macOS using `DispatchSource` (VNODE or FSEvents). The watcher monitors a directory path and fires the appropriate callback when a `.md` file changes, is added, or is removed.

**Acceptance Criteria:**
- [ ] Modifying an existing `.md` file triggers `onFileChanged`.
- [ ] Adding a new `.md` file to the watched directory triggers `onFileAdded`.
- [ ] Deleting a `.md` file from the watched directory triggers `onFileRemoved`.
- [ ] Calling `stop()` stops all callbacks from firing.
- [ ] Compiled and tested on macOS only (Linux build can stub this target).

**Status:** todo

---

### TASK-03: Implement file watcher for Linux

**Description:** Implement `FileWatcher` for Linux using `inotify` via system calls or `DispatchSource`. Same behavioral contract as the macOS implementation.

**Acceptance Criteria:**
- [ ] Modifying an existing `.md` file triggers `onFileChanged`.
- [ ] Adding a new `.md` file to the watched directory triggers `onFileAdded`.
- [ ] Deleting a `.md` file from the watched directory triggers `onFileRemoved`.
- [ ] Calling `stop()` stops all callbacks from firing.
- [ ] Compiled and tested on Linux only (macOS build uses the macOS implementation).

**Status:** todo

---

### TASK-04: Integrate file watcher with TUI

**Description:** Wire the `FileWatcher` into the TUI application. When the currently open file changes, re-render its content in the content area. When files are added or removed, rebuild and re-render the sidebar tree.

**Acceptance Criteria:**
- [ ] Saving a change to the currently open file causes the content area to refresh automatically (no manual reload needed).
- [ ] Adding a new `.md` file to the watched folder causes it to appear in the sidebar tree.
- [ ] Deleting a `.md` file causes it to disappear from the sidebar tree; if it was the open file, the content area shows an appropriate message.
- [ ] No crash or visible flicker on rapid successive file changes.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | de1ca1d7  |
| TASK-02 | 5faa4dea  |
| TASK-03 | 8e269fbe  |
| TASK-04 | 74ab3a43  |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
