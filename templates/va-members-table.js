'use strict';

/**
 * va-members-table.js — Virginia Delegation Quick Reference Table
 * Reusable across briefings. Import and call buildMembersTable(briefingNotes).
 *
 * briefingNotes: object keyed by member ID (see MEMBERS below), value is a
 * string describing that member's relevance to the current briefing's issues.
 * If no note is provided for a member, the cell is left blank.
 *
 * Usage:
 *   const { buildMembersTable } = require('./va-members-table');
 *   // in your children array:
 *   buildMembersTable({
 *     'warner':   'Co-authored bipartisan FISA reauthorization bill ...',
 *     'kiggans':  'Has broken with leadership on select issues ...',
 *   })
 *
 * Returns an array of docx elements (heading + table) ready to spread into children[].
 */

const {
  Paragraph, TextRun, ExternalHyperlink,
  Table, TableRow, TableCell,
  AlignmentType, BorderStyle, WidthType, ShadingType, HeadingLevel,
} = require('docx');

const FONT       = 'Arial';
const BODY_SIZE  = 20;   // 10pt — compact for a reference table
const LABEL_SIZE = 18;   // 9pt — column headers and role labels
const H1_SIZE    = 28;

const C = {
  NAVY:  '1F3864',
  GRAY:  '595959',
  LGRAY: 'F2F2F2',
  DKGRAY:'404040',
  WHITE: 'FFFFFF',
  AMBER: 'E6A817',
  RED:   'C00000',
};

const CONTENT_WIDTH = 9720;

// Column widths (DXA). Total = CONTENT_WIDTH.
// Member | Phone/Contact | Committees | Briefing Notes
const COLS = [1600, 1400, 2760, 3960];

// ── Member data ───────────────────────────────────────────────────────────────
// Keep this as the single source of truth for Virginia delegation contact info
// and committee assignments. Update when assignments change.
// Verified: 2026-06-01 against clerk.house.gov and senate.gov.

