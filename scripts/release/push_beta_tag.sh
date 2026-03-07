#!/bin/bash
# Push a zeroclaw-prefixed beta release tag
# Usage: ./scripts/release/push_beta_tag.sh [version]
# Example: ./scripts/release/push_beta_tag.sh 0.1.7-beta.1

set -euo pipefail

# Get version from Cargo.toml if not provided
if [ -z "${1:-}" ]; then
    BASE_VERSION=$(sed -n 's/^version = "\([^"]*\)"/\1/p' Cargo.toml | head -1)
    RUN_NUMBER=${GITHUB_RUN_NUMBER:-1}
    VERSION="${BASE_VERSION}-beta.${RUN_NUMBER}"
    echo "No version specified, using: ${VERSION}"
else
    VERSION="$1"
fi

TAG="zeroclaw/v${VERSION}"

echo "Creating tag: ${TAG}"

# Check if tag already exists
if git rev-parse "${TAG}" >/dev/null 2>&1; then
    echo "❌ Tag ${TAG} already exists!"
    exit 1
fi

# Create and push tag
git tag -a "${TAG}" -m "Beta release ${VERSION}"
git push origin "${TAG}"

echo "✅ Tag ${TAG} created and pushed!"
echo "GitHub Actions will now build and release."
