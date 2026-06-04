#!/bin/bash
# Scans all specs in docs/specs/
# For each spec, reads tasklin IDs from the Ticket Tracker table and counts Done vs total
# Prints table: Spec | Tasks Done | Tasks Total | QA Status

SPECS_DIR="docs/specs"
TICKETS_DIR=".todo/tickets"

if [ ! -d "$SPECS_DIR" ]; then
  echo "Error: $SPECS_DIR not found"
  exit 1
fi

if [ ! -d "$TICKETS_DIR" ]; then
  echo "Error: .todo/tickets/ not found. Run 'tasklin init' first."
  exit 1
fi

printf "%-30s %10s %11s %10s\n" "Spec" "Tasks Done" "Tasks Total" "QA Status"
printf "%-30s %10s %11s %10s\n" "----" "----------" "-----------" "---------"

for spec in "$SPECS_DIR"/*.md; do
  [ -f "$spec" ] || continue
  name=$(basename "$spec" .md)
  qa_status=$(grep "^Status:" "$spec" | head -1 | awk '{print $2}')

  done_count=0
  total_count=0

  while IFS= read -r tid; do
    [ -z "$tid" ] && continue
    total_count=$((total_count + 1))
    ticket_file="$TICKETS_DIR/$tid.yaml"
    if [ -f "$ticket_file" ] && grep -q "^status: Done" "$ticket_file"; then
      done_count=$((done_count + 1))
    fi
  done < <(grep -E "^\| TASK-[0-9]+" "$spec" | awk -F'|' '{gsub(/ /,"",$3); print $3}')

  printf "%-30s %10s %11s %10s\n" "$name" "$done_count" "$total_count" "$qa_status"
done
