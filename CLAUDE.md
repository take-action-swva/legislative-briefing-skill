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

**Maintained by:** Virginia Indivisible Steering Committee legislative team.

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
  fetch-donors.sh            FEC API → donor context markdown (industry tables filled manually from opensecrets.org website).
  build-zip.sh               Rebuild advocacy-legislation-brief-claude-upload.zip from current skill files.
  README.md                  Script setup and usage (human-facing).
templates/
  brief-base.js              Docx scaffolding: colors, fonts, helpers, header/footer.
                             Claude fills sections object; this handles structure.
evals/                       Evaluation cases (existing, not modified in this session).
```

---

## Current State

**Skill version:** 1.8  
**State context:** Virginia, 119th Congress (verified 2026-06-01)  
**Next required maintenance:** January 2027 (start of 120th Congress)

## Version History

| Version | Date | Summary |
|---------|------|---------|
| 1.0 | 2026-06-01 | Initial version. Derived from live SAVE Act research session. |
| 1.1 | 2026-06-01 | Converted to portable SKILL.md format. State config in front matter. References split into references/sources.md. INSTALL.md added. |
| 1.2 | 2026-06-01 | Added output format spec: .docx with inline hyperlink citations. Footnotes dropped. Lessons learned added. |
| 1.3 | 2026-06-01 | Added Style Rules section: Summary heading, acronyms on first use, jargon glossed. Rebuilt all briefing docx outputs. |
| 1.4 | 2026-06-01 | Fixed changelog ordering. Fixed example bill number. Added sources (Democracy Docket, Legislative Procedure, dailypress.senate.gov). Added Committee Leverage, Watch List, court challenge monitoring, PageNumberElement note, statewide scope rule. |
| 1.5 | 2026-06-01 | Removed Virginia hardcoding from skill body. All state-specific references use {{state}} substitution. Skill is now fully portable. |
| 1.6 | 2026-06-01 | Added Step 0 (load state context file). Added inline Pre-Delivery Self-Check (9-item checklist). Added state-context-va.md for Virginia 119th Congress. |
| 1.7 | 2026-06-01 | Added docx bug lessons: standalone hyperlink placement error and body() array-argument flattening. Sources split into sources-national.md and sources-va.md. Changelog moved to CLAUDE.md. |
| 1.8 | 2026-06-03 | Redesigned output structure: inverted pyramid, 10 sections, two-column Members table with embedded priority labels, shaded TL;DR and Actions boxes, moved Timeline to end. Full visual formatting spec added. Designed for Google Docs on mobile. |

All 12 planned items from the build checklist are complete. The skill has
been tested with a live SAVE Act briefing session. The resulting `.docx`
passed docx npm package validation.

---

## How to Generate a Briefing

When asked to produce a briefing, Claude should:

1. Load `SKILL.md` as context — Step 0 in the workflow instructs loading
   the remaining files (`state-context-va.md`, `references/sources-national.md`,
   `references/sources-va.md`)
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
echo $FEC_API_KEY         # from api.data.gov (free, 1,000 req/hr)
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

---

## Docx Layout Defaults

The visual spec is now fully defined in SKILL.md under "Visual formatting
conventions." The items below are the critical technical constraints that
apply to every briefing regardless of content — do not revert them.

**`ShadingType.CLEAR` (not `SOLID`)** — prevents black table cell backgrounds.

**Dual table widths** — set `columnWidths` array on the table AND `width` on
each cell, both in DXA units. Required for consistent rendering in Google Docs.

**Red headings are standalone only** — H1 headings inside shaded boxes (TL;DR,
Recommended Actions) always use navy, not red. Red is reserved for standalone
threat sections with no box. Two urgency signals on one element cancel each other.

**Two-column tables only** — the Members table and Status at a Glance are both
two-column. Four-column tables collapse to unreadable on Google Docs mobile.
Never add columns; consolidate content into the wide right column instead.
