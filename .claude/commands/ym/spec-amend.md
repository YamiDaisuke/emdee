---
description: Amend an existing spec, requirements, or architecture document — bumps version, records change in Revision History, and notifies affected agents.
---

# spec-amend

**Used by:** Scrum Master (spec files), Architect (REQUIREMENTS.md and ARCHITECTURE.md)

## When to use

Use when any of the following must change in an existing document:
- An acceptance criterion is added, changed, or removed (spec)
- A task is added, removed, or its scope changes (spec)
- A functional or non-functional requirement is added, changed, or removed (REQUIREMENTS.md)
- A success criterion changes (REQUIREMENTS.md)
- A tech stack decision, data model, API pattern, auth approach, or convention changes (ARCHITECTURE.md)

Do NOT use for: task status updates, ticket ID corrections, typo fixes that preserve meaning.

## Input

- The document to amend
- Description of the requested change

## Process

1. Identify the exact change and which document is affected. If multiple documents must change (e.g., a new FR also requires a spec update), handle each as a separate amendment in sequence.

2. Determine whether a version bump is required. Rule: does this change cause a Developer to implement something different, or cause QA to re-test something already accepted? Yes → bump. No → edit without bumping.

3. Confirm with the user before editing. Present:
   - What will change (specific section or lines)
   - Whether the version will bump, and to what (e.g., "v2 → v3")
   - The one-line Revision History summary you will add
   Wait for confirmation.

4. Make the edit to the document body.

5. If bumping: update the `Version:` field in the header.

6. If bumping: append a row to `## Revision History`. Format:
   `| v{N} | {YYYY-MM-DD} | {one-line summary referencing IDs (TASK-XX, FR-XX, TR-XX)} |`

7. Notify dependent agents:
   - Spec amended → notify Scrum Master. If any tasks are in-progress and affected by the change, notify the Developer explicitly.
   - REQUIREMENTS.md amended → notify Architect to assess whether ARCHITECTURE.md needs updating; notify Scrum Master to assess which specs reference the changed requirements.
   - ARCHITECTURE.md amended → notify Scrum Master to assess whether in-progress specs need technical requirement updates.

8. Commit the amendment:
   ```
   git add <amended-file> && git commit -m "docs: amend <filename> to v{N} — <summary>"
   ```
   The commit message summary must match the Revision History row summary exactly.
   Do not batch multiple amendments into one commit — one commit per amended document.

## Output

The amended document with updated content, updated `Version:` field (if bumped), and a new Revision History row (if bumped). A notification message naming which agents were notified and why. A commit containing only the amended file.
