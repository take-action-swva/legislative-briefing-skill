/**
 * brief-base.js — Advocacy legislation brief docx scaffolding (v1.8)
 *
 * Exports buildBrief(config). Claude fills the sections object; this file
 * handles all document structure, styling, and helpers.
 *
 * Usage:
 *   const { buildBrief, run, bold, link, body, bullet, numbered, spacer } =
 *     require('./templates/brief-base');
 *   const fs = require('fs');
 *   buildBrief({ ... }).then(buf => fs.writeFileSync('briefing.docx', buf));
 *
 * Requirements: npm install docx
 */

'use strict';

const {
  Document, Packer, Paragraph, TextRun, ExternalHyperlink,
  Header, Footer, AlignmentType, LevelFormat, HeadingLevel,
  BorderStyle, WidthType, ShadingType,
  Table, TableRow, TableCell,
} = require('docx');

// ── Brand colors ─────────────────────────────────────────────────────────────
const C = {
  RED:   'C00000',   // high-threat standalone headings, TL;DR threat border
  NAVY:  '1F3864',   // primary headings, table headers, standard TL;DR border
  GRAY:  '595959',   // de-emphasized text, footer, role labels
  LGRAY: 'F2F2F2',   // table label column, standard TL;DR fill
  AMBER: 'E6A817',   // Recommended Actions box border
  WHITE: 'FFFFFF',   // table data cells
  BLACK: '000000',
};

// ── Font and sizes (in half-points) ─────────────────────────────────────────
const FONT       = 'Arial';
const BODY_SIZE  = 22;   // 11pt
const H1_SIZE    = 28;   // 14pt
const H2_SIZE    = 24;   // 12pt
const SMALL_SIZE = 20;   // 10pt — role labels, footer

// ── Page geometry (US Letter, 0.75 in top/bottom, 0.875 in left/right) ──────
const PAGE = {
  size: { width: 12240, height: 15840 },
  margin: { top: 1080, right: 1260, bottom: 1080, left: 1260 },
};

// Content width: 12240 − 2 × 1260 = 9720 DXA
const CONTENT_WIDTH = 9720;
const COL_NARROW    = 2880;                        // label / member column (~30%)
const COL_WIDE      = CONTENT_WIDTH - COL_NARROW;  // value / action column (~70%)

// ── Numbering ────────────────────────────────────────────────────────────────
const NUMBERING = {
  config: [
    {
      reference: 'bullets',
      levels: [{
        level: 0, format: LevelFormat.BULLET, text: '•',
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } },
      }],
    },
    {
      reference: 'numbers',
      levels: [{
        level: 0, format: LevelFormat.DECIMAL, text: '%1.',
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } },
      }],
    },
  ],
};

// ── Styles ───────────────────────────────────────────────────────────────────
function buildStyles() {
  return {
    default: { document: { run: { font: FONT, size: BODY_SIZE } } },
    paragraphStyles: [
      {
        id: 'Heading1', name: 'Heading 1', basedOn: 'Normal',
        next: 'Normal', quickFormat: true,
        run: { size: H1_SIZE, bold: true, font: FONT, color: C.NAVY },
        paragraph: { spacing: { before: 240, after: 120 }, outlineLevel: 0 },
      },
      {
        id: 'Heading2', name: 'Heading 2', basedOn: 'Normal',
        next: 'Normal', quickFormat: true,
        run: { size: H2_SIZE, bold: true, font: FONT, color: C.NAVY },
        paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 1 },
      },
    ],
  };
}

// ── Utility helpers ──────────────────────────────────────────────────────────

function run(text, opts = {}) {
  return new TextRun({ text, font: FONT, size: BODY_SIZE, ...opts });
}

function bold(text, opts = {}) {
  return run(text, { bold: true, ...opts });
}

function link(label, url) {
  return new ExternalHyperlink({
    link: url,
    children: [new TextRun({
      text: `[${label}]`, style: 'Hyperlink', font: FONT, size: BODY_SIZE,
    })],
  });
}

function body(children, opts = {}) {
  return new Paragraph({
    spacing: { before: 80, after: 80 },
    ...opts,
    children: Array.isArray(children) ? children : [run(children)],
  });
}

function subheading(children) {
  return body(children, { keepNext: true });
}

function bullet(children) {
  return new Paragraph({
    numbering: { reference: 'bullets', level: 0 },
    spacing: { before: 40, after: 40 },
    children: Array.isArray(children) ? children : [run(children)],
  });
}

function numbered(children) {
  return new Paragraph({
    numbering: { reference: 'numbers', level: 0 },
    spacing: { before: 40, after: 40 },
    children: Array.isArray(children) ? children : [run(children)],
  });
}

