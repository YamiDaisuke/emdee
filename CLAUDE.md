# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**emdee** is a Go-based Markdown visualizer.

## Common Commands

```bash
# Build
go build ./...

# Run tests
go test ./...

# Run a single test
go test ./path/to/package -run TestName

# Run tests with coverage
go test -cover ./...

# Format code
go fmt ./...

# Vet code
go vet ./...

# Tidy dependencies
go mod tidy
```

## Architecture

This project is in its initial stages — no source code exists yet. As the codebase grows, document the architecture here:

- The main entry point will likely be `cmd/emdee/main.go`
- Core markdown parsing/rendering logic should live in internal packages