const MEMBERS = [
  {
    id:         'warner',
    name:       'Mark Warner',
    party:      'D',
    seat:       'Senate',
    phone:      '(202) 224-2023',
    contactUrl: 'https://www.warner.senate.gov/public/index.cfm/contact',
    committees: [
      'Intelligence — Ranking Member',
      'Banking, Housing & Urban Affairs',
      'Finance',
      'Budget',
      'Rules & Administration',
    ],
  },
  {
    id:         'kaine',
    name:       'Tim Kaine',
    party:      'D',
    seat:       'Senate',
    phone:      '(202) 224-4024',
    contactUrl: 'https://kaine.senate.gov/contact',
    committees: [
      'Armed Services — Seapower RM',
      'Foreign Relations — W. Hemisphere RM',
      'Health, Education, Labor & Pensions',
      'Budget',
    ],
  },
  {
    id:         'wittman',
    name:       'Rob Wittman',
    party:      'R',
    seat:       'VA-01',
    phone:      '(202) 225-4261',
    contactUrl: 'https://wittman.house.gov/contact',
    committees: [
      'Armed Services — Vice Chair; TAL subcommittee Chair',
      'Natural Resources',
      'Select Committee on CCP Competition',
    ],
  },
  {
    id:         'kiggans',
    name:       'Jen Kiggans',
    party:      'R',
    seat:       'VA-02',
    phone:      '(202) 225-4215',
    contactUrl: 'https://kiggans.house.gov/contact',
    committees: [
      'Armed Services — Seapower subcommittee',
      'Veterans\' Affairs',
    ],
  },
  {
    id:         'scott',
    name:       'Bobby Scott',
    party:      'D',
    seat:       'VA-03',
    phone:      '(202) 225-8351',
    contactUrl: 'https://bobbyscott.house.gov/contact',
    committees: [
      'Education & Workforce — Ranking Member',
      'Budget',
    ],
  },
  {
    id:         'mcclellan',
    name:       'Jennifer McClellan',
    party:      'D',
    seat:       'VA-04',
    phone:      '(202) 225-6365',
    contactUrl: 'https://mcclellan.house.gov/contact',
    committees: [
      'Energy & Commerce',
      '— Communications & Technology subcommittee',
      '— Health subcommittee',
    ],
  },
  {
    id:         'mcguire',
    name:       'John McGuire',
    party:      'R',
    seat:       'VA-05',
    phone:      '(202) 225-4711',
    contactUrl: 'https://mcguire.house.gov/contact',
    committees: [
      'Armed Services — TAL subcommittee',
      'Oversight & Government Reform',
    ],
  },
  {
    id:         'cline',
    name:       'Ben Cline',
    party:      'R',
    seat:       'VA-06',
    phone:      '(202) 225-5431',
    contactUrl: 'https://cline.house.gov/contact',
    committees: [
      'Appropriations',
      '— Agriculture, Rural Dev., FDA subcommittee',
    ],
  },
  {
    id:         'vindman',
    name:       'Eugene Vindman',
    party:      'D',
    seat:       'VA-07',
    phone:      '(202) 225-6561',
    contactUrl: 'https://vindman.house.gov/contact',
    committees: [
      'Armed Services — Seapower subcommittee',
      'Agriculture',
    ],
  },
  {
    id:         'beyer',
    name:       'Don Beyer',
    party:      'D',
    seat:       'VA-08',
    phone:      '(202) 225-4376',
    contactUrl: 'https://beyer.house.gov/contact',
    committees: [
      'Ways & Means',
      'Joint Economic Committee',
    ],
  },
  {
    id:         'griffith',
    name:       'Morgan Griffith',
    party:      'R',
    seat:       'VA-09',
    phone:      '(202) 225-3861',
    contactUrl: 'https://griffith.house.gov/contact',
    committees: [
      'Energy & Commerce',
      '— Health subcommittee',
      '— Environment subcommittee',
      'House Administration',
      'Rules',
    ],
  },
  {
    id:         'subramanyam',
    name:       'Suhas Subramanyam',
    party:      'D',
    seat:       'VA-10',
    phone:      '(202) 225-5136',
    contactUrl: 'https://subramanyam.house.gov/contact',
    committees: [
      'Science, Space & Technology — Military/Foreign Affairs RM',
      'Oversight & Government Reform',
      'Ethics',
    ],
  },
  {
    id:         'walkinshaw',
    name:       'James Walkinshaw',
    party:      'D',
    seat:       'VA-11',
    phone:      '(202) 225-1492',
    contactUrl: 'https://walkinshaw.house.gov/contact',
    committees: [
      'Oversight & Government Reform',
    ],
  },
];

// ── Helpers ───────────────────────────────────────────────────────────────────

function t(text, opts = {}) {
  return new TextRun({ text, font: FONT, size: BODY_SIZE, ...opts });
}

function label(text) {
  return new TextRun({ text, font: FONT, size: LABEL_SIZE, bold: true, color: C.GRAY });
}

function hyperlink(text, url) {
  return new ExternalHyperlink({
    link: url,
    children: [new TextRun({ text, style: 'Hyperlink', font: FONT, size: BODY_SIZE })],
  });
}

function p(children, opts = {}) {
  return new Paragraph({
    spacing: { before: 30, after: 30 },
    ...opts,
    children: Array.isArray(children) ? children.flat() : [t(children)],
  });
}

function cell(children, opts = {}) {
  return new TableCell({
    margins: { top: 80, bottom: 80, left: 100, right: 100 },
    ...opts,
    children: Array.isArray(children) ? children : [children],
  });
}

function headerCell(text, width) {
  return new TableCell({
    width: { size: width, type: WidthType.DXA },
    shading: { type: ShadingType.CLEAR, fill: C.NAVY, color: 'auto' },
    margins: { top: 80, bottom: 80, left: 100, right: 100 },
    children: [p([new TextRun({
      text, font: FONT, size: LABEL_SIZE, bold: true, color: C.WHITE,
    })])],
  });
}

