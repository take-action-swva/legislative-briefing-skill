#!/bin/bash
# fetch-signals.sh — Consumer-side query helper for the civic-signals D1
# table (Phase 5 of plans/2026-09-leading-edge-coverage.md, "not yet built"
# item). Queries the shared `signals` table that the Federal Register and
# regulations.gov collectors write to, and outputs a markdown table for the
# horizon-90 or digest-mode scan.
#
# Why wrangler instead of a raw D1 REST call: the civic-signals repo already
# authenticates against Cloudflare (see its own `wrangler whoami`). Querying
# through wrangler reuses that session instead of minting a new API token
# for this one script.
#
# Usage:
#   ./fetch-signals.sh [issue-area] [days]
#
# Examples:
#   ./fetch-signals.sh                    # all issue areas, last 14 days
#   ./fetch-signals.sh immigration        # one issue area, last 14 days
#   ./fetch-signals.sh immigration 30     # one issue area, last 30 days
#
# Issue areas: elections, immigration, health, education, environment,
# budget, federal workforce, civil liberties, other
#
# Requires:
#   - The civic-signals repo checked out locally. Defaults to
#     ../../../../Workers/civic-signals relative to this script (i.e. a
#     sibling of this repo's grandparent directory, matching this machine's
#     layout); override with CIVIC_SIGNALS_DIR if it lives elsewhere.
#   - wrangler authenticated (`npx wrangler whoami` from that repo)
#   - jq installed
#
# Output: Markdown to stdout, sorted by deadline (soonest first, nulls last).
# Signals are candidates, not verified facts — Shared Accuracy Rule 6 still
# applies. A signal with an issue_slug names an existing issues/<slug>.md
# file; check it against that file's Stage before treating it as new.

set -e

ISSUE_AREA=${1:-}
DAYS=${2:-14}

CIVIC_SIGNALS_DIR="${CIVIC_SIGNALS_DIR:-$(cd "$(dirname "$0")/../../../../Workers/civic-signals" 2>/dev/null && pwd)}"

if [ -z "$CIVIC_SIGNALS_DIR" ] || [ ! -d "$CIVIC_SIGNALS_DIR" ]; then
  echo "Error: civic-signals repo not found. Set CIVIC_SIGNALS_DIR to its path." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required." >&2
  exit 1
fi

# Both values below reach the SQL string built further down. Validate
# against a fixed allowlist / shape here rather than trusting a shell
# variable straight into --command — wrangler d1 execute takes no bind
# parameters, so this is the substitute for a parameterized query.
if [ -n "$ISSUE_AREA" ]; then
  case "$ISSUE_AREA" in
    elections|immigration|health|education|environment|budget|"federal workforce"|"civil liberties"|other) ;;
    *)
      echo "Error: unknown issue area '${ISSUE_AREA}'. Must be one of: elections, immigration, health, education, environment, budget, \"federal workforce\", \"civil liberties\", other" >&2
      exit 1
      ;;
  esac
fi

if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
  echo "Error: days must be a positive integer, got '${DAYS}'" >&2
  exit 1
fi

SINCE=$(date -u -v-"${DAYS}"d +%Y-%m-%d 2>/dev/null || date -u -d "-${DAYS} days" +%Y-%m-%d)

WHERE="collected_at >= '${SINCE}'"
if [ -n "$ISSUE_AREA" ]; then
  WHERE="${WHERE} AND issue_area = '${ISSUE_AREA}'"
fi

QUERY="SELECT source, external_id, url, title, agency, published_date, deadline, issue_area, threat_vectors, issue_slug, certainty, reliability FROM signals WHERE ${WHERE} ORDER BY (deadline IS NULL), deadline ASC;"

echo "Querying civic-signals (since ${SINCE}${ISSUE_AREA:+, issue_area=$ISSUE_AREA})..." >&2

RAW=$(cd "$CIVIC_SIGNALS_DIR" && npx wrangler d1 execute civic-signals --remote --json --command "$QUERY") || {
  echo "Error: wrangler d1 execute failed. Check auth with 'npx wrangler whoami' in $CIVIC_SIGNALS_DIR" >&2
  exit 1
}

ROWS=$(echo "$RAW" | jq '.[0].results')
COUNT=$(echo "$ROWS" | jq 'length')

echo "# Signals$([ -n "$ISSUE_AREA" ] && echo " — ${ISSUE_AREA}")"
echo
echo "${COUNT} signal(s) since ${SINCE}. Candidates only — re-verify before citing (Accuracy Rule 6)."
echo

if [ "$COUNT" -eq 0 ]; then
  echo "_No signals in this window._"
  exit 0
fi

echo "| Certainty | Deadline | Issue area | Threat vectors | Title | Agency | Source | Issue slug |"
echo "|---|---|---|---|---|---|---|---|"
echo "$ROWS" | jq -r '.[] | "| \(.certainty) | \(.deadline // "—") | \(.issue_area // "—") | \(.threat_vectors // "—") | [\(.title | gsub("\\|"; "\\|"))](\(.url)) | \(.agency // "—") | \(.source) | \(.issue_slug // "—") |"'
