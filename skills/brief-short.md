# Short Brief — Research Workflow and Output

Sub-skill of `legislative-briefing-skill`. Load this file when the user
requests a short brief, quick summary, or copy-paste-ready message for
distribution via Gmail, Signal, Discord, or Slack.

The parent skill (`SKILL.md`) has completed Step 0 (state context loaded) and
provides the shared accuracy rules. Begin at Step 1.

**Output format: markdown.** Do not produce a docx file. The output must be
readable as plain text in platforms that do not render markdown (Signal, plain
Gmail). Use bare URLs, not markdown link syntax — `[text](url)` does not
render in Signal or plain-text email.

**This brief links to the full brief rather than replacing it.** Generate or
locate the full briefing `.docx` on Google Drive before writing the short
brief, and include the link at the end. If no full brief exists yet, note that
one should be produced.

**Length target: 300–400 words.** Fits one Signal or Discord message without
excessive scrolling. Trim aggressively — every sentence must earn its place.

---

## Research Workflow

### Step 1 — Confirm the bill or EO identity

Same as the full brief: confirm exact bill number, Congress session, and
whether the legislation has been renamed or superseded. This step is the same
regardless of output length — a wrong bill number in a short brief sent to
hundreds of group leaders is worse than in a long document.

### Step 2 — Verify current status

Check congress.gov for current status and the next scheduled procedural moment.
Check dailypress.senate.gov if the bill has been on the Senate floor.
Do not rely on news summaries for status.

One question to answer before writing: **What is the single next decision
point, and when is it?** Everything in this brief flows from that.

### Step 3 — Identify the 2–3 most actionable members right now

Filter by *current leverage*, not seniority or general influence:

1. **Persuadables** — members who haven't stated a position or are wavering
2. **Gatekeepers** — members who control scheduling or whether the bill moves
3. **Allies who can move others** — confirmed supporters with influence over
   wavering colleagues

Do not list confirmed opponents. Do not list members just because they are
senior or on a relevant committee if they are already locked in. Two or three
movable members is enough — more dilutes the ask.

Skip Step 4 (deep state-specific impact research) unless a key statistic is
already known or quickly found in a senator's press release. Do not delay the
brief to chase state data.

### Step 4 — Confirm the full brief link

Confirm the Google Drive URL for the full briefing document before writing.
Include it at the end of the short brief.

---

## Output Format

Produce clean markdown. Write so the output is readable even where markdown
does not render — avoid nested formatting, use plain dashes for bullets, and
use bare URLs not link syntax.

### Structure (in order)

**1. Hook — 1–2 sentences**
What is happening right now and why it matters. No background, no history.
Lead with the threat or opportunity, not the bill's name.

Example:
> The Senate could vote on H.R. 22 as early as next week. If it passes, an
> estimated 21 million eligible voters in Virginia lose access to same-day
> registration.

**2. Act now — 2–3 members maximum**
One entry per member. Each entry on its own line block:

```
**[Name] — [Role/why they matter right now]**
DC: [phone number]
Contact: [bare URL to contact form]
Ask: [one sentence on what to say — not a full script]
```

No call scripts. The ask line is one directive sentence, not a script.
Phone numbers and contact URLs must be present — do not omit them.
Pull contact info from `state-context-va.md` — do not search for it.

**3. Why it matters — 2 bullets, 3 maximum**
Bold key phrase, then one tight sentence. Two bullets is often better than three — don't pad.
Cut anything that does not directly reinforce the action ask. Specifically: do not include
framing that argues for the opposition's position, even if it appeared in source material.

**4. Next trigger — 1 line**
The single next decision point and its deadline.

Example:
> Next: Senate floor vote expected week of June 23. Call before then.

**5. Full briefing link**
One line. Bare URL.

Example:
> Full briefing (Virginia Indivisible): https://drive.google.com/...

---

## Style rules

- **No jargon without a gloss.** If you use "cloture" or "markup," add a
  parenthetical. Group leaders on Signal are not reading slowly.
- **Acronyms on first use.** Same rule as the full brief — expand on first
  mention even in a short document.
- **Plain URLs only.** Do not use `[text](url)` markdown link syntax.
  Signal and plain-text Gmail show this as literal bracket text, not a link.
- **No footnotes, no endnotes, no citation brackets.** Sources are in the
  full brief. The short brief does not carry inline citations.
- **Active voice, short sentences.** Aim for eighth-grade reading level.
  These messages are read fast, often on a phone, often mid-meeting.
- See SKILL.md "Shared Style Rules" for em dash, concrete nouns, and
  sentence-length rules that apply to all output types.

---

## Pre-Delivery Check

Before sending, verify:

- [ ] Bill number and Congress session correct
- [ ] Status confirmed from congress.gov — not only from a news article
- [ ] Action members are the most movable right now — not just the most senior
- [ ] Each action entry has phone number and contact URL from state-context-va.md
- [ ] Next trigger date is specific — not "soon" or "in coming weeks"
- [ ] Full brief link present and resolves
- [ ] Total word count under 400
- [ ] Readable as plain text — no markdown link syntax, no nested formatting
- [ ] Apply humanizer pass to hook, bullets, and ask lines before sending

---

## Common Pitfalls

- **Listing too many members.** Two or three is enough. More than three and
  group leaders call nobody.
- **Burying the ask.** The action section comes before the background bullets,
  not after. Leaders who stop reading after the hook still know who to call.
- **Using the full brief's "Why It Matters" section verbatim.** It was written
  for a different reading context. Rewrite for scan speed.
- **Forgetting the full brief link.** The short brief's job is to drive people
  to call and to read more. Without the link, half the job is missing.
- **Writing "position not publicly stated."** Use "position not found during
  research" — same rule as the full brief.
- **Including source framing that cuts against the action ask.** If a source
  uses urgency to argue for the opposition's position (e.g., "the program
  must be extended immediately for security reasons"), do not carry that
  framing into the brief even if the source is credible. Stick to what
  supports the recommended action.
