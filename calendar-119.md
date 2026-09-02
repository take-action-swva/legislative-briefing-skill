# Congressional calendar — 119th Congress

Session weeks, recess/district work periods, and statutory deadlines.
`skills/horizon-90.md` Step 1 builds its calendar backbone from this file
instead of re-researching the same dates every scan.

**Status: Senate 2026 populated 2026-09-02. House 2026 NOT populated.**

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

The published calendars encode session status **in color** — red days are days
the chamber is not in session — so extracting text is not enough. `pdftotext`
returns the date grid with the color stripped, which looks like data and is
useless.

Read them as images instead. poppler is installed:

```bash
curl -s -o cal.pdf "https://www.senate.gov/legislative/resources/pdf/2026_calendar.pdf"
pdftoppm -png -r 300 -f 1 -l 1 cal.pdf cal      # whole page
pdftoppm -png -r 300 -f 1 -l 1 -x 540 -y 920 -W 1500 -H 480 cal.pdf q1   # one quarter
```

Then:

1. Read each quarter and record every period when the chamber is **not** in
   session, with exact start and end dates.
2. **Cross-check the reading against the figures printed on the same page.**
   The convening date should be the first in-session day and the target
   adjournment should be the last. If either disagrees, the color reading is
   wrong — stop and re-read rather than publishing it.
3. Note the source URL and the date you read it in the verification line.
4. Do not estimate a date. A missing row is better than a wrong one — a group
   leader who schedules a Hill-focused action against a closed building has
   been actively misled.

---

## 2026 — Senate

**Source:** <https://www.senate.gov/legislative/resources/pdf/2026_calendar.pdf>
**Read on:** 2026-09-02
**Document title:** "United States Senate, 119th Congress, 2nd Session, 2026 —
Tentative Schedule"

The published calendar encodes session status in color only: red days are days
the Senate is not in session. Two figures printed on the same page confirm the
reading — the first in-session day is January 5, matching "2nd Session Convenes
- January 5, 2026", and the last is December 18, matching "Target Adjournment -
December 18, 2026".

**Periods when the Senate is NOT in session** (weekends excluded; these are the
state work periods and holidays):

| Period | Dates | Notes |
|---|---|---|
| Pre-session | Jan 1 – Jan 4 | 2nd Session convenes Jan 5 |
| Martin Luther King Jr. Day | Jan 19 | Single day |
| February state work period | Feb 15 – Feb 22 | Includes Presidents Day, Feb 16 |
| Spring state work period | Mar 29 – Apr 12 | Returns Apr 13. The longest gap in the first half of the year |
| Memorial Day state work period | May 24 – May 31 | Memorial Day May 25 |
| Juneteenth | Jun 19 | Single day |
| Independence Day state work period | Jul 1 – Jul 12 | Independence Day observed Jul 3 |
| August state work period | Aug 8 – Sep 13 | Returns Sep 14. Labor Day Sep 7 falls inside it |
| Yom Kippur | Sep 21 | Single day |
| Election state work period | Oct 3 – Nov 8 | Returns Nov 9. Columbus Day Oct 12 falls inside it. Longest gap of the year |
| Veterans Day period | Nov 11 – Nov 15 | Veterans Day Nov 11 |
| Thanksgiving state work period | Nov 24 – Nov 29 | Thanksgiving Nov 26 |
| Post-adjournment | Dec 19 onward | Target adjournment Dec 18 |

**Longest in-session stretches**, useful for expecting floor action:
Jan 5 – Feb 14, Apr 13 – May 23, Jun 1 – Jun 30, Sep 14 – Oct 2.

**Best windows for district-based events**, when no floor action competes for a
member's attention: the spring period (Mar 29 – Apr 12), the August period
(Aug 8 – Sep 13), and the election period (Oct 3 – Nov 8).

This is the *tentative* schedule. The Senate revises it during the year. Per
Shared Accuracy Rule 7, a date drawn from this table is **Expected**, not
**Scheduled** — it becomes Scheduled only when a committee notice or floor
calendar confirms the specific action.

## 2026 — House

**Source:** FILL IN (Majority Leader's published calendar)
**Read on:** FILL IN

**Not yet populated.** Do not assume the House tracks the Senate — the two
chambers publish separate calendars and their recess weeks differ. An output
that cites "Congress is in recess" while only the Senate calendar has been
checked is wrong half the time.

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
