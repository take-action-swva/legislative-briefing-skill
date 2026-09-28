# Plan: Leading-Edge Coverage for the Legislative Briefing Skill

**Written:** 2026-09-28
**Updated:** 2026-09-28, adding the CTA readiness model and member evidence/role fields accepted from an external review
**Updated:** 2026-09-28, Phase 0 complete and merged (PR #22)
**Updated:** 2026-09-28, Phase 1 complete and merged (PR #24)
**Applies to:** SKILL.md v3.6
**Target version:** 3.6 (Phases 1 and 3 change the research workflow, which requires a version bump per MAINTENANCE.md)

## Why

The skill verifies congressional activity well. It watches almost nothing else.
Most current threats to elections, immigrant communities, health, education,
and the environment arrive through agency rules, guidance, funding withholds,
grant terminations, enforcement changes, and federal litigation. The skill
also runs only on request, so it cannot surface a threat before someone asks
about it.

This plan closes both gaps in five phases. Phases 0 through 4 are edits to
this repo. Phase 5 is a standalone signals collector in its own repo.

## Scope decision (settled 2026-09-28)

**Federal actions only.** The Virginia General Assembly stays out of scope.
Virginia state agencies (Department of Medical Assistance Services, Department
of Education, Department of Environmental Quality, Department of Elections)
appear only as sources of Virginia impact data for a federal action. When a
federal change hands Virginia an implementation choice, a brief notes it in one
line and does not track the state process.

---

## Phase 0: Correctness fixes (do first) — done, merged 2026-09-28 (PR #22)

These are defects in the current skill, independent of the expansion.

All five items below are done. Also landed in the same PR, outside the
original scope of this phase: consolidated `CLAUDE.md` and `AGENTS.md` into
one file (Claude Code reads `AGENTS.md` natively when no `CLAUDE.md` is
present, v2.1.277+), since the two had drifted into duplicated upkeep with no
benefit; and added a `nullglob` guard to `build-zip.sh`'s new `issues/*.md`
glob, caught in review.

1. **Cache life mismatch.** `issues/_template.md` says positions and campaign
   asks cache for 30 days (lines 35 and 54). SKILL.md and `issues/README.md`
   say 45. Change the template to 45.

2. **Sub-skills cite a file the upload does not ship.** `horizon-90.md`,
   `cta-roundup.md`, and `brief-short.md` point to "Docx Layout Defaults" and
   "Briefing file lifecycle" in `CLAUDE.md`. `build-zip.sh` does not include
   `CLAUDE.md`, so on claude.ai those instructions resolve to nothing. Move the
   two sections into a new `references/docx-conventions.md`, add it to
   `REF_FILES` in `build-zip.sh`, and repoint the seven references.

3. **Scripts referenced but absent on claude.ai.** `build-zip.sh` excludes the
   `fetch-*` scripts on purpose (they need API keys). The skill still tells
   every session to run `fetch-cosponsors.sh`, `fetch-votes.sh`,
   `fetch-donors.sh`, and `publish.sh`. Add a short "Running on claude.ai"
   section to SKILL.md that names the fallback for each:
   - cosponsors and votes: the congress.gov bill page (browser if WebFetch is blocked)
   - donors: `donor-context-va.md` is not shipped either; skip donor claims or verify at fec.gov
   - publish: the Google Drive connector, then update `brief-index.md` in the repo

4. **Empty cache on claude.ai.** Only `issues/README.md` and
   `issues/_template.md` ship, so the six issue files never reach claude.ai
   sessions. Add `issues/*.md` to `ISSUES_FILES`. State in SKILL.md that the
   uploaded copy is a read-only snapshot: freshness rules still apply, and any
   write-back must be committed to the repo.

5. **Firecrawl assumption.** The Access column in `sources-national.md` rates
   several sources "Firecrawl," which is not connected on claude.ai. Add
   "browser" as the fallback in the access-method key.

---

## Phase 1: Scope and taxonomy — done, merged 2026-09-28 (PR #24)

All seven items below are done, plus two fixes caught in review: a
contradictory pair of instructions in `issues/_template.md` for the
no-record-found case (one said leave Position blank, the other said write
"position not found during research" there — removed the first), and
`federal-grants-rule.md` being marked `cta-ready` while its own Next decision
was Certainty: Watch / Date: unknown, which fails readiness condition 1 —
repointed at the issue's real near-term decision point (the Scheduled
December 11 CR deadline its block rides on).

1. **Scope statement.** Add the scope decision above to SKILL.md, directly
   under the Audience scope paragraph.

2. **Description triggers.** Add agency-action phrasing: rule, regulation,
   comment period, agency action, grant cuts, funding freeze, impoundment.
   **Constraint:** the description is 988 of 1,024 characters. Trim before
   adding. Candidates to cut: "give me a quick summary" (overlaps "short
   brief"), and fold "the digest" into "monthly newsletter or digest."
   `build-zip.sh` fails the build if this runs over.

3. **Issue tags.** Add two fields to `issues/_template.md` under Status:
   - **Issue area:** elections, immigration, health, education, environment,
     budget, federal workforce, civil liberties, other
   - **Threat vectors:** legislation, appropriations, rulemaking, guidance,
     funding action (apportionment, impoundment, rescission), grant action,
     enforcement, litigation

   Rename "Bills and vehicles" to "Vehicles" and allow Federal Register
   dockets, court dockets, and funding actions as rows.

4. **Backfill.** Tag the six existing issue files, including stage, next
   decision, blocker, and the member evidence column from items 6 and 7.

5. **Accuracy Rule 6 additions.** Add to the never-cached, verify-on-distribution
   list: apportionment or impoundment status, and grant termination or
   reinstatement status. Both reverse on court orders with no congress.gov trace.

6. **CTA readiness model.** Give each issue an explicit stage so the move from
   "prepare" to "act" follows written conditions instead of editorial feel.
   Add to `issues/_template.md`:

   - **Stage:** `watch` | `prepare` | `cta-ready`. Distribution and outcomes
     stay in the existing "Outputs produced" and "Outcomes" sections, which
     already cover what happens after an ask goes out.
   - **Next decision:** type (markup, floor vote, comment deadline, rule
     effective date, appropriations deadline, court ruling), certainty
     (Scheduled, Expected, Watch), date or "unknown", and source URL.
   - **Blocker:** one line naming the unmet condition, e.g. "no confirmed
     markup notice."

   An issue is `cta-ready` when all four hold:
   1. An identified decision point with a primary source
   2. A target with a documented role in that decision
   3. An ask expressible as a specific yes/no request, verifiable against a
      primary source
   4. A response that can be observed afterward

   Deciding whether each condition holds still takes judgment. Writing the
   conditions down makes that judgment auditable, not automatic.

   The conditions cover agency actions as well as legislation. For a rule, the
   decision point is a comment deadline or effective date, the target is the
   agency, and the observable response is a submitted comment or a change in
   the final rule.

   Add a short "CTA readiness" section to SKILL.md defining the stages and
   conditions, so every sub-skill uses the same vocabulary.

7. **Member evidence and role.** Keep the three tiers. They tell organizers
   whether to escalate, persuade, or put a response on record, and that
   distinction is what the asks are built on. Two additions make the evidence
   behind a tier explicit:

   - **Evidence column** in the issue file's member table: `record found` or
     `no record found`. A Tier 2 member with no record then reads differently
     from one who broke with party on a related vote.
   - **Role field**, extending the existing Gatekeeper flag: gatekeeper,
     relevant committee, floor vote, oversight authority, or other. It states
     the factual reason an office matters to this decision, which readiness
     condition 2 needs.

   Update the Shared Member Taxonomy in SKILL.md to describe both. Rendering
   labels in outputs do not change.

---

## Phase 2: Sources

Verify every URL resolves and record a real `Last Verified` date before adding
a row. Anything that fails verification stays out. Ratings follow the existing
primary / high / moderate / monitor scale.

### sources-national.md: new sections

**Leading indicators (executive and regulatory pipeline)**
- reginfo.gov: rules under review at the Office of Information and Regulatory Affairs (OIRA); Unified Agenda
- federalregister.gov/public-inspection: documents posted the day before publication
- regulations.gov: open comment periods and deadlines (already listed; move here)
- openomb.org: apportionment footnotes, earliest sign of withheld funds
- gao.gov: Impoundment Control Act decisions

**Budget and appropriations**
- Congressional Budget Office (cbo.gov)
- House and Senate Appropriations committee sites
- Committee for a Responsible Federal Budget (crfb.org)
- Center on Budget and Policy Priorities (cbpp.org), moderate
- USAspending.gov and its API, for Virginia dollars at risk by county

**Litigation tracking**
- CourtListener (courtlistener.com): dockets, alerts, API
- Just Security litigation tracker for administration cases

**Health**
- KFF and KFF Health News
- Georgetown Center for Children and Families (ccf.georgetown.edu)
- Medicaid.gov state waiver pages

**Education**
- Education Week, K-12 Dive, The 74, Chalkbeat, Hechinger Report
- Grant Witness, for federal grant terminations

**Environment**
- Sabin Center Climate Backtracker (Columbia Law)
- Harvard Environmental and Energy Law Program regulatory tracker
- Inside Climate News

**Immigration (expand the existing TRAC row)**
- Deportation Data Project (FOIA'd ICE records)
- ice.gov 287(g) agreement list
- ICE detention statistics; DHS Office of Inspector General inspection reports
- American Immigration Council, National Immigration Law Center, Detention Watch Network

**Elections (expand)**
- U.S. Election Assistance Commission (eac.gov)
- Department of Justice Civil Rights Division press releases
- National Conference of State Legislatures (ncsl.org)
- Election Law Blog
- Protect Democracy, States United Democracy Center

### sources-va.md: new sections

**Virginia news**
- Virginia Mercury
- Cardinal News (Southwest Virginia)
- VPM News, Radio IQ
- Richmond Times-Dispatch

**Virginia impact data (federal actions only, per scope)**
- Department of Medical Assistance Services
- Department of Education
- Department of Environmental Quality

**Virginia advocacy and analysis (moderate)**
- The Commonwealth Institute
- Legal Aid Justice Center
- ACLU of Virginia
- Appalachian Voices
- Southern Environmental Law Center

**Existing row to check:** confirm virginiaindependentnews.com is an
established outlet before keeping its "high" rating. Downgrade to monitor or
remove if it does not hold up.

Add a citation link-text row for every new source.

---

## Phase 3: Workflow changes

1. **horizon-90.md Step 2.** Add the leading-indicator sources as required
   scan inputs. A rule under OIRA review with no publication date is a Watch
   item. A comment deadline is Scheduled.

2. **horizon-90.md coverage check.** Require candidates from every issue area
   before narrowing to 6 to 10 items. The closing note names any area with
   no qualifying item, so a quiet area reads as checked rather than missed.

3. **cta-roundup.md.** Add public comment as an ask type alongside
   congressional asks. It carries the docket number, the deadline (Scheduled),
   and the regulations.gov link. No member tiering applies.

4. **brief-full.md Step 2.** For non-legislative actions, the primary source is
   the Federal Register document, agency notice, or court docket. congress.gov
   does not apply.

5. **brief-full.md Step 4.** Add USAspending.gov as the default for Virginia
   dollar impact, by county where the data supports it.

6. **Litigation in issue files.** Record the CourtListener docket URL for any
   active case. Case status stays uncached per Rule 6; the URL makes the live
   check fast.

7. **Stages in horizon-90.md.** Every horizon item sets or updates its issue's
   stage (Phase 1, item 6). The item's "Prepare" line comes from the blocker:
   it names what organizers can do while the unmet condition holds, such as
   collecting constituent stories or lining up media contacts.

8. **Stages in cta-roundup.md.** Digest mode selects from `cta-ready` issues
   first. An item that fails a readiness condition stays out of the action
   list and goes back to Horizon-90 with its blocker recorded.

---

## Phase 4: Maintenance

1. **Coverage audit.** Add a quarterly step to MAINTENANCE.md: count
   `brief-index.md` rows and active `issues/` files by issue area. As of this
   plan, the index shows no environment or education outputs.

2. **brief-index.md.** Add an Issue area column.

3. **Post-election refresh.** Both Warner's seat and all 11 House seats are on
   the November 3, 2026 ballot. Regenerate `state-context-va.md` and
   `templates/va-members-table.js` after certification, then again once
   committee assignments settle in January. Run
   `check-delegation-parity.sh VA` after each.

---

## Phase 5: Watch loop (signals collector)

Staying ahead of threats requires polling, not better prompts. The loop polls
these sources on a schedule and writes candidate items for the skill to read:

| Source | Access | Key |
|---|---|---|
| Federal Register API | REST, filter by agency and term | none |
| congress.gov API | REST, bill actions | api.data.gov |
| regulations.gov API | REST, comment periods | api.data.gov |
| CourtListener API | REST and docket alerts | CourtListener token |
| Tier-one outlets | RSS | none |

### Placement (settled 2026-09-28)

This skill is the only implemented system. The CTA intelligence pipeline is
designed but not built, so there is no existing code to extend in either place.

Build the collectors and the D1 `signals` table as a standalone system with a
neutral name, in its own repo, owned by neither this skill nor the CTA
pipeline.

- **First consumer: this skill.** Horizon-90 and digest-mode runs query the
  `signals` table through the Cloudflare connector.
- **Later consumer: the CTA pipeline.** Its Slack card, Approve/Dismiss, and
  Mark sent layers read the same table when that pipeline is built. The
  collectors do not change.

One collector system feeds both, instead of two pollers with separate keys,
dedupe logic, and source ratings drifting apart.

### Collector design

1. **One cron Worker per source.** Each normalizes results to a common record:
   source, URL, published date, agency, docket or bill number, deadline.
2. **Filter in code before any model call.** Agency list, search terms, and
   Virginia keywords run in the collector. No AI in the first build.
3. **Public sources only.** Community reports, rapid-response sightings, and
   unverified social posts never enter this table. Immigration rapid-response
   data carries safety risk and belongs in a separate, access-controlled
   system.
4. **Readiness trigger.** A new signal carrying an `issue_slug` (a markup
   notice, a published comment deadline, a court ruling) flags that issue for
   a readiness recheck against the Phase 1 conditions. The first build only
   records the flag; a skill run acts on it. Nothing changes an issue's stage
   without a human-reviewed run.

### Decisions to settle in the first build

These are hard to change once two consumers depend on them.

- **`signals` schema.** Version it from the start.
- **Vocabulary.** Issue areas and threat vectors match `issues/_template.md`
  exactly (Phase 1, item 3). Each signal carries an `issue_slug` matching
  `issues/<slug>.md` so signals roll up to the research cache.
- **Certainty tag.** Scheduled, Expected, or Watch, per Accuracy Rule 7.
- **One reliability scale.** Use this skill's primary / high / moderate /
  monitor ratings. Do not introduce a separate numbered tier scheme.

### Smallest first build

1. Federal Register collector (no key) and regulations.gov collector
   (api.data.gov key), writing to D1. No AI, no Slack.
2. One Horizon-90 run that reads the table. Judge whether the signals improved
   the scan before adding anything else.
3. Then congress.gov, CourtListener, and RSS collectors.
4. The CTA pipeline's Slack layer comes after, as its own project.

---

## Sequencing

| Phase | Depends on | Version bump |
|---|---|---|
| 0 Correctness fixes | nothing | no |
| 1 Scope and taxonomy | 0 | yes (3.6) |
| 2 Sources | nothing | no |
| 3 Workflow changes | 1, 2 | included in 3.6 |
| 4 Maintenance | 1 | no |
| 5 Signals collector | 1 (shared vocabulary) | no (separate repo) |

Commit each phase separately. After Phases 0 through 3, run
`./scripts/build-zip.sh` and re-upload to claude.ai. Confirm the description
check passes and the zip listing includes `references/docx-conventions.md` and
the issue files.

## Out of scope

- Virginia General Assembly legislation and state budget tracking
- District-focused variants (existing audience-scope rule stands)
