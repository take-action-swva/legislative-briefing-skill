# Sources Reference — National

This file contains universal sources applicable to all states.
For state-specific sources, see `sources-[statecode].md` in this directory.
Maintained centrally; PRs from any state network welcome. Load this file when you need to select or evaluate sources during
research. Update `last_verified` and `reliability` fields as you encounter
sources that have changed, moved, or become more or less useful.

Reliability ratings:
- **primary** — official government source; authoritative for status and text
- **high** — nonpartisan research organization or well-established news outlet
- **moderate** — advocacy organization with a point of view; useful for
  context and impact analysis, but verify key facts against primary sources
- **monitor** — source has shown inconsistency or staleness; use with caution

Access method ratings (use this to choose the right tool):
- **script** — use the dedicated shell script in `scripts/` (preferred; pre-tested)
- **WebFetch** — plain `WebFetch` tool works; server-side rendered or static HTML
- **Firecrawl** — use the Firecrawl MCP tool; site is JS-rendered, uses anti-scrape
  protection, or has a metered/soft paywall that blocks plain HTTP

When `WebFetch` fails (redirect loop, empty body, JS placeholder), fall back to
`Firecrawl` regardless of the rating below. When Firecrawl is not connected
(it is not available on claude.ai), fall back to a browser tool instead —
navigate to the URL and read the rendered page.

---

## Primary / Official Sources

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Congress.gov | congress.gov | Bill text, status, votes, committees, co-sponsors | primary | script | 2026-06-01 |
| Senate.gov | senate.gov | Committee assignments, floor schedule, member pages | primary | WebFetch | 2026-06-01 |
| House.gov | house.gov | Member info, committee assignments, floor schedule | primary | WebFetch | 2026-06-01 |
| Federal Register | federalregister.gov | Executive orders, agency rulemaking, comment periods | primary | WebFetch | 2026-06-01 |
| Senate Daily Press | dailypress.senate.gov | Senate floor activity logs, timestamped procedural votes, exact cloture counts | primary | WebFetch | 2026-06-01 |
| White House | whitehouse.gov | EO text, administration statements | primary | WebFetch | 2026-06-01 |
| GovTrack | govtrack.us | Bill prognosis, vote history, member scorecards | high | WebFetch | 2026-06-01 |
| Congressional Research Service (CRS) Reports | crsreports.congress.gov | Deep nonpartisan legislative analysis, reconciliation procedure | primary | WebFetch | 2026-06-01 |

**Notes from live research sessions:**
- congress.gov often shows only "In Senate" or "In Committee" with minimal
  procedural detail for bills actively on the floor. When a bill has been
  debated in the Senate, check dailypress.senate.gov for the full procedural
  record — it provides timestamped vote logs that congress.gov doesn't surface.
- Regulations.gov moved to "Leading Indicators" below — open comment periods
  are a leading-indicator source for agency action, not just a status lookup.

---

## Congressional Calendars

Where to find session weeks, recess/district work periods, and adjournment
targets. Recorded 2026-09-02 after working these out from scratch — start here
rather than searching.

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Senate annual calendar | senate.gov/legislative/resources/pdf/2026_calendar.pdf | Senate session and recess days, convening and target adjournment dates | primary | PDF, render as image | 2026-09-02 |
| House Majority Leader | majorityleader.gov/house-legislative-calendar-2026/ | House session days; links the one-page and full PDFs | primary | WebFetch for the links, then PDF | 2026-09-02 |
| House Majority Leader — schedule | majorityleader.gov/schedule/ | Current week's House floor schedule | primary | WebFetch | 2026-09-02 |
| House legislative activity | house.gov/legislative-activity | Day-to-day House floor activity | primary | WebFetch | 2026-09-02 |
| congress.gov days in session | congress.gov/days-in-session/119th-congress | Days already in session | primary | blocked to WebFetch (403); open in a browser | 2026-09-02 |
| govinfo CCAL collection | api.govinfo.gov/collections/CCAL/{timestamp} | One package per day a chamber was in session — a machine-readable RETROSPECTIVE record | primary | API, api.data.gov key | 2026-09-02 |

