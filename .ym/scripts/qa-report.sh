#!/bin/bash
# Scans all specs in docs/specs/
# Prints table: Spec | Tasks Done | Tasks Total | QA Status

SPECS_DIR="docs/specs"

if [ ! -d "$SPECS_DIR" ]; then
  echo "Error: $SPECS_DIR not found"
  exit 1
fi

printf "%-30s %10s %11s %10s\n" "Spec" "Tasks Done" "Tasks Total" "QA Status"
printf "%-30s %10s %11s %10s\n" "----" "----------" "-----------" "---------"

for spec in "$SPECS_DIR"/*.md; do
  [ -f "$spec" ] || continue
  name=$(basename "$spec" .md)
  total=$(grep -c "^\*\*Status:\*\*" "$spec" || true)
  done=$(grep -c "^\*\*Status:\*\* done" "$spec" || true)
  qa_status=$(grep "^Status:" "$spec" | head -1 | awk '{print $2}')
  printf "%-30s %10s %11s %10s\n" "$name" "$done" "$total" "$qa_status"
done
