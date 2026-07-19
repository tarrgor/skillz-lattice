# skillz-lattice - An agentic coding workflow

A set of AI coding agent skills that implement a **spec-driven development** workflow: turn a rough idea into a confirmed spec, break it into issues, implement and review each one, and keep a running log of decisions and knowledge — all with you in the loop for every decision that matters. Written for [Claude Code](https://claude.com/claude-code) but not specific to it — any agent that supports skills can use them.

## Requirements

- **A GitHub repo.** The workflow runs on GitHub throughout — issues, pull requests, and review comments — and has no offline fallback. Issues are grouped into a GitHub milestone per spec (created via `gh api`). If the project isn't on GitHub yet, **kick-off** and **create-spec-issues** say so and offer to create the repo for you.
- **The [GitHub CLI](https://cli.github.com) (`gh`), installed and authenticated.** Every skill drives GitHub through `gh`. Install it (`brew install gh` on macOS), then run `gh auth login`; `gh auth status` should succeed before you start.
- **A base branch for feature work.** `develop` is preferred — it keeps released code on `main` separate from work in progress — but it's optional: if the repo doesn't have one, the skills use its default branch (usually `main`) instead. Either way, feature branches are cut from the base branch and PRs target it.

## The workflow

```
kick-off ──────────────► create-spec-issues ──────────────► implement-issue
(idea → SPEC.md)         (spec → milestone + issues)        (issue → PR)
                                                                   │
                                                                   ▼
project-meeting  ◄────────────  merge-pr  ◄──────────  verify-implementation
(triage findings,               (approved PR             (PR → findings)
 plan next steps)                → base branch)            │
        ▲                                                       ▼
        │                                              check-pr-comments
        └──────────── new issues, spec changes ◄────── (feedback → fixes)

project-status — run anytime: where does the project stand, what's the next action?
```

Each skill ends by naming the next step, so you always know what to run next. For an existing project that doesn't follow this workflow yet, **migrate-project** is the entry point instead of kick-off.

1. **kick-off** — interviews you about a new project or milestone, one question at a time, and writes a confirmed spec.
2. **create-spec-issues** — reads the newest spec, checks it against the code and captured knowledge for stale claims, and breaks it into one GitHub issue per unit of work — grouped under a GitHub milestone, ordered by dependency (`Depends on #N`).
3. **implement-issue** — implements a single issue end to end: branch, code, tests, and a pull request. Refuses issues whose blockers are still open.
4. **verify-implementation** — independently reviews the resulting PR for bugs, security issues, and unmet acceptance criteria, and returns its findings to the caller (implement-issue acts on them). Ships with a matching subagent (`agents/verify-implementation.md`), so the review runs in its own context window: the diff and the file reads stay out of your main conversation, and only a summary comes back. It delegates to that subagent however it was reached — including when you invoke it directly — so the review is never done by the context that wrote the code.
5. **check-pr-comments** — triages review feedback on an already-implemented issue and fixes what's valid.
6. **merge-pr** — merges an approved PR back into the base branch, cleans up the branch, and closes the milestone when its last issue lands.
7. **project-meeting** — a recurring status meeting: reviews open findings, reports on finished work, and plans what's next — always with your confirmation before anything is decided.
8. **project-status** — read-only, run anytime: reports milestone progress, open PRs, and pending findings, and recommends exactly one next action.
9. **migrate-project** — entry point for an existing project that doesn't follow the workflow yet: inventories its planning documents and GitHub state, migrates everything into `.project/` and a milestone, and archives the originals. Re-runnable — it migrates only what's missing.
10. **create-obsidian-vault** — makes `.project/` browsable as an Obsidian vault: vault config plus a generated `Home.md` index of specs, knowledge, findings, and reports. **You invoke this one** — run `/create-obsidian-vault` whenever you want the vault created or its index refreshed. Agents never run it on their own; kick-off and migrate-project only remind you it exists.
11. **generate-branding** — standalone, on demand: produces or refreshes a brand identity guide and visual assets in `.project/Branding/`. Independent of the loop above — run it whenever you want branding created or updated.

Conventions shared by all skills (branch naming, committing to a protected base branch, milestone commands, the spec `Status:` lifecycle, Knowledge rules) live in `skills/_shared/conventions.md`.

## The `.project/` directory

Skills read and write project state here (created automatically on first use):

| Folder | Purpose |
|---|---|
| `SPEC.md` | The original, confirmed project spec |
| `SPEC-milestone-<###>-<slug>.md` | One confirmed spec per milestone, with a `Status: Planned/Active/Done` header |
| `Reports/` | Short completion reports, one per finished issue |
| `Inbox/` | Findings surfaced during implementation, awaiting discussion |
| `Archive/` | Resolved findings and past meeting records |
| `Knowledge/` | Durable learnings, organized by topic |
| `Branding/BRAND.md` | Brand identity guide: palette, typography, voice & tone |
| `Branding/Assets/` | Generated logo, icon, and marketing assets (or creative briefs) |
| `Home.md` + `.obsidian/` | Obsidian vault: open `.project/` as a vault to browse all of the above |

## How to use it

Skills live in a plain top-level `skills/` folder rather than `.claude/skills/`, so your agent won't auto-discover them on its own. Run `install.sh` to symlink everything into place, so updates in this repo stay in sync:

```bash
./install.sh              # create the symlinks
./install.sh --dry-run    # show what would happen, change nothing
./install.sh --force      # also replace symlinks that point elsewhere
```

| Source | Symlinked into |
|---|---|
| `skills/<name>/` | `~/.claude/skills`, `~/.agents/skills` |
| `agents/<name>.md` | `~/.claude/agents` |

`skills/_shared/` is linked alongside the skills — it's not a skill itself, but the conventions file the skills reference as a sibling directory.

Existing symlinks that point somewhere else are skipped unless you pass `--force`, and real files or directories are never overwritten. If you'd rather not symlink, copy the `skills/<name>/` folders and `agents/<name>.md` files into your agent's skills and subagent directories by hand.

Subagents are a Claude Code feature, so `agents/` only goes to `~/.claude/agents`. On another agent runtime the skills still work on their own — you just lose the context isolation.

Once installed, just tell your agent what you want in plain language — e.g. *"kick off this project"*, *"implement issue #12"*, *"let's have a project meeting"*.