**There is no machine-readable forward calendar.** This was checked directly,
so do not go looking again:

- The congress.gov API has **no** calendar endpoint. `/v3/house-calendar`
  returns 404.
- govinfo's CCAL collection publishes packages named `CCAL-119hcal-YYYY-MM-DD`
  and `CCAL-119scal-YYYY-MM-DD`, one per day a chamber actually sat. That is a
  reliable record of the past and says nothing about next month. It works with
  the same api.data.gov key used for the FEC.
- The forward schedule exists only as annual PDFs from each chamber.

Because of this, `calendar-119.md` in the repo root is hand-maintained. Read it
before researching any date; refresh it twice a year per MAINTENANCE.md.

**The two chambers use opposite color conventions, and neither PDF is
readable as text.**

- **Senate:** red days = NOT in session.
- **House:** gold highlight = IS in session.
- Reading one with the other's convention inverts the entire year.
- `pdftotext` strips the color and returns a bare date grid — output that looks
  like data and carries none of the information. Render the page as an image
  instead:

```bash
pdftoppm -png -r 300 -f 1 -l 1 cal.pdf out            # whole page
pdftoppm -png -r 300 -f 1 -l 1 -x 540 -y 920 -W 1500 -H 480 cal.pdf q1
```

Always cross-check a color reading against the convening and target-adjournment
dates printed on the same page. If the first and last in-session days do not
match those figures, the reading is wrong.

The House PDF carries its own revision date in the filename
(`..._revised_march_2026.png.pdf`) and was revised after the Senate's was
published. Check for a newer revision rather than assuming a cached copy is
current.

---

## Leading Indicators (executive and regulatory pipeline)

Agency action moves before it reaches congress.gov. These sources catch a
rule, a withheld appropriation, or a comment deadline while it is still
preventable, not after it is final.

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| reginfo.gov | reginfo.gov/public/do/eoAdvancedSearchMain | Rules under Office of Information and Regulatory Affairs (OIRA) review; Unified Agenda search | primary | WebFetch | 2026-09-28 |
| Federal Register Public Inspection | federalregister.gov/public-inspection | Documents posted the day before official publication | primary | Firecrawl | 2026-09-28 |
| Regulations.gov | regulations.gov | Open public comment periods and deadlines | primary | Firecrawl | 2026-09-28 |
| OpenOMB | openomb.org | Apportionment footnotes — earliest sign of withheld funds | high | WebFetch | 2026-09-28 |
| GAO Impoundment Control Act decisions | gao.gov/legal/appropriations-law/impoundment-control-act | Impoundment Control Act legal decisions | primary | WebFetch | 2026-09-28 |

---

## Budget and Appropriations

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Congressional Budget Office | cbo.gov | Nonpartisan cost estimates and budget analysis | primary | WebFetch | 2026-09-28 |
| House Appropriations Committee | appropriations.house.gov | House Appropriations news, markups, bill status | primary | WebFetch | 2026-09-28 |
| Senate Appropriations Committee | appropriations.senate.gov | Senate Appropriations news, hearings, markups | primary | Firecrawl | 2026-09-28 |
| Committee for a Responsible Federal Budget | crfb.org | Nonpartisan fiscal analysis, deficit and debt tracking | high | WebFetch | 2026-09-28 |
| Center on Budget and Policy Priorities | cbpp.org | Budget and safety-net policy analysis | moderate | WebFetch | 2026-09-28 |
| USAspending.gov | usaspending.gov | Federal spending data by state and county, award-level, for dollars-at-risk figures | primary | Firecrawl | 2026-09-28 |

---

## Litigation Tracking

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| CourtListener | courtlistener.com | Dockets, opinions, docket alerts, API | high | Firecrawl | 2026-09-28 |
| Just Security Litigation Tracker | justsecurity.org/107087/tracker-litigation-legal-challenges-trump-administration/ | Tracked legal challenges to administration executive actions | high | WebFetch | 2026-09-28 |

---

