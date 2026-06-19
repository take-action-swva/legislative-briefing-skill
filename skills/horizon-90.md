# Horizon-90 — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests a forward-looking scan of what's coming over the next 90 days —
not what to act on right now, but what to prepare for.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy and style rules. Begin at Step 1.

**This is a planning document, not an action document.** The newsletter
answers "what's moving this month, call now." The short brief answers "act
on this one bill now." This sub-skill answers "what's coming in the next 90
days so group leaders can recruit, schedule, and budget volunteer time
ahead of it." No call scripts, no phone numbers — point readers to the
newsletter or a short brief once an item actually enters its action window.

**Output format: docx.** Use `templates/brief-base.js`. Same minimal
formatting as the newsletter: bold for issue headlines and field labels,
plain paragraphs for body text. One two-column table near the top
(`Looking Ahead at a Glance`) — see Docx Layout Defaults in CLAUDE.md for
the two-column constraint that applies to every table except the delegation
reference table.

**Audience:** Group leaders and steering committee members planning the
organizing calendar, not reacting to today's news.

**Time window:** Rolling 90 days from the date the scan is run. State the
scan date and the resulting window explicitly in the document header.

**Length target:** 6–10 items, organized chronologically by month, not by
importance.

---

## Research Workflow

### Step 1 — Build the calendar backbone first

Before looking for legislative items, establish the structural calendar for
the 90-day window:

- House and Senate floor calendars — confirm which weeks are session weeks
  and which are recess/district weeks
- Statutory deadlines falling inside the window: appropriations or
  continuing-resolution deadlines, program reauthorization expirations,
  debt limit dates if applicable
- federalregister.gov effective dates for major pending rules
- dailypress.senate.gov for any already-confirmed Senate floor schedule

Recess weeks matter as much as session weeks. No floor action happens
during them, and they are often the best window for district-based
visibility events. Cite a source for every date. Do not estimate a date
without a primary source backing it.

### Step 2 — Scan for legislative items with timing inside the window

Sources:

- congress.gov — committee markup schedules, scheduled floor votes
- Committee websites — many publish markup calendars several weeks out
- News sources per `references/sources-national.md`, for "leadership
  intends to move this by [date]" signals
- indivisible.org national priorities — one input, not a required list

Cast a wide net: pull 12–15 candidates before narrowing.

### Step 3 — Classify every candidate by certainty

Use exactly these three labels. Never blend them or soften the distinction:

- **Scheduled** — a confirmed date exists on a calendar or committee notice
- **Expected** — leadership or a committee has stated intent to act in this
  window, but no confirmed date exists yet
- **Watch** — could move into the window depending on developments (a court
  ruling, a negotiation outcome) but timing is not yet knowable

Do not assign a Scheduled date unless a primary source actually published
it. An Expected item with no date is more honest than an Expected item with
a guessed one.

### Step 4 — Select 6–10 items

Prioritize by:

1. **Virginia relevance** — a Virginia member has leverage, or the item has
   a state-specific impact
2. **Decision weight** — items that are hard to reverse once decided
   (confirmations, appropriations riders, reauthorizations) over items that
   are easily revisited later
3. **Spread across the window** — do not let every item cluster in the
   first two weeks. If the back half of the window is genuinely thin, say
   so in the closing note rather than padding with low-confidence Watch
   items to hit a count

Drop anything already covered in depth by a current full brief or short
brief. Link to that document instead of duplicating it.

### Step 5 — Confirm the Virginia angle for each selected item

Same accuracy rule as every other output type: one sourced sentence on why
it matters for Virginia specifically. Skip deep donor or impact research —
this is a planning document, not a persuasion document. If no
Virginia-specific angle exists, write that plainly rather than forcing one.

---

## Output Format

File lifecycle: write `horizon-90-[scan-date].js` in the project root (e.g.
`horizon-90-2026-06-19.js`), run the acronym checker, generate the docx,
copy to Google Drive, then move both files to `briefs/`.

