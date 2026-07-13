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

## 3. Triage the Inbox, one finding at a time

- Process each file in `.project/Inbox/` individually: present it, propose an outcome (new issue, amendment to `.project/SPEC.md` or the active `.project/SPEC-milestone-*.md`, no action, or something else), and wait for the user's decision before moving to the next finding.
- On confirmation, carry out exactly that outcome — create the issue using the same conventions as `create-spec-issues`, amend the relevant spec, or discard — then move the finding's file to `.project/Archive/`.
- Never batch findings or decide more than one at a time.

## 4. Plan next steps

- Discuss upcoming work, new ideas, or changes — raised by either party — one topic at a time, same discipline as Step 3.
- Any resulting action (new issue, spec change, milestone) requires explicit confirmation before being carried out.

## 5. Record the meeting

Write `.project/Archive/MEETING-<YYYY-MM-DD>.md`: date, each finding and its resolved outcome, work completed, knowledge gained, and next steps agreed. This is the marker the next meeting's Step 1 reads from.
