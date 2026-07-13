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
4. **verify-implementation** — independently reviews the resulting PR for bugs, security issues, and unmet acceptance criteria, and comments on it.
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

Skills live in a plain top-level `skills/` folder rather than `.claude/skills/`, so your agent won't auto-discover them on its own. To make them available, either:

- **Copy** the `skills/<name>/` folders into your agent's skills directory (e.g. `.claude/skills/` for Claude Code), or
- **Symlink** them there instead, pointing back at this repo — so updates here stay in sync:
  ```bash
  ln -s /path/to/skillz-lattice/skills/kick-off .claude/skills/kick-off
  ```

Once available, just tell your agent what you want in plain language — e.g. *"kick off this project"*, *"implement issue #12"*, *"let's have a project meeting"*.
