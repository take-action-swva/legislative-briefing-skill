#!/bin/bash
# fetch-donors.sh — Pull campaign finance data from OpenSecrets API for a
# state's congressional delegation and output formatted markdown.
#
# TERMS OF USE: OpenSecrets data is for research and informational purposes.
# Do not redistribute raw API output publicly. Summaries and analysis derived
# from this data may be used in internal advocacy briefings. See:
# opensecrets.org/api/docs
#
# Usage:
#   ./fetch-donors.sh <state-code> [cycle]
#
# Arguments:
#   state-code   Two-letter state code (e.g. VA, NC, PA)
#   cycle        Election cycle year — must be even (e.g. 2024, 2022)
#                Defaults to most recent completed cycle
#
# Examples:
#   ./fetch-donors.sh VA            # Virginia, most recent cycle
#   ./fetch-donors.sh VA 2024       # Virginia, 2024 cycle specifically
#   ./fetch-donors.sh VA 2022       # Virginia, 2022 cycle
#
# Output: Markdown donor context section, printed to stdout. Redirect:
#   ./fetch-donors.sh VA 2024 > donor-context-va-2024.md
#
# Requires:
#   - OPENSECRETS_KEY environment variable (free at opensecrets.org/api)
#   - curl and jq installed
#
# Note on cycle lag: OpenSecrets data for the most recent election cycle
# is typically complete 3-6 months after the election. The 2024 cycle data
# was fully available by mid-2025. Always note the cycle year in the output.

set -e

STATE=${1:?Usage: $0 <state-code> [cycle] (e.g. ./fetch-donors.sh VA 2024)}
STATE_UPPER=$(echo "$STATE" | tr '[:lower:]' '[:upper:]')
KEY="${OPENSECRETS_KEY:?Set OPENSECRETS_KEY environment variable. Free key at opensecrets.org/api}"

# Default cycle: most recent even year at or before current year
CURRENT_YEAR=$(date +%Y)
DEFAULT_CYCLE=$(( CURRENT_YEAR % 2 == 0 ? CURRENT_YEAR : CURRENT_YEAR - 1 ))
CYCLE=${2:-$DEFAULT_CYCLE}

# Validate cycle is an even number
if (( CYCLE % 2 != 0 )); then
  echo "Error: Cycle must be an even year (e.g. 2024, 2022). Got: ${CYCLE}" >&2
  exit 1
fi

BASE="https://www.opensecrets.org/api"

echo "Fetching ${STATE_UPPER} delegation donor data (${CYCLE} cycle)..." >&2

# Step 1: Get all legislators for the state with their OpenSecrets CIDs
LEGISLATORS=$(curl -sf \
  "${BASE}/?method=getLegislators&id=${STATE_UPPER}&output=json&apikey=${KEY}" \
  2>/dev/null) || {
  echo "Error: Could not fetch legislators. Check your API key." >&2
  exit 1
}

MEMBER_COUNT=$(echo "$LEGISLATORS" | jq '.response.legislator | length' 2>/dev/null || echo 0)

if [ "$MEMBER_COUNT" -eq 0 ]; then
  echo "Error: No legislators found for state ${STATE_UPPER}. Check the state code." >&2
  exit 1
fi

echo "Found ${MEMBER_COUNT} legislators for ${STATE_UPPER}" >&2

# Output header
cat << HEADER
## Donor Context — ${STATE_UPPER} Congressional Delegation
## Cycle: ${CYCLE} | Source: OpenSecrets.org | Retrieved: $(date +%Y-%m-%d)
## For internal use only. Verify totals at opensecrets.org before citing publicly.
## Frame as context for understanding voting patterns — not as accusations.

---

HEADER

