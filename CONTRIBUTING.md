# Contributing to advocacy-legislation-brief

This skill is maintained by the Virginia Indivisible Steering Committee and
designed for use by any state Indivisible network. Contributions from other
states are welcome.

---

## Adding a New State

To deploy this skill for a new state, you need to create two files:

### 1. `state-context-[statecode].md`

Copy `state-context-va.md` as a template. Replace all Virginia-specific
content with your state's delegation. Required fields for each member:

```
- Name and district
- Party
- Committees and subcommittees (verified from clerk.house.gov or senate.gov)
- DC phone number
- Official contact URL
- Brief advocacy notes (optional but useful)
```

Verify all committee assignments from primary sources:
- House members: clerk.house.gov/members/[member-id]
- Senators: senate.gov/general/committee_assignments/assignments.htm

Do not copy from news articles or Wikipedia — clerk.house.gov is authoritative.

### 2. `references/sources-[statecode].md`

Copy `references/sources-va.md` as a template. Replace the Virginia-specific
sources with your state's equivalents. Look for:

| Category | What to find |
|----------|---|
| Political data project | e.g., VPAP for Virginia; most states have one |
| State elections authority | Official voter registration and district maps |
| Independent state news | Non-partisan or lightly-partisan state political outlet |
| Official senator pages | [lastname].senate.gov |
| State attorney general | For tracking state-level legal responses to federal action |
| State legislative research | Equivalent of Virginia's JLARC |

### 3. Front matter update

If you are deploying the skill for your state (not contributing back to the
shared repo), update the front matter in SKILL.md:

```yaml
state: [Your State Name]
senators:
  - name: [Senator 1 Name]
    url: [lastname].senate.gov
  - name: [Senator 2 Name]
    url: [lastname].senate.gov
house_seats: [number]
```

---

## Submitting a Pull Request

### For new state additions
1. Create `state-context-[statecode].md`
2. Create `references/sources-[statecode].md`
3. Submit a PR with the title: `Add [State] context files (119th Congress)`
4. In the PR description, note your verification sources and date

New state files don't touch any shared files — no merge conflicts.

### For improvements to shared files
Shared files: `SKILL.md`, `CONTRIBUTING.md`, `MAINTENANCE.md`,
`briefing-qa-checklist.md`, `references/sources-national.md`,
`scripts/`, `templates/`

For shared file changes:
1. Open an issue first describing the change and why
2. Submit a PR referencing the issue
3. Add a row to the Version History table in CLAUDE.md and bump `version:` in SKILL.md front matter

### For lessons learned
Add a new entry to the `lessons_learned` block in SKILL.md front matter.
Tag state-specific entries with `[StateName]` at the start of the note.
Append to the bottom of the list. Retire a lesson once it is fully codified
as a rule or pitfall in the SKILL.md body — it no longer needs to be in
lessons_learned.

### For source updates
Update the relevant `sources-[statecode].md` file with the new information,
update the `last_verified` date, and note what changed.

---

## Regenerating a State Context File at Congress Start

At the start of each new Congress (January of odd years), the state context
file should be regenerated. Two options:

**Option A — Script (recommended):** Run `scripts/fetch-state-members.sh [statecode]`
if you have a congress.gov API key. The script outputs a pre-filled markdown
file you then verify.

**Option B — Manual:** Open a Claude conversation and paste this prompt:

```
Generate state-context-[statecode].md for the [Nth] Congress using the
template in state-context-va.md. Verify all committee assignments from
clerk.house.gov and senate.gov/general/committee_assignments. Note the
verification date and flag any assignments you could not confirm.
```

Review the output carefully before committing — committee assignments in
particular should be traced to official sources.

---

---

## Adapting to Another State

The skill body — workflow, template, accuracy rules, pitfalls — is fully
generic. No changes to SKILL.md are needed. To deploy for a new state:

1. **Update front matter fields in SKILL.md:**
   - `state:` — state name as it should appear in headings
   - `senators:` — both senator names and their `.senate.gov` URLs
   - `house_seats:` — current number of House seats

2. **Create `references/sources-[statecode].md`** using `sources-va.md` as
   a template. For each new state, find:
   - A state-level political data project (like VPAP for Virginia)
   - The state elections authority website
   - An independent state political news outlet
   - Official senator and representative pages
   - The state attorney general's office
   - Any state-specific legal or civic organizations tracking relevant issues

3. **Carry forward universal sources** — `references/sources-national.md`
   applies to all states unchanged. Only create the state-specific file.

4. **Create `state-context-[statecode].md`** following step 1 above and the
   Regenerating a State Context File instructions below.

5. **Seed lessons_learned** — Virginia-specific entries in SKILL.md are
   prefixed `[Virginia]` so you can identify which lessons generalize. Add
   state-specific entries for your state with the equivalent prefix.

The `{{state}}` placeholders throughout the template resolve from the front
matter automatically.

---

## Improving This Skill

After each research session, consider adding an entry to `lessons_learned`
in SKILL.md front matter. Useful things to note:

- Sources that were stale or hard to find
- State-specific sources that proved more useful than expected
- Pitfalls encountered that are not already listed in the skill body
- Any claim that required extra verification steps
- Output format issues encountered by recipients

**Tag state-specific lessons** with `[StateName]` so future users from
other states can tell which lessons generalize.

When source reliability changes, update the relevant `sources-[statecode].md`
or `sources-national.md` file with the new `last_verified` date and adjust
the reliability rating.

**Retire codified lessons.** Once a lesson has been added as a rule or
pitfall in the SKILL.md body, remove it from `lessons_learned`. It is
costing tokens every session without adding value.

---

## Questions

Open an issue in the repository or contact the Virginia Indivisible
Steering Committee legislative tracking team.
