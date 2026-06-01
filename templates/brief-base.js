/**
 * brief-base.js — Advocacy legislation brief docx scaffolding
 *
 * Exports a buildBrief(sections) function. Claude fills in the sections
 * object with content; this file handles all document structure, styling,
 * and helpers. This prevents Claude from regenerating boilerplate each
 * session and eliminates a class of docx API bugs.
 *
 * Usage:
 *   const { buildBrief } = require('./templates/brief-base');
 *   const fs = require('fs');
 *
 *   buildBrief({
 *     title: "SAVE America Act (S. 1383 / H.R. 22)",
 *     subtitle: "Briefing for Virginia Indivisible Group Leaders",
 *     issueArea: "Voting Rights & Election Administration",
 *     statusDate: "June 1, 2026",
 *     isActiveThreat: true,   // true = red headings on threat sections
 *     sections: {
 *       summary: [ ...paragraphs ],
 *       currentStatus: [ ...paragraphs ],
 *       senatorsPositions: [ ...paragraphs ],
 *       houseMembers: [ ...paragraphs ],
 *       stateImpact: [ ...paragraphs ],
 *       whoToContact: [ ...paragraphs ],
 *       recommendedActions: [ ...paragraphs ],
 *       accuracyNotes: [ ...paragraphs ],
 *       // optional:
 *       committeeLeverage: [ ...paragraphs ],
 *       watchList: [ ...paragraphs ],
 *     }
 *   }).then(buffer => fs.writeFileSync('briefing.docx', buffer));
 *
 * Requirements: npm install docx
 */

'use strict';

const {
  Document, Packer, Paragraph, TextRun, ExternalHyperlink,
  Header, Footer, AlignmentType, LevelFormat, HeadingLevel,
  BorderStyle, WidthType, Tab, TabStopType
} = require('docx');

// ── Brand colors ────────────────────────────────────────────────────────────
const C = {
  RED:   'C00000',   // active threat / urgency
  NAVY:  '1F3864',   // standard headings
  GRAY:  '595959',   // secondary text, footer
  BLACK: '000000',   // body text
};

// ── Font ────────────────────────────────────────────────────────────────────
const FONT = 'Arial';
const BODY_SIZE = 22;   // 11pt in half-points
const H1_SIZE   = 26;   // 13pt
const H2_SIZE   = 24;   // 12pt

// ── Page geometry (US Letter, 1-inch margins) ────────────────────────────────
const PAGE = {
  size: { width: 12240, height: 15840 },
  margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
};

// ── Numbering config ─────────────────────────────────────────────────────────
const NUMBERING = {
  config: [
    {
      reference: 'bullets',
      levels: [{
        level: 0, format: LevelFormat.BULLET, text: '\u2022',
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } }
      }]
    },
    {
      reference: 'numbers',
      levels: [{
        level: 0, format: LevelFormat.DECIMAL, text: '%1.',
        alignment: AlignmentType.LEFT,
        style: { paragraph: { indent: { left: 720, hanging: 360 } } }
      }]
    }
  ]
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
        paragraph: { spacing: { before: 280, after: 120 }, outlineLevel: 0 }
      },
      {
        id: 'Heading2', name: 'Heading 2', basedOn: 'Normal',
        next: 'Normal', quickFormat: true,
        run: { size: H2_SIZE, bold: true, font: FONT, color: C.NAVY },
        paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 1 }
      }
    ]
  };
}

// ── Helper: plain text run ───────────────────────────────────────────────────
function run(text, opts = {}) {
  return new TextRun({ text, font: FONT, size: BODY_SIZE, ...opts });
}

function bold(text, opts = {}) {
  return run(text, { bold: true, ...opts });
}

// ── Helper: inline hyperlink ─────────────────────────────────────────────────
function link(label, url) {
  return new ExternalHyperlink({
    link: url,
    children: [new TextRun({
      text: `[${label}]`, style: 'Hyperlink', font: FONT, size: BODY_SIZE
    })]
  });
}

// ── Helper: body paragraph ───────────────────────────────────────────────────
function body(children, opts = {}) {
  return new Paragraph({
    spacing: { before: 80, after: 80 },
    ...opts,
    children: Array.isArray(children)
      ? children
      : [run(children)]
  });
}

// ── Helper: bullet item ──────────────────────────────────────────────────────
function bullet(children) {
  return new Paragraph({
    numbering: { reference: 'bullets', level: 0 },
    spacing: { before: 40, after: 40 },
    children: Array.isArray(children) ? children : [run(children)]
  });
}

// ── Helper: numbered item ────────────────────────────────────────────────────
function numbered(children) {
  return new Paragraph({
    numbering: { reference: 'numbers', level: 0 },
    spacing: { before: 40, after: 40 },
    children: Array.isArray(children) ? children : [run(children)]
  });
}

// ── Helper: blank spacer paragraph ──────────────────────────────────────────
function spacer() {
  return new Paragraph({ spacing: { before: 40, after: 40 }, children: [run('')] });
}

// ── Helper: horizontal rule ──────────────────────────────────────────────────
function rule(color = 'CCCCCC') {
  return new Paragraph({
    spacing: { before: 80, after: 80 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 4, color, space: 2 } },
    children: [run('')]
  });
}

// ── Helper: H1 with bottom border, color-aware for threat sections ───────────
function h1(text, isThreat = false) {
  const color = isThreat ? C.RED : C.NAVY;
  return new Paragraph({
    heading: HeadingLevel.HEADING_1,
    spacing: { before: 280, after: 120 },
    border: { bottom: { style: BorderStyle.SINGLE, size: 6, color, space: 4 } },
    children: [new TextRun({ text, bold: true, color, font: FONT, size: H1_SIZE })]
  });
}

