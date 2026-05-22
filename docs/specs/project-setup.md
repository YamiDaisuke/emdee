# Spec: Project Setup

Status: draft
Version: v1

## Overview

Establishes the SPM package structure, third-party dependencies, SwiftLint enforcement, and CLI entry point for `emdee`. This spec is the foundation all other specs build on — no feature work begins until `swift build` passes, SwiftLint is wired up, and the CLI parses its arguments correctly.

## Functional Requirements

- All FRs depend on this foundation (no direct FR mapping — this is infrastructure).

## Technical Requirements

- TR-01: Package targets must match the module layout in `docs/ARCHITECTURE.md`: `emdee`, `Core`, `TUIRenderer`, `WebRenderer`, plus corresponding test targets.
- TR-02: Dependencies: `swift-tui` (TUI), `swift-markdown` (parsing). No other third-party dependencies.
- TR-03: SwiftLint violations must fail the build.
- TR-04: CLI argument parsing must handle: positional path (file or folder), `--web` flag, `--log-level` flag.

## Tasks

### TASK-01: Initialize SPM package structure

**Description:** Create `Package.swift` declaring all targets (`emdee`, `Core`, `TUIRenderer`, `WebRenderer`) and their corresponding test targets (`CoreTests`, `TUIRendererTests`, `WebRendererTests`). Add `swift-tui` and `swift-markdown` as package dependencies. Add a minimal stub source file in each target so `swift build` completes without errors.

**Acceptance Criteria:**
- [ ] `Package.swift` declares all four library/executable targets and three test targets.
- [ ] `swift-tui` and `swift-markdown` are listed as dependencies and resolve correctly (`swift package resolve`).
- [ ] `swift build` succeeds with no errors.
- [ ] `swift test` runs (zero tests is acceptable at this stage).

**Status:** todo

---

### TASK-02: Configure SwiftLint

**Description:** Add a `.swiftlint.yml` at the repo root with standard Swift convention rules. Integrate SwiftLint so it runs as part of the build and violations cause a build failure.

**Acceptance Criteria:**
- [ ] `.swiftlint.yml` exists at the repo root with at minimum: `opt_in_rules`, `line_length`, `trailing_whitespace`, and `force_cast` configured.
- [ ] Introducing a known violation (e.g., a `force_cast`) causes `swift build` to fail with a SwiftLint error.
- [ ] Removing the violation restores a clean build.

**Status:** todo

---

### TASK-03: Implement CLI argument parsing

**Description:** In `Sources/emdee/`, implement argument parsing for the three inputs: a positional path argument (single `.md` file or folder), a `--web` flag, and a `--log-level` flag (accepted values: `debug`, `info`, `warning`, `error`; default: `error`). No rendering logic yet — parse arguments and print a summary of what was received. Print a usage message and exit with a non-zero code on invalid input.

**Acceptance Criteria:**
- [ ] `emdee path/to/file.md` parses correctly and prints the resolved path and mode (single file, TUI).
- [ ] `emdee path/to/folder` parses correctly and prints the resolved path and mode (folder, TUI).
- [ ] `emdee path/to/folder --web` parses correctly and prints the resolved path and mode (folder, web).
- [ ] `emdee --log-level debug path/to/file.md` parses correctly and prints the log level.
- [ ] `emdee` with no arguments prints a usage message and exits with a non-zero code.
- [ ] `emdee --log-level invalid path/to/file.md` prints an error and exits with a non-zero code.

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
