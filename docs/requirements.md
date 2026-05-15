# Requirements

## Overview

**emdee** is a Go-based Markdown visualizer. It reads Markdown input and renders a visual representation in the terminal or another output target.

---

## Functional Requirements

### Core

- [ ] Parse standard Markdown (CommonMark spec)
- [ ] Render headings, paragraphs, bold, italic, and strikethrough text
- [ ] Render fenced and inline code blocks with syntax highlighting
- [ ] Render ordered and unordered lists (including nested lists)
- [ ] Render blockquotes
- [ ] Render horizontal rules
- [ ] Render links and images (with fallback text for non-graphical output)
- [ ] Render tables (GitHub Flavored Markdown)
- [ ] Render task lists (GFM checkbox syntax)

### Input

- [ ] Read Markdown from a file path supplied as a CLI argument
- [ ] Read Markdown from stdin when no file argument is given

### Output

- [ ] Write rendered output to stdout by default
- [ ] Support an `-o` / `--output` flag to write to a file

### CLI

- [ ] Provide a `--help` flag with usage information
- [ ] Provide a `--version` flag
- [ ] Exit with a non-zero status code on error

---

## Non-Functional Requirements

- [ ] Written in Go; targets Go 1.21+
- [ ] No CGO dependencies
- [ ] Single self-contained binary output
- [ ] Render a 1 000-line Markdown document in under 500 ms on commodity hardware
- [ ] Passes `go vet` and `go fmt` without warnings

---

## Out of Scope (v1)

- GUI or browser-based rendering
- Editing or live-preview mode
- Markdown extensions beyond CommonMark + GFM
