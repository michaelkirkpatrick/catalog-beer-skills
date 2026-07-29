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

# Stamp metadata.updated from git, not from the working tree. A fresh clone
# gets checkout-time mtimes, so file dates would claim the skill changed today
# when it didn't -- the last commit that touched catalog-beer/ is the honest
# answer. This is why step 1 of the workflow is "commit + push": an uncommitted
# edit is invisible here, so the stamp would understate what's being published.
# (metadata.version is NOT stamped -- semver is a judgement call about whether
# a change breaks an agent following the old copy. Bump it by hand.)
UPDATED="$(git -C "$SRC" log -1 --format=%cs -- catalog-beer/)"

if [ -n "$(git -C "$SRC" status --porcelain -- catalog-beer/)" ]; then
	echo "Warning: catalog-beer/ has uncommitted changes; stamping $UPDATED" >&2
	echo "         from the last commit. Commit first, then re-run." >&2
fi

# Rewrite in place -- capture, then truncate-and-write the same inode. Not
# `sed -i` (BSD wants an arg, GNU refuses one) and deliberately not mktemp+mv:
# moving a file in bumps the PARENT directory's mtime, and the zip below stores
# directory entries as well as files, so the archive bytes would change on every
# run even when nothing did. Writing in place leaves the directory alone.
# Command substitution eats trailing newlines; printf puts the single one back.
STAMPED="$(sed 's|^\( *updated: \).*|\1"'"$UPDATED"'"|' "$DEST/SKILL.md")"
printf '%s\n' "$STAMPED" > "$DEST/SKILL.md"

# Restore the source mtime the rsync had set: the zip stores per-entry mtimes,
# so leaving the post-write "now" here would also churn the archive.
touch -r "$SRC/catalog-beer/SKILL.md" "$DEST/SKILL.md"

# Downloadable zip for humans who can't run npx: Claude desktop / claude.ai
# take a skill as a zip uploaded under Settings, and GitHub's own "Download
# ZIP" is the wrong shape (it nests SKILL.md under a repo-name folder). Built
# from the MIRRORED tree so it can never disagree with the .md files served
# beside it, and it lands one level ABOVE $DEST -- the rsync --delete above
# would otherwise wipe it, same reason skills/.htaccess lives up there.
#
# -X drops uid/gid and extended attributes; rsync -a preserved the mtimes. So
# the bytes only change when the content does, and an unchanged sync leaves
# the frontend repo clean instead of churning a binary on every run.
(cd "$DEST/.." && rm -f catalog-beer.zip && zip -rqX catalog-beer.zip catalog-beer)

echo "Mirrored catalog-beer/ → $DEST"
echo "Built    catalog-beer.zip → $DEST/../catalog-beer.zip"
echo "Next: commit the catalog-beer repo and run its ./deploy.sh"