function spacer() {
  return new Paragraph({ spacing: { before: 40, after: 40 }, children: [run('')] });
}

function rule(color = 'CCCCCC') {
  return new Paragraph({
    spacing: { before: 80, after: 80 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 4, color, space: 2 } },
    children: [run('')],
  });
}

// Standalone section headings — red only when isThreat AND not inside a box
function h1(text, isThreat = false) {
  const color = isThreat ? C.RED : C.NAVY;
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    keepNext: true,
    spacing: { before: 240, after: 120 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color, space: 4 } },
    children: [new TextRun({ text, bold: true, color, font: FONT, size: H1_SIZE })],
  });
}

function h2(text, isThreat = false) {
  const color = isThreat ? C.RED : C.NAVY;
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    keepNext: true,
    spacing: { before: 200, after: 80 },
    children: [new TextRun({ text, bold: true, color, font: FONT, size: H2_SIZE })],
  });
}

// ── Structure helpers ─────────────────────────────────────────────────────────

// Single-cell shaded box (TL;DR and Recommended Actions).
// children: array of Paragraph objects.
// Headings inside boxes always use navy — never red — regardless of threat level.
function shadedBox(children, fill, borderColor) {
  return new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: [CONTENT_WIDTH],
    rows: [new TableRow({
      children: [new TableCell({
        width: { size: CONTENT_WIDTH, type: WidthType.DXA },
        shading: { type: ShadingType.CLEAR, fill, color: 'auto' },
        borders: {
          top:    { style: BorderStyle.SINGLE, size: 12, color: borderColor, space: 0 },
          bottom: { style: BorderStyle.SINGLE, size: 12, color: borderColor, space: 0 },
          left:   { style: BorderStyle.SINGLE, size: 12, color: borderColor, space: 0 },
          right:  { style: BorderStyle.SINGLE, size: 12, color: borderColor, space: 0 },
        },
        margins: { top: 120, bottom: 120, left: 180, right: 180 },
        children: Array.isArray(children) ? children : [children],
      })],
    })],
  });
}

// Heading for use inside a shaded box — always navy, no HeadingLevel (avoids
// outline numbering issues inside table cells).
function h1InBox(text) {
  return new Paragraph({
    keepNext: true,
    spacing: { before: 0, after: 120 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: C.NAVY, space: 4 } },
    children: [new TextRun({ text, bold: true, color: C.NAVY, font: FONT, size: H1_SIZE })],
  });
}

// Two-column Status at a Glance table.
// fields: Array<{ label: string, value: string | Run[], valueIsRed?: boolean }>
function statusTable(fields) {
  const cellOpts = { top: 80, bottom: 80, left: 120, right: 120 };

  const rows = fields.map(f => {
    const valueChildren = f.valueIsRed
      ? [bold(f.value, { color: C.RED })]
      : Array.isArray(f.value)
        ? f.value
        : [run(String(f.value))];

    return new TableRow({
      cantSplit: true,
      children: [
        new TableCell({
          width: { size: COL_NARROW, type: WidthType.DXA },
          shading: { type: ShadingType.CLEAR, fill: C.LGRAY, color: 'auto' },
          margins: cellOpts,
          children: [body([bold(f.label)])],
        }),
        new TableCell({
          width: { size: COL_WIDE, type: WidthType.DXA },
          shading: { type: ShadingType.CLEAR, fill: C.WHITE, color: 'auto' },
          margins: cellOpts,
          children: [body(valueChildren)],
        }),
      ],
    });
  });

  return new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: [COL_NARROW, COL_WIDE],
    rows,
  });
}

// Two-column Members — Positions & Contact table.
// members: Array<{
//   name: string,
//   role: string,           e.g. "U.S. Senator" or "U.S. Representative"
//   district?: string,      e.g. "VA-05" (omit for senators)
//   priority: 'call-now' | 'thank-reinforce' | 'constituent-pressure',
//   position: string,       plain-language position or "Position not publicly stated"
//   dcPhone: string,        e.g. "202-224-2023"
//   contactUrl: string,     e.g. "https://warner.senate.gov/contact"
//   email?: string,         include if a public email address exists
// }>
const PRIORITY_LABELS = {
  'call-now':             '→ Call now',
  'thank-reinforce':      '→ Thank and reinforce',
  'constituent-pressure': '→ Constituent pressure only',
};