function h2(text, isThreat = false) {
  const color = isThreat ? C.RED : C.NAVY;
  return new Paragraph({
    heading: HeadingLevel.HEADING_2,
    spacing: { before: 200, after: 80 },
    children: [new TextRun({ text, bold: true, color, font: FONT, size: H2_SIZE })]
  });
}

// ── Header ───────────────────────────────────────────────────────────────────
function buildHeader(orgLine) {
  return new Header({
    children: [new Paragraph({
      spacing: { before: 0, after: 80 },
      border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: C.NAVY, space: 4 } },
      children: [run(orgLine, { bold: true, color: C.NAVY, size: 20 })]
    })]
  });
}

// ── Footer ───────────────────────────────────────────────────────────────────
function buildFooter(statusDate) {
  return new Footer({
    children: [new Paragraph({
      border: { top: { style: BorderStyle.SINGLE, size: 4, color: 'CCCCCC', space: 4 } },
      children: [
        run(
          `Status checked: ${statusDate} — Verify before distributing. Bill status changes rapidly.`,
          { color: C.GRAY, size: 18, italics: true }
        )
      ]
    })]
  });
}

// ── Title block ───────────────────────────────────────────────────────────────
function buildTitleBlock(title, subtitle, issueArea, statusDate, isActiveThreat) {
  const threatColor = isActiveThreat ? C.RED : C.NAVY;
  return [
    new Paragraph({
      spacing: { before: 0, after: 60 },
      children: [new TextRun({ text: title, bold: true, font: FONT, size: 36, color: C.NAVY })]
    }),
    new Paragraph({
      spacing: { before: 0, after: 60 },
      children: [run(subtitle, { size: 26, color: C.GRAY })]
    }),
    new Paragraph({
      spacing: { before: 0, after: 40 },
      children: [
        bold('Issue area: ', { color: threatColor }),
        run(issueArea, { color: threatColor })
      ]
    }),
    new Paragraph({
      spacing: { before: 0, after: 40 },
      children: [bold('Date: '), run(`${statusDate}  `), bold('— Verify before distributing')]
    }),
    rule(C.NAVY),
    spacer()
  ];
}

// ── Section builder ───────────────────────────────────────────────────────────
// Claude passes an array of already-built Paragraph objects for each section.
// This function just wraps them with the heading.
function section(heading, paragraphs, isThreat = false) {
  if (!paragraphs || paragraphs.length === 0) return [];
  return [h1(heading, isThreat), ...paragraphs, spacer()];
}

function subsection(heading, paragraphs, isThreat = false) {
  if (!paragraphs || paragraphs.length === 0) return [];
  return [h2(heading, isThreat), ...paragraphs, spacer()];
}

// ── Main builder ──────────────────────────────────────────────────────────────
/**
 * @param {object} config
 * @param {string} config.title          - Bill name
 * @param {string} config.subtitle       - e.g. "Briefing for Virginia Indivisible..."
 * @param {string} config.issueArea      - e.g. "Voting Rights & Election Administration"
 * @param {string} config.statusDate     - e.g. "June 1, 2026"
 * @param {boolean} [config.isActiveThreat=false] - Red headings for threat sections
 * @param {string} [config.orgHeader]    - Header line (defaults to generic)
 * @param {object} config.sections       - Section content (arrays of Paragraphs)
 * @returns {Promise<Buffer>}
 */
async function buildBrief(config) {
  const {
    title,
    subtitle,
    issueArea,
    statusDate,
    isActiveThreat = false,
    orgHeader = 'Virginia Indivisible Steering Committee  |  Federal Legislative Briefing',
    sections: s
  } = config;

  const children = [
    ...buildTitleBlock(title, subtitle, issueArea, statusDate, isActiveThreat),

    ...section('Summary', s.summary, isActiveThreat),
    ...section('Current Status', s.currentStatus, isActiveThreat),

    // Senators section — state name substituted by Claude in section heading
    ...section(s.senatorsHeading || 'Senators\' Positions', s.senatorsPositions),

    // House members — optional Committee Leverage subsection
    ...(s.houseMembers ? [h1(s.houseMembersHeading || 'House Members — Key Votes & Positions')] : []),
    ...(s.houseMembers || []),
    ...(s.committeeLeverage
      ? subsection('Committee Leverage', s.committeeLeverage)
      : []),
    spacer(),

    // Watch List (optional)
    ...(s.watchList ? section('Watch List', s.watchList) : []),

    ...section(s.stateImpactHeading || 'State-Specific Impact', s.stateImpact, isActiveThreat),
    ...section('Who to Contact', s.whoToContact),
    ...section('Recommended Actions — Right Now', s.recommendedActions, isActiveThreat),
    ...section('Accuracy Notes', s.accuracyNotes),

    rule(C.NAVY),
    body([
      run(
        'Prepared by the Virginia Indivisible Steering Committee's legislative tracking team. ' +
        'Questions or corrections: contact your regional chapter coordinator. ' +
        'This briefing is for internal use by chapter leaders; verify status before distributing publicly. ' +
        'Sources are all publicly available and linked inline.',
        { italics: true, color: C.GRAY, size: 20 }
      )
    ])
  ];

  const doc = new Document({
    numbering: NUMBERING,
    styles: buildStyles(),
    sections: [{
      properties: { page: PAGE },
      headers: { default: buildHeader(orgHeader) },
      footers: { default: buildFooter(statusDate) },
      children
    }]
  });

  return Packer.toBuffer(doc);
}

module.exports = {
  buildBrief,
  // Export helpers for Claude to use when building section content:
  run, bold, link, body, bullet, numbered, spacer, rule, h1, h2,
  section, subsection,
  C, FONT, BODY_SIZE
};
