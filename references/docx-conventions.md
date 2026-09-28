# Docx Conventions

Shared by every sub-skill that produces a `.docx` deliverable. Moved out of
`AGENTS.md` in Phase 0 of the 2026-09 leading-edge coverage plan because
`build-zip.sh` does not ship `AGENTS.md` to claude.ai — sub-skills that
pointed there were pointing at nothing in an uploaded session.

---

## Briefing file lifecycle

1. Write `<topic>-brief.js` in the project root
2. Run `./scripts/check-acronyms.sh <topic>-brief.js` — fix any FAILs
3. Run `node <topic>-brief.js` to generate the docx
4. Publish and archive in one step:
   ```bash
   ./scripts/publish.sh <topic>-brief.docx <topic>-brief.js
   ```
   This copies the deliverable to Google Drive, verifies the bytes landed,
   and moves both files to `briefs/`. It refuses to run if Drive for Desktop
   is not running, which a bare `cp` would not catch.

   Do not use base64 or the Drive MCP upload tool. Both bloat context and can
   stall — a 20 KB docx costs roughly 10,000 tokens, re-billed on every
   subsequent turn.
5. Add the deliverable to `brief-index.md`, and record it in the issue's file
   under `issues/`.

**Markdown outputs** (short briefs, CTA roundups) have no `.js` or `node`
stage. They run `check-acronyms.sh` against the `.md` directly, then go
through `publish.sh` the same way. Every deliverable is archived in Drive,
not just the docx ones.

The `briefs/` directory is gitignored. Generated files never accumulate in
the project root.

---

## Docx Layout Defaults

The visual spec is fully defined in SKILL.md under "Visual formatting
conventions." The items below are the critical technical constraints that
apply to every briefing regardless of content — do not revert them.

**`ShadingType.CLEAR` (not `SOLID`)** — prevents black table cell backgrounds.

**Dual table widths** — set `columnWidths` array on the table AND `width` on
each cell, both in DXA units. Required for consistent rendering in Google Docs.

**Red headings are standalone only** — H1 headings inside shaded boxes (TL;DR,
Recommended Actions) always use navy, not red. Red is reserved for standalone
threat sections with no box. Two urgency signals on one element cancel each other.

**Two-column tables only (except the delegation reference table)** — Status at
a Glance is two-column. The delegation reference table (`templates/va-members-table.js`)
is intentionally four-column (member / phone / committees / briefing notes) and
occupies its own page as a reference appendix — acceptable because readers can
scroll horizontally on a dedicated reference page. All other tables must stay
two-column; four-column tables collapse to unreadable as inline content on Google
Docs mobile. Never add columns to other tables; consolidate into the wide right
column instead.
