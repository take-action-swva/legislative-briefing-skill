# Contributing to advocacy-legislation-brief

This skill is maintained by the Virginia Indivisible statewide network and
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
3. Include a changelog entry in the SKILL.md front matter

### For lessons learned
Add a new entry to the `lessons_learned` block in SKILL.md front matter.
Tag state-specific entries with `[StateName]` at the start of the note.
Append to the top of the list (most recent first).

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

## Questions

Open an issue in the repository or contact the Virginia Indivisible
statewide network legislative intelligence team.
