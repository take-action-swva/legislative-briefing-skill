# issues/ — the research cache

One file per active issue. This is where research that costs real time to
produce gets written down so the next session does not redo it.

## What this is for

`state-context-va.md` caches the facts that barely change: who the delegation
is, what committees they sit on, what their phone numbers are. It is the
single highest-leverage file in the skill.

This directory caches the tier below that — facts that change on a scale of
weeks rather than years. Member positions on a specific bill. Where a bill
stands. What a campaign is currently asking for. Without it, every output type
re-derives the same positions from the same press releases.

## The thing that will go wrong

Caching is exactly how both errors in `lessons_learned` reached distributed
documents: a congressional map that had already been struck down, and a stale
account of the USPS mail-ballot rulemaking. Neither was a research failure.
Both were facts that had been true.

So every fact in here carries the date it was verified and the URL it came
from, and the freshness table below is not advisory.

## Freshness rules

| Fact | Cache life | Void immediately when |
|---|---|---|
| Member position on the issue | 45 days | Any new vote, press release, or floor statement on the issue |
| Bill status | 7 days | Any action appears on congress.gov |
| Campaign ask wording | 45 days | The national org runs a new training or revises the toolkit |
| Committee, phone, contact URL | Not cached here | Lives in `state-context-va.md` |

**Never cached, in this directory or anywhere:**

- Cosponsor lists — run `./scripts/fetch-cosponsors.sh` on the day of distribution
- Federal Register docket status
- Current appropriations vehicle
- Litigation affecting district maps or election procedure
- Delegation composition

These are the volatile items in Shared Accuracy Rule 6. **A cache entry never
satisfies that check.** The cache speeds up drafting. The pre-distribution
verification still runs live, every time, against primary sources.

## Using it

**45 days, not 30.** A 30-day limit expires exactly on a monthly publishing
cadence, so the positions researched for September would be stale on the day
October is drafted — the cache would never pay off for its main use case. The
event-based invalidation in the right-hand column is the real correctness
control; the clock is a backstop behind it.

1. Before researching an issue, look for `issues/<slug>.md`. If it exists, read
   it and check every `verified:` date against the table above.
2. Use what is still fresh. Re-verify what is not, and update the file.
3. If no file exists, do the research and create one from `_template.md`.
4. After distribution, record what happened in the Outcomes section.

A stale entry is not a reason to distrust the file. It is a reason to re-verify
that one line and write the new date next to it.

## Outcomes

The Outcomes section is the only place in the skill that records whether any of
this worked. `cta-roundup.md` tells group leaders in Tier 3 districts to log
non-responses; this is where that log lives and where the next document reads
it. An office that has ignored three written asks is a different target than
one that has never been asked.

## Naming

`issues/<short-kebab-slug>.md` — `medicaid-cuts.md`, `save-act.md`,
`ice-detention-oversight.md`. Name for the issue as organizers talk about it,
not the bill number, because an issue routinely spans several bills.

Retire a file when the issue is genuinely over: the bill is dead and not
returning, or the rule is final and unchallenged. Move it to
`issues/archive/` rather than deleting it — the Outcomes section stays useful
after the issue closes.
