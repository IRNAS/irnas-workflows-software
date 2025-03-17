# pre-commit workflow

## Overview

This GitHub Actions workflow enforces pre-commit checks on code changes before merging them into the
main branch. It runs automatically on:

- Pull request creation, reopening, or updates (synchronize events)
- Pushes to the `main` branch

## What It Does

- Runs `pre-commit` hooks to check formatting, linting, and other code quality rules.
- Hooks are run on all commits in the PR or the commits pushed to the `main` branch, not just the
  latest one.

## Developer Experience

- **Before pushing or opening a pull request**, ensure you have `pre-commit` installed locally. See
  [pre-commit setup instructions](https://github.com/IRNAS/irnas-guidelines-docs/tree/main/tools/pre-commit).
- If a check fails, review the workflow logs for details and fix the issues locally before retrying.

By integrating this workflow, the repository maintains consistent code quality and commit history
standards automatically.
