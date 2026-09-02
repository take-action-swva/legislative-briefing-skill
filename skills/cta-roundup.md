# CTA Roundup — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests calls to action, CTAs, action asks, a monthly legislative digest or
newsletter, or a briefing on what a group should be asking of their members
of Congress.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy rules. Begin at Step 1.

**This output type is ask-shaped, not bill-shaped.** `brief-full.md` and
`brief-short.md` start from a bill or an executive order. `horizon-90.md`
starts from a calendar window. This one starts from the asks and works
outward, so a single document routinely spans several bills, at least one
agency rulemaking, and asks that involve no legislation at all.

---

## The two modes

This sub-skill produces two documents. They share a research workflow, the
delegation tiering, the ask-verification rules, and the volatile-items check.
They differ in what the reader is holding at the end.

**Campaign mode (default).** Starts from one or more campaigns or training
tracks and carries every live ask across them. Asks are grouped by campaign.
Markdown by default, docx on request. Length target 1,200–2,000 words: long
enough to carry every live ask, short enough that a group leader reads it in
one sitting before a meeting.

**Digest mode.** The monthly legislative update. Up to 5 standalone items,
each readable in 60 seconds, each with a near-term action point. Always docx,
with minimal formatting, because it is a content handoff to the newsletter
team who apply their own visual treatment.

### Choosing a mode

| The request says | Mode |
|---|---|
| A campaign or training track by name; "what should we be asking for"; "CTAs for the meeting" | Campaign |
| "Monthly newsletter"; "the digest"; "what's moving this month" | Digest |
| A recurring monthly cadence, or the newsletter team is the recipient | Digest |
| Asks spanning several campaigns with no monthly framing | Campaign |

If the request carries signals from both rows, ask. The two documents go to
different readers and a wrong guess wastes the research.

Everything below applies to both modes unless a paragraph is marked
**Campaign mode** or **Digest mode**.

---

## Audience

Written for the statewide network, following the parent skill's audience
scope. Tier members by *leverage*, never by whose district the requester
lives in. If a district-specific version is wanted, that is a separate,
narrower deliverable.

Assume a group leader who is savvy and already well informed. Skip process
basics and extended legislative history: they know what a markup is. They
will convert this into a meeting agenda item, a phone bank script, or a town
hall question, and every ask must survive that conversion without further
research.

**Campaign mode** covers the full delegation evenhandedly. **Digest mode**
names only the one or two members per item with the most leverage. The
tiering in Step 4 governs both; they differ in how many members reach the
page.

---

## Research Workflow

### Step 1 — Establish scope

**Campaign mode.** Identify which campaigns are in scope before researching
any ask. Get this from the user's request, from the trainings or toolkits
they reference, or by asking. Do not infer scope from a single bill
mentioned in passing.

For each campaign in scope, find the organizing source: the national
toolkit, training deck, or campaign page. The campaign's own stated
congressional ask is the anchor. Everything else in that section supports it.

