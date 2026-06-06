---
name: legislative-briefing-skill
description: >
  Use this skill whenever someone asks you to research, analyze, summarize, or
  produce a briefing on federal legislation or executive orders for civic
  advocacy, grassroots organizing, Indivisible groups, or similar audiences.
  Trigger on phrases like "brief me on this bill", "what should our group do
  about", "research this EO for our members", "what's the status of", "how does
  this affect our district", or any request combining legislation with advocacy,
  action, or organizing. Use this even if the request is casual — "what's the
  deal with the SAVE Act for our group" is exactly the kind of thing this skill
  handles. Always produce a .docx file as the final output unless the user
  explicitly asks for something else.
version: "1.8"
output_format: docx
citation_style: inline-hyperlink
state: Virginia
state_code: va
senators:
  - name: Mark Warner
    url: warner.senate.gov
  - name: Tim Kaine
    url: kaine.senate.gov
house_seats: 11
lessons_learned:
  - date: "2026-06-01"
    note: >
      [Virginia] For immigration enforcement briefings, TRAC Immigration
      (trac.syr.edu) provides ICE enforcement data by state and district,
      deportation statistics, and detention data. Warner and Kaine official
      .senate.gov press releases were the best first source for Virginia-specific
      statistics (passport data, women's name-change issue). Check official
      senator press releases early — they often contain state-specific data
      that takes much longer to find elsewhere.
  - date: "2026-06-01"
    note: >
      dailypress.senate.gov is the best source for procedural vote granularity.
      It provides timestamped records of every floor vote, including exact
      cloture counts and which senators voted how. congress.gov showed the SAVE
      Act as "In Senate" with minimal procedural detail. Use dailypress.senate.gov
      whenever a bill has been on the Senate floor — it fills the gap.
  - date: "2026-06-01"
    note: >
      Advocacy org press releases (LDF, Campaign Legal Center, SPLC) are useful
      for confirming stall or defeat events after they happen. They posted within
      days of the April 2026 stall with accurate vote counts and summaries. Good
      for retrospective confirmation; not for predicting what comes next. Treat
      their factual claims about legislative outcomes as reliable, but clearly
      label them as advocacy sources in the briefing.
  - date: "2026-06-01"
    note: >
      The reconciliation/Byrd Rule complexity is a recurring source of confusion.
      Multiple sources gave subtly different accounts of viability. The clearest
      explanation came from legislativeprocedure.com (nonpartisan procedural
      expert). Add this source to research rotation for any bill where
      reconciliation is being discussed as a pathway. Flag reconciliation
      pathway claims in Notes unless verified via a procedural primary
      source.
  - date: "2026-06-01"
    note: >
      [Virginia] House district numbers and compositions can shift mid-Congress
      due to redistricting litigation. Virginia redistricting was actively
      litigated in early 2026. Always verify current district boundaries and
      member assignments at VPAP (vpap.org) before using district numbers in
      constituent outreach materials. Other states may have equivalent political
      data projects — see references/sources-va.md for the pattern to follow.
  - date: "2026-06-01"
    note: >
      Deseret News (deseret.com) was a strong source for "what's next" analysis
      on GOP internal dynamics — their congressional correspondent covers
      Western/conservative Republican angles that explain intra-party resistance.
      Useful for understanding why certain Senate Republicans are blocking or
      wavering, regardless of which state the briefing is for.
  - date: "2026-06-01"
    note: >
      A standalone ExternalHyperlink object placed directly in a section
      content array — e.g. as the last item in a stateImpact list — causes
      a docx schema validation error: "externalHyperlink: This element is not
      expected. Expected is sectPr." Hyperlinks must always be children of a
      Paragraph, never top-level children of the document or section. Wrap
      any lone link in a body() call: body([run('label: '), link(...)]).
  - date: "2026-06-01"
    note: >
      The body() helper in brief-base.js must handle being called with an array
      as its first argument — body([run(...), link(...)]) — as well as the spread
      form body(run(...), 'text', link(...)). If body() uses a naive ...parts
      spread and doesn't flatten a single-array argument, the array serializes
      as <0/> in the XML, causing a validation error. Fix: check if parts has a
      single array argument and flatten before mapping. The validator catches
      this — always run validate.py after every build.
  - date: "2026-06-05"
    note: >
      House roll call vote data: clerk.house.gov does not support state-filtered
      queries — the XML is a flat file of all 435 members. fetch-votes.sh assumes
      bash network access, but clerk.house.gov is not in the bash allowlist and
      curl will fail silently. Fallback: fetch the full roll call via web_fetch
      with text_content_token_limit=40000 (required to avoid mid-alphabet
      truncation), then filter in Python by state attribute. Never use web search
      or third-party aggregators for individual member votes — use the House Clerk
      record directly. The Notes & Caveats section should say votes were
      "confirmed from the House Clerk official roll call record" — no need to
      mention the underlying file format.
  - date: "2026-06-05"
    note: >
      Do not use or recommend the ProPublica Congress API. It is closed and out
      of date. The correct primary source for House roll call votes is the House
      Clerk (clerk.house.gov). For Senate votes, use dailypress.senate.gov.
  - date: "2026-06-05"
    note: >
      "Funding" is a neutral term — it does not imply an increase or a cut.
      Do not flag it as implying either direction without explicit context in
      the source material.
  - date: "2026-06-05"
    note: >
      Apostrophes in JavaScript string literals cause SyntaxError if the string
      delimiter is a single quote (e.g., bold('Warner's') fails). Use Unicode
      smart quotes (U+2019, \u2019) for possessives and contractions inside
      single-quoted JS strings, or switch the delimiter to a backtick. Run
      node <file>.js immediately after writing to catch these before building
      the docx. sed replacements can also corrupt property names — always
      inspect the output of any bulk find-replace before running node.
---

# Advocacy Legislation Brief

Produce accurate, actionable briefings on federal legislation and executive
orders for Indivisible group leaders and similar civic advocacy audiences.
The goal is not just analysis — it is to tell group leaders what to do right
now, grounded in verified facts specific to their state and districts.

Accuracy is the foundation of this skill's value. A briefing that misleads
group leaders — even with a plausible-sounding but unverified statistic —
erodes trust and can misdirect real organizing energy. Verify every specific
claim before it goes in the briefing.

**Audience scope:** These briefings are written for the statewide network —
all `{{state}}` group leaders, not any single group or congressional
district. Cover all relevant state members evenhandedly. Do not weight,
emphasize, or call out any particular district just because the requester
happens to live there. If a specific group wants a district-focused version,
that is a separate, narrower deliverable.

---

## Configuration

This skill is pre-configured for `{{state}}` with the following delegation:

**Senators:** {{senators}}
**House seats:** {{house_seats}}
**State-specific sources:** See `references/sources-va.md` and `references/sources-national.md`

To adapt this skill for another state, update the front matter fields and
create `references/sources-[statecode].md`. See CONTRIBUTING.md for full
instructions. The workflow, output template, and accuracy rules remain the
same regardless of state.

---

## Research Workflow

Execute these steps in order. Do not write the briefing until Step 5.

### Step 0 — Load state context and source references

Before doing any research, load these three files:

1. `state-context-{{state_code}}.md` — pre-verified delegation, committee
   assignments, and contact information for `{{state}}`. Do not search for
   any information already present here.
2. `references/sources-national.md` — universal source hierarchy and
   reliability ratings for all states.
3. `references/sources-{{state_code}}.md` — state-specific sources,
   citation formats, and session notes.

Load all three now. Do not proceed to Step 1 until they are in context.

If no state context file exists yet, complete Steps 1–3 manually and create
one before the next session. See CONTRIBUTING.md for the format.

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
5. **House Clerk roll call** — When a House floor vote has already occurred,
   get the state delegation breakdown directly from the House Clerk's official
   roll call record. Do not use web search or third-party aggregators for
   individual member votes — they can contain errors.

   **Preferred:** run `scripts/fetch-votes.sh` if bash network access is
   available:
   ```
   ./scripts/fetch-votes.sh <year> <roll-number> <state-code>
   ./scripts/fetch-votes.sh 2026 205 VA
   ```

   **Fallback (clerk.house.gov not in bash allowlist):** fetch the full roll
   call via `web_fetch` with `text_content_token_limit=40000` — the default
   limit truncates mid-alphabet and will miss members with later last names.
   Then filter in Python locally:
   ```python
   import xml.etree.ElementTree as ET
   # xml_content = string returned by web_fetch
   root = ET.fromstring(xml_content)
   for rv in root.findall('.//recorded-vote'):
       leg = rv.find('legislator')
       vote = rv.find('vote')
       if leg is not None and leg.get('state') == 'VA':
           print(f"{leg.get('unaccented-name')} ({leg.get('party')}): {vote.text}")
   ```
   URL pattern: `https://clerk.house.gov/evs/{year}/roll{number}.xml`
   Roll number and year come from the congress.gov bill Actions tab.

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
healthcare, telecommunications — donor data from scripts/fetch-donors.sh
(or api.open.fec.gov directly) may help explain member positions and motivate
constituent pressure. Include a "Donor Context" section after House Members
when the human has provided this data. Do not include donor data on every
briefing — only when sector-linked influence is plausible and illuminates
the bill. **Framing rule:** state donor figures as facts, not conclusions.
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
use a short readable label (e.g., `[democracy docket]` for
democracydocket.com). Never use generic text like "click here."

**Link precision:** The link text stays short (`[vera.org]`), but the URL
must point to the specific article or page containing the claim — never to a
root domain or homepage. A reader tapping `[vera.org]` should land on the
exact page, not the front door.

- The URL behind the label must be the specific article, report page, or press
  release — not `https://vera.org` when a deeper URL exists.
- For interactive dashboards or data tools that have no permalink: find the
  static article or report that cites the same figure and use that URL instead.
  Most data publishers (Vera, TRAC, Census) publish companion articles with
  citable versions of dashboard findings.
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

6. **`{{state}}` Members — Positions & Contact**
   A two-column table. Column 1 (narrow): member name in bold, role in smaller
   mid-gray text on a second line, district below that. Column 2 (wide): three
   lines in order — priority action label in bold, position in plain language,
   DC phone and contact form link inline.

   Priority labels (use exactly these):
   - **→ Call now** — persuadable, wavering, or position unclear
   - **→ Thank and reinforce** — confirmed ally; thank them and ask them to
     press colleagues
   - **→ Constituent pressure only** — firm opponent; mobilize their own
     constituents, not ours

   Priority label order in the table must match the contact ranking in
   section 4. Every row includes DC phone number and contact form link.
   Include public email address if one exists.

7. **Donor Context** [optional — sector-linked bills only]
   One paragraph per relevant member. State figures as facts: amount, industry
   sector, cycle year. Never editorialize. Include only when the bill involves
   a sector where financial influence is plausibly explanatory (energy, pharma,
   financial regulation, firearms, healthcare, telecommunications, cryptocurrency). Omit
   entirely otherwise.

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
- Members: Two columns — member (2880 DXA, light gray fill) and action
  (6480 DXA, white). Member column: name bold, role in smaller mid-gray
  below, district below that. Action column: priority label bold, then
  position, then contact — each on its own line. Header row in navy fill
  with white bold text.

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
the status date instead. If page numbers are essential, investigate
`SimpleField("PAGE")` as an alternative, but validate the output carefully.

### Pre-Delivery Self-Check

Before writing the final docx, complete every item below in order. Do not
skip steps or mark them complete without actually checking. These exist
because briefing failures have occurred on each of these points.

**Step 1 — Run the acronym checker (mandatory, non-negotiable)**

After writing the briefing .js file and before running `node` to build the
docx, run:

```
./scripts/check-acronyms.sh <briefing-file.js>
```

Fix every FAIL before proceeding. The checker catches unexpanded acronyms
mechanically — do not rely on memory or a mental scan. This step exists
because AUMF appeared unexpanded in a Status at a Glance field in a prior
briefing, violating the style rule. The checker enforces it.

Beyond the checked list, manually scan the briefing .js for any additional
acronyms that may not be in the checker's list yet. If you add a new acronym,
add it to `scripts/check-acronyms.sh` before using it in a briefing.

**Step 2 — Verify the following internally:**

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

## Accuracy Rules

These rules exist because group leaders will act on this briefing. An
error does not just look bad — it can misdirect real people doing real work.

1. **Every specific claim needs a source.** Vote counts, committee
   assignments, statistics, stated positions — all must trace to a verifiable
   URL. If you found it in a news article, trace it to the primary source.

2. **Check the date.** Legislative status changes fast. Always note when you
   last checked status. Flag the briefing as potentially outdated if it is
   more than a week old.

3. **Do not infer positions, and do not assert absence.** Do not write that
   a member "likely opposes" based on party. Find a press release, floor
   statement, or vote record. If you cannot find one, write **"position not
   found during research"** — never "position not publicly stated." Readers
   who attended a town hall, heard a floor speech, or follow their member
   closely may know of a stated position the research didn't surface. Claiming
   a position is "not publicly stated" asserts absence; "not found during
   research" accurately describes what happened.

4. **Distinguish source types.** Advocacy organizations like the Brennan
   Center produce high-quality analysis but have a point of view. Use them
   for impact analysis and context. Use congress.gov, senate.gov, and
   federalregister.gov for facts about status and text.

5. **Flag what you could not verify.** Put uncertain claims in Notes & Caveats
   with a note that they need human verification before distribution.

6. **Recheck before distribution.** Run a final status check on congress.gov
   before the briefing goes to group leaders.

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
- **Writing "position not publicly stated"** — this asserts that no position
  exists. Group leaders are often more plugged in than the research sources:
  they may have attended a town hall, heard a floor speech, or seen a
  constituent newsletter that never made it into the press. Write **"position
  not found during research"** instead. It's accurate about what you did, not
  what the member did or didn't do.
- **Overstating committee leverage** — committee assignments change each
  Congress. Verify current assignments, not ones from memory.
- **Citing a root domain instead of the specific page** — `[vera.org]` is not
  a verifiable citation. Always link to the article, report, or press release
  containing the exact claim. For interactive dashboards with no permalink,
  find the companion static article and link to that; flag in Notes & Caveats
  if no static page exists.
- **Using Word footnotes** — not tappable in Google Docs. Use inline
  hyperlink citations instead.
- **Assuming reconciliation viability** — reconciliation pathway claims
  require procedural verification (Byrd Rule analysis). Flag as uncertain
  unless confirmed via legislativeprocedure.com or a CRS report. Multiple
  news outlets reported conflicting reconciliation assessments for the SAVE
  Act; the clearest analysis came from nonpartisan procedural sources.
- **Stale district numbers** — redistricting litigation can change district
  compositions mid-Congress. Verify current district boundaries and member
  assignments at the state's political data source before using them in
  constituent outreach. See `references/sources-va.md` for the state-specific
  source to use.
- **District bias from the requester's location** — the briefing is for the
  statewide network. Do not over-emphasize any particular congressional
  district just because the person who requested the briefing lives there.
  All groups need the full picture.
- **Using the ProPublica Congress API for vote data** — this API is closed and
  out of date. Do not use it or recommend it. Use the House Clerk roll call
  record for House votes and dailypress.senate.gov for Senate votes.
- **Inferring member votes from party affiliation** — when a House floor vote
  has occurred, always confirm individual member votes from the House Clerk
  roll call record directly. Do not infer votes from party-line patterns even
  when the vote appears nearly unanimous. The fallback fetch procedure is
  documented in Step 2.
- **Treating "funding" as directional** — "funding" is a neutral term. It does
  not imply an increase or a cut. Do not characterize a bill as increasing or
  reducing funding without explicit support from the source material.

---

For contribution guidelines, adapting to another state, and source maintenance,
see CONTRIBUTING.md. For source reference tables, see
`references/sources-national.md` and `references/sources-va.md`.
