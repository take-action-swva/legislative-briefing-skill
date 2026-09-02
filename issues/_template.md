# [Issue name as organizers say it]

**Slug:** `[kebab-slug]`
**Opened:** [YYYY-MM-DD]
**Last touched:** [YYYY-MM-DD]
**Status:** active | dormant | closed

One or two sentences on what this issue is and why the network is working it.

---

## Bills and vehicles

| Bill / docket | What it is | Status | verified |
|---|---|---|---|
| H.R. 0000 | [one phrase] | [status] | [YYYY-MM-DD] |

Bill status caches for 7 days. Re-check congress.gov past that.

Cosponsor counts are deliberately absent from this table. They are never
cached — run `./scripts/fetch-cosponsors.sh <congress> <type> <num> VA` on the
day of distribution.

---

## Member positions

One row per member with a found record. Members with no record found are
Tier 2 Movable by default and do not need a row until a record exists.

| Member | Tier | Position | Source | verified |
|---|---|---|---|---|
| Sen. Warner | Tier 2 Movable | [what they actually said or did] | [URL] | [YYYY-MM-DD] |

Tiers come from SKILL.md's Shared Member Taxonomy. Positions cache for 30 days
and are void immediately on any new vote, press release, or floor statement.

**Never write a position here that was inferred from party.** If no record was
found, the member does not get a row, and the output says "position not found
during research."

---

## Campaign linkage

Which national campaign or training track this issue serves, and that
campaign's current stated congressional ask.

- **Campaign:** [name]
- **Their stated ask:** [verbatim]
- **Source:** [toolkit or training URL]
- **verified:** [YYYY-MM-DD]

Caches for 30 days. National organizations revise asks between trainings.

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
