---
name: merge-pr
description: This skill should be used to merge an open, reviewed pull request back into its base branch, identified by its issue number or PR number. Trigger phrases include "merge PR #12", "merge this PR", "merge issue #12", "land this branch", or whenever an approved implementation is ready to merge.
---

# Merge PR

Merges an approved PR into its base branch and cleans up the branch — does not review or implement anything.

The base branch is whatever the PR targets: `develop` where the project has one, otherwise the default branch (typically `main`). Read it off the PR (`gh pr view <number> --json baseRefName`) rather than assuming.

## 1. Identify the PR

- Accept an issue number or a PR number. If genuinely unclear, ask.
- PR number: `gh pr view <number>` directly. Issue number: find the PR whose head branch is `issue/<issue-number>-*` (`gh pr list --search "head:issue/<issue-number>-"`).

## 2. Verify it's ready

- Confirm the PR is open, targets the expected base branch, has no unresolved review threads, and has no failing required checks (`gh pr checks <number>`).
- If blocked — failing CI, unresolved comments, merge conflicts — stop and report the blocker instead of force-merging.

## 3. Merge and delete the branch

- `gh pr merge <number> --squash --delete-branch`. Always use the squash merge method.
- Confirm the remote branch was deleted; if `--delete-branch` didn't remove it, delete it explicitly.

## 4. Clean up locally

```bash
git switch <base>
git branch -d issue/<slug>
git pull --ff-only
```

## 5. Report

Confirm the merge, the branch deletion (remote and local), and that the base branch is up to date. Note the issue this closed.

## 6. Check the Inbox

- List `.project/Inbox/findings-*.md` (skip if the folder is absent or empty).
- Recommend the user run a project meeting (`project-meeting`) if either holds: any finding is critical — needs immediate attention (e.g. security risk, data loss, broken build, blocker for other work) — or there are three or more findings pending.
- Keep it to a brief hint at the end of the report; name the critical finding(s) or the count. Do not open, triage, or act on the findings here — that is the project meeting's job.
