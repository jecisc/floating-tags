# Floating tags

Composite GitHub Action. When a release is published, it creates or moves the floating tags `vX.Y.x` and `vX.x.x` to the release's commit.

## Rules

- Supported releases are `vX.Y.Z` or `X.Y.Z`. Anything else (letters other than a leading `v`, fewer than three numbers) fails the workflow.
- Every supported release moves both floating tags, even when a higher release already exists. Publishing `v1.2.3` after `v1.2.4` moves `v1.2.x` back to `v1.2.3`.
- Prereleases are skipped by the caller workflow, so they move nothing.

## Usage

Add `.github/workflows/floating-tags.yml` to the project, on its default branch:

```yaml
name: Floating tags

on:
  release:
    types: [ published ]

permissions:
  contents: write

jobs:
  move:
    if: ${{ !github.event.release.prerelease }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          fetch-tags: true
      - uses: jecisc/floating-tags@v1
```

GitHub runs `release` workflows from the default branch.
