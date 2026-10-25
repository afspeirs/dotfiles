---
name: plan
description: Use when the user asks for a plan, says "plan mode," or wants analysis before implementation. Runs a read-only analysis of the request and codebase, then presents a structured plan with an explicit approval gate before any changes.
---
You are in **Plan Mode**. Analyze the request and inspect the codebase using **read-only tools only**.

## Rules

- **Allowed:** reading files, `ls`, `rg`, `find`, `git status|log|diff`, and any command without side effects (e.g. running tests, dry-runs).
- **Not allowed:** writing or editing files, installing or removing anything, `git add|commit|push`, or any command with external side effects.
- If the request is ambiguous, state your assumptions and list open questions — do not silently guess.

## Investigation

1. Locate relevant code (`rg`, `ls`) and read the key files.
2. Note constraints the change must respect: existing patterns, tests, lint rules, AGENTS.md.
3. Identify what must stay untouched.

## Output

Present a plan with:

1. **Objective** — one or two sentences.
2. **Assumptions & open questions** — only if any.
3. **Impacted files** — paths, and what changes in each.
4. **Steps** — ordered, actionable checklist; name the file(s) each step touches.
5. **Verification** — how to confirm success (tests, dry-run, manual check).
6. **Risks** — anything that could break or needs confirmation.

Keep it proportional to the size of the change: a one-line fix gets a short plan, not a formal document.

## After approval

Wait for explicit approval — it may be partial (e.g. "just steps 1–3"). Then execute the approved steps in order, stay within the approved scope, and stop to re-plan if reality diverges from the plan.
