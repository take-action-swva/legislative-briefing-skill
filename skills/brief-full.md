# Full Legislative Briefing — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests a full legislative briefing, detailed analysis, or a `.docx` briefing
document on a specific bill or executive order.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy rules. Begin at Step 1. Do not write the briefing
until Step 5 is complete.

---

## Research Workflow

### Step 1 — Confirm the bill or EO identity

- Confirm the exact bill number (e.g., H.R. 22, S. 1383) or EO number.
- Check whether the legislation has been renamed, reintroduced, or superseded.
  Bills often evolve — the SAVE Act became the SAVE America Act mid-cycle, and
  the House bill (H.R. 22) and Senate companion (S. 1383) are different records
  on congress.gov even when substantively identical.
- Note the Congress session (e.g., 119th Congress, 2025–2026).

### Step 2 — Verify current status from primary sources

Check these in order. Do not rely on news summaries for status.

1. **congress.gov** — bill text, status, committee referrals, vote records,
   co-sponsors. This is the authoritative source.
2. **senate.gov / house.gov** — floor schedules, committee hearing notices,
   member committee assignments.
3. **federalregister.gov** — for EOs, agency rulemaking, and implementation.
4. **dailypress.senate.gov** — Senate floor activity logs with timestamped
   vote records. Use this whenever a bill has been on the Senate floor —
   congress.gov often shows only "In Senate" with minimal procedural detail,
   while the daily press log shows exact cloture counts, amendment votes, and
   which senators voted how.
