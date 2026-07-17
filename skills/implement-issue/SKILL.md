---
name: implement-issue
description: This skill should be used to implement a single GitHub issue from a fresh, unimplemented state. Trigger phrases include "implement issue #12", "work on this ticket", "fix issue X", "resolve this issue", or whenever the user wants the full issue-to-PR workflow. If the issue already has a branch/PR, use check-pr-comments instead.
---

# Implement Issue

Follow this workflow end to end. Keep the user informed at important transitions, but continue autonomously unless a blocking question or unsafe repository state requires their input.

## 1. Identify the issue and check for an existing implementation

- Identify the GitHub issue by number. If genuinely unclear, ask.
- Search for a PR whose head branch is `issue/<issue-number>-*` (`gh pr list --search "head:issue/<issue-number>-"`).
- **Found one** — this issue is already implemented. Stop and tell the user to use the `check-pr-comments` skill instead; do not refresh the base branch, create a branch, or touch the existing one.
- **Found nothing** — continue to Step 2 as a fresh implementation.

## 2. Determine and refresh the base branch

- `git fetch` first. Check `git status`, current branch, and remotes. Never discard, stash, or sweep in unrelated user changes without explicit permission — if uncommitted changes make switching branches unsafe, stop and ask.
- The base branch is `develop` if it exists locally or on the remote; otherwise it's the repository's default branch (`gh repo view --json defaultBranchRef`), typically `main`. Single-branch projects are supported — don't create `develop` yourself.
- Update it with a fast-forward-only pull:
  ```bash
  git switch <base>
  git pull --ff-only
  ```

## 3. Review the issue

- Read any project instruction file (`CLAUDE.md`, `AGENTS.md`) and the relevant code/tests before acting.
- Fetch the issue's title, body, labels, linked context, and all comments (`gh issue view <number> --comments`).
- If the issue touches UI, styling, or any brand-facing output, also read `.project/Branding/BRAND.md` and `.project/Branding/Assets/`, if present, and implement against them (palette, typography, voice, logo/asset usage) — don't invent brand decisions the guide already made.
- Consult `.project/Knowledge/`, if present: list its subdirectory and file names (`ls -R .project/Knowledge`) and read only the entries whose names plausibly relate to this issue's area. Never read the tree wholesale; if nothing matches, skip it. Anything you do read (a convention, a gotcha, a past decision) is binding for this implementation — unless it asserts a specific, checkable state of the code or an issue (e.g. "bug X is unfixed", "feature Y is missing") that your own investigation contradicts. In that case, trust what you observe, proceed accordingly, and flag the entry as stale in Step 6.
- Restate the acceptance criteria internally; do not implement from the title alone.
- If something genuinely blocks a correct implementation (not resolvable from the codebase or convention), post one concise comment on the issue explaining the ambiguity, then stop and wait. Resume once answered.

## 4. Create the branch

- Branch from the freshly updated base branch, never using a worktree:
  ```bash
  git switch -c issue/<slug>
  ```
  `<slug>` is `<issue-number>-<kebab-title>`.
- Don't reset or overwrite an existing branch of that name — Step 1 already handles the case where one exists.

## 5. Implement and verify

- Inspect the affected architecture, nearby implementations, and existing tests before editing.
- Implement the smallest complete change that satisfies the issue and its acceptance criteria — no unrelated refactors.
- Add or update tests for every behavioral change. If a change has no meaningful layer for a test category, explain why in the final report instead of adding a vacuous test.
- Determine this project's build/test commands from its manifests, scripts, or instruction file, and run them after each coherent change. Fix failures before proceeding — do not publish with known relevant failures.
- Review the final diff and `git status`: implementation matches the issue, tests cover the behavior, no unrelated files included.

## 6. Capture findings and knowledge

- Anything found during implementation that needs the project owner's attention (scope gaps, follow-up work, potential new issues, risks, Knowledge entries contradicted by what you observed) — write `.project/Inbox/findings-<slug>.md` describing it, for review at the next project meeting.
- Anything learned worth keeping for future implementations (a gotcha, a convention, an architectural decision, a reusable pattern) — write it into `.project/Knowledge/`, in a subdirectory grouped by general topic (e.g. `architecture/`, `testing/`, `tooling/`); create a new subdirectory when nothing existing fits.
- Skip either if nothing qualifies — don't create empty or filler files.

## 7. Publish

- Commit only the issue-related changes, with a message referencing the issue.
- Push the branch and open a non-draft PR targeting the base branch from Step 2 (`gh pr create --base <base>`), with a summary and the verification commands that passed.
- **The PR body must include `Closes #<number>` on its own line** so GitHub auto-closes the issue on merge. Verify this line is present in the created PR before reporting completion — do not rely on a generic PR template to add it.

## 8. Report completion

Write `.project/Reports/<slug>.md` — a short report of what was implemented and how it was verified. `create-spec-issues` checks this directory to skip already-done work.

## 9. Independent review

- Launch the `verify-implementation` agent as a subagent (Agent tool, `subagent_type: verify-implementation`, `run_in_background: false`) so it reviews with its own fresh context. Give it the issue number and the PR number.
- Wait for it to finish — do not proceed, merge, or report done while it is running. It returns its findings directly in its final message; it does not post to the PR.

## 10. Address the review findings

- Findings returned: judge each one against the issue's acceptance criteria — valid and actionable, or not. For anything not actionable, note why instead of acting on it.
- For each valid finding, make the fix, then re-run the project's build/test commands; fix failures before proceeding.
- Stale knowledge findings aren't code fixes: add them to this issue's `.project/Inbox/findings-<slug>.md` (Step 6) instead, for resolution at the next project meeting — don't edit `.project/Knowledge/` directly.
- Commit and push the fixes to the existing branch.
- No findings: say so and stop; do not re-run the review or invent work.

## Failure handling

- Never claim a build, test, push, comment, or PR succeeded unless confirmed by the command/tool output.
- If auth, permissions, network, or CI blocks progress, preserve completed work and report the exact blocker.
- If requirements conflict with repository rules or constraints, comment on the issue (or tell the user) rather than guessing.
