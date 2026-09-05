#!/bin/bash
# publish.sh — Copy a finished deliverable to the Google Drive briefings
# folder, then move the source files into briefs/.
#
# Why this exists: the destination path was restated in CLAUDE.md and three
# sub-skills, and a bare `cp` reports success even when Drive is quit, signed
# out, or out of quota — leaving the file sitting locally forever while the
# session claims it published. This puts the path in one place and checks what
# can actually be checked.
#
# Usage:
#   ./scripts/publish.sh <file> [more files...]
#
# Examples:
#   ./scripts/publish.sh iran-war-powers-brief.docx iran-war-powers-brief.js
#   ./scripts/publish.sh cta-roundup-2026-09-02.md
#
# Accepts .docx and .md deliverables, and .js sources. Only deliverables are
# copied to Drive; .js sources are archived to briefs/ but never published.
#
# NEVER use the Drive MCP upload tool instead of this. It requires the file
# base64-encoded inline in the tool call, which costs thousands of tokens per
# document and is re-billed on every subsequent turn of the session.

set -e

# Defaults to the Virginia committee's Drive mount. Every other deployment
# overrides it — see scripts/README.md and CONTRIBUTING.md.
DRIVE="${BRIEFING_DRIVE_PATH:-/Users/ernie/Library/CloudStorage/GoogleDrive-ernie.braganza@gmail.com/My Drive/Statewide Coordinating Committee /Legislation Briefings}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
ARCHIVE="${REPO}/briefs"

[ $# -ge 1 ] || { echo "Usage: $0 <file> [more files...]" >&2; exit 1; }

# --- Preflight -------------------------------------------------------------
# A missing mount means Drive for Desktop is not running or the account is
# signed out. Copying anyway would create a real local directory that shadows
# the mount point and never syncs.
if [ ! -d "$DRIVE" ]; then
  echo "Error: Drive folder not found:" >&2
  echo "  $DRIVE" >&2
  echo "Google Drive for Desktop may be quit or signed out. Start it and retry." >&2
  exit 1
fi

# Drive for Desktop is a macOS app, and `pgrep -q` is macOS-only. On other
# platforms the mount check above is the whole preflight — a network mount
# that is present is the best signal available there.
if [ "$(uname -s)" = "Darwin" ]; then
  if ! pgrep -qf "/Applications/Google Drive.app/Contents/MacOS/Google Drive"; then
    echo "Error: Google Drive for Desktop is not running." >&2
    echo "The copy would succeed locally and never upload. Start it and retry." >&2
    exit 1
  fi
fi

mkdir -p "$ARCHIVE"

PUBLISHED=0
ARCHIVED=0

for SRC in "$@"; do
  [ -f "$SRC" ] || { echo "Error: file not found: $SRC" >&2; exit 1; }
  BASE=$(basename "$SRC")

  case "$BASE" in
    *.docx|*.md)
      cp "$SRC" "$DRIVE/$BASE"

      # Verify the bytes landed. This confirms the local write, not the
      # upload — Drive uploads asynchronously and exposes no completion
      # signal we can read here.
      SRC_SUM=$(shasum -a 256 "$SRC" | cut -d' ' -f1)
      DST_SUM=$(shasum -a 256 "$DRIVE/$BASE" | cut -d' ' -f1)
      if [ "$SRC_SUM" != "$DST_SUM" ]; then
        echo "Error: copy verification failed for $BASE — checksums differ." >&2
        exit 1
      fi
      echo "Published: $BASE"
      PUBLISHED=$((PUBLISHED + 1))
      ;;
    *.js)
      echo "Archived only (source file, not published): $BASE"
      ;;
    *)
      echo "Error: unsupported file type: $BASE (expected .docx, .md, or .js)" >&2
      exit 1
      ;;
  esac

  mv "$SRC" "$ARCHIVE/$BASE"
  ARCHIVED=$((ARCHIVED + 1))
done

echo ""
echo "${PUBLISHED} file(s) copied to Drive, ${ARCHIVED} moved to briefs/."
echo ""
echo "Upload happens in the background and is NOT confirmed by this script."
echo "Drive for Desktop is running and the bytes were written correctly, but"
echo "if the account is out of quota the file will sit locally. Spot-check the"
echo "folder in a browser when publishing something that matters."
echo ""
echo "Remember to add the deliverable to brief-index.md."