## Nonpartisan Research, Legal & Procedural

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Brennan Center | brennancenter.org | Voting rights, elections law, democracy analysis | high | WebFetch | 2026-06-01 |
| Campaign Legal Center | campaignlegal.org | Election law, litigation status, legal challenge tracking | high | WebFetch | 2026-06-01 |
| Democracy Docket | democracydocket.com | Voting rights litigation, real-time court challenge and injunction tracking | high | Firecrawl | 2026-06-01 |
| Legislative Procedure | legislativeprocedure.com | Senate/House procedure deep dives, Byrd Rule analysis, reconciliation pathway analysis | high | WebFetch | 2026-06-01 |
| Bipartisan Policy Center | bipartisanpolicy.org | Balanced legislative analysis across party lines | high | WebFetch | 2026-06-01 |
| Brookings Institution | brookings.edu | Policy analysis, EO impact assessment | high | WebFetch | 2026-06-01 |
| TRAC Immigration | trac.syr.edu | Immigration and Customs Enforcement (ICE) enforcement data by state and district, deportation statistics, detention data | high | WebFetch | 2026-06-01 |
| Census Bureau | census.gov | District demographics, population data | primary | WebFetch | 2026-06-01 |

**Notes from live research sessions:**
- Democracy Docket is the fastest and most reliable source for tracking active
  voting rights court cases. Check it early in Step 5 — for voting rights and
  election bills, litigation often moves faster than legislation.
- Legislative Procedure (legislativeprocedure.com) provided the clearest
  analysis of Byrd Rule constraints on the SAVE Act reconciliation question,
  where multiple news outlets gave conflicting accounts. Use for any bill
  where reconciliation, cloture, or unusual Senate procedure is a factor.
- Campaign Legal Center posts accurate post-event confirmation of Senate votes
  and bill status within days of major legislative outcomes. Reliable for
  retrospective confirmation; not for predicting what comes next.

---

## Voting Rights & Civic Advocacy

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| League of Women Voters | lwv.org | Voting access advocacy and analysis | moderate | WebFetch | 2026-06-01 |
| NAACP Legal Defense Fund | naacpldf.org | Civil rights and voting rights impact analysis; post-event status confirmation | moderate | WebFetch | 2026-06-01 |
| Vote.org | vote.org | Voter registration data, access statistics, practical voter guidance | moderate | Firecrawl | 2026-06-01 |
| ACLU | aclu.org | Civil liberties litigation, court challenge tracking | moderate | WebFetch | 2026-06-01 |
| Votebeat | votebeat.org | Election administration news, EO implementation tracking | high | WebFetch | 2026-06-01 |

**Notes from live research sessions:**
- Votebeat proved highly useful for tracking EO 14399 implementation and
  court rulings in real time. Add to standard research rotation for
  election-related EOs.
- NAACP LDF and SPLC post accurate post-event summaries of Senate outcomes
  within days of major votes. Their factual claims about legislative outcomes
  are reliable; flag them as advocacy sources when citing.
- Vote.org's SAVE Act page (vote.org/save-act) contained well-sourced status
  updates and voter impact analysis updated in near-real-time.

---

## Elections

Expands the voting-rights coverage above with election-administration and
enforcement-specific sources.

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| U.S. Election Assistance Commission | eac.gov | Federal election administration guidance and data | primary | WebFetch | 2026-09-28 |
| Department of Justice Civil Rights Division | justice.gov/crt | Voting rights enforcement press releases | primary | WebFetch | 2026-09-28 |
| National Conference of State Legislatures | ncsl.org | State election law tracking | high | WebFetch | 2026-09-28 |
| Election Law Blog | electionlawblog.org | Expert election-law commentary (Rick Hasen) | high | WebFetch | 2026-09-28 |
| Protect Democracy | protectdemocracy.org | Litigation and analysis on democratic-institution threats | moderate | WebFetch | 2026-09-28 |
| States United Democracy Center | statesunited.org | Election administration and rule-of-law support | moderate | WebFetch | 2026-09-28 |

---