5. **`scripts/fetch-votes.sh`** — When a House floor vote has already occurred,
   run this script to get the state delegation breakdown directly from the House
   Clerk's canonical XML. Do not use web search or third-party aggregators for
   individual member votes — they can contain errors (e.g., members from other
   states appearing in the wrong state's results). Usage:
   ```
   ./scripts/fetch-votes.sh <year> <roll-number> <state-code>
   ./scripts/fetch-votes.sh 2025 199 VA
   ```
   The year and roll call number come from the congress.gov bill actions page.

Search web sources for recent news *after* anchoring on primary sources, not
instead of them.

### Step 3 — Identify state leverage points

- Look up current committee assignments for `{{state}}` senators at
  senate.gov/committees.
- Look up committee assignments for `{{state}}` House members at
  house.gov/representatives.
- Note any state member serving as chair, ranking member, or on a relevant
  subcommittee — these members have disproportionate influence.
- Check recent press releases from state members' official .senate.gov or
  .house.gov pages for stated positions. Do not infer a position from party
  affiliation alone — find the record or note it as unstated.
- **Redistricting caveat:** District numbers and member compositions can shift
  mid-Congress due to litigation. Verify current district boundaries and member
  assignments at the state's political data source (see `references/sources-va.md`)
  before using district numbers in constituent outreach materials.

### Step 4 — Find state-specific impact data

State-specific numbers are more actionable for group leaders than national
ones. A stat like "40% of [state residents] lack a passport" lands harder than
"millions of Americans." Prefer:

- Official senator/representative press releases — often contain state-specific
  data that takes much longer to find elsewhere. Check these early.
- State-specific sources listed in `references/sources-va.md`
- Census Bureau (census.gov) for district demographics
- Nonpartisan research orgs listed in `references/sources-national.md`

### Step 5 — Map the action landscape

Determine what actions are available right now:

- Open comment periods → regulations.gov
- Scheduled hearings → congress.gov/committee-activity
- Upcoming floor votes → senate.gov / house.gov floor schedules
- **Active court challenges or injunctions** → Democracy Docket
  (democracydocket.com) first for voting rights; then Brennan Center, Campaign
  Legal Center, ACLU. For voting rights and election bills, litigation often
  moves faster than legislation — check this early, not as an afterthought.
- State-level responses → state legislature, governor's office, AG office
- Constituent contact windows → town halls, recess periods
- Donor context (optional): If the bill involves a sector where financial
  influence is likely relevant — energy, pharma, financial regulation, firearms,
  healthcare, telecommunications — donor data from `scripts/fetch-donors.sh`
  (or api.open.fec.gov directly) may help explain member positions and motivate
  constituent pressure. Include a "Donor Context" section when the human has
  provided this data. Do not include donor data on every briefing — only when
  sector-linked influence is plausible and illuminates the bill.
  **Framing rule:** state donor figures as facts, not conclusions.
  "Rep. X received $124,000 from oil and gas industry sources in the 2024
  cycle" belongs in a briefing. "Rep. X votes for the oil industry" does not.
  Always note the cycle year — donor data is typically one cycle behind.

---

## Output Format

Produce a `.docx` file using the docx skill. Do not output plain markdown
unless the user explicitly asks for a draft or quick summary.

The docx format is specified because briefings are shared with group leaders
who open documents in Google Docs or download them as PDFs. All layout
decisions are made for Google Docs readability, including on a phone.

### Citation style: inline hyperlinks

Place citations inline immediately after the claim they support, formatted as
a bracketed hyperlink to the source:

```
The bill stalled in the Senate in April 2026 [campaignlegal.org], with
supporters signaling they will pursue provisions through other paths [vote.org].
```

**Why inline links, not footnotes:** Word-style footnote superscripts are not
tappable in Google Docs and do not survive all PDF export workflows. Inline
bracketed hyperlinks work in Google Docs, in PDF (one tap opens the source),
and in Word. Group leaders reading on phones need one-tap access to sources.

Link text: use the shortest recognizable domain form. For navigational links
add an arrow suffix (`"warner.senate.gov →"`). For long or obscure domains
use a short readable label (e.g., `[democracy docket]` for democracydocket.com).
Never use generic text like "click here."

**Link precision:** The link text stays short (`[vera.org]`), but the URL
must point to the specific article or page containing the claim — never to a
root domain or homepage.

- The URL behind the label must be the specific article, report page, or press
  release — not `https://vera.org` when a deeper URL exists.
- For interactive dashboards or data tools that have no permalink: find the
  static article or report that cites the same figure and use that URL instead.
- When the only available URL is a root domain or un-permalinkable dashboard,
  flag it in Notes & Caveats so the human reviewer can verify before
  distribution.

### Output structure

Follow the inverted pyramid — most actionable content first, supporting detail
below, background last. Busy group leaders should be able to act on this
briefing without reading past the first two sections.

1. **Title block**
   Organization name, bill title, audience, issue area, and date. One line each.

2. **TL;DR box**
   A shaded alert box. What is happening, why it matters, and what
   `{{state}}`'s key lever is. Aim for three sentences; five maximum — if it
   cannot be said in five sentences, the detail belongs in Why It Matters, not
   here. Use red border and shading if the threat level is high; navy border
   and light gray shading otherwise.

3. **Status at a Glance**
   A compact labeled table with these fields: Current status, Last action,
   Next decision point, Core dispute, Administration position, Bill supporters,
   Threat level. No prose. Readers should orient themselves in under 10 seconds.

4. **Recommended Actions — Right Now**
   Open with contact actions before any other actions, ranked by leverage:
   1. Committee gatekeepers — members who control scheduling, amendments, or
      whether the bill moves at all
   2. Persuadables — members who haven't stated a position or are wavering
   3. Confirmed allies — thank them and ask them to pressure wavering colleagues
   4. Confirmed opponents — do not list for direct contact; route to
      constituent pressure via Watch List

   Each contact entry:
   - **Name — Role** (bold directive on its own line)
   - DC: [phone] | [contact form link] on the same line — no hunting required
   - One sentence on why this person is the lever right now
   - Call script directly below, italicized

   After all contact items, list any other time-sensitive actions (open
   comment periods, petitions, hearings).

5. **Why It Matters**
   Bulleted, not prose paragraphs. Lead each bullet with a bold key phrase,
   followed by one to two supporting sentences. One bullet per key point:
   core problem, documented abuse, `{{state}}`-specific impact, any related
   issues. Inline hyperlinks only — no footnotes.

6. **`{{state}}` Delegation — Committee & Position Reference**
   Built using `buildMembersTable(briefingNotes)` from
   `templates/va-members-table.js`. This table occupies its own page — prepend
   a page-break paragraph before the `buildMembersTable()` output:

   ```javascript
   const { buildMembersTable } = require('../templates/va-members-table');
   // in the children array:
   new Paragraph({ pageBreakBefore: true, children: [] }),
   ...buildMembersTable(briefingNotes),
   ```

   The `briefingNotes` object maps each member's ID (as defined in
   `va-members-table.js`) to a string covering the member's relevance to this
   specific briefing. For each member include, in order:

   - **Priority label first** (use exactly these):
     - **→ Call now** — persuadable, wavering, or position unclear
     - **→ Thank and reinforce** — confirmed ally; ask them to press colleagues
     - **→ Constituent pressure only** — firm opponent; route to constituent
       pressure, not direct calls from the statewide network
   - Position on the bill or issue, sourced from a press release, floor
     statement, or vote record — not inferred from party
   - Key vote(s) with roll call number and date if available
   - If no position was found: "Position not found during research"

   Example `briefingNotes` entries:
   ```javascript
   const briefingNotes = {
     'warner': '→ Call now. Voted YES on cloture (Roll Call 45, Jan 2025). Ask him to use his Intelligence Committee role to block companion provisions.',
     'kaine':  '→ Thank and reinforce. Publicly opposed the bill [kaine.senate.gov →]. Ask him to lobby wavering Democrats.',
     'scott':  '→ Thank and reinforce. Position not found during research; party leadership opposed. Thank for expected support.',
   };
   ```

   The template supplies contact information and committee assignments — do not
   duplicate them in the note string. All 13 delegation members must appear.
   Members with no issue-specific note still receive a priority label.
   Priority label order must match the contact ranking in section 4.

