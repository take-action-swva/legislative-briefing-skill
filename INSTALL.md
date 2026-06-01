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
  SKILL.md                       Core skill — workflow, template, accuracy rules
  INSTALL.md                     This file
  CONTRIBUTING.md                How other state networks adopt and contribute
  MAINTENANCE.md                 Update triggers and Congress-transition checklist
  briefing-qa-checklist.md       Human reviewer checklist (also used as AI self-check)
  state-context-va.md            Virginia 119th Congress delegation — AI loads this first
  scripts/
    fetch-bill.sh                Pulls bill data from congress.gov API → intake form
    fetch-state-members.sh       Pulls delegation data → draft state-context file
    README.md                    API key setup and usage
  templates/
    brief-base.js                Docx scaffolding (structure, colors, helpers)
  references/
    sources-national.md          Universal sources — all states
    sources-va.md                Virginia-specific sources
  evals/                         Evaluation cases for testing skill quality
```

---

## What Claude Loads Each Session

Two files are loaded at the start of every briefing:

1. `SKILL.md` — workflow, template, accuracy rules, self-check
2. `state-context-[statecode].md` — pre-verified delegation and committee data

Two more are referenced during research:

3. `references/sources-national.md` — universal source hierarchy
4. `references/sources-[statecode].md` — state-specific sources

The scripts and templates are used by humans or by Claude when generating
documents — they are not loaded as context.

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

The docx output requires:
```bash
npm install -g docx
```

The scripts require:
```bash
# macOS:
brew install curl jq

# Ubuntu/Debian:
sudo apt-get install curl jq
```

And a free congress.gov API key — see `scripts/README.md`.

---

## Troubleshooting

**briefing-qa-checklist.md references `[State]` — is that a bug?**
No. The checklist is state-generic. When using it for Virginia, read
`[State]` as Virginia. The checklist intentionally avoids hardcoding
a state name so it works for all networks.

**The docx has no page numbers**
This is intentional. `PageNumberElement` from the docx npm package causes
validation errors in the current environment. The footer status date serves
the same navigation purpose. See the formatting conventions in SKILL.md
for details.

**A committee assignment looks wrong**
Committee assignments change. Verify at clerk.house.gov for House members
or senate.gov/general/committee_assignments for senators. If you find an
error, update state-context-va.md and note the correction date.
