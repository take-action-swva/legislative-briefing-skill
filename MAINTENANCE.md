# Maintenance Guide

This file documents what needs to be updated, when, and how. Keep it current —
it is the reference for whoever owns the state context file.

---

## Immediate Update Triggers

Act on these within 48 hours of the triggering event.

### Member changes

| Event | What to update |
|---|---|
| Member resignation or death | Remove from state-context-[state].md; note the vacancy and special election date |
| Special election result | Add new member to state-context-[state].md with committees TBD; update once committees assigned (usually within 2 weeks of swearing in) |
| Member switches party | Update party designation in state-context-[state].md; note date |
| Member removed from or added to committee | Update committee list in state-context-[state].md; note date |

### How to find out about changes

Subscribe to VPAP alerts for Virginia: vpap.org  
Congress.gov member pages update within days of official changes.  
Official .gov press releases announce committee assignments immediately.  
Roll Call and Politico cover mid-Congress committee changes.

---

## Annual / Session Updates

### Annual donor context update (January of each year)

Run `./scripts/fetch-donors.sh VA 2024 > donor-context-va.md` to refresh FEC
fundraising totals and top contributing organizations. After the script runs,
re-enter the Top industries tables from opensecrets.org.

- FEC totals update continuously as campaigns file; a January refresh captures
  the most current data before the advocacy season ramps up
- Industry data is stable per election cycle — re-enter once per Congress
  (the 2024 cycle data holds through January 2027)
- If a new member joined via special election, they may not appear in the
  script output — add them manually using the section format in donor-context-va.md

Requires a free FEC API key from api.data.gov (set as `FEC_API_KEY` env var).

### Start of each new Congress (January of odd years)

Full regeneration of state-context files. Complete this within the first
two weeks of the new Congress — committee assignments are usually finalized
by the third week of January.

Checklist:
- [ ] Run `scripts/fetch-state-members.sh` or use the manual Claude prompt in CONTRIBUTING.md
- [ ] Verify all committee assignments at clerk.house.gov and senate.gov
- [ ] Update all senator URLs if any changed
- [ ] Update house_seats count in SKILL.md front matter if Virginia gained or lost seats
- [ ] Update "Next full review" date at the top of state-context-va.md
- [ ] Review redistricting status at vpap.org — note any pending litigation
- [ ] Bump `last_verified` dates in sources-va.md
- [ ] Review sources-national.md for stale entries
- [ ] Check all source URLs still resolve

### After major redistricting

If court orders or legislation redraws district lines mid-Congress:
- [ ] Update district numbers and boundaries in state-context-va.md
- [ ] Add a redistricting note at the top of the file
- [ ] Notify group leaders that district context has changed
- [ ] Update vpap.org as reference for new boundaries

---

## Committee Update Routine

This section is written as instructions for a scheduled Claude agent that runs
annually on January 15. A human can also follow these steps manually.

The agent loads this file from the repository and executes the steps below.

### Step 1 — Read the current state

Read `state-context-va.md` in full. Note the current committee assignments
for all 13 members so you can identify what changed.

### Step 2 — Check Senate assignments

Fetch `https://www.senate.gov/general/committee_assignments/assignments.htm`
and find the entries for Warner and Kaine. For each senator, record:
- Full committee names
- Subcommittee assignments
- Leadership roles (Chair, Ranking Member, Vice Chair)

### Step 3 — Check House member assignments

For each of the 11 Virginia House members, fetch their official page and
find their current committee assignments. Note full committee names,
subcommittee assignments, and any leadership roles.

| Member | Page |
|---|---|
| VA-01 Rob Wittman | wittman.house.gov |
| VA-02 Jen Kiggans | kiggans.house.gov |
| VA-03 Bobby Scott | bobbyscott.house.gov |
| VA-04 Jennifer McClellan | mcclellan.house.gov |
| VA-05 John McGuire | mcguire.house.gov |
| VA-06 Ben Cline | cline.house.gov |
| VA-07 Eugene Vindman | vindman.house.gov |
| VA-08 Don Beyer | beyer.house.gov |
| VA-09 Morgan Griffith | griffith.house.gov |
| VA-10 Suhas Subramanyam | subramanyam.house.gov |
| VA-11 James Walkinshaw | walkinshaw.house.gov |

If a page is unavailable, skip that member and note them in the PR description.

### Step 4 — Update state-context-va.md if anything changed

Compare what you found against the current file. For each member with changes:
- Update the **Committees:** section with current assignments
- Update leadership roles (Chair, Ranking Member, Vice Chair, subcommittee roles)
- Update the `Verified:` date on the changed section(s) to today's date
- Update the Delegation Summary table at the bottom if Key Committee columns changed

**Do not change:** phone numbers, contact URLs, advocacy notes, file header,
Update Triggers section.

**Accuracy rules:**
- Only update based on what you actually read from official pages
- Never infer or guess committee assignments
- If a member has been replaced entirely (death, resignation, special election),
  flag it prominently in the PR description rather than restructuring the file —
  that requires human review

### Step 5 — Commit and open a PR

If you made changes to state-context-va.md:

```bash
git checkout -b committee-update-$(date +%Y-%m)
git add state-context-va.md
git commit -m "Update committee assignments $(date +'%B %Y')"
git push origin HEAD
gh pr create \
  --title "Committee assignments update $(date +'%B %Y')" \
  --body "Annual committee assignment check by scheduled agent. Review diff carefully before merging. Any pages that were unavailable during the run are noted here: [list them]."
```

If no changes were found, do not commit. Output a summary noting that
assignments are current as of today's date.

---

## Source Reliability Reviews

Do this at the start of each Congress and whenever a source produces
an error in a live briefing session.

For each source in sources-national.md and sources-va.md:
- [ ] Confirm URL still resolves
- [ ] Confirm the content is still current and reliable
- [ ] Update `last_verified` date
- [ ] Downgrade to `monitor` reliability if the source has been stale or inaccurate
- [ ] Remove or replace `monitor` sources that haven't improved

---

## Lessons Learned Reviews

After each briefing session, check whether a new lesson should be added
to the `lessons_learned` block in SKILL.md. Specifically ask:
- Did a source prove more or less useful than expected?
- Did a claim require unusual verification effort?
- Did Claude make an error that the checklist would have caught?
- Did a recipient of the briefing report a problem?

Tag Virginia-specific lessons with `[Virginia]`. Keep lessons concise — one
paragraph maximum. Add to the top of the list (most recent first).

---

## Skills Version Updates

Bump the SKILL.md version number when:
- The research workflow steps change
- The output template changes
- New pitfalls or accuracy rules are added
- The Pre-Delivery Self-Check changes

Do NOT bump the version for:
- Adding a new state context file
- Updating source reliability dates
- Adding lessons learned entries
- Fixing typos

State context files and sources files have their own `last_verified` dates
independent of the skill version.

---

## Contact

Virginia Indivisible statewide network legislative tracking team.
See CONTRIBUTING.md for contribution instructions.