# Step 2: For each member, fetch summary and top contributors
echo "$LEGISLATORS" | jq -c '.response.legislator[]' | while read -r member; do
  CID=$(echo "$member" | jq -r '.["@attributes"].cid')
  NAME=$(echo "$member" | jq -r '.["@attributes"].firstlast')
  PARTY=$(echo "$member" | jq -r '.["@attributes"].party')
  DISTRICT=$(echo "$member" | jq -r '.["@attributes"].district')
  CHAMBER=$(echo "$member" | jq -r '.["@attributes"].chamber')

  # Format district label
  if [ "$CHAMBER" = "S" ]; then
    LABEL="Sen. ${NAME} (${PARTY})"
  else
    DIST_NUM=$(echo "$DISTRICT" | sed 's/^0*//')
    LABEL="Rep. ${NAME} (${PARTY}, ${STATE_UPPER}-${DIST_NUM})"
  fi

  echo "  Fetching data for ${NAME}..." >&2

  # Fetch fundraising summary
  SUMMARY=$(curl -sf \
    "${BASE}/?method=candSummary&cid=${CID}&cycle=${CYCLE}&output=json&apikey=${KEY}" \
    2>/dev/null) || { echo "  Warning: Could not fetch summary for ${NAME}" >&2; continue; }

  TOTAL_RAISED=$(echo "$SUMMARY" | jq -r '.response.summary["@attributes"].total // "N/A"')
  TOTAL_SPENT=$(echo "$SUMMARY" | jq -r '.response.summary["@attributes"].spent // "N/A"')
  CASH_ON_HAND=$(echo "$SUMMARY" | jq -r '.response.summary["@attributes"].cash_on_hand // "N/A"')
  PAC_PCT=$(echo "$SUMMARY" | jq -r '.response.summary["@attributes"].pacs // "N/A"')
  INDIV_PCT=$(echo "$SUMMARY" | jq -r '.response.summary["@attributes"].indivs // "N/A"')

  # Format dollar amounts
  format_dollars() {
    local val="$1"
    if [[ "$val" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
      printf "$%'.0f" "$val"
    else
      echo "$val"
    fi
  }

  RAISED_FMT=$(format_dollars "$TOTAL_RAISED")
  SPENT_FMT=$(format_dollars "$TOTAL_SPENT")
  COH_FMT=$(format_dollars "$CASH_ON_HAND")

  # Fetch top contributing organizations
  CONTRIBS=$(curl -sf \
    "${BASE}/?method=candContrib&cid=${CID}&cycle=${CYCLE}&output=json&apikey=${KEY}" \
    2>/dev/null) || { echo "  Warning: Could not fetch contributors for ${NAME}" >&2; CONTRIBS="{}"; }

  CONTRIB_LIST=$(echo "$CONTRIBS" | \
    jq -r '.response.contributors.contributor[]? | 
      "| \(.["@attributes"].org_name) | \(.["@attributes"].total) | \(.["@attributes"].pacs) | \(.["@attributes"].indivs) |"' \
    2>/dev/null || echo "| Could not retrieve contributor data | | | |")

  # Fetch top industries
  INDUSTRIES=$(curl -sf \
    "${BASE}/?method=candIndustry&cid=${CID}&cycle=${CYCLE}&output=json&apikey=${KEY}" \
    2>/dev/null) || INDUSTRIES="{}"

  INDUSTRY_LIST=$(echo "$INDUSTRIES" | \
    jq -r '.response.industries.industry[:5]? | 
      .[] | "| \(.["@attributes"].industry_name) | \(.["@attributes"].total) | \(.["@attributes"].pacs) | \(.["@attributes"].indivs) |"' \
    2>/dev/null || echo "| Could not retrieve industry data | | | |")

  # Output member section
  cat << MEMBER_SECTION
### ${LABEL}
OpenSecrets profile: opensecrets.org/members-of-congress/summary?cid=${CID}

**${CYCLE} cycle fundraising**
- Total raised: ${RAISED_FMT}
- Total spent: ${SPENT_FMT}
- Cash on hand: ${COH_FMT}
- From PACs: ${PAC_PCT}%
- From individuals: ${INDIV_PCT}%

**Top contributing organizations**
| Organization | Total | From PACs | From Individuals |
|---|---|---|---|
${CONTRIB_LIST}

**Top industries**
| Industry | Total | From PACs | From Individuals |
|---|---|---|---|
${INDUSTRY_LIST}

---

MEMBER_SECTION

  # Polite rate limiting — OpenSecrets free tier allows ~200 req/hour
  sleep 1

done

cat << FOOTER
*Data: OpenSecrets.org | Cycle: ${CYCLE} | Retrieved: $(date +%Y-%m-%d)*
*Note: "Organizations" include subsidiaries and affiliated PACs bundled under*
*parent company names. Industry totals include both PAC and individual*
*contributions from people employed in that industry.*
*Cycle lag: Data for the most recent election cycle may be incomplete*
*until 3-6 months after the election.*
FOOTER

echo "" >&2
echo "Done. Review output before including in briefings." >&2
echo "Verify significant figures at opensecrets.org before citing publicly." >&2
