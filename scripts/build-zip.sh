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
  calendar-119.md
  brief-index.md
)
REF_FILES=(
  references/sources-national.md
  references/sources-va.md
)
TEMPLATE_FILES=(
  templates/brief-base.js
  templates/va-members-table.js
)
SKILLS_FILES=(
  skills/brief-full.md
  skills/brief-short.md
  skills/horizon-90.md
  skills/cta-roundup.md
)
# SKILL.md Step 0 tells every session to check issues/ for the issue in scope.
# Without these the instruction points at a directory that does not exist on
# the claude.ai surface, though it works fine in the git repo.
ISSUES_FILES=(
  issues/README.md
  issues/_template.md
)
# check-acronyms.sh is a mandatory pre-delivery gate, not a convenience — it
# ships so the claude.ai surface can run the same gate the repo does. The
# fetch-* scripts stay out: they need API keys and network access.
SCRIPT_FILES=(
  scripts/check-acronyms.sh
)

# Verify all source files exist before touching the zip.
for f in "${SKILL_FILES[@]}" "${REF_FILES[@]}" "${TEMPLATE_FILES[@]}" "${SKILLS_FILES[@]}" \
         "${ISSUES_FILES[@]}" "${SCRIPT_FILES[@]}"; do
  [ -f "${REPO}/${f}" ] || { echo "ERROR: missing ${f}"; exit 1; }
done

# claude.ai rejects a skill whose front-matter description exceeds 1024
# characters, and it rejects it at the upload dialog — after the zip is built
# and carried to a browser. Fail here instead.
python3 - "${REPO}/SKILL.md" <<'PYCHECK' || exit 1
import re, sys

text = open(sys.argv[1], encoding="utf-8").read()
front = text.split("---")[1]

match = re.search(r"^description: >\n((?:  .*\n)+)", front, re.M)
if not match:
    print("ERROR: could not find a folded 'description: >' block in SKILL.md")
    sys.exit(1)

# YAML folds a '>' scalar by joining its lines with single spaces.
folded = " ".join(line.strip() for line in match.group(1).strip().split("\n"))
limit = 1024

if len(folded) > limit:
    print(f"ERROR: SKILL.md description is {len(folded)} characters, "
          f"{len(folded) - limit} over the {limit}-character limit claude.ai enforces.")
    print("Trim it before uploading. The upload dialog gives the same error.")
    sys.exit(1)

print(f"description: {len(folded)}/{limit} characters ({limit - len(folded)} to spare)")
PYCHECK

# Retired field labels must not reappear in the skill files. A renamed field
# that drifts back produces briefs using vocabulary the network has moved off,
# and nothing else would catch it until a group leader noticed.
RETIRED_LABELS=(
  "Answer looks like"
  "Constituent pressure only"
)
for label in "${RETIRED_LABELS[@]}"; do
  if grep -rqF "$label" "${REPO}/skills" "${REPO}/SKILL.md" "${REPO}/templates" 2>/dev/null; then
    echo "ERROR: retired label \"${label}\" found in the skill files:"
    grep -rnF "$label" "${REPO}/skills" "${REPO}/SKILL.md" "${REPO}/templates" 2>/dev/null
    echo "It was renamed deliberately. Use the current label instead."
    exit 1
  fi
done

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

mkdir -p \
  "${TMPDIR}/advocacy-legislation-brief/references" \
  "${TMPDIR}/advocacy-legislation-brief/templates" \
  "${TMPDIR}/advocacy-legislation-brief/skills" \
  "${TMPDIR}/advocacy-legislation-brief/issues" \
  "${TMPDIR}/advocacy-legislation-brief/scripts"

for f in "${SKILL_FILES[@]}";    do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/"; done
for f in "${REF_FILES[@]}";      do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/references/"; done
for f in "${TEMPLATE_FILES[@]}"; do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/templates/"; done
for f in "${SKILLS_FILES[@]}";   do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/skills/"; done
for f in "${ISSUES_FILES[@]}";   do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/issues/"; done
for f in "${SCRIPT_FILES[@]}";   do cp "${REPO}/${f}" "${TMPDIR}/advocacy-legislation-brief/scripts/"; done
chmod +x "${TMPDIR}/advocacy-legislation-brief/scripts/"*.sh

rm -f "$ZIP"
(cd "$TMPDIR" && zip -qr "$ZIP" advocacy-legislation-brief/)

echo "Built: $(basename "$ZIP")"
unzip -l "$ZIP" | tail -n +4 | awk '{print "  " $NF}'
