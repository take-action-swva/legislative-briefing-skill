# CLAUDE.md — advocacy-legislation-brief

This file gives Claude Code the context needed to work on this project
without relitigating decisions already made. Read it before touching
any files. The "Do Not" sections are especially important.

---

## What This Is

A Claude skill for producing federal legislative briefings for Virginia
Indivisible statewide network group leaders. Briefings are `.docx` files
with inline hyperlink citations, Virginia-specific impact data, and ranked
action recommendations. The skill is designed to be portable to other state
networks with minimal changes.

**Primary output:** A `.docx` briefing file, generated using `templates/brief-base.js`
and the `docx` npm package.

**Primary users:** Virginia Indivisible group leaders — busy non-technical
people who open documents in Google Docs and read on their phones.

**Maintained by:** Virginia Indivisible statewide network legislative
intelligence team.

---

## File Map

```
SKILL.md                     Core skill — workflow, template, accuracy rules,
                             pre-delivery self-check. Claude loads this first.
CLAUDE.md                    This file. Claude Code context only.
INSTALL.md                   Human setup instructions.
CONTRIBUTING.md              How other state networks adopt the skill.
MAINTENANCE.md               Update triggers and Congress-transition checklist.
briefing-qa-checklist.md     Human reviewer checklist (not needed by Claude
                             during generation — self-check is inline in SKILL.md).
state-context-va.md          Virginia 119th Congress delegation: all 13 members,
                             committees, contacts. Claude loads this at Step 0
                             of every briefing — eliminates Step 3 searches.
references/
  sources-national.md        Universal source hierarchy for all states.
  sources-va.md              Virginia-specific sources.
scripts/
  fetch-bill.sh              congress.gov API → pre-filled research intake form.
  fetch-state-members.sh     congress.gov API → draft state-context file.
  fetch-donors.sh            OpenSecrets API → donor context markdown.
  README.md                  Script setup and usage (human-facing).
templates/
  brief-base.js              Docx scaffolding: colors, fonts, helpers, header/footer.
                             Claude fills sections object; this handles structure.
evals/                       Evaluation cases (existing, not modified in this session).
```

---

## Current State

**Skill version:** 1.7  
**State context:** Virginia, 119th Congress (verified 2026-06-01)  
**Next required maintenance:** January 2027 (start of 120th Congress)

All 12 planned items from the build checklist are complete. The skill has
been tested with a live SAVE Act briefing session. The resulting `.docx`
passed docx npm package validation.

---

## How to Generate a Briefing

When asked to produce a briefing, Claude should:

1. Load `SKILL.md`, `state-context-va.md`, `references/sources-national.md`,
   and `references/sources-va.md` as context
2. Follow the Step 0–5 research workflow in `SKILL.md`
3. Run the Pre-Delivery Self-Check before generating the docx
4. Use `templates/brief-base.js` — do not regenerate document scaffolding
   from scratch

To use `brief-base.js`:
```javascript
const { buildBrief, run, bold, link, bullet, numbered, body, spacer } = require('./templates/brief-base');
```
Pass a `sections` object with arrays of Paragraph objects. See the
`buildBrief` JSDoc comment in `brief-base.js` for the full sections schema.

---

## How to Run the Scripts

All scripts require environment variables. Check that they are set before running:
```bash
echo $CONGRESS_API_KEY    # from api.congress.gov (free)
echo $OPENSECRETS_KEY     # from opensecrets.org/api (free)
```

```bash
# Generate a research intake form for a bill:
./scripts/fetch-bill.sh 119 hr 22 > intake-save-act.md

# Regenerate state delegation at Congress start:
./scripts/fetch-state-members.sh VA > state-context-va-draft.md

# Get donor data for sector-linked bills:
./scripts/fetch-donors.sh VA 2024 > donor-context-va-2024.md
```

Scripts output markdown to stdout. Redirect to files for use in briefings.
`fetch-state-members.sh` output requires human verification of committee
assignments before use — the congress.gov API does not include committee data.

---

## Key Architecture Decisions

These decisions were made deliberately. Do not reverse them without
understanding the reasoning.

**State config is inline in SKILL.md front matter, not a separate file.**
A `states/va.yaml` pointer was considered and rejected. The AI loading model
requires sequential file loads — state config in a separate file means every
session starts with two required loads before any work begins. Inline front
matter is immediately available. The current design works better for how
Claude reads skill files. Revisit when a second state network actually
contributes (then the migration is adding one file, not a restructure).

