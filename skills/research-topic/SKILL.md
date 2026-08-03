---
name: research-topic
description: This skill should be used to research a topic in depth against external sources and capture the result as a durable entry in `.project/Knowledge/`. Trigger phrases include "research <topic>", "look into <topic> for the project", "find out how <X> works", "gather knowledge about <X>", "what's the state of the art for <X>", or whenever a decision needs external knowledge the project doesn't have yet. User-invoked and on-demand — other skills may recommend it, but never run it on their own.
---

# Research Topic

Researches one topic against external sources and writes what was learned into `.project/Knowledge/<topic>/`. Does not touch code, issues, or specs.

The Knowledge consultation and governance rules, written-deliverable sizing, and the delegation rule are defined in `../_shared/conventions.md` (relative to this skill's directory).

## 1. Scope the research with the user

Research without a scope returns an encyclopedia. Before anything else, establish:

- **The decision it feeds** — what will this knowledge be used to decide or build? If the user hasn't said, ask.
- **Boundaries** — what's explicitly out of scope, and what depth is wanted (orientation vs. implementation-ready detail).
- **Subtopics** — break the topic into 1-5 independently researchable questions.

Ask one question at a time and propose a recommended answer for each. Skip anything the user has already specified.

## 2. Check what the project already knows

- `ls -R .project/Knowledge` (create `.project/Knowledge/` if absent). Pick the target topic directory: reuse an existing one whose name fits, create a new one only when nothing does.
- Read the entries in that directory plus any others whose names relate to the topic. Note both what's already established and when it was researched.
- Drop or narrow any subtopic already answered — research the gaps, not the basics. If everything in scope is already covered, say so and stop rather than producing a near-duplicate entry.

## 3. Confirm the brief

Present the final subtopic list, what's being skipped as already known, and the target path `.project/Knowledge/<topic>/<slug>.md`. Do not start researching until the user confirms.

## 4. Research each subtopic in a fresh context

Web research reads far more text than its conclusions are worth — keep it out of the main conversation.

- `agents/research-topic.md` installed: launch **one `research-topic` subagent per subtopic**, all in a single message so they run in parallel (`subagent_type: research-topic`, `run_in_background: false`). Give each one its subtopic, the decision it feeds, the boundaries, and what the project already knows so it doesn't re-derive it.
- Not installed: do the research directly, per the source discipline below.
- Already running as that subagent: research the assigned subtopic per the source discipline below, return the findings in full, and stop — Steps 5-7 belong to the caller.

**Source discipline** (applies wherever the research runs):

- Library, framework, SDK, or CLI documentation: query a documentation MCP server (e.g. Context7) if one is available before falling back to web search — it reflects current releases.
- Prefer primary sources — official docs, specs, RFCs, source repositories, papers — over blog posts and aggregators. Use a content-extraction tool if the environment has one; plain page fetches otherwise.
- Corroborate every load-bearing claim against a second independent source. A claim resting on one source is reported as such, not smoothed over.
- Record the publication or last-updated date of each source. Fast-moving topics go stale; an undated source is weaker evidence.
- Note disagreement between sources explicitly instead of picking a winner silently.

## 5. Write the Knowledge entry

One new file, `.project/Knowledge/<topic>/<slug>.md`, named for the specific question answered — not the broad topic. Never edit or overwrite an existing entry (governance per conventions).

Frontmatter marks it as researched rather than observed, so later readers weigh it accordingly:

```markdown
---
type: research
researched: <YYYY-MM-DD>   # from `date +%F`, never guessed
confidence: high | medium | low
---
```

`confidence` reflects source agreement and quality, not how sure the writing sounds. Body: the findings organized by subtopic, the trade-offs, a recommendation for the decision from Step 1, open questions that research couldn't settle, and a **Sources** section listing every source with its URL and date. Claims that rest on a single source or on disagreeing sources are marked inline.

If a prior entry in the topic covers adjacent ground, link it and state what this one adds — supersede, don't repeat.

## 6. Route contradictions to the Inbox

Research that contradicts an existing Knowledge entry does not correct it here. Write `.project/Inbox/findings-<slug>.md` naming both entries and the conflict; `project-meeting` reconciles them. Same for research that contradicts the current spec.

## 7. Report

State the entry's path, the recommendation in a sentence or two, the confidence and why, any open question left unanswered, and any Inbox finding written. Recommend `project-meeting` if a contradiction was filed.
