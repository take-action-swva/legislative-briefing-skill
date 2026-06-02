---
name: advocacy-legislation-brief
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
version: "1.7"
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
      pathway claims in Accuracy Notes unless verified via a procedural primary
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
who open documents in Google Docs or download them as PDFs. The format must
work reliably in both environments.

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

Use the shortest recognizable form of the domain as the link text:
- `[congress.gov]` not `[H.R. 22 on Congress.gov]`
- `[senator-name.senate.gov]` not `[Senator Name's website]`
- Use a short readable label for long or obscure domains: e.g., `[virginia independent]`
  for virginiaindependentnews.com, `[democracy docket]` for democracydocket.com.
  Apply the same pattern to your state's news outlets.

### Document structure

Use this template. Sections marked **[optional]** may be omitted when not
applicable, but include them whenever relevant content exists.

```
# [Bill Name or EO Title]
## Briefing for {{state}} Indivisible Group Leaders
## Date: [DATE] — Verify this information is still current before distributing

---

### Summary
[2–4 sentences. What does it actually do?]

### Current Status
[Where is it right now? What is the next procedural moment?]

### {{state}} Senators' Positions
[Stated positions with inline source links. If no public statement, say so.]

### {{state}} House Members — Key Votes & Positions
[All state members with their vote record or stated position. Focus on
committee members and persuadable votes. Note district numbers. Cover the
full delegation evenhandedly — do not give extra weight to any one district.]

#### Committee Leverage [optional]
[If any state member serves on the committee with jurisdiction, note it here.
Committee chairs and ranking members have disproportionate influence over
scheduling, amendments, and floor timing. Omit if no state member is on the
relevant committee.]

### Watch List [optional]
[Senators or House members from other states whose votes are pivotal — swing
votes, committee gatekeepers, or members facing constituent pressure that
could move them. Useful when the state's own senators are reliably for or
against and the real leverage is elsewhere. Name them specifically.]

### {{state}}-Specific Impact
[Concrete local data with inline source links.]

### Who to Contact
[Ranked: allies to thank and reinforce, persuadables to pressure, opponents
whose constituents should be mobilized. Name the members specifically.
Cover the full state delegation — do not give extra weight to any district
because of who requested the briefing.]

### Recommended Actions — Right Now
[Numbered, ranked by urgency. Specific about what to do and where to go.]

### Accuracy Notes
[Flag any claims that could not be fully verified. Note the date of last
status check. Flag if briefing is more than one week old.]
```

### Style rules

- **Summary, not Plain-Language Summary.** The section heading is always
  "Summary" — the plain language is implied by how it is written, not by
  labeling it as such.

- **Spell out acronyms on first use.** The first time any acronym or
  abbreviation appears that a non-specialist might not recognize, write out
  the full name followed by the acronym in parentheses. Subsequent references
  may use the acronym alone. Apply this to committee names, agency names,
  bill titles, and legislative procedures.

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

### Docx formatting conventions

- **Page size:** US Letter (8.5 × 11 in)
- **Margins:** 1 inch all sides
- **Font:** Arial, 11pt body
- **Header:** Organization name and briefing type
- **Footer:** Status date (page numbers optional — see note below)
- **Active threat sections:** Use red heading color to signal urgency
- **Active opportunity sections:** Use standard heading color
- **Page numbers:** `PageNumberElement` from the docx npm package causes a
  validation error in the current skill environment. Use a static footer with
  the status date instead. If page numbers are essential, investigate
  `SimpleField("PAGE")` as an alternative, but validate the output carefully.

### Pre-Delivery Self-Check

Before writing the final docx, verify each item below internally. This check
catches the most common AI failure modes before they reach group leaders.

- [ ] Every stated member position has a source URL — not inferred from party
- [ ] Bill number and Congress session are specified exactly
- [ ] Status confirmed from congress.gov or dailypress.senate.gov — not only from news
- [ ] State-specific data used where available — not only national statistics
- [ ] All `{{state}}` House members covered evenhandedly — no district given extra weight
- [ ] Reconciliation pathway claims (if any) flagged in Accuracy Notes unless confirmed via a procedural primary source
- [ ] Recommended Actions has at least one action doable right now, not just "watch and wait"
- [ ] Accuracy Notes section present and flags all unverified claims
- [ ] Date of last status check stated in Accuracy Notes

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

3. **Do not infer positions.** Do not write that a member "likely opposes"
   based on party. Find a press release, floor statement, or vote record — or
   write "position not publicly stated."

4. **Distinguish source types.** Advocacy organizations like the Brennan
   Center produce high-quality analysis but have a point of view. Use them
   for impact analysis and context. Use congress.gov, senate.gov, and
   federalregister.gov for facts about status and text.

5. **Flag what you could not verify.** Put uncertain claims in Accuracy Notes
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
- **Overstating committee leverage** — committee assignments change each
  Congress. Verify current assignments, not ones from memory.
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

---

For contribution guidelines, adapting to another state, and source maintenance,
see CONTRIBUTING.md. For source reference tables, see
`references/sources-national.md` and `references/sources-va.md`.
