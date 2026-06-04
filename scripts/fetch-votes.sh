#!/bin/bash
# fetch-votes.sh — Pull a House roll call vote from the House Clerk and show
# how a state delegation voted. Outputs markdown to stdout.
#
# Usage:
#   ./fetch-votes.sh <year> <roll-call-number> <state-code>
#
# Examples:
#   ./fetch-votes.sh 2025 199 VA          # CLARITY Act, Virginia delegation
#   ./fetch-votes.sh 2025 22 VA           # Any other House vote
#
# State code: two-letter postal abbreviation (VA, TX, NY, etc.)
#
# No API key required — uses the House Clerk's public XML files at:
#   https://clerk.house.gov/evs/{year}/roll{number}.xml
#
# Requires: python3 (available on macOS by default)
#
# Output: Markdown table printed to stdout. Redirect to a file or pipe into
# a briefing session.

set -e

YEAR=${1:?Usage: $0 <year> <roll-call-number> <state-code>}
ROLL=${2:?Usage: $0 <year> <roll-call-number> <state-code>}
STATE=${3:?Usage: $0 <year> <roll-call-number> <state-code>}

python3 << PYEOF
import sys, xml.etree.ElementTree as ET, urllib.request

year  = "$YEAR"
roll  = "$ROLL"
state = "$STATE".upper()

roll_padded = roll.zfill(3)
url = f"https://clerk.house.gov/evs/{year}/roll{roll_padded}.xml"

print(f"Fetching roll call {roll} ({year}) from House Clerk...", file=sys.stderr)

try:
    with urllib.request.urlopen(url, timeout=15) as resp:
        xml_text = resp.read()
except Exception as e:
    print(f"Error: Could not fetch {url}: {e}", file=sys.stderr)
    sys.exit(1)

try:
    root = ET.fromstring(xml_text)
except ET.ParseError as e:
    print(f"Error: Could not parse XML: {e}", file=sys.stderr)
    sys.exit(1)

meta = root.find('vote-metadata')
if meta is None:
    print("Error: Unexpected XML structure — no vote-metadata element.", file=sys.stderr)
    sys.exit(1)

def text(el, tag):
    node = el.find(tag)
    return node.text.strip() if node is not None and node.text else 'Unknown'

bill     = text(meta, 'legis-num')
desc     = text(meta, 'vote-desc')
date     = text(meta, 'action-date')
result   = text(meta, 'vote-result')
question = text(meta, 'vote-question')
congress = text(meta, 'congress')
rollnum  = text(meta, 'rollcall-num')

# Parse totals by party
totals = {}
for tp in meta.iter('totals-by-party'):
    party = text(tp, 'party')
    if party and party != 'Party':
        totals[party] = (
            text(tp, 'yea-total'),
            text(tp, 'nay-total'),
            text(tp, 'present-total'),
            text(tp, 'not-voting-total'),
        )

# Collect votes for the requested state
state_votes = []
for rv in root.iter('recorded-vote'):
    leg  = rv.find('legislator')
    vote = rv.find('vote')
    if leg is not None and leg.get('state') == state:
        name  = leg.get('unaccented-name', leg.text or 'Unknown')
        party = leg.get('party', '?')
        v     = vote.text.strip() if vote is not None and vote.text else 'Unknown'
        state_votes.append((name, party, v))

# Sort: Yea first, then Nay, then others; within each group alphabetically
ORDER = {'Yea': 0, 'Nay': 1}
state_votes.sort(key=lambda x: (ORDER.get(x[2], 2), x[0]))

# Output
clerk_url = f"https://clerk.house.gov/Votes/{year}{roll_padded}"
print(f"## {bill} — {desc}")
print(f"**Roll call {rollnum} | {congress}th Congress | {date} | {question} | Result: {result}**")
print(f"**Source:** {clerk_url}")
print()

if totals:
    print("### Full chamber totals")
    print()
    print("| Party | Yea | Nay | Present | Not Voting |")
    print("|-------|-----|-----|---------|------------|")
    for party, (yea, nay, pres, notv) in totals.items():
        print(f"| {party} | {yea} | {nay} | {pres} | {notv} |")
    print()

print(f"### {state} delegation ({len(state_votes)} members found)")
print()

if not state_votes:
    print(f"No members found for state code '{state}'. Check it is a two-letter postal abbreviation.")
    sys.exit(0)

yeas   = sum(1 for _, _, v in state_votes if v == 'Yea')
nays   = sum(1 for _, _, v in state_votes if v == 'Nay')
others = len(state_votes) - yeas - nays

summary = f"{yeas} Yea, {nays} Nay"
if others:
    summary += f", {others} other"
print(f"**{state} vote: {summary}**")
print()

print("| Member | Party | Vote |")
print("|--------|-------|------|")
for name, party, vote in state_votes:
    print(f"| {name} | {party} | {vote} |")
PYEOF