## Health

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| KFF | kff.org | Health policy research, polling, state data dashboards | high | WebFetch | 2026-09-28 |
| KFF Health News | kffhealthnews.org | Health policy journalism | high | WebFetch | 2026-09-28 |
| Georgetown Center for Children and Families | ccf.georgetown.edu | Medicaid and Children's Health Insurance Program (CHIP) research, child health coverage | high | WebFetch | 2026-09-28 |
| Medicaid.gov Section 1115 Waiver List | medicaid.gov/medicaid/section-1115-demo/demonstration-and-waiver-list | State-by-state Section 1115 waiver status | primary | WebFetch | 2026-09-28 |

---

## Education

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Education Week | edweek.org | K-12 policy and politics news | high | WebFetch | 2026-09-28 |
| K-12 Dive | k12dive.com | K-12 policy and legal news | high | WebFetch | 2026-09-28 |
| The 74 | the74million.org | Education news and policy analysis | high | WebFetch | 2026-09-28 |
| Chalkbeat | chalkbeat.org | Regional and national K-12 reporting | high | WebFetch | 2026-09-28 |
| Hechinger Report | hechingerreport.org | Nonprofit investigative education journalism | high | WebFetch | 2026-09-28 |
| Grant Witness | grantwitness.org | Federal grant terminations and freezes, grant-level data | high | WebFetch | 2026-09-28 |

---

## Environment

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Sabin Center Climate Backtracker | climate.law.columbia.edu/content/climate-backtracker | Tracks federal climate-policy rollback actions (Columbia Law) | high | WebFetch | 2026-09-28 |
| Harvard Environmental & Energy Law Program Regulatory Tracker | eelp.law.harvard.edu/tracker-type/regulatory-tracker/ | Environmental and energy regulatory rollback and litigation tracker | high | WebFetch | 2026-09-28 |
| Inside Climate News | insideclimatenews.org | Climate and environmental journalism | high | WebFetch | 2026-09-28 |

---

## Immigration

Expands the TRAC Immigration row in "Nonpartisan Research, Legal &
Procedural" above (trac.syr.edu) with sources for detention siting,
enforcement data, and agreement tracking.

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| Deportation Data Project | deportationdata.org | Freedom of Information Act (FOIA)'d Immigration and Customs Enforcement (ICE) arrest, detention, and removal data | high | WebFetch | 2026-09-28 |
| ICE 287(g) Agreements | ice.gov/identify-and-arrest/287g | Current 287(g) agreement list, by jurisdiction | primary | WebFetch | 2026-09-28 |
| ICE Detention Statistics | ice.gov/detain/detention-management | ICE detention custody data by fiscal year | primary | WebFetch | 2026-09-28 |
| DHS Office of Inspector General | oig.dhs.gov | ICE and DHS facility inspection reports | primary | WebFetch | 2026-09-28 |
| American Immigration Council | americanimmigrationcouncil.org | Immigration policy research | moderate | WebFetch | 2026-09-28 |
| National Immigration Law Center | nilc.org | Immigrant rights litigation and policy advocacy | moderate | Firecrawl | 2026-09-28 |
| Detention Watch Network | detentionwatchnetwork.org | Detention population data, anti-detention advocacy | moderate | WebFetch | 2026-09-28 |

---

## News Sources

Use news sources to find recent developments, quotes, and context — but trace
key facts back to primary sources before including them in a briefing.

| Source | URL | Best For | Reliability | Access | Last Verified |
|--------|-----|----------|-------------|--------|---------------|
| AP News | apnews.com | Breaking legislative news, wire reporting | high | Firecrawl | 2026-06-01 |
| The 19th | 19thnews.org | Gender, politics, voting rights coverage | high | WebFetch | 2026-06-01 |
| Politico | politico.com | Congressional procedure, whip counts, committee news | high | Firecrawl | 2026-06-01 |
| Roll Call | rollcall.com | Congressional floor and committee activity | high | Firecrawl | 2026-06-01 |
| NPR Politics | npr.org | Accessible legislative and EO coverage | high | WebFetch | 2026-06-01 |
| PBS NewsHour | pbs.org/newshour | Court rulings and EO implementation news | high | WebFetch | 2026-06-01 |
| Deseret News | deseret.com | GOP internal dynamics, Western/conservative Republican perspective on Senate strategy | high | Firecrawl | 2026-06-01 |
| The Lobby News | thelobbynews.com | Lobbying activity, industry influence, corporate advocacy tracking | high | WebFetch | 2026-06-09 |

