---
name: legislative-briefing-skill
description: >
  Use this skill whenever someone asks you to research, analyze, summarize, or
  produce a briefing on federal legislation or executive orders for civic
  advocacy, grassroots organizing, Indivisible groups, or similar audiences.
  Also use for short summaries or quick briefs on legislation, and for
  forward-looking 90-day legislative outlook scans. Trigger on phrases like
  "brief me on this bill", "what should our group do about", "give me a quick
  summary", "what's coming up in the next 90 days", "what should we be
  watching", "research this EO for our members", "what's the status of", or
  any request combining legislation with advocacy, action, or organizing.
version: "2.1"
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
      pathway claims in Notes unless verified via a procedural primary source.
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
| Monthly digest, newsletter, what's moving this month | `skills/newsletter.md` |
| 90-day outlook, what's coming, forward scan | `skills/horizon-90.md` |

If a request could plausibly match more than one row (e.g. "a quick summary
of what's moving this month" matches both `brief-short.md`'s "quick summary"
and `newsletter.md`'s "what's moving this month"), disambiguate by scope and
artifact shape, not by keyword count: a single bill with an act-now ask →
`brief-short.md`; multiple items as this month's digest → `newsletter.md`.
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

These rules apply to all output types — full brief, short brief, newsletter,
and horizon scan. No exceptions.

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
   before the output goes to group leaders.

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

## Shared Style Rules

These rules apply to all output types — full brief, short brief, newsletter,
and horizon scan. Sub-skills may add format-specific rules on top of these.

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
