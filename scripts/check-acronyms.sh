#!/bin/bash
# check-acronyms.sh — Verify acronyms are expanded on first use in a briefing file.
# Accepts either a .js source (docx outputs, checked before the docx is built, so
# violations are caught early) or a .md file (markdown outputs: short briefs and
# CTA roundups, which have no .js stage).
#
# Two passes run over every file:
#   1. Enumerated — a curated table of acronyms this project uses often, each
#      requiring a specific expansion. Catches a wrong or vague expansion, not
#      just a missing one.
#   2. Generic — any other all-caps token, flagged when nothing nearby defines
#      it. Catches acronyms nobody thought to enumerate (ACLU, FEMA, NEPA).
#
# Both passes enforce ORDER, not mere presence: the expansion has to appear
# before the acronym's first bare use, which is what "expand on first use"
# actually means. An expansion buried nine paragraphs below the first bare use
# does not help the reader who hit the acronym in paragraph one.
#
# Usage:
#   ./scripts/check-acronyms.sh <briefing-file.js|.md>
#
# Exit code 0 = all clear. Exit code 1 = one or more violations.
#
# Requires: python3

FILE=${1:?Usage: $0 <briefing-file.js|.md>}

if [ ! -f "$FILE" ]; then
  echo "Error: File not found: $FILE" >&2
  exit 1
fi

case "$FILE" in
  *.js|*.md) ;;
  *)
    echo "Error: expected a .js or .md file, got: $FILE" >&2
    exit 1
    ;;
esac

python3 - "$FILE" <<'PYTHON'
import re
import sys

path = sys.argv[1]
raw = open(path, encoding="utf-8").read()

# (acronym, required expansion). Dotted forms are matched as plain substrings;
# everything else on word boundaries.
ENUMERATED = [
    # Intelligence / surveillance
    ("NSA",   "National Security Agency"),
    ("FBI",   "Federal Bureau of Investigation"),
    ("DNI",   "Director of National Intelligence"),
    ("FISC",  "Foreign Intelligence Surveillance Court"),
    ("RISAA", "Reforming Intelligence and Securing America Act"),
    ("JAG",   "Judge Advocate General"),

    # Core legislative procedure
    ("AUMF",       "Authorization for Use of Military Force"),
    ("WPR",        "War Powers Resolution"),
    ("CR",         "continuing resolution"),
    ("CRS",        "Congressional Research Service"),
    ("CBO",        "Congressional Budget Office"),
    ("H.Con.Res.", "House Concurrent Resolution"),
    ("S.Con.Res.", "Senate Concurrent Resolution"),
    ("H.J.Res.",   "House Joint Resolution"),
    ("S.J.Res.",   "Senate Joint Resolution"),

    # Committees
    ("HASC",  "House Armed Services"),
    ("SASC",  "Senate Armed Services"),
    ("HSGAC", "Homeland Security and Governmental Affairs"),
    ("SSCI",  "Senate Select Committee on Intelligence"),
    ("HFSC",  "House Financial Services"),
    ("HELP",  "Health, Education, Labor, and Pensions"),

    # Agencies and regulators
    ("CFTC", "Commodity Futures Trading Commission"),
    ("CFPB", "Consumer Financial Protection Bureau"),
    ("NLRB", "National Labor Relations"),
    ("DOGE", "Department of Government Efficiency"),
    ("CBP",  "Customs and Border Protection"),
    ("ICE",  "Immigration and Customs Enforcement"),
    ("DHS",  "Department of Homeland Security"),
    ("DOJ",  "Department of Justice"),
    ("FISA", "Foreign Intelligence Surveillance"),

    # Finance and crypto
    ("DeFi",  "decentralized finance"),
    ("CBDC",  "central bank digital currency"),
    ("NASAA", "North American Securities Administrators"),

    # Voting rights / elections
    ("HAVA", "Help America Vote Act"),
    ("NVRA", "National Voter Registration Act"),
    ("VRA",  "Voting Rights Act"),
]

# Tokens that are not acronyms needing expansion in this context: postal codes
# (districts read "VA-09"), and a few unambiguous everyday forms.
STATE_CODES = {
    "AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA",
    "KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
    "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT",
    "VA","WA","WV","WI","WY","DC",
}
SAFE = STATE_CODES | {
    "US","USA","TV","AM","PM","EST","EDT","CST","CDT","MST","MDT","PST","PDT",
    "TLDR","TL","DR","OK","ID","AI","URL","PDF","FAQ","OK","NO","YES",
}

