#!/bin/bash
# Scans all specs in docs/specs/
# Prints the first task with status: todo
# Format: [spec-file] TASK-XX: description

SPECS_DIR="docs/specs"

if [ ! -d "$SPECS_DIR" ]; then
  echo "Error: $SPECS_DIR not found"
  exit 1
fi

for spec in "$SPECS_DIR"/*.md; do
  [ -f "$spec" ] || continue
  task=$(grep -B5 "^\*\*Status:\*\* todo" "$spec" | grep "^### TASK-" | tail -1)
  if [ -n "$task" ]; then
    title=$(echo "$task" | sed 's/^### //')
    echo "[$spec] $title"
    exit 0
  fi
done

echo "No tasks with status: todo"
