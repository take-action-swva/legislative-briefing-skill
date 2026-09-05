# Installation Guide

## Quick Start (Virginia)

If you are setting up this skill for Virginia Indivisible use, all state
context files are already included. You only need to:

1. Place the skill directory in your Claude skill path
2. Verify `state-context-va.md` is current (check the "Last full review"
   date at the top of the file)
3. Start a briefing session by telling Claude: "Research [bill name] and
   produce a briefing using the advocacy-legislation-brief skill."

---

## File Structure

```
advocacy-legislation-brief/
  SKILL.md                       Core skill — routing, shared rules, member taxonomy
  CLAUDE.md                      Repo working notes, file map, version history
  README.md                      Project overview and script setup
  INSTALL.md                     This file
  CONTRIBUTING.md                How other state networks adopt and contribute
  MAINTENANCE.md                 Update triggers and Congress-transition checklist
  briefing-qa-checklist.md       Human reviewer checklist (also used as AI self-check)
  state-context-va.md            Virginia 119th Congress delegation — loaded every session
  donor-context-va.md            FEC fundraising and top contributors per member
  brief-index.md                 Index of everything published to the Drive folder
  calendar-119.md                Session weeks, recesses, statutory deadlines
  package.json                   Pins the docx npm dependency
  skills/                        Sub-skills — exactly one loads per session
    brief-full.md                Full briefing, docx output
    brief-short.md               Short brief / one-pager
    horizon-90.md                90-day forward outlook scan
    cta-roundup.md               Calls to action (campaign mode) and digest mode
  issues/                        Research cache, one file per issue area
    README.md                    Freshness limits and the never-cache list
    _template.md                 Blank issue file to copy
  scripts/
    fetch-bill.sh                Bill data from congress.gov → intake form
    fetch-state-members.sh       Delegation data → draft state-context file
    fetch-cosponsors.sh          Current cosponsors, delegation flagged
    fetch-votes.sh               House roll-call breakdown for the delegation
    fetch-donors.sh              FEC fundraising and top employers → donor context
    check-acronyms.sh            Mandatory acronym gate before every output
    check-delegation-parity.sh   Diffs state context against the members table
    publish.sh                   Copies deliverables to the Drive folder
    build-zip.sh                 Packages the skill for upload to claude.ai
    README.md                    API key setup, usage, rate limits
  templates/
    brief-base.js                Docx scaffolding (structure, colors, helpers)
    va-members-table.js          Delegation reference table for full briefings
  references/
    sources-national.md          Universal sources — all states
    sources-va.md                Virginia-specific sources
```

---

## What Claude Loads Each Session

Since version 2.0 the skill is a parent plus four sub-skills, and the load
is a routing step rather than a fixed list.

**1. Always loaded first — `SKILL.md`.** Routing table, the shared accuracy
rules, the Shared Member Taxonomy, and the pre-delivery check.

**2. One sub-skill, chosen from the request.** Exactly one of these loads,
per SKILL.md's routing table:

| Request type | Sub-file |
|---|---|
| Full briefing, detailed analysis, `.docx` | `skills/brief-full.md` |
| Short brief, quick summary, one-pager | `skills/brief-short.md` |
| 90-day outlook, what's coming, forward scan | `skills/horizon-90.md` |
| Calls to action, campaign asks, monthly digest | `skills/cta-roundup.md` |

**3. Context files, loaded before research starts.**

- `state-context-[statecode].md` — delegation, committees, contact details
- `references/sources-national.md` — universal source hierarchy
- `references/sources-[statecode].md` — state-specific sources

**4. `issues/`, checked for a matching issue file.** If one exists it loads
as a drafting aid, valid only within the freshness limits in
`issues/README.md`. If none exists, the session creates one when finished.

**5. On demand, by the sub-skill that needs them.** `calendar-119.md` for
horizon scans, `brief-index.md` for what has already been published,
`donor-context-va.md` for sector-linked bills.

The scripts and templates are run when generating documents — they are not
loaded as context.

---

## Setting Up for a New State

See CONTRIBUTING.md for full instructions. The short version:

1. Run `./scripts/fetch-state-members.sh [statecode]` to generate a draft
   state context file (or ask Claude to generate it from the template)
2. Fill in committee assignments from clerk.house.gov and senate.gov
3. Create `references/sources-[statecode].md` using sources-va.md as a template
4. Update SKILL.md front matter with your state's senators and house seat count

---

## Congress Transitions (January of Odd Years)

At the start of each new Congress:

1. Run `./scripts/fetch-state-members.sh VA` to regenerate the delegation
2. Fill in new committee assignments (assignments are announced in weeks 2-3)
3. Update `state-context-va.md` with the verified data
4. Review `references/sources-va.md` for any stale URLs
5. See MAINTENANCE.md for the full checklist

---

## Dependencies

The docx output requires the pinned `docx` package. Install it from the
repo root, which reads `package.json`:
```bash
npm install
```

The scripts require:
```bash
# macOS:
brew install curl jq

# Ubuntu/Debian:
sudo apt-get install curl jq
```

Two free API keys, both covered in `scripts/README.md`:

- `CONGRESS_API_KEY` — congress.gov, for bills, cosponsors, and delegation
- `FEC_API_KEY` — api.data.gov, for donor context. Without it the scripts
  fall back to `DEMO_KEY`, which is capped near 50 requests a day; a single
  13-member delegation run exceeds that, so get a real key before running
  `fetch-donors.sh` over a full delegation.

`publish.sh` writes to a Google Drive folder. Set `BRIEFING_DRIVE_PATH` to
your own Drive mount — see `scripts/README.md`.

---

## Troubleshooting

**briefing-qa-checklist.md has blank fields at the top — is that a bug?**
No. The header carries fill-in-the-blank lines (`State: ____`,
`Reviewer: ____`, `Briefing topic: ____`, `Date: ____`) for whoever runs
the review to complete by hand. The checklist is state-generic on purpose
so every network can use the same file.

**The docx has no page numbers**
This is intentional. `PageNumberElement` from the docx npm package causes
validation errors in the current environment. The footer status date serves
the same navigation purpose. See the formatting conventions in SKILL.md
for details.

**A committee assignment looks wrong**
Committee assignments change. Verify at clerk.house.gov for House members
or senate.gov/general/committee_assignments for senators. If you find an
error, update state-context-va.md and note the correction date.