7. **Donor Context** [optional — sector-linked bills only]
   One paragraph per relevant member. State figures as facts: amount, industry
   sector, cycle year. Never editorialize. Include only when the bill involves
   a sector where financial influence is plausibly explanatory (energy, pharma,
   financial regulation, firearms, healthcare, telecommunications, cryptocurrency).
   Omit entirely otherwise.

8. **Watch List** [optional]
   Non-`{{state}}` members whose votes are pivotal. Bullet points only. Name,
   role, and one sentence on why they matter to the outcome. No priority
   labels — these are not our members to call.

9. **Legislative Timeline**
   Reference material, not primary reading. Bold date labels followed by
   one-sentence summaries.

10. **Notes & Caveats**
    De-emphasized. Bullet list of unverified claims, source disclosures, and
    the status date. Followed by the prepared-by line in small italic text.

### Style rules

- **Acronyms on first use.** The first time any acronym or abbreviation
  appears that a non-specialist might not recognize, write out the full name
  followed by the acronym in parentheses. Subsequent references may use the
  acronym alone. Apply to committee names, agency names, bill titles, and
  legislative procedures.

  Examples:
  - First use: "Senate Homeland Security and Governmental Affairs Committee (HSGAC)"
  - Subsequent: "HSGAC"
  - First use: "Customs and Border Protection (CBP)"
  - Subsequent: "CBP"
  - First use: "budget reconciliation" with a brief plain-language gloss the
    first time it appears for non-legislative audiences

- **Avoid jargon without explanation.** Terms like "cloture," "Byrd Rule,"
  "markup," and "vote-a-rama" should be briefly glossed on first use. Group
  leaders may not have a legislative background.

### Visual formatting conventions

**Page setup**
US Letter (8.5 × 11 in). Margins: 0.75 in top/bottom, 0.875 in left/right.
Font: Arial throughout. Body text: 11pt. Header and footer in mid-gray, 9pt.

**Color palette**

| Role       | Hex       | Used for                                                          |
|------------|-----------|-------------------------------------------------------------------|
| Navy       | `#1F3864` | Primary headings, table header backgrounds, standard TL;DR border |
| Red        | `#C00000` | Standalone threat H1s, high-threat TL;DR border, Threat Level value |
| Mid-gray   | `#595959` | De-emphasized text, footer, member role labels                    |
| White      | `#FFFFFF` | Table data cells, document background                             |
| Light gray | `#F2F2F2` | Table rows, Status label column, standard TL;DR fill              |

**Shaded boxes**
Used for TL;DR and Recommended Actions only. Each is a single-cell table
with cell padding of 120 top/bottom, 180 left/right.

| Box                        | Fill      | Border color    |
|----------------------------|-----------|-----------------|
| TL;DR (high threat)        | `#FFE5E5` | `#C00000` (red) |
| TL;DR (standard)           | `#F2F2F2` | `#1F3864` (navy)|
| Recommended Actions        | `#FFF3CD` | `#E6A817` (amber)|

**Heading hierarchy**
- H1: Arial 14pt bold, navy, with a bottom border rule in the heading color.
  Space before: 240. Space after: 120.
- H2: Arial 12pt bold, navy. Space before: 200. Space after: 80.
- H3: Arial 11pt bold, navy. Space before: 160. Space after: 60.
- Active threat H1 (standalone sections only, not inside a shaded box): red
  instead of navy. H1 headings inside shaded boxes always use navy.

**Tables**
All tables set to full content width (9360 DXA for US Letter with these
margins). Always use `WidthType.DXA` — never percentage. Set width on both
the table and each cell. Use `ShadingType.CLEAR` for all shading. Cell
padding: 80 top/bottom, 120 left/right.

- Status at a Glance: Two columns — label (2880 DXA, light gray fill, bold)
  and value (6480 DXA, white). Threat level value in red bold.
- Members (delegation reference): Four columns via `templates/va-members-table.js`.
  Column widths: 1600 / 1400 / 2760 / 3960 DXA (total 9720 DXA). Column 1:
  seat, name bold, party. Column 2: DC phone and contact form link. Column 3:
  committee assignments. Column 4: priority label + position + key votes for
  this briefing. Header row: navy fill, white bold text. Alternating row fill:
  white (#FFFFFF) / #F7F7F7. This section occupies its own page (page break
  before).

