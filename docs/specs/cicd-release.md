# Spec: CI/CD & Release

Status: draft
Version: v1

## Overview

Sets up the GitHub Actions pipeline and release process for `emdee`. Tests run on tag push only. A release is triggered by a manual version tag, which builds macOS and Linux binaries and publishes a GitHub Release with the binaries attached. Includes a Homebrew formula stub for future distribution.

## Functional Requirements

- NFR-01: Must run on macOS and Linux.

## Technical Requirements

- TR-01: CI/CD via GitHub Actions.
- TR-02: Test workflow triggers on version tag push only.
- TR-03: Release workflow builds separate binaries per platform (macOS runner, Ubuntu runner).
- TR-04: Homebrew formula stub lives in the repository.

## Tasks

### TASK-01: GitHub Actions test workflow

**Description:** Create `.github/workflows/test.yml` that triggers on version tag pushes (e.g., `v*`). The workflow runs `swift test` on both a macOS runner and an Ubuntu runner.

**Acceptance Criteria:**
- [ ] `.github/workflows/test.yml` exists and is valid YAML.
- [ ] Workflow triggers on tags matching `v*` only (not on every push or PR).
- [ ] Workflow runs `swift test` on a macOS runner.
- [ ] Workflow runs `swift test` on an Ubuntu runner.
- [ ] A failing test causes the workflow to fail.

**Status:** todo

---

### TASK-02: GitHub Actions release workflow

**Description:** Create `.github/workflows/release.yml` that triggers on version tag pushes. After tests pass, it builds the `emdee` binary for macOS and Linux in release configuration, then creates a GitHub Release with both binaries attached as assets.

**Acceptance Criteria:**
- [ ] `.github/workflows/release.yml` exists and is valid YAML.
- [ ] Workflow triggers on tags matching `v*`.
- [ ] macOS binary is built with `swift build -c release` on a macOS runner and named `emdee-macos`.
- [ ] Linux binary is built with `swift build -c release` on an Ubuntu runner and named `emdee-linux`.
- [ ] A GitHub Release is created with the tag name as the title.
- [ ] Both binaries are attached to the GitHub Release as downloadable assets.
- [ ] Release workflow runs only after test workflow passes (via `needs` or workflow dependency).

**Status:** todo

---

### TASK-03: Homebrew formula stub

**Description:** Create a Homebrew formula file at `Formula/emdee.rb` as a stub for future Homebrew tap distribution. The formula should reference the GitHub Releases download URL pattern and include install instructions.

**Acceptance Criteria:**
- [ ] `Formula/emdee.rb` exists with a valid Ruby formula structure.
- [ ] Formula references the GitHub Releases URL pattern for the macOS binary.
- [ ] Formula includes a `test` block that runs `emdee --help` or equivalent.
- [ ] Formula is syntactically valid (`brew audit --strict Formula/emdee.rb` passes, or equivalent offline check).

**Status:** todo

---

## Ticket Tracker

| Task    | Ticket ID |
|---------|-----------|
| TASK-01 | ede159f8  |
| TASK-02 | ac830520  |
| TASK-03 | 40afea0c  |

## Revision History

| Version | Date       | Summary      |
|---------|------------|--------------|
| v1      | 2026-05-22 | Initial spec |