function membersTable(members) {
  const cellOpts = { top: 80, bottom: 80, left: 120, right: 120 };

  const headerRow = new TableRow({
    tableHeader: true,
    cantSplit: true,
    children: [
      new TableCell({
        width: { size: COL_NARROW, type: WidthType.DXA },
        shading: { type: ShadingType.CLEAR, fill: C.NAVY, color: 'auto' },
        margins: cellOpts,
        children: [body([bold('Member', { color: C.WHITE })])],
      }),
      new TableCell({
        width: { size: COL_WIDE, type: WidthType.DXA },
        shading: { type: ShadingType.CLEAR, fill: C.NAVY, color: 'auto' },
        margins: cellOpts,
        children: [body([bold('Priority / Position / Contact', { color: C.WHITE })])],
      }),
    ],
  });

  const dataRows = members.map(m => {
    const label = PRIORITY_LABELS[m.priority] || m.priority;

    const contactParts = [];
    if (m.dcPhone) contactParts.push(run(`DC: ${m.dcPhone}`));
    if (m.contactUrl) {
      if (contactParts.length) contactParts.push(run(' | '));
      contactParts.push(link('contact form →', m.contactUrl));
    }
    if (m.email) contactParts.push(run(` | ${m.email}`));

    const memberCol = [
      body([bold(m.name)]),
      body([run(m.role, { size: SMALL_SIZE, color: C.GRAY })]),
      ...(m.district ? [body([run(m.district, { size: SMALL_SIZE, color: C.GRAY })])] : []),
    ];

    const actionCol = [
      body([bold(label)]),
      body([run(m.position)]),
      ...(contactParts.length ? [body(contactParts)] : []),
    ];

    return new TableRow({
      cantSplit: true,
      children: [
        new TableCell({
          width: { size: COL_NARROW, type: WidthType.DXA },
          shading: { type: ShadingType.CLEAR, fill: C.LGRAY, color: 'auto' },
          margins: cellOpts,
          children: memberCol,
        }),
        new TableCell({
          width: { size: COL_WIDE, type: WidthType.DXA },
          shading: { type: ShadingType.CLEAR, fill: C.WHITE, color: 'auto' },
          margins: cellOpts,
          children: actionCol,
        }),
      ],
    });
  });

  return new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: [COL_NARROW, COL_WIDE],
    rows: [headerRow, ...dataRows],
  });
}

// ── Header ───────────────────────────────────────────────────────────────────
function buildHeader(orgLine) {
  return new Header({
    children: [new Paragraph({
      spacing: { before: 0, after: 80 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: C.NAVY, space: 4 } },
      children: [run(orgLine, { bold: true, color: C.NAVY, size: SMALL_SIZE })],
    })],
  });
}

// ── Footer ───────────────────────────────────────────────────────────────────
function buildFooter(statusDate) {
  return new Footer({
    children: [new Paragraph({
      alignment: AlignmentType.CENTER,
      border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC', space: 4 } },
      children: [run(
        `Status checked: ${statusDate} — Verify the status of all bills before distributing.`,
        { color: C.GRAY, size: SMALL_SIZE, italics: true },
      )],
    })],
  });
}

// ── Title block ───────────────────────────────────────────────────────────────
function buildTitleBlock(title, subtitle, issueArea, statusDate) {
  return [
    new Paragraph({
      spacing: { before: 0, after: 60 },
      children: [new TextRun({ text: title, bold: true, font: FONT, size: 36, color: C.NAVY })],
    }),
    new Paragraph({
      spacing: { before: 0, after: 40 },
      children: [run(subtitle, { size: 26, color: C.GRAY })],
    }),
    new Paragraph({
      spacing: { before: 0, after: 40 },
      children: [bold('Issue area: '), run(issueArea)],
    }),
    new Paragraph({
      spacing: { before: 0, after: 40 },
      children: [bold('Date: '), run(statusDate)],
    }),
    rule(C.NAVY),
    spacer(),
  ];
}