If a campaign has a stated ask that is vague ("speak out," "stand with
families"), your job is to convert it into something with a yes or no
answer. Do not carry the vague version into the output.

**Digest mode.** Scan what is moving this month. Sources:

- congress.gov — bills with floor votes, markups, or committee action scheduled
- indivisible.org/get-involved/take-action/ — national campaign priorities
  (one input, not a required list)
- dailypress.senate.gov — scheduled Senate floor activity
- News sources per `references/sources-national.md`

Cast a wide net first. Pull 8–10 candidates before narrowing.

### Step 2 — Assemble the ask inventory

Gather candidate asks across all four categories. A document covering only
bills is incomplete in either mode.

1. **Legislation.** Cosponsorship, floor votes, discharge petitions.
2. **Appropriations.** Riders, funding levels, program eliminations, and whatever is live in the current continuing resolution (CR) or full-year bill. Check the House and Senate committee reports, not just the bill text. Program eliminations often appear only in report language.
3. **Oversight.** Facility inspections, document demands, hearing requests, letters to agency heads. These are available to minority-party members and are frequently the only asks that produce movement.
4. **Public commitments.** On-record pledges, town hall statements, named staff contacts. These cost an office nothing to give and are therefore the easiest asks to win, which makes them good openers.

**Digest mode — narrow to 5.** Select up to five items, prioritizing by:

1. **Near-term action point.** A vote, markup, or procedural moment expected
   this month or early next. No action point means it is not digest material
   right now.
2. **Constituent pressure can move the outcome.** A Tier 2 Movable member is
   involved, or a close vote is in play. Items where every relevant member is
   Tier 1 or Tier 3 are weaker digest material, though not disqualified.
3. **Virginia relevance.** A Virginia member has leverage, is the deciding
   vote, or the bill has a notable Virginia-specific impact.

Drop items that matter but are stalled with no near-term moment. Save them
for a month when they move.

### Step 3 — Verify each ask individually

Apply the parent skill's accuracy rules to every ask. Specifically:

- **Cosponsorship asks require a current cosponsor list.** Run  
  `./scripts/fetch-cosponsors.sh <congress> <type> <number> {{state_code}}`  
  on the day you write. Asking a member to cosponsor a bill they already  
  cosponsored destroys credibility with that office and with the group  
  leader who made the call. The script separates current cosponsors from  
  withdrawn ones — the congress.gov endpoint returns both mixed together,  
  and a member who withdrew is not a supporter to thank.
- **Rulemaking asks require the Federal Register docket.** Get the docket  
  number, the comment period status, and whether a final rule has issued.  
  congress.gov will not have this.
- **Appropriations asks require the current vehicle.** A rider ask is  
  meaningless if you name the wrong bill or a CR has superseded it.
- **Public-commitment asks require checking whether it was already made.**  
  Search the member's press releases and recent floor statements first.

Do not carry an item or an ask you cannot confirm from a primary source. A
stale status is worse than a missing item.

### Step 4 — Tier the delegation by leverage

Sort every member of the delegation using SKILL.md's Shared Member Taxonomy:
Tier 1 Aligned, Tier 2 Movable, Tier 3 Locked, plus the Gatekeeper flag. That
section carries the definitions, the rule that an unknown position is Tier 2,
and the contact ranking. This sub-skill originated that vocabulary and the
other output types now render it in their own labels.

Two notes specific to this output type:

**Tier 2 gets the most words.** It is the tier where the document changes an
outcome, so it earns the most space in campaign mode.

**Tier 3 gets a real ask, not a shrug.** Write the ask, name what a logged
non-response is worth, and say plainly that success in those districts is
measured by the record produced rather than by whether the office replies.

**Digest mode** applies the same tiering but publishes less of it. Each item
names only the one or two members with the most leverage on that item, chosen
by the tiers above. There is no delegation-wide section.

Pull all member names, districts, phone numbers, and contact URLs from
`state-context-{{state_code}}.md`. Do not search for them.

### Step 5 — Build the sequence

**Campaign mode.** Map every ask against known dates: funding deadlines,
comment period closings, scheduled markups, the election calendar. Then group
the asks into time blocks and say what goes first.

**Digest mode** has no sequencing section. Each item carries its own
near-term action point, and the month is the window.

In both modes, apply the parent skill's Scheduled / Expected / Watch
distinction to every future date. Leadership wanting a vote by a date is not
a scheduled vote.

---

## Output Format

### Campaign mode structure (in order)

**1. Framing facts — 2 to 4 items**

Open with the facts that shape every ask in the document. Corrected errors,
resolved litigation, seats on the ballot, and anything a reader might
otherwise get wrong. This section exists because CTA roundups get forwarded
and excerpted, and a wrong premise at the top propagates.

**Do not publish corrections that exist to keep you from making an error.**
Most logged corrections are guardrails for the writer, not news for the
reader. Virginia's district lines are the standing example: the fact is
recorded in `state-context-{{state_code}}.md` and in `issues/` so a draft
never gets it wrong, and the network already knows it. Printing it tells
group leaders something they know and implies they might not.

A correction belongs in this section only when a reader acting on the asks
would otherwise get it wrong, and the error is live in circulation. Test it
by asking what a group leader would do differently having read it. If the
answer is nothing, cut it and leave the fact in the cache where it does its
actual work.

**2. Delegation and tiers**

A short paragraph per tier explaining what the ask type is for that tier and which  
members are in it.

**3. Campaign sections**

One section per campaign. Within each, one numbered ask per subsection. Each
ask carries:

```
### [Number]. [Ask stated as an imperative]
[What is happening and why this ask, 2–4 sentences with sources]

**Ask:** [The specific action, with bill number or docket where applicable]
**Target:** [Which tier, or which named members]
**Expectations:** [What a yes actually is — a cosponsorship, a signed
letter, a recorded statement]
```

The "Expectations" line is mandatory. It is what separates this output
type from a list of talking points.

**4. Sequencing**

Time blocks with what leads in each. Tie each block to a real date.

**5. Notes for group leaders**

Practical guidance on running the asks: logging contacts, the value of the
statewide pattern across all districts, the nonviolence commitment, and a
direction to re-verify before any coordinated push.

---

### Digest mode structure (in order)

**1. Document header**

```
[Month Year] — Virginia Indivisible Legislative Update
```

No subtitle, no deck. The header is the only top-level label.

**2. Optional one-line framing**

One sentence on the overall legislative moment if it adds genuine context
(a reconciliation deadline, a recess window, a lame-duck dynamic). Omit if
nothing meaningful can be said in one sentence.

**3. Items — up to 5**

Each item uses this structure. No exceptions, no added fields.

```
[ISSUE NAME — bold, all caps]

Status: [one sentence — where it stands right now]

[2-3 sentences on why it matters. No process background. No history
beyond what a reader needs to understand the current moment.]

Act: [One or two members. For each: name, role, phone, contact URL,
one-sentence ask.]

Expectations: [What a yes actually is — a cosponsorship, a signed
letter, a recorded statement, a scheduled meeting.]
```

Separate items with a horizontal rule (`---` in the JS, rendered as a page
divider in the docx).

The "Expectations" line is mandatory here too. It is the single field
that keeps an item from degrading into a talking point, and digest items are
the ones most likely to be forwarded without their context.

**Example item**

```
MEDICAID CUTS

Status: Senate Finance Committee leadership has signaled it intends to mark
up the bill the week of June 23, though no markup notice is posted yet.

Roughly 600,000 Virginians rely on Medicaid. The current draft cuts federal
matching funds by 10%, which would require the state to either reduce
enrollment or cut provider payments. Virginia has no budget reserve large
enough to absorb the gap.

Act:
Sen. Tim Kaine — Health, Education, Labor, and Pensions Committee
DC: (202) 224-4024 | kaine.senate.gov/contact
Ask him to oppose any markup that cuts federal Medicaid matching rates.

Expectations: a public statement opposing the matching-rate cut, or an
amendment filed at markup.
```

**4. Closing line**

One sentence on what group leaders should do to track these issues between
digests — sign up for Indivisible alerts, check congress.gov, or watch for
short briefs from the steering committee.

---

## Tone

- Professional but direct. Not wooden, not chatty.
- Write to someone who already knows the stakes. Do not explain why
  healthcare or voting rights matter in the abstract.
- Assume the reader will forward the ask to their members. Write it so it
  survives that one layer of forwarding without losing its point.
- Avoid: "it is important to note," "this is a critical moment," "now more
  than ever." These are filler. If the moment is critical, the facts show it.

---

## Style rules

See SKILL.md "Shared Style Rules" for em dash, concrete nouns, and
sentence-length rules that apply to all output types.

- **No legislative process tutorials.** Do not explain what a markup is, how
  reconciliation works, or what cloture means unless the procedural fact is
  itself the news. If a gloss is needed, one parenthetical is enough.
- **Issue name over bill number as the lead.** In digest mode, use the issue
  name (MEDICAID CUTS, SURVEILLANCE REAUTHORIZATION) as the item headline and
  put the bill number in the Status line. An acronym in a headline still needs
  its expansion in the Status line or body.
- **One ask per member, one sentence.** The act line is a directive, not a
  script. Group leaders write their own scripts.

---

## Producing the file

**Campaign mode, markdown (default).** Write `cta-roundup-[YYYY-MM-DD].md` in
the project root. Run `./scripts/check-acronyms.sh cta-roundup-[YYYY-MM-DD].md`
and fix every FAIL. Then follow CLAUDE.md's "Briefing file lifecycle" from the
copy step onward: `cp` the `.md` to Google Drive, then `mv` it to `briefs/`.
Markdown outputs are archived in Drive alongside the docx ones so the folder
holds every deliverable, not just the docx subset.

**Campaign mode, docx (on request).** Write `cta-roundup-[YYYY-MM-DD].js`
using `templates/brief-base.js` and follow CLAUDE.md's "Briefing file
lifecycle" in full, substituting `cta-roundup-[YYYY-MM-DD]` for
`<topic>-brief`.

**Digest mode (always docx).** Write `[month]-[year]-digest.js` using
`templates/brief-base.js` and follow CLAUDE.md's "Briefing file lifecycle" in
full, substituting `[month]-[year]-digest` for `<topic>-brief`.

Both docx paths use minimal formatting, not the full brief's: bold for
headlines and field labels, plain paragraphs for body text. No shaded boxes,
no colored headings, no tables. The newsletter team applies visual formatting
downstream, so the docx is a clean content handoff. Do not use
`templates/va-members-table.js` — the delegation tiers here are prose, and the
four-column reference table belongs to full briefings.

---

## Volatile Items — Pre-Publish Verification

Parent skill Rule 6 requires a status recheck on congress.gov before
distribution. That is too narrow for this output type. Most CTA roundups
contain asks that congress.gov cannot confirm.

Re-verify all of the following on the day the document goes out:

- [ ] **Cosponsor lists** for every bill named — `./scripts/fetch-cosponsors.sh`, run today
- [ ] **Federal Register rulemakings** — docket status, comment period, whether a final rule has issued
- [ ] **Appropriations posture** — current CR or full-year bill, and whether any named rider or program elimination is still live
- [ ] **Litigation** affecting district maps, election procedure, or any agency action cited
- [ ] **Delegation composition** — resignations, deaths, and special elections change the roster mid-Congress
- [ ] **Campaign asks** — national organizations revise their asks between trainings. Recheck the current toolkit.

Litigation and rulemakings are the two categories that have caused actual
errors in distributed documents. Do not skip them because the underlying
legislation has not moved.

---

## Pre-Delivery Check

Run SKILL.md's Shared Pre-Delivery Check first. It covers acronyms, em dashes,
position phrasing, primary-source status, future-date tagging, the acronym
checker, and the humanizer pass. Then verify these roundup-specific items:

Both modes:

- [ ] Every ask names a bill, docket, or specific action
- [ ] Every ask has an "Expectations" line
- [ ] No ask requests something the target has already done
- [ ] Contact details pulled from state context, not searched
- [ ] Volatile items checklist above completed on the day of distribution

Campaign mode:

- [ ] Full delegation covered, tiered by leverage not by district number
- [ ] Tier 3 framed as documentation, not as persuasion
- [ ] Framing-facts section carries any logged corrections

Digest mode:

- [ ] An issue file in `issues/` written or updated for every item in the digest
- [ ] No more than 5 items
- [ ] Every item has a confirmed near-term action point
- [ ] Each Act entry has phone number and contact URL from state context
- [ ] Docx generated and opens without validation errors
- [ ] Both .js and .docx moved to briefs/

---

## Common Pitfalls

- **Asks that cannot be answered yes or no.** "Support immigrant families"  
  is not an ask an office can be held to. "Cosponsor S.2212" is.
- **Bill-only roundups.** If every ask in the document is a cosponsorship,  
  the oversight and public-commitment categories were skipped. Those are  
  often the winnable ones.
- **Treating aligned members as finished.** Tier 1 members get the weakest  
  asks in most drafts. They should get the most specific ones.
- **Pretending Tier 3 is Tier 2.** Writing hopeful asks for locked offices  
  wastes volunteer energy and teaches group leaders to distrust the document.
- **Stale cosponsor lists.** The single most common factual error in this  
  output type. Recheck on the day of distribution, not on the day of drafting.
- **Carrying a national toolkit's ask verbatim.** National asks are written  
  for all fifty states. Convert to the specific delegation before publishing.
- **Building around a map or rule that changed.** Check litigation before  
  writing anything that depends on district lines or election procedure.
- **Including stalled items in digest mode.** If there is no action point
  this month, cut the item. A digest full of "Congress is still debating"
  entries is not actionable.
- **Overloading a digest item.** Each item is 60 seconds of reading. If an
  issue needs more space, produce a short brief for it and reference it in
  the closing line.
- **Writing the act line as a script.** One directive sentence. Group leaders
  write their own scripts.
- **Running digest mode in campaign mode's shape.** A monthly digest with a
  delegation-and-tiers section and a sequencing block is a campaign roundup
  wearing the wrong header. Five standalone items, one or two members each.