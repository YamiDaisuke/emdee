#!/bin/bash
# Usage: ./migrate-versioning.sh
# - Adds Version: v1 header and Revision History section to existing docs
#   that were created before spec versioning was introduced.
# - Safe to run multiple times (skips files that already have Version:).

set -e

TODAY=$(date +%Y-%m-%d)

migrate_file() {
  local FILE="$1"
  local LABEL="$2"

  if grep -q "^Version:" "$FILE"; then
    echo "Skipped (already versioned): $FILE"
    return
  fi

  # Insert blank line + "Version: v1" after the first heading (line 1)
  sed -i '' "1a\\
\\
Version: v1
" "$FILE"

  # Append Revision History at end of file
  printf '\n## Revision History\n\n| Version | Date       | Summary              |\n|---------|------------|----------------------|\n| v1      | %s | Initial %s   |\n' \
    "$TODAY" "$LABEL" >> "$FILE"

  echo "Migrated: $FILE"
}

[ -f docs/REQUIREMENTS.md ] && migrate_file docs/REQUIREMENTS.md "requirements"
[ -f docs/ARCHITECTURE.md ] && migrate_file docs/ARCHITECTURE.md "architecture"

for SPEC in docs/specs/*.md; do
  [ -f "$SPEC" ] && migrate_file "$SPEC" "spec"
done

echo "Done. Review changes with: git diff"
echo "Commit with: git add docs/ && git commit -m 'docs: add versioning headers to existing documents'"
