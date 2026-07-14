---
name: check-pr-comments
description: This skill should be used to triage and address review feedback on an issue that already has an open PR. Trigger phrases include "check the PR comments", "address the review feedback", "handle the comments on PR #12", "respond to review comments", or whenever an already-implemented issue has feedback waiting.
---

# Check PR Comments

Addresses review feedback on an issue that's already implemented — does not re-implement or create a new branch/PR.

## 1. Identify the issue and its branch

- Accept an issue number or a PR number. If genuinely unclear, ask.
- PR number: `gh pr view <number>` directly. Issue number: find the PR whose head branch is `issue/<issue-number>-*` (`gh pr list --search "head:issue/<issue-number>-"`).
- `git switch` to that branch; do not create a new one.

## 2. Gather context and feedback

- Read the original issue in full — its acceptance criteria are the triage checklist.
- Fetch the feedback: all PR comments and unresolved review threads (`gh pr view <number> --comments`).
- If the feedback concerns UI, styling, or any brand-facing output, also read `.project/Branding/BRAND.md`, if present, and fix against it — don't invent brand decisions the guide already made.
- Consult `.project/Knowledge/`, if present: list its subdirectory and file names (`ls -R .project/Knowledge`) and read only the entries whose names plausibly relate to the feedback's area. Never read the tree wholesale; if nothing matches, skip it. A comment that contradicts a captured convention is worth flagging in the reply rather than silently following.

## 3. Triage and fix

- Judge each comment: valid and actionable, or not. For anything not actionable, reply explaining why instead of ignoring it.
- For each valid comment, make the fix, then determine this project's build/test commands from its manifests, scripts, or instruction file and run them — fix failures before proceeding.

## 4. Publish and report

- Commit and push the fixes to the existing branch.
- Reply to each addressed comment confirming the fix.
- Anything found that needs the project owner's attention: write `.project/Inbox/findings-<slug>.md`. Anything worth keeping for future implementations: add it to `.project/Knowledge/<topic>/`.
- Update `.project/Reports/<slug>.md` with the new verification results.