**`lessons_learned` stays in SKILL.md front matter, not a separate file.**
A `lessons.md` file was considered and rejected. Separate file = extra load
per session forever, with silent quality degradation if skipped. Append-only
front matter YAML handles 30+ entries fine and is always in context.

**No `states/` directory yet.**
Premature until a second state network exists. Current structure makes the
migration obvious when it's needed — add `states/va.yaml` and a pointer
in front matter. Don't add the directory speculatively.

**`brief-base.js` handles all docx scaffolding.**
Do not regenerate colors, fonts, helpers, header/footer, or numbering config
from scratch in briefing sessions. That code is stable and tested.
`PageNumberElement` causes validation errors in the docx npm environment —
it is intentionally absent from `brief-base.js`. Use the status date footer
instead.

**Inline hyperlink citations, not Word footnotes.**
Group leaders open briefings in Google Docs and read on phones. Word-style
footnote superscripts are not tappable in Google Docs. Every source citation
uses `link(label, url)` from `brief-base.js`, placed inline immediately
after the claim.

**Sources split into national + state files.**
`references/sources-national.md` is universal. `references/sources-va.md`
is Virginia-specific. Other state networks add `sources-[statecode].md`
without touching the national file — no merge conflicts.

**`state-context-va.md` is the token-saving mechanism.**
The single highest-leverage optimization in the skill. Without it, Claude
searches for committee assignments, contact URLs, and member positions
fresh every session. With it, Step 3 is eliminated entirely on every
briefing. Maintain this file carefully. See MAINTENANCE.md for triggers.

**Donor data is optional and sector-linked only.**
`fetch-donors.sh` is not run on every briefing. Only when the bill involves
a sector where financial influence plausibly explains member positions
(energy, pharma, financial regulation, firearms, healthcare, telecom).
Donor figures are stated as facts in briefings — never as editorial claims.
See Step 5 in SKILL.md for the full framing rule.

---

## Do Not Do These Things

These were explicitly considered and ruled out. Don't reintroduce them.

- **Do not create a `states/` directory** — premature, adds complexity
  before any other state network exists
- **Do not move `lessons_learned` to a separate file** — costs a load call
  every session forever
- **Do not use Word footnotes** — not tappable in Google Docs
- **Do not regenerate docx scaffolding from scratch** — use `brief-base.js`
- **Do not use `PageNumberElement`** — causes validation errors, intentionally
  omitted from `brief-base.js`
- **Do not weight any congressional district in briefing content** — briefings
  are for the statewide network, not any individual group's district
- **Do not infer member positions from party** — find a press release, floor
  statement, or vote record, or write "position not publicly stated"
- **Do not run donor lookups on every briefing** — sector-linked bills only
- **Do not create a per-briefing research intake form requirement** — too
  much burden on busy group leaders; `fetch-bill.sh` covers the automatable
  parts and outputs a form with only the irreducible parts marked FILL IN

---

## Adapting for Another State

See `CONTRIBUTING.md` for full instructions. The short version:
1. Run `./scripts/fetch-state-members.sh [statecode]` to generate a draft
   state-context file
2. Manually fill in committee assignments from clerk.house.gov and senate.gov
3. Create `references/sources-[statecode].md` using `sources-va.md` as template
4. Update `state:`, `senators:`, and `house_seats:` in `SKILL.md` front matter

No changes to the skill body are needed. The `{{state}}` placeholders
resolve from front matter.

---

## Versioning Rules

Bump `version:` in SKILL.md when:
- Research workflow steps change
- Output template sections change
- New accuracy rules or pitfalls are added
- Pre-Delivery Self-Check changes

Do NOT bump for:
- Adding lessons_learned entries
- Updating state-context files
- Fixing source URLs or reliability dates
- Adding a new state's context or sources files

State context files and sources files have their own `last_verified`
dates independent of the skill version.

---

## Testing a Briefing

To verify the skill is working correctly after changes:

1. Run a briefing session with a current bill
2. Confirm the docx passes validation:
   ```bash
   npm install -g docx
   # then validate with the docx skill validator if available
   ```
3. Open the output in Google Docs and confirm all hyperlinks are tappable
4. Run through `briefing-qa-checklist.md` manually

Known issue to watch for: any use of `PageNumberElement` or `new Tab()`
outside of a `TextRun` will cause XML validation errors in the docx output.
