---
name: merge-pr
description: This skill should be used to merge an open, reviewed pull request back into develop, identified by its issue number or PR number. Trigger phrases include "merge PR #12", "merge this PR", "merge issue #12", "land this branch", or whenever an approved implementation is ready to merge.
---

# Merge PR

Merges an approved PR into `develop` and cleans up the branch — does not review or implement anything.

## 1. Identify the PR

- Accept an issue number or a PR number. If genuinely unclear, ask.
- PR number: `gh pr view <number>` directly. Issue number: find the PR whose head branch is `issue/<issue-number>-*` (`gh pr list --search "head:issue/<issue-number>-"`).

## 2. Verify it's ready

- Confirm the PR is open, targets `develop`, has no unresolved review threads, and has no failing required checks (`gh pr checks <number>`).
- If blocked — failing CI, unresolved comments, merge conflicts — stop and report the blocker instead of force-merging.

## 3. Merge and delete the branch

- `gh pr merge <number> --delete-branch`, using the repo's configured merge method (ask if more than one is enabled and it's unclear which to use).
- Confirm the remote branch was deleted; if `--delete-branch` didn't remove it, delete it explicitly.

## 4. Clean up locally

```bash
git switch develop
git branch -d issue/<slug>
git pull --ff-only
```

## 5. Report

Confirm the merge, the branch deletion (remote and local), and that `develop` is up to date. Note the issue this closed.
