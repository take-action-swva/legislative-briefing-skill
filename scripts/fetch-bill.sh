#!/bin/bash
# fetch-bill.sh — Pull bill data from congress.gov API and output a
# pre-filled research intake markdown file.
#
# Usage:
#   ./fetch-bill.sh <congress> <bill-type> <bill-number>
#
# Examples:
#   ./fetch-bill.sh 119 hr 22          # SAVE Act (House)
#   ./fetch-bill.sh 119 s 1383         # SAVE Act (Senate companion)
#   ./fetch-bill.sh 119 hr 1           # One Big Beautiful Bill
#
# Bill types: hr, s, hjres, sjres, hconres, sconres, hres, sres
#
# Requires:
#   - CONGRESS_API_KEY environment variable (free at api.congress.gov)
#   - curl and jq installed
#
# Output: Markdown intake form printed to stdout. Redirect to a file:
#   ./fetch-bill.sh 119 hr 22 > research-intake-save-act.md

set -e

CONGRESS=${1:?Usage: $0 <congress> <bill-type> <bill-number>}
TYPE=${2:?Usage: $0 <congress> <bill-type> <bill-number>}
NUM=${3:?Usage: $0 <congress> <bill-type> <bill-number>}
KEY="${CONGRESS_API_KEY:?Set CONGRESS_API_KEY environment variable. Get a free key at api.congress.gov}"

BASE="https://api.congress.gov/v3"
PARAMS="?api_key=${KEY}&format=json"

echo "Fetching bill data from congress.gov..." >&2

# Fetch bill summary
BILL=$(curl -sf "${BASE}/bill/${CONGRESS}/${TYPE}/${NUM}${PARAMS}" 2>/dev/null) || {
  echo "Error: Could not fetch bill data. Check your API key and bill number." >&2
  exit 1
}

# Extract fields
TITLE=$(echo "$BILL" | jq -r '.bill.title // "Unknown"')
ORIGIN=$(echo "$BILL" | jq -r '.bill.originChamber // "Unknown"')
SPONSOR=$(echo "$BILL" | jq -r '.bill.sponsors[0].fullName // "Unknown"')
LATEST_ACTION=$(echo "$BILL" | jq -r '.bill.latestAction.text // "Unknown"')
LATEST_DATE=$(echo "$BILL" | jq -r '.bill.latestAction.actionDate // "Unknown"')
INTRO_DATE=$(echo "$BILL" | jq -r '.bill.introducedDate // "Unknown"')
POLICY_AREA=$(echo "$BILL" | jq -r '.bill.policyArea.name // "Not specified"')

# Fetch recent actions (last 8)
ACTIONS=$(curl -sf "${BASE}/bill/${CONGRESS}/${TYPE}/${NUM}/actions${PARAMS}&limit=8" 2>/dev/null) || ACTIONS="{}"
ACTION_LIST=$(echo "$ACTIONS" | jq -r '.actions[:8][] | "- \(.actionDate): \(.text)"' 2>/dev/null || echo "- Could not fetch actions")

# Fetch committees
COMMITTEES=$(curl -sf "${BASE}/bill/${CONGRESS}/${TYPE}/${NUM}/committees${PARAMS}" 2>/dev/null) || COMMITTEES="{}"
COMMITTEE_LIST=$(echo "$COMMITTEES" | jq -r '.committees[] | "- \(.chamber): \(.name)"' 2>/dev/null || echo "- Could not fetch committees")

# Fetch cosponsors count
COSPONSORS=$(curl -sf "${BASE}/bill/${CONGRESS}/${TYPE}/${NUM}/cosponsors${PARAMS}&limit=1" 2>/dev/null) || COSPONSORS="{}"
COSPONSOR_COUNT=$(echo "$COSPONSORS" | jq -r '.pagination.count // "Unknown"')

# Output intake form
TYPE_UPPER=$(echo "$TYPE" | tr '[:lower:]' '[:upper:]')
BILL_NUM="${TYPE_UPPER} ${NUM}"

cat << INTAKE
# Research Intake — ${TITLE}
# Auto-filled by fetch-bill.sh on $(date +%Y-%m-%d) — verify before use
# Some fields require manual completion (marked FILL IN)

---

## Bill Identity

- **Bill number:** ${BILL_NUM} (${CONGRESS}th Congress)
- **Senate companion / House companion:** FILL IN if applicable
- **Full title:** ${TITLE}
- **Sponsor:** ${SPONSOR}
- **Introduced:** ${INTRO_DATE}
- **Origin chamber:** ${ORIGIN}
- **Policy area:** ${POLICY_AREA}
- **Cosponsors:** ${COSPONSOR_COUNT}
- **Congress.gov URL:** https://www.congress.gov/bill/${CONGRESS}th-congress/$(echo "$TYPE" | sed 's/hr/house-bill/;s/s$/senate-bill/;s/hjres/house-joint-resolution/;s/sjres/senate-joint-resolution/')/${NUM}

---

## Current Status

- **Latest action:** ${LATEST_ACTION}
- **Latest action date:** ${LATEST_DATE}
- **Next scheduled action:** FILL IN — check senate.gov or house.gov floor schedule, and dailypress.senate.gov for Senate floor activity

---

## Committees

${COMMITTEE_LIST}

---

## Recent Actions (last 8, most recent first)

${ACTION_LIST}

---

## Key Votes

<!-- For House passage: run fetch-votes.sh with the year and roll call number shown above -->
<!-- Example: ./scripts/fetch-votes.sh 2025 199 VA                                       -->
<!-- For Senate votes: check dailypress.senate.gov for exact cloture counts               -->
- **House passage (if applicable):** FILL IN date, vote count — then run fetch-votes.sh for delegation breakdown
- **Senate cloture attempts (if applicable):** FILL IN dates and counts from dailypress.senate.gov
- **Senate final vote (if applicable):** FILL IN

---

## State Member Positions

<!-- Script cannot retrieve member positions — check each official .gov page -->
<!-- For Virginia: check warner.senate.gov, kaine.senate.gov, and each House member's official site -->
<!-- Only use official press releases, floor statements, or vote records — do not infer from party -->

- **Sen. [Name 1]:** FILL IN — [source URL]
- **Sen. [Name 2]:** FILL IN — [source URL]
- **[District] Rep. [Name]:** FILL IN — voted [yes/no] on [date] / stated position [source URL] / position not publicly stated
- (add a line for each House member)

---

## Active Court Challenges

<!-- Check democracydocket.com for voting rights / election bills -->
- FILL IN or "None identified as of $(date +%Y-%m-%d)"

---

## State-Specific Impact Data

<!-- Check official senator press releases first — they often contain state data -->
<!-- Then check state-specific sources in references/sources-[statecode].md -->
- FILL IN with verified statistics and source URLs

---

## Notes

- Intake generated: $(date +%Y-%m-%d)
- Status should be re-verified at congress.gov before briefing is distributed
INTAKE

echo "" >&2
echo "Done. Review all FILL IN sections before passing to Claude." >&2
