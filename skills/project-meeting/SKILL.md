---
name: project-meeting
description: This skill should be used to run a recurring project status meeting. Trigger phrases include "let's have a project meeting", "run the status meeting", "meeting time", "review the inbox", "project standup", or whenever accumulated findings, reports, and knowledge need to be reviewed and turned into decisions.
---

# Project Meeting

Moderates a recurring project status meeting — does not touch code. Every decision is made with the user, one at a time — no action without explicit confirmation.

## 1. Determine what's new since the last meeting

- Find the most recent `.project/Archive/MEETING-<YYYY-MM-DD>.md` (newest by date in filename). Everything after its date is "since last meeting"; if none exists, this is the first meeting and everything counts.
- Gather: `.project/Reports/*` newer than that date, `.project/Knowledge/**` entries newer than that date, and every file currently in `.project/Inbox/`.

## 2. Report on completed work and new knowledge

- Summarize issues implemented since the last meeting, from `.project/Reports/`.
- Summarize new knowledge captured, from `.project/Knowledge/`.
- Informational only — no decisions needed here, just present it.

## 3. Spot-check Knowledge currency

- List `.project/Knowledge/**`. Skip entries recording a pure convention or decision — nothing there to go stale. For entries asserting a specific, checkable state ("X is unfixed", "Y isn't supported yet"), re-verify against the current code or issue tracker.
- Anything contradicted: treat it as a finding in Step 4, alongside Inbox findings — propose update, archive, or supersede, one at a time, same discipline.
- This is a full sweep, not scoped to "since last meeting" — staleness accumulates precisely in entries nobody has touched recently.
- Also spot-check the `Active` milestone spec (`Status:` lifecycle per `../_shared/conventions.md`, relative to this skill's directory): re-verify its checkable claims about the codebase the same way. Contradictions become Step 4 findings (outcome: spec amendment). If the milestone is actually finished but the spec isn't marked, propose setting `Status: Done`.

## 4. Triage findings, one at a time

- Process each file in `.project/Inbox/`, plus each stale Knowledge entry flagged in Step 3, individually: present it, propose an outcome, and wait for the user's decision before moving to the next finding.
  - Inbox findings: new issue, amendment to `.project/SPEC.md` or the active `.project/SPEC-milestone-*.md`, no action, or something else.
  - Stale Knowledge entries: update the entry, archive/delete it, or leave as-is.
- On confirmation, carry out exactly that outcome — create the issue using the same conventions as `create-spec-issues`, amend the relevant spec, edit or remove the Knowledge entry, or discard — then move any consumed Inbox file to `.project/Archive/`.
- Never batch findings or decide more than one at a time.

## 5. Plan next steps

- Discuss upcoming work, new ideas, or changes — raised by either party — one topic at a time, same discipline as Step 4.
- Any resulting action (new issue, spec change, milestone) requires explicit confirmation before being carried out.

## 6. Record the meeting

Write `.project/Archive/MEETING-<YYYY-MM-DD>.md`: date, each finding and its resolved outcome (including stale Knowledge entries corrected or removed), work completed, knowledge gained, and next steps agreed. This is the marker the next meeting's Step 1 reads from.

## 7. Commit and push

- `.project/` changes belong on the base branch (per conventions: `develop` if present, else the default). If a feature branch is checked out, say so and `git switch <base>` first — never discard, stash, or sweep in unrelated uncommitted changes; if switching is unsafe, stop and ask.
- Stage only `.project/` (moved Inbox files, spec amendments, the new meeting record) — never unrelated changes sitting in the working tree.
- Commit with a message summarizing the meeting (date, findings resolved, decisions made) per the base-branch rules in `../_shared/conventions.md` — the branch is usually protected, so the branch-and-PR fallback (branch `chore/project-meeting-<YYYY-MM-DD>`) applies if the push is rejected; report that PR instead of claiming the change landed on the base branch.

## 8. Suggest the next step

End by naming the next action that follows from the meeting's decisions — e.g. `implement-issue` for a newly created issue, `create-spec-issues` after a spec change, or nothing pending.
