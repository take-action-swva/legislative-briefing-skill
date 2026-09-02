---
name: legislative-briefing-skill
description: >
  Use whenever someone asks you to research, analyze, summarize, or produce a
  briefing on federal legislation or executive orders for civic advocacy,
  grassroots organizing, Indivisible groups, or similar audiences. Covers full
  briefings, short briefs, 90-day legislative outlook scans, monthly digests
  and newsletters, and calls-to-action roundups that turn a campaign into
  specific congressional asks. Trigger on "CTA brief", "calls to action",
  "CTAs", "action asks", "what should we ask our reps", "brief me on this
  bill", "what should our group do about", "give me a quick summary", "what's
  the status of", "research this EO for our members", "what's coming up in the
  next 90 days", "what should we be watching", "monthly newsletter", "the
  digest", "what's moving this month", or any request combining legislation
  with advocacy, action, or organizing. Also trigger on named campaigns and
  training tracks, including Hands Off Our Vote, Immigrant Justice Summer, and
  Dismantling Detention.
version: "3.5"
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

Then check `issues/` for a file matching the issue in scope. If one exists,
load it and treat every fact in it as valid only within the freshness limits
in `issues/README.md`. If none exists, you are doing this research fresh and
should create one when you are done.

Load these now. Do not proceed to Step 1 until they are in context.

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

## The Research Cache

`issues/` holds one file per active issue: bill status, member positions,
campaign linkage, corrections, outputs produced, and outcomes. It exists so
that the same positions are not re-derived from the same press releases on
every run. `issues/README.md` carries the full rules; the essentials:

**Every fact carries the date it was verified and the URL it came from.** A
fact without both is not usable and must be re-researched.

**Freshness limits.** Member positions cache for 45 days and are void
immediately on any new vote, press release, or floor statement. Bill status
caches for 7 days. Campaign ask wording caches for 45 days.

The 45 days is deliberate. A 30-day limit expires exactly on a monthly
publishing cadence, so the most expensive research in the skill would be the
one thing the cache never delivers. The event-based invalidation above is the
real correctness control; the clock is a backstop.

**The cache never satisfies Accuracy Rule 6.** Cosponsor lists, Federal
Register docket status, the current appropriations vehicle, litigation, and
delegation composition are never cached. Re-verify them live on the day of
distribution, from primary sources, every time. Caching is how both errors in
`lessons_learned` reached distributed documents — a struck-down map and a stale
rulemaking, each a fact that had once been true.

**Record outcomes.** After distribution, write what happened into the issue
file: who responded, who did not, whether a position moved. Nothing else in
this skill records whether the work worked.

---

## Shared Member Taxonomy

Every output type classifies members the same way. The classes below are the
vocabulary; each sub-skill renders them in labels suited to its channel, and
the mapping table at the end of this section says how.

Classify by *current movability on the issue in scope*, never by party alone
and never by seniority.

**Tier 1 — Aligned.** On record supporting our position. The ask is
escalation, not persuasion: use procedural tools, go on record publicly, do
oversight in the open. A supportive vote is the floor, not the finish line.
Name the specific escalation. "Keep up the good work" is not an ask.

**Tier 2 — Movable.** In a competitive seat, has broken with party on a
related vote, or has no stated position on this issue. Asks here should be
public and local: town hall questions, letters to the editor, constituent
stories. **This is the default class when no record exists** — an unknown
position is a movable one until proven otherwise.

**Tier 3 — Locked.** On record against, with no realistic movement on any ask
in scope. Locked members are contacted like everyone else. Do not omit them
and do not pretend they are persuadable. The deliverable in these districts is
a written ask, a logged response or non-response, and a public record usable
with local press and at candidate forums. Say so plainly, so group leaders in
those districts do not measure success by whether the office replies.

**Gatekeeper** is a flag, not a class. It marks a member who controls
scheduling, a markup, or whether the thing moves at all — a chair, a ranking
member, or leadership. A member carries a tier *and*, optionally, this flag. An
Aligned Gatekeeper is usually the highest-leverage target in the delegation,
which a scheme that treated "gatekeeper" as a peer tier could not express.

### Applying it

- A member is Tier 1 or Tier 3 only on a found record: a press release, floor
  statement, or vote. Absent that, they are Tier 2 and the output says
  "position not found during research" (Accuracy Rule 3).
- Classify the full delegation every time. Output types differ in how many
  members reach the page, never in how many get classified.
- Contact ranking within an output follows leverage: Gatekeepers first
  regardless of tier, then Movable, then Aligned, then Locked.

### Rendering labels by output type

| Class | brief-full §6 | brief-short | cta-roundup |
|---|---|---|---|
| Tier 1 — Aligned | → Thank and reinforce | (omitted for space) | Tier 1 — Aligned |
| Tier 2 — Movable | → Call now | listed | Tier 2 — Movable |
| Tier 3 — Locked | → Contact and log | listed only if the highest-leverage target | Tier 3 — Locked |
| Gatekeeper flag | noted in the member's note | "— controls scheduling" | noted in the tier paragraph |

`brief-short.md` carries only two or three members total, so most of the
delegation is absent from it by design. That is a space constraint, not a
judgment that the omitted members should go uncontacted.

`skills/horizon-90.md` is absent from the table on purpose. It names no
members and carries no contact details, so it never classifies anyone. If a
horizon item has reached the point of naming who to call, it belongs in a
short brief or the digest instead.

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
- [ ] The issue file in `issues/` is written or updated with what this output
      established: positions found, status, corrections, and the output itself.
      **This is not optional and not a tidy-up step.** Research that is not
      written down is re-done from scratch next month, and the cache only pays
      off if every run feeds it.
- [ ] The deliverable is published with `./scripts/publish.sh` and added to
      `brief-index.md`. A document that never left the working directory has
      not been delivered.

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

- **Guardrails are for you, not for the reader.** Much of what is recorded in
  `state-context-{{state_code}}.md`, `lessons_learned`, and `issues/` exists to
  stop a draft going wrong, not to inform group leaders. Virginia's district
  lines are the standing example: the fact is cached so no draft misstates it,
  and the network already knows it. Publishing it tells readers something they
  know and implies they might not. Before stating a correction in output, ask
  what a group leader would do differently having read it. If the answer is
  nothing, leave it in the cache.

- **Gloss jargon on first use.** Terms like "cloture," "Byrd Rule," and
  "markup" need a brief plain-language parenthetical the first time they
  appear. Group leaders may not have a legislative background.
