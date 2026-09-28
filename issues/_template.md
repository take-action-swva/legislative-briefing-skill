# [Issue name as organizers say it]

**Slug:** `[kebab-slug]`
**Opened:** [YYYY-MM-DD]
**Last touched:** [YYYY-MM-DD]
**Status:** active | dormant | closed
**Issue area:** elections | immigration | health | education | environment |
budget | federal workforce | civil liberties | other
**Threat vectors:** legislation, appropriations, rulemaking, guidance,
funding action (apportionment, impoundment, rescission), grant action,
enforcement, litigation — list all that apply
**Stage:** watch | prepare | cta-ready — see SKILL.md's "CTA Readiness"
section for the four conditions
**Blocker:** [one line naming the unmet condition, or "none" if cta-ready]

**Next decision:**
- **Type:** markup | floor vote | comment deadline | rule effective date |
  appropriations deadline | court ruling | unknown
- **Certainty:** Scheduled | Expected | Watch
- **Date:** [YYYY-MM-DD or "unknown"]
- **Source:** [URL]

One or two sentences on what this issue is and why the network is working it.

---

## Vehicles

| Bill / docket | What it is | Status | verified |
|---|---|---|---|
| H.R. 0000 | [one phrase] | [status] | [YYYY-MM-DD] |

A row can be a bill, a Federal Register docket, a court docket, or a funding
action (an apportionment footnote, an impoundment, a rescission) — whatever
the decision point in scope actually is.

**For any active litigation, record the CourtListener docket URL** (from
`references/sources-national.md`'s "Litigation Tracking" section) in the
row's Status or verified column. Case status itself stays uncached per
Accuracy Rule 6 — the docket URL doesn't cache the status, it just makes the
live recheck on the day of distribution a single click instead of a new
search.

Bill status caches for 7 days. Re-check congress.gov past that. Federal
Register docket status, apportionment or impoundment status, litigation
status, and grant termination or reinstatement status are never cached —
re-verify live per Accuracy Rule 6.

Cosponsor counts are deliberately absent from this table. They are never
cached — run `./scripts/fetch-cosponsors.sh <congress> <type> <num> VA` on the
day of distribution.

---

## Member positions

One row per member with a found position record, or who needs a row to
document Role — a Gatekeeper or a relevant-committee seat — even without a
stated position. A member with neither stays off the table: Tier 2 Movable by
default per the Shared Member Taxonomy, and no row needed until one applies.

| Member | Tier | Role | Evidence | Position | Source | verified |
|---|---|---|---|---|---|---|
| Sen. Warner | Tier 2 Movable | relevant committee | record found | [what they actually said or did] | [URL] | [YYYY-MM-DD] |

Tiers come from SKILL.md's Shared Member Taxonomy. Positions cache for 45 days
and are void immediately on any new vote, press release, or floor statement.

**Role** states the factual reason this office matters to the decision in
scope: `gatekeeper`, `relevant committee`, `floor vote`, `oversight
authority`, or `other`. Extends the Gatekeeper flag rather than replacing it.

**Evidence** is `record found` or `no record found`. A Tier 2 member with a
Role but no position on this issue — a committee seat with nothing said or
voted yet — reads differently from one who broke with party on a related
vote.

**Never write a position here that was inferred from party.** If Evidence is
"no record found," write "position not found during research" in the
Position column rather than guessing or leaving it blank.

---

## Campaign linkage

Which national campaign or training track this issue serves, and that
campaign's current stated congressional ask.

- **Campaign:** [name]
- **Their stated ask:** [verbatim]
- **Source:** [toolkit or training URL]
- **verified:** [YYYY-MM-DD]

Caches for 45 days. National organizations revise asks between trainings.

---

## Corrections and traps

Facts that have already gone wrong in a distributed document, or that a writer
is likely to get wrong. This section exists because errors propagate through
forwarding and excerpting.

- [What is actually true, and what people wrongly believe]

---

## Outputs produced

| Date | Type | File | Where |
|---|---|---|---|
| [YYYY-MM-DD] | full brief / short brief / CTA roundup / digest / horizon | [filename] | Drive |

Also add each of these to `brief-index.md`.

---

## Outcomes

What actually happened after the asks went out. This is the only record of
whether the work moved anything.

| Date | Member | Ask | Result |
|---|---|---|---|
| [YYYY-MM-DD] | [name] | [what was asked] | responded / no response / position changed / cosponsored |

Log non-responses. Under the Shared Member Taxonomy, a logged non-response
from a Tier 3 Locked office is the deliverable in that district, not a
failure. Three ignored written asks is a fact worth having on record with
local press and at candidate forums.
