#!/bin/bash
# check-acronyms.sh — Verify common legislative acronyms are expanded in a briefing .js file.
# Runs against the .js source before the docx is built, so violations are caught early.
#
# Usage:
#   ./scripts/check-acronyms.sh <briefing-file.js>
#
# Exit code 0 = all clear. Exit code 1 = one or more acronyms used without expansion.
#
# Requires: python3 (used for reliable word-boundary matching across macOS/Linux)

FILE=${1:?Usage: $0 <briefing-file.js>}

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

ERRORS=0

# check: word-boundary search for all-caps acronyms (AUMF, CFTC, etc.)
# Args: acronym  "required expansion substring"
check() {
  local acronym="$1"
  local expansion="$2"

  local found
  found=$(python3 -c "
import re, sys
text = open(sys.argv[1]).read()
print('yes' if re.search(r'\b' + re.escape(sys.argv[2]) + r'\b', text) else 'no')
" "$FILE" "$acronym" 2>/dev/null)

  if [ "$found" = "yes" ]; then
    local expanded
    expanded=$(python3 -c "
import sys
text = open(sys.argv[1]).read().lower()
print('yes' if sys.argv[2].lower() in text else 'no')
" "$FILE" "$expansion" 2>/dev/null)

    if [ "$expanded" = "yes" ]; then
      echo "OK    ${acronym}"
    else
      echo "FAIL  ${acronym}  —  missing expansion: \"${expansion}\""
      ERRORS=$((ERRORS + 1))
    fi
  fi
}

# check_abbr: plain substring search for dot-notation abbreviations (H.Con.Res., S.J.Res., etc.)
# Word-boundary regex does not work when the abbreviation contains dots.
check_abbr() {
  local acronym="$1"
  local expansion="$2"

  local found
  found=$(python3 -c "
import sys
text = open(sys.argv[1]).read()
print('yes' if sys.argv[2] in text else 'no')
" "$FILE" "$acronym" 2>/dev/null)

  if [ "$found" = "yes" ]; then
    local expanded
    expanded=$(python3 -c "
import sys
text = open(sys.argv[1]).read().lower()
print('yes' if sys.argv[2].lower() in text else 'no')
" "$FILE" "$expansion" 2>/dev/null)

    if [ "$expanded" = "yes" ]; then
      echo "OK    ${acronym}"
    else
      echo "FAIL  ${acronym}  —  missing expansion: \"${expansion}\""
      ERRORS=$((ERRORS + 1))
    fi
  fi
}

# ── Intelligence / surveillance ──────────────────────────────────────────────
check "NSA"    "National Security Agency"
check "FBI"    "Federal Bureau of Investigation"
check "DNI"    "Director of National Intelligence"
check "FISC"   "Foreign Intelligence Surveillance Court"
check "RISAA"  "Reforming Intelligence and Securing America Act"
check "JAG"    "Judge Advocate General"

# ── Core legislative procedure ────────────────────────────────────────────────
check "AUMF"       "Authorization for Use of Military Force"
check "WPR"        "War Powers Resolution"
check "CR"         "continuing resolution"
check "CRS"        "Congressional Research Service"
check "CBO"        "Congressional Budget Office"
check_abbr "H.Con.Res." "House Concurrent Resolution"
check_abbr "S.Con.Res." "Senate Concurrent Resolution"
check_abbr "H.J.Res."   "House Joint Resolution"
check_abbr "S.J.Res."   "Senate Joint Resolution"

# ── Committees ────────────────────────────────────────────────────────────────
check "HASC"    "House Armed Services"
check "SASC"    "Senate Armed Services"
check "HSGAC"   "Homeland Security and Governmental Affairs"
check "SSCI"    "Senate Select Committee on Intelligence"
check "HFSC"    "House Financial Services"
check "HELP"    "Health, Education, Labor, and Pensions"

# ── Agencies and regulators ───────────────────────────────────────────────────
check "CFTC"    "Commodity Futures Trading Commission"
check "CFPB"    "Consumer Financial Protection Bureau"
check "NLRB"    "National Labor Relations"
check "DOGE"    "Department of Government Efficiency"
check "CBP"     "Customs and Border Protection"
check "ICE"     "Immigration and Customs Enforcement"
check "DHS"     "Department of Homeland Security"
check "DOJ"     "Department of Justice"
check "FISA"    "Foreign Intelligence Surveillance"

# ── Finance and crypto ────────────────────────────────────────────────────────
check "DeFi"    "decentralized finance"
check "CBDC"    "central bank digital currency"
check "NASAA"   "North American Securities Administrators"

# ── Voting rights / elections ─────────────────────────────────────────────────
check "HAVA"    "Help America Vote Act"
check "NVRA"    "National Voter Registration Act"
check "VRA"     "Voting Rights Act"

echo ""
if [ "$ERRORS" -eq 0 ]; then
  echo "All acronym checks passed."
else
  echo "${ERRORS} acronym expansion(s) missing — fix before running node to build the docx."
  exit 1
fi