**Inline hyperlinks**
All citations as inline hyperlinks — never footnotes. Link text should be
descriptive (`"warner.senate.gov →"`) not generic (`"click here"`). Link
color: `#1155CC`, underlined.

**Header and footer**
- Header: Organization name and briefing type, 9pt mid-gray, bottom border
  rule in navy.
- Footer: Status date and distribution note, 9pt mid-gray, centered, top
  border rule in mid-gray. Static text only — no page number fields.

**Page numbers:** `PageNumberElement` from the docx npm package causes a
validation error in the current skill environment. Use a static footer with
the status date instead.

### Pre-Delivery Self-Check

Before writing the final docx, complete every item below in order. Do not
skip steps or mark them complete without actually checking.

**Step 1 — Run the acronym checker (mandatory, non-negotiable)**

After writing the briefing .js file and before running `node` to build the
docx, run:

```
./scripts/check-acronyms.sh <briefing-file.js>
```

Fix every FAIL before proceeding. Beyond the checked list, manually scan the
briefing .js for any additional acronyms not yet in the checker. If you add a
new acronym, add it to `scripts/check-acronyms.sh` before using it.

**Step 2 — Apply humanizer pass (mandatory)**

Before finalizing any prose content, apply the `humanizer` skill to all
free-text sections: TL;DR, Why It Matters bullets, Recommended Actions
narrative text, Watch List, and Notes & Caveats. Do not apply to:

- The Status at a Glance table (structured fields only)
- Member contact tables (name, role, phone, link)
- Legislative Timeline entries (date + one-sentence summaries)
- Call scripts (these use intentional plain language already)
- Citation link text

**Step 3 — Verify the following internally:**

- [ ] Every stated member position has a source URL — not inferred from party
- [ ] Bill number and Congress session are specified exactly
- [ ] Status confirmed from congress.gov or dailypress.senate.gov — not only from news
- [ ] State-specific data used where available — not only national statistics
- [ ] All `{{state}}` members covered evenhandedly in the Members table — no district given extra weight
- [ ] Reconciliation pathway claims (if any) flagged in Notes & Caveats unless confirmed via a procedural primary source
- [ ] Recommended Actions opens with contact actions ranked by leverage order
- [ ] Every contact action includes DC phone number and contact form link
- [ ] TL;DR is five sentences or fewer
- [ ] Status at a Glance table has all seven required fields
- [ ] Member table priority labels match the contact ranking in Recommended Actions
- [ ] Donor Context included only if bill is sector-linked and donor data was provided
- [ ] Notes & Caveats present and flags all unverified claims
- [ ] Date of last status check stated in Notes & Caveats

---

## Common Pitfalls

- **Confusing related bills** — bills often evolve or get renamed. Always
  specify exact bill number and Congress session. House and Senate companion
  bills are separate records on congress.gov even when substantively identical.
- **Treating stalled as dead** — stalled bills can return at any time through
  new floor motions, reconciliation amendments, or reintroduction. Note the
  status but flag for monitoring.
- **Using national stats when state data exists** — state numbers are more
  actionable. Do the extra search. Official senator press releases are often
  the fastest path to verified state-specific data.
- **Omitting the "so what"** — analysis without a specific recommended action
  is incomplete for this audience.
- **Writing "position not publicly stated"** — write **"position not found
  during research"** instead. It's accurate about what you did, not what the
  member did or didn't do.
- **Overstating committee leverage** — committee assignments change each
  Congress. Verify current assignments from official sources, not memory.
- **Citing a root domain instead of the specific page** — `[vera.org]` is not
  a verifiable citation. Always link to the article, report, or press release
  containing the exact claim. For interactive dashboards with no permalink,
  find the companion static article; flag in Notes & Caveats if none exists.
- **Using Word footnotes** — not tappable in Google Docs. Use inline
  hyperlink citations instead.
- **Assuming reconciliation viability** — reconciliation pathway claims
  require procedural verification (Byrd Rule analysis). Flag as uncertain
  unless confirmed via legislativeprocedure.com or a CRS report.
- **Stale district numbers** — redistricting litigation can change district
  compositions mid-Congress. Verify at the state's political data source before
  using district numbers in constituent outreach.
- **District bias from the requester's location** — the briefing is for the
  statewide network. Do not over-emphasize any particular congressional
  district just because the person who requested the briefing lives there.

---

For contribution guidelines, adapting to another state, and source maintenance,
see CONTRIBUTING.md. For source reference tables, see
`references/sources-national.md` and `references/sources-va.md`.