def js_prose(src):
    """Reader-facing text in a .js source.

    Only string literals reach the page, and only some of those: a scanner is
    needed rather than a regex because comments hold example text that never
    ships ("FISA Reform Act" in a JSDoc @param), and because stripping
    comments by pattern would eat the // in every https:// URL. Single-token
    literals are dropped too — 'FFFFFF', 'DXA', 'CENTER' are config values,
    not prose, and the generic pass would otherwise flag every one of them.
    """
    out, i, n = [], 0, len(src)
    while i < n:
        c = src[i]
        if c == "/" and i + 1 < n and src[i + 1] == "*":
            j = src.find("*/", i + 2)
            i = n if j < 0 else j + 2
        elif c == "/" and i + 1 < n and src[i + 1] == "/":
            j = src.find("\n", i)
            i = n if j < 0 else j + 1
        elif c in "'\"`":
            quote, j, buf = c, i + 1, []
            while j < n and src[j] != quote:
                if src[j] == "\\":
                    j += 2
                    continue
                buf.append(src[j])
                j += 1
            out.append("".join(buf))
            i = j + 1
        else:
            i += 1
    return " ".join(s for s in out if len(s.split()) >= 3)


# Text the acronym rule applies to. Markdown drops fenced code and inline code
# spans, which are not prose either.
if path.endswith(".js"):
    prose = js_prose(raw)
else:
    prose = re.sub(r"```.*?```", " ", raw, flags=re.S)
    prose = re.sub(r"`[^`]*`", " ", prose)

# Collapse whitespace so a multi-word expansion wrapped across two lines still
# reads as one expansion, and so offsets from both searches are comparable.
text = re.sub(r"\s+", " ", prose)
lower = text.lower()

errors = []
checked_ok = []


def first_acronym_pos(token):
    if "." in token:
        i = text.find(token)
        return i if i >= 0 else None
    m = re.search(r"\b" + re.escape(token) + r"\b", text)
    return m.start() if m else None


def first_expansion_pos(expansion):
    i = lower.find(re.sub(r"\s+", " ", expansion.lower()))
    return i if i >= 0 else None


# ── Pass 1: enumerated ───────────────────────────────────────────────────────
enumerated_tokens = set()
for acronym, expansion in ENUMERATED:
    enumerated_tokens.add(acronym)
    a_pos = first_acronym_pos(acronym)
    if a_pos is None:
        continue
    e_pos = first_expansion_pos(expansion)
    if e_pos is None:
        errors.append(f'FAIL  {acronym}  —  missing expansion: "{expansion}"')
    elif e_pos > a_pos:
        errors.append(
            f'FAIL  {acronym}  —  first used at character {a_pos}, but "{expansion}" '
            f"does not appear until character {e_pos}. Expand it on first use."
        )
    else:
        checked_ok.append(f"OK    {acronym}")


# ── Pass 2: generic ──────────────────────────────────────────────────────────
# Any run of 2+ capitals that is not enumerated and not safe-listed. Considered
# defined if its first appearance is "(ACRONYM)" — the standard way a preceding
# expansion introduces one — or if a parenthetical of two or more words follows
# it directly, as in "ACLU (American Civil Liberties Union)".
seen = set()
for m in re.finditer(r"\b[A-Z][A-Z]+\b", text):
    token = m.group(0)
    if token in seen or token in enumerated_tokens or token in SAFE:
        continue
    seen.add(token)

    start, end = m.start(), m.end()
    defined = False

    if start > 0 and text[start - 1] == "(" and end < len(text) and text[end] == ")":
        defined = True
    else:
        follow = re.match(r"\s*\(([^)]{4,150})\)", text[end:])
        if follow and len(follow.group(1).split()) >= 2:
            defined = True

    if defined:
        checked_ok.append(f"OK    {token}  (generic)")
    else:
        errors.append(
            f"FAIL  {token}  —  used at character {start} with no expansion. "
            f'Write it out on first use, as "Full Name Here ({token})".'
        )


for line in checked_ok:
    print(line)
for line in errors:
    print(line)

print("")
if not errors:
    print("All acronym checks passed.")
    sys.exit(0)

if path.endswith(".js"):
    print(f"{len(errors)} acronym problem(s) — fix before running node to build the docx.")
else:
    print(f"{len(errors)} acronym problem(s) — fix before distributing.")
sys.exit(1)
PYTHON
