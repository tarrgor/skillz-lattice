# Workflow conventions

Shared rules for all skills in this workflow. Skills reference this file as `../_shared/conventions.md` relative to their own directory.

## Branches and slugs

- `<slug>` = `<issue-number>-<kebab-title>` (e.g. `12-add-login`).
- Feature branch: `issue/<slug>`.
- Find an issue's PR: `gh pr list --search "head:issue/<issue-number>-"`.

## Base branch

`develop` if it exists locally or on the remote; otherwise the repository's default branch (`gh repo view --json defaultBranchRef`), typically `main`. Never create `develop` yourself.

## Committing to the base branch

The base branch is usually protected against direct pushes — never assume a commit can land there. Commit it, then `git push`; if the push is rejected (protected branch, required reviews, required checks), move the commit to a branch and open a PR instead:

```bash
git reset --soft HEAD~1
git switch -c <type>/<short-slug>
git commit -m "<message>"
git push -u origin <type>/<short-slug>
gh pr create --base <base> --fill
```

Report the follow-up PR number rather than claiming the change landed on the base branch. Never bypass protection (no `--admin`, no force-push). In a linked worktree, skip the commit entirely and report the change as pending.

## GitHub milestones

- Milestone title = the spec filename minus `SPEC-milestone-` and `.md` (`SPEC-milestone-001-auth-flow.md` → `001-auth-flow`). A legacy project with only `SPEC.md` uses `001-initial`.
- There is **no `gh milestone` subcommand** — create and close via the API. Create: `gh api repos/{owner}/{repo}/milestones -f title="<title>"`. Close: look up the number (`gh api repos/{owner}/{repo}/milestones --jq '.[] | select(.title=="<title>") | .number'`), then `gh api -X PATCH repos/{owner}/{repo}/milestones/<number> -f state=closed`.
- `gh issue create --milestone "<title>"` and `gh issue list --milestone "<title>"` accept the title directly.

## Spec `Status:` lifecycle

Every milestone spec's first line is `Status: <value>`: `Planned` (spec written, no issues yet) → `Active` (issues created) → `Done` (milestone closed). Legacy spec without the header: treat as `Active` if a matching GitHub milestone or issues exist, else `Planned`.

## Issue dependencies

A dependency on another issue is one line in the issue body: `Depends on #<number>` — exact prefix, own line, one line per blocker — so skills can parse it reliably.

## Knowledge

- **Consultation**: list `.project/Knowledge/` subdirectory and file names (`ls -R .project/Knowledge`) and read only entries whose names plausibly relate to the task's area. Never read the tree wholesale; if nothing matches, skip it. Anything read (a convention, a gotcha, a past decision) is binding — unless it asserts a specific, checkable state of the code or an issue (e.g. "bug X is unfixed") that your own investigation contradicts; then trust what you observe and flag the entry as stale.
- **Governance**: any skill may add a **new** entry under `.project/Knowledge/<topic>/`. Editing or deleting an **existing** entry happens only in `project-meeting` — route contradictions and corrections through `.project/Inbox/` findings instead.