// ── Main builder ──────────────────────────────────────────────────────────────
/**
 * @param {object}  config
 * @param {string}  config.title           Bill name, e.g. "FISA Reform Act (S. 999)"
 * @param {string}  config.subtitle        Audience, e.g. "Briefing for Virginia Indivisible Group Leaders"
 * @param {string}  config.issueArea       e.g. "Civil Liberties & Surveillance"
 * @param {string}  config.statusDate      e.g. "June 3, 2026"
 * @param {boolean} [config.isActiveThreat=false]  true → red TL;DR border + red threat headings
 * @param {string}  [config.state='Virginia']       State name for section heading
 * @param {string}  [config.orgHeader]     Header line (defaults to Virginia)
 *
 * @param {object}    config.sections
 * @param {Paragraph[]} config.sections.tldr
 *   TL;DR box content. 3–5 Paragraph objects. No heading inside — the box is the signal.
 *
 * @param {Array<{label:string, value:string|Run[], valueIsRed?:boolean}>} config.sections.statusFields
 *   Seven rows: Current status, Last action, Next decision point, Core dispute,
 *   Administration position, Bill supporters, Threat level (set valueIsRed: true).
 *
 * @param {Paragraph[]} config.sections.recommendedActions
 *   Action items for the amber box. Open with contact items ranked by leverage:
 *   (1) committee gatekeepers, (2) persuadables, (3) allies, (4) skip opponents.
 *   Each contact: numbered() for name/role, body() for DC phone + contact form,
 *   body() for leverage context sentence, body() for call script (italicized).
 *
 * @param {Paragraph[]} config.sections.whyItMatters
 *   Bullet paragraphs. Lead each with bold() key phrase + run() supporting text.
 *
 * @param {Array<{name,role,district?,priority,position,dcPhone,contactUrl,email?}>} config.sections.members
 *   priority: 'call-now' | 'thank-reinforce' | 'constituent-pressure'
 *   Order must match the contact ranking in recommendedActions.
 *
 * @param {Paragraph[]} [config.sections.donorContext]   Optional — sector-linked bills only.
 * @param {Paragraph[]} [config.sections.watchList]      Optional — non-state pivotal members.
 * @param {Paragraph[]}  config.sections.timeline        Bold date labels + one-sentence summaries.
 * @param {Paragraph[]}  config.sections.notesCaveats    Bullets: unverified claims, status date.
 *
 * @returns {Promise<Buffer>}
 */
async function buildBrief(config) {
  const {
    title,
    subtitle,
    issueArea,
    statusDate,
    isActiveThreat = false,
    state = 'Virginia',
    orgHeader = 'Virginia Indivisible Steering Committee  |  Federal Legislation Brief',
    sections: s,
  } = config;

  const tldrFill        = isActiveThreat ? 'FFE5E5' : C.LGRAY;
  const tldrBorderColor = isActiveThreat ? C.RED    : C.NAVY;

  const children = [
    // 1. Title block
    ...buildTitleBlock(title, subtitle, issueArea, statusDate),

    // 2. TL;DR box — no heading inside; box color is the urgency signal
    shadedBox(s.tldr, tldrFill, tldrBorderColor),
    spacer(),

    // 3. Status at a Glance
    h1('Status at a Glance'),
    statusTable(s.statusFields),
    spacer(),

    // 4. Recommended Actions — heading inside the amber box, always navy
    shadedBox(
      [h1InBox('Recommended Actions — Right Now'), ...s.recommendedActions],
      'FFF3CD',
      C.AMBER,
    ),
    spacer(),

    // 5. Why It Matters — red heading on active threat briefings
    h1('Why It Matters', isActiveThreat),
    ...s.whyItMatters,
    spacer(),

    // 6. Members table
    h1(`${state} Members — Positions & Contact`),
    membersTable(s.members),
    spacer(),

    // 7. Donor Context (optional)
    ...(s.donorContext && s.donorContext.length
      ? [h1('Donor Context'), ...s.donorContext, spacer()]
      : []),

    // 8. Watch List (optional)
    ...(s.watchList && s.watchList.length
      ? [h1('Watch List'), ...s.watchList, spacer()]
      : []),

    // 9. Legislative Timeline
    h1('Legislative Timeline'),
    ...s.timeline,
    spacer(),

    // 10. Notes & Caveats
    h1('Notes & Caveats'),
    ...s.notesCaveats,
    spacer(),

    rule(C.NAVY),
    body([run(
      'Prepared by the Virginia Indivisible steering committee legislation team. ' +
      'Questions or corrections: contact your regional group coordinator. ' +
      'Sources are all publicly available and linked inline.',
      { italics: true, color: C.GRAY, size: SMALL_SIZE },
    )]),
  ];

  const doc = new Document({
    numbering: NUMBERING,
    styles: buildStyles(),
    sections: [{
      properties: { page: PAGE },
      headers: { default: buildHeader(orgHeader) },
      footers: { default: buildFooter(statusDate) },
      children,
    }],
  });

  return Packer.toBuffer(doc);
}

module.exports = {
  buildBrief,
  // Content helpers — use these when building section arrays:
  run, bold, link, body, subheading, bullet, numbered, spacer, rule, h1, h2,
  // Structure helpers — for advanced layout:
  shadedBox, statusTable, membersTable,
  // Constants:
  C, FONT, BODY_SIZE, SMALL_SIZE, CONTENT_WIDTH, COL_NARROW, COL_WIDE,
};
