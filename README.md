# skillz-lattice - An agentic coding workflow

A set of AI coding agent skills that implement a **spec-driven development** workflow: turn a rough idea into a confirmed spec, break it into issues, implement and review each one, and keep a running log of decisions and knowledge — all with you in the loop for every decision that matters. Written for [Claude Code](https://claude.com/claude-code) but not specific to it — any agent that supports skills can use them.

## The workflow

```
kick-off ──────────────► create-spec-issues ──────────────► implement-issue
(idea → SPEC.md)         (SPEC.md → GitHub issues)          (issue → PR)
                                                                   │
                                                                   ▼
project-meeting  ◄────────────  merge-pr  ◄──────────  verify-implementation
(triage findings,               (approved PR             (PR → review comments)
 plan next steps)                → develop)                    │
        ▲                                                       ▼
        │                                              check-pr-comments
        └──────────── new issues, spec changes ◄────── (feedback → fixes)
```

1. **kick-off** — interviews you about a new project or milestone, one question at a time, and writes a confirmed spec.
2. **create-spec-issues** — reads the newest spec and breaks it into one GitHub issue per unit of work (or a markdown ticket if GitHub isn't available).
3. **implement-issue** — implements a single issue end to end: branch, code, tests, and a pull request.
4. **verify-implementation** — independently reviews the resulting PR for bugs, security issues, and unmet acceptance criteria, and comments on it. Ships with a matching subagent (`agents/verify-implementation.md`), so the review runs in its own context window: the diff and the file reads stay out of your main conversation, and only a summary comes back.
5. **check-pr-comments** — triages review feedback on an already-implemented issue and fixes what's valid.
6. **merge-pr** — merges an approved PR back into `develop` and cleans up the branch.
7. **project-meeting** — a recurring status meeting: reviews open findings, reports on finished work, and plans what's next — always with your confirmation before anything is decided.
8. **generate-branding** — standalone, on demand: produces or refreshes a brand identity guide and visual assets in `.project/Branding/`. Independent of the loop above — run it whenever you want branding created or updated.

## The `.project/` directory

Skills read and write project state here (created automatically on first use):

| Folder | Purpose |
|---|---|
| `SPEC.md` | The original, confirmed project spec |
| `Tickets/` | Milestone specs and markdown-fallback issue tickets |
| `Reports/` | Short completion reports, one per finished issue |
| `Inbox/` | Findings surfaced during implementation, awaiting discussion |
| `Archive/` | Resolved findings and past meeting records |
| `Knowledge/` | Durable learnings, organized by topic |
| `Branding/BRAND.md` | Brand identity guide: palette, typography, voice & tone |
| `Branding/Assets/` | Generated logo, icon, and marketing assets (or creative briefs) |

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

Existing symlinks that point somewhere else are skipped unless you pass `--force`, and real files or directories are never overwritten. If you'd rather not symlink, copy the `skills/<name>/` folders and `agents/<name>.md` files into your agent's skills and subagent directories by hand.

Subagents are a Claude Code feature, so `agents/` only goes to `~/.claude/agents`. On another agent runtime the skills still work on their own — you just lose the context isolation.

Once installed, just tell your agent what you want in plain language — e.g. *"kick off this project"*, *"implement issue #12"*, *"let's have a project meeting"*.
