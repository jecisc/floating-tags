#!/usr/bin/env bash
# Moves the floating tags of a release to its commit.
#
# A release is vX.Y.Z or X.Y.Z. It creates or moves:
# - vX.Y.x to the release
# - vX.x.x to the release
set -euo pipefail

release=${1:?usage: move-floating-tags.sh <release> [remote]}
remote=${2:-origin}

if [[ ! $release =~ ^v?([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
	echo "::error::$release is not supported: expected vX.Y.Z or X.Y.Z"
	exit 1
fi
major=${BASH_REMATCH[1]}
minor=${BASH_REMATCH[2]}
commit=$(git rev-parse "$release^{commit}")

for tag in "v$major.$minor.x" "v$major.x.x"; do
	if git rev-parse --quiet --verify "refs/tags/$tag" > /dev/null; then
		action=moved
	else
		action=created
	fi
	git tag --force "$tag" "$commit"
	git push --force "$remote" "refs/tags/$tag"
	echo "$action $tag -> $release ($commit)"
done