const CELL_BORDERS = {
  top:    { style: BorderStyle.SINGLE, size: 2, color: 'CCCCCC' },
  bottom: { style: BorderStyle.SINGLE, size: 2, color: 'CCCCCC' },
  left:   { style: BorderStyle.SINGLE, size: 2, color: 'CCCCCC' },
  right:  { style: BorderStyle.SINGLE, size: 2, color: 'CCCCCC' },
};

// ── Table builder ─────────────────────────────────────────────────────────────

function buildMembersTable(briefingNotes = {}) {
  const headerRow = new TableRow({
    tableHeader: true,
    children: [
      headerCell('Member', COLS[0]),
      headerCell('DC Phone / Contact', COLS[1]),
      headerCell('Key Committees', COLS[2]),
      headerCell('Briefing Notes', COLS[3]),
    ],
  });

  const dataRows = MEMBERS.map((m, i) => {
    const isEven = i % 2 === 0;
    const fill   = isEven ? C.WHITE : 'F7F7F7';
    const partyColor = m.party === 'D' ? '1A4B8C' : 'A01010';

    // Column 1: Seat + Name + Party
    const col1 = cell([
      p([t(m.seat, { size: LABEL_SIZE, color: C.GRAY, bold: true })]),
      p([t(m.name, { bold: true })]),
      p([t(`(${m.party})`, { color: partyColor, bold: true, size: LABEL_SIZE })]),
    ], {
      width: { size: COLS[0], type: WidthType.DXA },
      shading: { type: ShadingType.CLEAR, fill, color: 'auto' },
      borders: CELL_BORDERS,
    });

    // Column 2: Phone + contact link
    const col2 = cell([
      p([t(m.phone)]),
      p([hyperlink('contact form →', m.contactUrl)]),
    ], {
      width: { size: COLS[1], type: WidthType.DXA },
      shading: { type: ShadingType.CLEAR, fill, color: 'auto' },
      borders: CELL_BORDERS,
    });

    // Column 3: Committees
    const col3 = cell(
      m.committees.map(c => p([t(c)])),
      {
        width: { size: COLS[2], type: WidthType.DXA },
        shading: { type: ShadingType.CLEAR, fill, color: 'auto' },
        borders: CELL_BORDERS,
      }
    );

    // Column 4: Briefing notes (blank if none provided)
    const note = briefingNotes[m.id] || '';
    const col4 = cell([
      p(note ? [t(note)] : [t('')]),
    ], {
      width: { size: COLS[3], type: WidthType.DXA },
      shading: { type: ShadingType.CLEAR, fill, color: 'auto' },
      borders: CELL_BORDERS,
    });

    return new TableRow({ cantSplit: true, children: [col1, col2, col3, col4] });
  });

  const heading = new Paragraph({
    heading: HeadingLevel.HEADING_1,
    keepNext: true,
    spacing: { before: 280, after: 120 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: C.NAVY, space: 4 } },
    children: [new TextRun({ text: 'Virginia Delegation — Contact & Committee Reference', bold: true, color: C.NAVY, font: FONT, size: H1_SIZE })],
  });

  const caption = new Paragraph({
    spacing: { before: 40, after: 80 },
    children: [new TextRun({
      text: 'Committees verified June 2026. Briefing Notes column is specific to this briefing\'s issues.',
      font: FONT, size: LABEL_SIZE, color: C.GRAY, italics: true,
    })],
  });

  const table = new Table({
    width: { size: CONTENT_WIDTH, type: WidthType.DXA },
    columnWidths: COLS,
    rows: [headerRow, ...dataRows],
  });

  return [heading, caption, table];
}

module.exports = { buildMembersTable, MEMBERS };
