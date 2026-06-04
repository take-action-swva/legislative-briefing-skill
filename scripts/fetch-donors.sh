#!/bin/bash
# fetch-donors.sh — Pull FEC campaign finance data for a state's congressional delegation.
#
# Outputs donor-context markdown to stdout. Redirect to overwrite donor-context-[state].md.
# After running: manually fill in the Top industries tables from opensecrets.org.
#
# Usage:
#   ./scripts/fetch-donors.sh <state-code> [cycle]
#   ./scripts/fetch-donors.sh VA 2024 > donor-context-va.md
#   ./scripts/fetch-donors.sh VA      > donor-context-va.md   # defaults to 2024
#
# API key: free at api.data.gov — register and set FEC_API_KEY env var:
#   export FEC_API_KEY="your-key-here"
#
# Without a key, falls back to DEMO_KEY (~50 requests/day total limit).
# A real key allows 1,000 req/hour. Use one for production runs over full delegations.
#
# Requires: curl, jq, awk

set -euo pipefail

STATE=${1:?'Usage: ./scripts/fetch-donors.sh <state-code> [cycle]   e.g. VA 2024'}
S=$(echo "$STATE" | tr '[:lower:]' '[:upper:]')
STATE_LOWER=$(echo "$STATE" | tr '[:upper:]' '[:lower:]')
CYCLE=${2:-2024}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTEXT_FILE="${SCRIPT_DIR}/../state-context-${STATE_LOWER}.md"
KEY="${FEC_API_KEY:-DEMO_KEY}"
BASE="https://api.open.fec.gov/v1"
TODAY=$(date +%Y-%m-%d)

log()  { echo "  $*" >&2; }
warn() { echo "  WARNING: $*" >&2; }

if [ "$KEY" = "DEMO_KEY" ]; then
  warn "Using DEMO_KEY — limited to ~50 requests/day total."
  warn "Get a free key at api.data.gov to run the full delegation."
fi

# Find the most recent FEC candidate ID for a member.
# Searches by last name, state, and office (H or S).
# Returns empty string if no match found.
find_cand() {
  local q office
  q=$(echo "$1" | tr ' ' '+')
  office="$2"
  curl -sf "${BASE}/candidates/?q=${q}&state=${S}&office=${office}&sort=-receipts&per_page=5&api_key=${KEY}" \
    | jq -r '.results[0].candidate_id // empty'
}

# Get fundraising totals for a candidate in a given cycle.
get_totals() {
  curl -sf "${BASE}/candidates/totals/?candidate_id=${1}&cycle=${CYCLE}&api_key=${KEY}"
}

# Get the principal campaign committee ID for a candidate.
get_committee() {
  curl -sf "${BASE}/candidate/${1}/committees/?designation=P&api_key=${KEY}" \
    | jq -r '.results[0].committee_id // empty'
}

# Format an integer as a dollar amount: 1234567 -> $1,234,567
fmt_dollars() {
  local n="${1%.*}"
  [ -z "$n" ] || [ "$n" = "null" ] || [ "$n" = "0" ] && echo "—" && return
  awk -v n="$n" 'BEGIN {
    s = sprintf("%d", n); r = ""
    while (length(s) > 3) { r = "," substr(s, length(s)-2) r; s = substr(s, 1, length(s)-3) }
    print "$" s r
  }'
}

# Output top 5 employer rows for a committee.
# Employer names are self-reported by donors — duplicates are possible.
top_employers() {
  local committee_id="$1"
  local data
  data=$(curl -sf "${BASE}/schedules/schedule_a/by_employer/?committee_id=${committee_id}&two_year_transaction_period=${CYCLE}&sort=-total&per_page=5&api_key=${KEY}" \
    | jq -r '.results[]? | select(.employer != null and .employer != "") | [(.employer), (.total | round | tostring)] | @tsv' 2>/dev/null) || true

  if [ -z "$data" ]; then
    echo "| — | — |"
    return
  fi

  local count=0
  while IFS=$'\t' read -r org amt; do
    echo "| ${org} | $(fmt_dollars "$amt") |"
    count=$((count + 1))
  done <<< "$data"

  # Pad to 5 rows
  while [ "$count" -lt 5 ]; do
    echo "| | |"
    count=$((count + 1))
  done
}

