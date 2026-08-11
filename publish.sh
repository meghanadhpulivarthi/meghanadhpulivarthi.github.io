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

echo "Rendering site..."
quarto render

echo "Pushing to $PUBLISH_BRANCH..."
quarto publish "$PUBLISH_BRANCH" --no-prompt

echo "Done. Live at $SITE_URL (allow a minute for Pages to rebuild)."
