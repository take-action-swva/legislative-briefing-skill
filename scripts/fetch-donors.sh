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
# API key: free at https://api.open.fec.gov/developers/ (arrives by email).
# Store it in ~/.config/secrets/env (chmod 600), sourced from your shell rc —
# not pasted into ~/.zshrc. See README.md#setup.
#   # in ~/.config/secrets/env
#   export FEC_API_KEY=your-key-here
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

# Look up FEC candidates matching a name query, restricted to this cycle's
# election years so retired/unrelated same-surname candidates (e.g. a former
# member) can't outrank the current one on lifetime receipts.
_fec_candidate_search() {
  local q="$1" office="$2"
  curl_retry "${BASE}/candidates/?q=${q}&state=${S}&office=${office}&sort=-receipts&per_page=10&api_key=${KEY}" \
    | jq -r --arg c1 "$CYCLE" --arg c2 "$((CYCLE + 2))" \
      '[.results[] | select((.election_years // []) | any(. == ($c1 | tonumber) or . == ($c2 | tonumber)))]
       | .[0].candidate_id // empty'
}

# Find the current FEC candidate ID for a member.
# A last-name-only search (e.g. "Scott") can be won by an unrelated,
# long-retired same-surname candidate with higher lifetime receipts (this
# happened for Rep. Bobby Scott, which matched a former VA-02 Rep with the
# same surname instead of him) — so try the full name first, since it's far
# less likely to collide, and fall back to last name only if that finds
# nothing (FEC search is literal and won't match a nickname like "Bobby"
# against a filing's legal name "Robert").
find_cand() {
  local full_name="$1" last_name="$2" office="$3"
  local cand_id

  cand_id=$(_fec_candidate_search "$(echo "$full_name" | tr ' ' '+')" "$office")
  [ -n "$cand_id" ] && { echo "$cand_id"; return; }

  cand_id=$(_fec_candidate_search "$(echo "$last_name" | tr ' ' '+')" "$office")
  [ -n "$cand_id" ] && { echo "$cand_id"; return; }

  # Nothing active this cycle matched — fall back to the old unfiltered
  # last-name search rather than reporting no match at all, but this is a
  # weaker result and worth a second look if it's ever hit.
  warn "No candidate active in ${CYCLE}/$((CYCLE + 2)) matched '${full_name}' — falling back to unfiltered last-name search"
  curl_retry "${BASE}/candidates/?q=$(echo "$last_name" | tr ' ' '+')&state=${S}&office=${office}&sort=-receipts&per_page=5&api_key=${KEY}" \
    | jq -r '.results[0].candidate_id // empty'
}

# curl with one retry on transient failure (timeout, rate limit, flaky connection).
curl_retry() {
  curl -sf "$@" || { sleep 1; curl -sf "$@"; }
}

# Get fundraising totals for a committee in a given cycle.
get_committee_totals() {
  curl_retry "${BASE}/committee/${1}/totals/?api_key=${KEY}" \
    | jq -r --arg cycle "$CYCLE" '.results[] | select(.cycle == ($cycle | tonumber))'
}

# A candidate can have multiple principal-committee registrations over time
# (e.g. an earlier run's committee that has since gone inactive). Picking
# .results[0] blindly returns whichever the API lists first, which is not
# necessarily the one with activity in the cycle we care about — this
# silently produced blank fundraising data for long-serving members with
# more than one P-designated committee on file (e.g. Sen. Warner, Rep.
# McGuire). Instead, check each P committee's totals for this cycle and use
# the first one that actually has data.
find_active_committee() {
  local cand_id="$1"
  local committee_ids
  committee_ids=$(curl_retry "${BASE}/candidate/${cand_id}/committees/?designation=P&api_key=${KEY}" \
    | jq -r '.results[].committee_id // empty')

  local cid totals
  while IFS= read -r cid; do
    [ -n "$cid" ] || continue
    totals=$(get_committee_totals "$cid")
    if [ -n "$totals" ]; then
      echo "$cid"
      return
    fi
  done <<< "$committee_ids"

  # None had data for this cycle — fall back to the first committee so the
  # employer breakdown (which doesn't depend on the cycle having totals) can
  # still be attempted.
  echo "$committee_ids" | head -n1
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
# Employer names are self-reported by donors, so exact-string duplicates
# (e.g. "Boeing" vs "Boeing Co.") are still possible and are flagged in the
# table caption for human review — but this endpoint's own cycle filter
# (two_year_transaction_period) does not actually restrict results: it
# returns one row per (employer, cycle) across the committee's entire
# history, sorted globally by total. Requesting per_page=5 with that filter
# silently returned the 5 largest employer/cycle rows overall — frequently
# the SAME employer (e.g. "NOT EMPLOYED") repeated across different cycles —
# rather than the top 5 employers within the requested cycle. Fetch a wide
# page instead and filter+sort to the target cycle client-side.
top_employers() {
  local committee_id="$1"
  local data
  data=$(curl_retry "${BASE}/schedules/schedule_a/by_employer/?committee_id=${committee_id}&sort=-total&per_page=100&api_key=${KEY}" \
    | jq -r --arg cycle "$CYCLE" \
      '[.results[]? | select(.employer != null and .employer != "" and .cycle == ($cycle | tonumber))]
       | sort_by(-.total) | .[0:5][]
       | [(.employer), (.total | round | tostring)] | @tsv' 2>/dev/null) || true

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
  cand_id=$(find_cand "$search_hint" "$name" "$office") || true

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
    local committee_id
    committee_id=$(find_active_committee "$cand_id") || true
    sleep 0.5

    local totals
    totals=$([ -n "$committee_id" ] && get_committee_totals "$committee_id" || true)

    local total_raised pac indiv pac_pct indiv_pct
    total_raised=$(echo "$totals" | jq -r '.receipts // 0')
    pac=$(echo "$totals" | jq -r '.other_political_committee_contributions // 0')
    indiv=$(echo "$totals" | jq -r '.individual_itemized_contributions // 0')
    pac_pct=$(echo "$totals" | jq -r \
      'if (.receipts // 0) > 0
       then (.other_political_committee_contributions / .receipts * 100 | round | tostring) + "%"
       else "—" end')
    indiv_pct=$(echo "$totals" | jq -r \
      'if (.receipts // 0) > 0
       then (.individual_itemized_contributions / .receipts * 100 | round | tostring) + "%"
       else "—" end')

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
