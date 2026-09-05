---
title: Briefing Quality Assurance Checklist
skill: advocacy-legislation-brief
version: "3.2"
---

# Briefing Quality Assurance (QA) Checklist

Use after any AI-generated output before distributing to group leaders.
**Check every box or note why it was skipped.**

Briefing topic: ____________________________________________   Date: ________________

State: ____________________________________________   Reviewer: ____________________________________________

Output type (circle one):
**Full brief** · **Short brief** · **Calls to action (CTA) roundup — campaign** ·
**CTA roundup — digest** · **90-day horizon**

---

## 1. Shared Pre-Delivery Check

Every output type runs these, regardless of format. These mirror SKILL.md's
Shared Pre-Delivery Check — if one cannot be checked, the output does not go
out.

- [ ] `./scripts/check-acronyms.sh` run against the output source (`.js` or
  `.md`), with **every FAIL fixed** — this is a gate, not a suggestion
- [ ] `humanizer` skill applied to free-text prose, and **not** applied to
  tables, contact blocks, date lines, citation link text, or call scripts
- [ ] Acronyms expanded on first use, in the order a reader meets them
- [ ] No em dashes in prose
- [ ] Every stated member position traces to a source URL; any member with no
  record found reads "position not found during research"
- [ ] Status confirmed from a primary source, not only from news coverage
- [ ] Every future date tagged **Scheduled**, **Expected**, or **Watch**
- [ ] Claims that could not be verified are flagged for human review
- [ ] Volatile items re-verified **on the day of distribution**: cosponsor
  lists, Federal Register dockets, the current appropriations vehicle,
  litigation affecting district maps or election procedure, and delegation
  composition. The `issues/` cache never satisfies this.

---

## 2. Document Structure

Complete only the subsection matching this output's type.

### 2a. Full brief (.docx)

- [ ] Produced as a **.docx file**, not plain markdown or text
- [ ] Citations are inline **[source]** hyperlinks, not Word footnotes
  *(footnotes are not tappable in Google Docs)*
- [ ] Opens and renders correctly in Google Docs

**Required sections, in order:**
- [ ] Title block (org name, bill title, audience, issue area, date)
- [ ] TL;DR box — five sentences or fewer; shading matches threat level
- [ ] Status at a Glance — all seven fields: Current status, Last action,
  Next decision point, Core dispute, Administration position, Bill
  supporters, Threat level
- [ ] Recommended Actions — Right Now, opening with contact actions in the
  shared ranking
- [ ] Why It Matters — bulleted, bold key phrase leading each bullet
- [ ] Delegation — Committee & Position Reference table, built from
  `templates/va-members-table.js`, on its own page
- [ ] `./scripts/check-delegation-parity.sh` run and passing — the table
  duplicates `state-context-va.md` by hand, and has drifted from it before
- [ ] Notes & Caveats

**Optional, when applicable:**
- [ ] Donor Context, if the bill is sector-linked and donor data exists
- [ ] Watch List, if pivotal votes sit outside the state delegation
- [ ] Legislative Timeline

### 2b. Short brief (markdown)

- [ ] Readable where markdown does not render — no nested formatting, plain
  dashes for bullets, **bare URLs** rather than link syntax
- [ ] Hook — 1–2 sentences, leads with the threat or opportunity, not the
  bill's name. No background, no history.
- [ ] Act now — **2–3 members maximum**, in the shared contact ranking
- [ ] Each member entry carries name, role, DC phone, contact URL, and a
  one-sentence ask
- [ ] Ask lines are single directive sentences — **no call scripts**
- [ ] Contact details came from `state-context-[statecode].md`, not a search
- [ ] Why it matters — 2 bullets, 3 maximum
- [ ] Next trigger — one line naming the next decision point and its deadline
- [ ] Full briefing link — one line, bare URL

### 2c. CTA roundup — campaign mode

- [ ] Framing facts — 2 to 4 items, including any logged factual correction
  that bears on the asks
- [ ] Delegation and tiers — a short paragraph per tier
- [ ] One section per campaign, with numbered asks inside
- [ ] Every ask carries **Ask**, **Target**, and **Answer looks like**
- [ ] "Answer looks like" names a concrete yes — a cosponsorship, a signed
  letter, a recorded statement — not a sentiment
- [ ] Sequencing — time blocks, each tied to a real date
- [ ] Notes for group leaders — logging contacts, the statewide pattern, the
  nonviolence commitment, and re-verification before a coordinated push

### 2d. CTA roundup — digest mode

- [ ] Header is `[Month Year] — [State] Indivisible Legislative Update`, with
  no subtitle or deck
- [ ] Optional one-line framing, or omitted entirely if nothing meaningful
  fits in one sentence
