# Congressional calendar — 119th Congress

Session weeks, recess/district work periods, and statutory deadlines.
`skills/horizon-90.md` Step 1 builds its calendar backbone from this file
instead of re-researching the same dates every scan.

**Status: NOT POPULATED. Fill in before relying on it.**

---

## Why this is a hand-maintained file and not a script

There is no machine-readable source for the forward congressional schedule.
Checked 2026-09-02:

- **congress.gov API** has no calendar or session-days endpoint. `house-calendar`
  returns 404.
- **govinfo CCAL collection** (`https://api.govinfo.gov/collections/CCAL/...`,
  reachable with the api.data.gov key already used for FEC) publishes one
  package per day a chamber is *actually* in session — `CCAL-119hcal-2026-09-02`,
  `CCAL-119scal-2026-09-04`. That is a reliable **retrospective** record of days
  in session. It says nothing about next month.
- The **forward** schedule is published only as annual PDF calendars:
  - Senate: <https://www.senate.gov/legislative/resources/pdf/2026_calendar.pdf>
  - House: published by the Majority Leader's office
  - congress.gov days-in-session pages: <https://www.congress.gov/days-in-session/119th-congress>

So this file is filled in by a person, twice a year, from the published
calendars. That is a real cost, and it is smaller than rebuilding the same
dates on every horizon scan.

---

## How to fill this in

1. Open the Senate PDF above and the House Majority Leader's calendar.
2. Record every period when each chamber is **not** in session, with exact
   start and end dates.
3. Note the source URL and the date you read it in the verification line below.
4. Do not estimate a date. A missing row is better than a wrong one — a group
   leader who schedules a Hill-focused action against a closed building has
   been actively misled.

---

## 2026 — Senate

**Source:** <https://www.senate.gov/legislative/resources/pdf/2026_calendar.pdf>
**Read on:** FILL IN

| Period | Dates | Notes |
|---|---|---|
| FILL IN | FILL IN | |

## 2026 — House

**Source:** FILL IN (Majority Leader's published calendar)
**Read on:** FILL IN

| Period | Dates | Notes |
|---|---|---|
| FILL IN | FILL IN | |

---

## Statutory deadlines

Dates that exist in law rather than on a floor schedule. These do not move
when the calendar does, which is what makes them the most reliable anchors in
a 90-day scan.

| Deadline | Date | What happens if missed | verified |
|---|---|---|---|
| FILL IN | FILL IN | | |

---

## Why recess weeks matter

No floor action happens during them, so they are the wrong window for
Hill-focused pressure and the best window for district-based visibility
events. `horizon-90.md` lists them explicitly in its closing note for exactly
this reason.

---

## Maintenance

Refresh when a new session's calendar is published, typically once in the
fall for the following year and again if leadership revises it mid-year. See
MAINTENANCE.md.

Chambers revise their calendars during the year. A date read in November for
the following June is a plausible plan, not a commitment — tag anything
downstream of this file **Scheduled** only if a committee notice or floor
calendar confirms it, per Shared Accuracy Rule 7.
