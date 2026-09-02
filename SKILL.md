---
name: legislative-briefing-skill
description: >
  Use this skill whenever someone asks you to research, analyze, summarize, or
  produce a briefing on federal legislation or executive orders for civic
  advocacy, grassroots organizing, Indivisible groups, or similar audiences.
  Also use for short summaries or quick briefs on legislation, for
  forward-looking 90-day legislative outlook scans, for monthly legislative
  digests and newsletters, and for calls-to-action roundups that turn a
  national campaign into specific congressional asks.
  Trigger immediately on the phrases "CTA brief" or "calls to action brief".
  Also trigger on phrases like "brief me on this bill", "what should our group
  do about", "give me a quick summary", "what's coming up in the next 90 days",
  "what should we be watching", "research this EO for our members", "what's the
  status of", "calls to action", "CTAs", "action asks", "what should we ask our
  reps", "what should we be demanding", "what do we tell our members to do",
  "monthly newsletter", "the digest", "what's moving this month", or
  any request combining legislation with advocacy, action, or organizing. Also
  trigger on named campaigns and training tracks, including Hands Off Our Vote,
  Immigrant Justice Summer, and Dismantling Detention.
version: "3.0"
output_format: [docx, markdown]
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
      (trac.syr.edu) provides Immigration and Customs Enforcement (ICE)
      enforcement data by state and district,
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
      pathway claims in Notes unless verified via a procedural primary source.
  - date: "2026-06-01"
    note: >
      [Virginia] (Updated 2026-09-02.) House district numbers and compositions
      can shift mid-Congress due to redistricting litigation. Virginia's 2026
      mid-decade redistricting amendment was approved by voters on 2026-04-21,
      struck down by the Supreme Court of Virginia on 2026-05-08, and the U.S.
      Supreme Court declined the emergency appeal on 2026-05-15. The 2021 maps
      remain in force. Never state or imply that Virginia district lines
      changed. Always verify current district boundaries and member assignments
      at VPAP (vpap.org) before using district numbers in constituent outreach
      materials. Other states may have equivalent political data projects —
      see references/sources-va.md for the pattern to follow.
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
      content array causes a docx schema validation error. Hyperlinks must
      always be children of a Paragraph, never top-level children of the
      document or section. Wrap any lone link in a body() call:
      body([run('label: '), link(...)]).
  - date: "2026-06-01"
    note: >
      The body() helper in brief-base.js must handle being called with an array
      as its first argument — body([run(...), link(...)]) — as well as the spread
      form body(run(...), 'text', link(...)). If body() uses a naive ...parts
      spread and doesn't flatten a single-array argument, the array serializes
      as <0/> in the XML. Fix: check if parts has a single array argument and
      flatten before mapping.
  - date: "2026-09-02"
    note: >
      Rule 6's congress.gov recheck is not sufficient for any output that cites
      something outside the legislative process. Two errors reached a
      distributed Virginia document: a congressional map that had already been
      struck down, and a stale account of the USPS mail-ballot rulemaking.
      Neither appears on congress.gov. Before distribution, separately
      re-verify cosponsor lists, Federal Register dockets, the current
      appropriations vehicle, litigation affecting district maps or election
      procedure, and delegation composition. skills/cta-roundup.md carries this
      as a structural checklist.
  - date: "2026-09-02"
    note: >
      Skill descriptions are matched against the user's phrasing before any
      sub-skill loads, so a guardrail written only in the body cannot fire if
      the description does not match. The v2.1 description was bill-shaped
      ("brief me on this bill", "what's the status of") and did not match
      campaign-shaped requests about calls to action, so the redistricting
      guardrail already recorded above never loaded. When adding a new output
      type, add its natural phrasing to the description in the same change.
---

# Advocacy Legislation Brief — Virginia Indivisible

Produce accurate, actionable outputs on federal legislation and executive
orders for Indivisible group leaders and similar civic advocacy audiences.
The goal is not just analysis — it is to tell group leaders what to do right
now, grounded in verified facts specific to their state and districts.

Accuracy is the foundation of this skill's value. A briefing that misleads
group leaders — even with a plausible-sounding but unverified statistic —
erodes trust and can misdirect real organizing energy. Verify every specific
claim before it goes in the output.

**Audience scope:** These outputs are written for the statewide network —
all `{{state}}` group leaders, not any single group or congressional district.
Cover all relevant state members evenhandedly. Do not weight, emphasize, or
call out any particular district just because the requester happens to live
there. If a specific group wants a district-focused version, that is a
separate, narrower deliverable.

---

## Configuration

This skill is pre-configured for `{{state}}` with the following delegation:

**Senators:** {{senators}}  
**House seats:** {{house_seats}}  
**State-specific sources:** See `references/sources-va.md` and `references/sources-national.md`

To adapt this skill for another state, update the front matter fields and
create `references/sources-[statecode].md`. See CONTRIBUTING.md for full
instructions.

---

## Which Sub-Skill to Load

Based on what the user is asking for, load the relevant sub-file now:

| Request type | Sub-file to load |
|---|---|
| Full legislative briefing, detailed analysis, `.docx` output | `skills/brief-full.md` |
| Short brief, quick summary, one-pager | `skills/brief-short.md` |
| 90-day outlook, what's coming, forward scan | `skills/horizon-90.md` |
| Calls to action, CTAs, campaign asks, monthly digest, newsletter, what's moving this month | `skills/cta-roundup.md` |

