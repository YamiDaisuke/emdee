# Requirements: emdee

## Project Vision & Problem Statement

`emdee` is a terminal-based markdown visualizer for projects with heavy markdown documentation (e.g., SDD/Software Design Document projects). Plain markdown is difficult to read raw in a terminal. `emdee` solves this by rendering markdown files directly in the terminal with proper font styles, tables, and diagrams — making documentation readable without leaving the command line.

## Target Users

- Developers and technical writers working on markdown-heavy projects (e.g., SDD documentation, wikis, READMEs).
- Their goal: read and navigate markdown documentation clearly without leaving the terminal.

## Functional Requirements

- FR-01: Render a single markdown file in the terminal with proper font styles (bold, italic, headers, code blocks), and tables.
- FR-02: Accept a folder path and recursively discover all `.md` files within it.
- FR-03: Display a navigable file tree in a sidebar alongside the rendering area using a full TUI; selecting a file replaces the rendered content.
- FR-04: Support a `--web` (or similar) mode that starts a local web server and serves the markdown files in a browser, with the same tree + rendering layout.
- FR-05: In web mode, render Mermaid diagrams. Mermaid rendering in terminal mode is out of scope for v1.
- FR-06: Watch for file and directory changes automatically; if the currently open file changes, refresh its rendered content; if files are added or removed, update the file tree.
- FR-07: Accept piped input (e.g., `cat file.md | emdee`) and render the content directly — no sidebar or file tree in this mode.

## Non-Functional Requirements

- NFR-01: Must run on macOS and Linux.
- NFR-02: File rendering and file-watch refresh should feel instant (no perceptible lag for typical markdown files).
- NFR-03: No specific accessibility requirements for v1.

## Out of Scope

- Windows support
- Mermaid rendering in terminal mode
- Authentication or access control for the web server
- Editing markdown files (read-only tool)
- Piped input directing to a full TUI session (piped input renders inline only — no sidebar or file tree)

## Constraints & Dependencies

- Written in Swift.
- Minimize third-party dependencies; only introduce them when the implementation complexity would be unreasonably high without one.
- No specific deadline for v1.

## Success Criteria

- A user can point `emdee` at any markdown-heavy project and navigate its files via a TUI or browser interface.
- Markdown is rendered clearly — headers, bold/italic, code blocks, and tables display correctly in both modes.
- Mermaid diagrams render correctly in web mode.
- File changes are reflected automatically without manual refresh.