```bash
# 1. Check acronyms
./scripts/check-acronyms.sh horizon-90-[scan-date].js

# 2. Generate docx
node horizon-90-[scan-date].js

# 3. Copy to Google Drive — use cp, not base64 or the Drive MCP tool
cp horizon-90-[scan-date].docx \
  "/Users/ernie/Library/CloudStorage/GoogleDrive-ernie.braganza@gmail.com/My Drive/Statewide Coordinating Committee /Legislation Briefings/"

# 4. Move source files to briefs/
mv horizon-90-[scan-date].js horizon-90-[scan-date].docx briefs/
```

### Document header

```
90-Day Outlook — Virginia Indivisible
Scan date: [Month D, Year]  |  Window: [Month D] – [Month D, Year]
```

### "Looking Ahead at a Glance" table

Two-column table, per the Docx Layout Defaults rule in CLAUDE.md — never
add a third column.

- **Column 1:** Window (e.g., "Week of June 23," "Expected July," "No
  window yet")
- **Column 2:** Item name plus certainty tag, e.g. "MEDICAID CUTS MARKUP
  (Scheduled)"

Sort rows chronologically. Group all Watch items with no confirmed window
into a single trailing row group at the bottom rather than interspersing
them by guessed timing.

### Per-item structure

Group items under actual calendar month headings (not "next 30 days," which
drifts meaning between scan runs).

```
[ISSUE NAME — bold, all caps]          [Scheduled | Expected | Watch]

Window: [specific date, date range, or "no confirmed window yet"]

[2-3 sentences: what's expected to happen and the mechanism — markup,
floor vote, rule effective date, anticipated ruling.]

Virginia angle: [one sentence, or "No Virginia-specific angle identified."]

Prepare: [one sentence of concrete organizational prep — recruiting,
scheduling, drafting materials. Not a call script. Once an item enters its
actual action window, it belongs in the newsletter or a short brief.]
```

### Closing note — recess and quiet weeks

List the recess/district weeks that fall inside the window explicitly.
Group leaders use these for district-based visibility events when no floor
action will compete for member attention. If the back half of the window
is thin on confirmed items, say so here rather than padding the item list.

---

## Style rules

See SKILL.md "Shared Style Rules" for em dash, concrete nouns, and
sentence-length rules that apply to all output types.

- **Navy only, never red.** Per the Docx Layout Defaults rule in CLAUDE.md,
  red is reserved for standalone urgent-threat sections. Every item in this
  document is future or uncertain by design, even Scheduled ones — that is
  a different urgency class than "happening now." Use navy throughout.
- **The certainty tag must match Step 3 exactly.** Never describe an
  Expected or Watch item's timing as if it were confirmed.
- **No member contact details, no call scripts.** This is a calendar, not
  an action sheet. If a reader needs to act now, point them to the
  newsletter or a short brief.

---

## Pre-Delivery Check

- [ ] Every item has a Scheduled / Expected / Watch tag matching Step 3
- [ ] No invented dates — every Scheduled date traces to a primary source
- [ ] Recess/district weeks inside the window are listed
- [ ] 6–10 items, sorted chronologically by month
- [ ] Glance table is two-column
- [ ] No phone numbers or call scripts included
- [ ] Virginia angle present, or explicitly marked absent, for every item
- [ ] Acronyms expanded on first use per SKILL.md
- [ ] No em dashes in prose per SKILL.md
- [ ] Docx generated and opens without validation errors
- [ ] Both .js and .docx moved to briefs/

---

## Common Pitfalls

- **Treating Expected as Scheduled.** Leadership "wanting" a vote by a
  certain date is not the same as a markup notice existing. Tag accurately.
- **Padding the back half of the window.** If confirmed items thin out
  past day 45, say so in the closing note instead of filling the gap with
  low-confidence Watch items just to hit 6–10.
- **Writing this like a newsletter.** No call-now asks. The point is
  organizational lead time, not a phone call this week.
- **Forgetting recess weeks.** A group leader who doesn't know Congress is
  out may schedule a Hill-focused action against a closed building, or miss
  the best window for a district-based event.
- **Forcing a Virginia angle that doesn't exist.** Write "No
  Virginia-specific angle identified" rather than stretching a national
  story into a state hook that doesn't hold up.
