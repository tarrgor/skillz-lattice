---
name: verify-implementation
description: This skill should be used to review a pull request produced by implement-issue. Trigger phrases include "review this PR", "verify the implementation", "check PR #12", "review issue #12's implementation", or whenever a finished implementation needs an independent review before merge.
---

# Verify Implementation

Reviews a finished implementation against its issue — does not implement or fix anything.

## 1. Identify the issue and its PR

- Identify the GitHub issue by number. If genuinely unclear, ask.
- Find the PR whose head branch is `issue/<issue-number>-*` (`gh pr list --search "head:issue/<issue-number>-"`, or `gh pr view <number>` if the PR number is already known). Read the linked issue in full.
- Note the acceptance criteria specifically — they're the review's checklist.
- Consult `.project/Knowledge/`, if present: list its subdirectory and file names (`ls -R .project/Knowledge`) and read only the entries whose names plausibly relate to this issue's area. Never read the tree wholesale; if nothing matches, skip it. A captured convention the diff violates is a valid finding.

## 2. Gather the diff

- `gh pr diff <number>`.
- Read every changed file's surrounding context, not just the diff hunks, before judging correctness.

## 3. Review

Check the diff from three angles:

- **Acceptance criteria** — does the change satisfy every criterion from the issue? Note any unmet or partially met.
- **Correctness** — logic errors, edge cases, regressions, missing or inadequate tests for the behavior change.
- **Security** — injection, auth/authorization gaps, unsafe deserialization, committed secrets, unvalidated input, unsafe defaults, and other OWASP-class flaws.

Report only concrete, verifiable findings — not stylistic preference.

## 4. Report findings

- Do not post to the PR. Return the findings directly to whatever invoked this skill, as the final output — that caller is responsible for anything further.
- For each finding: the acceptance criterion or file/line it relates to, what's wrong, and why it matters. Group by acceptance criteria / correctness / security.
- No findings: say so explicitly, stating which criteria were checked.
