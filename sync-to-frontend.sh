#!/bin/bash
# ============================================================================
# Mirror the skill into the catalog-beer frontend repo
# ----------------------------------------------------------------------------
# This repo (github.com/michaelkirkpatrick/catalog-beer-skills) is the
# CANONICAL source for the Catalog.beer agent skill. It is mirrored to
# https://catalog.beer/skills/catalog-beer/ so agents can fetch SKILL.md
# straight from llms.txt without GitHub or npm.
#
# Workflow after ANY change to catalog-beer/ in this repo:
#   1. Commit + push here
#   2. Run this script
#   3. Commit the catalog-beer frontend repo and run its ./deploy.sh
#
# Never edit catalog-beer/skills/ in the frontend repo directly — this
# script's --delete will discard those edits on the next sync.
# ============================================================================
set -euo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$SRC/../catalog-beer/skills/catalog-beer"

if [ ! -d "$SRC/../catalog-beer/.git" ]; then
	echo "Error: catalog-beer frontend repo not found next to this repo." >&2
	exit 1
fi

mkdir -p "$DEST"
rsync -a --delete --exclude '.DS_Store' --out-format='%n' "$SRC/catalog-beer/" "$DEST/"

echo "Mirrored catalog-beer/ → $DEST"
echo "Next: commit the catalog-beer repo and run its ./deploy.sh"
