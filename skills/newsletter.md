# Newsletter — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests a monthly legislative digest for Virginia Indivisible group leaders.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy and style rules. Begin at Step 1.

**Output format: docx.** Use `templates/brief-base.js`. Keep formatting
minimal — bold for issue headlines and field labels, plain paragraphs for
everything else. No shaded boxes, no colored headings, no tables. The
newsletter team will apply visual formatting; the docx is a clean content
handoff.

**Audience:** Savvy, well-informed group leaders. Skip process basics and
extended legislative history. They know what a markup is. Lead with what is
happening now and what to do about it.

**Length target:** Up to 5 items. Each item should be readable in 60 seconds.

---

## Research Workflow

### Step 1 — Scan what's moving this month

Identify federal legislation with near-term action potential. Sources to check:

- congress.gov — bills with floor votes, markups, or committee action scheduled
- indivisible.org/get-involved/take-action/ — national campaign priorities
  (use as one input, not as a required list)
- dailypress.senate.gov — scheduled Senate floor activity
- News sources per `references/sources-national.md`

Cast a wide net first. Pull 8-10 candidates before narrowing.

### Step 2 — Select up to 5 items

Prioritize by:

1. **Near-term action point** — a vote, markup, or procedural moment expected
   this month or early next. No action point = not newsletter material right now.
2. **Constituent pressure can move the outcome** — a member is persuadable,
   undecided, or facing a close vote. Locked votes on either side are less
   actionable.
3. **Virginia relevance** — a Virginia member has leverage, is the persuadable
   vote, or the bill has a notable Virginia-specific impact.

Drop items that are important but stalled with no near-term moment. Save them
for a month when they move.

### Step 3 — For each selected item

Confirm from primary sources:

- Exact bill number and Congress session
- Current status and next scheduled action
- The 1-2 Virginia members most worth contacting right now
- One concrete action ask per member

Do not include an item if you cannot confirm current status from congress.gov
or a primary source. A stale status is worse than a missing item.

---

## Output Format

File lifecycle: write `[month]-[year]-newsletter.js` in the project root, run
the acronym checker, generate the docx, copy to Google Drive, then move both
files to `briefs/`.

```bash
# 1. Check acronyms
./scripts/check-acronyms.sh [month]-[year]-newsletter.js

# 2. Generate docx
node [month]-[year]-newsletter.js

# 3. Copy to Google Drive — use cp, not base64 or the Drive MCP tool
cp [month]-[year]-newsletter.docx \
  "/Users/ernie/Library/CloudStorage/GoogleDrive-ernie.braganza@gmail.com/My Drive/Statewide Coordinating Committee /Legislation Briefings/"

# 4. Move source files to briefs/
mv [month]-[year]-newsletter.js [month]-[year]-newsletter.docx briefs/
```

### Document header

```
[Month Year] — Virginia Indivisible Legislative Update
```

No subtitle, no deck. The header is the only top-level label.

### Optional one-line framing

One sentence on the overall legislative moment if it adds genuine context
(e.g., a reconciliation deadline, a recess window, a lame-duck dynamic).
Omit if nothing meaningful can be said in one sentence.

### Per-item structure

Each item uses this structure. No exceptions, no added fields.

```
[ISSUE NAME — bold, all caps]

Status: [one sentence — where it stands right now]

[2-3 sentences on why it matters. No process background. No history
beyond what a reader needs to understand the current moment.]

Act: [One or two members. For each: name, role, phone, contact URL,
one-sentence ask.]
```

Separate items with a horizontal rule (`---` in the JS, rendered as a page
divider in the docx).

### Example item

```
MEDICAID CUTS

Status: The Senate Finance Committee is expected to mark up the bill the
week of June 23.

Roughly 600,000 Virginians rely on Medicaid. The current draft cuts federal
matching funds by 10%, which would require the state to either reduce
enrollment or cut provider payments. Virginia has no budget reserve large
enough to absorb the gap.

Act:
Sen. Tim Kaine — Health, Education, Labor, and Pensions Committee
DC: (202) 224-4024 | kaine.senate.gov/contact
Ask him to oppose any markup that cuts federal Medicaid matching rates.
```

### Closing line

One sentence. What group leaders should do if they want to track these issues
between newsletters — e.g., sign up for Indivisible alerts, check
congress.gov, or watch for short briefs from the steering committee.

---

## Tone

- Professional but direct. Not wooden, not chatty.
- Write to someone who already knows the stakes. Do not explain why healthcare
  or voting rights matter in the abstract.
- Assume the reader will forward the action ask to their members. Write the
  ask so it survives that one layer of forwarding without losing its point.
- Avoid: "it is important to note," "this is a critical moment," "now more
  than ever." These are filler. If the moment is critical, the facts show it.

---

## Style rules

See SKILL.md "Shared Style Rules" for em dash, concrete nouns, and
sentence-length rules that apply to all output types.

- **No legislative process tutorials.** Do not explain what a markup is, how
  reconciliation works, or what cloture means unless the procedural fact is
  itself the news. If a gloss is needed, one parenthetical is enough.
- **Issue name over bill number as the lead.** Use the issue name (MEDICAID
  CUTS, FISA REAUTHORIZATION) as the item headline. Include the bill number
  in the Status line.
- **One ask per member, one sentence.** The act line is a directive, not a
  script. Group leaders will adapt it for their members.

---

## Pre-Delivery Check

- [ ] No more than 5 items
- [ ] Each item has a confirmed near-term action point
- [ ] Status confirmed from congress.gov or a primary source — not only news
- [ ] Each Act entry has phone number and contact URL from state-context-va.md
- [ ] No item uses "position not publicly stated" — use "position not found
      during research"
- [ ] Acronyms expanded on first use per SKILL.md
- [ ] No em dashes in prose per SKILL.md
- [ ] Docx generated and opens without validation errors
- [ ] Both .js and .docx moved to briefs/

---

## Common Pitfalls

- **Including stalled bills.** If there is no action point this month, cut
  the item. A digest full of "Congress is still debating" entries is not
  actionable.
- **Overloading one item.** Each item is 60 seconds of reading. If an issue
  needs more space, produce a short brief for it and reference it in the
  closing line.
- **Listing members who are already locked in.** Confirmed yes votes and
  confirmed no votes are not worth calling space in the newsletter. Target
  persuadables and gatekeepers.
- **Writing the act line as a script.** One directive sentence. Group leaders
  will write their own scripts.
