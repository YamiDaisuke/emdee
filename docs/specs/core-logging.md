# Spec: Core Logging Infrastructure

Status: draft
Version: v1

## Overview

Establishes a `Logger` type in the `Core` module, moves the canonical `LogLevel` definition out of the `emdee` executable into `Core`, and wires the parsed `--log-level` CLI argument into a `Logger` instance that is passed to renderer modules via dependency injection. Log output is silent by default; it is only emitted when an explicit `LogContext` (`.webServer` or `.tui`) is active. This spec closes the gap between the `--log-level` argument parsed in TASK-03 of `project-setup.md` and the logging convention required by `docs/ARCHITECTURE.md`.

## Functional Requirements

- No direct user-visible FR — this is infrastructure that enables log output in web and TUI modes.

## Technical Requirements

- TR-01: `LogLevel` must be defined in `Core` so that all modules (`Core`, `TUIRenderer`, `WebRenderer`, `emdee`) can reference it without circular dependencies.
- TR-02: The logger must be passed to renderer modules via dependency injection — no global or shared singleton instance.
- TR-03: Log output must be silent unless a `LogContext` (`.webServer` or `.tui`) is active at the point of emission.
- TR-04: Unit tests must cover level filtering, silent-by-default behavior, and output in each active context.

## Tasks

### TASK-01: Define `Logger` type in `Core`

**Description:** Create `Sources/Core/Logger.swift`. Move the `LogLevel` enum from `Sources/emdee/main.swift` into this new file. Define a `Logger` struct that holds the active `LogLevel` and a `LogContext` value. Expose a `log(_:level:file:function:line:)` method where `file`, `function`, and `line` default to `#fileID`, `#function`, and `#line` respectively so callers capture their own context automatically. When output is permitted, emit a structured line of the form `[<ISO8601ms>] [<LEVEL>] [<context>] <fileID>:<line> <function> — <message>`. Update `Sources/emdee/main.swift` to remove its local `LogLevel` definition and use `Core.LogLevel` instead.

**Acceptance Criteria:**
- [ ] `Sources/Core/Logger.swift` exists and declares `LogLevel` (cases: `debug`, `info`, `warning`, `error`) and `LogContext` (cases: `webServer`, `tui`).
- [ ] `Logger` is a struct in `Core` with at minimum: an `init(level:context:)`, and a `log(_:level:)` method.
- [ ] `LogLevel` is no longer defined in `Sources/emdee/main.swift`; the file imports `Core` and uses `Core.LogLevel`.
- [ ] `swift build` succeeds with no errors after the move.
- [ ] No SwiftLint violations are introduced.

**Status:** done

---

### TASK-02: Wire `--log-level` into `Logger` at startup

**Description:** In `Sources/emdee/main.swift`, after argument parsing produces a `ParsedArguments` value, instantiate a `Logger` with the parsed `LogLevel`. Pass the `Logger` instance to renderer modules (TUI or web, as appropriate for the active mode) via their initializers or factory functions — not via a global variable or singleton.

**Acceptance Criteria:**
- [ ] `main.swift` constructs a `Logger` instance immediately after `parseArguments` returns.
- [ ] The `Logger` instance is passed as a parameter to any renderer initializer or setup function that needs it — no global or `static` logger reference is introduced.
- [ ] `swift build` succeeds with no errors.
- [ ] No SwiftLint violations are introduced.

**Status:** todo

---

### TASK-03: Enforce output-visibility rules

**Description:** `Logger.log(_:level:file:function:line:)` must write a structured line to stdout only when its `LogContext` is `.webServer` or `.tui`. When no context is active (i.e., the logger was constructed without a context), the method must produce no output regardless of the message level. The context should be supplied at construction time via `init(level:context:)`.

**Acceptance Criteria:**
- [ ] Calling `log(_:level:)` on a `Logger` constructed without an active context produces no stdout output.
- [ ] Calling `log(_:level:)` on a `Logger` with context `.webServer` writes to stdout when the message level is at or above the active `LogLevel`.
- [ ] Calling `log(_:level:)` on a `Logger` with context `.tui` writes to stdout when the message level is at or above the active `LogLevel`.
- [ ] Messages below the active `LogLevel` are never written, regardless of context.
- [ ] No SwiftLint violations are introduced.

**Status:** todo

---

### TASK-04: Unit tests for `Logger` in `CoreTests`

**Description:** Add test cases in `Tests/CoreTests/` covering the three behavioral properties of `Logger`: level filtering, silent-by-default (no context), and structured output when a context is active. Capture stdout to verify the emitted line format. Use Swift Testing (`@Test`, `#expect`).

**Acceptance Criteria:**
- [ ] A test verifies that a message whose level is below the active `LogLevel` is not emitted (e.g., a `.debug` message when the active level is `.warning`).
- [ ] A test verifies that a `Logger` with no active context produces no output even for a high-severity message.
- [ ] A test verifies that a `Logger` with context `.webServer` emits a line containing the ISO 8601 timestamp, `WARNING` (or relevant level), `webServer`, file, line, function, and message.
- [ ] A test verifies that a `Logger` with context `.tui` emits a line with the same structured fields.
- [ ] `swift test` passes with all new tests green.
- [ ] No SwiftLint violations are introduced.

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | N/A       |
| TASK-02 | N/A       |
| TASK-03 | N/A       |
| TASK-04 | N/A       |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-23 | Initial spec |
