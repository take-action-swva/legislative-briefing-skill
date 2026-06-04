# Scripts

Four scripts. Three are productivity tools for research, setup, and Congress
transitions. One (`check-acronyms.sh`) is mandatory — it runs before every
docx build and enforces the acronym expansion rule.

---

## Setup

`fetch-bill.sh`, `fetch-state-members.sh`, and `fetch-donors.sh` require a
free congress.gov API key. `fetch-votes.sh` requires no API key.

**Get a key:**
1. Go to api.congress.gov
2. Click "Sign Up" and create a free account
3. Your API key is displayed on your account page

**Set the environment variable:**
```bash
# Add to ~/.bashrc or ~/.zshrc for persistence:
export CONGRESS_API_KEY="your-key-here"

# Or set it just for the current session:
export CONGRESS_API_KEY="your-key-here"
```

**Install dependencies:**
```bash
# macOS
brew install curl jq

# Ubuntu/Debian
sudo apt-get install curl jq

# Both are typically pre-installed on most systems
```

---

## fetch-bill.sh

**What it does:** Pulls bill data from congress.gov and outputs a pre-filled
research intake markdown form. Saves 3-4 manual search steps at the start of
each briefing session.

**When to use:** At the start of any briefing session, once you know the bill
number.

**Usage:**
```bash
./scripts/fetch-bill.sh <congress> <bill-type> <bill-number>

# Examples:
./scripts/fetch-bill.sh 119 hr 22 > intake-save-act.md
./scripts/fetch-bill.sh 119 s 1383 > intake-save-act-senate.md
./scripts/fetch-bill.sh 119 hr 1 > intake-reconciliation.md
```

**Bill types:** `hr` (House bill), `s` (Senate bill), `hjres`, `sjres`,
`hconres`, `sconres`, `hres`, `sres`

**Output:** A markdown file with bill identity, current status, committee
referrals, and recent actions pre-filled. Member positions and state-specific
impact data are marked FILL IN — those require manual research and cannot
be automated.

**After running:**
1. Open the output file
2. Verify the auto-filled sections look correct
3. Fill in the FILL IN sections (positions, state impact, court challenges)
4. Paste the completed file into your Claude conversation as the research
   starting point

---

## fetch-state-members.sh

**What it does:** Pulls the current congressional delegation for a state
from congress.gov and outputs a draft state-context markdown file.

**When to use:** At the start of each new Congress (January of odd years)
to regenerate the state context file. Run once, verify, and you're done
until the next Congress.

**Usage:**
```bash
./scripts/fetch-state-members.sh <state-code> > state-context-draft.md

# Examples:
./scripts/fetch-state-members.sh VA > state-context-va-draft.md
./scripts/fetch-state-members.sh NC > state-context-nc-draft.md
```

**Important:** The congress.gov API does not include committee assignments.
The script outputs a draft with FILL IN placeholders for committees. You must
add committee assignments manually from:
- House: clerk.house.gov/members/[bioguide-id]
- Senate: senate.gov/general/committee_assignments/assignments.htm

**After running:**
1. Open the draft file
2. For each member, look up committee assignments at the sources above
3. Fill in phone numbers (available on each member's official .gov page)
4. Fill in advocacy notes if desired
5. Remove the draft warning header
6. Save as `state-context-[statecode].md`
7. Commit to the repository

Alternatively, you can skip the script and ask Claude to generate the file
directly. See CONTRIBUTING.md for the manual Claude prompt.

---

## check-acronyms.sh

**What it does:** Scans a briefing `.js` file for known legislative acronyms
and verifies that each one's full expansion appears somewhere in the file.
Exits non-zero if any acronym is used without being expanded.

**When to use:** Before every `node <brief>.js` run. This is mandatory, not
optional. The SKILL.md Pre-Delivery Self-Check requires it as Step 1.

**Usage:**
```bash
./scripts/check-acronyms.sh <briefing-file.js>

# Example:
./scripts/check-acronyms.sh iran-war-powers-brief.js
```

**Output:** `OK` or `FAIL` for each acronym found, followed by a summary.
Non-zero exit code if any FAILs are found — stops the build pipeline.

**Adding new acronyms:** When you use a legislative acronym not already in
the checker, add it to the `check` list in this script before using it in a
briefing. The script is append-only — adding is always safe.

**No API key or dependencies needed** beyond python3 (standard on macOS).

---

## fetch-votes.sh

**What it does:** Pulls a House roll call vote from the House Clerk's canonical
XML and shows how a state delegation voted. No API key required.

**When to use:** Any time a bill has already had a House floor vote and you need
individual member votes for the state. This is the primary source — more reliable
than web search or third-party aggregators, which can contain state-assignment
errors.

**Usage:**
```bash
./scripts/fetch-votes.sh <year> <roll-call-number> <state-code>

# Examples:
./scripts/fetch-votes.sh 2025 199 VA    # CLARITY Act, Virginia
./scripts/fetch-votes.sh 2025 22 VA     # Any other House vote
```

The year and roll call number come from the congress.gov bill actions page. Look
for the "Passed House" action — it will show the date and roll call number.

**Output:** A markdown table with the full chamber party totals and each state
member's individual vote (Yea / Nay / Not Voting).

**No API key needed.** Reads directly from:
```
https://clerk.house.gov/evs/<year>/roll<number>.xml
```

**After running:**
1. Paste the output into your briefing session as part of the research context
2. The member votes go directly into the Members table — no "verify manually" needed
3. Cross-check any surprising votes (unexpected party breaks) against the member's
   official press releases

---

## Rate Limits

The free congress.gov API key allows 5,000 requests per hour. Both scripts
make fewer than 10 requests each. Rate limits are not a practical concern
for normal use.
