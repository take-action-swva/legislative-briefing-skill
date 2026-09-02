# CTA Roundup — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests calls to action, CTAs, action asks, or a briefing on what a group
should be asking of their members of Congress. Also load it when a request
starts from a national campaign or training track rather than from a single
bill.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy rules. Begin at Step 1.

**This output type is campaign-shaped, not bill-shaped.** The other four
sub-skills all start from a bill, an executive order, or a calendar window.
This one starts from a campaign and works outward to the asks that serve it.
A single CTA roundup will usually cover several bills, at least one agency
rulemaking, and several asks that involve no legislation at all.

**Output format: markdown or docx.** Default to markdown. Produce docx only
when the user asks for it, or when the roundup is going into a packet
alongside full briefs. Unlike `brief-short.md`, markdown link syntax is
acceptable here. This document is read on a laptop or printed, not pasted
into Signal.

See "Producing the file" below for how to build and archive either format.

**Length target: 1,200–2,000 words.** Long enough to carry every live ask
across the campaigns in scope. Short enough that a group leader reads it in
one sitting before a meeting.

---

## Audience

Written for the statewide network, following the parent skill's audience
scope. Cover the full delegation evenhandedly. Tier members by *leverage*,
never by whose district the requester lives in. If a district-specific
version is wanted, that is a separate, narrower deliverable.

Assume the reader is a group leader who will convert this into a meeting
agenda item, a phone bank script, or a town hall question. Every ask must
survive that conversion without further research.

---

## Research Workflow

### Step 1 — Establish campaign scope

Identify which campaigns are in scope before researching any ask. Get this
from the user's request, from the trainings or toolkits they reference, or
by asking. Do not infer scope from a single bill mentioned in passing.

For each campaign in scope, find the organizing source: the national
toolkit, training deck, or campaign page. The campaign's own stated
congressional ask is the anchor. Everything else in that section supports it.

