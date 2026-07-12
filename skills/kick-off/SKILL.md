---
name: kick-off
description: This skill should be used when starting a brand new project (empty or near-empty project directory) or when kicking off a new milestone in an existing codebase. Trigger phrases include "kick off this project", "let's start this project", "kickoff", "new milestone", "spec this out", "interview me about this idea", or whenever the user has a rough idea or plan they want turned into a formal, mutually-confirmed spec before any code is written.
---

# Kick-off

Runs on an empty/near-empty project directory (new project) or to scope a new milestone in an existing codebase. Turns a rough idea into a confirmed spec — does not implement anything.

## 1. Set up project files

- Create if missing: `.project/Inbox/`, `.project/Archive/`, `.project/Tickets/`, `.project/Knowledge/`, `.project/Branding/Assets/`, `.project/Reports/`.
- Create if missing: root `CLAUDE.md`, copied verbatim from this skill's `references/CLAUDE.md.template`; and root `AGENTS.md` containing just `Read CLAUDE.md.`. Never overwrite either if it already exists.
- If a codebase exists, read the README, manifests, source layout, `.project/SPEC.md`, and `.project/Tickets/*` first. Anything discoverable this way is a **fact** — never ask the user for it.

## 2. Map the decision tree

Sketch the decision branches this plan touches — problem/goal, target users, scope (in/out), core workflows, data model, architecture/stack, integrations, non-functional requirements, milestone plan, risks — scoped to what's actually relevant, expanding into sub-branches as answers reveal dependencies.

## 3. Interview one question at a time

- One question per turn; wait for the answer before asking the next.
- Propose a recommended answer with a short rationale for every question.
- Ask only about **decisions**. Never ask about **facts** obtainable from the codebase — look those up instead.
- Resolve branches in dependency order — don't ask about something whose answer depends on an unresolved earlier decision.
- Keep going until every relevant branch is resolved, not just until "enough."

## 4. Confirm before writing

Summarize the full plan. Do not write anything until the user explicitly confirms it's correct and complete.

## 5. Write the spec

- New project: `.project/SPEC.md` — the idea, all decisions, all discovered facts.
- New milestone: `.project/Tickets/SPEC-<milestone-slug>.md` instead, leaving `.project/SPEC.md` untouched.
- Documentation only — do not implement the plan.