If a request could plausibly match more than one row (e.g. "a quick summary
of what's moving this month" matches both `brief-short.md`'s "quick summary"
and `cta-roundup.md`'s "what's moving this month"), disambiguate by scope and
artifact shape, not by keyword count: a single bill with an act-now ask →
`brief-short.md`; several items or campaigns carrying a set of asks →
`cta-roundup.md`. The distinguishing test for `cta-roundup.md` is whether the
request starts from the asks rather than from a bill, an executive order, or
a calendar window.

`cta-roundup.md` covers both the campaign roundup and the monthly digest as
two modes of one document. Load it for either and choose the mode from the
table inside that file — do not treat "newsletter" and "CTAs" as separate
sub-skills.

If still unclear, ask which one the user means rather than guessing.

Load the matching sub-file before proceeding to Step 0.

---

## Step 0 — Load State Context and Source References

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

---

## Shared Accuracy Rules

These rules apply to all output types — full brief, short brief, horizon
scan, and CTA roundup in either mode. No exceptions.

1. **Every specific claim needs a source.** Vote counts, committee
   assignments, statistics, stated positions — all must trace to a verifiable
   URL. If you found it in a news article, trace it to the primary source.

2. **Check the date.** Legislative status changes fast. Always note when you
   last checked status. Flag the output as potentially outdated if it is
   more than a week old.

3. **Do not infer positions, and do not assert absence.** Do not write that
   a member "likely opposes" based on party. Find a press release, floor
   statement, or vote record. If you cannot find one, write **"position not
   found during research"** — never "position not publicly stated." Readers
   who attended a town hall, heard a floor speech, or follow their member
   closely may know of a stated position the research didn't surface.

4. **Distinguish source types.** Advocacy organizations like the Brennan
   Center produce high-quality analysis but have a point of view. Use them
   for impact analysis and context. Use congress.gov, senate.gov, and
   federalregister.gov for facts about status and text.

5. **Flag what you could not verify.** Put uncertain claims in Notes with
   a note that they need human verification before distribution.

6. **Recheck before distribution.** Run a final status check on congress.gov
   before the output goes to group leaders. congress.gov alone is not enough
   whenever an output cites something outside the legislative process. Also
   re-verify, on the day of distribution: cosponsor lists for every bill
   named, Federal Register dockets for any agency rulemaking cited, the
   current appropriations vehicle (continuing resolution or full-year bill),
   any litigation affecting district maps or election procedure, and the
   current delegation roster. `skills/cta-roundup.md` applies this as a
   structural checklist; other output types should work through the same list
   in whatever form applies to their content.

7. **Never state a future date as more certain than it is.** When citing a
   markup, floor vote, rule effective date, or any other date that hasn't
   happened yet, distinguish what's confirmed from what's merely intended:
   **Scheduled** (a confirmed date exists on a calendar or committee notice),
   **Expected** (leadership or a committee has stated intent, but no
   confirmed date exists), or **Watch** (could happen in this timeframe
   depending on developments, but timing isn't knowable yet). Leadership
   "wanting" a vote by a certain date is not the same as a markup notice
   existing — do not write the former as if it were the latter.
   `skills/horizon-90.md` applies this as a structural Scheduled/Expected/Watch
   tag on every item; other output types should apply the same distinction in
   prose whenever a future date is stated.

---

## Shared Pre-Delivery Check

Every output type runs these items before it goes anywhere. Each sub-skill
adds its own format-specific items on top; none of them repeat these.

- [ ] Acronyms expanded on first use (Shared Style Rules)
- [ ] No em dashes in prose (Shared Style Rules)
- [ ] Every stated member position traces to a source URL, and any member with
      no record found is written as "position not found during research"
      (Accuracy Rule 3)
- [ ] Status confirmed from a primary source, not only from news coverage
      (Accuracy Rule 1)
- [ ] Every future date tagged Scheduled, Expected, or Watch, in prose or as a
      structural tag (Accuracy Rule 7)
- [ ] Claims that could not be verified are flagged for human review
      (Accuracy Rule 5)
- [ ] Volatile items re-verified on the day of distribution (Accuracy Rule 6)
- [ ] `./scripts/check-acronyms.sh` run against the output source, `.js` or
      `.md`, with every FAIL fixed
- [ ] `humanizer` skill applied to all free-text prose. Do not apply it to
      structured fields: tables, contact blocks, date lines, citation link
      text, or call scripts.

---

## Shared Style Rules

These rules apply to all output types — full brief, short brief, horizon
scan, and CTA roundup in either mode. Sub-skills may add format-specific rules on top of these.

- **No em dashes in prose.** Em dashes are acceptable in structured fields
  (e.g., member entry headers: "Sen. Warner — Ranking Member") but not in
  sentences. Rewrite to a period or plain conjunction instead.

- **Concrete nouns over generic ones.** Write "emails, text messages, and
  phone calls" not "messages." Write "your doctor, your bank" not "private
  parties." Specifics land harder on a phone screen.

- **Break long bullets into short sentences.** A bullet with two or three
  short sentences reads faster than one long sentence with multiple clauses.

- **Acronyms on first use.** Write out the full name followed by the
  acronym in parentheses on first mention. Subsequent uses may use the
  acronym alone.

- **Gloss jargon on first use.** Terms like "cloture," "Byrd Rule," and
  "markup" need a brief plain-language parenthetical the first time they
  appear. Group leaders may not have a legislative background.
