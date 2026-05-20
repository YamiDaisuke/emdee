# Architecture: emdee

## Tech Stack

- Language: Swift
- Build system: Swift Package Manager (SPM)
- TUI: `swift-tui` (third-party — justified by TUI complexity)
- Web server: Foundation's built-in networking (no additional dependency)
- Markdown parsing: `swift-markdown` (Apple)

## Repository & Code Organization

Single repository, SPM layout:

```
Sources/
  emdee/          # CLI entry point, argument parsing
  Core/           # Markdown parsing, file watching, shared models
  TUIRenderer/    # Terminal rendering and TUI layout
  WebRenderer/    # Web server, JSON API, and embedded browser assets
Tests/
  CoreTests/
  TUIRendererTests/
  WebRendererTests/
```

## Data Model Overview

No persistent storage — all state is in-memory.

Key entities:
- `MarkdownDocument` — parsed representation of a single `.md` file (produced by `swift-markdown`)
- `FileNode` — a file or directory entry used to build the navigation tree
- `AppState` — current open file, selected tree node, active rendering mode (TUI or web)

## API / Integration Patterns

Web mode uses a JSON API + client-side rendering approach:
- The Swift server exposes a JSON API: file tree listing and raw markdown content per file.
- A static HTML shell + JavaScript frontend handles markdown rendering and Mermaid diagram rendering in the browser.
- Live refresh is delivered via SSE (Server-Sent Events) — server pushes change notifications to the browser when files change.
- All HTML, CSS, and JS assets are embedded in the binary at build time using SPM's `embedInCode` resource rule — no external files required at runtime.

No external API integrations.

## Auth & Security Approach

- Web server binds to `127.0.0.1` only — never exposed to the network.
- No authentication or authorization.
- No secrets management.

## Testing Strategy

- Unit tests only — no automated TUI or end-to-end tests.
- Core module (markdown parsing, file tree, file watching) is the primary test target.
- Web API: contract tests to verify the JSON schema remains stable and consistent with what the JS frontend expects.
- No specific coverage threshold — reasonable coverage on business logic.
- Tooling: Swift Testing (built-in).

## Deployment & Environments

- Distribution: Homebrew formula + direct binary download via GitHub Releases.
- CI/CD: GitHub Actions, triggered only on version tags.
- Release pipeline (on tag push):
  1. Run unit tests
  2. Build binaries for macOS and Linux (separate runner per platform)
  3. Publish GitHub Release with binaries attached
- No dev/staging environments — local builds only during development.

## Conventions & Style Rules

- Naming: standard Swift conventions — camelCase for variables/functions, PascalCase for types.
- Error handling: `throws` / `try` — no `Result` wrapping unless async context requires it.
- Logging: a simple internal logger utility with a log level settable via CLI argument. Logs are only visible in two contexts: web server mode (output to stdout) and TUI mode (via an optional debug panel). Silent in all other contexts.
- Formatting: SwiftLint enforced — violations fail CI.
