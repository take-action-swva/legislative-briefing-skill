# Scripts

Two utility scripts that reduce manual research work. Neither is required
for normal briefing operation — they are productivity tools for one-time
setup and Congress transitions.

---

## Setup

Both scripts require a free congress.gov API key.

**Get a key:**
1. Go to https://api.congress.gov/sign-up/
2. Fill in the form (first name, last name, email) and submit it
3. The key arrives by email

There is no account to log into — api.congress.gov keys are issued by
api.data.gov, which has no dashboard. That also means a key **cannot be
revoked by you**: if one leaks, the only route is asking Library of Congress
staff to disable it via their [issue
tracker](https://github.com/LibraryOfCongress/api.congress.gov/issues). Treat
the key accordingly.

**Store the key:** keep it in a file only your user can read, and source that
from your shell rc — rather than pasting the value into `~/.zshrc` directly,
where it is world-readable by default and ends up in every backup of that file.

```bash
mkdir -p ~/.config/secrets && chmod 700 ~/.config/secrets
touch ~/.config/secrets/env && chmod 600 ~/.config/secrets/env
$EDITOR ~/.config/secrets/env      # add a line: export CONGRESS_API_KEY=your-key-here
```

Then add this one line to `~/.zshrc` (or `~/.bashrc`):

```bash
[ -f "$HOME/.config/secrets/env" ] && source "$HOME/.config/secrets/env"
```

Editing the file directly, rather than `export`-ing on the command line, also
keeps the key out of your shell history.

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

## Rate Limits

| API | Free limit | Script usage |
|---|---|---|
| congress.gov | 5,000 req/hour | < 10 per run — not a concern |
| FEC (api.data.gov) | 1,000 req/hour | ~3 per member, 0.5s sleep between calls |
| FEC DEMO_KEY | ~50 req/day total | May not complete a full delegation |

Use a real FEC API key (free at api.data.gov) for production runs.

---

## fetch-donors.sh

Pulls FEC campaign finance data for a state's congressional delegation and
overwrites `donor-context-[state].md` with auto-filled fundraising totals
and top contributing organizations. Industry data is left blank for manual
entry from opensecrets.org.

**Data sources:**
- Fundraising totals and top contributing organizations: FEC API (api.open.fec.gov)
- Top industries: manual entry from opensecrets.org (the OpenSecrets API was
  discontinued April 2025; the website still shows industry data)

**What the output looks like:**

```
### VA-09 — Rep. Morgan Griffith (R)
*opensecrets.org/members-of-congress/ — search: Morgan Griffith Virginia*

**2024 cycle fundraising** *(FEC — api.open.fec.gov)*
| Metric | Value |
|---|---|
| Total raised | $1,842,301 |
| From PACs | 52% |
| From individuals | 48% |

**Top contributing organizations** *(FEC — employer self-reported; may contain duplicates)*
| Organization | Total |
|---|---|
| Murray Energy | $42,800 |
| Alpha Natural Resources | $38,500 |
...

**Top industries** *(opensecrets.org — fill in manually, top 5)*
| Industry | Total |
|---|---|
| | |
```

**When to use in a briefing:** Only when the bill involves a sector where
financial influence is likely relevant to a member's position:

- Energy and environment (oil, gas, coal, utilities, mining)
- Healthcare and pharmaceutical bills
- Financial regulation
- Firearms legislation
- Telecommunications and tech regulation

Don't include donor context in every briefing — only when sector-linked
influence plausibly explains a member's position.

---

### Setup: FEC API key

The FEC API is free. Sign up at https://api.open.fec.gov/developers/ (the form
is on that page) or at https://api.data.gov/signup/ — both issue the same
api.data.gov key. The form is JavaScript-rendered and cannot be automated; the
key arrives by email.

As with the congress.gov key, there is no account and no self-service
revocation. To retire a leaked FEC key you must email APIinfo@fec.gov and ask
them to disable it.

Store it the same way as the congress.gov key — in `~/.config/secrets/env`
(mode `600`), sourced from your shell rc, not pasted into `~/.zshrc`:

```bash
# in ~/.config/secrets/env
export FEC_API_KEY=your-fec-key-here
export CONGRESS_API_KEY=your-congress-key-here
```

Without `FEC_API_KEY` set, the script falls back to `DEMO_KEY` (~50 requests/day
total — may not complete a full delegation). Use a real key for production runs.

---

### Usage

```bash
./scripts/fetch-donors.sh <state-code> [cycle]

# Examples:
./scripts/fetch-donors.sh VA 2024 > donor-context-va.md
./scripts/fetch-donors.sh VA      > donor-context-va.md   # defaults to 2024
```

This overwrites `donor-context-va.md` with fresh FEC data and blank industry
tables. After running, fill in the industry tables from opensecrets.org.

**Run cadence:** Once per year (January). Industry data is stable per
election cycle — re-enter it once after the script runs, then done until
the next Congress.

---

### After running

1. Open `donor-context-va.md`
2. For each member, go to their opensecrets.org profile (search hint in each section)
3. Find the **Industries** section and enter the top 5 by total
4. Spot-check 2-3 members' FEC totals against their opensecrets.org profile
   (totals should be close — methodology differs slightly)
5. When generating a briefing, paste only the relevant members' sections
   (not the whole file) and tell Claude: "Include a Donor Context section
   for members where the donor profile is relevant to this bill."
