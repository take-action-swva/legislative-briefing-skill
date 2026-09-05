#!/bin/bash
# check-delegation-parity.sh — Compare the delegation data that exists twice.
#
# state-context-[code].md is the source of truth a briefing session reads.
# templates/[code]-members-table.js carries its own hardcoded MEMBERS array to
# render the delegation reference table in every full briefing. Nothing keeps
# the two in sync except a human remembering to edit both, and that has
# already failed once: Griffith's Communications & Technology subcommittee sat
# in the markdown and not in the table, so every briefing understated his
# committee footprint until someone diffed the files by hand.
#
# This is the automated version of that diff. Run it after any committee
# change, and before publishing anything that includes the delegation table.
#
# Usage:
#   ./scripts/check-delegation-parity.sh [state-code]     # defaults to va
#
# Exit code 0 = the two files agree. Exit code 1 = they have drifted.
#
# The table deliberately abbreviates to fit a narrow docx column ("Seapower
# and Projection Forces subcommittee" renders as "Seapower subcommittee"), so
# this matches on distinctive words rather than exact strings. Where the table
# drops a subcommittee entirely and that is intended, record it in
# INTENTIONALLY_OMITTED below with the reason — an omission should be a
# decision someone wrote down, not a silent difference.
#
# Requires: python3

STATE_CODE="${1:-va}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"

CONTEXT="${REPO}/state-context-${STATE_CODE}.md"
TABLE="${REPO}/templates/${STATE_CODE}-members-table.js"

for f in "$CONTEXT" "$TABLE"; do
  [ -f "$f" ] || { echo "Error: file not found: $f" >&2; exit 1; }
done

python3 - "$CONTEXT" "$TABLE" <<'PYTHON'
import re
import sys

context_path, table_path = sys.argv[1], sys.argv[2]

# Subcommittees the table intentionally leaves out, keyed by member name.
# Each entry needs a reason. An unlisted omission is treated as drift.
INTENTIONALLY_OMITTED = {
    "Mark Warner": [
        # Table shows the parent committee only; the ranking-member detail on
        # this subcommittee did not fit the column.
        "Securities, Insurance, and Investment",
    ],
    "Rob Wittman": [
        # Table shows "Natural Resources" alone — both subcommittees dropped
        # to keep his three-committee entry inside the column width.
        "Energy and Mineral Resources",
        "Water, Wildlife and Fisheries",
    ],
}

ROLE_NOISE = re.compile(
    r"\b(ranking member|ranking|vice chair|chair|of full committee|member)\b",
    re.I,
)

# Words that carry no identifying weight when deciding whether two spellings
# name the same committee.
STOP = {
    "committee","committees","subcommittee","subcommittees","select","joint",
    "and","the","of","on","for","with","related","agencies","affairs","house",
    "senate","national","american","united","states",
}


def norm(s):
    s = s.replace("&", " and ").replace("—", " ").replace("-", " ")
    return re.sub(r"\s+", " ", s).strip()


def distinctive(s):
    """Content words that would identify this committee in either spelling."""
    return {w for w in re.findall(r"[a-z]+", norm(s).lower())
            if len(w) >= 4 and w not in STOP}


def parse_context(path):
    """member name -> list of committee/subcommittee units named in markdown."""
    members = {}
    for block in re.split(r"\n### ", open(path, encoding="utf-8").read())[1:]:
        lines = block.split("\n")
        name = re.sub(r"^(Rep\.|Sen\.)\s*", "", lines[0].split("—")[-1].strip())
        name = name.split("(")[0].strip()

        # Collect the bullet list under **Committees:**, re-joining the
        # continuation lines that wrap in the source.
        raw, grabbing = [], False
        for line in lines:
            if line.strip().startswith("**Committees:**"):
                grabbing = True
                continue
            if not grabbing:
                continue
            stripped = line.strip()
            if stripped.startswith("-"):
                raw.append(stripped.lstrip("- ").strip())
            elif raw and line.startswith("  ") and stripped:
                raw[-1] += " " + stripped
            elif raw:
                break

        units = []
        for entry in raw:
            entry = ROLE_NOISE.sub(" ", entry)
            # Subcommittees appear in parentheses, or after an em dash.
            paren = re.search(r"\(([^)]*)\)", entry)
            head = entry[: paren.start()] if paren else entry
            tail = paren.group(1) if paren else ""

            # "(HELP)", "(TAL)" gloss an acronym rather than naming a
            # subcommittee, and the text they gloss is already in the head.
            if re.fullmatch(r"\s*[A-Z]{2,}\s*", tail):
                tail = ""

            if "—" in head:
                head, _, after = head.partition("—")
                tail = tail + ";" + after

            head = norm(head.strip(" ,;:"))
            if head:
                units.append(head)
            # Split on semicolons only. Committee names carry internal commas
            # ("Securities, Insurance, and Investment"), so splitting on those
            # shatters one name into fragments that match nothing.
            for sub in re.split(r";", tail):
                sub = norm(sub.strip(" ,;:"))
                # A fragment like "Ranking" left behind by ROLE_NOISE is not a
                # subcommittee; require something with identifying words.
                if sub and distinctive(sub):
                    units.append(sub)
        if units:
            members[name] = units
    return members


def parse_table(path):
    """member name -> the committee strings the docx table renders."""
    src = open(path, encoding="utf-8").read()
    members = {}
    for m in re.finditer(r"name:\s*'([^']+)'.*?committees:\s*\[(.*?)\]", src, re.S):
        entries = re.findall(r"'((?:[^'\\]|\\.)*)'", m.group(2))
        members[m.group(1)] = [norm(e.replace("\\'", "'")) for e in entries]
    return members


context = parse_context(context_path)
table = parse_table(table_path)

problems = []

only_context = sorted(set(context) - set(table))
only_table = sorted(set(table) - set(context))
for n in only_context:
    problems.append(f"{n}: in {context_path} but missing from the members table")
for n in only_table:
    problems.append(f"{n}: in the members table but missing from {context_path}")

for name in sorted(set(context) & set(table)):
    blob = " ".join(table[name]).lower()
    blob_words = set(re.findall(r"[a-z]+", blob))
    allowed = INTENTIONALLY_OMITTED.get(name, [])

    for unit in context[name]:
        words = distinctive(unit)
        if not words:
            continue
        if words & blob_words:
            continue
        if any(distinctive(a) & words for a in allowed):
            continue
        problems.append(
            f'{name}: "{unit}" is in the state context but nothing in the '
            f"members table matches it"
        )

    # The reverse direction. The table is the derived artifact, so an entry
    # with no counterpart in the state context is a claim about a member's
    # committees that no verified source backs.
    context_words = set()
    for unit in context[name]:
        context_words |= distinctive(unit)
    for entry in table[name]:
        words = distinctive(entry)
        if words and not (words & context_words):
            problems.append(
                f'{name}: the members table lists "{entry}" but the state '
                f"context does not mention it"
            )

print(f"Members: {len(context)} in state context, {len(table)} in members table")
print("")

if not problems:
    print("Delegation parity OK — the two files agree.")
    sys.exit(0)

for p in problems:
    print(f"DRIFT  {p}")
print("")
print(f"{len(problems)} discrepancy(ies). Update both files, or record a")
print("deliberate omission in INTENTIONALLY_OMITTED in this script.")
sys.exit(1)
PYTHON
