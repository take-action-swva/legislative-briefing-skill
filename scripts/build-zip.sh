#!/bin/bash
# build-zip.sh — Rebuild the Claude.ai upload zip from current skill files.
#
# Run this before uploading to claude.ai/customize/skills:
#   ./scripts/build-zip.sh
#
# Output: advocacy-legislation-brief-claude-upload.zip at the repo root.

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
ZIP="${REPO}/advocacy-legislation-brief-claude-upload.zip"

SKILL_FILES=(
  SKILL.md
  state-context-va.md
)
REF_FILES=(
  references/sources-national.md
  references/sources-va.md
)
TEMPLATE_FILES=(
  templates/brief-base.js
)

# Verify all source files exist before touching the zip.
for f in "${SKILL_FILES[@]}" "${REF_FILES[@]}" "${TEMPLATE_FILES[@]}"; do
  [ -f "${REPO}/${f}" ] || { echo "ERROR: missing ${f}"; exit 1; }
done

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

mkdir -p \
  "${TMPDIR}/advocacy-legislation-brief/references" \
  "${TMPDIR}/advocacy-legislation-brief/templates"

for f in "${SKILL_FILES[@]}";    do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/"; done
for f in "${REF_FILES[@]}";      do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/references/"; done
for f in "${TEMPLATE_FILES[@]}"; do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/templates/"; done

rm -f "$ZIP"
(cd "$TMPDIR" && zip -qr "$ZIP" advocacy-legislation-brief/)

echo "Built: $(basename "$ZIP")"
unzip -l "$ZIP" | tail -n +4 | awk '{print "  " $NF}'