# Output a complete member section.
# Args: display_title  search_name  office(H|S)  member_search_hint
member_section() {
  local title="$1" name="$2" office="$3" search_hint="$4"

  log "Processing ${title}..."

  echo ""
  echo "### ${title}"
  echo "*opensecrets.org/members-of-congress/ — search: ${search_hint}*"
  echo ""

  local cand_id
  cand_id=$(find_cand "$name" "$office") || true

  if [ -z "$cand_id" ]; then
    warn "FEC lookup failed for '${name}' — fill in manually"
    cat <<EOF
**${CYCLE} cycle fundraising** *(FEC lookup failed — fill in manually)*
| Metric | Value |
|---|---|
| Total raised | |
| From PACs | |
| From individuals | |

**Top contributing organizations** *(fill in manually from opensecrets.org)*
| Organization | Total |
|---|---|
| | |
| | |
| | |
| | |
| | |
EOF
  else
    sleep 0.5
    local totals
    totals=$(get_totals "$cand_id")

    local total_raised pac indiv pac_pct indiv_pct
    total_raised=$(echo "$totals" | jq -r '.results[0].receipts // 0')
    pac=$(echo "$totals" | jq -r '.results[0].other_political_committee_contributions // 0')
    indiv=$(echo "$totals" | jq -r '.results[0].individual_itemized_contributions // 0')
    pac_pct=$(echo "$totals" | jq -r \
      'if (.results[0].receipts // 0) > 0
       then (.results[0].other_political_committee_contributions / .results[0].receipts * 100 | round | tostring) + "%"
       else "—" end')
    indiv_pct=$(echo "$totals" | jq -r \
      'if (.results[0].receipts // 0) > 0
       then (.results[0].individual_itemized_contributions / .results[0].receipts * 100 | round | tostring) + "%"
       else "—" end')

    sleep 0.5
    local committee_id
    committee_id=$(get_committee "$cand_id") || true
    sleep 0.5

    cat <<EOF
**${CYCLE} cycle fundraising** *(FEC — api.open.fec.gov)*
| Metric | Value |
|---|---|
| Total raised | $(fmt_dollars "$total_raised") |
| From PACs | ${pac_pct} |
| From individuals | ${indiv_pct} |

**Top contributing organizations** *(FEC — employer self-reported; may contain duplicates)*
| Organization | Total |
|---|---|
EOF

    if [ -n "$committee_id" ]; then
      top_employers "$committee_id"
    else
      printf "| | |\n%.0s" {1..5}
    fi
  fi

  cat <<EOF

**Top industries** *(opensecrets.org — fill in manually, top 5)*
| Industry | Total |
|---|---|
| | |
| | |
| | |
| | |
| | |

---

EOF
}

# Parse member roster from state-context-[state].md.
# Reads section headers of the form:
#   ### Sen. Mark Warner (D)
#   ### VA-01 — Rep. Rob Wittman (R)
# Outputs one tab-separated line per member: OFFICE  TITLE  LAST_NAME  FULL_NAME
parse_members() {
  while IFS= read -r line; do
    if echo "$line" | grep -qE '^### Sen\.'; then
      local full_name party last
      full_name=$(echo "$line" | sed 's/^### Sen\. //; s/ ([DR])$//')
      party=$(echo "$line" | grep -oE '\([DR]\)' | tr -d '()')
      last=$(echo "$full_name" | awk '{print $NF}')
      printf 'S\t%s\t%s\t%s\n' "Sen. ${full_name} (${party})" "$last" "$full_name"

    elif echo "$line" | grep -qE '^### VA-[0-9]+'; then
      local district rep_name party last
      district=$(echo "$line" | grep -oE 'VA-[0-9]+')
      rep_name=$(echo "$line" | sed 's/^.*Rep\. //; s/ ([DR])$//')
      party=$(echo "$line" | grep -oE '\([DR]\)' | tr -d '()')
      last=$(echo "$rep_name" | awk '{print $NF}')
      printf 'H\t%s\t%s\t%s\n' "${district} — Rep. ${rep_name} (${party})" "$last" "$rep_name"
    fi
  done < "$CONTEXT_FILE"
}

# ── Output ────────────────────────────────────────────────────────────────────

if [ ! -f "$CONTEXT_FILE" ]; then
  warn "state-context-${STATE_LOWER}.md not found at ${CONTEXT_FILE}"
  warn "Cannot determine member roster. Create that file first."
  exit 1
fi

log "Generating ${S} donor context (${CYCLE} cycle)..."
log "Reading member roster from state-context-${STATE_LOWER}.md..."

cat <<EOF
# ${S} Donor Context — 119th Congress
<!-- Cycle: ${CYCLE} | FEC: auto-filled ${TODAY} | Industries: fill in manually -->
<!-- Member roster sourced from state-context-${STATE_LOWER}.md -->
<!-- Next full update: January 2027 (120th Congress) -->

## How to fill in industry data

For each member below:
1. Go to opensecrets.org/members-of-congress/
2. Search by member name (hint in each section)
3. On their profile, scroll to **Industries** — note the top 5 by total
4. Enter industry name and total in the table, largest first

Industry totals are stable per election cycle — fill them in once and
they hold through the full 119th Congress (through January 2027).

FEC employer names are self-reported by donors and may appear in multiple forms
(e.g. "Boeing" and "Boeing Co." as separate entries).

---

EOF

current_chamber=""
while IFS=$'\t' read -r office title last full_name; do
  if [ "$office" = "S" ] && [ "$current_chamber" != "S" ]; then
    echo "## Senate"
    echo ""
    current_chamber="S"
  elif [ "$office" = "H" ] && [ "$current_chamber" != "H" ]; then
    echo "## House"
    echo ""
    current_chamber="H"
  fi
  member_section "$title" "$last" "$office" "$full_name"
done < <(parse_members)

cat <<EOF
*FEC data: api.open.fec.gov | Cycle: ${CYCLE} | Retrieved: ${TODAY}*
*Employer names are self-reported by donors — verify significant figures*
*before citing publicly. Industry data entered manually from opensecrets.org.*
EOF

log ""
log "Done. Next step: fill in Top industries tables from opensecrets.org."
log "Review FEC employer data for obvious duplicates before distributing."