If a campaign has a stated ask that is vague ("speak out," "stand with
families"), your job is to convert it into something with a yes or no
answer. Do not carry the vague version into the output.

### Step 2 — Assemble the ask inventory

For each campaign, gather candidate asks across all four categories. A
roundup covering only bills is incomplete.

1. **Legislation.** Cosponsorship, floor votes, discharge petitions.
2. **Appropriations.** Riders, funding levels, program eliminations, and whatever is live in the current continuing resolution (CR) or full-year bill. Check the House and Senate committee reports, not just the bill text. Program eliminations often appear only in report language.
3. **Oversight.** Facility inspections, document demands, hearing requests, letters to agency heads. These are available to minority-party members and are frequently the only asks that produce movement.
4. **Public commitments.** On-record pledges, town hall statements, named staff contacts. These cost an office nothing to give and are therefore the easiest asks to win, which makes them good openers.

### Step 3 — Verify each ask individually

Apply the parent skill's accuracy rules to every ask. Specifically:

- **Cosponsorship asks require a current cosponsor list.** Pull it from  
  congress.gov on the day you write. Asking a member to cosponsor a bill  
  they already cosponsored destroys credibility with that office and with  
  the group leader who made the call.
- **Rulemaking asks require the Federal Register docket.** Get the docket  
  number, the comment period status, and whether a final rule has issued.  
  congress.gov will not have this.
- **Appropriations asks require the current vehicle.** A rider ask is  
  meaningless if you name the wrong bill or a CR has superseded it.
- **Public-commitment asks require checking whether it was already made.**  
  Search the member's press releases and recent floor statements first.

### Step 4 — Tier the delegation by leverage

Sort every member of the delegation into one of three tiers. Tiering is by
current movability, not by party alone and not by seniority.

**Tier 1 — Aligned.** Members who will vote the right way without pressure.
The ask here is escalation, not persuasion: use procedural tools, go on
record publicly, do oversight in the open. A supportive vote is the floor.
Name the specific escalation. "Keep up the good work" is not an ask.

**Tier 2 — Movable.** Members in competitive seats, members who have broken
with their party on a related vote, members whose stated position is
unclear. This tier gets the most words in the output. Asks here should be
public and local: town hall questions, letters to the editor, constituent
stories.

**Tier 3 — Locked.** Members who will not move on any ask in scope. Do not
omit them and do not pretend they are persuadable. The deliverable in these
districts is documentation: a written ask, a logged non-response, and a
public record usable with local press and at candidate forums. Say so
plainly so group leaders in those districts do not measure success by
whether the office responds.

Pull all member names, districts, phone numbers, and contact URLs from
`state-context-{{state_code}}.md`. Do not search for them.

Apply the parent skill's rule on inferring positions. A member is Tier 2 or
Tier 3 based on a found record, not on your read of their party. Where no
record exists, write "position not found during research" and place them in
Tier 2 by default. An unknown position is a movable one until proven
otherwise.

### Step 5 — Build the sequence

Map every ask against known dates: funding deadlines, comment period
closings, scheduled markups, the election calendar. Then group the asks into
time blocks and say what goes first.

Apply the parent skill's Scheduled / Expected / Watch distinction to every
future date. Leadership wanting a vote by a date is not a scheduled vote.

---

## Output Format

### Structure (in order)

**1. Framing facts — 2 to 4 items**

Open with the facts that shape every ask in the document. Corrected errors,
resolved litigation, seats on the ballot, and anything a reader might
otherwise get wrong. This section exists because CTA roundups get forwarded
and excerpted, and a wrong premise at the top propagates.

If a factual correction has been logged in `state-context-{{state_code}}.md`,
and it bears on the asks, state it here explicitly rather than relying on
readers to already know.

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
**Answer looks like:** [What a yes actually is — a cosponsorship, a signed
letter, a recorded statement]
```

The "Answer looks like" line is mandatory. It is what separates this output
type from a list of talking points.

**4. Sequencing**

Time blocks with what leads in each. Tie each block to a real date.

**5. Notes for group leaders**

Practical guidance on running the asks: logging contacts, the value of the
statewide pattern across all districts, the nonviolence commitment, and a
direction to re-verify before any coordinated push.

---

## Producing the file

**Markdown (default).** Write `cta-roundup-[YYYY-MM-DD].md` in the project
root. Run `./scripts/check-acronyms.sh cta-roundup-[YYYY-MM-DD].md` and fix
every FAIL. Then follow CLAUDE.md's "Briefing file lifecycle" from the copy
step onward: `cp` the `.md` to Google Drive, then `mv` it to `briefs/`.
Markdown outputs are archived in Drive alongside the docx ones so the folder
holds every deliverable, not just the docx subset.

**Docx (on request).** Write `cta-roundup-[YYYY-MM-DD].js` using
`templates/brief-base.js` and follow CLAUDE.md's "Briefing file lifecycle"
in full, substituting `cta-roundup-[YYYY-MM-DD]` for `<topic>-brief`.

Use the newsletter's minimal formatting, not the full brief's: bold for ask
headlines and field labels, plain paragraphs for body text. No shaded boxes,
no colored headings, no tables. Do not use `templates/va-members-table.js` —
the delegation tiers in this document are prose, and the four-column
reference table belongs to full briefings.

---

## Volatile Items — Pre-Publish Verification

Parent skill Rule 6 requires a status recheck on congress.gov before
distribution. That is too narrow for this output type. Most CTA roundups
contain asks that congress.gov cannot confirm.

Re-verify all of the following on the day the document goes out:

- [ ] **Cosponsor lists** for every bill named, from congress.gov
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

- [ ] Every ask names a bill, docket, or specific action
- [ ] Every ask has an "Answer looks like" line
- [ ] No ask requests something the target has already done
- [ ] Full delegation covered, tiered by leverage not by district number
- [ ] Tier 3 framed as documentation, not as persuasion
- [ ] Framing-facts section carries any logged corrections
- [ ] Contact details pulled from state context, not searched
- [ ] Volatile items checklist above completed on the day of distribution

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