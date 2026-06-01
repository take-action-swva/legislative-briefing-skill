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
- [ ] Notify chapter leaders that district context has changed
- [ ] Update vpap.org as reference for new boundaries

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

Virginia Indivisible statewide network legislative intelligence team.
See CONTRIBUTING.md for contribution instructions.
