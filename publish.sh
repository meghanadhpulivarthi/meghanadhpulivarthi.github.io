#!/bin/bash
set -euo pipefail

# Config — edit these directly
SITE_URL="https://meghanadhpulivarthi.github.io"
PUBLISH_BRANCH="gh-pages"

# Run from the repo root regardless of the caller's working directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Repo         : $SCRIPT_DIR"
echo "Publishing to: $PUBLISH_BRANCH"

# Refuse to publish from a dirty tree. Quarto renders whatever is on disk and will
# happily publish uncommitted edits, which would put text on the live site that
# exists in no commit and on no remote — impossible to reconstruct later.
echo "Checking for uncommitted changes..."
DIRTY_FILES="$(git status --porcelain)"
if [ -n "$DIRTY_FILES" ]; then
    echo "Refusing to publish: the working tree is dirty."
    echo "$DIRTY_FILES"
    echo "Commit or stash these changes first, then run publish.sh again."
    exit 1
fi

echo "Rendering site..."
quarto render

echo "Pushing to $PUBLISH_BRANCH..."
quarto publish "$PUBLISH_BRANCH" --no-prompt

# Push the source too, so the commit that produced the live site is on GitHub.
echo "Pushing source branch main to origin..."
git push origin main

echo "Done. Live at $SITE_URL (allow a minute for Pages to rebuild)."
