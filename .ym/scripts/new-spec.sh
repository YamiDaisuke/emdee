#!/bin/bash
# Usage: ./new-spec.sh <feature-slug>
# - Creates docs/specs/<feature-slug>.md from SPEC.md template
# - Adds status: draft header

set -e

if [ -z "$1" ]; then
  echo "Error: feature slug required"
  echo "Usage: $0 <feature-slug>"
  exit 1
fi

SLUG="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$(dirname "$SCRIPT_DIR")/templates/SPEC.md"
OUTPUT="docs/specs/${SLUG}.md"

if [ ! -f "$TEMPLATE" ]; then
  echo "Error: SPEC.md template not found at $TEMPLATE"
  exit 1
fi

if [ -f "$OUTPUT" ]; then
  echo "Error: $OUTPUT already exists"
  exit 1
fi

mkdir -p docs/specs
TODAY=$(date +%Y-%m-%d)
sed "s/{DATE}/$TODAY/g" "$TEMPLATE" > "$OUTPUT"
echo "Created: $OUTPUT"