**Notes from live research sessions:**
- Deseret News had the strongest "what's next" analysis on GOP internal
  dynamics for the SAVE Act — their congressional correspondent covers
  conservative Republican angles and intra-party resistance that national
  outlets often underreport. Useful when understanding why Senate Republicans
  are blocking or wavering is key to the action landscape.
- The Hill's reporting on the Kennedy reconciliation amendment vote (April
  2026) was accurate and well-sourced; useful for procedural vote details when
  dailypress.senate.gov coverage is incomplete.

---

## Citation Format

When citing sources in the briefing docx, use inline bracketed hyperlinks
immediately after the claim. Use the shortest recognizable domain as link text:

| Source | Link text to use |
|--------|-----------------|
| congress.gov | `[congress.gov]` |
| federalregister.gov | `[federalregister.gov]` |
| campaignlegal.org | `[campaign legal center]` |
| brennancenter.org | `[brennan center]` |
| naacpldf.org | `[naacp ldf]` |
| democracydocket.com | `[democracy docket]` |
| legislativeprocedure.com | `[legislative procedure]` |
| vote.org | `[vote.org]` |
| thelobbynews.com | `[the lobby news]` |
| reginfo.gov | `[reginfo.gov]` |
| federalregister.gov/public-inspection | `[federal register public inspection]` |
| regulations.gov | `[regulations.gov]` |
| openomb.org | `[openomb.org]` |
| gao.gov | `[gao.gov]` |
| cbo.gov | `[cbo.gov]` |
| appropriations.house.gov | `[house appropriations]` |
| appropriations.senate.gov | `[senate appropriations]` |
| crfb.org | `[committee for a responsible federal budget]` |
| cbpp.org | `[center on budget and policy priorities]` |
| usaspending.gov | `[usaspending.gov]` |
| courtlistener.com | `[courtlistener]` |
| justsecurity.org | `[just security]` |
| eac.gov | `[election assistance commission]` |
| justice.gov/crt | `[doj civil rights division]` |
| ncsl.org | `[ncsl]` |
| electionlawblog.org | `[election law blog]` |
| protectdemocracy.org | `[protect democracy]` |
| statesunited.org | `[states united democracy center]` |
| kff.org | `[kff]` |
| kffhealthnews.org | `[kff health news]` |
| ccf.georgetown.edu | `[georgetown ccf]` |
| medicaid.gov | `[medicaid.gov]` |
| edweek.org | `[education week]` |
| k12dive.com | `[k-12 dive]` |
| the74million.org | `[the 74]` |
| chalkbeat.org | `[chalkbeat]` |
| hechingerreport.org | `[hechinger report]` |
| grantwitness.org | `[grant witness]` |
| climate.law.columbia.edu | `[sabin center climate backtracker]` |
| eelp.law.harvard.edu | `[harvard eelp tracker]` |
| insideclimatenews.org | `[inside climate news]` |
| deportationdata.org | `[deportation data project]` |
| ice.gov | `[ice.gov]` |
| oig.dhs.gov | `[dhs office of inspector general]` |
| americanimmigrationcouncil.org | `[american immigration council]` |
| nilc.org | `[national immigration law center]` |
| detentionwatchnetwork.org | `[detention watch network]` |

State-specific sources (senator pages, state elections sites, state news
outlets) belong in `sources-[statecode].md`, not here.

This format works in Google Docs, PDF export, and Word. Do not use Word-style
footnote superscripts — they are not tappable in Google Docs.

---

## Sources to Avoid

The following source types tend to introduce inaccuracy or unverifiable claims
into briefings. Do not cite them as evidence for factual claims.

- **Social media posts** — even from members of Congress; use official .gov
  pages instead
- **Partisan news outlets** — use for context only; verify claims elsewhere
- **AI-generated summaries** — including those from other tools; always go
  to the primary source
- **Wikipedia** — useful for background orientation only; confirm all facts
  at primary sources before citing

---

*Last full review: 2026-09-28*
*Next recommended review: Start of 120th Congress (January 2027)*
