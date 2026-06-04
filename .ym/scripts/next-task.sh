#!/bin/bash
# Prints the earliest-created To Do ticket in tasklin (ordered by created_at)
# Format: #<id> <title>

TICKETS_DIR=".todo/tickets"

if [ ! -d "$TICKETS_DIR" ]; then
  echo "Error: .todo/tickets/ not found. Run 'tasklin init' first."
  exit 1
fi

# For each To Do ticket, emit: created_at<TAB>id<TAB>title
# ISO 8601 timestamps sort lexicographically, so plain sort gives chronological order.
result=$(for f in "$TICKETS_DIR"/*.yaml; do
  [ -f "$f" ] || continue
  grep -q "^status: To Do" "$f" || continue
  id=$(grep "^id:" "$f" | awk '{print $2}')
  title=$(grep "^title:" "$f" | sed "s/^title: //; s/^'//; s/'$//")
  created=$(grep "^created_at:" "$f" | awk '{print $2}')
  printf "%s\t%s\t%s\n" "$created" "$id" "$title"
done | sort | head -1)

if [ -z "$result" ]; then
  echo "No tickets with status: To Do"
  exit 0
fi

id=$(printf "%s" "$result" | awk -F'\t' '{print $2}')
title=$(printf "%s" "$result" | awk -F'\t' '{print $3}')
echo "#$id $title"
