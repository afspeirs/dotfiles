---
name: code-audit
description: Read-only audit of a whole codebase that produces a prioritized, phased action plan (AUDIT.md). Use when asked to audit, review, or health-check a project, hunt for tech debt, doc drift, dead weight, accessibility gaps, or missing tests, and to plan a refactor or cleanup before touching code.
---
You are running a **code audit**: read-only inspection of the whole project, then a
prioritized findings table and a phased action plan. You are not fixing anything.

## Mode

- **Allowed:** `ls`, `rg`, `find`, `wc -l`, `du -h`, `git status|log|diff|show`, reading
  files, and running checks that already exist in the project (`test`, `lint`,
  `typecheck`, `build`, dependency audit).
- **Not allowed:** editing or deleting project files, installs (`npm ci`, `pip install`,
  `cargo fetch`), formatters or fixers (`--fix`, `--write`), snapshot-writing test runs,
  and any git write (`add|commit|push|checkout`).
- **The one write is the report.** Present findings in chat first; write `AUDIT.md` at the
  repo root (or the path the user names) only when asked.
- Findings are **not** approval to implement. Hand implementation back to the `plan` skill.

## Step 1 — Baseline

Detect the toolchain from manifests and config (`package.json`, `pyproject.toml`,
`requirements.txt`, `Cargo.toml`, `go.mod`, `Makefile`, lint/config dotfiles). Ask rather
than guess when a check is ambiguous.

Run every check the project already defines. Record the results verbatim in a table with
**real counts** — tests passed, files, error count, vulnerabilities.

- Never report a check as passing without running it in this session.
- If a check is missing or fails to run, record that as a finding *and* say so in the
  baseline table. Stale claims about checks are the most common form of doc drift.

## Step 2 — Inventory

Map the shape of the project before judging it:

- Entry points, routes, and where state enters and leaves.
- Largest files (`wc -l`), single giant modules, inline page/component bodies inside routers.
- Config files, CI (`.github/workflows`, `.gitlab-ci.yml`, …), test files and coverage config.
- Docs: `README.md`, `AGENTS.md`/`CONTRIBUTING.md`, progress/journal files, inline TODOs.
- Assets and build output sizes (`du -h public src dist`).
- `git log --oneline -20` for recent intent, and any doc the repo treats as a contract.

## Step 3 — Walk by layer

For each layer, ask the questions; cite what you actually read.

1. **State & data flow** — single shared error/UI state reused by unrelated screens,
   duplicated hydration, state that is written but never read, magic strings compared
   across module boundaries, edits lost on unmount/navigation.
2. **Domain rules** — the invariants the docs promise; find the code that enforces each and
   the call path that can bypass it; domain logic living in components (untested).
3. **Storage & persistence** — schema/version handling, unique indexes and constraints,
   cascades and orphans, the documented "invalid state can't exist" claims, migration and
   rollback paths.
4. **UI & structure** — repeated blocks that should be a component or hook, hand-rolled
   platform behavior that native elements provide for free (focus trap, Escape, dialog),
   affordances that contradict state (a button that can only fail).
5. **Styling & accessibility** — orphaned or oversized assets, `aria-label` on elements
   with no role, `title` used where `aria-label` is required, viewport units that fight
   mobile browser chrome, cascade order that is load-bearing but unguarded by lint.
6. **Performance & dead weight** — unused exports/files/assets, oversized images, work on
   every render or page load.
7. **Docs as contract** — open every path named in `AGENTS.md`/README/progress files and
   confirm it exists; re-count every number the docs claim. Confirm each documented rule
   against the code that supposedly implements it.
8. **Tooling, CI, tests** — what runs on push, whether typecheck has its own entry point,
   which invariants have zero coverage, how permissive the lint config actually is.

## Step 4 — Classify

Use these buckets; renumber findings continuously across them.

| Pri | Meaning |
| --- | --- |
| P1 | Bugs, or behavior that contradicts the documented contract |
| P2 | Architecture and maintainability drag |
| P3 | Documentation drift (misleads the next session) |
| P4 | Accessibility |
| P5 | Performance and dead weight |
| P6 | Tooling, CI, tests |

**Every finding needs:** a `path:line` (or `path` plus the symbol) that you opened in this
session, one line of evidence, one line of consequence. No location, no finding — write it
as an open question instead. Prefer measured numbers (`wc -l`, `du -h`, test counts) over
adjectives.

## Step 5 — Phased plan

Group the findings into independently shippable phases, cheapest and riskiest-first:

1. Quick fixes — no new dependencies, low risk.
2. Consistency and durability — usually needs a product decision first.
3. Tests and CI.
4. Structural refactors — own branch, behavior identical by design.
5. Docs and polish.

Write each phase as `- [ ]` checkboxes numbered `N.M`, cross-referencing finding numbers,
naming the file(s) each step touches. End every phase with a **Verification** block the next
session can paste. Add:

- **Open questions to settle** before any phase that depends on a product decision —
  ask, do not decide silently.
- **Risks** — data with no rollback path, large diffs, anything that can invalidate
  existing user data or links.
- **Recommended skills to write** — the repeated ceremonies the audit exposed, ranked, with
  the findings each one would have prevented.

## Output

Follow `references/report-template.md`. Header line carries the audit date, branch, and
commit, and states that it is a working document with boxes to tick as items land.

When a planned step lands differently than written, record the deviation inline in that
checkbox rather than editing the plan to look correct. Record the verification run's actual
counts (before → after) when a phase is confirmed.