- [ ] **Five items maximum**
- [ ] Each item has ISSUE NAME, Status, 2–3 sentences of why it matters, Act,
  and Answer looks like — no added fields
- [ ] Every item's "Answer looks like" line is present
- [ ] Items separated by horizontal rules
- [ ] Stalled items dropped rather than carried forward

### 2e. 90-day horizon scan

- [ ] Header carries scan date and the window it covers
- [ ] "Looking Ahead at a Glance" table is **two columns** — never three
- [ ] Rows sorted chronologically, with no-window Watch items grouped in a
  single trailing block rather than interspersed by guessed timing
- [ ] Items grouped under actual calendar month headings, not "next 30 days"
- [ ] Every item carries a certainty tag: Scheduled, Expected, or Watch
- [ ] Every item has Window, mechanism, state angle (or an explicit "No
  [state]-specific angle identified"), and Prepare

---

## 3. Accuracy & Sources

**If any box here cannot be checked, the output should not be distributed.**

### Bill / Executive Order identity

- [ ] Exact bill number confirmed *(e.g. H.R. 22, not just "the SAVE Act")*
- [ ] Congress session noted *(e.g. 119th Congress, 2025–2026)*
- [ ] Confirmed this is the current version, not a superseded one
- [ ] Where House and Senate companions exist, the correct one is cited for
  each claim

### Status verification

- [ ] Current status verified at [congress.gov](https://congress.gov) or
  [senate.gov](https://senate.gov), not only from a news article
- [ ] Senate floor procedural details confirmed at
  [dailypress.senate.gov](https://www.dailypress.senate.gov) where relevant
- [ ] Status checked within the past week; flagged if older
- [ ] Next procedural moment identified

### Member positions

- [ ] Every stated position has a source *(press release, floor statement, or
  vote record)*
- [ ] No position inferred from party affiliation alone
- [ ] Unstated positions read "position not found during research" — not left
  blank, and never "position not publicly stated"
- [ ] A member with no found record is treated as **Tier 2 Movable**, never
  assumed to be an ally
- [ ] District numbers and committee assignments verified against the state's
  political data source *(redistricting litigation can change these
  mid-Congress)*

### Statistics & impact claims

- [ ] Every statistic has a source link
- [ ] State-specific data used where available, not only national figures
- [ ] Advocacy org sources *(Brennan Center, Campaign Legal Center, Democracy
  Docket)* used for context and analysis, never for stating legislative status
- [ ] Reconciliation pathway claims flagged in Notes unless confirmed from a
  procedural primary source such as a Congressional Research Service (CRS)
  report

### Notes section

- [ ] Unverified claims are flagged
- [ ] Date of last status check is stated
- [ ] Flagged as potentially outdated if more than a week old

---

## 4. Actionability & Member Taxonomy

An output without a clear, specific ask is incomplete for this audience.

- [ ] Actions are ranked by leverage, in the shared order: **Gatekeepers
  first regardless of tier**, then Tier 2 Movable, then Tier 1 Aligned, then
  Tier 3 Locked
- [ ] Each action is specific — names a person to contact, a URL, a deadline
- [ ] **Tier 1 Aligned** members get "Thank and reinforce," naming the
  specific escalation being asked for — not a generic thank-you
- [ ] **Tier 2 Movable** members get "Call now"
- [ ] **Tier 3 Locked** members get "Contact and log" — a written ask with the
  documentation framing. They are **never omitted from contact**; the
  deliverable in those districts is the record, not a reply
- [ ] **Gatekeeper** is applied as a flag on top of a tier, not as a
  replacement for one *(an Aligned Gatekeeper is expressible and is usually
  the highest-leverage target in the delegation)*
- [ ] No member classification vocabulary appears that is not in SKILL.md's
  Shared Member Taxonomy
- [ ] At least one action is doable **right now** — not only "watch and wait"

---

## 5. Final Check Before Distributing

- [ ] Final status check run at [congress.gov](https://congress.gov) since
  research began
- [ ] Active court challenges checked at
  [democracydocket.com](https://democracydocket.com) *(for voting rights and
  election bills — litigation often moves faster than legislation)*
- [ ] New rulings or injunctions checked for any active Executive Orders (EOs)
- [ ] For docx outputs: PDF exported from Google Docs, links tested on mobile
- [ ] Output date visible and accurate
- [ ] Deliverable published with `./scripts/publish.sh` and added to
  `brief-index.md`
- [ ] Research recorded in the matching `issues/` file, or a new one created

---

## Reviewer Notes

*Use this space to flag anything that needed extra verification, sources that
were hard to find, or suggested improvements to the skill.*

After review, add notable findings to `lessons_learned` in SKILL.md front
matter.

___

___

___

___
