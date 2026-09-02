# Congressional calendar — 119th Congress

Session weeks, recess/district work periods, and statutory deadlines.
`skills/horizon-90.md` Step 1 builds its calendar backbone from this file
instead of re-researching the same dates every scan.

**Status: Senate and House 2026 both populated 2026-09-02.**

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

**Source:** <https://www.majorityleader.gov/house-legislative-calendar-2026/>
**PDF read:** <https://www.majorityleader.gov/uploadedfiles/one_page_-_2026_house_calendar_-_revised_march_2026.png.pdf>
**Read on:** 2026-09-02
**Document:** "2026 House Calendar | 119th Congress | Second Session",
**revised March 2026** — a later revision than the Senate calendar above.
Landing page: <https://www.majorityleader.gov/schedule/>

**The House calendar uses the opposite convention from the Senate's.** Gold
highlight marks days the House **is** in session; everything unmarked is a
district work period. The Senate calendar marks the reverse, in red. Reading
one with the other's convention inverts the entire year.

**Days the House IS in session:**

| Month | In session |
|---|---|
| January | 6–9, 12–15, 20–23 |
| February | 2–4, 9–12, 23–25 |
| March | 3–5, 16–19, 24–27 |
| April | 14–17, 20–23, 27–30 |
| May | 12–15, 18–21 |
| June | 2–5, 8–11, 23–26, 29–30 |
| July | 1–2, 13–16, 20–23 |
| August | 31 only |
| September | 1–3, 14–17, 22–25, 28–30 |
| October | 1 only |
| November | 9–12, 17–20, 30 |
| December | 1–3, 8–11, 14–17 |

**District work periods of a week or longer:**

| Period | Dates |
|---|---|
| Late January | Jan 24 – Feb 1 |
| February | Feb 13 – Feb 22 |
| March | Mar 6 – Mar 15 |
| Spring | Mar 28 – Apr 13 |
| Early May | May 1 – May 11 |
| Memorial Day | May 22 – Jun 1 |
| Mid-June | Jun 12 – Jun 22 |
| Independence Day | Jul 3 – Jul 12 |
| **Summer** | **Jul 24 – Aug 30** |
| Early September | Sep 4 – Sep 13 |
| **Election** | **Oct 2 – Nov 8** |
| Thanksgiving | Nov 21 – Nov 29 |
| End of session | Dec 18 onward |

---

## Where the two chambers diverge

Do not write "Congress is in recess" from one chamber's calendar. The 2026
schedules differ materially:

| Window | House | Senate |
|---|---|---|
| **Return from summer** | **Aug 31** | **Sep 14** |
| February recess | Feb 13 – Feb 22 | Feb 15 – Feb 22 |
| Early May | Out May 1 – 11 | In session |
| Mid-June | Out Jun 12 – 22 | In session |
| July | Out Jul 3 – 12 | Out Jul 1 – 12 |
| October | Out from Oct 2 | Out from Oct 3 |
| End of session | Adjourns after Dec 17 | Target adjournment Dec 18 |

The summer gap is the one most likely to cause an error: **the House returns
two full weeks before the Senate.** As of this file's read date, 2026-09-02,
the House is in session and the Senate is not.

A House-focused action in early September lands on members who are back at
work; the same action aimed at Warner or Kaine hits an empty office until
September 14.

---

## Statutory deadlines

Dates that exist in law rather than on a floor schedule. These do not move
when the calendar does, which is what makes them the most reliable anchors in
a 90-day scan.

**Not populated.** Unlike the chamber calendars, these are not published in one
document — appropriations deadlines, program reauthorization expirations, and
debt limit dates each have to be traced to the statute or the current funding
vehicle. Fill them in as a scan encounters them, with a source and a date.

Note the boundary against Accuracy Rule 6: a reauthorization expiry written in
statute belongs here and is stable. The *current appropriations vehicle* does
not — which continuing resolution is live, and when it lapses, is a volatile
item that gets re-verified before every distribution and is never cached.

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
