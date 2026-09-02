#!/bin/bash
# fetch-cosponsors.sh — Pull the CURRENT cosponsor list for a bill from the
# congress.gov API and flag which of them are in the configured state's
# delegation.
#
# Why this exists: a stale cosponsor list is the most common factual error in
# ask-shaped output. Asking a member to cosponsor a bill they already
# cosponsored burns credibility with that office and with the group leader who
# made the call. Run this on the DAY the document goes out, not the day you
# draft it.
#
# Usage:
#   ./fetch-cosponsors.sh <congress> <bill-type> <bill-number> [state-code]
#
# Examples:
#   ./fetch-cosponsors.sh 119 hr 22 VA
#   ./fetch-cosponsors.sh 119 s 1383        # no state filter section
#
# Bill types: hr, s, hjres, sjres, hconres, sconres, hres, sres
#
# Requires:
#   - CONGRESS_API_KEY environment variable. Free key at
#     https://api.congress.gov/sign-up/. Store it in ~/.config/secrets/env
#     (chmod 600) — see README.md#setup. Never echo or paste it.
#   - curl and jq installed
#
# Output: Markdown to stdout. Redirect to a file, or read it inline.

set -e

CONGRESS=${1:?Usage: $0 <congress> <bill-type> <bill-number> [state-code]}
TYPE=${2:?Usage: $0 <congress> <bill-type> <bill-number> [state-code]}
NUM=${3:?Usage: $0 <congress> <bill-type> <bill-number> [state-code]}
STATE=${4:-}
KEY="${CONGRESS_API_KEY:?Set CONGRESS_API_KEY environment variable. Get a free key at api.congress.gov}"

STATE=$(echo "$STATE" | tr '[:lower:]' '[:upper:]')
# macOS ships bash 3.2, which has no ${var,,} — use tr for the lowercase form.
STATE_LOWER=$(echo "$STATE" | tr '[:upper:]' '[:lower:]')

BASE="https://api.congress.gov/v3"
PARAMS="?api_key=${KEY}&format=json"

echo "Fetching cosponsors from congress.gov..." >&2

# limit=250 is the API maximum. Page through if a bill exceeds it — rare, but
# a truncated list is exactly the error this script exists to prevent.
OFFSET=0
ALL="[]"
while :; do
  PAGE=$(curl -sf "${BASE}/bill/${CONGRESS}/${TYPE}/${NUM}/cosponsors${PARAMS}&limit=250&offset=${OFFSET}") || {
    echo "Error: Could not fetch cosponsors. Check your API key and bill number." >&2
    exit 1
  }
  BATCH=$(echo "$PAGE" | jq '.cosponsors // []')
  COUNT=$(echo "$BATCH" | jq 'length')
  ALL=$(jq -n --argjson a "$ALL" --argjson b "$BATCH" '$a + $b')
  [ "$COUNT" -lt 250 ] && break
  OFFSET=$((OFFSET + 250))
done

# The API returns WITHDRAWN cosponsors alongside current ones, distinguished
# only by sponsorshipWithdrawnDate. Reporting a withdrawn cosponsor as current
# is the same class of error this script exists to prevent, so split them.
CURRENT=$(echo "$ALL" | jq '[.[] | select(.sponsorshipWithdrawnDate == null)]')
WITHDRAWN=$(echo "$ALL" | jq '[.[] | select(.sponsorshipWithdrawnDate != null)]')

TOTAL=$(echo "$CURRENT" | jq 'length')
WD_COUNT=$(echo "$WITHDRAWN" | jq 'length')
REPORTED=$(echo "$PAGE" | jq -r '.pagination.count // "unknown"')

TYPE_UPPER=$(echo "$TYPE" | tr '[:lower:]' '[:upper:]')

echo "# Cosponsors — ${TYPE_UPPER} ${NUM} (${CONGRESS}th Congress)"
echo ""
echo "**Fetched:** $(date +%Y-%m-%d) from api.congress.gov"
echo "**Current cosponsors:** ${TOTAL} (API reports ${REPORTED})"
echo "**Withdrawn:** ${WD_COUNT}"
echo ""
echo "This list is accurate only as of the fetch date above. Re-run before"
echo "distribution — see Shared Accuracy Rule 6."
echo ""

if [ -n "$STATE" ]; then
  IN_STATE=$(echo "$CURRENT" | jq --arg st "$STATE" '[.[] | select(.state == $st)]')
  IN_STATE_WD=$(echo "$WITHDRAWN" | jq --arg st "$STATE" '[.[] | select(.state == $st)]')
  IN_WD_COUNT=$(echo "$IN_STATE_WD" | jq 'length')
  IN_COUNT=$(echo "$IN_STATE" | jq 'length')

  echo "## ${STATE} delegation — already cosponsoring (${IN_COUNT})"
  echo ""
  if [ "$IN_COUNT" -eq 0 ]; then
    echo "None. Every ${STATE} member is a valid cosponsorship ask."
  else
    echo "$IN_STATE" | jq -r '.[] | "- \(.fullName) — signed \(.sponsorshipDate)\(if .isOriginalCosponsor then " (original cosponsor)" else "" end)"'
    echo ""
    echo "**Do not ask these members to cosponsor.** Escalate instead: floor"
    echo "statement, committee pressure, whip their colleagues."
  fi
  echo ""
  echo "Cross-reference against \`state-context-${STATE_LOWER}.md\` for the members"
  echo "NOT on this list — those are the live cosponsorship asks."
  echo ""

  if [ "$IN_WD_COUNT" -gt 0 ]; then
    echo "## ${STATE} delegation — WITHDRAWN cosponsorship (${IN_WD_COUNT})"
    echo ""
    echo "$IN_STATE_WD" | jq -r '.[] | "- \(.fullName) — signed \(.sponsorshipDate), withdrew \(.sponsorshipWithdrawnDate)"'
    echo ""
    echo "A withdrawal is news. It is a member moving away from the bill, and"
    echo "it is a valid ask to re-cosponsor. Do not thank these members for"
    echo "support they have publicly pulled."
    echo ""
  fi
fi

echo "## All current cosponsors"
echo ""
echo "$CURRENT" | jq -r '.[] | "- \(.fullName) — \(.sponsorshipDate)"'

if [ "$WD_COUNT" -gt 0 ]; then
  echo ""
  echo "## Withdrawn (${WD_COUNT}) — not cosponsors, do not count as support"
  echo ""
  echo "$WITHDRAWN" | jq -r '.[] | "- \(.fullName) — signed \(.sponsorshipDate), withdrew \(.sponsorshipWithdrawnDate)"'
fi
