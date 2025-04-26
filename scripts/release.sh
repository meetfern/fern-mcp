#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 v0.1.0"
  exit 1
fi

VERSION=$1

git add .
git commit -m "Prepare release $VERSION"
git tag -a "$VERSION" -m "Release $VERSION"
git push origin main --tags

echo "✅ Release $VERSION tagged and pushed."