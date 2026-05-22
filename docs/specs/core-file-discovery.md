# Spec: Core: File Discovery & Tree

Status: draft
Version: v1

## Overview

Implements recursive `.md` file discovery and the `FileNode` model that represents a folder's file tree in memory. This is the data foundation for TUI folder navigation and web mode — both consume the `FileNode` tree produced here.

## Functional Requirements

- FR-02: Accept a folder path and recursively discover all `.md` files within it.

## Technical Requirements

- TR-01: Discovery and model live in `Sources/Core/` — no UI or rendering dependencies.
- TR-02: Uses Foundation's `FileManager` for directory traversal.

## Tasks

### TASK-01: Implement recursive .md file discovery

**Description:** In `Sources/Core/`, implement a function that accepts a folder path and returns all `.md` files found recursively, sorted by path. Hidden directories (prefixed with `.`) should be skipped.

**Acceptance Criteria:**
- [ ] Given a folder, returns all `.md` files found at any depth.
- [ ] Results are sorted alphabetically by file path.
- [ ] Hidden directories (e.g., `.git`, `.build`) are excluded from traversal.
- [ ] A path that is not a directory throws an error.
- [ ] An empty directory returns an empty array (no crash).

**Status:** todo

---

### TASK-02: Define FileNode model

**Description:** In `Sources/Core/`, define a `FileNode` enum or struct representing either a file (leaf) or a directory (branch with children). It should hold the node's name, full path, and children (for directories).

**Acceptance Criteria:**
- [ ] `FileNode` can represent a file with a name and full path.
- [ ] `FileNode` can represent a directory with a name, full path, and an ordered list of child `FileNode`s.
- [ ] `FileNode` is `Equatable` and `Identifiable`.

**Status:** todo

---

### TASK-03: Build FileNode tree from discovery results

**Description:** Implement a function that takes the flat list of discovered `.md` file paths and constructs a `FileNode` tree reflecting the actual directory hierarchy.

**Acceptance Criteria:**
- [ ] Given a folder with nested subdirectories and `.md` files, the resulting `FileNode` tree mirrors the directory structure.
- [ ] Directory nodes appear before file nodes at each level.
- [ ] Files at the root of the given folder appear directly under the root node.
- [ ] Unit tests cover a multi-level nested structure.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |
| TASK-03 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
